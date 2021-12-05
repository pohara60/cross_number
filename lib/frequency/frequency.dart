import 'package:powers/powers.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/cartesian.dart';
import 'package:crossnumber/frequency/clue.dart';
import 'package:crossnumber/frequency/puzzle.dart';

class Frequency extends Crossnumber<FrequencyPuzzle> {
  Frequency() {
    puzzle = FrequencyPuzzle();
    initCrossnumber();
  }

  late final FrequencyClue a1;
  late final FrequencyClue a5;
  late final FrequencyClue a6;
  late final FrequencyClue a7;
  late final FrequencyClue a9;
  late final FrequencyClue a10;

  late final FrequencyClue d2;
  late final FrequencyClue d3;
  late final FrequencyClue d4;
  late final FrequencyClue d5;
  late final FrequencyClue d8;
  late final FrequencyClue d9;

  void initCrossnumber() {
    puzzle.clues = {};

    a1 = FrequencyClue(
        name: 'A1', length: 3, valueDesc: 'Palindrome', solve: solveA1);
    puzzle.addClue(a1);
    a5 = FrequencyClue(
        name: 'A5', length: 2, valueDesc: 'Digit product = D2', solve: solveA5);
    puzzle.addClue(a5);
    a6 = FrequencyClue(
        name: 'A6', length: 2, valueDesc: 'Factor of D9', solve: solveA6);
    puzzle.addClue(a6);
    a7 = FrequencyClue(
        name: 'A7', length: 2, valueDesc: 'Factor of D4', solve: solveA7);
    puzzle.addClue(a7);
    a9 = FrequencyClue(
        name: 'A9', length: 2, valueDesc: 'Reverse of D2', solve: solveA9);
    puzzle.addClue(a9);
    a10 = FrequencyClue(
        name: 'A10', length: 3, valueDesc: 'Triangular', solve: solveA10);
    puzzle.addClue(a10);

    d2 = FrequencyClue(
        name: 'D2', length: 2, valueDesc: 'Triangular', solve: solveD2);
    puzzle.addClue(d2);
    d3 = FrequencyClue(
        name: 'D3',
        length: 2,
        valueDesc: 'Digit sum is square',
        solve: solveD3);
    puzzle.addClue(d3);
    d4 = FrequencyClue(
        name: 'D4', length: 3, valueDesc: 'Multiple of A7', solve: solveD4);
    puzzle.addClue(d4);
    d5 = FrequencyClue(
        name: 'D5',
        length: 3,
        valueDesc: 'Same digit product as A1',
        solve: solveD5);
    puzzle.addClue(d5);
    d8 = FrequencyClue(
        name: 'D8',
        length: 2,
        valueDesc: 'Cube + sum all digits',
        solve: solveD8);
    puzzle.addClue(d8);
    d9 = FrequencyClue(
        name: 'D9', length: 2, valueDesc: 'Triangular', solve: solveD9);
    puzzle.addClue(d9);

    puzzle.addDigitIdentity(a1, 2, d2, 1);
    puzzle.addDigitIdentity(a1, 3, d3, 1);
    puzzle.addDigitIdentity(a5, 1, d5, 1);
    puzzle.addDigitIdentity(a5, 2, d2, 2);
    puzzle.addDigitIdentity(a6, 1, d3, 2);
    puzzle.addDigitIdentity(a6, 2, d4, 2);
    puzzle.addDigitIdentity(a7, 1, d5, 2);
    puzzle.addDigitIdentity(a7, 2, d8, 1);
    puzzle.addDigitIdentity(a9, 1, d9, 1);
    puzzle.addDigitIdentity(a9, 2, d4, 3);
    puzzle.addDigitIdentity(a10, 1, d8, 2);
    puzzle.addDigitIdentity(a10, 2, d9, 2);

    puzzle.addReference(a5, d2, true);
    puzzle.addReference(a6, d9, true);
    puzzle.addReference(a7, d4, true);
    puzzle.addReference(a9, d2, true);
    puzzle.addReference(d4, a7, true);
    puzzle.addReference(d5, a1, true);

    // D8 references all other cells!
    puzzle.addReference(d8, a1, false);
    puzzle.addReference(d8, a5, false);
    puzzle.addReference(d8, a6, false);
    puzzle.addReference(d8, a7, false);
    puzzle.addReference(d8, a9, false);
    puzzle.addReference(d8, a10, false);
    puzzle.addReference(d8, d2, false);
    puzzle.addReference(d8, d3, false);
    puzzle.addReference(d8, d4, false);
    puzzle.addReference(d8, d5, false);
    puzzle.addReference(d8, d9, false);

    super.initCrossnumber();
  }

  static void filterDigits(
      FrequencyClue clue, List<int> values, Set<int> possibleValue) {
    for (var value in values) {
      // Check digits permissible
      if (clue.digitsMatch(value)) {
        possibleValue.add(value);
      }
    }
  }

  bool solveA1(FrequencyClue clue, Set<int> possibleValue) {
    List<int>? values;
    if (clue.values != null)
      values = List.from(clue.values!);
    else
      values = getThreeDigitPalindromes();
    var values2 = getDigitProductEqualsOtherClueProduct(clue, d5);
    if (values2 != null) {
      values.removeWhere((value) => !values2.contains(value));
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA5(FrequencyClue clue, Set<int> possibleValue) {
    var values = getDigitProductEqualsOtherClue(clue, d2);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  List<int>? getDigitProductEqualsOtherClue(
      FrequencyClue clue, FrequencyClue other) {
    if (other.values != null) {
      var values = <int>{};
      for (var value in other.values!) {
        for (var factor = 2; factor <= value.sqrt().floor(); factor++) {
          if (value % factor == 0) {
            var factor2 = value ~/ factor;
            if (factor2 < 10) {
              values.add(factor * 10 + factor2);
              values.add(factor2 * 10 + factor);
            }
          }
        }
      }
      return List.from(values);
    }
    return null;
  }

  bool solveA6(FrequencyClue clue, Set<int> possibleValue) {
    var values = getFactorsOfOtherClue(clue, d9);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  List<int>? getFactorsOfOtherClue(FrequencyClue clue, FrequencyClue other) {
    if (other.values != null) {
      var values = <int>{};
      int loLimit = 10.pow(clue.length - 1) as int;
      if (loLimit < 2) loLimit = 2;
      int hiLimit = (10.pow(clue.length) as int) - 1;
      for (var value in other.values!) {
        int lo = loLimit;
        int hi = value ~/ 2;
        if (hi > hiLimit) hi = hiLimit;
        for (var factor = lo; factor <= hi; factor++) {
          if (value % factor == 0) {
            values.add(factor);
          }
        }
      }
      return List.from(values);
    }
    return null;
  }

  bool solveA7(FrequencyClue clue, Set<int> possibleValue) {
    var values = getFactorsOfOtherClue(clue, d4);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  bool solveA9(FrequencyClue clue, Set<int> possibleValue) {
    var values = getReverseOfOtherClue(clue, d2);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  List<int>? getReverseOfOtherClue(FrequencyClue clue, FrequencyClue other) {
    if (other.values != null) {
      var values = <int>[];
      for (var value in other.values!) {
        var reverse = 0;
        while (value > 0) {
          reverse = reverse * 10 + value % 10;
          // First digit cannot be 0
          if (reverse == 0) break;
          value = value ~/ 10;
        }
        if (reverse != 0) {
          values.add(reverse);
        }
      }
      return values;
    }
    return null;
  }

  bool solveA10(FrequencyClue clue, Set<int> possibleValue) {
    filterDigits(clue, getThreeDigitTriangles(), possibleValue);
    return false;
  }

  bool solveD2(FrequencyClue clue, Set<int> possibleValue) {
    List<int>? values;
    if (clue.values != null)
      values = List.from(clue.values!);
    else
      values = getTwoDigitTriangles();
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

  List<int>? getDigitProductOtherClue(FrequencyClue clue, FrequencyClue other) {
    if (other.values != null) {
      var values = <int>{};
      for (var value in other.values!) {
        var product = 1;
        while (value > 0) {
          product *= value % 10;
          value = value ~/ 10;
        }
        values.add(product);
      }
      return List.from(values);
    }
    return null;
  }

  bool solveD3(FrequencyClue clue, Set<int> possibleValue) {
    var squares = getSquaresRange(1, 17);
    var values = <int>[];
    for (var d1 = 1; d1 < 10; d1++) {
      for (var d2 = 0; d2 < 10; d2++) {
        var sum = d1 + d2;
        if (squares.contains(sum)) {
          values.add(d1 * 10 + d2);
        }
      }
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD4(FrequencyClue clue, Set<int> possibleValue) {
    var values = <int>[];
    if (a7.values != null) {
      values = getMultipleOfOtherClue(clue, a7)!;
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
    filterDigits(clue, values, possibleValue);
    return false;
  }

  List<int>? getMultipleOfOtherClue(FrequencyClue clue, FrequencyClue other) {
    if (other.values != null) {
      var values = <int>[];
      for (var value in other.values!) {
        var hi = ((10.pow(clue.length) as int) - 1) ~/ value;
        for (var i = 2; i <= hi; i++) {
          var multiple = i * value;
          values.add(multiple);
        }
      }
      return values;
    }
    return null;
  }

  bool solveD5(FrequencyClue clue, Set<int> possibleValue) {
    var values = getDigitProductEqualsOtherClueProduct(clue, a1);
    if (values != null) {
      filterDigits(clue, values, possibleValue);
    }
    return false;
  }

  List<int>? getDigitProductEqualsOtherClueProduct(
      FrequencyClue clue, FrequencyClue other) {
    if (other.values != null) {
      var values = <int>{};
      for (var value in other.values!) {
        var product = 1;
        while (value > 0) {
          product *= value % 10;
          value = value ~/ 10;
        }
        for (var factor = 1; factor <= product.sqrt().floor(); factor++) {
          if (factor < 10 && product % factor == 0) {
            for (var factor2 = 1;
                factor2 <= product.sqrt().floor();
                factor2++) {
              var prod2 = factor * factor2;
              if (factor2 < 10 && product % prod2 == 0) {
                var factor3 = product ~/ prod2;
                if (factor3 < 10) {
                  values.add(factor * 100 + factor2 * 10 + factor3);
                  values.add(factor * 100 + factor3 * 10 + factor2);
                  values.add(factor2 * 100 + factor * 10 + factor3);
                  values.add(factor2 * 100 + factor3 * 10 + factor);
                  values.add(factor3 * 100 + factor2 * 10 + factor);
                  values.add(factor3 * 100 + factor * 10 + factor2);
                }
              }
            }
          }
        }
      }
      return List.from(values);
    }
    return null;
  }

  bool solveD8(FrequencyClue clue, Set<int> possibleValue) {
    var cubes = getCubesRange(1, 99);
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
      int lo = 10.pow(clue.length - 1) as int;
      int hi = (10.pow(clue.length) as int) - 1;
      for (var cube in cubes) {
        for (var sum in sums) {
          var valueWithoutDigits = cube + sum;
          // Iterate ove possible value digit sums
          for (var valueSumDigits = 1;
              valueSumDigits <= 9 * clue.length;
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

  int sumDigits(int value) {
    var str = value.toString();
    var sum = 0;
    for (var i = 0; i < str.length; i++) {
      sum += int.parse(str[i]);
    }
    return sum;
  }

  int sumClueDigits(Clue clue, List<Clue> otherClues, List<int> otherValues) {
    var sum = 0;
    // Sum all otherClues that do not interset with Clue
    // Do not double count digits that appear in Across and Down clues
    var index = 0;
    for (var otherClue in otherClues) {
      var value = otherValues[index].toString();
      // Sum all digitd of Across clues
      for (var d = 0; d < otherClue.length; d++) {
        var digit = int.parse(value[d]);
        // Exclude digits that intersect with the Clue
        if (otherClue.digitIdentities[d] != null) {
          if (otherClue.digitIdentities[d]!.clue == clue) digit = 0;
        }
        // Exclude digits of Down clues that intersect with Across clues
        if (otherClue.name[0] == 'D') {
          if (otherClue.digitIdentities[d] != null) digit = 0;
        }
        sum += digit;
      }
      index++;
    }
    return sum;
  }

  bool solveD9(FrequencyClue clue, Set<int> possibleValue) {
    var values = getTwoDigitTriangles();
    var values2 = getMultipleOfOtherClue(clue, a6);
    if (values2 != null) {
      values.removeWhere((value) => !values2.contains(value));
    }
    filterDigits(clue, values, possibleValue);
    return false;
  }
}
