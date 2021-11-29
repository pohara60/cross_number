import 'package:powers/powers.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/dicenets/clue.dart';
import 'package:crossnumber/dicenets/puzzle.dart';

class DiceNets extends Crossnumber {
  late DiceNetsPuzzle puzzle;

  DiceNets() {
    puzzle = DiceNetsPuzzle();
    initCrossnumber();
  }

  late final DiceNetsClue a1;
  late final DiceNetsClue a4;
  late final DiceNetsClue a8;
  late final DiceNetsClue a10;
  late final DiceNetsClue a12;
  late final DiceNetsClue a14;
  late final DiceNetsClue a16;
  late final DiceNetsClue a17;
  late final DiceNetsClue a18;
  late final DiceNetsClue a19;
  late final DiceNetsClue a21;
  late final DiceNetsClue a23;
  late final DiceNetsClue a25;
  late final DiceNetsClue a27;
  late final DiceNetsClue a29;
  late final DiceNetsClue a30;
  late final DiceNetsClue a31;
  late final DiceNetsClue a33;
  late final DiceNetsClue a35;
  late final DiceNetsClue a36;

  late final DiceNetsClue d1;
  late final DiceNetsClue d2;
  late final DiceNetsClue d3;
  late final DiceNetsClue d5;
  late final DiceNetsClue d6;
  late final DiceNetsClue d7;
  late final DiceNetsClue d9;
  late final DiceNetsClue d11;
  late final DiceNetsClue d13;
  late final DiceNetsClue d15;
  late final DiceNetsClue d18;
  late final DiceNetsClue d20;
  late final DiceNetsClue d22;
  late final DiceNetsClue d24;
  late final DiceNetsClue d26;
  late final DiceNetsClue d28;
  late final DiceNetsClue d32;
  late final DiceNetsClue d34;

  void initCrossnumber() {
    puzzle.clues = {};
    a1 =
        DiceNetsClue(name: 'A1', length: 4, valueDesc: 'Prime', solve: solveA1);
    puzzle.addClue(a1);
    a4 =
        DiceNetsClue(name: 'A4', length: 4, valueDesc: 'Power', solve: solveA4);
    puzzle.addClue(a4);
    a8 = DiceNetsClue(
        name: 'A8', length: 4, valueDesc: 'Triangular - A18', solve: solveA8);
    puzzle.addClue(a8);
    a10 = DiceNetsClue(
        name: 'A10', length: 3, valueDesc: 'Multiple of D34', solve: solveA10);
    puzzle.addClue(a10);
    a12 = DiceNetsClue(
        name: 'A12', length: 3, valueDesc: 'Even Square', solve: solveA12);
    puzzle.addClue(a12);
    a14 = DiceNetsClue(
        name: 'A14', length: 2, valueDesc: 'Triangular', solve: solveA14);
    puzzle.addClue(a14);
    a16 = DiceNetsClue(
        name: 'A16', length: 3, valueDesc: 'Triangular - A31', solve: solveA16);
    puzzle.addClue(a16);
    a17 = DiceNetsClue(
        name: 'A17', length: 4, valueDesc: 'Multiple of D7', solve: solveA17);
    puzzle.addClue(a17);
    a18 = DiceNetsClue(
        name: 'A18', length: 5, valueDesc: 'Triangular', solve: solveA18);
    puzzle.addClue(a18);
    a19 = DiceNetsClue(
        name: 'A19', length: 2, valueDesc: 'Triangular - A29', solve: solveA19);
    puzzle.addClue(a19);
    a21 = DiceNetsClue(
        name: 'A21', length: 2, valueDesc: 'Power', solve: solveA21);
    puzzle.addClue(a21);
    a23 = DiceNetsClue(
        name: 'A23', length: 5, valueDesc: 'Multiple of D32', solve: solveA23);
    puzzle.addClue(a23);
    a25 = DiceNetsClue(
        name: 'A25', length: 4, valueDesc: 'Prime', solve: solveA25);
    puzzle.addClue(a25);
    a27 = DiceNetsClue(
        name: 'A27', length: 3, valueDesc: 'Square - A16', solve: solveA27);
    puzzle.addClue(a27);
    a29 = DiceNetsClue(
        name: 'A29',
        length: 2,
        valueDesc: 'Multiple of a Power',
        solve: solveA29);
    puzzle.addClue(a29);
    a30 = DiceNetsClue(
        name: 'A30', length: 3, valueDesc: 'Square + D24', solve: solveA30);
    puzzle.addClue(a30);
    a31 = DiceNetsClue(
        name: 'A31', length: 3, valueDesc: 'Square - A16', solve: solveA31);
    puzzle.addClue(a31);
    a33 = DiceNetsClue(
        name: 'A33', length: 4, valueDesc: 'Multiple of A30', solve: solveA33);
    puzzle.addClue(a33);
    a35 = DiceNetsClue(
        name: 'A35', length: 4, valueDesc: 'Triangular', solve: solveA35);
    puzzle.addClue(a35);
    a36 = DiceNetsClue(
        name: 'A36', length: 4, valueDesc: 'Jumble of D1', solve: solveA36);
    puzzle.addClue(a36);

    d1 = DiceNetsClue(
        name: 'D1', length: 4, valueDesc: 'Square', solve: solveD1);
    puzzle.addClue(d1);
    d2 = DiceNetsClue(
        name: 'D2', length: 6, valueDesc: 'Square', solve: solveD2);
    puzzle.addClue(d2);
    d3 = DiceNetsClue(
        name: 'D3',
        length: 2,
        valueDesc: 'Product 3 distinct Primes',
        solve: solveD3);
    puzzle.addClue(d3);
    d5 = DiceNetsClue(
        name: 'D5',
        length: 5,
        valueDesc: 'Product 3 distinct Primes',
        solve: solveD5);
    puzzle.addClue(d5);
    d6 = DiceNetsClue(
        name: 'D6', length: 4, valueDesc: 'D7 + D18', solve: solveD6);
    puzzle.addClue(d6);
    d7 =
        DiceNetsClue(name: 'D7', length: 2, valueDesc: 'Power', solve: solveD7);
    puzzle.addClue(d7);
    d9 = DiceNetsClue(
        name: 'D9', length: 7, valueDesc: 'Triangular', solve: solveD9);
    puzzle.addClue(d9);
    d11 = DiceNetsClue(
        name: 'D11', length: 3, valueDesc: 'Twice a Square', solve: solveD11);
    puzzle.addClue(d11);
    d13 = DiceNetsClue(
        name: 'D13', length: 7, valueDesc: 'Square', solve: solveD13);
    puzzle.addClue(d13);
    d15 = DiceNetsClue(
        name: 'D15', length: 4, valueDesc: 'Square', solve: solveD15);
    puzzle.addClue(d15);
    d18 = DiceNetsClue(
        name: 'D18', length: 4, valueDesc: 'Power', solve: solveD18);
    puzzle.addClue(d18);
    d20 = DiceNetsClue(
        name: 'D20', length: 6, valueDesc: 'Square', solve: solveD20);
    puzzle.addClue(d20);
    d22 = DiceNetsClue(
        name: 'D22',
        length: 5,
        valueDesc: 'Multiple of Square of D32',
        solve: solveD22);
    puzzle.addClue(d22);
    d24 = DiceNetsClue(
        name: 'D24',
        length: 3,
        valueDesc: 'Sum of 2 consecutive Squares',
        solve: solveD24);
    puzzle.addClue(d24);
    d26 = DiceNetsClue(
        name: 'D26',
        length: 4,
        valueDesc: 'Half of a Triangular',
        solve: solveD26);
    puzzle.addClue(d26);
    d28 = DiceNetsClue(
        name: 'D28', length: 4, valueDesc: 'Square', solve: solveD28);
    puzzle.addClue(d28);
    d32 = DiceNetsClue(
        name: 'D32', length: 2, valueDesc: 'A19 - D7', solve: solveD32);
    puzzle.addClue(d32);
    d34 = DiceNetsClue(
        name: 'D34', length: 2, valueDesc: 'Prime', solve: solveD34);
    puzzle.addClue(d34);

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

    puzzle.addReference(a8, a18, false);
    puzzle.addReference(a10, d34, false);
    puzzle.addReference(a16, a31, false);
    puzzle.addReference(a17, d7, false);
    puzzle.addReference(a19, a29, false);
    puzzle.addReference(a23, d32, false);
    puzzle.addReference(a27, a16, false);
    puzzle.addReference(a30, d24, false);
    puzzle.addReference(a31, a16, false);
    puzzle.addReference(a33, a30, false);
    puzzle.addReference(a36, d1, true);
    puzzle.addReference(d6, d7, false);
    puzzle.addReference(d6, d18, false);
    puzzle.addReference(d22, d32, false);
    puzzle.addReference(d32, a19, false);
    puzzle.addReference(d32, d7, false);

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
      DiceNetsClue clue, List<int> values, Set<int> possibleValue) {
    for (var value in values) {
      if (clue.digitsMatch(value)) {
        possibleValue.add(value);
      }
    }
  }

  static void filterDiceDigits(
      DiceNetsClue clue, List<int> values, Set<int> possibleValue) {
    filterDigits(clue, filterDice(values), possibleValue);
  }

  bool solveA1(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA4(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPowers(), possibleValue);
    return false;
  }

  bool solveA8(DiceNetsClue clue, Set<int> possibleValue) {
    findTriangularsLessClue(clue, a18, possibleValue);
    return false;
  }

  bool solveA10(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d34, possibleValue);
    return false;
  }

  bool solveA12(DiceNetsClue clue, Set<int> possibleValue) {
    var values = filterDice(getThreeDigitSquares());
    values.removeWhere((value) => value % 2 == 1);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA14(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA16(DiceNetsClue clue, Set<int> possibleValue) {
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

  Set<int>? getValuesFromClueDigits(DiceNetsClue clue) {
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

  bool solveA17(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d7, possibleValue);
    return false;
  }

  bool solveA18(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFiveDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA19(DiceNetsClue clue, Set<int> possibleValue) {
    findTriangularsLessClue(clue, a29, possibleValue);
    return false;
  }

  bool solveA21(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitPowers(), possibleValue);
    return false;
  }

  bool solveA23(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d32, possibleValue);
    return false;
  }

  bool solveA25(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA27(DiceNetsClue clue, Set<int> possibleValue) {
    findSquarePlusOrMinusClue(clue, a16, possibleValue, false);
    return false;
  }

  bool solveA29(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfPower(clue, possibleValue);
    return false;
  }

  bool solveA30(DiceNetsClue clue, Set<int> possibleValue) {
    findSquarePlusOrMinusClue(clue, d24, possibleValue, true);
    return false;
  }

  bool solveA31(DiceNetsClue clue, Set<int> possibleValue) {
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

  bool solveA33(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, a30, possibleValue);
    return false;
  }

  bool solveA35(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA36(DiceNetsClue clue, Set<int> possibleValue) {
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

  static bool solveFourDigitSquares(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    return false;
  }

  bool solveD1(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    // A36 is Jumble of D1, so check for illegal values
    if (possibleValue.length > 0) {
      // Find required and forbidden digits in A36, check for D1 values that have them
      var required = <int>{};
      var forbidden = Set.from(List.generate(6, (index) => index + 1));
      for (var d = 0; d < a36.length; d++) {
        if (a36.digits[d].length == 1) {
          required.addAll(a36.digits[d]);
        }
        forbidden.removeAll(a36.digits[d]);
      }
      if (required.length > 0 || forbidden.length > 0) {
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

  static bool solveSixDigitSquares(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSixDigitSquares(), possibleValue);
    return false;
  }

  var solveD2 = solveSixDigitSquares;

  bool solveD3(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitMultipleThreePrimes(), possibleValue);
    return false;
  }

  bool solveD5(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFiveDigitMultipleThreePrimes(), possibleValue);
    return false;
  }

  bool solveD6(DiceNetsClue clue, Set<int> possibleValue) {
    findPlusOrMinusClues(clue, d7, d18, possibleValue, true);
    return false;
  }

  bool solveD7(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitPowers(), possibleValue);
    return false;
  }

  bool solveD9(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSevenDigitTriangles(), possibleValue);
    return false;
  }

  bool solveD11(DiceNetsClue clue, Set<int> possibleValue) {
    var squares = getTwoDigitSquares().where((value) => value >= 50).toList();
    squares.addAll(getThreeDigitSquares().where((value) => value < 500));
    var values = squares.map((value) => 2 * value).toList();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  static bool solveSevenDigitSquares(
      DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSevenDigitSquares(), possibleValue);
    return false;
  }

  var solveD13 = solveSevenDigitSquares;

  bool solveD15(DiceNetsClue clue, Set<int> possibleValue) {
    var values = filterDice(getFourDigitSquares());
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD18(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPowers(), possibleValue);
    return false;
  }

  var solveD20 = solveSixDigitSquares;

  bool solveD22(DiceNetsClue clue, Set<int> possibleValue) {
    if (d32.values != null) {
      var values = d32.values!.map((value) => value * value).toList();
      findMultiplesOfValues(clue, values, possibleValue);
    }
    return false;
  }

  bool solveD24(DiceNetsClue clue, Set<int> possibleValue) {
    // Sum of two consecutive squares
    var squares = getSquaresRange(49, 999);
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

  bool solveD26(DiceNetsClue clue, Set<int> possibleValue) {
    var triangles = getFourDigitTriangles()
        .where((value) => value >= 2000 && value % 2 == 0)
        .toList();
    triangles.addAll(getFiveDigitTriangles()
        .where((value) => value < 20000 && value % 2 == 0));
    var values = triangles.map((value) => value ~/ 2).toList();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD28(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    return false;
  }

  bool solveD32(DiceNetsClue clue, Set<int> possibleValue) {
    findPlusOrMinusClues(clue, a19, d7, possibleValue, false);
    return false;
  }

  bool solveD34(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, twoDigitPrimes, possibleValue);
    return false;
  }

  static void findTriangularsLessClue(
      DiceNetsClue output, DiceNetsClue input, Set<int> possibleValue) {
    if (input.values != null) {
      findTriangularsLessValues(output, input.values!, possibleValue);
    }
  }

  static void findTriangularsLessValues(
      DiceNetsClue output, Set<int> values, Set<int> possibleValue) {
    var minInput =
        values.reduce((value, element) => element < value ? element : value);
    var maxInput =
        values.reduce((value, element) => element > value ? element : value);
    var lo = 10.pow(output.length - 1) as int;
    var hi = (10.pow(output.length) as int) - 1;
    var minTriangle = lo + minInput;
    var maxTriangle = hi + maxInput;
    var triangles = getTrianglesRange(minTriangle, maxTriangle);
    for (var value in values) {
      var values = <int>[];
      for (var triangle in triangles) {
        var difference = triangle - value;
        if (difference < lo) continue;
        if (difference >= hi) continue;
        values.add(difference);
      }
      var possible = <int>{};
      filterDiceDigits(output, values, possible);
      possibleValue.addAll(possible);
    }
  }

  static void findPlusOrMinusClues(DiceNetsClue output, DiceNetsClue input1,
      DiceNetsClue input2, possibleValue,
      [bool plus = false]) {
    if (input1.values != null && input2.values != null) {
      var lo = 10.pow(output.length - 1) as int;
      var hi = (10.pow(output.length) as int) - 1;
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
      DiceNetsClue output, DiceNetsClue input, possibleValue,
      [bool plus = false]) {
    if (input.values != null) {
      var minInput = input.values!
          .reduce((value, element) => element < value ? element : value);
      var maxInput = input.values!
          .reduce((value, element) => element > value ? element : value);
      var lo = 10.pow(output.length - 1) as int;
      var hi = (10.pow(output.length) as int) - 1;
      int minSquare;
      int maxSquare;
      if (plus) {
        minSquare = lo > maxInput ? lo - maxInput : 1;
        maxSquare = hi - minInput;
      } else {
        minSquare = lo + minInput;
        maxSquare = hi + maxInput;
      }
      var squares = getSquaresRange(minSquare, maxSquare);
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

  static void findMultiplesOfPower(DiceNetsClue clue, Set<int> possibleValue) {
    var hi = (10.pow(clue.length) as int) - 1;
    var squares = getPowersInRange(1, hi);
    findMultiplesOfValues(clue, squares, possibleValue);
  }

  static void findMultiplesOfClue(
      DiceNetsClue output, DiceNetsClue input, Set<int> possibleValue) {
    if (input.values != null) {
      findMultiplesOfValues(output, input.values!.toList(), possibleValue);
    }
  }

  static void findMultiplesOfValues(
      DiceNetsClue clue, List<int> values, Set<int> possibleValue) {
    var loResult = 10.pow(clue.length - 1) as int;
    var hiResult = (10.pow(clue.length) as int) - 1;
    for (var value in values) {
      var loMultiplier = loResult ~/ value;
      if (loMultiplier < 2) loMultiplier = 2;
      var hiMultiplier = hiResult ~/ value;
      var values = <int>[];
      for (var multiplier = loMultiplier;
          multiplier <= hiMultiplier;
          multiplier++) {
        var multiple = multiplier * value;
        if (multiple < loResult) continue;
        if (multiple >= hiResult) continue;
        values.add(multiple);
      }
      var possible = <int>{};
      filterDiceDigits(clue, values, possible);
      possibleValue.addAll(possible);
    }
  }
}
