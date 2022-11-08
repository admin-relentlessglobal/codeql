// generated by codegen/codegen.py
import codeql.swift.elements.CommentConstructor
import codeql.swift.elements.DbFileConstructor
import codeql.swift.elements.DbLocationConstructor
import codeql.swift.elements.UnspecifiedElementConstructor
import codeql.swift.elements.decl.AccessorDeclConstructor
import codeql.swift.elements.decl.AssociatedTypeDeclConstructor
import codeql.swift.elements.decl.ClassDeclConstructor
import codeql.swift.elements.decl.ConcreteFuncDeclConstructor
import codeql.swift.elements.decl.ConcreteVarDeclConstructor
import codeql.swift.elements.decl.ConstructorDeclConstructor
import codeql.swift.elements.decl.DestructorDeclConstructor
import codeql.swift.elements.decl.EnumCaseDeclConstructor
import codeql.swift.elements.decl.EnumDeclConstructor
import codeql.swift.elements.decl.EnumElementDeclConstructor
import codeql.swift.elements.decl.ExtensionDeclConstructor
import codeql.swift.elements.decl.GenericTypeParamDeclConstructor
import codeql.swift.elements.decl.IfConfigDeclConstructor
import codeql.swift.elements.decl.ImportDeclConstructor
import codeql.swift.elements.decl.InfixOperatorDeclConstructor
import codeql.swift.elements.decl.MissingMemberDeclConstructor
import codeql.swift.elements.decl.ModuleDeclConstructor
import codeql.swift.elements.decl.OpaqueTypeDeclConstructor
import codeql.swift.elements.decl.ParamDeclConstructor
import codeql.swift.elements.decl.PatternBindingDeclConstructor
import codeql.swift.elements.decl.PostfixOperatorDeclConstructor
import codeql.swift.elements.decl.PoundDiagnosticDeclConstructor
import codeql.swift.elements.decl.PrecedenceGroupDeclConstructor
import codeql.swift.elements.decl.PrefixOperatorDeclConstructor
import codeql.swift.elements.decl.ProtocolDeclConstructor
import codeql.swift.elements.decl.StructDeclConstructor
import codeql.swift.elements.decl.SubscriptDeclConstructor
import codeql.swift.elements.decl.TopLevelCodeDeclConstructor
import codeql.swift.elements.decl.TypeAliasDeclConstructor
import codeql.swift.elements.expr.AnyHashableErasureExprConstructor
import codeql.swift.elements.expr.AppliedPropertyWrapperExprConstructor
import codeql.swift.elements.expr.ArchetypeToSuperExprConstructor
import codeql.swift.elements.expr.ArgumentConstructor
import codeql.swift.elements.expr.ArrayExprConstructor
import codeql.swift.elements.expr.ArrayToPointerExprConstructor
import codeql.swift.elements.expr.ArrowExprConstructor
import codeql.swift.elements.expr.AssignExprConstructor
import codeql.swift.elements.expr.AutoClosureExprConstructor
import codeql.swift.elements.expr.AwaitExprConstructor
import codeql.swift.elements.expr.BinaryExprConstructor
import codeql.swift.elements.expr.BindOptionalExprConstructor
import codeql.swift.elements.expr.BooleanLiteralExprConstructor
import codeql.swift.elements.expr.BridgeFromObjCExprConstructor
import codeql.swift.elements.expr.BridgeToObjCExprConstructor
import codeql.swift.elements.expr.CallExprConstructor
import codeql.swift.elements.expr.CaptureListExprConstructor
import codeql.swift.elements.expr.ClassMetatypeToObjectExprConstructor
import codeql.swift.elements.expr.ClosureExprConstructor
import codeql.swift.elements.expr.CodeCompletionExprConstructor
import codeql.swift.elements.expr.CoerceExprConstructor
import codeql.swift.elements.expr.CollectionUpcastConversionExprConstructor
import codeql.swift.elements.expr.ConditionalBridgeFromObjCExprConstructor
import codeql.swift.elements.expr.ConditionalCheckedCastExprConstructor
import codeql.swift.elements.expr.ConstructorRefCallExprConstructor
import codeql.swift.elements.expr.CovariantFunctionConversionExprConstructor
import codeql.swift.elements.expr.CovariantReturnConversionExprConstructor
import codeql.swift.elements.expr.DeclRefExprConstructor
import codeql.swift.elements.expr.DefaultArgumentExprConstructor
import codeql.swift.elements.expr.DerivedToBaseExprConstructor
import codeql.swift.elements.expr.DestructureTupleExprConstructor
import codeql.swift.elements.expr.DictionaryExprConstructor
import codeql.swift.elements.expr.DifferentiableFunctionExprConstructor
import codeql.swift.elements.expr.DifferentiableFunctionExtractOriginalExprConstructor
import codeql.swift.elements.expr.DiscardAssignmentExprConstructor
import codeql.swift.elements.expr.DotSelfExprConstructor
import codeql.swift.elements.expr.DotSyntaxBaseIgnoredExprConstructor
import codeql.swift.elements.expr.DotSyntaxCallExprConstructor
import codeql.swift.elements.expr.DynamicMemberRefExprConstructor
import codeql.swift.elements.expr.DynamicSubscriptExprConstructor
import codeql.swift.elements.expr.DynamicTypeExprConstructor
import codeql.swift.elements.expr.EditorPlaceholderExprConstructor
import codeql.swift.elements.expr.EnumIsCaseExprConstructor
import codeql.swift.elements.expr.ErasureExprConstructor
import codeql.swift.elements.expr.ErrorExprConstructor
import codeql.swift.elements.expr.ExistentialMetatypeToObjectExprConstructor
import codeql.swift.elements.expr.FloatLiteralExprConstructor
import codeql.swift.elements.expr.ForceTryExprConstructor
import codeql.swift.elements.expr.ForceValueExprConstructor
import codeql.swift.elements.expr.ForcedCheckedCastExprConstructor
import codeql.swift.elements.expr.ForeignObjectConversionExprConstructor
import codeql.swift.elements.expr.FunctionConversionExprConstructor
import codeql.swift.elements.expr.IfExprConstructor
import codeql.swift.elements.expr.InOutExprConstructor
import codeql.swift.elements.expr.InOutToPointerExprConstructor
import codeql.swift.elements.expr.InjectIntoOptionalExprConstructor
import codeql.swift.elements.expr.IntegerLiteralExprConstructor
import codeql.swift.elements.expr.InterpolatedStringLiteralExprConstructor
import codeql.swift.elements.expr.IsExprConstructor
import codeql.swift.elements.expr.KeyPathApplicationExprConstructor
import codeql.swift.elements.expr.KeyPathDotExprConstructor
import codeql.swift.elements.expr.KeyPathExprConstructor
import codeql.swift.elements.expr.LazyInitializerExprConstructor
import codeql.swift.elements.expr.LinearFunctionExprConstructor
import codeql.swift.elements.expr.LinearFunctionExtractOriginalExprConstructor
import codeql.swift.elements.expr.LinearToDifferentiableFunctionExprConstructor
import codeql.swift.elements.expr.LoadExprConstructor
import codeql.swift.elements.expr.MagicIdentifierLiteralExprConstructor
import codeql.swift.elements.expr.MakeTemporarilyEscapableExprConstructor
import codeql.swift.elements.expr.MemberRefExprConstructor
import codeql.swift.elements.expr.MetatypeConversionExprConstructor
import codeql.swift.elements.expr.MethodRefExprConstructor
import codeql.swift.elements.expr.NilLiteralExprConstructor
import codeql.swift.elements.expr.ObjCSelectorExprConstructor
import codeql.swift.elements.expr.ObjectLiteralExprConstructor
import codeql.swift.elements.expr.OneWayExprConstructor
import codeql.swift.elements.expr.OpaqueValueExprConstructor
import codeql.swift.elements.expr.OpenExistentialExprConstructor
import codeql.swift.elements.expr.OptionalEvaluationExprConstructor
import codeql.swift.elements.expr.OptionalTryExprConstructor
import codeql.swift.elements.expr.OtherConstructorDeclRefExprConstructor
import codeql.swift.elements.expr.OverloadedDeclRefExprConstructor
import codeql.swift.elements.expr.PackExprConstructor
import codeql.swift.elements.expr.ParenExprConstructor
import codeql.swift.elements.expr.PointerToPointerExprConstructor
import codeql.swift.elements.expr.PostfixUnaryExprConstructor
import codeql.swift.elements.expr.PrefixUnaryExprConstructor
import codeql.swift.elements.expr.PropertyWrapperValuePlaceholderExprConstructor
import codeql.swift.elements.expr.ProtocolMetatypeToObjectExprConstructor
import codeql.swift.elements.expr.RebindSelfInConstructorExprConstructor
import codeql.swift.elements.expr.RegexLiteralExprConstructor
import codeql.swift.elements.expr.ReifyPackExprConstructor
import codeql.swift.elements.expr.SequenceExprConstructor
import codeql.swift.elements.expr.StringLiteralExprConstructor
import codeql.swift.elements.expr.StringToPointerExprConstructor
import codeql.swift.elements.expr.SubscriptExprConstructor
import codeql.swift.elements.expr.SuperRefExprConstructor
import codeql.swift.elements.expr.TapExprConstructor
import codeql.swift.elements.expr.TryExprConstructor
import codeql.swift.elements.expr.TupleElementExprConstructor
import codeql.swift.elements.expr.TupleExprConstructor
import codeql.swift.elements.expr.TypeExprConstructor
import codeql.swift.elements.expr.UnderlyingToOpaqueExprConstructor
import codeql.swift.elements.expr.UnevaluatedInstanceExprConstructor
import codeql.swift.elements.expr.UnresolvedDeclRefExprConstructor
import codeql.swift.elements.expr.UnresolvedDotExprConstructor
import codeql.swift.elements.expr.UnresolvedMemberChainResultExprConstructor
import codeql.swift.elements.expr.UnresolvedMemberExprConstructor
import codeql.swift.elements.expr.UnresolvedPatternExprConstructor
import codeql.swift.elements.expr.UnresolvedSpecializeExprConstructor
import codeql.swift.elements.expr.UnresolvedTypeConversionExprConstructor
import codeql.swift.elements.expr.VarargExpansionExprConstructor
import codeql.swift.elements.pattern.AnyPatternConstructor
import codeql.swift.elements.pattern.BindingPatternConstructor
import codeql.swift.elements.pattern.BoolPatternConstructor
import codeql.swift.elements.pattern.EnumElementPatternConstructor
import codeql.swift.elements.pattern.ExprPatternConstructor
import codeql.swift.elements.pattern.IsPatternConstructor
import codeql.swift.elements.pattern.NamedPatternConstructor
import codeql.swift.elements.pattern.OptionalSomePatternConstructor
import codeql.swift.elements.pattern.ParenPatternConstructor
import codeql.swift.elements.pattern.TuplePatternConstructor
import codeql.swift.elements.pattern.TypedPatternConstructor
import codeql.swift.elements.stmt.BraceStmtConstructor
import codeql.swift.elements.stmt.BreakStmtConstructor
import codeql.swift.elements.stmt.CaseLabelItemConstructor
import codeql.swift.elements.stmt.CaseStmtConstructor
import codeql.swift.elements.stmt.ConditionElementConstructor
import codeql.swift.elements.stmt.ContinueStmtConstructor
import codeql.swift.elements.stmt.DeferStmtConstructor
import codeql.swift.elements.stmt.DoCatchStmtConstructor
import codeql.swift.elements.stmt.DoStmtConstructor
import codeql.swift.elements.stmt.FailStmtConstructor
import codeql.swift.elements.stmt.FallthroughStmtConstructor
import codeql.swift.elements.stmt.ForEachStmtConstructor
import codeql.swift.elements.stmt.GuardStmtConstructor
import codeql.swift.elements.stmt.IfStmtConstructor
import codeql.swift.elements.stmt.PoundAssertStmtConstructor
import codeql.swift.elements.stmt.RepeatWhileStmtConstructor
import codeql.swift.elements.stmt.ReturnStmtConstructor
import codeql.swift.elements.stmt.StmtConditionConstructor
import codeql.swift.elements.stmt.SwitchStmtConstructor
import codeql.swift.elements.stmt.ThrowStmtConstructor
import codeql.swift.elements.stmt.WhileStmtConstructor
import codeql.swift.elements.stmt.YieldStmtConstructor
import codeql.swift.elements.type.ArraySliceTypeConstructor
import codeql.swift.elements.type.BoundGenericClassTypeConstructor
import codeql.swift.elements.type.BoundGenericEnumTypeConstructor
import codeql.swift.elements.type.BoundGenericStructTypeConstructor
import codeql.swift.elements.type.BuiltinBridgeObjectTypeConstructor
import codeql.swift.elements.type.BuiltinDefaultActorStorageTypeConstructor
import codeql.swift.elements.type.BuiltinExecutorTypeConstructor
import codeql.swift.elements.type.BuiltinFloatTypeConstructor
import codeql.swift.elements.type.BuiltinIntegerLiteralTypeConstructor
import codeql.swift.elements.type.BuiltinIntegerTypeConstructor
import codeql.swift.elements.type.BuiltinJobTypeConstructor
import codeql.swift.elements.type.BuiltinNativeObjectTypeConstructor
import codeql.swift.elements.type.BuiltinRawPointerTypeConstructor
import codeql.swift.elements.type.BuiltinRawUnsafeContinuationTypeConstructor
import codeql.swift.elements.type.BuiltinUnsafeValueBufferTypeConstructor
import codeql.swift.elements.type.BuiltinVectorTypeConstructor
import codeql.swift.elements.type.ClassTypeConstructor
import codeql.swift.elements.type.DependentMemberTypeConstructor
import codeql.swift.elements.type.DictionaryTypeConstructor
import codeql.swift.elements.type.DynamicSelfTypeConstructor
import codeql.swift.elements.type.EnumTypeConstructor
import codeql.swift.elements.type.ErrorTypeConstructor
import codeql.swift.elements.type.ExistentialMetatypeTypeConstructor
import codeql.swift.elements.type.ExistentialTypeConstructor
import codeql.swift.elements.type.FunctionTypeConstructor
import codeql.swift.elements.type.GenericFunctionTypeConstructor
import codeql.swift.elements.type.GenericTypeParamTypeConstructor
import codeql.swift.elements.type.InOutTypeConstructor
import codeql.swift.elements.type.LValueTypeConstructor
import codeql.swift.elements.type.MetatypeTypeConstructor
import codeql.swift.elements.type.ModuleTypeConstructor
import codeql.swift.elements.type.OpaqueTypeArchetypeTypeConstructor
import codeql.swift.elements.type.OpenedArchetypeTypeConstructor
import codeql.swift.elements.type.OptionalTypeConstructor
import codeql.swift.elements.type.PackExpansionTypeConstructor
import codeql.swift.elements.type.PackTypeConstructor
import codeql.swift.elements.type.ParameterizedProtocolTypeConstructor
import codeql.swift.elements.type.ParenTypeConstructor
import codeql.swift.elements.type.PlaceholderTypeConstructor
import codeql.swift.elements.type.PrimaryArchetypeTypeConstructor
import codeql.swift.elements.type.ProtocolCompositionTypeConstructor
import codeql.swift.elements.type.ProtocolTypeConstructor
import codeql.swift.elements.type.SequenceArchetypeTypeConstructor
import codeql.swift.elements.type.SilBlockStorageTypeConstructor
import codeql.swift.elements.type.SilBoxTypeConstructor
import codeql.swift.elements.type.SilFunctionTypeConstructor
import codeql.swift.elements.type.SilTokenTypeConstructor
import codeql.swift.elements.type.StructTypeConstructor
import codeql.swift.elements.type.TupleTypeConstructor
import codeql.swift.elements.type.TypeAliasTypeConstructor
import codeql.swift.elements.type.TypeReprConstructor
import codeql.swift.elements.type.TypeVariableTypeConstructor
import codeql.swift.elements.type.UnboundGenericTypeConstructor
import codeql.swift.elements.type.UnmanagedStorageTypeConstructor
import codeql.swift.elements.type.UnownedStorageTypeConstructor
import codeql.swift.elements.type.UnresolvedTypeConstructor
import codeql.swift.elements.type.VariadicSequenceTypeConstructor
import codeql.swift.elements.type.WeakStorageTypeConstructor
