class Element extends @element {
  string toString() { none() }
}

class ForEachStmt extends Element, @for_each_stmt {
  Element getSequence() { for_each_stmts(this, _, result, _) }

  Pattern getPattern() { for_each_stmts(this, result, _, _) }
}

class Pattern extends Element, @pattern {
  string getGeneratorString() { result = "$generator" }
}

class NamedPattern extends Pattern, @named_pattern {
  override string getGeneratorString() {
    exists(string name |
      named_patterns(this, name) and
      result = "$" + name + "$generator"
    )
  }
}

newtype TAddedElement =
  TIteratorVar(ForEachStmt stmt) or
  TIteratorVarPattern(ForEachStmt stmt) or
  TNextCall(ForEachStmt stmt) or
  TNextCallMethodLookup(ForEachStmt stmt) or
  TNextCallInOutConversion(ForEachStmt stmt) or
  TNextCallVarRef(ForEachStmt stmt) or
  TNextCallFuncRef(ForEachStmt stmt)

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }
}

query predicate new_for_each_stmts(ForEachStmt id, NamedPattern pattern, Element body) {
  for_each_stmts(id, pattern, _, body)
}

query predicate for_each_stmt_iterator_vars(ForEachStmt id, NewElement iteratorVar) {
  Fresh::map(TIteratorVar(id)) = iteratorVar
}

query predicate new_pattern_binding_decls(NewElement id) {
  pattern_binding_decls(id)
  or
  Fresh::map(TIteratorVar(_)) = id
}

query predicate new_pattern_binding_decl_patterns(NewElement id, int index, NewElement pattern) {
  pattern_binding_decl_patterns(id, index, pattern)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TIteratorVar(foreach)) = id and
    Fresh::map(TIteratorVarPattern(foreach)) = pattern and
    index = 0
  )
}

query predicate new_named_patterns(NewElement id, string name) {
  named_patterns(id, name)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TIteratorVarPattern(foreach)) = id and
    name = foreach.getPattern().getGeneratorString()
  )
}

query predicate new_pattern_binding_decl_inits(NewElement id, int index, NewElement init) {
  pattern_binding_decl_inits(id, index, init)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TIteratorVar(foreach)) = id and
    foreach.getSequence() = init and
    index = 0
  )
}

query predicate for_each_stmt_next_calls(ForEachStmt id, NewElement nextCall) {
  Fresh::map(TNextCall(id)) = nextCall
}

query predicate new_dot_syntax_call_exprs(NewElement id) {
  dot_syntax_call_exprs(id)
  or
  Fresh::map(TNextCallMethodLookup(_)) = id
}

query predicate new_self_apply_exprs(NewElement id, NewElement base) {
  self_apply_exprs(id, base)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallMethodLookup(foreach)) = id and
    Fresh::map(TNextCallInOutConversion(foreach)) = base
  )
}

query predicate new_in_out_exprs(NewElement inOutExpr, NewElement subExpr) {
  in_out_exprs(inOutExpr, subExpr)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallInOutConversion(foreach)) = inOutExpr and
    Fresh::map(TNextCallVarRef(foreach)) = subExpr
  )
}

query predicate new_apply_exprs(NewElement id, NewElement func) {
  apply_exprs(id, func)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCall(foreach)) = id and
    Fresh::map(TNextCallMethodLookup(foreach)) = func
  )
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallMethodLookup(foreach)) = id and
    Fresh::map(TNextCallFuncRef(foreach)) = func
  )
}

Element getParent(Element type) {
  any_generic_type_parents(type, result)
  or
  // there may be an extension that implements IteratorProtocol
  exists(@extension_decl extDecl, @nominal_type_decl typeDecl, @protocol_decl protocolDecl |
    any_generic_types(type, typeDecl) and
    extension_decls(extDecl, typeDecl) and
    extension_decl_protocols(extDecl, _, protocolDecl) and
    any_generic_types(result, protocolDecl)
  )
}

// TODO: do we need a new_apply_expr_arguments
query predicate new_decl_ref_exprs(NewElement id, NewElement decl) {
  decl_ref_exprs(id, decl)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallVarRef(foreach)) = id and
    Fresh::map(TIteratorVarPattern(foreach)) = decl
  )
  or
  exists(ForEachStmt foreach, @element sequence, @element exprType, @element parentType, @element typeDecl |
    Fresh::map(TNextCallFuncRef(foreach)) = id and
    // ForEachStmt.getSequence().getType().getMember(next)
    sequence = foreach.getSequence() and
    expr_types(sequence, exprType) and
    parentType = getParent*(exprType) and
    any_generic_types(parentType, typeDecl) and
    decl_members(typeDecl, _, decl) and
    callable_names(decl, "next()")
  )
}

query predicate new_lookup_exprs(NewElement id, NewElement base) {
  lookup_exprs(id, base)
  or
  exists(ForEachStmt foreach |
    Fresh::map(TNextCallMethodLookup(foreach)) = id and
    Fresh::map(TNextCallVarRef(foreach)) = base
  )
}

query predicate new_call_exprs(NewElement id) {
  call_exprs(id) or
  Fresh::map(TNextCall(_)) = id
}
