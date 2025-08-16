import 'dart:math';

import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'expression.dart';
import 'generators.dart';
import 'monadic.dart';

/// Evaluates an [Expression] tree to a list of possible numerical results.
///
/// The evaluator can handle variables, generators, and references to grid entries,
/// provided that the necessary context ([puzzle]) is given.
class Evaluator implements ExpressionVisitor<List<num>> {
  final PuzzleDefinition puzzle;
  final GeneratorRegistry _generatorRegistry = GeneratorRegistry();
  final MonadicFunctionRegistry _monadicFunctionRegistry =
      MonadicFunctionRegistry();
  final Map<String, int> _pinnedVariables;

  num? maxResult;

  /// Creates a new evaluator with the given [puzzle] context.
  Evaluator(this.puzzle, [Map<String, int>? pinnedVariables])
      : _pinnedVariables = pinnedVariables ?? {};

  /// Evaluates the given [expression] and returns a list of possible values.
  List<int> evaluate(Expression expression, List<String> variables,
      {required int min, required int max}) {
    final numResult = _internalEvaluate(expression, variables,
        min: min as num, max: max as num);
    return numResult
        .where((n) => n.isFinite && n.truncate() == n)
        .map((n) => n.toInt())
        .where((value) => value >= min && value <= max)
        .toSet()
        .toList();
  }

  List<num> _internalEvaluate(Expression expression, List<String> variables,
      {required num min, required num max}) {
    // Maximum possible result value
    maxResult = max;

    if (variables.isEmpty) {
      return _evaluateWithPinnedVariables(expression, min: min, max: max);
    }

    final results = <num>{};
    final currentVariable = variables.first;
    final unpinnedVariables = variables.sublist(1);

    final possibleValues = puzzle.variables.containsKey(currentVariable)
        ? puzzle.variables[currentVariable]!.possibleValues
        : puzzle.clues[currentVariable]!.possibleValues!;

    for (final value in possibleValues) {
      // Check for duplicate variable values
      if (_pinnedVariables.containsValue(value)) continue;

      final newPinnedVariables = Map<String, int>.from(_pinnedVariables);
      newPinnedVariables[currentVariable] = value;

      final evaluator = Evaluator(puzzle, newPinnedVariables);
      final result = evaluator._internalEvaluate(expression, unpinnedVariables,
          min: min, max: max);
      results.addAll(result);
    }

    return results.toList();
  }

  List<num> _evaluateWithPinnedVariables(Expression expression,
      {required num min, required num max}) {
    return expression.accept(this, min: min, max: max);
  }

  @override
  List<num> visitNumberExpression(NumberExpression expression,
      {required num min, required num max}) {
    final value = expression.value;
    return value >= min && value <= max ? [value] : [];
  }

  @override
  List<num> visitVariableExpression(VariableExpression expression,
      {required num min, required num max}) {
    if (_pinnedVariables.containsKey(expression.name)) {
      final value = _pinnedVariables[expression.name]!;
      return value >= min && value <= max ? [value] : [];
    }
    if (puzzle.variables.containsKey(expression.name)) {
      return puzzle.variables[expression.name]!.possibleValues
          .where((value) => value >= min && value <= max)
          .map((e) => e as num)
          .toList();
    } else if (puzzle.clues.containsKey(expression.name)) {
      return (puzzle.clues[expression.name]!.possibleValues ?? <int>{})
          .where((value) => value >= min && value <= max)
          .map((e) => e as num)
          .toList();
    }
    throw Exception('Undefined variable or clue: ${expression.name}');
  }

  @override
  List<num> visitGeneratorExpression(GeneratorExpression expression,
      {required num min, required num max}) {
    final generator = _generatorRegistry.get(expression.name);
    if (generator != null) {
      return generator
          .getValues(min.ceil(), max.floor())
          .map((e) => e as num)
          .toList();
    }
    throw Exception('Unknown generator: ${expression.name}');
  }

  @override
  List<num> visitBinaryExpression(BinaryExpression expression,
      {required num min, required num max}) {
    num leftMin = -max;
    num leftMax = max;
    if (expression.operator.type == TokenType.MINUS ||
        expression.operator.type == TokenType.SLASH) {
      // Arbitrary min/max limit when do not know what values are to be subtracted or divided
      const arbitraryLimit = 10000;
      leftMin = -arbitraryLimit;
      leftMax = arbitraryLimit;
    }
    final leftValues = _evaluateWithPinnedVariables(expression.left,
        min: leftMin, max: leftMax);
    final results = <num>{};
    for (final left in leftValues) {
      num rightMin, rightMax;
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
          if (left > 0) {
            rightMin = min / left;
            rightMax = max / left;
          } else {
            // left < 0
            rightMin = max / left;
            rightMax = min / left;
          }
          break;
        case TokenType.SLASH:
          if (left == 0) continue;
          if (left > 0) {
            rightMin = left / max;
            rightMax = left / (min > 0 ? min : 1);
          } else {
            // left < 0
            rightMin = left / (min > 0 ? min : 1);
            rightMax = left / max;
          }
          break;
        case TokenType.EXPONENT:
          if (left == 0) continue;
          if (min < 1) min = 1;
          rightMin = left <= 1 ? 2 : log(min) / log(left);
          if (rightMin == 0) rightMin = 1; // Avoid zero exponent
          rightMax = left <= 1 ? max : log(max) / log(left);
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
              results.add(left / right);
            }
            break;
          case TokenType.EXPONENT:
            results.add(pow(left, right));
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
  List<num> visitUnaryExpression(UnaryExpression expression,
      {required num min, required num max}) {
    final rightValues =
        _evaluateWithPinnedVariables(expression.right, min: -max, max: -min);
    final results = <num>{};
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
  List<num> visitGroupingExpression(GroupingExpression expression,
      {required num min, required num max}) {
    return _evaluateWithPinnedVariables(expression.expression,
        min: min, max: max);
  }

  @override
  List<num> visitGridEntryExpression(GridEntryExpression expression,
      {required num min, required num max}) {
    final entry = puzzle.entries[expression.entryId];
    if (entry != null) {
      return entry.possibleValues
          .where((value) => value >= min && value <= max)
          .map((e) => e as num)
          .toList();
    }
    throw Exception(
        'Entry ${expression.entryId} not found in puzzle definition.');
  }

  @override
  List<num> visitMonadicExpression(MonadicExpression expression,
      {required num min, required num max}) {
    // Heuristic for min/max of argument to function
    num fmin = 1;
    num fmax = max;
    var fname = expression.operator.lexeme;
    if (fname.startsWith('is') && fname != 'jumble') {
      fmax = maxResult! * maxResult!;
    }
    final values =
        _evaluateWithPinnedVariables(expression.right, min: fmin, max: fmax);
    final function = _monadicFunctionRegistry.get(fname);
    if (function != null) {
      // Monadic functions return int, convert to num
      return function(values
              .map((e) => e.round())
              .where((e) => e == e.truncate())
              .toList())
          .where((value) => value >= min && value <= max)
          .map((e) => e as num)
          .toList();
    }
    throw Exception('Unknown monadic function: ${expression.operator.lexeme}');
  }
}
