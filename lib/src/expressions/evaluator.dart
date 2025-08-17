import 'dart:math';

import 'package:crossnumber/src/models/evaluation_result.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'expression.dart';
import 'generators.dart';
import 'monadic.dart';

/// Evaluates an [Expression] tree to a list of possible numerical results.
///
/// The evaluator can handle variables, generators, and references to grid entries,
/// provided that the necessary context ([puzzle]) is given.
class Evaluator implements ExpressionVisitor<List<dynamic>> {
  final PuzzleDefinition puzzle;
  final GeneratorRegistry _generatorRegistry = GeneratorRegistry();
  final MonadicFunctionRegistry _monadicFunctionRegistry =
      MonadicFunctionRegistry();
  final Map<String, int> _pinnedVariables;

  num? maxResult;
  bool withVariables = false;

  /// Creates a new evaluator with the given [puzzle] context.
  Evaluator(this.puzzle, [Map<String, int>? pinnedVariables])
      : _pinnedVariables = pinnedVariables ?? {};

  /// Evaluates the given [expression] and returns a list of possible values.
  List<int> evaluate(Expression expression, List<String> variables,
      {required int min, required int max}) {
    withVariables = false;
    final numResult = _internalEvaluate(expression, variables,
        min: min as num, max: max as num);
    return numResult
        .where((n) => n.isFinite && n.truncate() == n)
        .map((n) => n.toInt())
        .where((value) => value >= min && value <= max)
        .toSet()
        .toList();
  }

  List<EvaluationFinalResult> evaluateWithVariables(
      Expression expression, List<String> variables,
      {required int min, required int max}) {
    withVariables = true;
    final results = _internalEvaluateV(expression, variables,
        min: min as num, max: max as num);
    return results
        .where((r) => r.value.isFinite && r.value.truncate() == r.value)
        .map((r) => EvaluationFinalResult(r.value.toInt(), r.variableValues))
        .where((r) => r.value >= min && r.value <= max)
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

  List<EvaluationResult> _internalEvaluateV(
      Expression expression, List<String> variables,
      {required num min, required num max}) {
    // Maximum possible result value
    maxResult = max;

    if (variables.isEmpty) {
      return _evaluateWithPinnedVariablesV(expression, min: min, max: max);
    }

    final results = <EvaluationResult>{};
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
      final result = evaluator._internalEvaluateV(expression, unpinnedVariables,
          min: min, max: max);
      results.addAll(result);
    }

    return results.toList();
  }

  List<num> _evaluateWithPinnedVariables(Expression expression,
      {required num min, required num max}) {
    return expression
        .accept(this, min: min, max: max, withVariables: false)
        .map((e) => e as num)
        .toList();
  }

  List<EvaluationResult> _evaluateWithPinnedVariablesV(Expression expression,
      {required num min, required num max}) {
    return expression.accept(this, min: min, max: max, withVariables: true)
        as List<EvaluationResult>;
  }

  @override
  List<dynamic> visitNumberExpression(NumberExpression expression,
      {required num min, required num max, required bool withVariables}) {
    final value = expression.value;
    if (value >= min && value <= max) {
      return withVariables ? [EvaluationResult(value, {})] : [value];
    }
    return [];
  }

  @override
  List<dynamic> visitVariableExpression(VariableExpression expression,
      {required num min, required num max, required bool withVariables}) {
    if (_pinnedVariables.containsKey(expression.name)) {
      final value = _pinnedVariables[expression.name]!;
      if (value >= min && value <= max) {
        return withVariables
            ? [
                EvaluationResult(value, {expression.name: value})
              ]
            : [value];
      }
      return [];
    }
    if (puzzle.variables.containsKey(expression.name)) {
      return puzzle.variables[expression.name]!.possibleValues
          .where((value) => value >= min && value <= max)
          .map((e) =>
              withVariables ? EvaluationResult(e, {expression.name: e}) : e)
          .toList();
    } else if (puzzle.clues.containsKey(expression.name)) {
      return (puzzle.clues[expression.name]!.possibleValues ?? <int>{})
          .where((value) => value >= min && value <= max)
          .map((e) =>
              withVariables ? EvaluationResult(e, {expression.name: e}) : e)
          .toList();
    }
    throw Exception('Undefined variable or clue: ${expression.name}');
  }

  @override
  List<dynamic> visitGeneratorExpression(GeneratorExpression expression,
      {required num min, required num max, required bool withVariables}) {
    final generator = _generatorRegistry.get(expression.name);
    if (generator != null) {
      return generator
          .getValues(min.ceil(), max.floor())
          .map((e) => withVariables ? EvaluationResult(e, {}) : e)
          .toList();
    }
    throw Exception('Unknown generator: ${expression.name}');
  }

  @override
  List<dynamic> visitBinaryExpression(BinaryExpression expression,
      {required num min, required num max, required bool withVariables}) {
    num leftMin = -max;
    num leftMax = max;
    if (expression.operator.type == TokenType.MINUS ||
        expression.operator.type == TokenType.SLASH) {
      // Arbitrary min/max limit when do not know what values are to be subtracted or divided
      const arbitraryLimit = 10000;
      leftMin = -arbitraryLimit;
      leftMax = arbitraryLimit;
    }
    final leftValues = withVariables
        ? _evaluateWithPinnedVariablesV(expression.left,
            min: leftMin, max: leftMax)
        : _evaluateWithPinnedVariables(expression.left,
            min: leftMin, max: leftMax);
    final results = withVariables ? <EvaluationResult>{} : <num>{};
    for (final leftResult in leftValues) {
      final left = withVariables
          ? (leftResult as EvaluationResult).value
          : leftResult as num;
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
      final rightValues = withVariables
          ? _evaluateWithPinnedVariablesV(expression.right,
              min: rightMin, max: rightMax)
          : _evaluateWithPinnedVariables(expression.right,
              min: rightMin, max: rightMax);
      for (final rightResult in rightValues) {
        final right = withVariables
            ? (rightResult as EvaluationResult).value
            : (rightResult as num);
        num resultValue;
        switch (expression.operator.type) {
          case TokenType.PLUS:
            resultValue = left + right;
            break;
          case TokenType.MINUS:
            resultValue = left - right;
            break;
          case TokenType.STAR:
            resultValue = left * right;
            break;
          case TokenType.SLASH:
            if (right != 0) {
              resultValue = left / right;
            } else {
              continue;
            }
            break;
          case TokenType.EXPONENT:
            resultValue = pow(left, right);
            break;
          default:
            throw Exception(
                'Unknown binary operator: ${expression.operator.type}');
        }
        if (withVariables) {
          // TODO compute the intersection of leftResult and rightResult variableValues with common variables
          final variableValues = Map<String, int>.from(
              (leftResult as EvaluationResult).variableValues)
            ..addAll((rightResult as EvaluationResult).variableValues);
          results.add(EvaluationResult(resultValue, variableValues));
        } else {
          results.add(resultValue);
        }
      }
    }
    return results.toList();
  }

  @override
  List<dynamic> visitUnaryExpression(UnaryExpression expression,
      {required num min, required num max, required bool withVariables}) {
    final rightValues = withVariables
        ? _evaluateWithPinnedVariablesV(expression.right, min: -max, max: -min)
        : _evaluateWithPinnedVariables(expression.right, min: -max, max: -min);
    final results = withVariables ? <EvaluationResult>{} : <num>{};
    for (final rightResult in rightValues) {
      final right = withVariables
          ? (rightResult as EvaluationResult).value
          : rightResult as num;
      switch (expression.operator.type) {
        case TokenType.MINUS:
          if (withVariables) {
            results.add(EvaluationResult(
                -right, (rightResult as EvaluationResult).variableValues));
          } else {
            results.add(-right);
          }
          break;
        default:
          throw Exception('Invalid unary operator.');
      }
    }
    return results.toList();
  }

  @override
  List<dynamic> visitGroupingExpression(GroupingExpression expression,
      {required num min, required num max, required bool withVariables}) {
    return withVariables
        ? _evaluateWithPinnedVariablesV(expression.expression,
            min: min, max: max)
        : _evaluateWithPinnedVariables(expression.expression,
            min: min, max: max);
  }

  @override
  List<dynamic> visitGridEntryExpression(GridEntryExpression expression,
      {required num min, required num max, required bool withVariables}) {
    final entry = puzzle.entries[expression.entryId];
    if (entry != null) {
      return entry.possibleValues
          .where((value) => value >= min && value <= max)
          .map((e) => withVariables ? EvaluationResult(e, {}) : e)
          .toList();
    }
    throw Exception(
        'Entry ${expression.entryId} not found in puzzle definition.');
  }

  @override
  List<dynamic> visitMonadicExpression(MonadicExpression expression,
      {required num min, required num max, required bool withVariables}) {
    // Heuristic for min/max of argument to function
    num fmin = 1;
    num fmax = max;
    var fname = expression.operator.lexeme;
    if (fname.startsWith('is') && fname != 'jumble') {
      fmax = maxResult! * maxResult!;
    }
    final values = withVariables
        ? _evaluateWithPinnedVariablesV(expression.right, min: fmin, max: fmax)
        : _evaluateWithPinnedVariables(expression.right, min: fmin, max: fmax);
    final function = _monadicFunctionRegistry.get(fname);
    if (function != null) {
      // Monadic functions return int, convert to num
      return function(values
              .map((e) => withVariables
                  ? (e as EvaluationResult).value.round()
                  : (e as num).round())
              .where((e) => e == e.truncate())
              .toList())
          .where((value) => value >= min && value <= max)
          .map((e) => withVariables ? EvaluationResult(e, {}) : e)
          .toList();
    }
    throw Exception('Unknown monadic function: ${expression.operator.lexeme}');
  }
}
