// generated by codegen/codegen.py
import codeql.swift.elements
import TestUtils

from UnspecifiedElement x, string getProperty, string getError
where
  toBeTested(x) and
  not x.isUnknown() and
  getProperty = x.getProperty() and
  getError = x.getError()
select x, "getProperty:", getProperty, "getError:", getError
