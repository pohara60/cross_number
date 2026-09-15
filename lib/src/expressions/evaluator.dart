import 'dart:math';

import 'package:crossnumber/src/expressions/cartesian.dart';
import 'package:crossnumber/src/expressions/polyadic.dart';
import '../models/evaluation_result.dart';
import '../models/expressable.dart';
import '../models/puzzle_definition.dart';
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
  static final MonadicFunctionRegistry _monadicFunctionRegistry = MonadicFunctionRegistry();
  static final PolyadicFunctionRegistry _polyadicFunctionRegistry = PolyadicFunctionRegistry();
  Map<String, int> _pinnedVariables;
  String? _selfReferenceId;
  Set<int>? _selfValues;

  // The minimum and maximum result values for the evaluation
  num? minResult;
  num? maxResult;
  // Previously known results for the evaluation, used for hard-coded #result generator
  List<int>? knownResults;

  /// Creates a new evaluator with the given [puzzle] context.
  Evaluator(this.puzzle) : _pinnedVariables = {};
  Evaluator copyWith({Map<String, int>? pinnedVariables}) {
    return Evaluator(puzzle)
      .._pinnedVariables = pinnedVariables ?? _pinnedVariables
      ..minResult = minResult
      ..maxResult = maxResult
      ..knownResults = knownResults
      .._selfReferenceId = _selfReferenceId
      .._selfValues = _selfValues;
  }

  /// Evaluates the given [expressable] and returns a list of [EvaluationFinalResult]
  /// containing the evaluated values and their corresponding variable values.
  List<EvaluationFinalResult> evaluate(Expressable expressable,
      {required int min, required int max, Set<int>? previousResults}) {
    ensureKnownResultSet(min, max, previousResults);

    var results = <EvaluationFinalResult>[];
    var haveResults = false;
    for (var i = 0; i < expressable.expressionTrees.length; i++) {
      final expression = expressable.expressionTrees[i];
      final variables = expressable.variableLists[i];
      try {
        final selfReferences = variables.contains(expressable.id);
        final candidates = haveResults
            ? _candidatesForExpression(results, variables, selfReferences)
            : _initialCandidates(previousResults, selfReferences);
        final useCandidates = candidates.isNotEmpty && _candidateSearchIsSmaller(variables, candidates);
        final expressionResults = _evaluateExpressionWithCandidates(
          expression,
          variables,
          min: min,
          max: max,
          candidates: useCandidates ? candidates : const [],
          restrictSelfReference: useCandidates && (haveResults || previousResults != null),
          selfReferenceId: useCandidates && selfReferences ? expressable.id : null,
        );
        // If expression involved this expressable, then the result value must match the expressable's value
        if (variables.contains(expressable.id) &&
            expressionResults.every((r) => r.variableValues.containsKey(expressable.id))) {
          expressionResults.removeWhere((r) => r.value != r.variableValues[expressable.id]);
        }
        if (selfReferences && previousResults != null && i == 0) {
          expressionResults.removeWhere((r) => !previousResults.contains(r.value));
        }
        if (!haveResults) {
          results = expressionResults;
          haveResults = true;
        } else {
          results = resultsIntersection(results, expressionResults);
        }
      } on EvaluatorNotPossibleException {
        // If all expressions cannot be evaluated, then rethrow the exception
        if (!haveResults && i == expressable.expressionTrees.length - 1) {
          rethrow;
        }
      }
    }
    return results.toList();
  }

  bool _candidateSearchIsSmaller(List<String> variables, List<_EvaluationCandidate> candidates) {
    var combinations = 1;
    for (final variable in variables) {
      if (_pinnedVariables.containsKey(variable)) continue;
      final possibleValues = puzzle.getExpressable(variable).possibleValues;
      if (possibleValues == null) return true;
      combinations *= possibleValues.length;
      if (combinations >= candidates.length * 2) continue;
    }
    return candidates.length * 2 < combinations;
  }

  List<_EvaluationCandidate> _initialCandidates(Set<int>? previousResults, bool selfReferences) {
    if (!selfReferences || previousResults == null) return const [];
    return previousResults.map((value) => _EvaluationCandidate({}, value)).toList();
  }

  List<_EvaluationCandidate> _candidatesForExpression(
      List<EvaluationFinalResult> results, List<String> variables, bool selfReferences) {
    final candidates = <_EvaluationCandidate>[];
    for (final result in results) {
      final assignment = <String, int>{};
      for (final variable in variables) {
        final value = result.variableValues[variable];
        if (value != null) assignment[variable] = value;
      }
      final candidate = _EvaluationCandidate(assignment, selfReferences ? result.value : null);
      if (!candidates.contains(candidate)) candidates.add(candidate);
    }
    return candidates;
  }

  List<EvaluationFinalResult> _evaluateExpressionWithCandidates(Expression expression, List<String> variables,
      {required int min,
      required int max,
      required List<_EvaluationCandidate> candidates,
      required bool restrictSelfReference,
      String? selfReferenceId}) {
    if (candidates.isEmpty && selfReferenceId != null && restrictSelfReference) return [];
    if (candidates.isEmpty) return evaluateExpression(expression, variables, min: min, max: max);

    final results = <EvaluationFinalResult>[];
    for (final candidate in candidates) {
      final pinnedVariables = Map<String, int>.from(_pinnedVariables);
      var consistent = true;
      for (final entry in candidate.variableValues.entries) {
        final existingValue = pinnedVariables[entry.key];
        if (existingValue != null && existingValue != entry.value) {
          consistent = false;
          break;
        }
        pinnedVariables[entry.key] = entry.value;
      }
      if (selfReferenceId != null && candidate.selfValue != null) {
        final existingValue = pinnedVariables[selfReferenceId];
        if (existingValue != null && existingValue != candidate.selfValue) continue;
        pinnedVariables[selfReferenceId] = candidate.selfValue!;
      }
      if (!consistent) continue;

      final evaluator = copyWith(pinnedVariables: pinnedVariables)
        .._selfReferenceId = selfReferenceId
        .._selfValues = candidate.selfValue == null ? null : {candidate.selfValue!};
      final candidateResults = evaluator.evaluateExpression(expression, variables, min: min, max: max);
      results.addAll(candidateResults);
    }
    return results.toSet().toList();
  }

  /// Evaluates the given [expression] with the provided [variables] and returns
  /// a list of [EvaluationFinalResult] containing the evaluated values and their
  /// corresponding variable values.
  List<EvaluationFinalResult> evaluateExpression(Expression expression, List<String> variables,
      {required int min, required int max, Set<int>? previousResults}) {
    ensureKnownResultSet(min, max, previousResults);
    // Some variables may be pinned already
    var unpinnedVariables = variables.where((v) => !_pinnedVariables.containsKey(v)).toList();
    var combinations = tooManyCombinations(unpinnedVariables);
    if (combinations != null) {
      throw EvaluatorNotPossibleException(
          'Too many combinations $combinations for variables: ${unpinnedVariables.join(', ')}');
    }
    final results = _internalEvaluate(expression, unpinnedVariables, min: min as num, max: max as num);
    return results
        .where((r) => r.value.isFinite && r.value.truncate() == r.value)
        .map((r) => EvaluationFinalResult(r.value.toInt(), r.variableValues))
        .where((r) => r.value >= min && r.value <= max)
        .toSet()
        .toList();
  }

  /// Evaluates the given [expressable] and returns a list of integer results
  /// that fall within the specified [min] and [max] range.
  List<int> evaluateNoVariables(Expressable expressable, {required int min, required int max}) {
    ensureKnownResultSet(min, max);
    var results = <int>{};
    for (var i = 0; i < expressable.expressionTrees.length; i++) {
      final expression = expressable.expressionTrees[i];
      final variables = expressable.variableLists[i];
      final expressionResults = evaluateExpressionNoVariables(expression, variables, min: min, max: max);
      if (i == 0) {
        results = expressionResults.toSet();
      } else {
        results = results.intersection(expressionResults.toSet());
      }
      if (results.isEmpty) {
        // No results possible, so no need to continue evaluating other expressions
        break;
      }
    }
    return results.toList();
  }

  /// Evaluates the given [expression] with the provided [variables] and returns
  /// a list of integer results that fall within the specified [min] and [max] range.
  List<int> evaluateExpressionNoVariables(Expression expression, List<String> variables,
      {required int min, required int max}) {
    ensureKnownResultSet(min, max);
    // Some variables may be pinned already
    var unpinnedVariables = variables.where((v) => !_pinnedVariables.containsKey(v)).toList();
    final results = _internalEvaluate(expression, unpinnedVariables, min: min as num, max: max as num);
    return results
        .where((r) => r.value.isFinite && r.value.truncate() == r.value)
        .map((r) => r.value.toInt())
        .where((r) => r >= min && r <= max)
        .toSet()
        .toList();
  }

  List<EvaluationResult> _internalEvaluate(Expression expression, List<String> unpinnedVariables,
      {required num min, required num max}) {
    if (unpinnedVariables.isEmpty) {
      return _evaluateWithPinnedVariables(expression, min: min, max: max);
    }

    final results = <EvaluationResult>{};
    final currentVariable = unpinnedVariables.first;
    final newUnpinnedVariables = unpinnedVariables.sublist(1);

    var expressable = puzzle.getExpressable(currentVariable);
    final possibleValues = expressable.possibleValues!;

    for (final value in possibleValues) {
      // Check for duplicate variable values
      if (_pinnedVariables.containsValue(value)) continue;

      final newPinnedVariables = Map<String, int>.from(_pinnedVariables);
      newPinnedVariables[currentVariable] = value;

      final evaluator = copyWith(pinnedVariables: newPinnedVariables);
      final result = evaluator._internalEvaluate(expression, newUnpinnedVariables, min: min, max: max);
      results.addAll(result);
    }

    return results.toList();
  }

  List<EvaluationResult> _evaluateWithPinnedVariables(Expression expression, {required num min, required num max}) {
    return expression.accept(this, min: min, max: max);
  }

  @override
  List<EvaluationResult> visitNumberExpression(NumberExpression expression, {required num min, required num max}) {
    final value = expression.value;
    // Hack! Do not impose range check for constants
    // if (value >= min && value <= max)
    return [EvaluationResult(value, {})];
  }

  @override
  List<EvaluationResult> visitVariableExpression(VariableExpression expression, {required num min, required num max}) {
    // Check for pinned variable first
    if (_pinnedVariables.containsKey(expression.name)) {
      final value = _pinnedVariables[expression.name]!;
      if (value >= min && value <= max) {
        return [
          EvaluationResult(value, {expression.name: value})
        ];
      }
      return [];
    }
    // If not pinned, self-reference values may be restricted
    if (expression.name == _selfReferenceId && _selfValues != null) {
      return _selfValues!
          .where((value) => value >= min && value <= max)
          .map((value) => EvaluationResult(value, {expression.name: value}))
          .toList();
    }
    // Expressale possible values
    var expressable = puzzle.getExpressable(expression.name);
    return (expressable.possibleValues ?? <int>{})
        .where((value) => value >= min && value <= max)
        .map((e) => EvaluationResult(e, {expression.name: e}))
        .toList();
  }

  @override
  List<EvaluationResult> visitGeneratorExpression(GeneratorExpression expression,
      {required num min, required num max}) {
    // Hard-coded #results generator returns previous values
    if (expression.name == 'result') {
      if (knownResults == null) {
        throw EvaluatorException('No known results for generator #result');
      }
      return knownResults!.map((e) => EvaluationResult(e, {})).toList();
    }
    final generator = _generatorRegistry.get(expression.name);
    if (generator != null) {
      return generator.getValues(min.ceil(), max.floor()).map((e) => EvaluationResult(e, {})).toList();
    }
    throw EvaluatorException('Unknown generator: ${expression.name}');
  }

  @override
  List<EvaluationResult> visitBinaryExpression(BinaryExpression expression, {required num min, required num max}) {
    num leftMin = -max;
    num leftMax = max;
    // TODO If child nodes only have one value, then we can compute it and use that value to compuute the min/max for the other side.
    leftMin = -arbitraryLimit;
    leftMax = arbitraryLimit;
    final leftValues = _evaluateWithPinnedVariables(expression.left, min: leftMin, max: leftMax);
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
          if (min > 0 && max > 0) {
            rightMin = left / max;
            rightMax = left / min;
          } else if (min < 0 && max < 0) {
            rightMax = left / max;
            rightMin = left / min;
          } else {
            // Really there are two ranges that do not include a range around zero
            rightMin = -1000;
            rightMax = 1000;
          }
          if (rightMin > rightMax) {
            (rightMin, rightMax) = (rightMax, rightMin);
          }
          break;
        case TokenType.MODULUS:
          rightMin = 1;
          rightMax = leftMax;
          break;
        case TokenType.EXPONENT:
          if (left == 0) continue;
          if (min < 1) min = 1;
          rightMin = left <= 1 ? 2 : log(min) / log(left);
          if (rightMin == 0) rightMin = 1; // Avoid zero exponent
          rightMax = left <= 1 ? max : log(max) / log(left);
          break;
        case TokenType.EQUAL:
        case TokenType.AMPERSAND:
        case TokenType.LESS:
        case TokenType.GREATER:
          rightMin = leftMin;
          rightMax = leftMax;
          break;
        default:
          throw EvaluatorException('Unknown binary operator: ${expression.operator.type}');
      }
      final rightValues = _evaluateWithPinnedVariables(expression.right, min: rightMin, max: rightMax);
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
          case TokenType.MODULUS:
            if (right != 0) {
              resultValue = left % right;
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
          case TokenType.LESS:
            if (left >= right) continue;
            resultValue = left;
            break;
          case TokenType.GREATER:
            if (left <= right) continue;
            resultValue = left;
            break;
          case TokenType.AMPERSAND:
            // Existence of both sides is enough to return a value
            resultValue = left;
            break;
          default:
            throw EvaluatorException('Unknown binary operator: ${expression.operator.type}');
        }
        // compute the intersection of left and right variableValues for common variables
        final leftVariableValues = leftResult.variableValues;
        final rightVariableValues = rightResult.variableValues;
        var consistent = true;
        for (var key in leftVariableValues.keys) {
          if (rightVariableValues.containsKey(key) && leftVariableValues[key] != rightVariableValues[key]) {
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
  List<EvaluationResult> visitIfExpression(IfExpression expression, {required num min, required num max}) {
    final conditionResults = _evaluateWithPinnedVariables(
      expression.condition,
      min: -arbitraryLimit > min ? min : -arbitraryLimit,
      max: arbitraryLimit < max ? max : arbitraryLimit,
    );
    if (conditionResults.isEmpty) return [];

    final valueResults = _evaluateWithPinnedVariables(expression.value, min: min, max: max);
    final results = <EvaluationResult>{};
    for (final conditionResult in conditionResults) {
      for (final valueResult in valueResults) {
        final variableValues = <String, int>{...conditionResult.variableValues};
        var consistent = true;
        for (final entry in valueResult.variableValues.entries) {
          final existingValue = variableValues[entry.key];
          if (existingValue != null && existingValue != entry.value) {
            consistent = false;
            break;
          }
          variableValues[entry.key] = entry.value;
        }
        if (consistent) {
          results.add(EvaluationResult(valueResult.value, variableValues));
        }
      }
    }
    return results.toList();
  }

  @override
  List<EvaluationResult> visitUnaryExpression(UnaryExpression expression, {required num min, required num max}) {
    var type = expression.operator.type;
    var rightMin = type == TokenType.MINUS ? -max : min;
    var rightMax = type == TokenType.MINUS ? -min : max;
    final rightValues = _evaluateWithPinnedVariables(expression.right, min: rightMin, max: rightMax);
    final results = <EvaluationResult>{};
    for (final rightResult in rightValues) {
      final right = rightResult.value;
      switch (type) {
        case TokenType.MINUS:
          results.add(EvaluationResult(-right, rightResult.variableValues));
          break;
        case TokenType.REVERSE:
          final reversed = int.parse(right.toInt().toString().split('').reversed.join(''));
          results.add(EvaluationResult(reversed, rightResult.variableValues));
          break;
        default:
          throw EvaluatorException('Invalid unary operator.');
      }
    }
    return results.toList();
  }

  @override
  List<EvaluationResult> visitGroupingExpression(GroupingExpression expression, {required num min, required num max}) {
    return _evaluateWithPinnedVariables(expression.expression, min: min, max: max);
  }

  @override
  List<EvaluationResult> visitGridReferenceExpression(GridReferenceExpression expression,
      {required num min, required num max}) {
    final referenceId = '${expression.gridId}.${expression.referenceId}';
    if (referenceId == _selfReferenceId && _selfValues != null) {
      return _selfValues!
          .where((value) => value >= min && value <= max)
          .map((value) => EvaluationResult(value, {}))
          .toList();
    }
    final expressable = puzzle.getExpressable(referenceId);
    if (expressable.possibleValues == null) return [];
    return expressable.possibleValues!
        .where((value) => value >= min && value <= max)
        .map((e) => EvaluationResult(e, {}))
        .toList();
  }

  @override
  List<EvaluationResult> visitMonadicExpression(MonadicExpression expression, {required num min, required num max}) {
    // Heuristic for min/max of argument to function
    num fmin = 1;
    num fmax = max;
    final fname = expression.operator.lexeme;
    final maxOp = _monadicFunctionRegistry.getMaxOp(fname);
    if (maxOp == MonadicMaxOp.double) {
      fmax = max * 2;
    } else if (maxOp == MonadicMaxOp.limit) {
      fmax = arbitraryLimit;
    } else if (maxOp == MonadicMaxOp.square) {
      fmax = maxResult! * maxResult!;
    } else if (maxOp == MonadicMaxOp.cube) {
      fmax = maxResult! * maxResult! * maxResult!;
    } else {
      fmax = max;
    }
    final values = _evaluateWithPinnedVariables(expression.right, min: fmin, max: fmax);
    final function = _monadicFunctionRegistry.get(fname);
    if (function != null) {
      var results = <EvaluationResult>[];
      for (var valueResult in values) {
        // Monadic functions return int, convert to num
        var valueValue = valueResult.value.toInt();
        var resultValue = function([valueValue], min: min.toInt(), max: max.toInt());
        var result = resultValue
            .where((value) => value >= min && value <= max)
            .map((e) => EvaluationResult(e, valueResult.variableValues))
            .toList();
        if (result.isEmpty) continue;
        results.addAll(result);
      }
      return results;
    }
    throw EvaluatorException('Unknown monadic function: ${expression.operator.lexeme}');
  }

  @override
  List<EvaluationResult> visitPolyadicExpression(PolyadicExpression expression, {required num min, required num max}) {
    // Heuristic for min/max of argument to function
    num fmin = 1;
    num fmax = max;
    final fname = expression.operator.lexeme;
    final maxOp = _polyadicFunctionRegistry.getMaxOp(fname);
    if (maxOp == PolyadicMaxOp.double) {
      fmax = max * 2;
    } else if (maxOp == PolyadicMaxOp.limit) {
      fmax = arbitraryLimit;
    } else if (maxOp == PolyadicMaxOp.square) {
      fmax = maxResult! * maxResult!;
    } else if (maxOp == PolyadicMaxOp.cube) {
      fmax = maxResult! * maxResult! * maxResult!;
    } else {
      fmax = max;
    }
    var args = <List<EvaluationResult>>[];
    var results = <EvaluationResult>[];
    for (final operand in expression.operands) {
      var operandValues = _evaluateWithPinnedVariables(operand, min: fmin, max: fmax);
      if (operandValues.isEmpty) {
        // No results
        return results;
      }
      args.add(operandValues);
    }
    final function = _polyadicFunctionRegistry.get(fname);
    if (function != null) {
      for (var arguments in cartesian(args)) {
        // Check that all variableValues are consistent across arguments
        var variableValues = <String, int>{};
        var consistent = true;
        var values = <int>[];
        for (var arg in arguments) {
          for (var key in arg.variableValues.keys) {
            if (variableValues.containsKey(key) && variableValues[key] != arg.variableValues[key]) {
              consistent = false;
              break;
            }
            variableValues[key] = arg.variableValues[key]!;
          }
          if (!consistent) break;
          values.add(arg.value.toInt());
        }
        if (!consistent) continue;
        var resultValue = function(values, min: min.toInt(), max: max.toInt());
        var result = resultValue
            .where((value) => value >= min && value <= max)
            .map((e) => EvaluationResult(e, variableValues))
            .toList();
        if (result.isEmpty) continue;
        results.addAll(result);
      }
      return results;
    }
    throw EvaluatorException('Unknown Polyadic function: ${expression.operator.lexeme}');
  }

  int? tooManyCombinations(List<String> unpinnedVariables) {
    // Heuristic: if more than 100000 combinations, consider it too many
    const maxCombinations = 1000000;
    int combinations = 1;
    for (var variable in unpinnedVariables) {
      var expressable = puzzle.getExpressable(variable);
      final possibleValues = expressable.possibleValues;
      if (possibleValues == null) {
        return 0; // No possible values means cannot evaluate yet
      }
      combinations *= possibleValues.length;
    }
    if (combinations > maxCombinations) {
      return combinations;
    }
    return null;
  }

  void ensureKnownResultSet(int min, int max, [Set<int>? previousResults]) {
    minResult ??= min;
    maxResult ??= max;
    if (previousResults != null && knownResults == null) {
      knownResults = previousResults.toList()..sort();
      if (knownResults!.isNotEmpty) {
        minResult = knownResults!.first;
        maxResult = knownResults!.last;
      }
    }
  }
}

List<EvaluationFinalResult> resultsIntersection(
    List<EvaluationFinalResult> results, List<EvaluationFinalResult> expressionResults) {
  final resultMap = <int, List<Map<String, int>>>{};
  var resultVariables = <int, List<String>>{};
  for (var r in results) {
    resultMap.putIfAbsent(r.value, () => <Map<String, int>>[]).add(r.variableValues);
    resultVariables.putIfAbsent(r.value, () => <String>[]).addAll(r.variableValues.keys);
  }
  final matchingResults = <int, List<EvaluationFinalResult>>{};
  for (var r in expressionResults) {
    if (resultMap.containsKey(r.value)) {
      var listVariables = resultVariables[r.value]!;
      var listVariableValues = resultMap[r.value]!;
      var matchVariables = listVariables.where((v) => r.variableValues.containsKey(v));
      if (matchVariables.isNotEmpty) {
        var match = r.variableValues.entries.every((e) =>
            !matchVariables.contains(e.key) ||
            listVariableValues.any((m) => m.containsKey(e.key) && m[e.key]! == e.value));
        if (!match) continue;
        matchVariables.every((v) => false);
      }
      matchingResults.putIfAbsent(r.value, () => []).add(r);
    }
  }
  final finalResults = <EvaluationFinalResult>[];
  final seen = <String>{};
  const maxMergedPairs = 1000;
  matchingResults.forEach((value, rightResults) {
    final leftResults = resultMap[value]!;
    if (leftResults.length * rightResults.length > maxMergedPairs) {
      for (final left in leftResults) {
        final resultKey = '$value:${left.entries.map((entry) => '${entry.key}=${entry.value}').join(',')}';
        if (seen.add(resultKey)) finalResults.add(EvaluationFinalResult(value, left));
      }
      for (final right in rightResults) {
        final resultKey =
            '$value:${right.variableValues.entries.map((entry) => '${entry.key}=${entry.value}').join(',')}';
        if (seen.add(resultKey)) finalResults.add(EvaluationFinalResult(value, right.variableValues));
      }
      return;
    }
    for (final right in rightResults) {
      for (final left in leftResults) {
        final variableValues = <String, int>{...left};
        var consistent = true;
        for (final entry in right.variableValues.entries) {
          final existingValue = variableValues[entry.key];
          if (existingValue != null && existingValue != entry.value) {
            consistent = false;
            break;
          }
          variableValues[entry.key] = entry.value;
        }
        if (!consistent) continue;
        final resultKey = '$value:${variableValues.entries.map((entry) => '${entry.key}=${entry.value}').join(',')}';
        if (seen.add(resultKey)) {
          finalResults.add(EvaluationFinalResult(value, variableValues));
        }
      }
    }
  });
  return finalResults;
}

bool _mapsEqual(Map<String, int> first, Map<String, int> second) {
  if (first.length != second.length) return false;
  return first.entries.every((entry) => second[entry.key] == entry.value);
}

class _EvaluationCandidate {
  final Map<String, int> variableValues;
  final int? selfValue;

  _EvaluationCandidate(this.variableValues, this.selfValue);

  @override
  bool operator ==(Object other) {
    return other is _EvaluationCandidate &&
        selfValue == other.selfValue &&
        _mapsEqual(variableValues, other.variableValues);
  }

  @override
  int get hashCode => Object.hash(
      selfValue, Object.hashAll(variableValues.entries.map((entry) => Object.hash(entry.key, entry.value))));
}

/// An error thrown when the evaluator encounters an error.
class EvaluatorException implements Exception {
  String? msg;
  EvaluatorException([this.msg]);
}

/// An error thrown when the evaluator encounters an expression that is too slow
class EvaluatorNotPossibleException implements Exception {
  String? msg;
  EvaluatorNotPossibleException([this.msg]);
}
