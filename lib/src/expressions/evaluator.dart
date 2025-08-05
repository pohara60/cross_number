import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'expression.dart';

/// Evaluates an [Expression] tree to a numerical result.
///
/// The evaluator can handle variables and references to grid entries,
/// provided that the necessary context ([variables] and [puzzle]) is given.
class Evaluator implements ExpressionVisitor<num> {
  /// A map of variable names to their current numerical values.
  final Map<String, num> variables;

  /// The puzzle definition, required for evaluating grid entry expressions.
  final PuzzleDefinition? puzzle;

  /// Creates a new evaluator with the given [variables] and optional [puzzle].
  Evaluator(this.variables, {this.puzzle});

  /// Evaluates the given [expression] and returns the result.
  num evaluate(Expression expression) {
    return expression.accept(this);
  }

  @override
  num visitNumberExpression(NumberExpression expression) {
    return expression.value;
  }

  @override
  num visitVariableExpression(VariableExpression expression) {
    if (variables.containsKey(expression.name)) {
      return variables[expression.name]!;
    }
    throw Exception('Undefined variable: ${expression.name}');
  }

  @override
  num visitBinaryExpression(BinaryExpression expression) {
    final left = evaluate(expression.left);
    final right = evaluate(expression.right);

    switch (expression.operator.type) {
      case TokenType.PLUS:
        return left + right;
      case TokenType.MINUS:
        return left - right;
      case TokenType.STAR:
        return left * right;
      case TokenType.SLASH:
        return left / right;
      default:
        throw Exception('Unknown binary operator: ${expression.operator.type}');
    }
  }

  @override
  num visitUnaryExpression(UnaryExpression expression) {
    final right = evaluate(expression.right);
    switch (expression.operator.type) {
      case TokenType.MINUS:
        return -right;
      default:
        // Should not happen.
        throw Exception('Invalid unary operator.');
    }
  }

  @override
  num visitGroupingExpression(GroupingExpression expression) {
    return evaluate(expression.expression);
  }

  @override
  num visitGridEntryExpression(GridEntryExpression expression) {
    if (puzzle == null) {
      throw Exception('PuzzleDefinition not provided to Evaluator for grid entry evaluation.');
    }
    final grid = puzzle!.grids[expression.gridId];
    if (grid == null) {
      throw Exception('Grid ${expression.gridId} not found in puzzle definition.');
    }
    final entry = puzzle!.entries[expression.entryId];
    if (entry == null) {
      throw Exception('Entry ${expression.entryId} not found in puzzle definition.');
    }
    if (entry.possibleValues.length != 1) {
      throw Exception('Entry ${expression.entryId} does not have a single determined value.');
    }
    return entry.possibleValues.single;
  }
}
