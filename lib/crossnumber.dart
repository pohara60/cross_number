/// An API for solving Cross Number puzzles.
library crossnumber;

import 'package:collection/collection.dart' show PriorityQueue;
import 'package:crossnumber/set.dart';
import 'dart:math';
import 'package:powers/powers.dart';

import 'package:crossnumber/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/monadic.dart';

import 'cartesian.dart';
import 'variable.dart';

/// Provide access to the Cross Number API.
class Crossnumber<PuzzleKind extends Puzzle<Clue, Clue>> {
  late PuzzleKind puzzle;

  static const bool traceInit = true;
  static const bool traceSolve = true;

  Crossnumber();

  void initCrossnumber() {
    if (traceInit) {
      print(puzzle.toString());
    }
  }

  var updateQueue = <Variable>[];
  var priorityQueue = PriorityQueue<Variable>((a, b) => -(b as PriorityVariable)
      .priority
      .compareTo((a as PriorityVariable).priority));

  void addToUpdateQueue(Variable clue) {
    if ((puzzle is VariablePuzzle) &&
        (puzzle as VariablePuzzle).hasVariables &&
        (clue is VariableClue || clue is ExpressionVariable)) {
      if (clue is VariableClue)
        (puzzle as VariablePuzzle).updateCluePriority(clue);
      if (clue is ExpressionVariable)
        (puzzle as VariablePuzzle).updateVariablePriority(clue);

      if (priorityQueue.contains(clue)) {
        priorityQueue.remove(clue);
      }
      //print('addToUpdateQueue(${clue.name}), count=${clue.count}');
      priorityQueue.add(clue);
    } else {
      if (!updateQueue.contains(clue)) {
        updateQueue.add(clue);
      }
    }
  }

  Variable takeFromUpdateQueue() {
    if (priorityQueue.isNotEmpty) {
      var clue = priorityQueue.removeFirst();
      //print('takeFromUpdateQueue()=${clue.name}), count=${clue.count}');
      return clue;
    } else {
      return updateQueue.removeAt(0);
    }
  }

  bool updateQueueIsNotEmpty() {
    return priorityQueue.isNotEmpty || updateQueue.isNotEmpty;
  }

  void solve([bool iteration = true]) {
    bool updated;
    var iterations = 0;
    var updates = 0;
    var remainingClues = List<Variable>.from(puzzle.clues.values).toList();

    if (traceSolve) {
      print("UPDATES-----------------------------");
    }

    final stopwatch = Stopwatch()..start();
    Variable? firstExceptionClue;
    bool skipExceptionClues = false;
    Variable? previousClue;
    var exceptionClues = <Variable>[];
    while (remainingClues.isNotEmpty) {
      remainingClues.forEach((clue) {
        addToUpdateQueue(clue);
      });
      remainingClues.clear();
      exceptionClues.forEach((clue) {
        addToUpdateQueue(clue);
      });
      exceptionClues.clear();

      while (updateQueueIsNotEmpty()) {
        Variable clueOrVariable = takeFromUpdateQueue();
        if (clueOrVariable == previousClue) {
          remainingClues.add(clueOrVariable);
          continue;
        }
        previousClue = clueOrVariable;

        iterations++;
        try {
          var referrers = <Variable>[];
          if (clueOrVariable is Clue) {
            updated = solveClue(clueOrVariable);
            referrers.addAll(clueOrVariable.referrers);
            // Add variables that clue uses
            // if (puzzle is VariablePuzzle) {
            //   for (var variableName in clueOrVariable.variableReferences) {
            //     var variable =
            //         (puzzle as VariablePuzzle).variables[variableName]!;
            //     if (variable is ExpressionVariable) referrers.add(variable);
            //   }
            // }
          } else {
            updated = solveVariable(clueOrVariable as ExpressionVariable);
            referrers = clueOrVariable.referrers;
          }
          if (updated) {
            for (var referrer in referrers) {
              addToUpdateQueue(referrer);
            }
            updates++;
            firstExceptionClue = null;
            skipExceptionClues = false;
          }
        } on SolveException {
          // Put clue back at end of queue until no update since this clue
          if (firstExceptionClue == clueOrVariable) {
            skipExceptionClues = true;
          } else {
            if (!skipExceptionClues) {
              addToUpdateQueue(clueOrVariable);
              if (firstExceptionClue == null) {
                firstExceptionClue = clueOrVariable;
              }
            } else {
              exceptionClues.add(clueOrVariable);
            }
          }
        }
      }
    }
    if (traceSolve) {
      print(
          'Clue/Variable iterations=$iterations, updates=$updates, elapsed ${stopwatch.elapsed}');
    }

    // Unique solution?
    if (!puzzle.uniqueSolution()) {
      if (Crossnumber.traceSolve) {
        print("PARTIAL SOLUTION-----------------------------");
        print(puzzle.toSummary());
        // print(puzzle.toString());
      }
      puzzle.postProcessing(iteration);
    } else {
      print("SOLUTION-----------------------------");
      print(puzzle.toSummary());
    }
  }

  bool solveClue(Clue clue) {
    // If clue solved already then skip it
    // Can no longer do this because clue can be set by other clues
    // if (clue.values != null && clue.values!.length == 1) return false;

    var updated = false;
    if (clue.initialise()) updated = true;

    if (clue.solve != null) {
      var possibleValue = <int>{};
      var possibleVariables = <String, Set<int>>{};
      var updatedVariables = <String>{};
      var updatedClues = <String>{};
      if (clue is VariableClue) {
        for (var variableName in clue.variableClueReferences) {
          possibleVariables[variableName] = <int>{};
        }
        if (clue.solve!(clue, possibleValue, possibleVariables)) updated = true;
      } else {
        if (clue.solve!(clue, possibleValue)) updated = true;
      }
      // If no Values returned then Solve function could not solve
      if (possibleValue.isEmpty) {
        print(
            'Solve Error: clue ${clue.name} (${clue.valueDesc}) no solution!');
        throw SolveException();
      }
      if (puzzle.updateValues(clue, possibleValue)) updated = true;
      if (clue.finalise()) updated = true;
      if (clue is VariableClue) {
        for (var variableName in clue.variableReferences) {
          if (possibleVariables[variableName] != null) {
            updateVariables(variableName, possibleVariables[variableName]!,
                updatedVariables);
          }
        }
        for (var clueName in clue.clueReferences) {
          if (possibleVariables[clueName] != null) {
            if (updateClues(clueName, possibleVariables[clueName]!))
              updatedClues.add(clueName);
          }
        }
      }

      if (traceSolve && updated) {
        print("solve: ${clue.toString()}");
        if (clue is VariableClue) {
          var variableList = (puzzle as VariablePuzzle).variableList;
          for (var variableName in updatedVariables) {
            print(
                '$variableName=${variableList.variables[variableName]!.values!.toShortString()}');
          }
          for (var clueName in updatedClues) {
            print(
                '$clueName=${puzzle.clues[clueName]!.values!.toShortString()}');
          }
        }
      }
    }
    return updated;
  }

  bool updateVariables(String variableName, Set<int> possibleValues,
      Set<String> updatedVariables) {
    if (puzzle is VariablePuzzle) {
      var variablePuzzle = puzzle as VariablePuzzle;
      updatedVariables
          .addAll(variablePuzzle.updateVariables(variableName, possibleValues));
      // Schedule updated variables for update
      // for (var variableName in updatedVariables) {
      //   var variable = variablePuzzle.variables[variableName]!;
      //   addToUpdateQueue(variable);
      // }
      // Schedule referencing clues for update
      for (var clue in puzzle.clues.values) {
        if (clue is VariableClue) {
          if (clue.variableReferences
              .any((element) => updatedVariables.contains(element))) {
            addToUpdateQueue(clue);
          }
        }
      }
      // Schedule referencing variables for update
      for (var variable in variablePuzzle.variables.values) {
        if (variable is ExpressionVariable) {
          if (variable.variableReferences
              .any((element) => updatedVariables.contains(element))) {
            addToUpdateQueue(variable);
          }
        }
      }
      return updatedVariables.length > 0;
    }
    return false;
  }

  bool updateClues(String clueName, Set<int> possibleValues) {
    var clue = puzzle.clues[clueName]!;
    var updated = clue.updateValues(possibleValues);
    if (updated) {
      // Schedule clue for update (to check digits)
      addToUpdateQueue(clue);
      // Schedule referencing clues for update
      for (var referrer in clue.referrers) {
        addToUpdateQueue(referrer);
      }
      // Schedule referenced variables for update
      if (puzzle is VariablePuzzle) {
        var variablePuzzle = puzzle as VariablePuzzle;

        for (var variableName in clue.variableReferences) {
          var variable = variablePuzzle.variables[variableName]!;
          if (variable is ExpressionVariable) {
            addToUpdateQueue(variable);
          }
        }
        return true;
      }
    }
    return false;
  }

  bool validVariable(ExpressionVariable variable, int value,
      List<String> variableReferences, List<int> variableValues) {
    // if no values so far, then all valid
    if (variable.values == null) return true;
    return variable.values!.contains(value);
  }

  bool solveVariable(ExpressionVariable variable) {
    // If variable solved already then skip it
    // Can no longer do this because variable can be set by other clues/variable
    // if (variable.values != null && variable.values!.length == 1) return false;

    var updated = false;
    var puzzle = this.puzzle as VariablePuzzle;
    var possibleValue = <int>{};
    var possibleVariables = <String, Set<int>>{};

    for (var variable in variable.variableReferences) {
      possibleVariables[variable] = <int>{};
    }

    if (variable.solve!(variable, possibleValue, possibleVariables))
      updated = true;
    // If no Values returned then Solve function could not solve
    if (possibleValue.isEmpty) {
      print(
          'Solve Error: variable ${variable.name} (${variable.valueDesc}) no solution!');
      throw SolveException();
    }
    var updatedVariables = <String>{};
    if (updateVariables(variable.name, possibleValue, updatedVariables)) {
      updated = true;
    }
    // Update variable references even if this variable not updated, because may
    // have been set elsewhere
    for (var variableName in variable.variableReferences) {
      if (updateVariables(
          variableName, possibleVariables[variableName]!, updatedVariables)) {
        updated = true;
      }
    }

    if (traceSolve && updated) {
      print("solve: ${variable.runtimeType}(${variable.toString()})");
      var variableList = puzzle.variableList;
      for (var variableName in updatedVariables) {
        print(
            '$variableName=${variableList.variables[variableName]!.values.toString()}');
      }
    }

    return updated;
  }
}

const List<int> twoDigitPrimes = [
  11,
  13,
  17,
  19,
  23,
  29,
  31,
  37,
  41,
  43,
  47,
  53,
  59,
  61,
  67,
  71,
  73,
  79,
  83,
  89,
  97
];

Map<int, Set<int>> getSumTwoPrimes() {
  var primes = <int, Set<int>>{};
  for (var p1 in twoDigitPrimes) {
    for (var p2 in twoDigitPrimes) {
      var sum = p1 + p2;
      if (!primes.containsKey(sum)) {
        primes[sum] = <int>{};
      }
      primes[sum]!.add(p1);
      primes[sum]!.add(p2);
    }
  }
  return primes;
}

List<int> getTwoDigitNumbers() {
  return getNDigitNumbers(2);
}

List<int> getThreeDigitNumbers() {
  return getNDigitNumbers(3);
}

List<int> getFourDigitNumbers() {
  return getNDigitNumbers(4);
}

List<int> getNDigitNumbers(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return List.generate(hi - lo + 1, (index) => lo + index);
}

List<int> getTwoDigitTriangles() {
  return getNDigitTriangles(2);
}

List<int> getThreeDigitTriangles() {
  return getNDigitTriangles(3);
}

List<int> getFourDigitTriangles() {
  return getNDigitTriangles(4);
}

List<int> getFiveDigitTriangles() {
  return getNDigitTriangles(5);
}

List<int> getSevenDigitTriangles() {
  return getNDigitTriangles(7);
}

List<int> getNDigitTriangles(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return getTrianglesInRange(lo, hi);
}

List<int> getTrianglesInRange(int lo, int hi) {
  var triangles = <int>[];
  int index = 1;
  int next = 1;
  while (next <= hi) {
    if (next >= lo) triangles.add(next);
    index++;
    next += index;
  }
  return triangles;
}

List<int> getTwoDigitPyramidal() {
  return getNDigitPyramidal(2);
}

List<int> getThreeDigitPyramidal() {
  return getNDigitPyramidal(3);
}

List<int> getFourDigitPyramidal() {
  return getNDigitPyramidal(4);
}

List<int> getFiveDigitPyramidal() {
  return getNDigitPyramidal(5);
}

List<int> getSevenDigitPyramidal() {
  return getNDigitPyramidal(7);
}

List<int> getNDigitPyramidal(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return getPyramidalInRange(lo, hi);
}

List<int> getPyramidalInRange(int lo, int hi) {
  var pyramidals = <int>[];
  int index = 1;
  int next = 1;
  while (next <= hi) {
    if (next >= lo) pyramidals.add(next);
    index++;
    next += index * index;
  }
  return pyramidals;
}

List<int> getTwoDigitSquares() {
  return getNDigitSquares(2);
}

List<int> getThreeDigitSquares() {
  return getNDigitSquares(3);
}

List<int> getFourDigitSquares() {
  return getNDigitSquares(4);
}

List<int> getSixDigitSquares() {
  return getNDigitSquares(6);
}

List<int> getSevenDigitSquares() {
  return getNDigitSquares(7);
}

List<int> getNDigitSquares(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return getSquaresInRange(lo, hi);
}

List<int> getSquaresInRange(int lo, int hi) {
  var squares = <int>[];
  var loSq = sqrt(lo).ceil();
  var hiSq = sqrt(hi).floor();
  for (var d1 = loSq; d1 <= hiSq; d1++) {
    var value = d1 * d1;
    squares.add(value);
  }
  return squares;
}

List<int> getTwoDigitCubes() {
  return getNDigitCubes(2);
}

List<int> getNDigitCubes(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return getCubesInRange(lo, hi);
}

List<int> getCubesInRange(int lo, int hi) {
  var cubes = <int>[];
  var loRoot = lo.root(3).ceil();
  var hiRoot = hi.root(3).floor();
  for (var d1 = loRoot; d1 <= hiRoot; d1++) {
    var value = d1 * d1 * d1;
    cubes.add(value);
  }
  return cubes;
}

List<int> getTwoDigitPrimes() {
  return getNDigitPrimes(2);
}

List<int> getThreeDigitPrimes() {
  return getNDigitPrimes(3);
}

List<int> getFourDigitPrimes() {
  return getNDigitPrimes(4);
}

List<int> getNDigitPrimes(n) {
  var lo = 10.pow(n - 1) as int;
  var limit = (10.pow(n) as int) - 1;
  var primes = getPrimesInRange(lo, limit);
  return primes;
}

List<int> getPrimesInRange(int lo, int hi) {
  var primes = getPrimesUpto(hi).where((element) => element >= lo).toList();
  return primes;
}

List<int> getPrimesUpto(limit) {
  var hi = limit ~/ 2;
  List<int> sieve = List.generate(hi, (i) => 2 * i + 3);
  for (var i = 0; i < hi; i++) {
    if (sieve[i] != 0) {
      for (var j = i + 1; j < hi; j++) {
        if (sieve[j] % sieve[i] == 0) {
          sieve[j] = 0;
        }
      }
    }
  }
  var primes =
      sieve.where((element) => element != 0 && element <= limit).toList();
  primes.insertAll(0, [1, 2]);
  return primes;
}

List<int> getTwoDigitFibonacci() {
  return getNDigitFibonacci(2);
}

List<int> getThreeDigitFibonacci() {
  return getNDigitFibonacci(3);
}

List<int> getFourDigitFibonacci() {
  return getNDigitFibonacci(4);
}

List<int> getNDigitFibonacci(n) {
  var lo = 10.pow(n - 1) as int;
  var limit = (10.pow(n) as int) - 1;
  var primes = getFibonacciInRange(lo, limit);
  return primes;
}

List<int> getFibonacciInRange(int lo, int hi) {
  var primes = getFibonacciUpto(hi).where((element) => element >= lo).toList();
  return primes;
}

List<int> getFibonacciUpto(limit) {
  var first = 0;
  var second = 1;
  var fibonacci = <int>[];
  var next = 0;
  while ((next = first + second) <= limit) {
    fibonacci.add(next);
    first = second;
    second = next;
  }
  return fibonacci;
}

List<int> getTwoDigitMultipleThreePrimes() {
  return getNDigitMultipleThreePrimes(2);
}

List<int> getFiveDigitMultipleThreePrimes() {
  return getNDigitMultipleThreePrimes(5);
}

List<int> getNDigitMultipleThreePrimes(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = 10.pow(n) as int;
  var primes = getPrimesUpto(hi ~/ 2);
  var products = <int>{};
  for (var p1 in primes.where((p) => p * p * p < hi)) {
    for (var p2 in primes.where((p) => p > p1 && p * p * p1 < hi)) {
      for (var p3 in primes.where((p) => p > p2 && p * p2 * p1 < hi)) {
        var product = p1 * p2 * p3;
        if (product < lo) continue;
        products.add(product);
      }
    }
  }
  return products.toList();
}

List<int> getTwoDigitPowers() {
  return getNDigitPowers(2);
}

List<int> getFourDigitPowers() {
  return getNDigitPowers(4);
}

List<int> getNDigitPowers(n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return getPowersInRange(lo, hi);
}

List<int> getPowersInRange(int lo, int hi, [int? n, int? minPower]) {
  var powers = <int>{};
  var any = true;
  for (var power = minPower ?? 3; any; power++) {
    any = false;
    for (var x = n ?? 2;; x++) {
      var value = x.pow(power) as int;
      if (value > hi) break;
      any = true;
      if (value >= lo) powers.add(value);
      if (n != null) break;
    }
  }
  var result = powers.toList();
  result.sort();
  return result;
}

List<int> getTwoDigitLucas() {
  return getNDigitLucas(2);
}

List<int> getNDigitLucas(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return getLucasInRange(lo, hi);
}

List<int> getLucasInRange(int lo, int hi) {
  var lucas = <int>[2, 1];
  while (true) {
    var value = lucas[lucas.length - 2] + lucas[lucas.length - 1];
    if (value > hi) break;
    lucas.add(value);
  }
  var result = lucas.where((element) => element >= lo).toList();
  return result;
}

List<int> getTwoDigitPalindromes() {
  var palindromes = <int>[];
  for (var d1 = 1; d1 < 10; d1++) {
    var value = d1 * 10 + d1;
    palindromes.add(value);
  }
  return palindromes;
}

List<int> getThreeDigitPalindromes() {
  var palindromes = <int>[];
  for (var d1 = 1; d1 < 10; d1++) {
    for (var d2 = 0; d2 < 10; d2++) {
      var value = d1 * 100 + d2 * 10 + d1;
      palindromes.add(value);
    }
  }
  return palindromes;
}

List<int> getFiveDigitPalindromes() {
  var palindromes = <int>[];
  for (var d1 = 1; d1 < 10; d1++) {
    for (var d2 = 0; d2 < 10; d2++) {
      for (var d3 = 0; d3 < 10; d3++) {
        var value = d1 * 10000 + d2 * 1000 + d3 * 100 + d2 * 10 + d1;
        palindromes.add(value);
      }
    }
  }
  return palindromes;
}

Map<int, Map<String, int>> getThreeDigitPrimeMultiples() {
  var multiples = <int, Map<String, int>>{};
  outer:
  for (var p1 in twoDigitPrimes) {
    var finished = true;
    for (var p2 in twoDigitPrimes.where((element) => element > p1)) {
      var multiple = p1 * p2;
      if (multiple >= 1000) {
        if (finished) break outer;
        break;
      }
      finished = false;
      if (multiple >= 100) {
        multiples[multiple] = {'p1': p1, 'p2': p2};
      }
    }
  }
  return multiples;
}

bool twoDigitPrimeHasReverse(int prime) {
  return primeHasReverse(prime, twoDigitPrimes);
}

bool primeHasReverse(int prime, List<int> primes) {
  var other = reverse(prime);
  return primes.contains(other) && other != prime;
}

bool ascending(int value) {
  var valueStr = value.toString();
  var last = 0;
  for (var index = 0; index < valueStr.length; index++) {
    var next = int.parse(valueStr[index]);
    if (next <= last) return false;
    last = next;
  }
  return true;
}

bool isJumble(int value, int jumble) {
  var valueStr = value.toString();
  var jumbleStr = jumble.toString();
  for (var index = 0; index < valueStr.length; index++) {
    if (!jumbleStr.contains(valueStr[index])) return false;
    jumbleStr.replaceFirst(RegExp(valueStr[index]), '');
  }
  return true;
}

List<int>? getDigitProductEqualsOtherClue(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>{};
    for (var value in other.values!) {
      for (var factor = 2; factor <= value.sqrt().floor(); factor++) {
        if (value % factor == 0) {
          var factor2 = value ~/ factor;
          if (factor2 < 10) {
            values.add(factor * 10 + factor2);
            values.add(factor2 * 10 + factor);
          }
        }
      }
    }
    return List.from(values);
  }
  return null;
}

List<int>? getFactorsOfOtherClue(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>{};
    int loLimit = clue.min;
    if (loLimit < 2) loLimit = 2;
    int hiLimit = clue.max;
    for (var value in other.values!) {
      int lo = loLimit;
      int hi = value ~/ 2;
      if (hi > hiLimit) hi = hiLimit;
      for (var factor = lo; factor <= hi; factor++) {
        if (value % factor == 0) {
          values.add(factor);
        }
      }
    }
    return List.from(values);
  }
  return null;
}

List<int>? getReverseOfOtherClue(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>[];
    for (var value in other.values!) {
      var reverse = 0;
      while (value > 0) {
        reverse = reverse * 10 + value % 10;
        // First digit cannot be 0
        if (reverse == 0) break;
        value = value ~/ 10;
      }
      if (reverse != 0) {
        values.add(reverse);
      }
    }
    return values;
  }
  return null;
}

List<int>? getDigitProductOtherClue(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>{};
    for (var value in other.values!) {
      var product = 1;
      while (value > 0) {
        product *= value % 10;
        value = value ~/ 10;
      }
      values.add(product);
    }
    return List.from(values);
  }
  return null;
}

List<int>? getMultipleOfOtherClue(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>[];
    for (var value in other.values!) {
      var hi = (clue.max) ~/ value;
      for (var i = 2; i <= hi; i++) {
        var multiple = i * value;
        values.add(multiple);
      }
    }
    return values;
  }
  return null;
}

List<int>? getDigitProductEqualsOtherClueProduct(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>{};
    for (var value in other.values!) {
      var product = 1;
      while (value > 0) {
        product *= value % 10;
        value = value ~/ 10;
      }
      for (var factor = 1; factor <= product.sqrt().floor(); factor++) {
        if (factor < 10 && product % factor == 0) {
          for (var factor2 = 1; factor2 <= product.sqrt().floor(); factor2++) {
            var prod2 = factor * factor2;
            if (factor2 < 10 && product % prod2 == 0) {
              var factor3 = product ~/ prod2;
              if (factor3 < 10) {
                values.add(factor * 100 + factor2 * 10 + factor3);
                values.add(factor * 100 + factor3 * 10 + factor2);
                values.add(factor2 * 100 + factor * 10 + factor3);
                values.add(factor2 * 100 + factor3 * 10 + factor);
                values.add(factor3 * 100 + factor2 * 10 + factor);
                values.add(factor3 * 100 + factor * 10 + factor2);
              }
            }
          }
        }
      }
    }
    return List.from(values);
  }
  return null;
}

int sumClueDigits(Clue clue, List<Clue> otherClues, List<int> otherValues) {
  var sum = 0;
  // Sum all otherClues that do not interset with Clue
  // Do not double count digits that appear in Across and Down clues
  var index = 0;
  for (var otherClue in otherClues) {
    var value = otherValues[index].toString();
    // Sum all digits of Across clues
    for (var d = 0; d < otherClue.length; d++) {
      var digit = int.parse(value[d]);
      // Exclude digits that intersect with the Clue
      if (otherClue.digitIdentities[d] != null) {
        if (otherClue.digitIdentities[d]!.clue == clue) digit = 0;
      }
      // Exclude digits of Down clues that intersect with Across clues
      if (otherClue.name[0] == 'D') {
        if (otherClue.digitIdentities[d] != null) digit = 0;
      }
      sum += digit;
    }
    index++;
  }
  return sum;
}

Set<int>? getValuesFromClueDigits(Clue clue) {
  var allDigits =
      List<List<int>>.generate(clue.length, (d) => clue.digits[d].toList());
  var count = cartesianCount(allDigits);
  if (count > 1000) return null;
  var values = <int>{};
  for (var product in cartesian(allDigits, true)) {
    int value = product.reduce((value, element) => value * 10 + element);
    values.add(value);
  }
  return values;
}

List<int>? getMultiplesOfValues(Clue clue, List<int> values) {
  var multiples = <int>[];
  var loResult = clue.min;
  var hiResult = clue.max;
  for (var value in values) {
    var loMultiplier = loResult ~/ value;
    if (loMultiplier < 2) loMultiplier = 2;
    var hiMultiplier = hiResult ~/ value;
    for (var multiplier = loMultiplier;
        multiplier <= hiMultiplier;
        multiplier++) {
      var multiple = multiplier * value;
      if (multiple < loResult) continue;
      if (multiple >= hiResult) continue;
      multiples.add(multiple);
    }
  }
  return multiples;
}

List<int>? getTriangularsLessValues(Clue clue, Set<int> values) {
  var result = <int>{};
  var minInput =
      values.reduce((value, element) => element < value ? element : value);
  var maxInput =
      values.reduce((value, element) => element > value ? element : value);
  var lo = clue.min;
  var hi = clue.max;
  var minTriangle = lo + minInput;
  var maxTriangle = hi + maxInput;
  var triangles = getTrianglesInRange(minTriangle, maxTriangle);
  for (var value in values) {
    for (var triangle in triangles) {
      var difference = triangle - value;
      if (difference < lo) continue;
      if (difference >= hi) continue;
      result.add(difference);
    }
  }
  return List.from(result);
}
