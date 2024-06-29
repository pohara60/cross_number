import '../crossnumber.dart';
import '../clue.dart';
import '../cartesian.dart';
import '../distancing/clue.dart';
import '../distancing/puzzle.dart';

import '../generators.dart';
import '../monadic.dart';
import '../puzzle.dart';
import '../variable.dart';

class Distancing extends Crossnumber<DistancingPuzzle> {
  Distancing() {
    puzzle = DistancingPuzzle();
    initCrossnumber();
  }

  late final DistancingEntry a1;
  late final DistancingEntry a3;
  late final DistancingEntry a6;
  late final DistancingEntry a9;
  late final DistancingEntry a12;
  late final DistancingEntry a13;

  late final DistancingEntry d1;
  late final DistancingEntry d2;
  late final DistancingEntry d4;
  late final DistancingEntry d5;
  late final DistancingEntry d7;
  late final DistancingEntry d8;
  late final DistancingEntry d9;
  late final DistancingEntry d10;
  late final DistancingEntry d11;

  SolveFunction solveWrapper(
      bool Function(DistancingEntry clue, Set<int> possibleValue) solve) {
    bool solveDistancingClue(
      Puzzle p,
      Variable v,
      Set<int> possibleValue, {
      Set<int>? possibleValue2,
      Map<String, Set<int>>? possibleVariables,
      Map<String, Set<int>>? possibleVariables2,
      Set<String>? updatedVariables,
    }) {
      var clue = v as DistancingEntry;
      return solve(clue, possibleValue);
    }

    return solveDistancingClue;
  }

  void initCrossnumber() {
    a1 = DistancingEntry(
        name: 'A1',
        length: 2,
        valueDesc: 'Square',
        solve: solveWrapper(solveA1));
    puzzle.addEntry(a1);
    a3 = DistancingEntry(
        name: 'A3',
        length: 3,
        valueDesc: 'Square',
        solve: solveWrapper(solveA3));
    puzzle.addEntry(a3);
    a6 = DistancingEntry(
        name: 'A6',
        length: 3,
        valueDesc: 'Prime',
        solve: solveWrapper(solveA6));
    puzzle.addEntry(a6);
    a9 = DistancingEntry(
        name: 'A9',
        length: 3,
        valueDesc: 'Square',
        solve: solveWrapper(solveA9));
    puzzle.addEntry(a9);
    a12 = DistancingEntry(
        name: 'A12',
        length: 3,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveA12));
    puzzle.addEntry(a12);
    a13 = DistancingEntry(
        name: 'A13',
        length: 2,
        valueDesc: 'Lucas',
        solve: solveWrapper(solveA13));
    puzzle.addEntry(a13);

    d1 = DistancingEntry(
        name: 'D1',
        length: 2,
        valueDesc: 'Prime',
        solve: solveWrapper(solveD1));
    puzzle.addEntry(d1);
    d2 = DistancingEntry(
        name: 'D2',
        length: 2,
        valueDesc: 'Prime',
        solve: solveWrapper(solveD2));
    puzzle.addEntry(d2);
    d4 = DistancingEntry(
        name: 'D4', length: 2, valueDesc: 'Cube', solve: solveWrapper(solveD4));
    puzzle.addEntry(d4);
    d5 = DistancingEntry(
        name: 'D5',
        length: 2,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveD5));
    puzzle.addEntry(d5);
    d7 = DistancingEntry(
        name: 'D7',
        length: 2,
        valueDesc: 'Lucas',
        solve: solveWrapper(solveD7));
    puzzle.addEntry(d7);
    d8 = DistancingEntry(
        name: 'D8',
        length: 2,
        valueDesc: 'Prime, digit product = another entry',
        solve: solveWrapper(solveD8));
    puzzle.addEntry(d8);
    d9 = DistancingEntry(
        name: 'D9',
        length: 2,
        valueDesc: 'Triangular',
        solve: solveWrapper(solveD9));
    puzzle.addEntry(d9);
    d10 = DistancingEntry(
        name: 'D10',
        length: 2,
        valueDesc: 'Square',
        solve: solveWrapper(solveD10));
    puzzle.addEntry(d10);
    d11 = DistancingEntry(
        name: 'D11',
        length: 2,
        valueDesc: 'Prime = sum of digits',
        solve: solveWrapper(solveD11));
    puzzle.addEntry(d11);

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
    puzzle.addClueReference(d8, a1, false);
    puzzle.addClueReference(d8, a3, false);
    puzzle.addClueReference(d8, a6, false);
    puzzle.addClueReference(d8, a9, false);
    puzzle.addClueReference(d8, a12, false);
    puzzle.addClueReference(d8, a13, false);
    puzzle.addClueReference(d8, d1, false);
    puzzle.addClueReference(d8, d2, false);
    puzzle.addClueReference(d8, d4, false);
    puzzle.addClueReference(d8, d5, false);
    puzzle.addClueReference(d8, d7, false);
    puzzle.addClueReference(d8, d9, false);
    puzzle.addClueReference(d8, d10, false);
    puzzle.addClueReference(d8, d11, false);

    // D11 references all other cells!
    puzzle.addClueReference(d11, a1, false);
    puzzle.addClueReference(d11, a3, false);
    puzzle.addClueReference(d11, a6, false);
    puzzle.addClueReference(d11, a9, false);
    puzzle.addClueReference(d11, a12, false);
    puzzle.addClueReference(d11, a13, false);
    puzzle.addClueReference(d11, d1, false);
    puzzle.addClueReference(d11, d2, false);
    puzzle.addClueReference(d11, d4, false);
    puzzle.addClueReference(d11, d5, false);
    puzzle.addClueReference(d11, d7, false);
    puzzle.addClueReference(d11, d9, false);
    puzzle.addClueReference(d11, d10, false);
    puzzle.addClueReference(d11, d11, false);

    puzzle.finalize();
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
      DistancingEntry clue, List<int> values, Set<int> possibleValue) {
    for (var value in values) {
      // Check digits permissible
      if (clue.digitsMatch(value)) {
        if (isSociallyDistant(value)) {
          possibleValue.add(value);
        }
      }
    }
  }

  bool solveA1(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitSquares(), possibleValue);
    return false;
  }

  bool solveA3(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getThreeDigitSquares(), possibleValue);
    return false;
  }

  bool solveA6(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getThreeDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA9(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getThreeDigitSquares(), possibleValue);
    return false;
  }

  bool solveA12(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getThreeDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA13(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitLucas(), possibleValue);
    return false;
  }

  bool solveD1(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitPrimes(), possibleValue);
    return false;
  }

  bool solveD2(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitPrimes(), possibleValue);
    return false;
  }

  bool solveD4(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitCubes(), possibleValue);
    return false;
  }

  bool solveD5(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitTriangles(), possibleValue);
    return false;
  }

  bool solveD7(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitLucas(), possibleValue);
    return false;
  }

  bool solveD8(DistancingEntry clue, Set<int> possibleValue) {
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

  bool solveD9(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitTriangles(), possibleValue);
    return false;
  }

  bool solveD10(DistancingEntry clue, Set<int> possibleValue) {
    filterDigits(clue, getTwoDigitSquares(), possibleValue);
    return false;
  }

  bool solveD11(DistancingEntry clue, Set<int> possibleValue) {
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
