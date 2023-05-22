// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.AstNode
import codeql.swift.elements.AvailabilityInfo
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.pattern.Pattern

module Generated {
  class ConditionElement extends Synth::TConditionElement, AstNode {
    override string getAPrimaryQlClass() { result = "ConditionElement" }

    /**
     * Gets the boolean of this condition element, if it exists.
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    Expr getImmediateBoolean() {
      result =
        Synth::convertExprFromRaw(Synth::convertConditionElementToRaw(this)
              .(Raw::ConditionElement)
              .getBoolean())
    }

    /**
     * Gets the boolean of this condition element, if it exists.
     */
    final Expr getBoolean() {
      exists(Expr immediate |
        immediate = this.getImmediateBoolean() and
        if exists(this.getResolveStep()) then result = immediate else result = immediate.resolve()
      )
    }

    /**
     * Holds if `getBoolean()` exists.
     */
    final predicate hasBoolean() { exists(this.getBoolean()) }

    /**
     * Gets the pattern of this condition element, if it exists.
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    Pattern getImmediatePattern() {
      result =
        Synth::convertPatternFromRaw(Synth::convertConditionElementToRaw(this)
              .(Raw::ConditionElement)
              .getPattern())
    }

    /**
     * Gets the pattern of this condition element, if it exists.
     */
    final Pattern getPattern() {
      exists(Pattern immediate |
        immediate = this.getImmediatePattern() and
        if exists(this.getResolveStep()) then result = immediate else result = immediate.resolve()
      )
    }

    /**
     * Holds if `getPattern()` exists.
     */
    final predicate hasPattern() { exists(this.getPattern()) }

    /**
     * Gets the initializer of this condition element, if it exists.
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    Expr getImmediateInitializer() {
      result =
        Synth::convertExprFromRaw(Synth::convertConditionElementToRaw(this)
              .(Raw::ConditionElement)
              .getInitializer())
    }

    /**
     * Gets the initializer of this condition element, if it exists.
     */
    final Expr getInitializer() {
      exists(Expr immediate |
        immediate = this.getImmediateInitializer() and
        if exists(this.getResolveStep()) then result = immediate else result = immediate.resolve()
      )
    }

    /**
     * Holds if `getInitializer()` exists.
     */
    final predicate hasInitializer() { exists(this.getInitializer()) }

    /**
     * Gets the availability of this condition element, if it exists.
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    AvailabilityInfo getImmediateAvailability() {
      result =
        Synth::convertAvailabilityInfoFromRaw(Synth::convertConditionElementToRaw(this)
              .(Raw::ConditionElement)
              .getAvailability())
    }

    /**
     * Gets the availability of this condition element, if it exists.
     */
    final AvailabilityInfo getAvailability() {
      exists(AvailabilityInfo immediate |
        immediate = this.getImmediateAvailability() and
        if exists(this.getResolveStep()) then result = immediate else result = immediate.resolve()
      )
    }

    /**
     * Holds if `getAvailability()` exists.
     */
    final predicate hasAvailability() { exists(this.getAvailability()) }
  }
}
