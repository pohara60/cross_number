import 'dart:math';
import 'package:crossnumber/src/models/evaluation_result.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'expression.dart';
import 'generators.dart';
import 'monadic.dart';

// Arbitrary min/max limit when do not know what values are to be operated on
const arbitraryLimit = 10000;

/// Evaluates an [Expression] tree to a list of possible numerical results.
///
/// The evaluator can handle variables, generators, and references to grid entries,
/// provided that the necessary context ([puzzle]) is given.
class Evaluator implements ExpressionVisitor<List<EvaluationResult>> {
  final PuzzleDefinition puzzle;
  static final GeneratorRegistry _generatorRegistry = GeneratorRegistry();
  static final MonadicFunctionRegistry _monadicFunctionRegistry =
      MonadicFunctionRegistry();
  final Map<String, int> _pinnedVariables;

  num? maxResult;

  /// Creates a new evaluator with the given [puzzle] context.
  Evaluator(this.puzzle, [Map<String, int>? pinnedVariables])
      : _pinnedVariables = pinnedVariables ?? {};

  /// Evaluates the given [expression] with the provided [variables] and returns
  /// a list of [EvaluationFinalResult] containing the evaluated values and their
  /// corresponding variable values.
  List<EvaluationFinalResult> evaluate(
      Expression expression, List<String> variables,
      {required int min, required int max}) {
    // Some variables may be pinned already
    var unpinnedVariables =
        variables.where((v) => !_pinnedVariables.containsKey(v)).toList();
    if (tooManyCombinations(unpinnedVariables)) {
      throw EvaluatorNotPossiblexception(
          'Too many combinations for variables: ${unpinnedVariables.join(', ')}');
    }
    final results = _internalEvaluate(expression, unpinnedVariables,
        min: min as num, max: max as num);
    return results
        .where((r) => r.value.isFinite && r.value.truncate() == r.value)
        .map((r) => EvaluationFinalResult(r.value.toInt(), r.variableValues))
        .where((r) => r.value >= min && r.value <= max)
        .toSet()
        .toList();
  }

  /// Evaluates the given [expression] with the provided [variables] and returns
  /// a list of integer results that fall within the specified [min] and [max] range.
  List<int> evaluateNoVariables(Expression expression, List<String> variables,
      {required int min, required int max}) {
    // Some variables may be pinned already
    var unpinnedVariables =
        variables.where((v) => !_pinnedVariables.containsKey(v)).toList();
    final results = _internalEvaluate(expression, unpinnedVariables,
        min: min as num, max: max as num);
    return results
        .where((r) => r.value.isFinite && r.value.truncate() == r.value)
        .map((r) => r.value.toInt())
        .where((r) => r >= min && r <= max)
        .toSet()
        .toList();
  }

  List<EvaluationResult> _internalEvaluate(
      Expression expression, List<String> unpinnedVariables,
      {required num min, required num max}) {
    // Maximum possible result value
    maxResult = max;

    if (unpinnedVariables.isEmpty) {
      return _evaluateWithPinnedVariables(expression, min: min, max: max);
    }

    final results = <EvaluationResult>{};
    final currentVariable = unpinnedVariables.first;
    final newUnpinnedVariables = unpinnedVariables.sublist(1);

    final possibleValues = puzzle.variables.containsKey(currentVariable)
        ? puzzle.variables[currentVariable]!.possibleValues
        : puzzle.clues[currentVariable]!.possibleValues!;

    for (final value in possibleValues) {
      // Check for duplicate variable values
      if (_pinnedVariables.containsValue(value)) continue;

      final newPinnedVariables = Map<String, int>.from(_pinnedVariables);
      newPinnedVariables[currentVariable] = value;

      final evaluator = Evaluator(puzzle, newPinnedVariables);
      final result = evaluator._internalEvaluate(
          expression, newUnpinnedVariables,
          min: min, max: max);
      results.addAll(result);
    }

    return results.toList();
  }

  List<EvaluationResult> _evaluateWithPinnedVariables(Expression expression,
      {required num min, required num max}) {
    return expression.accept(this, min: min, max: max);
  }

  @override
  List<EvaluationResult> visitNumberExpression(NumberExpression expression,
      {required num min, required num max}) {
    final value = expression.value;
    if (value >= min && value <= max) {
      return [EvaluationResult(value, {})];
    }
    return [];
  }

  @override
  List<EvaluationResult> visitVariableExpression(VariableExpression expression,
      {required num min, required num max}) {
    if (_pinnedVariables.containsKey(expression.name)) {
      final value = _pinnedVariables[expression.name]!;
      if (value >= min && value <= max) {
        return [
          EvaluationResult(value, {expression.name: value})
        ];
      }
      return [];
    }
    if (puzzle.variables.containsKey(expression.name)) {
      return puzzle.variables[expression.name]!.possibleValues
          .where((value) => value >= min && value <= max)
          .map((e) => EvaluationResult(e, {expression.name: e}))
          .toList();
    } else if (puzzle.clues.containsKey(expression.name)) {
      return (puzzle.clues[expression.name]!.possibleValues ?? <int>{})
          .where((value) => value >= min && value <= max)
          .map((e) => EvaluationResult(e, {expression.name: e}))
          .toList();
    }
    throw EvaluatorException('Undefined variable or clue: ${expression.name}');
  }

  @override
  List<EvaluationResult> visitGeneratorExpression(
      GeneratorExpression expression,
      {required num min,
      required num max}) {
    final generator = _generatorRegistry.get(expression.name);
    if (generator != null) {
      return generator
          .getValues(min.ceil(), max.floor())
          .map((e) => EvaluationResult(e, {}))
          .toList();
    }
    throw EvaluatorException('Unknown generator: ${expression.name}');
  }

  @override
  List<EvaluationResult> visitBinaryExpression(BinaryExpression expression,
      {required num min, required num max}) {
    num leftMin = -max;
    num leftMax = max;
    // TODO If child nodes only have one value, then we can compute it and use that value to compuute the min/max for the other side.
    leftMin = -arbitraryLimit;
    leftMax = arbitraryLimit;
    final leftValues = _evaluateWithPinnedVariables(expression.left,
        min: leftMin, max: leftMax);
    final results = <EvaluationResult>{};
    for (final leftResult in leftValues) {
      final left = leftResult.value;
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
        case TokenType.EQUAL:
          rightMin = leftMin;
          rightMax = leftMax;
          break;
        default:
          throw EvaluatorException(
              'Unknown binary operator: ${expression.operator.type}');
      }
      final rightValues = _evaluateWithPinnedVariables(expression.right,
          min: rightMin, max: rightMax);
      for (final rightResult in rightValues) {
        final right = rightResult.value;
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
          case TokenType.EQUAL:
            if (left != right) continue;
            resultValue = left;
            break;
          default:
            throw EvaluatorException(
                'Unknown binary operator: ${expression.operator.type}');
        }
        // compute the intersection of left and right variableValues for common variables
        final leftVariableValues = leftResult.variableValues;
        final rightVariableValues = rightResult.variableValues;
        var consistent = true;
        for (var key in leftVariableValues.keys) {
          if (rightVariableValues.containsKey(key) &&
              leftVariableValues[key] != rightVariableValues[key]) {
            consistent = false;
            break;
          }
        }
        if (!consistent) continue;

        var variableValues = {...leftVariableValues, ...rightVariableValues};
        results.add(EvaluationResult(resultValue, variableValues));
      }
    }
    return results.toList();
  }

  @override
  List<EvaluationResult> visitUnaryExpression(UnaryExpression expression,
      {required num min, required num max}) {
    final rightValues =
        _evaluateWithPinnedVariables(expression.right, min: -max, max: -min);
    final results = <EvaluationResult>{};
    for (final rightResult in rightValues) {
      final right = rightResult.value;
      switch (expression.operator.type) {
        case TokenType.MINUS:
          results.add(EvaluationResult(-right, rightResult.variableValues));
          break;
        default:
          throw EvaluatorException('Invalid unary operator.');
      }
    }
    return results.toList();
  }

  @override
  List<EvaluationResult> visitGroupingExpression(GroupingExpression expression,
      {required num min, required num max}) {
    return _evaluateWithPinnedVariables(expression.expression,
        min: min, max: max);
  }

  @override
  List<EvaluationResult> visitGridEntryExpression(
      GridEntryExpression expression,
      {required num min,
      required num max}) {
    final entry = puzzle.entries[expression.entryId];
    if (entry != null) {
      return entry.possibleValues
          .where((value) => value >= min && value <= max)
          .map((e) => EvaluationResult(e, {}))
          .toList();
    }
    throw EvaluatorException(
        'Entry ${expression.entryId} not found in puzzle definition.');
  }

  @override
  List<EvaluationResult> visitMonadicExpression(MonadicExpression expression,
      {required num min, required num max}) {
    // Heuristic for min/max of argument to function
    num fmin = 1;
    num fmax = max;
    var fname = expression.operator.lexeme;
    if (!fname.startsWith('is') && fname != 'jumble') {
      if (fname.startsWith('lt')) {
        fmax = arbitraryLimit;
      } else {
        fmax = maxResult! * maxResult!;
      }
    }
    final values =
        _evaluateWithPinnedVariables(expression.right, min: fmin, max: fmax);
    final function = _monadicFunctionRegistry.get(fname);
    if (function != null) {
      var results = <EvaluationResult>[];
      for (var valueResult in values) {
        // Monadic functions return int, convert to num
        var valueValue = valueResult.value.toInt();
        var resultValue = function([valueValue]);
        var result = resultValue
            .where((value) => value >= min && value <= max)
            .map((e) => EvaluationResult(e, valueResult.variableValues))
            .toList();
        if (result.isEmpty) continue;
        results.addAll(result);
      }
      return results;
    }
    throw EvaluatorException(
        'Unknown monadic function: ${expression.operator.lexeme}');
  }

  bool tooManyCombinations(List<String> unpinnedVariables) {
    // Heuristic: if more than 100000 combinations, consider it too many
    const maxCombinations = 100000;
    int combinations = 1;
    for (var variable in unpinnedVariables) {
      final possibleValues = puzzle.variables.containsKey(variable)
          ? puzzle.variables[variable]!.possibleValues
          : puzzle.clues[variable]!.possibleValues;
      if (possibleValues == null) {
        return true; // No possible values means cannot evaluate yet
      }
      combinations *= possibleValues.length;
      if (combinations > maxCombinations) {
        return true;
      }
    }
    return false;
  }
}

/// An error thrown when the evaluator encounters an error.
class EvaluatorException implements Exception {
  String? msg;
  EvaluatorException([this.msg]);
}

/// An error thrown when the evaluator encounters an expression that is too slow
class EvaluatorNotPossiblexception implements Exception {
  String? msg;
  EvaluatorNotPossiblexception([this.msg]);
}
