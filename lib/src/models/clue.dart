import 'dart:math' as math;
import '../expressions/expression.dart';
import 'expressable.dart';
import '../expressions/evaluator.dart';
import 'constraint.dart';
import 'entry.dart';
import 'expression_constraint.dart';

/// Represents a single clue in a cross number puzzle.
///
/// A clue has an [id], a set of [constraints] that define its value,
/// and a set of [_possibleValues] that the clue can take.
class Clue implements Expressable {
  /// The unique identifier for the clue (e.g., "A1", "B2").
  final String id;

  /// The entry associated with this clue, if any.
  Entry? entry;

  /// The list of constraints that apply to this clue.
  final List<Constraint> constraints;

  /// The set of possible integer values for this clue.
  /// This set is narrowed down by the solver as constraints are applied.
  Set<int>? _possibleValues;
  @override
  Set<int>? get possibleValues => _possibleValues;
  @override
  set possibleValues(Set<int>? values) {
    _checkAnswer(values);
    _possibleValues = values;
  }

  /// Min and max values for the clue.
  /// Determined by the puzzle entry length, if any.
  /// Restricted by current possibleValues if they are set.
  @override
  int? get min {
    if (_possibleValues != null && _possibleValues!.isNotEmpty) {
      return _possibleValues!.reduce(math.min);
    }
    if (entry != null) return math.pow(10, entry!.length - 1).toInt();
    return null;
  }

  @override
  int? get max {
    if (_possibleValues != null && _possibleValues!.isNotEmpty) {
      return _possibleValues!.reduce(math.max);
    }
    if (entry != null) return math.pow(10, entry!.length).toInt() - 1;
    return null;
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
            'Clue $id: Answer $_answer is not in the possible values $values');
      }
    }
  }

  /// Creates a new clue with the given [id] and [constraints].
  Clue(this.id, this.constraints, [this.entry]);

  @override
  Expression get expressionTree =>
      (constraints.first as ExpressionConstraint).expressionTree!;

  @override
  List<String> get variables =>
      (constraints.first as ExpressionConstraint).variables;

  /// Solves the clue by applying its constraints.
  ///
  /// This method iterates through the constraints of the clue and uses them
  /// to narrow down the set of [_possibleValues].
  ///
  /// Returns `true` if the set of possible values was updated, `false` otherwise.
  // bool solve(PuzzleDefinition puzzle, List<String> updatedVariables,
  //     {bool trace = false}) {
  //       return solveExpression(this, updatedVariables,
  //           trace: trace, puzzle: puzzle);
  //     }

  Clue copyWith({
    String? id,
    List<Constraint>? constraints,
    Set<int>? possibleValues,
  }) {
    return Clue(
      id ?? this.id,
      constraints ?? this.constraints,
    ).._possibleValues = possibleValues != null
        ? Set<int>.from(possibleValues)
        : _possibleValues == null
            ? null
            : Set<int>.from(_possibleValues!);
  }
}
