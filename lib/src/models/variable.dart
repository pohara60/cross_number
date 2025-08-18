import '../expressions/evaluator.dart';

/// Represents a variable in a cross number puzzle.
///
/// A variable is a named quantity that can take on a range of possible integer values.
/// Variables are often used in clues that are defined by mathematical expressions.
class Variable {
  /// The name of the variable.
  final String name;

  /// The set of possible integer values for this clue.
  /// This set is narrowed down by the solver as constraints are applied.
  Set<int> _possibleValues;
  Set<int> get possibleValues => _possibleValues;
  set possibleValues(Set<int> values) {
    _checkAnswer(values);
    _possibleValues = values;
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
  Variable(this.name, this._possibleValues);

  Variable copyWith({
    String? name,
    Set<int>? possibleValues,
  }) {
    return Variable(
      name ?? this.name,
      possibleValues ?? this._possibleValues,
    );
  }
}
