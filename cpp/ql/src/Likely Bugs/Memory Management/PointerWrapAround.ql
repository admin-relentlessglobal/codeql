/**
 * @name Reliance on pointer wrap-around
 * @description Adding a value to a pointer
 *              to see if it "wraps around" is dangerous because it relies
 *              on undefined behavior and may lead to memory corruption.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/pointer-wrap-around
 * @tags reliability
 *       security
 */

import cpp
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering

from RelationalOperation ro, PointerAddExpr add, Expr expr1, Expr expr2
where
  ro.getAnOperand() = add and
  add.getAnOperand() = expr1 and
  ro.getAnOperand() = expr2 and
  globalValueNumber(expr1) = globalValueNumber(expr2) and
  // Exclude macros except for assert macros.
  // TODO: port that location-based macro check we have in another query. Then
  // we don't need to special-case on names.
  not exists(MacroInvocation mi |
    mi.getAnAffectedElement() = add and
    not mi.getMacroName().toLowerCase().matches("%assert%")
  )
  // TODO: Add a check for -fno-strict-overflow and -fwrapv-pointer
select ro, "Range check relying on pointer overflow."
