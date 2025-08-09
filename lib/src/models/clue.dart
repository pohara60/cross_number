import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';

import 'constraint.dart';
import 'expression_constraint.dart';

/// Represents a single clue in a cross number puzzle.
///
/// A clue has an [id], a set of [constraints] that define its value,
/// and a set of [possibleValues] that the clue can take.
class Clue {
  /// The unique identifier for the clue (e.g., "A1", "B2").
  final String id;

  /// The list of constraints that apply to this clue.
  final List<Constraint> constraints;

  /// The set of possible integer values for this clue.
  /// This set is narrowed down by the solver as constraints are applied.
  Set<int> possibleValues = {};

  /// Creates a new clue with the given [id] and [constraints].
  Clue(this.id, this.constraints);

  /// Solves the clue by applying its constraints.
  ///
  /// This method iterates through the constraints of the clue and uses them
  /// to narrow down the set of [possibleValues].
  ///
  /// Returns `true` if the set of possible values was updated, `false` otherwise.
  bool solve(PuzzleDefinition puzzle) {
    bool updated = false;
    for (final constraint in constraints) {
      if (constraint is ExpressionConstraint) {
        final parser = Parser(constraint.expression);
        final expression = parser.parse();
        final evaluator = Evaluator(puzzle);

        final newPossibleValues = evaluator.evaluate(expression);

        final oldPossibleValues = Set<int>.from(possibleValues);
        if (possibleValues.isEmpty) {
          possibleValues = newPossibleValues.toSet();
        } else {
          possibleValues.retainWhere((value) => newPossibleValues.contains(value));
        }

        if (possibleValues.length != oldPossibleValues.length ||
            !possibleValues.containsAll(oldPossibleValues)) {
          updated = true;
        }
      }
    }
    return updated;
  }

  /// Updates the possible values of variables based on the clue's possible values.
  ///
  /// Returns `true` if any variable's possible values were updated, `false` otherwise.
  bool updateVariables(PuzzleDefinition puzzle) {
    // This method will need to be updated to work with the new evaluator.
    // For now, we'll just return false.
    return false;
  }

  Clue copyWith({
    String? id,
    List<Constraint>? constraints,
    Set<int>? possibleValues,
  }) {
    return Clue(
      id ?? this.id,
      constraints ?? this.constraints,
    )..possibleValues = Set<int>.from(possibleValues ?? this.possibleValues);
  }
}
