import 'package:crossnumber/src/expressions/expression.dart';

import '../expressions/evaluator.dart';

abstract class Expressable {
  String get id;

  /// The set of possible integer values for this clue.
  /// This set is narrowed down by the solver as constraints are applied.
  Set<int>? _possibleValues;
  Set<int>? get possibleValues => _possibleValues;
  static bool checkAnswer = true;
  set possibleValues(Set<int>? values) {
    if (checkAnswer) _checkAnswer(values);
    _possibleValues = values;
  }

  int? get min => possibleValues == null || possibleValues!.isEmpty
      ? null
      : possibleValues!.reduce((a, b) => a < b ? a : b);

  int? get max => possibleValues == null || possibleValues!.isEmpty
      ? null
      : possibleValues!.reduce((a, b) => a > b ? a : b);

  /// The expression tree from the expression constraint for this expressable.
  /// Only set if there is an expression constraint
  Expression get expressionTree;
  List<String> get variables;

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
            'Expressable $id: Answer $_answer is not in the possible values $values');
      }
    }
  }
}
