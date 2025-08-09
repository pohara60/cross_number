import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'expression.dart';
import 'generators.dart';

/// Evaluates an [Expression] tree to a list of possible numerical results.
///
/// The evaluator can handle variables, generators, and references to grid entries,
/// provided that the necessary context ([puzzle]) is given.
class Evaluator implements ExpressionVisitor<List<int>> {
  final PuzzleDefinition puzzle;
  final int min;
  final int max;
  final GeneratorRegistry _generatorRegistry = GeneratorRegistry();

  /// Creates a new evaluator with the given [puzzle] context.
  Evaluator(this.puzzle, {required this.min, required this.max});

  /// Evaluates the given [expression] and returns a list of possible values.
  List<int> evaluate(Expression expression) {
    return expression.accept(this);
  }

  @override
  List<int> visitNumberExpression(NumberExpression expression) {
    return [expression.value.toInt()];
  }

  @override
  List<int> visitVariableExpression(VariableExpression expression) {
    if (puzzle.variables.containsKey(expression.name)) {
      return puzzle.variables[expression.name]!.possibleValues.toList();
    }
    throw Exception('Undefined variable: ${expression.name}');
  }

  @override
  List<int> visitGeneratorExpression(GeneratorExpression expression) {
    final generator = _generatorRegistry.get(expression.name);
    if (generator != null) {
      return generator(min, max);
    }
    throw Exception('Unknown generator: ${expression.name}');
  }

  @override
  List<int> visitBinaryExpression(BinaryExpression expression) {
    final leftValues = evaluate(expression.left);
    final rightValues = evaluate(expression.right);
    final results = <int>{};

    for (final left in leftValues) {
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
  List<int> visitUnaryExpression(UnaryExpression expression) {
    final rightValues = evaluate(expression.right);
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
  List<int> visitGroupingExpression(GroupingExpression expression) {
    return evaluate(expression.expression);
  }

  @override
  List<int> visitGridEntryExpression(GridEntryExpression expression) {
    final entry = puzzle.entries[expression.entryId];
    if (entry != null) {
      return entry.possibleValues.toList();
    }
    throw Exception('Entry ${expression.entryId} not found in puzzle definition.');
  }
}
