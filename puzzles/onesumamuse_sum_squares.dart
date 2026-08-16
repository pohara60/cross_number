import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

Map<List<int>, int> getSumOfSquares({String cacheFilePath = 'cache.json'}) {
  final cacheFile = File(cacheFilePath);

  // Define the map with value-equality for keys
  final results = LinkedHashMap<List<int>, int>(
    equals: const ListEquality().equals,
    hashCode: const ListEquality().hash,
  );

  // 1. READ FROM DISK (If cache file exists)
  if (cacheFile.existsSync()) {
    try {
      final jsonString = cacheFile.readAsStringSync();
      final Map<String, dynamic> rawMap = json.decode(jsonString);

      for (final entry in rawMap.entries) {
        // Decode the string key back into List<int>
        final List<int> key = List<int>.from(json.decode(entry.key) as List);
        results[key] = entry.value as int;
      }
      return results;
    } catch (e) {
      // If reading/parsing fails, fall back to recalculating
      print('Failed to read cache, recalculating: $e');
    }
  }

  // 2. COMPUTE RESULTS (If cache doesn't exist)
  for (var a = 100; a <= 999; a++) {
    for (var b = a + 1; b <= 999; b++) {
      for (var c = b + 1; c <= 999; c++) {
        final sumOfSquares = a * a + b * b + c * c;
        if (sumOfSquares < 1000000 || sumOfSquares > 9999999) continue;
        final digits = (a.toString() + b.toString() + c.toString()).split('').map(int.parse).toSet();
        if (digits.length != 9) continue;
        if (digits.contains(0)) continue;
        final reversedA = int.parse(a.toString().split('').reversed.join(''));
        final reversedB = int.parse(b.toString().split('').reversed.join(''));
        final reversedC = int.parse(c.toString().split('').reversed.join(''));
        final reversedSumOfSquares = reversedA * reversedA + reversedB * reversedB + reversedC * reversedC;
        if (reversedSumOfSquares < 1000000 || reversedSumOfSquares > 9999999) continue;
        if (reversedSumOfSquares != sumOfSquares) continue;
        // final reversedDigits =
        //     (reversedA.toString() + reversedB.toString() + reversedC.toString()).split('').map(int.parse).toSet();
        // if (reversedDigits.length != 9) continue;
        // if (reversedDigits.contains(0)) continue;
        // print('Found: $a, $b, $c => Sum of squares: $sumOfSquares');
        var ordered = [a, b, c];
        results[ordered] = sumOfSquares;
      }
    }
  }

  // 3. WRITE TO DISK
  try {
    // Standard JSON requires string keys, so we stringify the List<int> keys
    final rawMap = <String, int>{};
    for (final entry in results.entries) {
      rawMap[json.encode(entry.key)] = entry.value;
    }

    cacheFile.writeAsStringSync(json.encode(rawMap));
  } catch (e) {
    print('Failed to write cache to disk: $e');
  }

  return results;
}

Map<List<int>, int> results = {};
var firstArg = <int>{};
var secondArg = <int>{};
var thirdArg = <int>{};
var sumOfSquares = <int>{};
var allArgs = <int>{};
var gArg = <int>{};

Set<int> sortedSet(Iterable<int> iterable) {
  var list = iterable.toList();
  list.sort();
  return list.toSet();
}

void computeSumOfSquares() {
  results = getSumOfSquares();
  print('Total results found: ${results.length}');
  firstArg = sortedSet(results.keys.map((k) => k[0]));
  secondArg = sortedSet(results.keys.map((k) => k[1]));
  thirdArg = sortedSet(results.keys.map((k) => k[2]));
  sumOfSquares = sortedSet(results.values);
  allArgs = sortedSet(firstArg.union(secondArg).union(thirdArg));
  print('Unique A value count: ${firstArg.length}');
  print('Unique B value count: ${secondArg.length}');
  print('Unique C value count: ${thirdArg.length}');
  print('Unique Sum value count: ${sumOfSquares.length}');
  print('Unique All Args value count: ${allArgs.length}');
  // Find G, which appears in 4 different sums
  var countArg = <int, Set<int>>{};
  for (var entry in results.entries) {
    var key = entry.key;
    var value = entry.value;
    for (var arg in key) {
      var set = countArg.putIfAbsent(arg, () => <int>{});
      set.add(value);
    }
  }
  gArg = sortedSet(countArg.entries.where((e) => e.value.length >= 4).map((e) => e.key));
  getLookupsFromResults(results);
}

int? getSumOfSquaresForOrdered(List<int> ordered) {
  return results[ordered];
}

int? sum3DigitSquares(List<dynamic> values) {
  // In each clue the first three elements are 3-digit numbers that together comprise the nine non-zero digits. The
  // fourth element is the sum of the squares of the other three.
  // Clues are given in pairs, in each pair one set of 3-digit numbers are the reverses of the other set.
  assert(values.length == 3);
  final a = values[0] as int;
  final b = values[1] as int;
  final c = values[2] as int;

  var ordered = [a, b, c]..sort();
  final sumOfSquares = getSumOfSquaresForOrdered(ordered);
  return sumOfSquares;
}

int reverse(int value) {
  var valueStr = value.toString();
  var reverseValue = 0;
  for (var index = valueStr.length - 1; index >= 0; index--) {
    reverseValue = reverseValue * 10 + int.parse(valueStr[index]);
  }
  return reverseValue;
}

// Map 1-number -> Set of co-occurring numbers
final Map<int, Set<int>> _oneNumLookup = {};

// Map 2-numbers (sorted pair) -> Set of remaining 3rd numbers
final Map<List<int>, Set<int>> _twoNumLookup = LinkedHashMap<List<int>, Set<int>>(
  equals: const ListEquality().equals,
  hashCode: const ListEquality().hash,
);

getLookupsFromResults(Map<List<int>, int> results) {
  for (final triple in results.keys) {
    if (triple.length != 3) continue;

    final a = triple[0];
    final b = triple[1];
    final c = triple[2];

    // 1. Index single numbers (each number maps to the other two)
    _addOneNum(a, b);
    _addOneNum(a, c);
    _addOneNum(b, a);
    _addOneNum(b, c);
    _addOneNum(c, a);
    _addOneNum(c, b);

    // 2. Index pairs (sorted so lookup order doesn't matter)
    _addPair([a, b], c);
    _addPair([a, c], b);
    _addPair([b, c], a);
  }
}

void _addOneNum(int num, int coOccurring) {
  _oneNumLookup.putIfAbsent(num, () => <int>{}).add(coOccurring);
}

void _addPair(List<int> pair, int remaining) {
  pair.sort(); // Normalize pair so order [a, b] == [b, a]
  _twoNumLookup.putIfAbsent(pair, () => <int>{}).add(remaining);
}

/// Given 1 number, returns all possible values for the other 2 numbers.
Set<int> getOthersForOne(int num) {
  return _oneNumLookup[num] ?? {};
}

/// Given 2 numbers (in any order), returns all possible 3rd numbers.
Set<int> getRemainingForTwo(int num1, int num2) {
  final pair = [num1, num2]..sort();
  return _twoNumLookup[pair] ?? {};
}
