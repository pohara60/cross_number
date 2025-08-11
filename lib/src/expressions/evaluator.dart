import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'expression.dart';
import 'generators.dart';
import 'monadic.dart';

/// Evaluates an [Expression] tree to a list of possible numerical results.
///
/// The evaluator can handle variables, generators, and references to grid entries,
/// provided that the necessary context ([puzzle]) is given.
class Evaluator implements ExpressionVisitor<List<int>> {
  final PuzzleDefinition puzzle;
  final GeneratorRegistry _generatorRegistry = GeneratorRegistry();
  final MonadicFunctionRegistry _monadicFunctionRegistry =
      MonadicFunctionRegistry();
  final Map<String, int> _pinnedVariables;

  /// Creates a new evaluator with the given [puzzle] context.
  Evaluator(this.puzzle, [Map<String, int>? pinnedVariables])
      : _pinnedVariables = pinnedVariables ?? {};

  /// Evaluates the given [expression] and returns a list of possible values.
  List<int> evaluate(Expression expression,
      {required int min, required int max}) {
    final variableVisitor = _VariableVisitor();
    expression.accept(variableVisitor, min: min, max: max);
    final variables = variableVisitor.variables
        .where((v) => !_pinnedVariables.containsKey(v))
        .toList();

    if (variables.isEmpty) {
      return _evaluateWithPinnedVariables(expression, min: min, max: max);
    }

    final results = <int>{};
    final currentVariable = variables.first;

    final possibleValues = puzzle.variables.containsKey(currentVariable)
        ? puzzle.variables[currentVariable]!.possibleValues
        : puzzle.clues[currentVariable]!.possibleValues;

    for (final value in possibleValues) {
      // Check for duplicate variable values
      if (_pinnedVariables.containsValue(value)) continue;

      final newPinnedVariables = Map<String, int>.from(_pinnedVariables);
      newPinnedVariables[currentVariable] = value;

      final evaluator = Evaluator(puzzle, newPinnedVariables);
      final result = evaluator.evaluate(expression, min: min, max: max);
      results.addAll(result);
    }

    return results.toList();
  }

  List<int> _evaluateWithPinnedVariables(Expression expression,
      {required int min, required int max}) {
    return expression.accept(this, min: min, max: max);
  }

  @override
  List<int> visitNumberExpression(NumberExpression expression,
      {required int min, required int max}) {
    final value = expression.value.toInt();
    return value >= min && value <= max ? [value] : [];
  }

  @override
  List<int> visitVariableExpression(VariableExpression expression,
      {required int min, required int max}) {
    if (_pinnedVariables.containsKey(expression.name)) {
      final value = _pinnedVariables[expression.name]!;
      return value >= min && value <= max ? [value] : [];
    }
    if (puzzle.variables.containsKey(expression.name)) {
      return puzzle.variables[expression.name]!.possibleValues
          .where((value) => value >= min && value <= max)
          .toList();
    } else if (puzzle.clues.containsKey(expression.name)) {
      return puzzle.clues[expression.name]!.possibleValues
          .where((value) => value >= min && value <= max)
          .toList();
    }
    throw Exception('Undefined variable or clue: ${expression.name}');
  }

  @override
  List<int> visitGeneratorExpression(GeneratorExpression expression,
      {required int min, required int max}) {
    final generator = _generatorRegistry.get(expression.name);
    if (generator != null) {
      return generator(min, max);
    }
    throw Exception('Unknown generator: ${expression.name}');
  }

  @override
  List<int> visitBinaryExpression(BinaryExpression expression,
      {required int min, required int max}) {
    final leftValues =
        _evaluateWithPinnedVariables(expression.left, min: -10000, max: 10000);
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
          throw Exception(
              'Unknown binary operator: ${expression.operator.type}');
      }
      final rightValues = _evaluateWithPinnedVariables(expression.right,
          min: rightMin, max: rightMax);
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
            throw Exception(
                'Unknown binary operator: ${expression.operator.type}');
        }
      }
    }
    return results.toList();
  }

  @override
  List<int> visitUnaryExpression(UnaryExpression expression,
      {required int min, required int max}) {
    final rightValues =
        _evaluateWithPinnedVariables(expression.right, min: -max, max: -min);
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
  List<int> visitGroupingExpression(GroupingExpression expression,
      {required int min, required int max}) {
    return _evaluateWithPinnedVariables(expression.expression,
        min: min, max: max);
  }

  @override
  List<int> visitGridEntryExpression(GridEntryExpression expression,
      {required int min, required int max}) {
    final entry = puzzle.entries[expression.entryId];
    if (entry != null) {
      return entry.possibleValues
          .where((value) => value >= min && value <= max)
          .toList();
    }
    throw Exception(
        'Entry ${expression.entryId} not found in puzzle definition.');
  }

  @override
  List<int> visitMonadicExpression(MonadicExpression expression,
      {required int min, required int max}) {
    final values =
        _evaluateWithPinnedVariables(expression.right, min: -10000, max: 10000);
    final function = _monadicFunctionRegistry.get(expression.operator.lexeme);
    if (function != null) {
      return function(values)
          .where((value) => value >= min && value <= max)
          .toList();
    }
    throw Exception('Unknown monadic function: ${expression.operator.lexeme}');
  }
}

class _VariableVisitor implements ExpressionVisitor<void> {
  final Set<String> _variables = {};

  Set<String> get variables => _variables;

  @override
  void visitBinaryExpression(BinaryExpression expression,
      {required int min, required int max}) {
    expression.left.accept(this, min: min, max: max);
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitGroupingExpression(GroupingExpression expression,
      {required int min, required int max}) {
    expression.expression.accept(this, min: min, max: max);
  }

  @override
  void visitNumberExpression(NumberExpression expression,
      {required int min, required int max}) {}

  @override
  void visitUnaryExpression(UnaryExpression expression,
      {required int min, required int max}) {
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitVariableExpression(VariableExpression expression,
      {required int min, required int max}) {
    _variables.add(expression.name);
  }

  @override
  void visitGeneratorExpression(GeneratorExpression expression,
      {required int min, required int max}) {}

  @override
  void visitGridEntryExpression(GridEntryExpression expression,
      {required int min, required int max}) {}

  @override
  void visitMonadicExpression(MonadicExpression expression,
      {required int min, required int max}) {
    expression.right.accept(this, min: min, max: max);
  }
}
