// generated by codegen/codegen.py
/**
 * This module provides the generated definition of `ForceTryExpr`.
 * INTERNAL: Do not import directly.
 */

private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.AnyTryExpr

module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::ForceTryExpr` class directly.
   * Use the subclass `ForceTryExpr`, where the following predicates are available.
   */
  class ForceTryExpr extends Synth::TForceTryExpr, AnyTryExpr {
    override string getAPrimaryQlClass() { result = "ForceTryExpr" }
  }
}
