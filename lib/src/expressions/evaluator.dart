import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'expression.dart';
import 'generators.dart';

/// Evaluates an [Expression] tree to a list of possible numerical results.
///
/// The evaluator can handle variables, generators, and references to grid entries,
/// provided that the necessary context ([puzzle]) is given.
class Evaluator implements ExpressionVisitor<List<int>> {
  final PuzzleDefinition puzzle;
  final GeneratorRegistry _generatorRegistry = GeneratorRegistry();

  /// Creates a new evaluator with the given [puzzle] context.
  Evaluator(this.puzzle);

  /// Evaluates the given [expression] and returns a list of possible values.
  List<int> evaluate(Expression expression, {required int min, required int max}) {
    return expression.accept(this, min: min, max: max);
  }

  @override
  List<int> visitNumberExpression(NumberExpression expression, {required int min, required int max}) {
    final value = expression.value.toInt();
    return value >= min && value <= max ? [value] : [];
  }

  @override
  List<int> visitVariableExpression(VariableExpression expression, {required int min, required int max}) {
    if (puzzle.variables.containsKey(expression.name)) {
      return puzzle.variables[expression.name]!.possibleValues.where((value) => value >= min && value <= max).toList();
    } else if (puzzle.clues.containsKey(expression.name)) {
      return puzzle.clues[expression.name]!.possibleValues.where((value) => value >= min && value <= max).toList();
    }
    throw Exception('Undefined variable or clue: ${expression.name}');
  }

  @override
  List<int> visitGeneratorExpression(GeneratorExpression expression, {required int min, required int max}) {
    final generator = _generatorRegistry.get(expression.name);
    if (generator != null) {
      return generator(min, max);
    }
    throw Exception('Unknown generator: ${expression.name}');
  }

  @override
  List<int> visitBinaryExpression(BinaryExpression expression, {required int min, required int max}) {
    final leftValues = expression.left.accept(this, min: -10000, max: 10000);
    final results = <int>{};
    for (final left in leftValues) {
      int rightMin, rightMax;
      switch (expression.operator.type) {
        case TokenType.PLUS:
          rightMin = min - left;
          rightMax = max - left;
          break;
        case TokenType.MINUS:
          rightMin = left - max;
          rightMax = left - min;
          break;
        case TokenType.STAR:
          if (left == 0) continue;
          rightMin = min ~/ left;
          rightMax = max ~/ left;
          break;
        case TokenType.SLASH:
          if (left == 0) continue;
          rightMin = left ~/ max;
          rightMax = left ~/ min;
          break;
        default:
          throw Exception('Unknown binary operator: ${expression.operator.type}');
      }
      final rightValues = expression.right.accept(this, min: rightMin, max: rightMax);
      for (final right in rightValues) {
        switch (expression.operator.type) {
          case TokenType.PLUS:
            results.add(left + right);
            break;
          case TokenType.MINUS:
            results.add(left - right);
            break;
          case TokenType.STAR:
            results.add(left * right);
            break;
          case TokenType.SLASH:
            if (right != 0) {
              results.add(left ~/ right);
            }
            break;
          default:
            throw Exception('Unknown binary operator: ${expression.operator.type}');
        }
      }
    }
    return results.toList();
  }

  @override
  List<int> visitUnaryExpression(UnaryExpression expression, {required int min, required int max}) {
    final rightValues = expression.right.accept(this, min: -max, max: -min);
    final results = <int>{};
    for (final right in rightValues) {
      switch (expression.operator.type) {
        case TokenType.MINUS:
          results.add(-right);
          break;
        default:
          throw Exception('Invalid unary operator.');
      }
    }
    return results.toList();
  }

  @override
  List<int> visitGroupingExpression(GroupingExpression expression, {required int min, required int max}) {
    return expression.expression.accept(this, min: min, max: max);
  }

  @override
  List<int> visitGridEntryExpression(GridEntryExpression expression, {required int min, required int max}) {
    final entry = puzzle.entries[expression.entryId];
    if (entry != null) {
      return entry.possibleValues.where((value) => value >= min && value <= max).toList();
    }
    throw Exception('Entry ${expression.entryId} not found in puzzle definition.');
  }
}
