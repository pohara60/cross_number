import '../crossnumber.dart';
import '../clue.dart';
import '../cartesian.dart';
import '../frequency/clue.dart';
import '../frequency/puzzle.dart';

import '../generators.dart';
import '../monadic.dart';
import '../puzzle.dart';
import '../variable.dart';

class Frequency extends Crossnumber<FrequencyPuzzle> {
  var gridString = [
    '+--+--+--+--+',
    '|1 :2 :3 |4 |',
    '+--:::::::::+',
    '|5 :  |6 :  |',
    '+:::--+--:::+',
    '|7 :8 |9 :  |',
    '+:::::::::--+',
    '|  |10:  :  |',
    '+--+--+--+--+',
  ];

  Frequency() {
    puzzle = FrequencyPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  late final FrequencyEntry a1;
  late final FrequencyEntry a5;
  late final FrequencyEntry a6;
  late final FrequencyEntry a7;
  late final FrequencyEntry a9;
  late final FrequencyEntry a10;

  late final FrequencyEntry d2;
  late final FrequencyEntry d3;
  late final FrequencyEntry d4;
  late final FrequencyEntry d5;
  late final FrequencyEntry d8;
  late final FrequencyEntry d9;

  SolveFunction solveWrapper(
      bool Function(FrequencyEntry clue, Set<int> possibleValue) solve) {
    bool solveFrequencyClue(
      Puzzle p,
      Variable v,
      Set<int> possibleValue, {
      Set<int>? possibleValue2,
      Map<Variable, Set<int>>? possibleVariables,
      Map<Variable, Set<int>>? possibleVariables2,
      Set<Variable>? updatedVariables,
    }) {
      var clue = v as FrequencyEntry;
      return solve(clue, possibleValue);
    }

    return solveFrequencyClue;
  }

  @override
  void initCrossnumber() {
    a1 = FrequencyEntry(
        name: 'A1',
        length: 3,
        valueDesc: 'Palindrome',
        solve: solveWrapper(solveA1));
    puzzle.addEntry(a1);
    a5 = FrequencyEntry(
        name: 'A5',
        length: 2,
        valueDesc: 'Digit product = D2',
        solve: solveWrapper(solveA5));
    puzzle.addEntry(a5);
    a6 = FrequencyEntry(
        name: 'A6',
        length: 2,
        valueDesc: 'Factor of D9',
        solve: solveWrapper(solveA6));
    puzzle.addEntry(a6);
    a7 = FrequencyEntry(
        name: 'A7',
        length: 2,
        valueDesc: 'Factor of D4',
        solve: solveWrapper(solveA7));
    puzzle.addEntry(a7);
    a9 = FrequencyEntry(
        name: 'A9',
        length: 2,
        valueDesc: 'Reverse of D2',
        solve: solveWrapper(solveA9));
    puzzle.addEntry(a9);
    a10 = FrequencyEntry(
        name: 'A10',
        length: 3,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveA10));
    puzzle.addEntry(a10);

    d2 = FrequencyEntry(
        name: 'D2',
        length: 2,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveD2));
    puzzle.addEntry(d2);
    d3 = FrequencyEntry(
        name: 'D3',
        length: 2,
        valueDesc: 'Digit sum is square',
        solve: solveWrapper(solveD3));
    puzzle.addEntry(d3);
    d4 = FrequencyEntry(
        name: 'D4',
        length: 3,
        valueDesc: 'Multiple of A7',
        solve: solveWrapper(solveD4));
    puzzle.addEntry(d4);
    d5 = FrequencyEntry(
        name: 'D5',
        length: 3,
        valueDesc: 'Same digit product as A1',
        solve: solveWrapper(solveD5));
    puzzle.addEntry(d5);
    d8 = FrequencyEntry(
        name: 'D8',
        length: 2,
        valueDesc: 'Cube + sum all digits',
        solve: solveWrapper(solveD8));
    puzzle.addEntry(d8);
    d9 = FrequencyEntry(
        name: 'D9',
        length: 2,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveD9));
    puzzle.addEntry(d9);

    puzzle.linkEntriesToGrid();
    // puzzle.addDigitIdentity(a1, 2, d2, 1);
    // puzzle.addDigitIdentity(a1, 3, d3, 1);
    // puzzle.addDigitIdentity(a5, 1, d5, 1);
    // puzzle.addDigitIdentity(a5, 2, d2, 2);
    // puzzle.addDigitIdentity(a6, 1, d3, 2);
    // puzzle.addDigitIdentity(a6, 2, d4, 2);
    // puzzle.addDigitIdentity(a7, 1, d5, 2);
    // puzzle.addDigitIdentity(a7, 2, d8, 1);
    // puzzle.addDigitIdentity(a9, 1, d9, 1);
    // puzzle.addDigitIdentity(a9, 2, d4, 3);
    // puzzle.addDigitIdentity(a10, 1, d8, 2);
    // puzzle.addDigitIdentity(a10, 2, d9, 2);

    puzzle.addClueReference(a5, d2, true);
    puzzle.addClueReference(a6, d9, true);
    puzzle.addClueReference(a7, d4, true);
    puzzle.addClueReference(a9, d2, true);
    puzzle.addClueReference(d4, a7, true);
    puzzle.addClueReference(d5, a1, true);

    // D8 references all other cells!
    puzzle.addClueReference(d8, a1, false);
    puzzle.addClueReference(d8, a5, false);
    puzzle.addClueReference(d8, a6, false);
    puzzle.addClueReference(d8, a7, false);
    puzzle.addClueReference(d8, a9, false);
    puzzle.addClueReference(d8, a10, false);
    puzzle.addClueReference(d8, d2, false);
    puzzle.addClueReference(d8, d3, false);
    puzzle.addClueReference(d8, d4, false);
    puzzle.addClueReference(d8, d5, false);
    puzzle.addClueReference(d8, d9, false);

    puzzle.finalize();
    super.initCrossnumber();
  }

  static void filterDigits(
      FrequencyEntry clue, List<int> values, Set<int> possibleValue) {
    for (var value in values) {
      // Check digits permissible
      if (clue.digitsMatch(value)) {
        possibleValue.add(value);
      }
    }
  }

  bool solveA1(FrequencyEntry clue, Set<int> possibleValue) {
    var values = clue.values != null
        ? List<int>.from(clue.values!)
        : getThreeDigitPalindromes();
    var values2 = getDigitProductEqualsOtherClueProduct(clue, d5);
    if (values2 != null) {
      values.removeWhere((value) => !values2.contains(value));
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA5(FrequencyEntry clue, Set<int> possibleValue) {
    var values = getDigitProductEqualsOtherClue(clue, d2);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  bool solveA6(FrequencyEntry clue, Set<int> possibleValue) {
    var values = getFactorsOfOtherClue(clue, d9);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  bool solveA7(FrequencyEntry clue, Set<int> possibleValue) {
    var values = getFactorsOfOtherClue(clue, d4);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  bool solveA9(FrequencyEntry clue, Set<int> possibleValue) {
    var values = getReverseOfOtherClue(clue, d2);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  bool solveA10(FrequencyEntry clue, Set<int> possibleValue) {
    var values = clue.values != null
        ? List<int>.from(clue.values!)
        : getThreeDigitTriangles();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD2(FrequencyEntry clue, Set<int> possibleValue) {
    var values = clue.values != null
        ? List<int>.from(clue.values!)
        : getTwoDigitTriangles();
    var values2 = getDigitProductOtherClue(clue, a5);
    if (values2 != null) {
      values.removeWhere((value) => !values2.contains(value));
    }
    var values3 = getReverseOfOtherClue(clue, a9);
    if (values3 != null) {
      values.removeWhere((value) => !values3.contains(value));
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD3(FrequencyEntry clue, Set<int> possibleValue) {
    List<int>? values;
    if (clue.values != null) {
      values = List.from(clue.values!);
    } else {
      var squares = getSquaresInRange(1, 17);
      values = <int>[];
      for (var d1 = 1; d1 < 10; d1++) {
        for (var d2 = 0; d2 < 10; d2++) {
          var sum = d1 + d2;
          if (squares.contains(sum)) {
            values.add(d1 * 10 + d2);
          }
        }
      }
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD4(FrequencyEntry clue, Set<int> possibleValue) {
    var values = <int>[];
    if (a7.values != null) {
      values = getMultipleOfOtherClue(clue, a7)!;
    } else {
      if (clue.values != null) {
        values = List.from(clue.values!);
      } else {
        // Need to get started with mutually recursive clues
        var setValues = <int>{};
        for (var a7value = 10; a7value < 100; a7value++) {
          int hi = 999 ~/ a7value;
          for (var i = 2; i <= hi; i++) {
            var multiple = i * a7value;
            setValues.add(multiple);
          }
          values = List.from(setValues);
        }
      }
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD5(FrequencyEntry clue, Set<int> possibleValue) {
    var values = getDigitProductEqualsOtherClueProduct(clue, a1);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  bool solveD8(FrequencyEntry clue, Set<int> possibleValue) {
    var cubes = getCubesInRange(1, 99);
    // Check Value = Cube plus Sum of Digits in whole grid
    var otherValues = <List<int>>[];
    var otherClues = <Clue>[];
    var incomplete = false;
    var productSize = 1;
    const productSizeLimit = 100;
    for (var other in puzzle.clues.values.where((element) => element != clue)) {
      if (other.values == null) {
        incomplete = true;
        break;
      }
      productSize *= other.values!.length;
      //if (productSize > productSizeLimit) break;
      otherClues.add(other);
      otherValues.add(other.values!.toList());
    }
    if (!incomplete && productSize <= productSizeLimit) {
      var sums = <int>{};
      var values = <int>{};
      for (var product in cartesian(otherValues)) {
        var sum = sumClueDigits(clue, otherClues, product);
        sums.add(sum);
      }
      int lo = clue.min!;
      int hi = clue.max!;
      for (var cube in cubes) {
        for (var sum in sums) {
          var valueWithoutDigits = cube + sum;
          // Iterate ove possible value digit sums
          for (var valueSumDigits = 1;
              valueSumDigits <= 9 * clue.length!;
              valueSumDigits++) {
            var value = valueWithoutDigits + valueSumDigits;
            if (value >= lo &&
                value <= hi &&
                sumDigits(value) == valueSumDigits) {
              values.add(value);
            }
          }
        }
      }
      filterDigits(clue, List.from(values), possibleValue);
    }
    return false;
  }

  bool solveD9(FrequencyEntry clue, Set<int> possibleValue) {
    var values = clue.values != null
        ? List<int>.from(clue.values!)
        : getTwoDigitTriangles();
    var values2 = getMultipleOfOtherClue(clue, a6);
    if (values2 != null) {
      values.removeWhere((value) => !values2.contains(value));
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }
}
