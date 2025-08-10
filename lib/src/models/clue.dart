import 'package:collection/collection.dart';
import 'package:crossnumber/src/utils/combinations.dart';
import 'dart:math';

import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/expressions/expression.dart';
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

        final entry =
            puzzle.entries.values.firstWhereOrNull((e) => e.clueId == id);
        final min = entry != null ? pow(10, entry.length - 1).toInt() : -10000;
        final max = entry != null ? pow(10, entry.length).toInt() - 1 : 10000;

        final evaluator = Evaluator(puzzle);
        final newPossibleValues =
            evaluator.evaluate(expression, min: min, max: max);

        final oldPossibleValues = Set<int>.from(possibleValues);
        possibleValues
            .retainWhere((value) => newPossibleValues.contains(value));

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
  bool updateVariables(PuzzleDefinition puzzle, {bool trace = false}) {
    bool updated = false;
    for (final constraint in constraints) {
      if (constraint is ExpressionConstraint) {
        final parser = Parser(constraint.expression);
        final expression = parser.parse();

        // Get all variables in the expression
        final variableExtractor = VariableExtractorVisitor();
        expression.accept(variableExtractor, min: -10000, max: 10000);
        final expressionVariables = variableExtractor.variables;

        if (expressionVariables.isEmpty) continue;

        // For each variable, try to narrow down its possible values
        for (var variableName in expressionVariables) {
          var variable = puzzle.variables[variableName];
          if (variable == null) {
            // This is a clue, not a variable
            continue;
          }
          var newPossibleValues = <int>{};

          // Try each possible value of the variable
          for (var value in variable.possibleValues) {
            // Create a temporary puzzle state with the variable fixed to this value
            var tempPuzzle = puzzle.copyWith();
            tempPuzzle.variables[variableName]!.possibleValues = {value};

            // Evaluate the expression with this temporary state
            final tempEvaluator = Evaluator(tempPuzzle);
            final clueValues =
                tempEvaluator.evaluate(expression, min: -10000, max: 10000);

            // If the clue's possible values have any intersection with the new possible values,
            // then the variable value is possible
            if (possibleValues.any((v) => clueValues.contains(v))) {
              newPossibleValues.add(value);
            }
          }

          if (newPossibleValues.length < variable.possibleValues.length) {
            if (trace) {
              print(
                  '    Variable ${variable.name} updated by clue ${this.id}: ${variable.possibleValues.length} -> ${newPossibleValues.length}');
            }
            variable.possibleValues = newPossibleValues;
            updated = true;
          }
        }
      }
    }
    return updated;
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
