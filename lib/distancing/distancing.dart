import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/cartesian.dart';
import 'package:crossnumber/distancing/clue.dart';
import 'package:crossnumber/distancing/puzzle.dart';

class Distancing extends Crossnumber<DistancingPuzzle> {
  Distancing() {
    puzzle = DistancingPuzzle();
    initCrossnumber();
  }

  late final DistancingClue a1;
  late final DistancingClue a3;
  late final DistancingClue a6;
  late final DistancingClue a9;
  late final DistancingClue a12;
  late final DistancingClue a13;

  late final DistancingClue d1;
  late final DistancingClue d2;
  late final DistancingClue d4;
  late final DistancingClue d5;
  late final DistancingClue d7;
  late final DistancingClue d8;
  late final DistancingClue d9;
  late final DistancingClue d10;
  late final DistancingClue d11;

  void initCrossnumber() {
    puzzle.clues = {};

    a1 = DistancingClue(
        name: 'A1', length: 2, valueDesc: 'Square', solve: solveA1);
    puzzle.addClue(a1);
    a3 = DistancingClue(
        name: 'A3', length: 3, valueDesc: 'Square', solve: solveA3);
    puzzle.addClue(a3);
    a6 = DistancingClue(
        name: 'A6', length: 3, valueDesc: 'Prime', solve: solveA6);
    puzzle.addClue(a6);
    a9 = DistancingClue(
        name: 'A9', length: 3, valueDesc: 'Square', solve: solveA9);
    puzzle.addClue(a9);
    a12 = DistancingClue(
        name: 'A12', length: 3, valueDesc: 'Triangular', solve: solveA12);
    puzzle.addClue(a12);
    a13 = DistancingClue(
        name: 'A13', length: 2, valueDesc: 'Lucas', solve: solveA13);
    puzzle.addClue(a13);

    d1 = DistancingClue(
        name: 'D1', length: 2, valueDesc: 'Prime', solve: solveD1);
    puzzle.addClue(d1);
    d2 = DistancingClue(
        name: 'D2', length: 2, valueDesc: 'Prime', solve: solveD2);
    puzzle.addClue(d2);
    d4 = DistancingClue(
        name: 'D4', length: 2, valueDesc: 'Cube', solve: solveD4);
    puzzle.addClue(d4);
    d5 = DistancingClue(
        name: 'D5', length: 2, valueDesc: 'Triangular', solve: solveD5);
    puzzle.addClue(d5);
    d7 = DistancingClue(
        name: 'D7', length: 2, valueDesc: 'Lucas', solve: solveD7);
    puzzle.addClue(d7);
    d8 = DistancingClue(
        name: 'D8',
        length: 2,
        valueDesc: 'Prime, digit product = another entry',
        solve: solveD8);
    puzzle.addClue(d8);
    d9 = DistancingClue(
        name: 'D9', length: 2, valueDesc: 'Triangular', solve: solveD9);
    puzzle.addClue(d9);
    d10 = DistancingClue(
        name: 'D10', length: 2, valueDesc: 'Square', solve: solveD10);
    puzzle.addClue(d10);
    d11 = DistancingClue(
        name: 'D11',
        length: 2,
        valueDesc: 'Prime = sum of digits',
        solve: solveD11);
    puzzle.addClue(d11);

    puzzle.addDigitIdentity(a1, 1, d1, 1);
    puzzle.addDigitIdentity(a1, 2, d2, 1);
    puzzle.addDigitIdentity(a3, 2, d4, 1);
    puzzle.addDigitIdentity(a3, 3, d5, 1);
    puzzle.addDigitIdentity(a6, 1, d2, 2);
    puzzle.addDigitIdentity(a6, 2, d7, 1);
    puzzle.addDigitIdentity(a6, 3, d4, 2);
    puzzle.addDigitIdentity(a9, 1, d9, 1);
    puzzle.addDigitIdentity(a9, 2, d7, 2);
    puzzle.addDigitIdentity(a9, 3, d10, 1);
    puzzle.addDigitIdentity(a12, 1, d8, 2);
    puzzle.addDigitIdentity(a12, 2, d9, 2);
    puzzle.addDigitIdentity(a13, 1, d10, 2);
    puzzle.addDigitIdentity(a13, 2, d11, 2);

    // D8 references all other cells!
    puzzle.addReference(d8, a1, false);
    puzzle.addReference(d8, a3, false);
    puzzle.addReference(d8, a6, false);
    puzzle.addReference(d8, a9, false);
    puzzle.addReference(d8, a12, false);
    puzzle.addReference(d8, a13, false);
    puzzle.addReference(d8, d1, false);
    puzzle.addReference(d8, d2, false);
    puzzle.addReference(d8, d4, false);
    puzzle.addReference(d8, d5, false);
    puzzle.addReference(d8, d7, false);
    puzzle.addReference(d8, d9, false);
    puzzle.addReference(d8, d10, false);
    puzzle.addReference(d8, d11, false);

    // D11 references all other cells!
    puzzle.addReference(d11, a1, false);
    puzzle.addReference(d11, a3, false);
    puzzle.addReference(d11, a6, false);
    puzzle.addReference(d11, a9, false);
    puzzle.addReference(d11, a12, false);
    puzzle.addReference(d11, a13, false);
    puzzle.addReference(d11, d1, false);
    puzzle.addReference(d11, d2, false);
    puzzle.addReference(d11, d4, false);
    puzzle.addReference(d11, d5, false);
    puzzle.addReference(d11, d7, false);
    puzzle.addReference(d11, d9, false);
    puzzle.addReference(d11, d10, false);
    puzzle.addReference(d11, d11, false);

    super.initCrossnumber();
  }

  static bool isSociallyDistant(int value) {
    var last = -1;
    var ok = true;
    var remaining = value;
    while (remaining > 0) {
      var digit = remaining % 10;
      if (last != -1) {
        if (digit >= last && (digit - last) < 2 ||
            digit < last && (last - digit) < 2) {
          ok = false;
        }
      }
      last = digit;
      remaining = remaining ~/ 10;
    }
    return ok;
  }

  static void filterDigits(
      DistancingClue clue, List<int> values, Set<int> possibleValue) {
    for (var value in values) {
      // Check digits permissible
      if (clue.digitsMatch(value)) {
        if (isSociallyDistant(value)) {
          possibleValue.add(value);
        }
      }
    }
  }

  bool solveA1(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitSquares(), possibleValue);
    return false;
  }

  bool solveA3(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getThreeDigitSquares(), possibleValue);
    return false;
  }

  bool solveA6(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getThreeDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA9(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getThreeDigitSquares(), possibleValue);
    return false;
  }

  bool solveA12(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getThreeDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA13(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitLucas(), possibleValue);
    return false;
  }

  bool solveD1(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitPrimes(), possibleValue);
    return false;
  }

  bool solveD2(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitPrimes(), possibleValue);
    return false;
  }

  bool solveD4(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitCubes(), possibleValue);
    return false;
  }

  bool solveD5(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitTriangles(), possibleValue);
    return false;
  }

  bool solveD7(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitLucas(), possibleValue);
    return false;
  }

  bool solveD8(DistancingClue clue, Set<int> possibleValue) {
    var values = getTwoDigitPrimes();
    // Check Digit Product = Another (non-Prime) Entry
    var otherValues = <int>{};
    var incomplete = false;
    for (var other in [a1, a3, a9, a12, a13, d4, d5, d7, d9, d10, d11]) {
      if (other.values == null) {
        incomplete = true;
        break;
      }
      otherValues.addAll(other.values!);
    }
    if (!incomplete) {
      values.removeWhere((value) {
        var str = value.toString();
        var prod = int.parse(str[0]) * int.parse(str[1]);
        return !otherValues.contains(prod);
      });
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD9(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitTriangles(), possibleValue);
    return false;
  }

  bool solveD10(DistancingClue clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitSquares(), possibleValue);
    return false;
  }

  bool solveD11(DistancingClue clue, Set<int> possibleValue) {
    var values = getTwoDigitPrimes();
    // Check Digit Sum = Sum of Digits in whole grid
    var otherValues = <List<int>>[];
    var otherClues = <Clue>[];
    var incomplete = false;
    var productSize = 1;
    const productSizeLimit = 32;
    for (var other in puzzle.clues.values.where((element) => element != clue)) {
      if (other.values == null) {
        incomplete = true;
        break;
      }
      productSize *= other.values!.length;
      if (productSize > productSizeLimit) break;
      otherClues.add(other);
      otherValues.add(other.values!.toList());
    }
    if (!incomplete && productSize <= productSizeLimit) {
      var sums = <int>{};
      for (var product in cartesian(otherValues)) {
        var sum = sumClueDigits(clue, otherClues, product);
        sums.add(sum);
      }
      values.removeWhere(
          (value) => !sums.any((sum) => value == sum + sumDigits(value)));
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }
}
