using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public sealed partial class DependencyManager
    {
        private void RestoreNugetPackages(List<FileInfo> allNonBinaryFiles, IEnumerable<string> allProjects, IEnumerable<string> allSolutions, HashSet<string> dllPaths)
        {
            try
            {
                var checkNugetFeedResponsiveness = EnvironmentVariables.GetBoolean(EnvironmentVariableNames.CheckNugetFeedResponsiveness);
                if (checkNugetFeedResponsiveness && !CheckFeeds(allNonBinaryFiles))
                {
                    DownloadMissingPackages(allNonBinaryFiles, dllPaths, withNugetConfig: false);
                    return;
                }

                using (var nuget = new NugetPackages(sourceDir.FullName, legacyPackageDirectory, logger))
                {
                    var count = nuget.InstallPackages();

                    if (nuget.PackageCount > 0)
                    {
                        CompilationInfos.Add(("packages.config files", nuget.PackageCount.ToString()));
                        CompilationInfos.Add(("Successfully restored packages.config files", count.ToString()));
                    }
                }

                var nugetPackageDlls = legacyPackageDirectory.DirInfo.GetFiles("*.dll", new EnumerationOptions { RecurseSubdirectories = true });
                var nugetPackageDllPaths = nugetPackageDlls.Select(f => f.FullName).ToHashSet();
                var excludedPaths = nugetPackageDllPaths
                    .Where(path => IsPathInSubfolder(path, legacyPackageDirectory.DirInfo.FullName, "tools"))
                    .ToList();

                if (nugetPackageDllPaths.Count > 0)
                {
                    logger.LogInfo($"Restored {nugetPackageDllPaths.Count} Nuget DLLs.");
                }
                if (excludedPaths.Count > 0)
                {
                    logger.LogInfo($"Excluding {excludedPaths.Count} Nuget DLLs.");
                }

                foreach (var excludedPath in excludedPaths)
                {
                    logger.LogInfo($"Excluded Nuget DLL: {excludedPath}");
                }

                nugetPackageDllPaths.ExceptWith(excludedPaths);
                dllPaths.UnionWith(nugetPackageDllPaths);
            }
            catch (Exception exc)
            {
                logger.LogError($"Failed to restore Nuget packages with nuget.exe: {exc.Message}");
            }

            var restoredProjects = RestoreSolutions(allSolutions, out var assets1);
            var projects = allProjects.Except(restoredProjects);
            RestoreProjects(projects, out var assets2);

            var dependencies = Assets.GetCompilationDependencies(logger, assets1.Union(assets2));

            var paths = dependencies
                .Paths
                .Select(d => Path.Combine(packageDirectory.DirInfo.FullName, d))
                .ToList();
            dllPaths.UnionWith(paths);

            LogAllUnusedPackages(dependencies);
            DownloadMissingPackages(allNonBinaryFiles, dllPaths);
        }

        /// <summary>
        /// Executes `dotnet restore` on all solution files in solutions.
        /// As opposed to RestoreProjects this is not run in parallel using PLINQ
        /// as `dotnet restore` on a solution already uses multiple threads for restoring
        /// the projects (this can be disabled with the `--disable-parallel` flag).
        /// Populates assets with the relative paths to the assets files generated by the restore.
        /// Returns a list of projects that are up to date with respect to restore.
        /// </summary>
        /// <param name="solutions">A list of paths to solution files.</param>
        private IEnumerable<string> RestoreSolutions(IEnumerable<string> solutions, out IEnumerable<string> assets)
        {
            var successCount = 0;
            var nugetSourceFailures = 0;
            var assetFiles = new List<string>();
            var projects = solutions.SelectMany(solution =>
                {
                    logger.LogInfo($"Restoring solution {solution}...");
                    var res = dotnet.Restore(new(solution, packageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: true));
                    if (res.Success)
                    {
                        successCount++;
                    }
                    if (res.HasNugetPackageSourceError)
                    {
                        nugetSourceFailures++;
                    }
                    assetFiles.AddRange(res.AssetsFilePaths);
                    return res.RestoredProjects;
                }).ToList();
            assets = assetFiles;
            CompilationInfos.Add(("Successfully restored solution files", successCount.ToString()));
            CompilationInfos.Add(("Failed solution restore with package source error", nugetSourceFailures.ToString()));
            CompilationInfos.Add(("Restored projects through solution files", projects.Count.ToString()));
            return projects;
        }

        /// <summary>
        /// Executes `dotnet restore` on all projects in projects.
        /// This is done in parallel for performance reasons.
        /// Populates assets with the relative paths to the assets files generated by the restore.
        /// </summary>
        /// <param name="projects">A list of paths to project files.</param>
        private void RestoreProjects(IEnumerable<string> projects, out IEnumerable<string> assets)
        {
            var successCount = 0;
            var nugetSourceFailures = 0;
            var assetFiles = new List<string>();
            var sync = new object();
            Parallel.ForEach(projects, new ParallelOptions { MaxDegreeOfParallelism = threads }, project =>
            {
                logger.LogInfo($"Restoring project {project}...");
                var res = dotnet.Restore(new(project, packageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: true));
                lock (sync)
                {
                    if (res.Success)
                    {
                        successCount++;
                    }
                    if (res.HasNugetPackageSourceError)
                    {
                        nugetSourceFailures++;
                    }
                    assetFiles.AddRange(res.AssetsFilePaths);
                }
            });
            assets = assetFiles;
            CompilationInfos.Add(("Successfully restored project files", successCount.ToString()));
            CompilationInfos.Add(("Failed project restore with package source error", nugetSourceFailures.ToString()));
        }

        private void DownloadMissingPackages(List<FileInfo> allFiles, ISet<string> dllPaths, bool withNugetConfig = true)
        {
            var alreadyDownloadedPackages = GetRestoredPackageDirectoryNames(packageDirectory.DirInfo);
            var alreadyDownloadedLegacyPackages = GetRestoredLegacyPackageNames();

            var notYetDownloadedPackages = new HashSet<PackageReference>(fileContent.AllPackages);
            foreach (var alreadyDownloadedPackage in alreadyDownloadedPackages)
            {
                notYetDownloadedPackages.Remove(new(alreadyDownloadedPackage, PackageReferenceSource.SdkCsProj));
            }
            foreach (var alreadyDownloadedLegacyPackage in alreadyDownloadedLegacyPackages)
            {
                notYetDownloadedPackages.Remove(new(alreadyDownloadedLegacyPackage, PackageReferenceSource.PackagesConfig));
            }

            if (notYetDownloadedPackages.Count == 0)
            {
                return;
            }

            var multipleVersions = notYetDownloadedPackages
                .GroupBy(p => p.Name)
                .Where(g => g.Count() > 1)
                .Select(g => g.Key)
                .ToList();

            foreach (var package in multipleVersions)
            {
                logger.LogWarning($"Found multiple not yet restored packages with name '{package}'.");
                notYetDownloadedPackages.Remove(new(package, PackageReferenceSource.PackagesConfig));
            }

            logger.LogInfo($"Found {notYetDownloadedPackages.Count} packages that are not yet restored");
            var nugetConfig = withNugetConfig
                ? GetNugetConfig(allFiles)
                : null;

            CompilationInfos.Add(("Fallback nuget restore", notYetDownloadedPackages.Count.ToString()));

            var successCount = 0;
            var sync = new object();

            Parallel.ForEach(notYetDownloadedPackages, new ParallelOptions { MaxDegreeOfParallelism = threads }, package =>
            {
                var success = TryRestorePackageManually(package.Name, nugetConfig, package.PackageReferenceSource);
                if (!success)
                {
                    return;
                }

                lock (sync)
                {
                    successCount++;
                }
            });

            CompilationInfos.Add(("Successfully ran fallback nuget restore", successCount.ToString()));

            dllPaths.Add(missingPackageDirectory.DirInfo.FullName);
        }

        private string[] GetAllNugetConfigs(List<FileInfo> allFiles) => allFiles.SelectFileNamesByName("nuget.config").ToArray();

        private string? GetNugetConfig(List<FileInfo> allFiles)
        {
            var nugetConfigs = GetAllNugetConfigs(allFiles);
            string? nugetConfig;
            if (nugetConfigs.Length > 1)
            {
                logger.LogInfo($"Found multiple nuget.config files: {string.Join(", ", nugetConfigs)}.");
                nugetConfig = allFiles
                    .SelectRootFiles(sourceDir)
                    .SelectFileNamesByName("nuget.config")
                    .FirstOrDefault();
                if (nugetConfig == null)
                {
                    logger.LogInfo("Could not find a top-level nuget.config file.");
                }
            }
            else
            {
                nugetConfig = nugetConfigs.FirstOrDefault();
            }

            if (nugetConfig != null)
            {
                logger.LogInfo($"Using nuget.config file {nugetConfig}.");
            }

            return nugetConfig;
        }

        private void LogAllUnusedPackages(DependencyContainer dependencies)
        {
            var allPackageDirectories = GetAllPackageDirectories();

            logger.LogInfo($"Restored {allPackageDirectories.Count} packages");
            logger.LogInfo($"Found {dependencies.Packages.Count} packages in project.assets.json files");

            allPackageDirectories
                .Where(package => !dependencies.Packages.Contains(package))
                .Order()
                .ForEach(package => logger.LogInfo($"Unused package: {package}"));
        }


        private ICollection<string> GetAllPackageDirectories()
        {
            return new DirectoryInfo(packageDirectory.DirInfo.FullName)
                .EnumerateDirectories("*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .Select(d => d.Name)
                .ToList();
        }

        private static bool IsPathInSubfolder(string path, string rootFolder, string subFolder)
        {
            return path.IndexOf(
                $"{Path.DirectorySeparatorChar}{subFolder}{Path.DirectorySeparatorChar}",
                rootFolder.Length,
                StringComparison.InvariantCultureIgnoreCase) >= 0;
        }

        private IEnumerable<string> GetRestoredLegacyPackageNames()
        {
            var oldPackageDirectories = GetRestoredPackageDirectoryNames(legacyPackageDirectory.DirInfo);
            foreach (var oldPackageDirectory in oldPackageDirectories)
            {
                // nuget install restores packages to 'packagename.version' folders (dotnet restore to 'packagename/version' folders)
                // typical folder names look like:
                //   newtonsoft.json.13.0.3
                // there are more complex ones too, such as:
                //   runtime.tizen.4.0.0-armel.Microsoft.NETCore.DotNetHostResolver.2.0.0-preview2-25407-01

                var match = LegacyNugetPackage().Match(oldPackageDirectory);
                if (!match.Success)
                {
                    logger.LogWarning($"Package directory '{oldPackageDirectory}' doesn't match the expected pattern.");
                    continue;
                }

                yield return match.Groups[1].Value.ToLowerInvariant();
            }
        }

        private static IEnumerable<string> GetRestoredPackageDirectoryNames(DirectoryInfo root)
        {
            return Directory.GetDirectories(root.FullName)
                .Select(d => Path.GetFileName(d).ToLowerInvariant());
        }

        private bool TryRestorePackageManually(string package, string? nugetConfig, PackageReferenceSource packageReferenceSource = PackageReferenceSource.SdkCsProj)
        {
            logger.LogInfo($"Restoring package {package}...");
            using var tempDir = new TemporaryDirectory(ComputeTempDirectory(package, "missingpackages_workingdir"));
            var success = dotnet.New(tempDir.DirInfo.FullName);
            if (!success)
            {
                return false;
            }

            if (packageReferenceSource == PackageReferenceSource.PackagesConfig)
            {
                TryChangeTargetFrameworkMoniker(tempDir.DirInfo);
            }

            success = dotnet.AddPackage(tempDir.DirInfo.FullName, package);
            if (!success)
            {
                return false;
            }

            var res = dotnet.Restore(new(tempDir.DirInfo.FullName, missingPackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: false, PathToNugetConfig: nugetConfig));
            if (!res.Success)
            {
                if (res.HasNugetPackageSourceError && nugetConfig is not null)
                {
                    // Restore could not be completed because the listed source is unavailable. Try without the nuget.config:
                    res = dotnet.Restore(new(tempDir.DirInfo.FullName, missingPackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: false, PathToNugetConfig: null, ForceReevaluation: true));
                }

                // TODO: the restore might fail, we could retry with
                // - a prerelease (*-* instead of *) version of the package,
                // - a different target framework moniker.

                if (!res.Success)
                {
                    logger.LogInfo($"Failed to restore nuget package {package}");
                    return false;
                }
            }

            return true;
        }

        private void TryChangeTargetFrameworkMoniker(DirectoryInfo tempDir)
        {
            try
            {
                logger.LogInfo($"Changing the target framework moniker in {tempDir.FullName}...");

                var csprojs = tempDir.GetFiles("*.csproj", new EnumerationOptions { RecurseSubdirectories = false, MatchCasing = MatchCasing.CaseInsensitive });
                if (csprojs.Length != 1)
                {
                    logger.LogError($"Could not find the .csproj file in {tempDir.FullName}, count = {csprojs.Length}");
                    return;
                }

                var csproj = csprojs[0];
                var content = File.ReadAllText(csproj.FullName);
                var matches = TargetFramework().Matches(content);
                if (matches.Count == 0)
                {
                    logger.LogError($"Could not find target framework in {csproj.FullName}");
                }
                else
                {
                    content = TargetFramework().Replace(content, $"<TargetFramework>{FrameworkPackageNames.LatestNetFrameworkMoniker}</TargetFramework>", 1);
                    File.WriteAllText(csproj.FullName, content);
                }
            }
            catch (Exception exc)
            {
                logger.LogError($"Failed to update target framework in {tempDir.FullName}: {exc}");
            }
        }

        private static async Task ExecuteGetRequest(string address, HttpClient httpClient, CancellationToken cancellationToken)
        {
            using var stream = await httpClient.GetStreamAsync(address, cancellationToken);
            var buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = stream.Read(buffer, 0, buffer.Length)) > 0)
            {
                // do nothing
            }
        }

        private bool IsFeedReachable(string feed)
        {
            using HttpClient client = new();
            var timeoutSeconds = 1;
            var tryCount = 4;

            for (var i = 0; i < tryCount; i++)
            {
                using var cts = new CancellationTokenSource();
                cts.CancelAfter(timeoutSeconds * 1000);
                try
                {
                    ExecuteGetRequest(feed, client, cts.Token).GetAwaiter().GetResult();
                    return true;
                }
                catch (Exception exc)
                {
                    if (exc is TaskCanceledException tce &&
                        tce.CancellationToken == cts.Token &&
                        cts.Token.IsCancellationRequested)
                    {
                        logger.LogWarning($"Didn't receive answer from Nuget feed '{feed}' in {timeoutSeconds} seconds.");
                        timeoutSeconds *= 2;
                        continue;
                    }

                    // We're only interested in timeouts.
                    logger.LogWarning($"Querying Nuget feed '{feed}' failed: {exc}");
                    return true;
                }
            }

            logger.LogError($"Didn't receive answer from Nuget feed '{feed}'. Tried it {tryCount} times.");
            return false;
        }

        private bool CheckFeeds(List<FileInfo> allFiles)
        {
            logger.LogInfo("Checking Nuget feeds...");
            var feeds = GetAllFeeds(allFiles);

            var excludedFeeds = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ExcludedNugetFeedsFromResponsivenessCheck)
                ?.Split(Path.PathSeparator, StringSplitOptions.RemoveEmptyEntries)
                .ToHashSet() ?? [];

            if (excludedFeeds.Count > 0)
            {
                logger.LogInfo($"Excluded feeds from responsiveness check: {string.Join(", ", excludedFeeds)}");
            }

            var allFeedsReachable = feeds.All(feed => excludedFeeds.Contains(feed) || IsFeedReachable(feed));
            if (!allFeedsReachable)
            {
                diagnosticsWriter.AddEntry(new DiagnosticMessage(
                    Language.CSharp,
                    "buildless/unreachable-feed",
                    "Found unreachable Nuget feed in C# analysis with build-mode 'none'",
                    visibility: new DiagnosticMessage.TspVisibility(statusPage: true, cliSummaryTable: true, telemetry: true),
                    markdownMessage: "Found unreachable Nuget feed in C# analysis with build-mode 'none'. This may cause missing dependencies in the analysis.",
                    severity: DiagnosticMessage.TspSeverity.Warning
                ));
            }
            CompilationInfos.Add(("All Nuget feeds reachable", allFeedsReachable ? "1" : "0"));
            return allFeedsReachable;
        }

        private IEnumerable<string> GetFeeds(string nugetConfig)
        {
            logger.LogInfo($"Getting Nuget feeds from '{nugetConfig}'...");
            var results = dotnet.GetNugetFeeds(nugetConfig);
            var regex = EnabledNugetFeed();
            foreach (var result in results)
            {
                var match = regex.Match(result);
                if (!match.Success)
                {
                    logger.LogError($"Failed to parse feed from '{result}'");
                    continue;
                }

                var url = match.Groups[1].Value;
                if (!url.StartsWith("https://", StringComparison.InvariantCultureIgnoreCase) &&
                    !url.StartsWith("http://", StringComparison.InvariantCultureIgnoreCase))
                {
                    logger.LogInfo($"Skipping feed '{url}' as it is not a valid URL.");
                    continue;
                }

                yield return url;
            }
        }

        private HashSet<string> GetAllFeeds(List<FileInfo> allFiles)
        {
            var nugetConfigs = GetAllNugetConfigs(allFiles);
            var feeds = nugetConfigs
                .SelectMany(nf => GetFeeds(nf))
                .Where(str => !string.IsNullOrWhiteSpace(str))
                .ToHashSet();
            return feeds;
        }

        [GeneratedRegex(@"<TargetFramework>.*</TargetFramework>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex TargetFramework();

        [GeneratedRegex(@"^(.+)\.(\d+\.\d+\.\d+(-(.+))?)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex LegacyNugetPackage();

        [GeneratedRegex(@"^E (.*)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex EnabledNugetFeed();
    }
}
