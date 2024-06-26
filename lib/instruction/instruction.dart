import 'dart:io';
import 'dart:math';

import '../crossnumber.dart';
import '../instruction/clue.dart';
import '../instruction/puzzle.dart';

import '../generators.dart';
import '../puzzle.dart';
import '../variable.dart';

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
    puzzle = InstructionPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  var happyNumbers = [
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
  var luckyNumbers = [
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

  late final InstructionEntry a1;
  late final InstructionEntry a3;
  late final InstructionEntry a7;
  late final InstructionEntry a9;
  late final InstructionEntry a10;
  late final InstructionEntry a11;
  late final InstructionEntry a13;
  late final InstructionEntry a14;
  late final InstructionEntry a17;
  late final InstructionEntry a19;
  late final InstructionEntry a20;
  late final InstructionEntry a23;
  late final InstructionEntry a25;
  late final InstructionEntry a26;
  late final InstructionEntry a28;
  late final InstructionEntry a29;

  late final InstructionEntry d1;
  late final InstructionEntry d2;
  late final InstructionEntry d3;
  late final InstructionEntry d4;
  late final InstructionEntry d5;
  late final InstructionEntry d6;
  late final InstructionEntry d8;
  late final InstructionEntry d11;
  late final InstructionEntry d12;
  late final InstructionEntry d13;
  late final InstructionEntry d15;
  late final InstructionEntry d16;
  late final InstructionEntry d18;
  late final InstructionEntry d19;
  late final InstructionEntry d20;
  late final InstructionEntry d21;
  late final InstructionEntry d22;
  late final InstructionEntry d24;
  late final InstructionEntry d25;
  late final InstructionEntry d27;

  SolveFunction solveWrapper(
      bool Function(InstructionEntry clue, Set<int> possibleValue) solve) {
    bool solveInstructionClue(
      Puzzle p,
      Variable v,
      Set<int> possibleValue, {
      Set<int>? possibleValue2,
      Map<Variable, Set<int>>? possibleVariables,
      Map<Variable, Set<int>>? possibleVariables2,
      Set<Variable>? updatedVariables,
    }) {
      var clue = v as InstructionEntry;
      return solve(clue, possibleValue);
    }

    return solveInstructionClue;
  }

  @override
  void initCrossnumber() {
    a1 = InstructionEntry(
        name: 'A1',
        length: 3,
        valueDesc: 'Triangular number with a triangular DP',
        solve: solveWrapper(solveA1));
    puzzle.addEntry(a1);
    a3 = InstructionEntry(
        name: 'A3',
        length: 3,
        valueDesc: 'Square number with a square DS',
        solve: solveWrapper(solveA3));
    puzzle.addEntry(a3);
    a7 = InstructionEntry(
        name: 'A7',
        length: 2,
        valueDesc: 'DS is half of D21',
        solve: solveWrapper(solveA7));
    puzzle.addEntry(a7);
    a9 = InstructionEntry(
        name: 'A9',
        length: 2,
        valueDesc: 'D18+26',
        solve: solveWrapper(solveA9));
    puzzle.addEntry(a9);
    a10 = InstructionEntry(
        name: 'A10',
        length: 2,
        valueDesc: 'Palindrome',
        solve: solveWrapper(solveA10));
    puzzle.addEntry(a10);
    a11 = InstructionEntry(
        name: 'A11',
        length: 4,
        valueDesc: 'DS equals D21',
        solve: solveWrapper(solveA11));
    puzzle.addEntry(a11);
    a13 = InstructionEntry(
        name: 'A13',
        length: 2,
        valueDesc: 'Digits have opposite parity and DP equals another entry',
        solve: solveWrapper(solveA13));
    puzzle.addEntry(a13);
    a14 = InstructionEntry(
        name: 'A14',
        length: 3,
        valueDesc:
            'Consecutive odd digits in ascending or descending order, with triangular DP',
        solve: solveWrapper(solveA14));
    puzzle.addEntry(a14);
    a17 = InstructionEntry(
        name: 'A17',
        length: 3,
        valueDesc: 'DS is triangular',
        solve: solveWrapper(solveA17));
    puzzle.addEntry(a17);
    a19 = InstructionEntry(
        name: 'A19',
        length: 2,
        valueDesc: 'DP equals D21',
        solve: solveWrapper(solveA19));
    puzzle.addEntry(a19);
    a20 = InstructionEntry(
        name: 'A20',
        length: 4,
        valueDesc: 'Prime whose DP is square and DS is a factor of D13',
        solve: solveWrapper(solveA20));
    puzzle.addEntry(a20);
    a23 = InstructionEntry(
        name: 'A23',
        length: 2,
        valueDesc: 'Palindromic prime',
        solve: solveWrapper(solveA23));
    puzzle.addEntry(a23);
    a25 = InstructionEntry(
        name: 'A25',
        length: 2,
        valueDesc: 'Prime',
        solve: solveWrapper(solveA25));
    puzzle.addEntry(a25);
    a26 = InstructionEntry(
        name: 'A26',
        length: 2,
        valueDesc: 'DP is a cube',
        solve: solveWrapper(solveA26));
    puzzle.addEntry(a26);
    a28 = InstructionEntry(
        name: 'A28',
        length: 3,
        valueDesc: 'DP equals 180',
        solve: solveWrapper(solveA28));
    puzzle.addEntry(a28);
    a29 = InstructionEntry(
        name: 'A29',
        length: 3,
        valueDesc: 'DS equals D21 and DP is a cube',
        solve: solveWrapper(solveA29));
    puzzle.addEntry(a29);

    d1 = InstructionEntry(
        name: 'D1',
        length: 2,
        valueDesc: '(DS+DP) is an odd multiple of 5',
        solve: solveWrapper(solveD1));
    puzzle.addEntry(d1);
    d2 = InstructionEntry(
        name: 'D2',
        length: 3,
        valueDesc: 'Palindrome and multiple of 5 with MP of 2',
        solve: solveWrapper(solveD2));
    puzzle.addEntry(d2);
    d3 = InstructionEntry(
        name: 'D3',
        length: 3,
        valueDesc: 'A3 plus or minus 3',
        solve: solveWrapper(solveD3));
    puzzle.addEntry(d3);
    d4 = InstructionEntry(
        name: 'D4',
        length: 2,
        valueDesc: 'Greater than D8 and DS equals another entry',
        solve: solveWrapper(solveD4));
    puzzle.addEntry(d4);
    d5 = InstructionEntry(
        name: 'D5',
        length: 2,
        valueDesc: '2 times a square',
        solve: solveWrapper(solveD5));
    puzzle.addEntry(d5);
    d6 = InstructionEntry(
        name: 'D6',
        length: 3,
        valueDesc: 'Has 8 factors including 1 and itself',
        solve: solveWrapper(solveD6));
    puzzle.addEntry(d6);
    d8 = InstructionEntry(
        name: 'D8',
        length: 2,
        valueDesc: 'Square pyramidal number (ie, sum of the first n squares)',
        solve: solveWrapper(solveD8));
    puzzle.addEntry(d8);
    d11 = InstructionEntry(
        name: 'D11',
        length: 2,
        valueDesc: 'Square',
        solve: solveWrapper(solveD11));
    puzzle.addEntry(d11);
    d12 = InstructionEntry(
        name: 'D12',
        length: 2,
        valueDesc: 'DP is a single-digit even number',
        solve: solveWrapper(solveD12));
    puzzle.addEntry(d12);
    d13 = InstructionEntry(
        name: 'D13',
        length: 2,
        valueDesc: 'Multiple of 7',
        solve: solveWrapper(solveD13));
    puzzle.addEntry(d13);
    d15 = InstructionEntry(
        name: 'D15',
        length: 2,
        valueDesc: 'DP equals another entry',
        solve: solveWrapper(solveD15));
    puzzle.addEntry(d15);
    d16 = InstructionEntry(
        name: 'D16',
        length: 2,
        valueDesc: 'Prime',
        solve: solveWrapper(solveD16));
    puzzle.addEntry(d16);
    d18 = InstructionEntry(
        name: 'D18',
        length: 2,
        valueDesc: 'Lucky and happy number',
        solve: solveWrapper(solveD18));
    puzzle.addEntry(d18);
    d19 = InstructionEntry(
        name: 'D19',
        length: 3,
        valueDesc: 'DP equals another entry',
        solve: solveWrapper(solveD19));
    puzzle.addEntry(d19);
    d20 = InstructionEntry(
        name: 'D20',
        length: 3,
        valueDesc: '(DS + DP) is a multiple of D21',
        solve: solveWrapper(solveD20));
    puzzle.addEntry(d20);
    d21 = InstructionEntry(
        name: 'D21',
        length: 2,
        valueDesc: 'Multiple of 10',
        solve: solveWrapper(solveD21));
    puzzle.addEntry(d21);
    d22 = InstructionEntry(
        name: 'D22',
        length: 3,
        valueDesc: 'DP is a power of 2',
        solve: solveWrapper(solveD22));
    puzzle.addEntry(d22);
    d24 = InstructionEntry(
        name: 'D24',
        length: 2,
        valueDesc: 'DP is square',
        solve: solveWrapper(solveD24));
    puzzle.addEntry(d24);
    d25 = InstructionEntry(
        name: 'D25',
        length: 2,
        valueDesc: 'Lucky number',
        solve: solveWrapper(solveD25));
    puzzle.addEntry(d25);
    d27 = InstructionEntry(
        name: 'D27',
        length: 2,
        valueDesc: 'Fibonacci number',
        solve: solveWrapper(solveD27));
    puzzle.addEntry(d27);

    // D8 references all other cells!
    puzzle.linkEntriesToGrid();
    puzzle.addClueReference(a7, d21, true);
    puzzle.addClueReference(a9, d18, true);
    puzzle.addClueReference(a11, d21, true);
    puzzle.addClueReference(a19, d21, true);
    puzzle.addClueReference(a20, d13, true);
    puzzle.addClueReference(a29, d21, true);
    puzzle.addClueReference(d3, a3, true);
    puzzle.addClueReference(d4, d8, true);
    // d4 refers all
    // d15 refers all
    // d19 refers all
    puzzle.addClueReference(d20, d21, false);
    // printReferences();

    puzzle.finalize();
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
      InstructionEntry clue, List<int> values, Set<int> possibleValue) {
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
      InstructionEntry clue,
      Set<int> possibleValue,
      List<int> Function() getValues,
      int Function(int) getConstraintValue,
      List<int> Function(int, int) getConstraintValues) {
    var values = <int>[];
    var possible = clue.getValues(getValues);
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
      InstructionEntry clue,
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
      InstructionEntry clue,
      Set<int> possibleValue,
      List<int> Function() getValues,
      List<int> Function(int, int) getDPValues) {
    return solveConstraint(clue, possibleValue, getValues, dp, getDPValues);
  }

  bool solveDSConstraint(
      InstructionEntry clue,
      Set<int> possibleValue,
      List<int> Function() getValues,
      List<int> Function(int, int) getDSValues) {
    return solveConstraint(clue, possibleValue, getValues, ds, getDSValues);
  }

  List<int> solveClueValues(
      InstructionEntry clue, Set<int> possibleValue, bool Function(int) valueOK,
      [Iterable<int>? clueValues]) {
    var values = <int>[];
    for (var value in clue.getValues(() => clueValues ?? clue.range)) {
      if (valueOK(value)) {
        values.add(value);
      }
    }
    return values;
  }

  bool solveClueValue(
      InstructionEntry clue, Set<int> possibleValue, bool Function(int) valueOK,
      [Iterable<int>? clueValues]) {
    var values = solveClueValues(clue, possibleValue, valueOK, clueValues);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  List<int> solveOtherClueValues(
      InstructionEntry clue,
      InstructionEntry otherClue,
      Set<int> possibleValue,
      List<int> Function(int) getOtherValues,
      [Iterable<int>? clueValues]) {
    if (otherClue.values != null) {
      var values = <int>[];
      var validOtherValues = <int>{};
      for (var value in clue.getValues(() => clueValues ?? clue.range)) {
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
      otherClue.restrictedValues = validOtherValues;
      return values;
    }
    return <int>[];
  }

  bool solveOtherClueValue(InstructionEntry clue, InstructionEntry otherClue,
      Set<int> possibleValue, List<int> Function(int) otherValues,
      [Iterable<int>? clueValues]) {
    if (otherClue.values != null) {
      var values = solveOtherClueValues(
          clue, otherClue, possibleValue, otherValues, clueValues);
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  bool clueLimitedValues(InstructionEntry clue) =>
      clue.values != null && clue.values!.length <= 10;

  bool solveValueOtherClueValue(
      InstructionEntry clue, Set<int> possibleValue, int Function(int) getValue,
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

  bool solveDPOtherClueValue(InstructionEntry clue, Set<int> possibleValue,
      [Iterable<int>? clueValues]) {
    return solveValueOtherClueValue(clue, possibleValue, dp, clueValues);
  }

  bool solveDSOtherClueValue(InstructionEntry clue, Set<int> possibleValue,
      [Iterable<int>? clueValues]) {
    return solveValueOtherClueValue(clue, possibleValue, ds, clueValues);
  }

  bool solveA1(InstructionEntry clue, Set<int> possibleValue) {
    /* Triangular number with a triangular DP, 3 digits */
    return solveDPConstraint(
        clue, possibleValue, getThreeDigitTriangles, getTrianglesInRange);
  }

  bool solveA3(InstructionEntry clue, Set<int> possibleValue) {
    /* Square number with a square DS, 3 digits */
    var values = clue.getValues(getThreeDigitSquares);
    return solveDSConstraint(
        clue, possibleValue, () => values, getSquaresInRange);
  }

  bool solveA7(InstructionEntry clue, Set<int> possibleValue) {
    /* DS is half of D21, 2 digits */
    return solveOtherClueValue(
        clue, d21, possibleValue, (value) => [ds(value) * 2]);
  }

  bool solveA9(InstructionEntry clue, Set<int> possibleValue) {
    /* D18+26, 2 digits */
    return solveOtherClueValue(
        clue, d18, possibleValue, (value) => [value - 26]);
  }

  bool solveA10(InstructionEntry clue, Set<int> possibleValue) {
    /* Palindrome, 2 digits */
    var values = clue.getValues(getTwoDigitPalindromes);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA11(InstructionEntry clue, Set<int> possibleValue) {
    /* DS equals D21, 4 digits */
    return solveOtherClueValue(
        clue, d21, possibleValue, (value) => [ds(value)]);
  }

  bool solveA13(InstructionEntry clue, Set<int> possibleValue) {
    /* Digits have opposite parity and DP equals another entry, 2 digits */
    // Check parity first
    var values = clue.getValues(() => clue.range
        .where((value) => (value ~/ 10 % 2 + value % 10 % 2) == 1)
        .toList());
    filterDigits(clue, values, possibleValue);
    // Check other entries (if possible)
    return solveDPOtherClueValue(clue, possibleValue, possibleValue);
  }

  bool solveA14(InstructionEntry clue, Set<int> possibleValue) {
    /* Consecutive odd digits in ascending or descending order, with triangular DP, 3 digits */
    var values = clue.getValues(() => clue.range.where((value) {
          var d1 = value ~/ 100;
          var d2 = value ~/ 10 % 10;
          var d3 = value % 10;
          if (d1 < d2) {
            return d1 % 2 == 1 && d2 == (d1 + 2) && d3 == (d2 + 2);
          } else {
            return d1 % 2 == 1 && d2 == (d3 + 2) && d1 == (d2 + 2);
          }
        }).toList());
    return solveDPConstraint(
        clue, possibleValue, () => values, getTrianglesInRange);
  }

  bool solveA17(InstructionEntry clue, Set<int> possibleValue) {
    /* DS is triangular, 3 digits */
    return solveDSConstraint(
        clue, possibleValue, getThreeDigitNumbers, getTrianglesInRange);
  }

  bool solveA19(InstructionEntry clue, Set<int> possibleValue) {
    /* DP equals D21, 2 digits */
    return solveOtherClueValue(
        clue, d21, possibleValue, (value) => [dp(value)]);
  }

  bool solveA20(InstructionEntry clue, Set<int> possibleValue) {
    /* Prime whose DP is square and DS is a factor of D13, 4 digits */
    // Check parity first
    var values = solveConstraintValues(
        clue, possibleValue, getFourDigitPrimes, dp, getSquaresInRange);
    if (d13.values != null) {
      var validD13forA20 = <int>{};
      var result = solveClueValue(clue, possibleValue, (value) {
        if (!clue.digitsMatch(value)) return false;
        var valueDS = ds(value);
        var otherValues = d13.values!.where((value) => value % valueDS == 0);
        if (otherValues.isEmpty) return false;
        for (var otherValue in otherValues) {
          validD13forA20.add(otherValue);
        }
        return true;
      }, values);
      d13.restrictedValues = validD13forA20;
      return result;
    }
    // Progress with these values
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA23(InstructionEntry clue, Set<int> possibleValue) {
    /* Palindromic prime, 2 digits */
    var values = <int>[11];
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA25(InstructionEntry clue, Set<int> possibleValue) {
    /* Prime, 2 digits */
    var values = clue.getValues(getTwoDigitPrimes);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA26(InstructionEntry clue, Set<int> possibleValue) {
    /* DP is a cube, 2 digits */
    return solveDPConstraint(
        clue, possibleValue, getTwoDigitNumbers, getCubesInRange);
  }

  bool solveA28(InstructionEntry clue, Set<int> possibleValue) {
    /* DP equals 180, 3 digits */
    return solveDPConstraint(
        clue, possibleValue, getThreeDigitNumbers, (lo, hi) => [180]);
  }

  bool solveA29(InstructionEntry clue, Set<int> possibleValue) {
    /* DS equals D21 and DP is a cube, 3 digits */
    var values = solveConstraintValues(
        clue, possibleValue, getThreeDigitNumbers, dp, getCubesInRange);
    if (d21.values != null) {
      return solveOtherClueValue(
          clue, d21, possibleValue, (value) => [ds(value)], values);
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD1(InstructionEntry clue, Set<int> possibleValue) {
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

  bool solveD2(InstructionEntry clue, Set<int> possibleValue) {
    /* Palindrome and multiple of 5 with MP of 2, 3 digits */
    var values = clue.getValues(getThreeDigitPalindromes);
    return solveClueValue(
      clue,
      possibleValue,
      (value) => (value % 5) == 0 && mp(value) == 2,
      values,
    );
  }

  bool solveD3(InstructionEntry clue, Set<int> possibleValue) {
    /* A3 plus or minus 3, 3 digits */
    return solveOtherClueValue(
        clue, a3, possibleValue, (value) => [value - 3, value + 3]);
  }

  bool solveD4(InstructionEntry clue, Set<int> possibleValue) {
    /* Greater than D8 and DS equals another entry, 2 digits */
    if (d8.values != null) {
      var minValue = d8.values!.reduce(min) + 1;
      if (minValue > 10) {
        var values = clue.range.where((value) => value > minValue).toList();
        filterDigits(clue, values, possibleValue);
        var result = solveDSOtherClueValue(clue, possibleValue, possibleValue);
        var maxValue = possibleValue.reduce(max);
        d8.restrictedValues =
            d8.values!.where((element) => element < maxValue).toSet();
        return result;
      }
    }
    return false;
  }

  bool solveD5(InstructionEntry clue, Set<int> possibleValue) {
    /* 2 times a square, 2 digits */
    var values = clue.getValues(() => <int>[18, 32, 50, 72, 98]);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD6(InstructionEntry clue, Set<int> possibleValue) {
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

  bool solveD8(InstructionEntry clue, Set<int> possibleValue) {
    /* Square pyramidal number (ie, sum of the first n squares), 2 digits */
    var values = clue.getValues(getTwoDigitPyramidal);
    filterDigits(clue, values, possibleValue);
    return false;
    // puzzle.addReference(d4, d8, true);
  }

  bool solveD11(InstructionEntry clue, Set<int> possibleValue) {
    /* Square, 2 digits */
    var values = clue.getValues(getTwoDigitSquares);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD12(InstructionEntry clue, Set<int> possibleValue) {
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

  bool solveD13(InstructionEntry clue, Set<int> possibleValue) {
    /* Multiple of 7, 2 digits */
    var values = clue.getValues(
        () => clue.range.where((value) => (value % 7) == 0).toList());
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD15(InstructionEntry clue, Set<int> possibleValue) {
    /* DP equals another entry, 2 digits */
    return solveDPOtherClueValue(clue, possibleValue, clue.values);
  }

  bool solveD16(InstructionEntry clue, Set<int> possibleValue) {
    /* Prime, 2 digits */
    var values = clue.getValues(getTwoDigitPrimes);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD18(InstructionEntry clue, Set<int> possibleValue) {
    /* Lucky and happy number, 2 digits */
    var values = clue.getValues(() => luckyNumbers
        .where((element) => happyNumbers.contains(element))
        .toList());
    filterDigits(clue, values, possibleValue);
    return false;
    // puzzle.addReference(a9, d18, true);
  }

  bool solveD19(InstructionEntry clue, Set<int> possibleValue) {
    /* DP equals another entry, 3 digits */
    return solveDPOtherClueValue(clue, possibleValue, clue.values);
  }

  bool solveD20(InstructionEntry clue, Set<int> possibleValue) {
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

  bool solveD21(InstructionEntry clue, Set<int> possibleValue) {
    // Multiple of 10, 2 digits
    var values =
        clue.getValues(() => <int>[10, 20, 30, 40, 50, 60, 70, 80, 90]);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD22(InstructionEntry clue, Set<int> possibleValue) {
    /* DP is a power of 2, 3 digits */
    getPowers(lo, hi) => getPowersInRange(lo, hi, 2, 0);
    return solveDPConstraint(
        clue, possibleValue, getThreeDigitNumbers, getPowers);
  }

  bool solveD24(InstructionEntry clue, Set<int> possibleValue) {
    /* DP is square, 2 digits */
    return solveDPConstraint(
        clue, possibleValue, getTwoDigitNumbers, getSquaresInRange);
  }

  bool solveD25(InstructionEntry clue, Set<int> possibleValue) {
    /* Lucky number, 2 digits */
    var values = clue.getValues(() => luckyNumbers);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD27(InstructionEntry clue, Set<int> possibleValue) {
    /* Fibonacci number, 2 digits */
    var values = clue.getValues(getTwoDigitFibonacci);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  void resetSolution() {
    puzzle.resetSolution();
  }

  @override
  void solve([bool iteration = true]) {
    print("SOLVE------------");

    super.solve(false);

    // Partial solution enabled me to guess the words
    // formed by the Down clues, and so restrict some
    // of the values - this gave 2 solutions
    resetSolution();
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
    resetSolution();
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
