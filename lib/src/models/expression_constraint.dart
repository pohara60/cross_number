import 'constraint.dart';

/// A constraint that is defined by a mathematical or logical expression.
///
/// The [expression] string is parsed and evaluated by the solver to determine
/// the possible values for a clue.
class ExpressionConstraint extends Constraint {
  /// The expression string that defines the constraint.
  final String expression;

  /// Creates a new expression constraint with the given [expression].
  ExpressionConstraint(this.expression);
}
