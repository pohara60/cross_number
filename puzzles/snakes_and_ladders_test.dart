// ignore_for_file: unused_local_variable

import 'package:crossnumber/src/expressions/generators.dart';
// ignore: unused_import
import 'package:crossnumber/src/utils/set.dart';
import 'package:powers/powers.dart';

/*
a1=9380581029
a20=1287913472
a21=5584059450
a40=6321363049
a41=9208180736
a60=2073071593
a61=1804229351
a80=3077056399
a81=1350125107
a100=2357947691
u11=2096
u15=1568
u38=201
u45=10201
d94=756
d68=3570
d61=1296
d42=2352
*/

void main(List<String> args) {
  var path = [5, 10, 46, 51, 56, 40, 85, 90, 95, 100];
  // D61 - square of a square, 4 digits
  var d61values = squareSquare();
  // print('D61= ${d61values.length} - ${d61values.toShortString()}');
  // A40 - cube of a square
  var a40values = cubeSquare10Digits();
  var patternD61Digit3 = getPatternForValueDigit(d61values, 3);
  a40values =
      a40values.where((n) => n.toString().startsWith(patternD61Digit3)).toSet();
  // print('A40= ${a40values.length} - ${a40values.toShortString()}');
  // A41 - cube, 10 digits
  // U11 - cube root of A41, 4 digits
  var u11values = cubeRoot10DigitCubeLastDigitsSame();
  var a41values = u11values.map((n) => n * n * n).toSet();
  var patternD61Digit2 = getPatternForValueDigit(d61values, 2);
  a41values =
      a41values.where((n) => n.toString().startsWith(patternD61Digit2)).toSet();
  u11values = a41values.map((n) => (n.toDouble().pow(1 / 3)).round()).toSet();
  // print('A41= ${a41values.length} - ${a41values.toShortString()}');
  // print('U11= ${u11values.length} - ${u11values.toShortString()}');

  var u15values = doubleSquare4Digits();
  // print('U15= ${u15values.length} - ${u15values.toShortString()}');

  var d68values = productFivePrimes4Digits();
  // print('D68= ${d68values.length} - ${d68values.toShortString()}');

  var u45values = square5Digits();
  // print('U45= ${u45values.length} - ${u45values.toShortString()}');

  var a60values = twoDigitPrimeToPrimePower10Digits();
  // print('A60= ${a60values.length} - ${a60values.toShortString()}');

  var a61values = twoDigitPrimeToPrimePower10Digits();
  // print('A61= ${a61values.length} - ${a61values.toShortString()}');

  var a80values = twoDigitPrimeToPrimePower10Digits();
  // print('A80= ${a80values.length} - ${a80values.toShortString()}');

  var a81values = twoDigitPrimeToPrimePower10Digits();
  // print('A81= ${a81values.length} - ${a81values.toShortString()}');

  var a100values = cubeCube10Digits();
  // print('A100= ${a100values.length} - ${a100values.toShortString()}');

  var a21values = twoDigitPrimeToPrimePower10DigitsPlusOne();
  // print('A21= ${a21values.length} - ${a21values.toShortString()}');

  var a1values = cube10Digits();
  // print('A1= ${a1values.length} - ${a1values.toShortString()}');

  var a20values = cube10Digits();
  // print('A20= ${a20values.length} - ${a20values.toShortString()}');

  var u11NewValues = <int>{};
  var u15NewValues = <int>{};
  var u38NewValues = <int>{};
  var u45NewValues = <int>{};
  var a1NewValues = <int>{};
  var a20NewValues = <int>{};
  var a21NewValues = <int>{};
  var a40NewValues = <int>{};
  var a41NewValues = <int>{};
  var a60NewValues = <int>{};
  var a61NewValues = <int>{};
  var a80NewValues = <int>{};
  var a81NewValues = <int>{};
  var a100NewValues = <int>{};
  var d42NewValues = <int>{};
  var d68NewValues = <int>{};
  var d94NewValues = <int>{};
  var pathDigits = <String>[];
  for (var d61 in d61values) {
    var d61Str = d61.toString();
    var (ok, newPathDigits) =
        updatePath(d61Str, [61, 60, 41, 40], path, pathDigits);
    if (!ok) continue;
    var d61Digit2 = int.parse(d61Str[2]);
    var d61Digit3 = int.parse(d61Str[3]);
    for (var a41 in a41values) {
      var a41Str = a41.toString();
      if (a41Str[0] != d61Str[2]) continue;
      var (ok, newPathDigits) = updatePath(
          a41Str, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50], path, pathDigits);
      if (!ok) continue;
      {
        var u11 = (a41.toDouble().pow(1 / 3)).round();
        var u11Str = u11.toString();
        if (u11Str[3] != a41Str[9]) continue;
        var (ok, newPathDigits) =
            updatePath(u11Str, [11, 30, 31, 50], path, pathDigits);
        if (!ok) continue;
        for (var a40 in a40values) {
          var a40Str = a40.toString();
          if (a40Str[0] != d61Str[3]) continue;
          if (a40Str[9] != u11Str[2]) continue;
          var (ok, newPathDigits) = updatePath(a40Str,
              [40, 39, 38, 37, 36, 35, 34, 33, 32, 31], path, pathDigits);
          if (!ok) continue;
          for (var u15 in u15values) {
            var u15Str = u15.toString();
            if (u15Str[2] != a40Str[5]) continue;
            if (u15Str[3] != a41Str[5]) continue;
            var (ok, newPathDigits) =
                updatePath(u15Str, [15, 26, 35, 46], path, pathDigits);
            if (!ok) continue;
            for (var d68 in d68values) {
              var d68Str = d68.toString();
              if (d68Str[2] != a41Str[7]) continue;
              if (d68Str[3] != a40Str[7]) continue;
              var (ok, newPathDigits) =
                  updatePath(d68Str, [68, 53, 48, 33], path, pathDigits);
              if (!ok) continue;
              for (var u45 in u45values) {
                var u45Str = u45.toString();
                if (u45Str[0] != a41Str[4]) continue;
                var (ok, newPathDigits) =
                    updatePath(u45Str, [45, 56, 65, 76, 85], path, pathDigits);
                if (!ok) continue;
                for (var a60 in a60values) {
                  var a60Str = a60.toString();
                  if (a60Str[0] != d61Str[1]) continue;
                  if (a60Str[4] != u45Str[1]) continue;
                  if (a60Str[7] != d68Str[1]) continue;
                  var (ok, newPathDigits) = updatePath(
                      a60Str,
                      [60, 59, 58, 57, 56, 55, 54, 53, 52, 51],
                      path,
                      pathDigits);
                  if (!ok) continue;
                  for (var a61 in a61values) {
                    var a61Str = a61.toString();
                    if (a61Str[0] != d61Str[0]) continue;
                    if (a61Str[4] != u45Str[2]) continue;
                    if (a61Str[7] != d68Str[0]) continue;
                    var (ok, newPathDigits) = updatePath(
                        a61Str,
                        [61, 62, 63, 64, 65, 66, 67, 68, 69, 70],
                        path,
                        pathDigits);
                    if (!ok) continue;
                    for (var a80 in a80values) {
                      var a80Str = a80.toString();
                      if (a80Str[4] != u45Str[3]) continue;
                      var (ok, newPathDigits) = updatePath(
                          a80Str,
                          [80, 79, 78, 77, 76, 75, 74, 73, 72, 71],
                          path,
                          pathDigits);
                      if (!ok) continue;
                      for (var a81 in a81values) {
                        var a81Str = a81.toString();
                        if (a81Str[4] != u45Str[4]) continue;
                        // if (a81Str[6] != d94Str[1]) continue;
                        var (ok, newPathDigits) = updatePath(
                            a81Str,
                            [81, 82, 83, 84, 85, 86, 87, 88, 89, 90],
                            path,
                            pathDigits);
                        if (!ok) continue;
                        for (var a100 in a100values) {
                          var a100Str = a100.toString();
                          if (a100Str[6] == '0') continue;
                          // if (a100Str[6] != d94Str[0]) continue;
                          var (ok, newPathDigits) = updatePath(
                              a100Str,
                              [100, 99, 98, 97, 96, 95, 94, 93, 92, 91],
                              path,
                              pathDigits);
                          if (!ok) continue;
                          for (var a21 in a21values) {
                            var a21Str = a21.toString();
                            if (a21Str[5] != u15Str[1]) continue;
                            if (a21Str[9] != u11Str[1]) continue;
                            // if (a21Str[1] != d42Str[2]) continue;
                            var (ok, newPathDigits) = updatePath(
                                a21Str,
                                [21, 22, 23, 24, 25, 26, 27, 28, 29, 30],
                                path,
                                pathDigits);
                            if (!ok) continue;
                            for (var a20 in a20values) {
                              var a20Str = a20.toString();
                              if (a20Str[5] != u15Str[0]) continue;
                              if (a20Str[9] != u11Str[0]) continue;
                              // if (a20Str[1] != d42Str[3]) continue;
                              if (a20 >= a21) continue;
                              if (a20 >= a40) continue;
                              if (a20 >= a41) continue;
                              if (a20 >= a60) continue;
                              if (a20 >= a61) continue;
                              if (a20 >= a80) continue;
                              if (a20 >= a81) continue;
                              if (a20 >= a100) continue;
                              var (ok, newPathDigits) = updatePath(
                                  a20Str,
                                  [20, 19, 18, 17, 16, 15, 14, 13, 12, 11],
                                  path,
                                  pathDigits);
                              if (!ok) continue;

                              for (var a1 in a1values) {
                                var a1Str = a1.toString();
                                if (a1 <= a20) continue;
                                if (a1 <= a21) continue;
                                if (a1 <= a40) continue;
                                if (a1 <= a41) continue;
                                if (a1 <= a60) continue;
                                if (a1 <= a61) continue;
                                if (a1 <= a80) continue;
                                if (a1 <= a81) continue;
                                if (a1 <= a100) continue;
                                var (ok, newPathDigits) = updatePath(
                                    a1Str,
                                    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                                    path,
                                    pathDigits);
                                if (!ok) continue;

                                // Compute other down/up entries
                                var u38Str = a40Str[2] + a41Str[2] + a60Str[6];
                                var u38 = int.parse(u38Str);
                                var d94Str = a100Str[6] + a81Str[6] + a80Str[6];
                                var d94 = int.parse(d94Str);
                                var d42Str = a41Str[1] +
                                    a40Str[1] +
                                    a21Str[1] +
                                    a20Str[1];
                                var d42 = int.parse(d42Str);

                                // Check unique digits on path [5, 10, 46, 51, 56, 40, 85, 90, 95, 100];
                                var pathValueStr = a1Str[4] +
                                    a1Str[9] +
                                    a41Str[5] +
                                    a60Str[9] +
                                    a60Str[4] +
                                    a40Str[0] +
                                    a81Str[4] +
                                    a81Str[9] +
                                    a100Str[5] +
                                    a100Str[0];
                                var duplicate = false;
                                for (var index = 1;
                                    index < pathValueStr.length;
                                    index++) {
                                  var digit = pathValueStr[index];
                                  if (pathValueStr
                                      .substring(0, index)
                                      .contains(digit)) {
                                    duplicate = true;
                                    break;
                                  }
                                }
                                if (duplicate) continue;

                                // Check d94 has multiple of number of even digits
                                var numberOfEvenDigits =
                                    countEvenDigits(a1Str) +
                                        countEvenDigits(a20Str) +
                                        countEvenDigits(a21Str) +
                                        countEvenDigits(a40Str) +
                                        countEvenDigits(a41Str) +
                                        countEvenDigits(a60Str) +
                                        countEvenDigits(a61Str) +
                                        countEvenDigits(a80Str) +
                                        countEvenDigits(a81Str) +
                                        countEvenDigits(a100Str);
                                if (d94 % numberOfEvenDigits != 0) continue;

                                // All conditions met
                                u11NewValues.add(u11);
                                u15NewValues.add(u15);
                                u45NewValues.add(u45);
                                a1NewValues.add(a1);
                                a20NewValues.add(a20);
                                a21NewValues.add(a21);
                                a40NewValues.add(a40);
                                a41NewValues.add(a41);
                                a60NewValues.add(a60);
                                a61NewValues.add(a61);
                                a80NewValues.add(a80);
                                a81NewValues.add(a81);
                                a100NewValues.add(a100);
                                d68NewValues.add(d68);
                                u38NewValues.add(u38);
                                d94NewValues.add(d94);
                                d42NewValues.add(d42);
                                [
                                  'a1=$a1',
                                  'a20=$a20',
                                  'a21=$a21',
                                  'a40=$a40',
                                  'a41=$a41',
                                  'a60=$a60',
                                  'a61=$a61',
                                  'a80=$a80',
                                  'a81=$a81',
                                  'a100=$a100',
                                  'u11=$u11',
                                  'u15=$u15',
                                  'u38=$u38',
                                  'u45=$u45',
                                  'd94=$d94',
                                  'd68=$d68',
                                  'd61=$d61',
                                  'd42=$d42'
                                ].forEach((element) {
                                  print(element);
                                });

                                pathDigits.removeWhere(
                                    (digit) => newPathDigits.contains(digit));
                              }

                              pathDigits.removeWhere(
                                  (digit) => newPathDigits.contains(digit));
                            }

                            pathDigits.removeWhere(
                                (digit) => newPathDigits.contains(digit));
                          }

                          pathDigits.removeWhere(
                              (digit) => newPathDigits.contains(digit));
                        }

                        pathDigits.removeWhere(
                            (digit) => newPathDigits.contains(digit));
                      }

                      pathDigits.removeWhere(
                          (digit) => newPathDigits.contains(digit));
                    }

                    pathDigits
                        .removeWhere((digit) => newPathDigits.contains(digit));
                  }

                  pathDigits
                      .removeWhere((digit) => newPathDigits.contains(digit));
                }

                pathDigits
                    .removeWhere((digit) => newPathDigits.contains(digit));
              }

              pathDigits.removeWhere((digit) => newPathDigits.contains(digit));
            }

            pathDigits.removeWhere((digit) => newPathDigits.contains(digit));
          }

          pathDigits.removeWhere((digit) => newPathDigits.contains(digit));
        }

        pathDigits.removeWhere((digit) => newPathDigits.contains(digit));
      }

      pathDigits.removeWhere((digit) => newPathDigits.contains(digit));
    }

    pathDigits.removeWhere((digit) => newPathDigits.contains(digit));
  }
/*   if (u11NewValues.length != u11values.length) {
    print('New U11= ${u11NewValues.length} - ${u11NewValues.toShortString()}');
  }
  if (u15NewValues.length != u15values.length) {
    print('New U15= ${u15NewValues.length} - ${u15NewValues.toShortString()}');
  }
  if (u45NewValues.length != u45values.length) {
    print('New U45= ${u45NewValues.length} - ${u45NewValues.toShortString()}');
  }
  if (a1NewValues.length != a1values.length) {
    print('New A1= ${a1NewValues.length} - ${a1NewValues.toShortString()}');
  }
  if (a20NewValues.length != a20values.length) {
    print('New A20= ${a20NewValues.length} - ${a20NewValues.toShortString()}');
  }
  if (a21NewValues.length != a21values.length) {
    print('New A21= ${a21NewValues.length} - ${a21NewValues.toShortString()}');
  }
  if (a40NewValues.length != a40values.length) {
    print('New A40= ${a40NewValues.length} - ${a40NewValues.toShortString()}');
  }
  if (a41NewValues.length != a41values.length) {
    print('New A41= ${a41NewValues.length} - ${a41NewValues.toShortString()}');
  }
  if (a60NewValues.length != a60values.length) {
    print('New A60= ${a60NewValues.length} - ${a60NewValues.toShortString()}');
  }
  if (a61NewValues.length != a61values.length) {
    print('New A61= ${a61NewValues.length} - ${a61NewValues.toShortString()}');
  }
  if (a80NewValues.length != a80values.length) {
    print('New A80= ${a80NewValues.length} - ${a80NewValues.toShortString()}');
  }
  if (a81NewValues.length != a81values.length) {
    print('New A81= ${a81NewValues.length} - ${a81NewValues.toShortString()}');
  }
  if (a100NewValues.length != a100values.length) {
    print(
        'New A100= ${a100NewValues.length} - ${a100NewValues.toShortString()}');
  }
  if (d68NewValues.length != d68values.length) {
    print('New D68= ${d68NewValues.length} - ${d68NewValues.toShortString()}');
  }
  print('New U38= ${u38NewValues.length} - ${u38NewValues.toShortString()}');
  print('New D42= ${d42NewValues.length} - ${d42NewValues.toShortString()}');
  print('New D94= ${d94NewValues.length} - ${d94NewValues.toShortString()}');
 */
  // Enforce grid related constraints and see if any further reduction is possible
}

countEvenDigits(String str) {
  var count = 0;
  for (var i = 0; i < str.length; i++) {
    var digit = str[i];
    if ("02468".contains(digit)) {
      count++;
    }
  }
  return count;
}

bool duplicatePathDigit(
    String valueStr, List<int> cells, List<int> path, List<String> pathDigits) {
  var index = 0;
  for (var cell in cells) {
    if (path.contains(cell)) {
      var digit = valueStr[index];
      if (pathDigits.contains(digit)) {
        return true;
      }
    }
    index++;
  }
  return false;
}

List<String> getNewPathDigits(
    String valueStr, List<int> cells, List<int> path, List<String> pathDigits) {
  var addPathDigits = <String>[];
  var index = 0;
  for (var cell in cells) {
    if (path.contains(cell)) {
      var digit = valueStr[index];
      if (pathDigits.contains(digit)) {
        return [];
      }
      addPathDigits.add(digit);
    }
    index++;
  }
  return addPathDigits;
}

(bool ok, List<String> newPathDigits) updatePath(
    String valueStr, List<int> cells, List<int> path, List<String> pathDigits) {
  return (true, []);
  // ignore: dead_code
  if (duplicatePathDigit(valueStr, cells, path, pathDigits)) {
    return (false, []);
  }
  var newPathDigits = getNewPathDigits(valueStr, cells, path, pathDigits);
  pathDigits.addAll(newPathDigits);
  return (true, newPathDigits);
}

Set<int> twoDigitPrimeToPrimePower10DigitsPlusOne() {
  var results = <int>{};
  for (var value in twoDigitPrimeToPrimePower10Digits()) {
    value += 1;
    if (value >= 1000000000 && value < 10000000000) {
      results.add(value);
    }
  }
  return results;
}

Set<int> doubleSquare4Digits() {
  var results = <int>{};
  for (var i = 4; i <= 31; i++) {
    var square = i * i;
    var doubleSquare = square * 2;
    if (doubleSquare >= 1000 && doubleSquare < 10000) {
      results.add(doubleSquare);
    }
  }
  return results;
}

Set<int> square5Digits() {
  var results = <int>{};
  for (var i = 100; i <= 316; i++) {
    var square = i * i;
    if (square >= 10000 && square < 100000) {
      results.add(square);
    }
  }
  return results;
}

RegExp getPatternForValueDigit(Set<int> d61, int digit) =>
    RegExp('[${d61.map((n) => n.toString()[digit]).join()}]');

Set<int> cubeSquare10Digits() {
  var results = <int>{};
  for (var i = 32; i <= 46; i++) {
    var square = i * i;
    var cube = square * square * square;
    if (cube >= 1000000000 && cube < 10000000000) {
      results.add(cube);
    }
  }
  return results;
}

Set<int> cube10Digits() {
  var results = <int>{};
  for (var i = 1000; i <= 2154; i++) {
    var cube = i * i * i;
    if (cube >= 1000000000 && cube < 10000000000) {
      results.add(cube);
    }
  }
  return results;
}

Set<int> cubeCube10Digits() {
  var results = <int>{};
  for (var i = 10; i <= 12; i++) {
    var cube1 = i * i * i;
    var cube2 = cube1 * cube1 * cube1;
    if (cube2 >= 1000000000 && cube2 < 10000000000) {
      results.add(cube2);
    }
  }
  return results;
}

Set<int> twoDigitPrimeToPrimePower10Digits() {
  var _generator = GeneratorRegistry().get('twodigitprimetoprimepower')
      as TwoDigitPrimeToPrimePowerGenerator;
  var results = _generator.getValues(1000000000, 9999999999).toSet();
  return results;
}

Set<int> squareSquare() {
  return {1296, 6561};
}

Set<int> cubeRoot10DigitCubeLastDigitsSame() {
  var results = <int>{};
  for (var i = 1000; i <= 2154; i++) {
    var cube = i * i * i;
    if (cube >= 1000000000 && cube < 10000000000) {
      if (cube % 10 == i % 10) {
        results.add(i);
      }
    }
  }
  return results;
}

late final PrimeGenerator _primeGenerator;

Set<int> productFivePrimes4Digits() {
  var min = 1000;
  var max = 9999;
  var maxPrime = max ~/ 2 ~/ 3 ~/ 5 ~/ 7;
  if (maxPrime < 11) {
    return {};
  }
  _primeGenerator = GeneratorRegistry().get('prime') as PrimeGenerator;
  final primes = _primeGenerator.getValues(2, maxPrime);
  var results = <int>{};
  for (var p1 in primes) {
    if (p1 > maxPrime) break;
    var maxP2 = max ~/ p1 ~/ p1 ~/ p1 ~/ p1;
    for (var p2 in primes) {
      if (p2 <= p1) continue;
      if (p2 > maxP2) break;
      var prod12 = p1 * p2;
      var maxP3 = max ~/ prod12 ~/ p2 ~/ p2;
      for (var p3 in primes) {
        if (p3 <= p2) continue;
        if (p3 > maxP3) break;
        var prod123 = prod12 * p3;
        var maxP4 = max ~/ prod123 ~/ p3;
        for (var p4 in primes) {
          if (p4 <= p3) continue;
          if (p4 > maxP4) break;
          var prod1234 = prod123 * p4;
          var maxP5 = max ~/ prod1234;
          for (var p5 in primes) {
            if (p5 <= p4) continue;
            if (p5 > maxP5) break;
            var prod12345 = prod1234 * p5;
            if (prod12345 < min) continue;
            if (prod12345 > max) break;
            results.add(prod12345);
          }
        }
      }
    }
  }
  return results;
}
