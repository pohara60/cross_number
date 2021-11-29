import 'package:powers/powers.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/puzzle.dart';

class DiceNets extends Crossnumber {
  late final Clue a1;
  late final Clue a4;
  late final Clue a8;
  late final Clue a10;
  late final Clue a12;
  late final Clue a14;
  late final Clue a16;
  late final Clue a17;
  late final Clue a18;
  late final Clue a19;
  late final Clue a21;
  late final Clue a23;
  late final Clue a25;
  late final Clue a27;
  late final Clue a29;
  late final Clue a30;
  late final Clue a31;
  late final Clue a33;
  late final Clue a35;
  late final Clue a36;

  late final Clue d1;
  late final Clue d2;
  late final Clue d3;
  late final Clue d5;
  late final Clue d6;
  late final Clue d7;
  late final Clue d9;
  late final Clue d11;
  late final Clue d13;
  late final Clue d15;
  late final Clue d18;
  late final Clue d20;
  late final Clue d22;
  late final Clue d24;
  late final Clue d26;
  late final Clue d28;
  late final Clue d32;
  late final Clue d34;

  void initCrossnumber() {
    a1 = Clue(name: 'A1', length: 4, valueDesc: 'Prime', solve: solveA1);
    puzzle.addClue(a1);
    a4 = Clue(name: 'A4', length: 4, valueDesc: 'Power', solve: solveA4);
    puzzle.addClue(a4);
    a8 = Clue(
        name: 'A8', length: 4, valueDesc: 'Triangular - A18', solve: solveA8);
    puzzle.addClue(a8);
    a10 = Clue(
        name: 'A10', length: 3, valueDesc: 'Multiple of D34', solve: solveA10);
    puzzle.addClue(a10);
    a12 =
        Clue(name: 'A12', length: 3, valueDesc: 'Even Square', solve: solveA12);
    puzzle.addClue(a12);
    a14 =
        Clue(name: 'A14', length: 2, valueDesc: 'Triangular', solve: solveA14);
    puzzle.addClue(a14);
    a16 = Clue(
        name: 'A16', length: 3, valueDesc: 'Triangular - A31', solve: solveA16);
    puzzle.addClue(a16);
    a17 = Clue(
        name: 'A17', length: 4, valueDesc: 'Multiple of D7', solve: solveA17);
    puzzle.addClue(a17);
    a18 =
        Clue(name: 'A18', length: 5, valueDesc: 'Triangular', solve: solveA18);
    puzzle.addClue(a18);
    a19 = Clue(
        name: 'A19', length: 2, valueDesc: 'Triangular - A29', solve: solveA19);
    puzzle.addClue(a19);
    a21 = Clue(name: 'A21', length: 2, valueDesc: 'Power', solve: solveA21);
    puzzle.addClue(a21);
    a23 = Clue(
        name: 'A23', length: 5, valueDesc: 'Multiple of D32', solve: solveA23);
    puzzle.addClue(a23);
    a25 = Clue(name: 'A25', length: 4, valueDesc: 'Prime', solve: solveA25);
    puzzle.addClue(a25);
    a27 = Clue(
        name: 'A27', length: 3, valueDesc: 'Square - A16', solve: solveA27);
    puzzle.addClue(a27);
    a29 = Clue(
        name: 'A29',
        length: 2,
        valueDesc: 'Multiple of a Power',
        solve: solveA29);
    puzzle.addClue(a29);
    a30 = Clue(
        name: 'A30', length: 3, valueDesc: 'Square + D24', solve: solveA30);
    puzzle.addClue(a30);
    a31 = Clue(
        name: 'A31', length: 3, valueDesc: 'Square - A16', solve: solveA31);
    puzzle.addClue(a31);
    a33 = Clue(
        name: 'A33', length: 4, valueDesc: 'Multiple of A30', solve: solveA33);
    puzzle.addClue(a33);
    a35 =
        Clue(name: 'A35', length: 4, valueDesc: 'Triangular', solve: solveA35);
    puzzle.addClue(a35);
    a36 = Clue(
        name: 'A36', length: 4, valueDesc: 'Jumble of D1', solve: solveA36);
    puzzle.addClue(a36);

    d1 = Clue(name: 'D1', length: 4, valueDesc: 'Square', solve: solveD1);
    puzzle.addClue(d1);
    d2 = Clue(name: 'D2', length: 6, valueDesc: 'Square', solve: solveD2);
    puzzle.addClue(d2);
    d3 = Clue(
        name: 'D3',
        length: 2,
        valueDesc: 'Product 3 distinct Primes',
        solve: solveD3);
    puzzle.addClue(d3);
    d5 = Clue(
        name: 'D5',
        length: 5,
        valueDesc: 'Product 3 distinct Primes',
        solve: solveD5);
    puzzle.addClue(d5);
    d6 = Clue(name: 'D6', length: 4, valueDesc: 'D7 + D18', solve: solveD6);
    puzzle.addClue(d6);
    d7 = Clue(name: 'D7', length: 2, valueDesc: 'Power', solve: solveD7);
    puzzle.addClue(d7);
    d9 = Clue(name: 'D9', length: 7, valueDesc: 'Triangular', solve: solveD9);
    puzzle.addClue(d9);
    d11 = Clue(
        name: 'D11', length: 3, valueDesc: 'Twice a Square', solve: solveD11);
    puzzle.addClue(d11);
    d13 = Clue(name: 'D13', length: 7, valueDesc: 'Square', solve: solveD13);
    puzzle.addClue(d13);
    d15 = Clue(name: 'D15', length: 4, valueDesc: 'Square', solve: solveD15);
    puzzle.addClue(d15);
    d18 = Clue(name: 'D18', length: 4, valueDesc: 'Power', solve: solveD18);
    puzzle.addClue(d18);
    d20 = Clue(name: 'D20', length: 6, valueDesc: 'Square', solve: solveD20);
    puzzle.addClue(d20);
    d22 = Clue(
        name: 'D22',
        length: 5,
        valueDesc: 'Multiple of Square of D32',
        solve: solveD22);
    puzzle.addClue(d22);
    d24 = Clue(
        name: 'D24',
        length: 3,
        valueDesc: 'Sum of 2 consecutive Squares',
        solve: solveD24);
    puzzle.addClue(d24);
    d26 = Clue(
        name: 'D26',
        length: 4,
        valueDesc: 'Half of a Triangular',
        solve: solveD26);
    puzzle.addClue(d26);
    d28 = Clue(name: 'D28', length: 4, valueDesc: 'Square', solve: solveD28);
    puzzle.addClue(d28);
    d32 = Clue(name: 'D32', length: 2, valueDesc: 'A19 - D7', solve: solveD32);
    puzzle.addClue(d32);
    d34 = Clue(name: 'D34', length: 2, valueDesc: 'Prime', solve: solveD34);
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
      Clue clue, List<int> values, Set<int> possibleValue) {
    for (var value in values) {
      if (clue.digitsMatch(value)) {
        possibleValue.add(value);
      }
    }
  }

  static void filterDiceDigits(
      Clue clue, List<int> values, Set<int> possibleValue) {
    filterDigits(clue, filterDice(values), possibleValue);
  }

  bool solveA1(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA4(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPowers(), possibleValue);
    return false;
  }

  bool solveA8(Clue clue, Set<int> possibleValue) {
    findTriangularsLessClue(clue, a18, possibleValue);
    return false;
  }

  bool solveA10(Clue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d34, possibleValue);
    return false;
  }

  bool solveA12(Clue clue, Set<int> possibleValue) {
    var values = filterDice(getThreeDigitSquares());
    values.removeWhere((value) => value % 2 == 1);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA14(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA16(Clue clue, Set<int> possibleValue) {
    if (a31.values != null) {
      if (a31.values!.length == 13) {
        var b = true;
      }
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

  bool solveA17(Clue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d7, possibleValue);
    return false;
  }

  bool solveA18(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFiveDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA19(Clue clue, Set<int> possibleValue) {
    findTriangularsLessClue(clue, a29, possibleValue);
    return false;
  }

  bool solveA21(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitPowers(), possibleValue);
    return false;
  }

  bool solveA23(Clue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d32, possibleValue);
    return false;
  }

  bool solveA25(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA27(Clue clue, Set<int> possibleValue) {
    findSquarePlusOrMinusClue(clue, a16, possibleValue, false);
    return false;
  }

  bool solveA29(Clue clue, Set<int> possibleValue) {
    findMultiplesOfPower(clue, possibleValue);
    return false;
  }

  bool solveA30(Clue clue, Set<int> possibleValue) {
    findSquarePlusOrMinusClue(clue, d24, possibleValue, true);
    return false;
  }

  bool solveA31(Clue clue, Set<int> possibleValue) {
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

  bool solveA33(Clue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, a30, possibleValue);
    return false;
  }

  bool solveA35(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA36(Clue clue, Set<int> possibleValue) {
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

  static bool solveFourDigitSquares(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    return false;
  }

  bool solveD1(Clue clue, Set<int> possibleValue) {
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

  static bool solveSixDigitSquares(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSixDigitSquares(), possibleValue);
    return false;
  }

  var solveD2 = solveSixDigitSquares;

  bool solveD3(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitMultipleThreePrimes(), possibleValue);
    return false;
  }

  bool solveD5(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFiveDigitMultipleThreePrimes(), possibleValue);
    return false;
  }

  bool solveD6(Clue clue, Set<int> possibleValue) {
    findPlusOrMinusClues(clue, d7, d18, possibleValue, true);
    return false;
  }

  bool solveD7(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitPowers(), possibleValue);
    return false;
  }

  bool solveD9(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSevenDigitTriangles(), possibleValue);
    return false;
  }

  bool solveD11(Clue clue, Set<int> possibleValue) {
    var squares = getTwoDigitSquares().where((value) => value >= 50).toList();
    squares.addAll(getThreeDigitSquares().where((value) => value < 500));
    var values = squares.map((value) => 2 * value).toList();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  static bool solveSevenDigitSquares(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSevenDigitSquares(), possibleValue);
    return false;
  }

  var solveD13 = solveSevenDigitSquares;

  bool solveD15(Clue clue, Set<int> possibleValue) {
    var values = filterDice(getFourDigitSquares());
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD18(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPowers(), possibleValue);
    return false;
  }

  var solveD20 = solveSixDigitSquares;

  bool solveD22(Clue clue, Set<int> possibleValue) {
    if (d32.values != null) {
      var values = d32.values!.map((value) => value * value).toList();
      findMultiplesOfValues(clue, values, possibleValue);
    }
    return false;
  }

  bool solveD24(Clue clue, Set<int> possibleValue) {
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

  bool solveD26(Clue clue, Set<int> possibleValue) {
    var triangles = getFourDigitTriangles()
        .where((value) => value >= 2000 && value % 2 == 0)
        .toList();
    triangles.addAll(getFiveDigitTriangles()
        .where((value) => value < 20000 && value % 2 == 0));
    var values = triangles.map((value) => value ~/ 2).toList();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD28(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    return false;
  }

  bool solveD32(Clue clue, Set<int> possibleValue) {
    findPlusOrMinusClues(clue, a19, d7, possibleValue, false);
    return false;
  }

  bool solveD34(Clue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, twoDigitPrimes, possibleValue);
    return false;
  }

  static void findTriangularsLessClue(
      Clue output, Clue input, Set<int> possibleValue) {
    if (input.values != null) {
      findTriangularsLessValues(output, input.values!, possibleValue);
    }
  }

  static void findTriangularsLessValues(
      Clue output, Set<int> values, Set<int> possibleValue) {
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

  static void findPlusOrMinusClues(
      Clue output, Clue input1, Clue input2, possibleValue,
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

  static void findSquarePlusOrMinusClue(Clue output, Clue input, possibleValue,
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

  static void findMultiplesOfPower(Clue clue, Set<int> possibleValue) {
    var hi = (10.pow(clue.length) as int) - 1;
    var squares = getPowersInRange(1, hi);
    findMultiplesOfValues(clue, squares, possibleValue);
  }

  static void findMultiplesOfClue(
      Clue output, Clue input, Set<int> possibleValue) {
    if (input.values != null) {
      findMultiplesOfValues(output, input.values!.toList(), possibleValue);
    }
  }

  static void findMultiplesOfValues(
      Clue clue, List<int> values, Set<int> possibleValue) {
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
