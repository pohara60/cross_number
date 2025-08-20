import 'package:crossnumber/src/expressions/expression.dart';

import 'constraint.dart';

/// A constraint that is defined by a mathematical or logical expression.
///
/// The [expression] string is parsed and evaluated by the solver to determine
/// the possible values for a clue.
class ExpressionConstraint extends Constraint {
  /// The expression string that defines the constraint.
  final String expression;

  /// The parsed expression tree.
  Expression? expressionTree;

  /// The list of variables in the expression.
  List<String> variables = [];

  /// Creates a new expression constraint with the given [expression].
  ExpressionConstraint(this.expression);

  @override
  String toString() {
    return 'ExpressionConstraint($expression)';
  }
}
