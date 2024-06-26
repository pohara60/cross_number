import 'package:powers/powers.dart';
import '../crossnumber.dart';
import '../dicenets/clue.dart';
import '../dicenets/puzzle.dart';

import '../generators.dart';
import '../puzzle.dart';
import '../variable.dart';

class DiceNets extends Crossnumber<DiceNetsPuzzle> {
  DiceNets() {
    puzzle = DiceNetsPuzzle();
    initCrossnumber();
  }

  late final DiceNetsEntry a1;
  late final DiceNetsEntry a4;
  late final DiceNetsEntry a8;
  late final DiceNetsEntry a10;
  late final DiceNetsEntry a12;
  late final DiceNetsEntry a14;
  late final DiceNetsEntry a16;
  late final DiceNetsEntry a17;
  late final DiceNetsEntry a18;
  late final DiceNetsEntry a19;
  late final DiceNetsEntry a21;
  late final DiceNetsEntry a23;
  late final DiceNetsEntry a25;
  late final DiceNetsEntry a27;
  late final DiceNetsEntry a29;
  late final DiceNetsEntry a30;
  late final DiceNetsEntry a31;
  late final DiceNetsEntry a33;
  late final DiceNetsEntry a35;
  late final DiceNetsEntry a36;

  late final DiceNetsEntry d1;
  late final DiceNetsEntry d2;
  late final DiceNetsEntry d3;
  late final DiceNetsEntry d5;
  late final DiceNetsEntry d6;
  late final DiceNetsEntry d7;
  late final DiceNetsEntry d9;
  late final DiceNetsEntry d11;
  late final DiceNetsEntry d13;
  late final DiceNetsEntry d15;
  late final DiceNetsEntry d18;
  late final DiceNetsEntry d20;
  late final DiceNetsEntry d22;
  late final DiceNetsEntry d24;
  late final DiceNetsEntry d26;
  late final DiceNetsEntry d28;
  late final DiceNetsEntry d32;
  late final DiceNetsEntry d34;

  SolveFunction solveWrapper(
      bool Function(DiceNetsEntry clue, Set<int> possibleValue) solve) {
    bool solveDiceNetsClue(
      Puzzle p,
      Variable v,
      Set<int> possibleValue, {
      Set<int>? possibleValue2,
      Map<Variable, Set<int>>? possibleVariables,
      Map<Variable, Set<int>>? possibleVariables2,
      Set<Variable>? updatedVariables,
    }) {
      var clue = v as DiceNetsEntry;
      return solve(clue, possibleValue);
    }

    return solveDiceNetsClue;
  }

  @override
  void initCrossnumber() {
    a1 = DiceNetsEntry(
        name: 'A1',
        length: 4,
        valueDesc: 'Prime',
        solve: solveWrapper(solveA1));
    puzzle.addEntry(a1);
    a4 = DiceNetsEntry(
        name: 'A4',
        length: 4,
        valueDesc: 'Power',
        solve: solveWrapper(solveA4));
    puzzle.addEntry(a4);
    a8 = DiceNetsEntry(
        name: 'A8',
        length: 4,
        valueDesc: 'Triangular - A18',
        solve: solveWrapper(solveA8));
    puzzle.addEntry(a8);
    a10 = DiceNetsEntry(
        name: 'A10',
        length: 3,
        valueDesc: 'Multiple of D34',
        solve: solveWrapper(solveA10));
    puzzle.addEntry(a10);
    a12 = DiceNetsEntry(
        name: 'A12',
        length: 3,
        valueDesc: 'Even Square',
        solve: solveWrapper(solveA12));
    puzzle.addEntry(a12);
    a14 = DiceNetsEntry(
        name: 'A14',
        length: 2,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveA14));
    puzzle.addEntry(a14);
    a16 = DiceNetsEntry(
        name: 'A16',
        length: 3,
        valueDesc: 'Triangular - A31',
        solve: solveWrapper(solveA16));
    puzzle.addEntry(a16);
    a17 = DiceNetsEntry(
        name: 'A17',
        length: 4,
        valueDesc: 'Multiple of D7',
        solve: solveWrapper(solveA17));
    puzzle.addEntry(a17);
    a18 = DiceNetsEntry(
        name: 'A18',
        length: 5,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveA18));
    puzzle.addEntry(a18);
    a19 = DiceNetsEntry(
        name: 'A19',
        length: 2,
        valueDesc: 'Triangular - A29',
        solve: solveWrapper(solveA19));
    puzzle.addEntry(a19);
    a21 = DiceNetsEntry(
        name: 'A21',
        length: 2,
        valueDesc: 'Power',
        solve: solveWrapper(solveA21));
    puzzle.addEntry(a21);
    a23 = DiceNetsEntry(
        name: 'A23',
        length: 5,
        valueDesc: 'Multiple of D32',
        solve: solveWrapper(solveA23));
    puzzle.addEntry(a23);
    a25 = DiceNetsEntry(
        name: 'A25',
        length: 4,
        valueDesc: 'Prime',
        solve: solveWrapper(solveA25));
    puzzle.addEntry(a25);
    a27 = DiceNetsEntry(
        name: 'A27',
        length: 3,
        valueDesc: 'Square - A16',
        solve: solveWrapper(solveA27));
    puzzle.addEntry(a27);
    a29 = DiceNetsEntry(
        name: 'A29',
        length: 2,
        valueDesc: 'Multiple of a Power',
        solve: solveWrapper(solveA29));
    puzzle.addEntry(a29);
    a30 = DiceNetsEntry(
        name: 'A30',
        length: 3,
        valueDesc: 'Square + D24',
        solve: solveWrapper(solveA30));
    puzzle.addEntry(a30);
    a31 = DiceNetsEntry(
        name: 'A31',
        length: 3,
        valueDesc: 'Square - A16',
        solve: solveWrapper(solveA31));
    puzzle.addEntry(a31);
    a33 = DiceNetsEntry(
        name: 'A33',
        length: 4,
        valueDesc: 'Multiple of A30',
        solve: solveWrapper(solveA33));
    puzzle.addEntry(a33);
    a35 = DiceNetsEntry(
        name: 'A35',
        length: 4,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveA35));
    puzzle.addEntry(a35);
    a36 = DiceNetsEntry(
        name: 'A36',
        length: 4,
        valueDesc: 'Jumble of D1',
        solve: solveWrapper(solveA36));
    puzzle.addEntry(a36);

    d1 = DiceNetsEntry(
        name: 'D1',
        length: 4,
        valueDesc: 'Square',
        solve: solveWrapper(solveD1));
    puzzle.addEntry(d1);
    d2 = DiceNetsEntry(
        name: 'D2',
        length: 6,
        valueDesc: 'Square',
        solve: solveWrapper(solveD2));
    puzzle.addEntry(d2);
    d3 = DiceNetsEntry(
        name: 'D3',
        length: 2,
        valueDesc: 'Product 3 distinct Primes',
        solve: solveWrapper(solveD3));
    puzzle.addEntry(d3);
    d5 = DiceNetsEntry(
        name: 'D5',
        length: 5,
        valueDesc: 'Product 3 distinct Primes',
        solve: solveWrapper(solveD5));
    puzzle.addEntry(d5);
    d6 = DiceNetsEntry(
        name: 'D6',
        length: 4,
        valueDesc: 'D7 + D18',
        solve: solveWrapper(solveD6));
    puzzle.addEntry(d6);
    d7 = DiceNetsEntry(
        name: 'D7',
        length: 2,
        valueDesc: 'Power',
        solve: solveWrapper(solveD7));
    puzzle.addEntry(d7);
    d9 = DiceNetsEntry(
        name: 'D9',
        length: 7,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveD9));
    puzzle.addEntry(d9);
    d11 = DiceNetsEntry(
        name: 'D11',
        length: 3,
        valueDesc: 'Twice a Square',
        solve: solveWrapper(solveD11));
    puzzle.addEntry(d11);
    d13 = DiceNetsEntry(
        name: 'D13',
        length: 7,
        valueDesc: 'Square',
        solve: solveWrapper(solveD13));
    puzzle.addEntry(d13);
    d15 = DiceNetsEntry(
        name: 'D15',
        length: 4,
        valueDesc: 'Square',
        solve: solveWrapper(solveD15));
    puzzle.addEntry(d15);
    d18 = DiceNetsEntry(
        name: 'D18',
        length: 4,
        valueDesc: 'Power',
        solve: solveWrapper(solveD18));
    puzzle.addEntry(d18);
    d20 = DiceNetsEntry(
        name: 'D20',
        length: 6,
        valueDesc: 'Square',
        solve: solveWrapper(solveD20));
    puzzle.addEntry(d20);
    d22 = DiceNetsEntry(
        name: 'D22',
        length: 5,
        valueDesc: 'Multiple of Square of D32',
        solve: solveWrapper(solveD22));
    puzzle.addEntry(d22);
    d24 = DiceNetsEntry(
        name: 'D24',
        length: 3,
        valueDesc: 'Sum of 2 consecutive Squares',
        solve: solveWrapper(solveD24));
    puzzle.addEntry(d24);
    d26 = DiceNetsEntry(
        name: 'D26',
        length: 4,
        valueDesc: 'Half of a Triangular',
        solve: solveWrapper(solveD26));
    puzzle.addEntry(d26);
    d28 = DiceNetsEntry(
        name: 'D28',
        length: 4,
        valueDesc: 'Square',
        solve: solveWrapper(solveD28));
    puzzle.addEntry(d28);
    d32 = DiceNetsEntry(
        name: 'D32',
        length: 2,
        valueDesc: 'A19 - D7',
        solve: solveWrapper(solveD32));
    puzzle.addEntry(d32);
    d34 = DiceNetsEntry(
        name: 'D34',
        length: 2,
        valueDesc: 'Prime',
        solve: solveWrapper(solveD34));
    puzzle.addEntry(d34);

    puzzle.addDigitIdentity(a1, 1, d1, 1);
    puzzle.addDigitIdentity(a1, 2, d2, 1);
    puzzle.addDigitIdentity(a1, 3, d3, 1);
    puzzle.addDigitIdentity(a4, 2, d5, 1);
    puzzle.addDigitIdentity(a4, 3, d6, 1);
    puzzle.addDigitIdentity(a4, 4, d7, 1);
    puzzle.addDigitIdentity(a8, 1, d3, 2);
    puzzle.addDigitIdentity(a8, 2, d9, 1);
    puzzle.addDigitIdentity(a8, 4, d5, 2);
    puzzle.addDigitIdentity(a10, 1, d1, 3);
    puzzle.addDigitIdentity(a10, 2, d2, 3);
    puzzle.addDigitIdentity(a10, 3, d11, 1);
    puzzle.addDigitIdentity(a12, 1, d9, 2);
    puzzle.addDigitIdentity(a12, 2, d13, 1);
    puzzle.addDigitIdentity(a12, 3, d5, 3);
    puzzle.addDigitIdentity(a14, 1, d6, 3);
    puzzle.addDigitIdentity(a14, 2, d15, 1);
    puzzle.addDigitIdentity(a16, 1, d1, 4);
    puzzle.addDigitIdentity(a16, 2, d2, 4);
    puzzle.addDigitIdentity(a16, 3, d11, 2);
    puzzle.addDigitIdentity(a17, 1, d13, 2);
    puzzle.addDigitIdentity(a17, 2, d5, 4);
    puzzle.addDigitIdentity(a17, 3, d6, 4);
    puzzle.addDigitIdentity(a17, 4, d15, 2);
    puzzle.addDigitIdentity(a18, 2, d2, 5);
    puzzle.addDigitIdentity(a18, 3, d11, 3);
    puzzle.addDigitIdentity(a18, 4, d9, 4);
    puzzle.addDigitIdentity(a18, 5, d13, 3);
    puzzle.addDigitIdentity(a19, 1, d5, 5);
    puzzle.addDigitIdentity(a19, 2, d20, 1);
    puzzle.addDigitIdentity(a21, 1, d2, 6);
    puzzle.addDigitIdentity(a21, 2, d22, 1);
    puzzle.addDigitIdentity(a23, 1, d9, 5);
    puzzle.addDigitIdentity(a23, 2, d13, 4);
    puzzle.addDigitIdentity(a23, 3, d24, 1);
    puzzle.addDigitIdentity(a23, 4, d20, 2);
    puzzle.addDigitIdentity(a23, 5, d15, 4);
    puzzle.addDigitIdentity(a25, 1, d18, 3);
    puzzle.addDigitIdentity(a25, 2, d26, 1);
    puzzle.addDigitIdentity(a25, 3, d22, 2);
    puzzle.addDigitIdentity(a25, 4, d9, 6);
    puzzle.addDigitIdentity(a27, 1, d24, 2);
    puzzle.addDigitIdentity(a27, 2, d20, 3);
    puzzle.addDigitIdentity(a27, 3, d28, 1);
    puzzle.addDigitIdentity(a29, 1, d18, 4);
    puzzle.addDigitIdentity(a29, 2, d26, 2);
    puzzle.addDigitIdentity(a30, 1, d22, 3);
    puzzle.addDigitIdentity(a30, 2, d9, 7);
    puzzle.addDigitIdentity(a30, 3, d13, 6);
    puzzle.addDigitIdentity(a31, 1, d24, 3);
    puzzle.addDigitIdentity(a31, 2, d20, 4);
    puzzle.addDigitIdentity(a31, 3, d28, 2);
    puzzle.addDigitIdentity(a33, 1, d22, 4);
    puzzle.addDigitIdentity(a33, 3, d13, 7);
    puzzle.addDigitIdentity(a33, 4, d34, 1);
    puzzle.addDigitIdentity(a35, 1, d32, 2);
    puzzle.addDigitIdentity(a35, 2, d26, 4);
    puzzle.addDigitIdentity(a35, 3, d22, 5);
    puzzle.addDigitIdentity(a36, 2, d34, 2);
    puzzle.addDigitIdentity(a36, 3, d20, 6);
    puzzle.addDigitIdentity(a36, 4, d28, 4);

    puzzle.addEntryReference(a8, a18, false);
    puzzle.addEntryReference(a10, d34, false);
    puzzle.addEntryReference(a16, a31, false);
    puzzle.addEntryReference(a17, d7, false);
    puzzle.addEntryReference(a19, a29, false);
    puzzle.addEntryReference(a23, d32, false);
    puzzle.addEntryReference(a27, a16, false);
    puzzle.addEntryReference(a30, d24, false);
    puzzle.addEntryReference(a31, a16, false);
    puzzle.addEntryReference(a33, a30, false);
    puzzle.addEntryReference(a36, d1, true);
    puzzle.addEntryReference(d6, d7, false);
    puzzle.addEntryReference(d6, d18, false);
    puzzle.addEntryReference(d22, d32, false);
    puzzle.addEntryReference(d32, a19, false);
    puzzle.addEntryReference(d32, d7, false);

    puzzle.finalize();
    super.initCrossnumber();
  }

  static List<int> filterDice(Iterable<int> values) {
    List<int> dice = [];
    for (var value in values) {
      var ok = true;
      for (var digit in value.toString().split('')) {
        if ("7890".contains(digit)) {
          ok = false;
          break;
        }
      }
      if (ok) dice.add(value);
    }
    return dice;
  }

  static void filterDigits(
      DiceNetsEntry clue, List<int> values, Set<int> possibleValue) {
    for (var value in values) {
      if (clue.digitsMatch(value)) {
        possibleValue.add(value);
      }
    }
  }

  static void filterDiceDigits(
      DiceNetsEntry clue, List<int> values, Set<int> possibleValue) {
    filterDigits(clue, filterDice(values), possibleValue);
  }

  bool solveA1(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA4(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPowers(), possibleValue);
    return false;
  }

  bool solveA8(DiceNetsEntry clue, Set<int> possibleValue) {
    findTriangularsLessClue(clue, a18, possibleValue);
    return false;
  }

  bool solveA10(DiceNetsEntry clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d34, possibleValue);
    return false;
  }

  bool solveA12(DiceNetsEntry clue, Set<int> possibleValue) {
    var values = filterDice(getThreeDigitSquares());
    values.removeWhere((value) => value % 2 == 1);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA14(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA16(DiceNetsEntry clue, Set<int> possibleValue) {
    if (a31.values != null) {
      findTriangularsLessClue(clue, a31, possibleValue);
    } else {
      // A16 and A31 are mutually referential, so need a way to get started
      var values = getValuesFromClueDigits(a31);
      if (values != null) {
        findTriangularsLessValues(clue, values, possibleValue);
      }
    }
    return false;
  }

  bool solveA17(DiceNetsEntry clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d7, possibleValue);
    return false;
  }

  bool solveA18(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFiveDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA19(DiceNetsEntry clue, Set<int> possibleValue) {
    findTriangularsLessClue(clue, a29, possibleValue);
    return false;
  }

  bool solveA21(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitPowers(), possibleValue);
    return false;
  }

  bool solveA23(DiceNetsEntry clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d32, possibleValue);
    return false;
  }

  bool solveA25(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA27(DiceNetsEntry clue, Set<int> possibleValue) {
    findSquarePlusOrMinusClue(clue, a16, possibleValue, false);
    return false;
  }

  bool solveA29(DiceNetsEntry clue, Set<int> possibleValue) {
    findMultiplesOfPower(clue, possibleValue);
    return false;
  }

  bool solveA30(DiceNetsEntry clue, Set<int> possibleValue) {
    findSquarePlusOrMinusClue(clue, d24, possibleValue, true);
    return false;
  }

  bool solveA31(DiceNetsEntry clue, Set<int> possibleValue) {
    if (a16.values != null) {
      findTriangularsLessClue(clue, a16, possibleValue);
    } else {
      // A16 and A31 are mutually referential, so need a way to get started
      var values = getValuesFromClueDigits(a16);
      if (values != null) {
        findTriangularsLessValues(clue, values, possibleValue);
      }
    }
    return false;
  }

  bool solveA33(DiceNetsEntry clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, a30, possibleValue);
    return false;
  }

  bool solveA35(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA36(DiceNetsEntry clue, Set<int> possibleValue) {
    // A36 is Jumble of D1
    if (d1.values != null) {
      // Construct Jumbles of all values
      for (var value in d1.values!) {
        var jumbles = <int>{};
        for (var d1 = 0; d1 < 4; d1++) {
          for (var d2 = 0; d2 < 4; d2++) {
            if (d2 != d1) {
              for (var d3 = 0; d3 < 4; d3++) {
                if (d3 != d1 && d3 != d2) {
                  for (var d4 = 0; d4 < 4; d4++) {
                    if (d4 != d3 && d4 != d1 && d4 != d2) {
                      var str = value.toString();
                      var jumble = str[d1] + str[d2] + str[d3] + str[d4];
                      jumbles.add(int.parse(jumble));
                    }
                  }
                }
              }
            }
          }
        }
        var possible = <int>{};
        filterDiceDigits(clue, jumbles.toList(), possible);
        possibleValue.addAll(possible);
      }
    }
    return false;
  }

  static bool solveFourDigitSquares(
      DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    return false;
  }

  bool solveD1(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    // A36 is Jumble of D1, so check for illegal values
    if (possibleValue.isNotEmpty) {
      // Find required and forbidden digits in A36, check for D1 values that have them
      var required = <int>{};
      var forbidden = Set.from(List.generate(6, (index) => index + 1));
      for (var d = 0; d < a36.length!; d++) {
        if (a36.digits[d].length == 1) {
          required.addAll(a36.digits[d]);
        }
        forbidden.removeAll(a36.digits[d]);
      }
      if (required.isNotEmpty || forbidden.isNotEmpty) {
        var removeValue = <int>{};
        for (var value in possibleValue) {
          var ok = true;
          for (var digit in required) {
            if (!value.toString().contains(digit.toString())) {
              ok = false;
              break;
            }
          }
          for (var digit in forbidden) {
            if (value.toString().contains(digit.toString())) {
              ok = false;
              break;
            }
          }
          // Update D1
          if (!ok) {
            removeValue.add(value);
          }
        }
        possibleValue.removeAll(removeValue);
      }
    }
    return false;
  }

  static bool solveSixDigitSquares(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSixDigitSquares(), possibleValue);
    return false;
  }

  var solveD2 = solveSixDigitSquares;

  bool solveD3(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitMultipleThreePrimes(), possibleValue);
    return false;
  }

  bool solveD5(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFiveDigitMultipleThreePrimes(), possibleValue);
    return false;
  }

  bool solveD6(DiceNetsEntry clue, Set<int> possibleValue) {
    findPlusOrMinusClues(clue, d7, d18, possibleValue, true);
    return false;
  }

  bool solveD7(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitPowers(), possibleValue);
    return false;
  }

  bool solveD9(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSevenDigitTriangles(), possibleValue);
    return false;
  }

  bool solveD11(DiceNetsEntry clue, Set<int> possibleValue) {
    var squares = getTwoDigitSquares().where((value) => value >= 50).toList();
    squares.addAll(getThreeDigitSquares().where((value) => value < 500));
    var values = squares.map((value) => 2 * value).toList();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  static bool solveSevenDigitSquares(
      DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSevenDigitSquares(), possibleValue);
    return false;
  }

  var solveD13 = solveSevenDigitSquares;

  bool solveD15(DiceNetsEntry clue, Set<int> possibleValue) {
    var values = filterDice(getFourDigitSquares());
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD18(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPowers(), possibleValue);
    return false;
  }

  var solveD20 = solveSixDigitSquares;

  bool solveD22(DiceNetsEntry clue, Set<int> possibleValue) {
    if (d32.values != null) {
      var values = d32.values!.map((value) => value * value).toList();
      findMultiplesOfValues(clue, values, possibleValue);
    }
    return false;
  }

  bool solveD24(DiceNetsEntry clue, Set<int> possibleValue) {
    // Sum of two consecutive squares
    var squares = getSquaresInRange(49, 999);
    int previous = 0;
    var values = <int>[];
    for (var square in squares) {
      if (previous != 0) {
        var sum = previous + square;
        if (sum < 100) continue;
        if (sum > 999) break;
        values.add(sum);
      }
      previous = square;
    }
    filterDiceDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD26(DiceNetsEntry clue, Set<int> possibleValue) {
    var triangles = getFourDigitTriangles()
        .where((value) => value >= 2000 && value % 2 == 0)
        .toList();
    triangles.addAll(getFiveDigitTriangles()
        .where((value) => value < 20000 && value % 2 == 0));
    var values = triangles.map((value) => value ~/ 2).toList();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD28(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    return false;
  }

  bool solveD32(DiceNetsEntry clue, Set<int> possibleValue) {
    findPlusOrMinusClues(clue, a19, d7, possibleValue, false);
    return false;
  }

  bool solveD34(DiceNetsEntry clue, Set<int> possibleValue) {
    filterDiceDigits(clue, twoDigitPrimes, possibleValue);
    return false;
  }

  static void findTriangularsLessClue(
      DiceNetsEntry output, DiceNetsEntry input, Set<int> possibleValue) {
    if (input.values != null) {
      findTriangularsLessValues(output, input.values!, possibleValue);
    }
  }

  static void findTriangularsLessValues(
      DiceNetsEntry clue, Set<int> values, Set<int> possibleValue) {
    var result = getTriangularsLessValues(clue, values);
    if (result != null) {
      var possible = <int>{};
      filterDiceDigits(clue, result, possible);
      possibleValue.addAll(possible);
    }
  }

  static void findPlusOrMinusClues(DiceNetsEntry output, DiceNetsEntry input1,
      DiceNetsEntry input2, possibleValue,
      [bool plus = false]) {
    if (input1.values != null && input2.values != null) {
      var lo = 10.pow(output.length! - 1) as int;
      var hi = (10.pow(output.length!) as int) - 1;
      for (var value1 in input1.values!) {
        var values = <int>[];
        for (var value2 in input2.values!) {
          var difference = plus ? value1 + value2 : value1 - value2;
          if (difference < lo) continue;
          if (difference >= hi) continue;
          values.add(difference);
        }
        var possible = <int>{};
        filterDiceDigits(output, values, possible);
        possibleValue.addAll(possible);
      }
    }
  }

  static void findSquarePlusOrMinusClue(
      DiceNetsEntry output, DiceNetsEntry input, possibleValue,
      [bool plus = false]) {
    if (input.values != null) {
      var minInput = input.values!
          .reduce((value, element) => element < value ? element : value);
      var maxInput = input.values!
          .reduce((value, element) => element > value ? element : value);
      var lo = 10.pow(output.length! - 1) as int;
      var hi = (10.pow(output.length!) as int) - 1;
      int minSquare;
      int maxSquare;
      if (plus) {
        minSquare = lo > maxInput ? lo - maxInput : 1;
        maxSquare = hi - minInput;
      } else {
        minSquare = lo + minInput;
        maxSquare = hi + maxInput;
      }
      var squares = getSquaresInRange(minSquare, maxSquare);
      for (var value in input.values!) {
        var values = <int>[];
        for (var square in squares) {
          var difference = plus ? square + value : square - value;
          if (difference < lo) continue;
          if (difference >= hi) continue;
          values.add(difference);
        }
        var possible = <int>{};
        filterDiceDigits(output, values, possible);
        possibleValue.addAll(possible);
      }
    }
  }

  static void findMultiplesOfPower(DiceNetsEntry clue, Set<int> possibleValue) {
    var hi = clue.max!;
    var squares = getPowersInRange(1, hi);
    findMultiplesOfValues(clue, squares, possibleValue);
  }

  static void findMultiplesOfClue(
      DiceNetsEntry output, DiceNetsEntry input, Set<int> possibleValue) {
    if (input.values != null) {
      findMultiplesOfValues(output, input.values!.toList(), possibleValue);
    }
  }

  static void findMultiplesOfValues(
      DiceNetsEntry clue, List<int> values, Set<int> possibleValue) {
    var multiples = getMultiplesOfValues(clue, values);
    if (multiples != null) {
      var possible = <int>{};
      filterDiceDigits(clue, multiples, possible);
      possibleValue.addAll(possible);
    }
  }
}
