// generated by codegen/codegen.py
import codeql.swift.elements.decl.EnumElementDecl
import codeql.swift.elements.expr.Expr

class EnumIsCaseExprBase extends @enum_is_case_expr, Expr {
  override string getAPrimaryQlClass() { result = "EnumIsCaseExpr" }

  Expr getSubExpr() {
    exists(Expr x |
      enum_is_case_exprs(this, x, _) and
      result = x.resolve()
    )
  }

  EnumElementDecl getElement() {
    exists(EnumElementDecl x |
      enum_is_case_exprs(this, _, x) and
      result = x.resolve()
    )
  }
}
