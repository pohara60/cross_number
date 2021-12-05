/// An API for solving Cross Number puzzles.
library crossnumber;

//import 'dart:collection';
import 'dart:math';
import 'package:powers/powers.dart';

import 'package:crossnumber/clue.dart';
import 'package:crossnumber/puzzle.dart';

/// Provide access to the Cross Number API.
class Crossnumber<PuzzleKind extends Puzzle> {
  late PuzzleKind puzzle;

  static const bool traceInit = false;
  static const bool traceSolve = true;

  Crossnumber();

  void initCrossnumber() {
    if (traceInit) {
      print(puzzle.toString());
    }
  }

  List<Clue> updateQueue = [];

  void addToUpdateQueue(Clue clue) {
    if (!updateQueue.contains(clue)) {
      updateQueue.add(clue);
    }
  }

  void solve() {
    bool updated;
    var iterations = 0;
    var allClue = List<Clue>.from(puzzle.clues.values).toList();
    updateQueue
        .addAll(allClue.where((element) => !updateQueue.contains(element)));

    if (traceSolve) {
      print("UPDATES-----------------------------");
    }

    while (updateQueue.length > 0) {
      Clue clue = updateQueue.removeAt(0);
      iterations++;
      updated = solveClue(clue);
      if (updated) {
        for (var referrer in clue.referrers) {
          addToUpdateQueue(referrer);
        }
      }
    }
    if (traceSolve) {
      print('Clue iterations=$iterations');
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
      if (possibleValue.isNotEmpty) {
        if (puzzle.updateValues(clue, possibleValue)) updated = true;
        if (clue.finalise()) updated = true;
        if (clue is VariableClue) {
          for (var variable in clue.variableReferences) {
            if (updateVariables(variable, possibleVariables[variable]!))
              updated = true;
          }
        }
      }
    }

    if (traceSolve && updated) {
      print("solve: ${clue.toString()}");
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

int reverse(int prime) {
  var primeStr = prime.toString();
  var reverse = primeStr[1] + primeStr[0];
  return int.parse(reverse);
}

bool primeHasReverse(int prime) {
  var other = reverse(prime);
  return twoDigitPrimes.contains(other) && other != prime;
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
