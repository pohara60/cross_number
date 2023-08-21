/// An API for solving Prime Cuts puzzles.
library primecuts;

import 'dart:collection';

import 'package:powers/powers.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/primecuts/clue.dart';
import 'package:crossnumber/primecuts/puzzle.dart';

import '../variable.dart';

/// Provide access to the Prime Cuts API.
class PrimeCuts extends Crossnumber<PrimeCutsPuzzle> {
  PrimeCuts() {
    puzzle = PrimeCutsPuzzle();
    initCrossnumber();
  }

  void initCrossnumber() {
    var a2 = PrimeCutsEntry(
        name: 'A2',
        length: 3,
        preValueDesc: 'Multiple of gA2',
        prime: 'B',
        primeDesc: 'B',
        valueDesc: '',
        solve: solveA2);
    puzzle.addEntry(a2);
    var a5 = PrimeCutsEntry(
        name: 'A5',
        length: 2,
        preValueDesc: 'Square',
        prime: 'C',
        primeDesc: 'C',
        valueDesc: '',
        solve: solveA5);
    puzzle.addEntry(a5);
    var a7 = PrimeCutsEntry(
        name: 'A7',
        length: 3,
        preValueDesc: 'Multiple of D',
        prime: 'D',
        primeDesc: 'D',
        valueDesc: 'Multiple of D',
        solve: solveA7);
    puzzle.addEntry(a7);
    var a9 = PrimeCutsEntry(
        name: 'A9',
        length: 2,
        preValueDesc: 'Multiple of R',
        prime: 'F',
        primeDesc: 'F',
        valueDesc: 'Reverse of another entry',
        solve: solveA9);
    puzzle.addEntry(a9);
    var a11 = PrimeCutsEntry(
        name: 'A11',
        length: 2,
        preValueDesc: 'Ascending digits',
        prime: 'G',
        primeDesc: 'G',
        valueDesc: 'Factor of gD11',
        solve: solveA11);
    puzzle.addEntry(a11);
    var a12 = PrimeCutsEntry(
        name: 'A12',
        length: 2,
        preValueDesc: 'Triangular ',
        prime: 'H',
        primeDesc: 'H',
        valueDesc: 'Triangular ',
        solve: solveA12);
    puzzle.addEntry(a12);
    var a13 = PrimeCutsEntry(
        name: 'A13',
        length: 2,
        preValueDesc: 'Prime',
        prime: 'J',
        primeDesc: 'J',
        valueDesc: '',
        solve: solveA13);
    puzzle.addEntry(a13);
    var a14 = PrimeCutsEntry(
        name: 'A14',
        length: 2,
        preValueDesc: 'Triangular ',
        prime: 'K',
        primeDesc: 'K',
        valueDesc: '',
        solve: solveA14);
    puzzle.addEntry(a14);
    var a15 = PrimeCutsEntry(
        name: 'A15',
        length: 3,
        preValueDesc: 'Cube of D',
        prime: 'L',
        primeDesc: 'L',
        valueDesc: 'Square of S',
        solve: solveA15);
    puzzle.addEntry(a15);
    var a17 = PrimeCutsEntry(
        name: 'A17',
        length: 2,
        preValueDesc: 'Square',
        prime: 'M',
        primeDesc: 'M reverse C',
        valueDesc: 'Reverse of gD3',
        solve: solveA17);
    puzzle.addEntry(a17);
    var a18 = PrimeCutsEntry(
        name: 'A18',
        length: 3,
        preValueDesc: 'Multiple H',
        prime: 'N',
        primeDesc: 'N ascending ',
        valueDesc: 'Multiple  of W',
        solve: solveA18);
    puzzle.addEntry(a18);

    var d1 = PrimeCutsEntry(
        name: 'D1',
        length: 2,
        preValueDesc: 'Multiple of P',
        prime: 'P',
        primeDesc: 'P = Triangular - Z',
        valueDesc: '',
        solve: solveD1);
    puzzle.addEntry(d1);
    var d3 = PrimeCutsEntry(
        name: 'D3',
        length: 2,
        preValueDesc: 'Square ',
        prime: 'Q',
        primeDesc: 'Q',
        valueDesc: '',
        solve: solveD3);
    puzzle.addEntry(d3);
    var d4 = PrimeCutsEntry(
        name: 'D4',
        length: 3,
        preValueDesc: 'Multiple of B',
        prime: 'R',
        primeDesc: 'R',
        valueDesc: '',
        solve: solveD4);
    puzzle.addEntry(d4);
    var d6 = PrimeCutsEntry(
        name: 'D6',
        length: 3,
        preValueDesc: 'Palindrome',
        prime: 'S',
        primeDesc: 'S',
        valueDesc: 'K x T',
        solve: solveD6);
    puzzle.addEntry(d6);
    var d8 = PrimeCutsEntry(
        name: 'D8',
        length: 3,
        preValueDesc: 'Descending digits',
        prime: 'T',
        primeDesc: 'T',
        valueDesc: '',
        solve: solveD8);
    puzzle.addEntry(d8);
    var d10 = PrimeCutsEntry(
        name: 'D10',
        length: 3,
        preValueDesc: 'Ascending digits, Divisible by sum digits',
        prime: 'V',
        primeDesc: 'V',
        valueDesc: '',
        solve: solveD10);
    puzzle.addEntry(d10);
    var d11 = PrimeCutsEntry(
        name: 'D11',
        length: 3,
        preValueDesc: 'Ascending digits',
        prime: 'W',
        primeDesc: 'W',
        valueDesc: 'G + W',
        solve: solveD11);
    puzzle.addEntry(d11);
    var d12 = PrimeCutsEntry(
        name: 'D12',
        length: 3,
        preValueDesc: 'Same sum digits A18',
        prime: 'X',
        primeDesc: 'X',
        valueDesc: 'Jumble gA18',
        solve: solveD12);
    puzzle.addEntry(d12);
    var d15 = PrimeCutsEntry(
        name: 'D15',
        length: 2,
        preValueDesc: 'Square',
        prime: 'Y',
        primeDesc: 'Y = reverse Q',
        valueDesc: '',
        solve: solveD15);
    puzzle.addEntry(d15);
    var d16 = PrimeCutsEntry(
        name: 'D16',
        length: 2,
        preValueDesc: 'Multiple of Z',
        prime: 'Z',
        primeDesc: 'Z',
        valueDesc: 'Square - gD1',
        solve: solveD16);
    puzzle.addEntry(d16);

    puzzle.addDigitIdentity(a2, 2, d3, 1);
    puzzle.addDigitIdentity(a2, 3, d4, 1);
    puzzle.addDigitIdentity(a5, 2, d6, 1);
    puzzle.addDigitIdentity(a7, 1, d1, 2);
    puzzle.addDigitIdentity(a7, 2, d8, 1);
    puzzle.addDigitIdentity(a7, 3, d3, 2);
    puzzle.addDigitIdentity(a9, 1, d4, 2);
    puzzle.addDigitIdentity(a9, 2, d10, 1);
    puzzle.addDigitIdentity(a11, 1, d11, 1);
    puzzle.addDigitIdentity(a11, 2, d8, 2);
    puzzle.addDigitIdentity(a12, 1, d12, 1);
    puzzle.addDigitIdentity(a12, 2, d4, 3);
    puzzle.addDigitIdentity(a13, 1, d10, 2);
    puzzle.addDigitIdentity(a13, 2, d6, 3);
    puzzle.addDigitIdentity(a14, 1, d8, 3);
    puzzle.addDigitIdentity(a14, 2, d12, 2);
    puzzle.addDigitIdentity(a15, 1, d15, 1);
    puzzle.addDigitIdentity(a15, 2, d10, 3);
    puzzle.addDigitIdentity(a15, 3, d16, 1);
    puzzle.addDigitIdentity(a17, 1, d11, 3);
    puzzle.addDigitIdentity(a18, 1, d12, 3);
    puzzle.addDigitIdentity(a18, 2, d15, 2);
    puzzle.addClueReference(a9, d4, false);
    puzzle.addClueReference(a11, d11, true);
    puzzle.addClueReference(a15, a7, false);
    puzzle.addClueReference(a17, a5, true);
    puzzle.addClueReference(a17, d3, true);
    puzzle.addClueReference(a18, a12, false);
    puzzle.addClueReference(a18, d11, false);
    puzzle.addClueReference(d1, d16, true);
    puzzle.addClueReference(d4, a2, false);
    puzzle.addClueReference(d6, a14, true);
    puzzle.addClueReference(d6, d8, true);
    puzzle.addClueReference(d11, a11, false);
    puzzle.addClueReference(d12, a18, true);
    puzzle.addClueReference(d15, d3, false);
    puzzle.addClueReference(d16, d1, false);
    a9.addPrimeReference('R');
    a15.addPrimeReference('D');
    a15.addPrimeReference('S');
    a17.addPrimeReference('C');
    a18.addPrimeReference('H');
    a18.addPrimeReference('W');
    d1.addPrimeReference('Z');
    d4.addPrimeReference('B');
    d6.addPrimeReference('K');
    d6.addPrimeReference('T');
    d11.addPrimeReference('G');
    d15.addPrimeReference('Q');

    // A9 depends on all othe 2 digit entries
    for (var other in getTwoDigitCluesLessA9()) {
      puzzle.addClueReference(a9, other, false);
    }

    if (Crossnumber.traceInit) {
      print(puzzle.toString());
    }
  }

  // Override solveClue to manage preValues
  bool solveClue(Clue inputClue) {
    var clue = inputClue as PrimeCutsEntry;
    // If clue solved already then skip it
    if (clue.values != null && clue.values!.length == 1) return false;

    var updated = false;
    if (clue.initialise()) updated = true;

    if (clue.solve != null) {
      var possiblePreValue = <int>{};
      var possibleValue = <int>{};
      if (clue.solve!(clue, possiblePreValue, possibleValue)) updated = true;
      // Some Solve functions do not update PreValues
      if (possiblePreValue.isNotEmpty && clue.updatePreValues(possiblePreValue))
        updated = true;
      // If no Values returned then Solve function could not solve
      if (possibleValue.isNotEmpty) {
        if (clue.updateValues(possibleValue)) updated = true;
        if (clue.finalise()) updated = true;
      }
    }

    if (Crossnumber.traceSolve) {
      print("solve: $clue");
      print("primes[${clue.prime}]=${puzzle.primes[clue.prime]}");
      for (var prime in clue.primeReferences) {
        print("primes[$prime]=${puzzle.primes[prime]}");
      }
    }
    return updated;
  }

  bool updatePrimes(String prime, Set<int> possibleValues) =>
      updateVariables(prime, possibleValues);

  // A15 - PreValue 5 digits D^3, Removed prime L, Value entry S^2
  bool solveA15(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var maxD = 100000.cbrt().floor();
    var minD = 10000.cbrt().ceil();
    var allD = puzzle.primes['D']!.values!
        .where((element) => element <= maxD && element >= minD)
        .toList();
    var fiveDigitCubedPrimes = allD.map((e) => e * e * e).toList();
    var twoDigitPrimesSquared = twoDigitPrimes.map((e) => e * e).toList();
    var possibleD = <int>{};
    var possibleL = <int>{};
    var possibleS = <int>{};
    for (var index = 0; index < fiveDigitCubedPrimes.length; index++) {
      var preValue = fiveDigitCubedPrimes[index];
      var d = allD[index];
      for (var l
          in puzzle.primes['L']!.values!.where((element) => element != d)) {
        for (var value in ValueIterator(preValue, l)) {
          var sIndex = twoDigitPrimesSquared.indexOf(value!);
          if (sIndex != -1 && clue.digitsMatch(value)) {
            var s = twoDigitPrimesSquared[sIndex].sqrt().floor();
            if (s != d && s != l) {
              possiblePreValue.add(preValue);
              possibleValue.add(value);
              possibleD.add(d);
              possibleL.add(l);
              possibleS.add(s);
            }
          }
        }
      }
    }
    if (updatePrimes('D', possibleD)) updated = true;
    if (updatePrimes('L', possibleL)) updated = true;
    if (updatePrimes('S', possibleS)) updated = true;

    return updated;
  }

  // D6 - PreValue 5 digits palindrome, Removed prime S, Value entry K*T
  bool solveD6(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var fiveDigitPalindromes = getFiveDigitPalindromes();
    var threeDigitPrimeMultiples = getThreeDigitPrimeMultiples();
    var possibleS = <int>{};
    var possibleK = <int>{};
    var possibleT = <int>{};
    for (var preValue in fiveDigitPalindromes) {
      for (var s in puzzle.primes['S']!.values!) {
        for (var value in ValueIterator(preValue, s)) {
          if (threeDigitPrimeMultiples.containsKey(value) &&
              clue.digitsMatch(value!)) {
            var p1 = threeDigitPrimeMultiples[value]!['p1']!;
            var p2 = threeDigitPrimeMultiples[value]!['p2']!;
            if (p1 != s && p2 != s) {
              possiblePreValue.add(preValue);
              possibleValue.add(value);
              possibleS.add(s);
              possibleK.add(p1);
              possibleK.add(p2);
              possibleT.add(p1);
              possibleT.add(p2);
            }
          }
        }
      }
    }
    if (updatePrimes('S', possibleS)) updated = true;
    if (updatePrimes('K', possibleK)) updated = true;
    if (updatePrimes('T', possibleT)) updated = true;

    return updated;
  }

  // A17 - PreValue 4 digits square, Removed prime M = reverse C
  bool solveA17(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var fourDigitSquares = getFourDigitSquares();
    var possibleM = <int>{};
    var possibleC = <int>{};
    for (var preValue in fourDigitSquares) {
      for (var m in puzzle.primes['M']!.values!
          .where((element) => primeHasReverse(element, twoDigitPrimes))) {
        for (var value in ValueIterator(preValue, m)) {
          if (clue.digitsMatch(value!)) {
            possiblePreValue.add(preValue);
            possibleValue.add(value);
            possibleM.add(m);
            possibleC.add(reverse(m));
          }
        }
      }
    }
    if (updatePrimes('M', possibleM)) updated = true;
    if (updatePrimes('C', possibleC)) updated = true;

    return updated;
  }

  // D15 - PreValue 4 digits square, Removed prime Y = reverse Q
  bool solveD15(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var fourDigitSquares = getFourDigitSquares();
    var possibleY = <int>{};
    var possibleQ = <int>{};
    for (var preValue in fourDigitSquares) {
      for (var y in puzzle.primes['Y']!.values!
          .where((element) => twoDigitPrimeHasReverse(element))) {
        for (var value in ValueIterator(preValue, y)) {
          if (clue.digitsMatch(value!)) {
            possiblePreValue.add(preValue);
            possibleValue.add(value);
            possibleY.add(y);
            possibleQ.add(reverse(y));
          }
        }
      }
    }
    if (updatePrimes('Y', possibleY)) updated = true;
    if (updatePrimes('Q', possibleQ)) updated = true;

    return updated;
  }

  // D3 - PreValue 4 digits square, Removed prime Q = reverse Y
  bool solveD3(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var fourDigitSquares = getFourDigitSquares();
    var possibleQ = <int>{};
    var possibleY = <int>{};
    for (var preValue in fourDigitSquares) {
      for (var q in puzzle.primes['Q']!.values!
          .where((element) => twoDigitPrimeHasReverse(element))) {
        for (var value in ValueIterator(preValue, q)) {
          if (clue.digitsMatch(value!)) {
            possiblePreValue.add(preValue);
            possibleValue.add(value);
            possibleQ.add(q);
            possibleY.add(reverse(q));
          }
        }
      }
    }
    if (updatePrimes('Q', possibleQ)) updated = true;
    if (updatePrimes('Y', possibleY)) updated = true;

    return updated;
  }

  // A5 - PreValue 4 digits square, Removed prime C = reverse M
  bool solveA5(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var fourDigitSquares = getFourDigitSquares();
    var possibleC = <int>{};
    var possibleM = <int>{};
    for (var preValue in fourDigitSquares) {
      for (var c in puzzle.primes['C']!.values!
          .where((element) => twoDigitPrimeHasReverse(element))) {
        for (var value in ValueIterator(preValue, c)) {
          if (clue.digitsMatch(value!)) {
            possiblePreValue.add(preValue);
            possibleValue.add(value);
            possibleC.add(c);
            possibleM.add(reverse(c));
          }
        }
      }
    }
    if (updatePrimes('C', possibleC)) updated = true;
    if (updatePrimes('M', possibleM)) updated = true;

    return updated;
  }

  // A13 - PreValue 4 digits prime, Removed prime J
  bool solveA13(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var fourDigitPrimes = getFourDigitPrimes();
    var possibleJ = <int>{};
    for (var preValue in fourDigitPrimes) {
      for (var j in puzzle.primes['J']!.values!) {
        for (var value in ValueIterator(preValue, j)) {
          if (clue.digitsMatch(value!)) {
            possiblePreValue.add(preValue);
            possibleValue.add(value);
            possibleJ.add(j);
          }
        }
      }
    }
    if (updatePrimes('J', possibleJ)) updated = true;

    return updated;
  }

  // D16 - PreValue 4 digits multiple of Z, Removed prime Z, value square - D1
  bool solveD16(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;

    Set<int>? valueD1 = puzzle.clues['D1']!.values;
    var possibleZ = <int>{};
    var possibleD1 = <int>{};
    for (var z in puzzle.primes['Z']!.values!) {
      var multiples = multiple(z, requireMultiple: false);
      for (var value in multiples) {
        if (clue.digitsMatch(value)) {
          if (valueD1 == null) {
            possibleValue.add(value);
            possibleZ.add(z);
          } else {
            for (var d1 in valueD1) {
              if ((d1 + value).sqrt().floor().pow(2) == (d1 + value)) {
                possibleValue.add(value);
                possibleZ.add(z);
                possibleD1.add(d1);
              }
            }
          }
        }
      }
    }

    if (updatePrimes('Z', possibleZ)) updated = true;

    return updated;
  }

  // A7 - PreValue 5 digits multiple of D, Removed prime D, value multiple of D
  bool solveA7(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var possibleD = <int>{};
    for (var d in puzzle.primes['D']!.values!) {
      var multiples = multiple(d, digits: 5, requireMultiple: true);
      for (var value in multiples) {
        if (clue.digitsMatch(value)) {
          possibleValue.add(value);
          possibleD.add(d);
        }
      }
    }
    if (updatePrimes('D', possibleD)) updated = true;

    return updated;
  }

  // D1 - PreValue 4 digits multiple of P, Removed prime P = triangular - Z
  bool solveD1(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var triangleSumTwoPrimes = getPrimesInTriangleSumTwoPrimes();
    var possibleP = <int>{};
    var possibleZ = SplayTreeSet<int>();
    for (var p in puzzle.primes['P']!.values!) {
      var updatedP = false;
      if (triangleSumTwoPrimes.containsKey(p) &&
          triangleSumTwoPrimes[p]!.any(
              (element) => puzzle.primes['Z']!.values!.contains(element))) {
        var multiples = multiple(p, requireMultiple: false);
        for (var value in multiples) {
          if (clue.digitsMatch(value)) {
            possibleValue.add(value);
            possibleP.add(p);
            updatedP = true;
          }
        }
      }
      if (updatedP) {
        triangleSumTwoPrimes[p]!.forEach((element) {
          if (puzzle.primes['Z']!.values!.contains(element)) {
            possibleZ.add(element);
          }
        });
      }
    }
    if (updatePrimes('P', possibleP)) updated = true;
    if (updatePrimes('Z', possibleZ)) updated = true;

    return updated;
  }

  // A12 - 4 digit triangle, removed prime H, value triangle
  bool solveA12(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var fourDigitTriangles = getFourDigitTriangles();
    var twoDigitTriangles = getTwoDigitTriangles();
    var possibleH = <int>{};
    for (var preValue in fourDigitTriangles) {
      for (var h in puzzle.primes['H']!.values!) {
        for (var value in ValueIterator(preValue, h)) {
          if (twoDigitTriangles.contains(value!)) {
            if (clue.digitsMatch(value)) {
              possiblePreValue.add(preValue);
              possibleValue.add(value);
              possibleH.add(h);
            }
          }
        }
      }
    }
    if (updatePrimes('H', possibleH)) updated = true;

    return updated;
  }

  // A14 - 4 digit triangle, removed prime K
  bool solveA14(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var fourDigitTriangles = getFourDigitTriangles();
    var possibleK = <int>{};
    for (var preValue in fourDigitTriangles) {
      for (var k in puzzle.primes['K']!.values!) {
        for (var value in ValueIterator(preValue, k)) {
          if (clue.digitsMatch(value!)) {
            possiblePreValue.add(preValue);
            possibleValue.add(value);
            possibleK.add(k);
          }
        }
      }
    }
    if (updatePrimes('K', possibleK)) updated = true;

    return updated;
  }

  // D11 - PreValue 5 ascending digits, Removed prime W, Value G+W
  bool solveD11(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var sumTwoPrimes = getSumTwoPrimes();
    var possibleG = <int>{};
    var possibleW = <int>{};
    for (var d1 in [1, 2, 3, 4, 5, 6, 7, 8, 9]) {
      for (var d2
          in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].where((element) => element > d1)) {
        for (var d3 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
            .where((element) => element > d2)) {
          for (var d4 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
              .where((element) => element > d3)) {
            for (var d5 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                .where((element) => element > d4)) {
              var preValue = d1 * 10000 + d2 * 1000 + d3 * 100 + d4 * 10 + d5;
              for (var w in puzzle.primes['W']!.values!) {
                for (var value in ValueIterator(preValue, w)) {
                  if (sumTwoPrimes.containsKey(value) &&
                      sumTwoPrimes[value]!.contains(w) &&
                      puzzle.primes['G']!.values!.contains(value! - w) &&
                      clue.digitsMatch(value)) {
                    possiblePreValue.add(preValue);
                    possibleValue.add(value);
                    possibleW.add(w);
                    possibleG.add(value - w);
                  }
                }
              }
            }
          }
        }
      }
    }
    if (updatePrimes('W', possibleW)) updated = true;
    if (updatePrimes('G', possibleG)) updated = true;

    return updated;
  }

  // D10 - PreValue 5 ascending digits divisible by sum, Removed prime V
  bool solveD10(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var possibleV = <int>{};
    for (var d1 in [1, 2, 3, 4, 5, 6, 7, 8, 9]) {
      for (var d2
          in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].where((element) => element > d1)) {
        for (var d3 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
            .where((element) => element > d2)) {
          for (var d4 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
              .where((element) => element > d3)) {
            for (var d5 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                .where((element) => element > d4)) {
              var preValue = d1 * 10000 + d2 * 1000 + d3 * 100 + d4 * 10 + d5;
              var sum = d1 + d2 + d3 + d4 + d5;
              if (preValue % sum == 0) {
                for (var v in puzzle.primes['V']!.values!) {
                  for (var value in ValueIterator(preValue, v)) {
                    if (clue.digitsMatch(value!)) {
                      possiblePreValue.add(preValue);
                      possibleValue.add(value);
                      possibleV.add(v);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    if (updatePrimes('V', possibleV)) updated = true;

    return updated;
  }

  // A2 - PreValue 5 digits multiple of value, Removed prime B
  bool solveA2(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var possibleB = <int>{};
    for (var preValue = 10000; preValue < 100000; preValue++) {
      for (var b in puzzle.primes['B']!.values!) {
        for (var value in ValueIterator(preValue, b)) {
          if (preValue % value! == 0 && clue.digitsMatch(value)) {
            possiblePreValue.add(preValue);
            possibleValue.add(value);
            possibleB.add(b);
          }
        }
      }
    }
    if (updatePrimes('B', possibleB)) updated = true;

    return updated;
  }

  // A11 - PreValue 4 ascending digits, Removed prime G, Value factor of D11
  bool solveA11(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;

    // Need D11 value to solve
    Set<int>? allD11 = puzzle.clues['D11']!.values;
    if (allD11 == null) return false;

    var possibleG = <int>{};
    var possibleD11 = <int>{};
    for (var d1 in [1, 2, 3, 4, 5, 6, 7, 8, 9]) {
      for (var d2
          in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].where((element) => element > d1)) {
        for (var d3 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
            .where((element) => element > d2)) {
          for (var d4 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
              .where((element) => element > d3)) {
            var preValue = d1 * 1000 + d2 * 100 + d3 * 10 + d4;
            for (var g in puzzle.primes['G']!.values!) {
              for (var value in ValueIterator(preValue, g)) {
                for (var d11 in allD11) {
                  if (d11 % value! == 0 && clue.digitsMatch(value)) {
                    possiblePreValue.add(preValue);
                    possibleValue.add(value);
                    possibleG.add(g);
                    possibleD11.add(d11);
                  }
                }
              }
            }
          }
        }
      }
    }
    if (updatePrimes('G', possibleG)) updated = true;
    // Not necessary to update D11

    return updated;
  }

  // A18 - PreValue 5 digits multiple of H, Removed prime N asc digits, Value multiple W
  bool solveA18(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var possibleN = <int>{};
    var possibleH = <int>{};
    var possibleW = <int>{};
    for (var h in puzzle.primes['H']!.values!) {
      var preValue = h;
      while (preValue < 100000) {
        if (preValue > 9999) {
          for (var n in puzzle.primes['N']!.values!
              .where((element) => element != h && ascending(element))) {
            for (var value in ValueIterator(preValue, n)) {
              if (clue.digitsMatch(value!)) {
                for (var w in puzzle.primes['W']!.values!
                    .where((element) => element != h && element != n)) {
                  if (value % w == 0) {
                    possiblePreValue.add(preValue);
                    possibleValue.add(value);
                    possibleN.add(n);
                    possibleH.add(h);
                    possibleW.add(w);
                  }
                }
              }
            }
          }
        }
        preValue += h;
      }
    }
    if (updatePrimes('N', possibleN)) updated = true;
    if (updatePrimes('H', possibleH)) updated = true;
    if (updatePrimes('W', possibleW)) updated = true;
    return updated;
  }

  // D12 - PreValue 5 digits same digit sum as A18, Prime X, Value jumble gA18
  bool solveD12(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;

    // Require A18 preValue and value, do not try if too many possibles
    var a18 = puzzle.clues['A18']! as PrimeCutsEntry;
    Set<int>? valueA18 = a18.values;
    Set<int>? preValueA18 = a18.preValues;
    if (valueA18 == null ||
        preValueA18 == null ||
        valueA18.length > 10 ||
        preValueA18.length > 10) return false;

    var possibleX = <int>{};
    // Should process A18 preValue and value in parallel, but not possible, and works OK
    // for (var index = 0; index < preValueA18.length; index++) {
    //   var vA18 = preValueA18[index];
    //   var gA18 = valueA18[index];
    for (var vA18 in preValueA18) {
      for (var gA18 in valueA18) {
        var sum = sumDigits(vA18);
        var preValue = 10000;
        while (preValue < 100000) {
          if (sum == sumDigits(preValue)) {
            for (var x in puzzle.primes['X']!.values!) {
              for (var value in ValueIterator(preValue, x)) {
                if (isJumble(gA18, value!) && clue.digitsMatch(value)) {
                  possiblePreValue.add(preValue);
                  possibleValue.add(value);
                  possibleX.add(x);
                }
              }
            }
          }
          preValue++;
        }
      }
    }
    if (updatePrimes('X', possibleX)) updated = true;
    return updated;
  }

  // D8 PreValue 5 descending digits, Prime T
  bool solveD8(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var possibleT = <int>{};
    for (var d5 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
      for (var d4
          in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].where((element) => element > d5)) {
        for (var d3 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
            .where((element) => element > d4)) {
          for (var d2 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
              .where((element) => element > d3)) {
            for (var d1 in [1, 2, 3, 4, 5, 6, 7, 8, 9]
                .where((element) => element > d2)) {
              var preValue = d1 * 10000 + d2 * 1000 + d3 * 100 + d4 * 10 + d5;
              for (var t in puzzle.primes['T']!.values!) {
                for (var value in ValueIterator(preValue, t)) {
                  if (clue.digitsMatch(value!)) {
                    possiblePreValue.add(preValue);
                    possibleValue.add(value);
                    possibleT.add(t);
                  }
                }
              }
            }
          }
        }
      }
    }
    if (updatePrimes('T', possibleT)) updated = true;
    return updated;
  }

  // D4 PreValue 5 digits multiple B, Prime R
  bool solveD4(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;
    var possibleR = <int>{};
    var possibleB = <int>{};
    for (var b in puzzle.primes['B']!.values!) {
      var preValue = b;
      while (preValue < 100000) {
        if (preValue > 9999) {
          for (var r
              in puzzle.primes['R']!.values!.where((element) => element != b)) {
            for (var value in ValueIterator(preValue, r)) {
              if (clue.digitsMatch(value!)) {
                possiblePreValue.add(preValue);
                possibleValue.add(value);
                possibleR.add(r);
                possibleB.add(b);
              }
            }
          }
        }
        preValue += b;
      }
    }
    if (updatePrimes('B', possibleB)) updated = true;
    if (updatePrimes('R', possibleR)) updated = true;
    return updated;
  }

  // A9 PreValue 4 digits multiple R, Prime F, Value reverse of another entry
  bool solveA9(
      PrimeCutsEntry clue, Set<int> possiblePreValue, Set<int> possibleValue) {
    var updated = false;

    var otherEntry = <int>{};
    for (var other in getTwoDigitCluesLessA9()) {
      // If any other unknown then cannot continue
      if (other.values == null) return false;
      otherEntry.addAll(other.values!);
    }

    var possibleR = <int>{};
    var possibleF = <int>{};
    for (var r in puzzle.primes['R']!.values!) {
      var preValue = r;
      while (preValue < 10000) {
        if (preValue > 999) {
          for (var f
              in puzzle.primes['F']!.values!.where((element) => element != r)) {
            for (var value in ValueIterator(preValue, f)) {
              if (otherEntry.contains(reverse(value!)) &&
                  clue.digitsMatch(value)) {
                possiblePreValue.add(preValue);
                possibleValue.add(value);
                possibleR.add(r);
                possibleF.add(f);
              }
            }
          }
        }
        preValue += r;
      }
    }
    if (updatePrimes('R', possibleR)) updated = true;
    if (updatePrimes('F', possibleF)) updated = true;
    return updated;
  }

  /// Find **multiple** of prime, that are also a multiple when the digits of prime are removed.
  ///
  /// [digits] is the length of the preValue.
  Set<int> multiple(int prime, {int digits = 4, bool requireMultiple = true}) {
    var matches = <int>{};
    int preValue = prime;
    String preValueStr = preValue.toString();
    while (preValueStr.length <= digits) {
      if (preValueStr.length == digits) {
        for (var match in ValueIterator(preValue, prime)) {
          if (!requireMultiple || match! % prime == 0) {
            matches.add(match!);
          }
        }
      }
      preValue += prime;
      preValueStr = preValue.toString();
    }
    return matches;
  }

  List<PrimeCutsClue> getTwoDigitCluesLessA9() {
    return puzzle.clues.values
        .where((element) => element.name != 'A9' && element.length == 2)
        .toList();
  }
}

Map<int, Set<int>> getSumTwoPrimes() {
  var primes = <int, Set<int>>{};
  for (var p1 in twoDigitPrimes) {
    for (var p2 in twoDigitPrimes) {
      var sum = p1 + p2;
      if (!primes.containsKey(sum)) {
        primes[sum] = <int>{};
      }
      primes[sum]!.add(p1);
      primes[sum]!.add(p2);
    }
  }
  return primes;
}

Map<int, Map<String, int>> getTriangleSumTwoPrimes() {
  var triangles = getTrianglesInRange(20, 198);
  var triangleSums = <int, Map<String, int>>{};
  for (var p1 in twoDigitPrimes) {
    for (var p2 in twoDigitPrimes.where((element) => element > p1)) {
      var sum = p1 + p2;
      if (triangles.contains(sum)) {
        triangleSums[sum] = {'p1': p1, 'p2': p2};
      }
    }
  }
  return triangleSums;
}

Map<int, List<int>> getPrimesInTriangleSumTwoPrimes() {
  var triangles = getTrianglesInRange(20, 198);
  var primes = <int, List<int>>{};
  for (var p1 in twoDigitPrimes) {
    var p2s = <int>[];
    for (var p2 in twoDigitPrimes) {
      var sum = p1 + p2;
      if (p1 != p2 && triangles.contains(sum)) {
        p2s.add(p2);
      }
    }
    if (p2s.isNotEmpty) {
      primes[p1] = p2s;
    }
  }
  return primes;
}

List<int> getTwoDigitSquaresLessA1(int? d1) {
  var squares = <int>[];
  int minA1 = d1 != null ? d1 : 10;
  int maxA1 = d1 != null ? d1 : 99;
  for (var d1 = 1; d1 <= 200.sqrt().floor(); d1++) {
    var preValue = d1 * d1;
    if (preValue - minA1 > 9 && preValue - maxA1 < 100) {
      squares.add(preValue);
    }
  }

  return squares;
}

Map<int, Map<String, int>> getThreeDigitPrimeMultiples() {
  var multiples = <int, Map<String, int>>{};
  outer:
  for (var p1 in twoDigitPrimes) {
    var finished = true;
    for (var p2 in twoDigitPrimes.where((element) => element > p1)) {
      var multiple = p1 * p2;
      if (multiple >= 1000) {
        if (finished) break outer;
        break;
      }
      finished = false;
      if (multiple >= 100) {
        multiples[multiple] = {'p1': p1, 'p2': p2};
      }
    }
  }
  return multiples;
}

class ValueIterator extends Iterable<int?> with Iterator<int?> {
  int preValue;
  String preValueStr;
  int prime;
  String primeStr;
  int? _current;
  int index = 0;

  ValueIterator(this.preValue, this.prime)
      : preValueStr = preValue.toString(),
        primeStr = prime.toString(),
        index = 0;

  // `moveNext`method must return boolean preValue to state if next preValue is available
  bool moveNext() {
    while (index < preValueStr.length - 1 &&
            preValueStr.substring(index, index + 2) != primeStr ||
        index == 0 && preValueStr[index + 2] == '0') {
      index++;
    }
    if (index == preValueStr.length - 1) {
      _current = null;
      return false;
    } else {
      _current = int.parse(
          preValueStr.substring(0, index) + preValueStr.substring(index + 2));
      index += 1;
      return true;
    }
  }

  // `current` getter method returns the current preValue of the iteration when `moveNext` is called
  int? get current => _current;

  @override
  Iterator<int?> get iterator => this;
}
