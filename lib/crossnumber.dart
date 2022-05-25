/// An API for solving Cross Number puzzles.
library crossnumber;

import 'package:collection/collection.dart';
import 'dart:math';
import 'package:powers/powers.dart';

import 'package:crossnumber/clue.dart';
import 'package:crossnumber/puzzle.dart';

/// Provide access to the Cross Number API.
class Crossnumber<PuzzleKind extends Puzzle> {
  late PuzzleKind puzzle;

  static const bool traceInit = true;
  static const bool traceSolve = true;

  Crossnumber();

  void initCrossnumber() {
    if (traceInit) {
      print(puzzle.toString());
    }
  }

  var updateQueue = <Clue>[];
  var priorityQueue =
      PriorityQueue<VariableClue>((a, b) => -b.count.compareTo(a.count));

  void addToUpdateQueue(Clue clue) {
    if (clue is VariableClue) {
      (puzzle as VariablePuzzle).updateClueCount(clue);
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

  Clue takeFromUpdateQueue() {
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

  void solve() {
    bool updated;
    var iterations = 0;
    var updates = 0;
    var allClue = List<Clue>.from(puzzle.clues.values).toList();
    allClue.forEach((clue) {
      addToUpdateQueue(clue);
    });

    if (traceSolve) {
      print("UPDATES-----------------------------");
    }

    final stopwatch = Stopwatch()..start();
    Clue? firstExceptionClue;
    bool skipExceptionClues = false;
    while (updateQueueIsNotEmpty()) {
      Clue clue = takeFromUpdateQueue();
      iterations++;
      try {
        updated = solveClue(clue);
        if (updated) {
          for (var referrer in clue.referrers) {
            addToUpdateQueue(referrer);
          }
          updates++;
          firstExceptionClue = null;
          skipExceptionClues = false;
        }
      } on SolveException {
        // Put clue back at end of queue until no update since this clue
        if (firstExceptionClue == clue) {
          skipExceptionClues = true;
        } else {
          if (!skipExceptionClues) {
            addToUpdateQueue(clue);
            if (firstExceptionClue == null) {
              firstExceptionClue = clue;
            }
          }
        }
      }
    }
    if (traceSolve) {
      print(
          'Clue iterations=$iterations, updates=$updates, elapsed ${stopwatch.elapsed}');
    }

    // Unique solution?
    if (!puzzle.uniqueSolution()) {
      puzzle.postProcessing();
    } else {
      print("SOLUTION-----------------------------");
      print(puzzle.toString());
    }
  }

  bool solveClue(Clue clue) {
    // If clue solved already then skip it
    if (clue.values != null && clue.values!.length == 1) return false;

    var updated = false;
    if (clue.initialise()) updated = true;

    if (clue.solve != null) {
      var possibleValue = <int>{};
      var possibleVariables = <String, Set<int>>{};
      if (clue is VariableClue) {
        for (var variable in clue.variableReferences) {
          possibleVariables[variable] = <int>{};
        }
        if (clue.solve!(clue, possibleValue, possibleVariables)) updated = true;
      } else {
        if (clue.solve!(clue, possibleValue)) updated = true;
      }
      // If no Values returned then Solve function could not solve
      if (possibleValue.isEmpty) {
        print('Solve Error: clue ${clue.name} no solution!');
        throw SolveException();
      }
      if (puzzle.updateValues(clue, possibleValue)) updated = true;
      if (clue.finalise()) updated = true;
      if (clue is VariableClue) {
        for (var variable in clue.variableReferences) {
          if (updateVariables(variable, possibleVariables[variable]!))
            updated = true;
        }
      }
    }

    if (traceSolve && updated) {
      print("solve: ${clue.toString()}");
      if (clue is VariableClue) {
        var variableList = (puzzle as VariablePuzzle).variableList;
        for (var variable in clue.variableReferences) {
          print(
              '$variable=${variableList.variables[variable]!.values.toString()}');
        }
      }
    }
    return updated;
  }

  bool updateVariables(String variable, Set<int> possibleValues) {
    if (puzzle is VariablePuzzle) {
      var variablePuzzle = puzzle as VariablePuzzle;
      var updatedVariables =
          variablePuzzle.updateVariables(variable, possibleValues);
      // Schedule referencing clues for update
      for (var clue in puzzle.clues.values) {
        if (clue is VariableClue) {
          if (clue.variableReferences
              .any((element) => updatedVariables.contains(element))) {
            addToUpdateQueue(clue);
          }
        }
      }
      return updatedVariables.length > 0;
    }
    return false;
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
  return getSquaresRange(lo, hi);
}

List<int> getSquaresRange(int lo, int hi) {
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
  return getCubesRange(lo, hi);
}

List<int> getCubesRange(int lo, int hi) {
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

List<int> getPowersInRange(int lo, int hi) {
  var powers = <int>{};
  var any = true;
  for (var power = 3; any; power++) {
    any = false;
    for (var n = 2;; n++) {
      var value = n.pow(power) as int;
      if (value > hi) break;
      if (value < lo) continue;
      any = true;
      powers.add(value);
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

int reverse(int value) {
  var valueStr = value.toString();
  var reverse = '';
  for (var index = 0; index < valueStr.length; index++) {
    reverse = valueStr[index] + reverse;
  }
  return int.parse(reverse);
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

int sumDigits(int value) {
  var valueStr = value.toString();
  var sum = 0;
  for (var index = 0; index < valueStr.length; index++) {
    sum += int.parse(valueStr[index]);
  }
  return sum;
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
    int loLimit = 10.pow(clue.length - 1) as int;
    if (loLimit < 2) loLimit = 2;
    int hiLimit = (10.pow(clue.length) as int) - 1;
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
      var hi = ((10.pow(clue.length) as int) - 1) ~/ value;
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
  var numValues = 1;
  for (var d = 0; d < clue.length; d++) {
    numValues *= clue.digits[d].length;
  }
  if (numValues >= 100) return null;
  var values = <int>{};
  for (var d1 in clue.digits[0]) {
    for (var d2 in clue.digits[1]) {
      for (var d3 in clue.digits[2]) {
        var value = d3 + 10 * (d2 + 10 * d1);
        values.add(value);
      }
    }
  }
  return values;
}

List<int>? getMultiplesOfValues(Clue clue, List<int> values) {
  var values = <int>[];
  var loResult = 10.pow(clue.length - 1) as int;
  var hiResult = (10.pow(clue.length) as int) - 1;
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
      values.add(multiple);
    }
  }
  return values;
}

List<int>? getTriangularsLessValues(Clue clue, Set<int> values) {
  var result = <int>{};
  var minInput =
      values.reduce((value, element) => element < value ? element : value);
  var maxInput =
      values.reduce((value, element) => element > value ? element : value);
  var lo = 10.pow(clue.length - 1) as int;
  var hi = (10.pow(clue.length) as int) - 1;
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
