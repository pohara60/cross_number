// cspell: disable
import "onesumamuse_sum_squares.dart";

void main(List<String> args) {
/*
      A = sum3digitsquares(e,G,L) = sum3digitsquares(b,'G,H+j)
      a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
      d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
      N = sum3digitsquares(7*D/12,G,g) = sum3digitsquares(f-b/2,'G,K)
*/
// In each clue the first three elements are 3-digit numbers that together comprise the nine non-zero digits. The
// fourth element is the sum of the squares of the other three.
// Clues are given in pairs, in each pair one set of 3-digit numbers are the reverses of the other set.

  computeSumOfSquares();

// allArgs
// B, C, g, G, h, J, K, M
// 100-999
// D, E, L
// b, c, e, f, j
// 10-99
// F, H
  var argValues = <String, int>{};
  var any3DigitValue = List.generate(900, (i) => 100 + i);
  for (var e in any3DigitValue) {
    argValues['e'] = e;
    var argA1a = e;
    for (var G in allArgs) {
      if (argValues.containsValue(G)) continue; // Distinct
      argValues['G'] = G;
      var argA1b = G;
      var argA2b = reverse(G);
      for (var L in any3DigitValue) {
        if (argValues.containsValue(L)) continue; // Distinct
        argValues['L'] = L;
        var argA1c = L;
        var argA1 = [argA1a, argA1b, argA1c];
        var sumA1 = sum3DigitSquares(argA1);
        if (sumA1 == null) continue;
        var reversedArgA1 = argA1.map((e) => reverse(e)).toSet();
        reversedArgA1.remove(argA2b); // Remove G from the reversed list since we already have it as argA2b
        assert(reversedArgA1.length == 2);
        for (var b in any3DigitValue) {
          if (argValues.containsValue(b)) continue; // Distinct
          if (b % 2 != 0) continue; // N requires this
          argValues['b'] = b;
          var argA2a = b;
          if (!reversedArgA1.contains(argA2a)) continue;
          reversedArgA1.remove(argA2a); // Remove b from the reversed list since we already have it as argA2a
          assert(reversedArgA1.length == 1);
          var argA2c = reversedArgA1.first;
          var argA2 = [argA2a, argA2b, argA2c];
          var sumA2 = sum3DigitSquares(argA2);
          if (sumA1 == sumA2) {
            for (var H = 10; H <= 99; H++) {
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
                      for (var M in allArgs) {
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
                          for (var E in any3DigitValue) {
                            if (argValues.containsValue(E)) continue; // Distinct
                            argValues['E'] = E;
                            for (var f in any3DigitValue) {
                              if (argValues.containsValue(f)) continue; // Distinct
                              argValues['f'] = f;
                              var argd2a = E + f + H;
                              if (argd2a < 100 || argd2a > 999) continue;
                              if (!reversedArgd1.contains(argd2a)) continue;
                              reversedArgd1.remove(argd2a);
                              assert(reversedArgd1.length == 1,
                                  "reversedArgd1.length == ${reversedArgd1.length}, should be 1");
                              var argd2c = reversedArgd1.first;
                              var argd2 = [argd2a, argd2b, argd2c];
                              var sumd2 = sum3DigitSquares(argd2);
                              if (sumd1 == sumd2) {
                                var F = L - argd2c;
                                if (F >= 10 && F <= 99 && !argValues.containsValue(F)) {
                                  argValues['F'] = F;
                                  // a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
// e, G, L, b, H, j => A
// C, B, J, M, c => a
// h, E, f, F => d
                                  // d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
// D, g, K => N
                                  // N = sum3digitsquares(7*D/12,G,g) = sum3digitsquares(f-b/2,'G,K)}
                                  var argN1b = G;
                                  var argN2b = reverse(G);
                                  var argN2a = f - (b / 2).toInt();
                                  if (argN2a >= 100 && argN2a <= 999) {
                                    var reverseArgN2a = reverse(argN2a);
                                    for (var D in any3DigitValue) {
                                      if (argValues.containsValue(D)) continue; // Distinct
                                      argValues['D'] = D;
                                      if (7 * D % 12 != 0) continue;
                                      var argN1a = (7 * D / 12).toInt();
                                      if (argN1a < 100 || argN1a > 999) continue;
                                      var gValues = argN1a == reverseArgN2a ? allArgs : {reverseArgN2a};
                                      for (var g in gValues) {
                                        if (argValues.containsValue(g)) continue; // Distinct
                                        argValues['g'] = g;
                                        var argN1c = g;
                                        var argN1 = [argN1a, argN1b, argN1c];
                                        var sumN1 = sum3DigitSquares(argN1);
                                        if (sumN1 == null || sumN1 == sumd1 || sumN1 == suma1 || sumN1 == sumA1)
                                          continue; // Distinct
                                        var reversedArgN1 = argN1.map((e) => reverse(e)).toSet();
                                        reversedArgN1.remove(argN2b);
                                        assert(reversedArgN1.length == 2);
                                        if (!reversedArgN1.contains(argN2a)) continue;
                                        reversedArgN1.remove(argN2a);
                                        var kValues = {reversedArgN1.first};
                                        for (var K in kValues) {
                                          if (argValues.containsValue(K)) continue; // Distinct
                                          argValues['K'] = K;
                                          var argN2c = K;
                                          var argN2 = [argN2a, argN2b, argN2c];
                                          var sumN2 = sum3DigitSquares(argN2);
                                          if (sumN1 == sumN2) {
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
                                                'Found: h=$h, E=$E, f=$f, F=$F => d: $sumd1, Args are reverses of each other: $argN1 and $argd2');
                                            print(
                                                'Found: D=$D, g=$g, K=$K => N: $sumN1, Args are reverses of each other: $argN1 and $argd2');
                                          }
                                          argValues.remove('K');
                                        }
                                        argValues.remove('K');
                                        reversedArgN1.add(argd2a);
                                        assert(reversedArgN1.length == 2);
                                        reversedArgN1.add(argN2b);
                                        assert(reversedArgN1.length == 3);
                                        argValues.remove('g');
                                      }
                                      argValues.remove('g');
                                    }
                                    argValues.remove('D');
                                    argValues.remove('F');
                                  }
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
