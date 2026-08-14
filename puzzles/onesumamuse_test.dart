// cspell: disable
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

Map<List<int>, int> getSumOfSquares({String cacheFilePath = 'cache.json'}) {
  final cacheFile = File(cacheFilePath);

  // Define the map with value-equality for keys
  final results = LinkedHashMap<List<int>, int>(
    equals: const ListEquality().equals,
    hashCode: const ListEquality().hash,
  );

  // 1. READ FROM DISK (If cache file exists)
  if (cacheFile.existsSync()) {
    try {
      final jsonString = cacheFile.readAsStringSync();
      final Map<String, dynamic> rawMap = json.decode(jsonString);

      for (final entry in rawMap.entries) {
        // Decode the string key back into List<int>
        final List<int> key = List<int>.from(json.decode(entry.key) as List);
        results[key] = entry.value as int;
      }
      return results;
    } catch (e) {
      // If reading/parsing fails, fall back to recalculating
      print('Failed to read cache, recalculating: $e');
    }
  }

  // 2. COMPUTE RESULTS (If cache doesn't exist)
  for (var a = 100; a <= 999; a++) {
    for (var b = a + 1; b <= 999; b++) {
      for (var c = b + 1; c <= 999; c++) {
        final sumOfSquares = a * a + b * b + c * c;
        if (sumOfSquares < 1000000 || sumOfSquares > 9999999) continue;
        final digits = (a.toString() + b.toString() + c.toString()).split('').map(int.parse).toSet();
        if (digits.length != 9) continue;
        if (digits.contains(0)) continue;
        final reversedA = int.parse(a.toString().split('').reversed.join(''));
        final reversedB = int.parse(b.toString().split('').reversed.join(''));
        final reversedC = int.parse(c.toString().split('').reversed.join(''));
        final reversedSumOfSquares = reversedA * reversedA + reversedB * reversedB + reversedC * reversedC;
        if (reversedSumOfSquares < 1000000 || reversedSumOfSquares > 9999999) continue;
        if (reversedSumOfSquares != sumOfSquares) continue;
        // final reversedDigits =
        //     (reversedA.toString() + reversedB.toString() + reversedC.toString()).split('').map(int.parse).toSet();
        // if (reversedDigits.length != 9) continue;
        // if (reversedDigits.contains(0)) continue;
        // print('Found: $a, $b, $c => Sum of squares: $sumOfSquares');
        var ordered = [a, b, c];
        results[ordered] = sumOfSquares;
      }
    }
  }

  // 3. WRITE TO DISK
  try {
    // Standard JSON requires string keys, so we stringify the List<int> keys
    final rawMap = <String, int>{};
    for (final entry in results.entries) {
      rawMap[json.encode(entry.key)] = entry.value;
    }

    cacheFile.writeAsStringSync(json.encode(rawMap));
  } catch (e) {
    print('Failed to write cache to disk: $e');
  }

  return results;
}

Map<List<int>, int> results = {};
var firstArg = <int>{};
var secondArg = <int>{};
var thirdArg = <int>{};
var sumOfSquares = <int>{};
var allArgs = <int>{};

void computeSumOfSquares() {
  results = getSumOfSquares();
  print('Total results found: ${results.length}');
  firstArg = results.keys.map((k) => k[0]).toSet();
  secondArg = results.keys.map((k) => k[1]).toSet();
  thirdArg = results.keys.map((k) => k[2]).toSet();
  sumOfSquares = results.values.toSet();
  allArgs = firstArg.union(secondArg).union(thirdArg);
  print('Unique A value count: ${firstArg.length}');
  print('Unique B value count: ${secondArg.length}');
  print('Unique C value count: ${thirdArg.length}');
  print('Unique Sum value count: ${sumOfSquares.length}');
  print('Unique All Args value count: ${allArgs.length}');
}

int? getSumOfSquaresForOrdered(List<int> ordered) {
  return results[ordered];
}

int? sum3DigitSquares(List<dynamic> values) {
  // In each clue the first three elements are 3-digit numbers that together comprise the nine non-zero digits. The
  // fourth element is the sum of the squares of the other three.
  // Clues are given in pairs, in each pair one set of 3-digit numbers are the reverses of the other set.
  assert(values.length == 3);
  final a = values[0] as int;
  final b = values[1] as int;
  final c = values[2] as int;

  var ordered = [a, b, c]..sort();
  final sumOfSquares = getSumOfSquaresForOrdered(ordered);
  return sumOfSquares;
}

int reverse(int value) {
  var valueStr = value.toString();
  var reverseValue = 0;
  for (var index = valueStr.length - 1; index >= 0; index--) {
    reverseValue = reverseValue * 10 + int.parse(valueStr[index]);
  }
  return reverseValue;
}

void main(List<String> args) {
/*
      a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
      d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
      N = sum3digitsquares(7*D/12,G,g) = sum3digitsquares(f-b/2,'G,K)
*/
// In each clue the first three elements are 3-digit numbers that together comprise the nine non-zero digits. The
// fourth element is the sum of the squares of the other three.
// Clues are given in pairs, in each pair one set of 3-digit numbers are the reverses of the other set.

  computeSumOfSquares();

  var argValues = <String, int>{};
  for (var e in allArgs) {
    argValues['e'] = e;
    var argA1a = e;
    for (var G in allArgs) {
      if (argValues.containsValue(G)) continue; // Distinct
      argValues['G'] = G;
      var argA1b = G;
      var argA2b = reverse(G);
      for (var L = 100; L <= 999; L++) {
        if (argValues.containsValue(L)) continue; // Distinct
        argValues['L'] = L;
        var argA1c = L;
        var argA1 = [argA1a, argA1b, argA1c];
        var sumA1 = sum3DigitSquares(argA1);
        if (sumA1 == null) continue;
        var reversedArgA1 = argA1.map((e) => reverse(e)).toSet();
        reversedArgA1.remove(argA2b); // Remove G from the reversed list since we already have it as argA2b
        assert(reversedArgA1.length == 2);
        for (var b in allArgs) {
          if (argValues.containsValue(b)) continue; // Distinct
          argValues['b'] = b;
          var argA2a = b;
          if (!reversedArgA1.contains(argA2a)) continue;
          reversedArgA1.remove(argA2a); // Remove b from the reversed list since we already have it as argA2a
          assert(reversedArgA1.length == 1);
          var argA2c = reversedArgA1.first;
          var argA2 = [argA2a, argA2b, argA2c];
          var sumA2 = sum3DigitSquares(argA2);
          if (sumA1 == sumA2) {
            for (var H = 100; H <= 999; H++) {
              if (argValues.containsValue(H)) continue; // Distinct
              argValues['H'] = H;
              var j = argA2c - H;
              if (j < 100 || j > 999) continue; // j must be a 3-digit number
              if (argValues.containsValue(j)) continue; // Distinct
              argValues['j'] = j;
              // A = sum3digitsquares(e,G,L) = sum3digitsquares(b,'G,H+j)
              var arga1c = G;
              for (var C in allArgs) {
                if (argValues.containsValue(C)) continue; // Distinct
                argValues['C'] = C;
                var arga1a = C;
                for (var B in allArgs) {
                  if (argValues.containsValue(B)) continue; // Distinct
                  argValues['B'] = B;
                  var arga1b = B;
                  var arga1 = [arga1a, arga1b, arga1c];
                  var suma1 = sum3DigitSquares(arga1);
                  if (suma1 == null || suma1 == sumA1) continue; // Distinct
                  var reversedArga1 = arga1.map((e) => reverse(e)).toSet();
                  var arga2a = reverse(G);
                  reversedArga1.remove(arga2a); // Remove G from the reversed list since we already have it as argA2b
                  assert(reversedArga1.length == 2);
                  for (var J in allArgs) {
                    if (argValues.containsValue(J)) continue; // Distinct
                    argValues['J'] = J;
                    var arga2b = J;
                    if (!reversedArga1.contains(arga2b)) continue;
                    reversedArga1.remove(arga2b);
                    assert(reversedArga1.length == 1);
                    var arga2c = reversedArga1.first;
                    var arga2 = [arga2a, arga2b, arga2c];
                    var suma2 = sum3DigitSquares(arga2);
                    if (suma1 == suma2) {
                      for (var M = 100; M <= 999; M++) {
                        if (argValues.containsValue(M)) continue; // Distinct
                        argValues['M'] = M;
                        var c = M - arga2c;
                        if (c < 100 || c > 999) continue;
                        if (argValues.containsValue(c)) continue; // Distinct
                        argValues['c'] = c;
                        // a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
// e, G, L, b, H, j => A
// C, B, J, M, c => a
// h, E, f, F => d
                        // d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
                        var argd1a = G;
                        var argd2b = reverse(G);
                        var argd1c = M;
                        for (var h in allArgs) {
                          if (argValues.containsValue(h)) continue; // Distinct
                          argValues['h'] = h;
                          var argd1b = h;
                          var argd1 = [argd1a, argd1b, argd1c];
                          var sumd1 = sum3DigitSquares(argd1);
                          if (sumd1 == null || sumd1 == suma1 || sumd1 == sumA1) continue; // Distinct
                          var reversedArgd1 = argd1.map((e) => reverse(e)).toSet();
                          reversedArgd1.remove(argd2b);
                          assert(reversedArgd1.length == 2);
                          for (var E in allArgs) {
                            if (argValues.containsValue(E)) continue; // Distinct
                            argValues['E'] = E;
                            for (var f in allArgs) {
                              if (argValues.containsValue(f)) continue; // Distinct
                              argValues['f'] = f;
                              var argd2a = E + f + H;
                              if (!reversedArgd1.contains(argd2a)) continue;
                              reversedArgd1.remove(argd2a);
                              assert(reversedArgd1.length == 1,
                                  "reversedArgd1.length == ${reversedArgd1.length}, should be 1");
                              var argd2c = reversedArgd1.first;
                              var argd2 = [argd2a, argd2b, argd2c];
                              var sumd2 = sum3DigitSquares(argd2);
                              if (sumd1 == sumd2) {
                                var F = L - argd2c;
                                if (F >= 100 && F <= 999 && !argValues.containsValue(F)) {
                                  argValues['F'] = F;
                                  // a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
// e, G, L, b, H, j => A
// C, B, J, M, c => a
// h, E, f, F => d
                                  // d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
// D, g, K => N
                                  // N = sum3digitsquares(7*D/12,G,g) = sum3digitsquares(f-b/2,'G,K)}
                                  print(
                                      'Found: e=$e, G=$G, L=$L, b=$b, H=$H, j=$j => A: $sumA1, Args are reverses of each other: $argA1 and $argA2');
                                  print(
                                      'Found: C=$C, B=$B, J=$J, M=$M, c=$c => a: $suma1, Args are reverses of each other: $arga1 and $arga2');
                                  print(
                                      'Found: h=$h, E=$E, f=$f, F=$F => d: $sumd1, Args are reverses of each other: $argd1 and $argd2');
                                  argValues.remove('F');
                                }
                              }
                              reversedArgd1.add(argd2a);
                              assert(reversedArgd1.length == 2);
                            }
                            argValues.remove('f');
                          }
                          argValues.remove('E');
                          reversedArgd1.add(argd2b);
                          assert(reversedArgd1.length == 3);
                        }
                        argValues.remove('h');
                      }
                      argValues.remove('M');
                      argValues.remove('c');
                    }
                    reversedArga1.add(arga2b);
                    assert(reversedArga1.length == 2);
                  }
                  reversedArga1.add(arga2a);
                  assert(reversedArga1.length == 3);
                  argValues.remove('J');
                }
                argValues.remove('B');
              }
              argValues.remove('C');
            }
            argValues.remove('H');
            argValues.remove('j');
          }
          reversedArgA1.add(argA2a); // Add b back to the reversed list since we are done with it
          assert(reversedArgA1.length == 2, 'reversedArgA1.length = ${reversedArgA1.length} should be 2');
        }
        reversedArgA1.add(argA2b);
        assert(reversedArgA1.length == 3);
        argValues.remove('b');
      }
      argValues.remove('L');
    }
    argValues.remove('G');
  }
}
