import 'package:crossnumber/src/models/constraint.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/expressable.dart';

import '../expressions/evaluator.dart';
import '../expressions/expression.dart';

/// Represents a variable in a cross number puzzle.
///
/// A variable is a named quantity that can take on a range of possible integer values.
/// Variables are often used in clues that are defined by mathematical expressions.
class Variable implements Expressable {
  /// The name of the variable.
  final String name;

  /// The list of constraints that apply to this variable.
  final List<Constraint> constraints;

  /// The set of possible integer values for this clue.
  /// This set is narrowed down by the solver as constraints are applied.
  Set<int> _possibleValues;
  @override
  Set<int> get possibleValues => _possibleValues;
  @override
  set possibleValues(Set<int>? values) {
    assert(values != null, 'Possible values cannot be null for variable $name');
    _checkAnswer(values);
    _possibleValues = values!;
  }

  /// Answer used for debugging
  /// This is not used in the solver.
  int? _answer;
  set answer(int value) {
    _answer = value;
  }

  void _checkAnswer(Set<int>? values) {
    if (values != null && _answer != null) {
      if (!values.contains(_answer)) {
        throw EvaluatorException(
            'Variable $name: Answer $_answer is not in the possible values $values');
      }
    }
  }

  /// Creates a new variable with the given [name] and [possibleValues].
  Variable(this.name, this._possibleValues, {this.constraints = const []});

  @override
  Expression get expressionTree =>
      (constraints.first as ExpressionConstraint).expressionTree!;

  @override
  List<String> get variables =>
      (constraints.first as ExpressionConstraint).variables;

  @override
  int? get min => possibleValues.reduce((a, b) => a < b ? a : b);

  @override
  int? get max => possibleValues.reduce((a, b) => a > b ? a : b);

  Variable copyWith({
    String? name,
    Set<int>? possibleValues,
    List<Constraint>? constraints,
  }) {
    return Variable(
      name ?? this.name,
      possibleValues ?? _possibleValues,
      constraints: constraints ?? this.constraints,
    );
  }
}
