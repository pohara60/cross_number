import 'dart:io';
import 'dart:math';

import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/instruction/clue.dart';
import 'package:crossnumber/instruction/puzzle.dart';
import 'package:crossnumber/set.dart';

class Instruction extends Crossnumber<InstructionPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :2 :  |3 :4 :5 |6 |',
    '+::+::+--+::+::+::+::+',
    '|7 :  |8 |9 :  |10:  |',
    '+--+::+::+::+--+--+::+',
    '|11:  :  :  |12|13:  |',
    '+::+--+--+--+::+::+--+',
    '|14:15:16|  |17:  :18|',
    '+--+::+::+--+--+--+::+',
    '|19:  |  |20:21:22:  |',
    '+::+--+--+::+::+::+--+',
    '|23:24|25:  |  |26:27|',
    '+::+::+::+::+--+::+::+',
    '|  |28:  :  |29:  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  Instruction() {
    puzzle = InstructionPuzzle.grid(gridString);
    initCrossnumber();
  }

  var HappyNumbers = [
    1,
    7,
    10,
    13,
    19,
    23,
    28,
    31,
    32,
    44,
    49,
    68,
    70,
    79,
    82,
    86,
    91,
    94,
    97
  ];
  var LuckyNumbers = [
    1,
    3,
    7,
    9,
    13,
    15,
    21,
    31,
    33,
    37,
    43,
    49,
    51,
    63,
    67,
    69,
    73,
    75,
    79,
    87,
    93,
    99
  ];

  late final InstructionClue a1;
  late final InstructionClue a3;
  late final InstructionClue a7;
  late final InstructionClue a9;
  late final InstructionClue a10;
  late final InstructionClue a11;
  late final InstructionClue a13;
  late final InstructionClue a14;
  late final InstructionClue a17;
  late final InstructionClue a19;
  late final InstructionClue a20;
  late final InstructionClue a23;
  late final InstructionClue a25;
  late final InstructionClue a26;
  late final InstructionClue a28;
  late final InstructionClue a29;

  late final InstructionClue d1;
  late final InstructionClue d2;
  late final InstructionClue d3;
  late final InstructionClue d4;
  late final InstructionClue d5;
  late final InstructionClue d6;
  late final InstructionClue d8;
  late final InstructionClue d11;
  late final InstructionClue d12;
  late final InstructionClue d13;
  late final InstructionClue d15;
  late final InstructionClue d16;
  late final InstructionClue d18;
  late final InstructionClue d19;
  late final InstructionClue d20;
  late final InstructionClue d21;
  late final InstructionClue d22;
  late final InstructionClue d24;
  late final InstructionClue d25;
  late final InstructionClue d27;

  void initCrossnumber() {
    puzzle.clues = {};

    a1 = InstructionClue(
        name: 'A1',
        length: 3,
        valueDesc: 'Triangular number with a triangular DP',
        solve: solveA1);
    puzzle.addClue(a1);
    a3 = InstructionClue(
        name: 'A3',
        length: 3,
        valueDesc: 'Square number with a square DS',
        solve: solveA3);
    puzzle.addClue(a3);
    a7 = InstructionClue(
        name: 'A7', length: 2, valueDesc: 'DS is half of D21', solve: solveA7);
    puzzle.addClue(a7);
    a9 = InstructionClue(
        name: 'A9', length: 2, valueDesc: 'D18+26', solve: solveA9);
    puzzle.addClue(a9);
    a10 = InstructionClue(
        name: 'A10', length: 2, valueDesc: 'Palindrome', solve: solveA10);
    puzzle.addClue(a10);
    a11 = InstructionClue(
        name: 'A11', length: 4, valueDesc: 'DS equals D21', solve: solveA11);
    puzzle.addClue(a11);
    a13 = InstructionClue(
        name: 'A13',
        length: 2,
        valueDesc: 'Digits have opposite parity and DP equals another entry',
        solve: solveA13);
    puzzle.addClue(a13);
    a14 = InstructionClue(
        name: 'A14',
        length: 3,
        valueDesc:
            'Consecutive odd digits in ascending or descending order, with triangular DP',
        solve: solveA14);
    puzzle.addClue(a14);
    a17 = InstructionClue(
        name: 'A17', length: 3, valueDesc: 'DS is triangular', solve: solveA17);
    puzzle.addClue(a17);
    a19 = InstructionClue(
        name: 'A19', length: 2, valueDesc: 'DP equals D21', solve: solveA19);
    puzzle.addClue(a19);
    a20 = InstructionClue(
        name: 'A20',
        length: 4,
        valueDesc: 'Prime whose DP is square and DS is a factor of D13',
        solve: solveA20);
    puzzle.addClue(a20);
    a23 = InstructionClue(
        name: 'A23',
        length: 2,
        valueDesc: 'Palindromic prime',
        solve: solveA23);
    puzzle.addClue(a23);
    a25 = InstructionClue(
        name: 'A25', length: 2, valueDesc: 'Prime', solve: solveA25);
    puzzle.addClue(a25);
    a26 = InstructionClue(
        name: 'A26', length: 2, valueDesc: 'DP is a cube', solve: solveA26);
    puzzle.addClue(a26);
    a28 = InstructionClue(
        name: 'A28', length: 3, valueDesc: 'DP equals 180', solve: solveA28);
    puzzle.addClue(a28);
    a29 = InstructionClue(
        name: 'A29',
        length: 3,
        valueDesc: 'DS equals D21 and DP is a cube',
        solve: solveA29);
    puzzle.addClue(a29);

    d1 = InstructionClue(
        name: 'D1',
        length: 2,
        valueDesc: '(DS+DP) is an odd multiple of 5',
        solve: solveD1);
    puzzle.addClue(d1);
    d2 = InstructionClue(
        name: 'D2',
        length: 3,
        valueDesc: 'Palindrome and multiple of 5 with MP of 2',
        solve: solveD2);
    puzzle.addClue(d2);
    d3 = InstructionClue(
        name: 'D3', length: 3, valueDesc: 'A3 plus or minus 3', solve: solveD3);
    puzzle.addClue(d3);
    d4 = InstructionClue(
        name: 'D4',
        length: 2,
        valueDesc: 'Greater than D8 and DS equals another entry',
        solve: solveD4);
    puzzle.addClue(d4);
    d5 = InstructionClue(
        name: 'D5', length: 2, valueDesc: '2 times a square', solve: solveD5);
    puzzle.addClue(d5);
    d6 = InstructionClue(
        name: 'D6',
        length: 3,
        valueDesc: 'Has 8 factors including 1 and itself',
        solve: solveD6);
    puzzle.addClue(d6);
    d8 = InstructionClue(
        name: 'D8',
        length: 2,
        valueDesc: 'Square pyramidal number (ie, sum of the first n squares)',
        solve: solveD8);
    puzzle.addClue(d8);
    d11 = InstructionClue(
        name: 'D11', length: 2, valueDesc: 'Square', solve: solveD11);
    puzzle.addClue(d11);
    d12 = InstructionClue(
        name: 'D12',
        length: 2,
        valueDesc: 'DP is a single-digit even number',
        solve: solveD12);
    puzzle.addClue(d12);
    d13 = InstructionClue(
        name: 'D13', length: 2, valueDesc: 'Multiple of 7', solve: solveD13);
    puzzle.addClue(d13);
    d15 = InstructionClue(
        name: 'D15',
        length: 2,
        valueDesc: 'DP equals another entry',
        solve: solveD15);
    puzzle.addClue(d15);
    d16 = InstructionClue(
        name: 'D16', length: 2, valueDesc: 'Prime', solve: solveD16);
    puzzle.addClue(d16);
    d18 = InstructionClue(
        name: 'D18',
        length: 2,
        valueDesc: 'Lucky and happy number',
        solve: solveD18);
    puzzle.addClue(d18);
    d19 = InstructionClue(
        name: 'D19',
        length: 3,
        valueDesc: 'DP equals another entry',
        solve: solveD19);
    puzzle.addClue(d19);
    d20 = InstructionClue(
        name: 'D20',
        length: 3,
        valueDesc: '(DS + DP) is a multiple of D21',
        solve: solveD20);
    puzzle.addClue(d20);
    d21 = InstructionClue(
        name: 'D21', length: 2, valueDesc: 'Multiple of 10', solve: solveD21);
    puzzle.addClue(d21);
    d22 = InstructionClue(
        name: 'D22',
        length: 3,
        valueDesc: 'DP is a power of 2',
        solve: solveD22);
    puzzle.addClue(d22);
    d24 = InstructionClue(
        name: 'D24', length: 2, valueDesc: 'DP is square', solve: solveD24);
    puzzle.addClue(d24);
    d25 = InstructionClue(
        name: 'D25', length: 2, valueDesc: 'Lucky number', solve: solveD25);
    puzzle.addClue(d25);
    d27 = InstructionClue(
        name: 'D27', length: 2, valueDesc: 'Fibonacci number', solve: solveD27);
    puzzle.addClue(d27);

    // D8 references all other cells!
    puzzle.addDigitIdentityFromGrid();
    puzzle.addReference(a7, d21, true);
    puzzle.addReference(a9, d18, true);
    puzzle.addReference(a11, d21, true);
    puzzle.addReference(a19, d21, true);
    puzzle.addReference(a20, d13, true);
    puzzle.addReference(a29, d21, true);
    puzzle.addReference(d3, a3, true);
    puzzle.addReference(d4, d8, true);
    // d4 refers all
    // d15 refers all
    // d19 refers all
    puzzle.addReference(d20, d21, false);
    // printReferences();

    super.initCrossnumber();
  }

  void printReferences() {
    var clues = puzzle.clues.values;
    for (var clue in clues) {
      stdout.write(clue.name);
      for (var otherClue in clues) {
        if (clue.referrers.contains(otherClue)) {
          stdout.write('\t${otherClue.name}');
        } else {
          stdout.write('\t');
        }
      }
      stdout.write('\n');
    }
  }

  static void filterDigits(
      InstructionClue clue, List<int> values, Set<int> possibleValue) {
    var filtered = <int>[];
    for (var value in values) {
      // Check digits permissible
      if (clue.digitsMatch(value)) {
        possibleValue.add(value);
      } else {
        filtered.add(value);
      }
    }
    // if (filtered.isNotEmpty)
    //   print("Clue ${clue.name} filtered: ${filtered.toShortString()}");
  }

  List<int> solveConstraintValues(
      InstructionClue clue,
      Set<int> possibleValue,
      List<int> Function() getValues,
      int Function(int) getConstraintValue,
      List<int> Function(int, int) getConstraintValues) {
    var values = <int>[];
    var possible = getValues();
    var possibleConstraintValue =
        possible.map((e) => getConstraintValue(e)).toList();
    var constraintValueValues = getConstraintValues(
        possibleConstraintValue.reduce(min),
        possibleConstraintValue.reduce(max));
    for (var i = 0; i < possible.length; i++) {
      var value = possible[i];
      var constraintValue = possibleConstraintValue[i];
      if (constraintValueValues.contains(constraintValue)) {
        values.add(value);
      }
    }
    return values;
  }

  bool solveConstraint(
      InstructionClue clue,
      Set<int> possibleValue,
      List<int> Function() getValues,
      int Function(int) getConstraintValue,
      List<int> Function(int, int) getConstraintValues) {
    var values = solveConstraintValues(
      clue,
      possibleValue,
      getValues,
      getConstraintValue,
      getConstraintValues,
    );
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveDPConstraint(
      InstructionClue clue,
      Set<int> possibleValue,
      List<int> Function() getValues,
      List<int> Function(int, int) getDPValues) {
    return solveConstraint(clue, possibleValue, getValues, dp, getDPValues);
  }

  bool solveDSConstraint(
      InstructionClue clue,
      Set<int> possibleValue,
      List<int> Function() getValues,
      List<int> Function(int, int) getDSValues) {
    return solveConstraint(clue, possibleValue, getValues, ds, getDSValues);
  }

  List<int> solveClueValues(
      InstructionClue clue, Set<int> possibleValue, bool Function(int) valueOK,
      [Iterable<int>? clueValues]) {
    var values = <int>[];
    for (var value in clueValues ?? clue.range) {
      if (valueOK(value)) {
        values.add(value);
      }
    }
    return values;
  }

  bool solveClueValue(
      InstructionClue clue, Set<int> possibleValue, bool Function(int) valueOK,
      [Iterable<int>? clueValues]) {
    var values = solveClueValues(clue, possibleValue, valueOK, clueValues);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  List<int> solveOtherClueValues(
      InstructionClue clue,
      InstructionClue otherClue,
      Set<int> possibleValue,
      List<int> Function(int) getOtherValues,
      Set<int> validOtherValues,
      [Iterable<int>? clueValues]) {
    if (otherClue.values != null) {
      var values = <int>[];
      validOtherValues.clear();
      for (var value in clueValues ?? clue.range) {
        var otherValues = getOtherValues(value);
        if (otherValues
            .any((otherValue) => otherClue.values!.contains(otherValue))) {
          if (clue.digitsMatch(value)) {
            values.add(value);
            for (var otherValue in otherValues) {
              if (otherClue.values!.contains(otherValue)) {
                validOtherValues.add(otherValue);
              }
            }
          }
        }
      }
      return values;
    }
    return <int>[];
  }

  bool solveOtherClueValue(
      InstructionClue clue,
      InstructionClue otherClue,
      Set<int> possibleValue,
      List<int> Function(int) otherValues,
      Set<int> validOtherValues,
      [Iterable<int>? clueValues]) {
    if (otherClue.values != null) {
      var values = solveOtherClueValues(clue, otherClue, possibleValue,
          otherValues, validOtherValues, clueValues);
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  bool clueLimitedValues(InstructionClue clue) =>
      clue.values != null && clue.values!.length <= 10;

  bool solveValueOtherClueValue(
      InstructionClue clue, Set<int> possibleValue, int Function(int) getValue,
      [Iterable<int>? clueValues]) {
    var otherClues =
        puzzle.clues.values.where((other) => other != clue).toList();
    // Do not worry about clues that refer to all other clues, unless known
    if (!clueLimitedValues(a13)) otherClues.remove(a13);
    if (!clueLimitedValues(d4)) otherClues.remove(d4);
    if (!clueLimitedValues(d15)) otherClues.remove(d15);
    if (!clueLimitedValues(d19)) otherClues.remove(d19);
    if (otherClues.any((clue) => clue.values == null)) return false;
    return solveClueValue(clue, possibleValue, (value) {
      var otherValue = getValue(value);
      return otherClues.any((clue) => clue.values!.contains(otherValue));
    }, clueValues);
  }

  bool solveDPOtherClueValue(InstructionClue clue, Set<int> possibleValue,
      [Iterable<int>? clueValues]) {
    return solveValueOtherClueValue(clue, possibleValue, dp, clueValues);
  }

  bool solveDSOtherClueValue(InstructionClue clue, Set<int> possibleValue,
      [Iterable<int>? clueValues]) {
    return solveValueOtherClueValue(clue, possibleValue, ds, clueValues);
  }

  bool solveA1(InstructionClue clue, Set<int> possibleValue) {
    /* Triangular number with a triangular DP, 3 digits */
    return solveDPConstraint(
        clue, possibleValue, getThreeDigitTriangles, getTrianglesInRange);
  }

  bool solveA3(InstructionClue clue, Set<int> possibleValue) {
    /* Square number with a square DS, 3 digits */
    var values = getThreeDigitSquares();
    if (validA3forD3.isNotEmpty) {
      var set = values.toSet();
      set = set.intersection(validA3forD3);
      // if (set.length != values.length)
      //   print(
      //       '${clue.name} reference removed ${values.length - set.length} values');
      values = set.toList();
    }
    return solveDSConstraint(
        clue, possibleValue, () => values, getSquaresInRange);
  }

  var validD21forA7 = <int>{};
  bool solveA7(InstructionClue clue, Set<int> possibleValue) {
    /* DS is half of D21, 2 digits */
    return solveOtherClueValue(
        clue, d21, possibleValue, (value) => [ds(value) * 2], validD21forA7);
  }

  var validD18forA9 = <int>{};
  bool solveA9(InstructionClue clue, Set<int> possibleValue) {
    /* D18+26, 2 digits */
    return solveOtherClueValue(
        clue, d18, possibleValue, (value) => [value - 26], validD18forA9);
  }

  bool solveA10(InstructionClue clue, Set<int> possibleValue) {
    /* Palindrome, 2 digits */
    var values = getTwoDigitPalindromes();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  var validD21forA11 = <int>{};
  bool solveA11(InstructionClue clue, Set<int> possibleValue) {
    /* DS equals D21, 4 digits */
    return solveOtherClueValue(
        clue, d21, possibleValue, (value) => [ds(value)], validD21forA11);
  }

  bool solveA13(InstructionClue clue, Set<int> possibleValue) {
    /* Digits have opposite parity and DP equals another entry, 2 digits */
    // Check parity first
    var values = clue.range
        .where((value) => (value ~/ 10 % 2 + value % 10 % 2) == 1)
        .toList();
    filterDigits(clue, values, possibleValue);
    // Check other entries (if possible)
    return solveDPOtherClueValue(clue, possibleValue, possibleValue);
  }

  bool solveA14(InstructionClue clue, Set<int> possibleValue) {
    /* Consecutive odd digits in ascending or descending order, with triangular DP, 3 digits */
    var values = clue.range.where((value) {
      var d1 = value ~/ 100;
      var d2 = value ~/ 10 % 10;
      var d3 = value % 10;
      if (d1 < d2) {
        return d1 % 2 == 1 && d2 == (d1 + 2) && d3 == (d2 + 2);
      } else {
        return d1 % 2 == 1 && d2 == (d3 + 2) && d1 == (d2 + 2);
      }
    }).toList();
    return solveDPConstraint(
        clue, possibleValue, () => values, getTrianglesInRange);
  }

  bool solveA17(InstructionClue clue, Set<int> possibleValue) {
    /* DS is triangular, 3 digits */
    return solveDSConstraint(
        clue, possibleValue, getThreeDigitNumbers, getTrianglesInRange);
  }

  var validD21forA19 = <int>{};
  bool solveA19(InstructionClue clue, Set<int> possibleValue) {
    /* DP equals D21, 2 digits */
    return solveOtherClueValue(
        clue, d21, possibleValue, (value) => [dp(value)], validD21forA19);
  }

  var validD13forA20 = <int>{};
  bool solveA20(InstructionClue clue, Set<int> possibleValue) {
    /* Prime whose DP is square and DS is a factor of D13, 4 digits */
    // Check parity first
    var values = solveConstraintValues(
        clue, possibleValue, getFourDigitPrimes, dp, getSquaresInRange);
    if (d13.values != null) {
      validD13forA20.clear();
      return solveClueValue(clue, possibleValue, (value) {
        if (!clue.digitsMatch(value)) return false;
        var valueDS = ds(value);
        var otherValues = d13.values!.where((value) => value % valueDS == 0);
        if (otherValues.isEmpty) return false;
        for (var otherValue in otherValues) {
          validD13forA20.add(otherValue);
        }
        return true;
      }, values);
    }
    // Progress with these values
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA23(InstructionClue clue, Set<int> possibleValue) {
    /* Palindromic prime, 2 digits */
    var values = <int>[11];
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA25(InstructionClue clue, Set<int> possibleValue) {
    /* Prime, 2 digits */
    var values = getTwoDigitPrimes();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA26(InstructionClue clue, Set<int> possibleValue) {
    /* DP is a cube, 2 digits */
    return solveDPConstraint(
        clue, possibleValue, getTwoDigitNumbers, getCubesInRange);
  }

  bool solveA28(InstructionClue clue, Set<int> possibleValue) {
    /* DP equals 180, 3 digits */
    return solveDPConstraint(
        clue, possibleValue, getThreeDigitNumbers, (lo, hi) => [180]);
  }

  var validD21forA29 = <int>{};
  bool solveA29(InstructionClue clue, Set<int> possibleValue) {
    /* DS equals D21 and DP is a cube, 3 digits */
    var values = solveConstraintValues(
        clue, possibleValue, getThreeDigitNumbers, dp, getCubesInRange);
    if (d21.values != null) {
      return solveOtherClueValue(clue, d21, possibleValue,
          (value) => [ds(value)], validD21forA29, values);
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD1(InstructionClue clue, Set<int> possibleValue) {
    /* (DS+DP) is an odd multiple of 5, 2 digits */
    return solveClueValue(
      clue,
      possibleValue,
      (value) {
        var dsplusdp = ds(value) + dp(value);
        return (dsplusdp % 5) == 0 && (dsplusdp ~/ 5) % 2 == 1;
      },
    );
  }

  bool solveD2(InstructionClue clue, Set<int> possibleValue) {
    /* Palindrome and multiple of 5 with MP of 2, 3 digits */
    return solveClueValue(
      clue,
      possibleValue,
      (value) => (value % 5) == 0 && mp(value) == 2,
      getThreeDigitPalindromes(),
    );
  }

  var validA3forD3 = <int>{};
  bool solveD3(InstructionClue clue, Set<int> possibleValue) {
    /* A3 plus or minus 3, 3 digits */
    return solveOtherClueValue(clue, a3, possibleValue,
        (value) => [value - 3, value + 3], validA3forD3);
  }

  var validD8forD4 = <int>{};
  bool solveD4(InstructionClue clue, Set<int> possibleValue) {
    /* Greater than D8 and DS equals another entry, 2 digits */
    if (d8.values != null) {
      var minValue = d8.values!.reduce(min) + 1;
      if (minValue > 10) {
        var values = clue.range.where((value) => value > minValue).toList();
        filterDigits(clue, values, possibleValue);
        var result = solveDSOtherClueValue(clue, possibleValue, possibleValue);
        var maxValue = possibleValue.reduce(max);
        validD8forD4 =
            d8.values!.where((element) => element < maxValue).toSet();
        return result;
      }
    }
    return false;
  }

  bool solveD5(InstructionClue clue, Set<int> possibleValue) {
    /* 2 times a square, 2 digits */
    var values = <int>[18, 32, 50, 72, 98];
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD6(InstructionClue clue, Set<int> possibleValue) {
    /* Has 8 factors including 1 and itself, 3 digits */
    return solveClueValue(
      clue,
      possibleValue,
      (value) {
        var factors = <int>[];
        for (var i = 1; i <= value; i++) {
          if (value % i == 0) factors.add(i);
          if (factors.length > 8) break;
        }
        return factors.length == 8;
      },
    );
  }

  bool solveD8(InstructionClue clue, Set<int> possibleValue) {
    /* Square pyramidal number (ie, sum of the first n squares), 2 digits */
    var values = getTwoDigitPyramidal();
    if (validD8forD4.isNotEmpty) {
      var set = values.toSet();
      set = set.intersection(validD8forD4);
      // if (set.length != values.length)
      //   print(
      //       '${clue.name} reference removed ${values.length - set.length} values');
      values = set.toList();
    }
    filterDigits(clue, values, possibleValue);
    return false;
    // puzzle.addReference(d4, d8, true);
  }

  bool solveD11(InstructionClue clue, Set<int> possibleValue) {
    /* Square, 2 digits */
    var values = getTwoDigitSquares();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD12(InstructionClue clue, Set<int> possibleValue) {
    /* DP is a single-digit even number, 2 digits */
    return solveClueValue(
      clue,
      possibleValue,
      (value) {
        var valueDP = dp(value);
        return valueDP < 10 && (valueDP % 2) == 0;
      },
    );
  }

  bool solveD13(InstructionClue clue, Set<int> possibleValue) {
    /* Multiple of 7, 2 digits */
    var values = clue.range.where((value) => (value % 7) == 0).toList();
    if (validD13forA20.isNotEmpty) {
      var set = values.toSet();
      set = set.intersection(validD13forA20);
      // if (set.length != values.length)
      //   print(
      //       '${clue.name} reference removed ${values.length - set.length} values');
      values = set.toList();
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD15(InstructionClue clue, Set<int> possibleValue) {
    /* DP equals another entry, 2 digits */
    return solveDPOtherClueValue(clue, possibleValue, clue.values);
  }

  bool solveD16(InstructionClue clue, Set<int> possibleValue) {
    /* Prime, 2 digits */
    var values = getTwoDigitPrimes();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD18(InstructionClue clue, Set<int> possibleValue) {
    /* Lucky and happy number, 2 digits */
    var values = LuckyNumbers.where((element) => HappyNumbers.contains(element))
        .toList();
    if (validD18forA9.isNotEmpty) {
      var set = values.toSet();
      set = set.intersection(validD18forA9);
      // if (set.length != values.length)
      //   print(
      //       '${clue.name} reference removed ${values.length - set.length} values');
      values = set.toList();
    }
    filterDigits(clue, values, possibleValue);
    return false;
    // puzzle.addReference(a9, d18, true);
  }

  bool solveD19(InstructionClue clue, Set<int> possibleValue) {
    /* DP equals another entry, 3 digits */
    return solveDPOtherClueValue(clue, possibleValue, clue.values);
  }

  bool solveD20(InstructionClue clue, Set<int> possibleValue) {
    /* (DS + DP) is a multiple of D21, 3 digits */
    if (d21.values != null) {
      return solveClueValue(
        clue,
        possibleValue,
        (value) {
          var valueDP = dp(value);
          var valueDS = ds(value);
          var sum = valueDP + valueDS;
          return d21.values!.any((value) => sum % value == 0);
        },
      );
    }
    return false;
  }

  bool solveD21(InstructionClue clue, Set<int> possibleValue) {
    // Multiple of 10, 2 digits
    var values = <int>[10, 20, 30, 40, 50, 60, 70, 80, 90];
    // Check referring cells
    var set = values.toSet();
    if (validD21forA7.isNotEmpty) set = set.intersection(validD21forA7);
    if (validD21forA11.isNotEmpty) set = set.intersection(validD21forA11);
    if (validD21forA19.isNotEmpty) set = set.intersection(validD21forA19);
    if (validD21forA29.isNotEmpty) set = set.intersection(validD21forA29);
    // if (set.length != values.length)
    //   print(
    //       '${clue.name} reference removed ${values.length - set.length} values');
    values = set.toList();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD22(InstructionClue clue, Set<int> possibleValue) {
    /* DP is a power of 2, 3 digits */
    var getPowers = (lo, hi) => getPowersInRange(lo, hi, 2, 0);
    return solveDPConstraint(
        clue, possibleValue, getThreeDigitNumbers, getPowers);
  }

  bool solveD24(InstructionClue clue, Set<int> possibleValue) {
    /* DP is square, 2 digits */
    return solveDPConstraint(
        clue, possibleValue, getTwoDigitNumbers, getSquaresInRange);
  }

  bool solveD25(InstructionClue clue, Set<int> possibleValue) {
    /* Lucky number, 2 digits */
    var values = LuckyNumbers;
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD27(InstructionClue clue, Set<int> possibleValue) {
    /* Fibonacci number, 2 digits */
    var values = getTwoDigitFibonacci();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  void resetSolution() {
    puzzle.resetSolution();
    validA3forD3 = {};
    validD13forA20 = {};
    validD18forA9 = {};
    validD21forA11 = {};
    validD21forA19 = {};
    validD21forA29 = {};
    validD21forA7 = {};
    validD8forD4 = {};
  }

  void solve([bool iteration = true]) {
    print("SOLVE------------");

    super.solve(false);

    // Partial solution enabled me to guess the words
    // formed by the Down clues, and so restrict some
    // of the values - this gave 2 solutions
    this.resetSolution();
    puzzle.fixClue('D8', 55);
    puzzle.fixClue('D1', 38);
    puzzle.fixClue('D3', 172);
    puzzle.fixClue('D4', 65);
    puzzle.fixClue('D6', 189);
    puzzle.fixClue('D15', 35);
    puzzle.fixClue('D13', 28);
    puzzle.fixClue('D16', 59);
    puzzle.fixClue('D19', 415);
    puzzle.fixClue('D24', 19);
    puzzle.fixClue('D25', 15);

    super.solve(true);

    // Reversing the Across Entries gives a different
    // potential solution
    this.resetSolution();
    puzzle.fixClue('A1', 153);
    puzzle.fixClue('A3', 961);
    puzzle.fixClue('A7', 28);
    puzzle.fixClue('A9', 57);
    puzzle.fixClue('A10', 88);
    puzzle.fixClue('A11', 2558);
    puzzle.fixClue('A13', 92);
    puzzle.fixClue('A14', 531);
    puzzle.fixClue('A17', 483);
    puzzle.fixClue('A19', 54);
    puzzle.fixClue('A20', 9221);
    puzzle.fixClue('A23', 11);
    puzzle.fixClue('A25', 71);
    puzzle.fixClue('A26', 81);
    puzzle.fixClue('A28', 459);
    puzzle.fixClue('A29', 983);

    puzzle.fixClue('D1', 12);
    puzzle.fixClue('D2', 585);
    puzzle.fixClue('D3', 958);
    puzzle.fixClue('D4', 67);
    puzzle.fixClue('D5', 18);
    puzzle.fixClue('D6', 182);
    puzzle.fixClue('D8', 55);
    puzzle.fixClue('D11', 25);
    puzzle.fixClue('D12', 24);
    puzzle.fixClue('D13', 98);
    puzzle.fixClue('D15', 34);
    puzzle.fixClue('D16', 19);
    puzzle.fixClue('D18', 31);
    puzzle.fixClue('D19', 515);
    puzzle.fixClue('D20', 919);
    puzzle.fixClue('D21', 20);
    puzzle.fixClue('D22', 288);
    puzzle.fixClue('D24', 14);
    puzzle.fixClue('D25', 75);
    puzzle.fixClue('D27', 13);

    super.solve(true);
  }
}

int ds(int value) {
  var digits = value.toString().split('').map((e) => int.parse(e));
  var result =
      digits.fold<int>(0, (previousValue, element) => previousValue + element);
  return result;
}

int dp(int value) {
  var digits = value.toString().split('').map((e) => int.parse(e));
  var result =
      digits.fold<int>(1, (previousValue, element) => previousValue * element);
  return result;
}

int mp(int value) {
  var next = value;
  var result = 0;
  while (next > 9) {
    next = dp(next);
    result++;
  }
  return result;
}
