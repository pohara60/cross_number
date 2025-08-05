import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/expressions/expression.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/utils/combinations.dart';

import 'constraint.dart';
import 'expression_constraint.dart';
import 'variable.dart';

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

        final variableExtractor = VariableExtractorVisitor();
        expression.accept(variableExtractor);

        final Map<String, Set<int>> variableDomains = {};
        for (final varName in variableExtractor.variables) {
          if (puzzle.variables.containsKey(varName)) {
            variableDomains[varName] = puzzle.variables[varName]!.possibleValues;
          } else {
            // Handle error: variable not found
            print('Error: Variable $varName not found in puzzle definition.');
            return false; // Or throw an error
          }
        }

        final Set<int> newPossibleValues = {};
        if (variableDomains.isEmpty) {
          final evaluator = Evaluator({}, puzzle: puzzle); // Always pass puzzle
          final result = evaluator.evaluate(expression);
          if (result is int) {
            newPossibleValues.add(result);
          }
        } else {
          final combinations = generateCombinations(variableDomains);
          for (final combo in combinations) {
            final evaluator = Evaluator(combo.cast<String, num>(), puzzle: puzzle); // Always pass puzzle
            try {
              final result = evaluator.evaluate(expression);
              if (result is int) {
                newPossibleValues.add(result);
              }
            } catch (e) {
              // Handle evaluation errors (e.g., division by zero)
              print('Evaluation error for clue ${id} with combo $combo: $e');
            }
          }
        }

        final oldPossibleValues = Set<int>.from(possibleValues);
        if (possibleValues.isEmpty) {
          possibleValues = newPossibleValues;
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
    bool updated = false;
    for (final constraint in constraints) {
      if (constraint is ExpressionConstraint) {
        final parser = Parser(constraint.expression);
        final expression = parser.parse();
        final variableExtractor = VariableExtractorVisitor();
        expression.accept(variableExtractor);

        for (final varName in variableExtractor.variables) {
          final variable = puzzle.variables[varName]!;
          final originalValues = Set<int>.from(variable.possibleValues);

          final newVariableValues = <int>{};
          for (final varValue in variable.possibleValues) {
            final evaluator = Evaluator({varName: varValue}, puzzle: puzzle);
            try {
              final result = evaluator.evaluate(expression);
              if (possibleValues.contains(result)) {
                newVariableValues.add(varValue);
              }
            } catch (e) {
              // Ignore evaluation errors
            }
          }

          if (newVariableValues.length < variable.possibleValues.length) {
            variable.possibleValues = newVariableValues;
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