import 'dart:math';

import 'package:crossnumber/src/expressions/generators.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/primania.dart';

void main() {
  // Disable slow test
  final disabled = false;
  group('Primania', () {
    test('should solve the puzzle', () {
      final puzzle = primania();
      // final solver = Solver(puzzle, traceSolve: true);
      final solver = Solver(puzzle, traceSolve: false, traceBacktrace: false);
      int solveCount = 0;

      final reversiblePrimes2Digits = getReversiblePrimesNDigits(2);
      final reversiblePrimes3Digits = getReversiblePrimesNDigits(3);
      final reversiblePrimes4Digits = getReversiblePrimesNDigits(4);

      bool callback() {
        // Check entry/clue values
        for (final entry in puzzle.entries.values) {
          if (entry.orientation == EntryOrientation.down) continue;

          var value = entry.possibleValues!.single;
          if (entry.length == 2) {
            expect(reversiblePrimes2Digits.contains(value), true,
                reason:
                    'Entry ${entry.id} value $value is not a 2-digit reversible prime');
          } else if (entry.length == 3) {
            expect(reversiblePrimes3Digits.contains(value), true,
                reason:
                    'Entry ${entry.id} value $value is not a 3-digit reversible prime');
          } else if (entry.length == 4) {
            expect(reversiblePrimes4Digits.contains(value), true,
                reason:
                    'Entry ${entry.id} value $value is not a 4-digit reversible prime');
          } else {
            fail('Entry ${entry.id} has unexpected length ${entry.length}');
          }
          var count = puzzle.entries.values
              .where((e) => e.possibleValues!.single == value)
              .length;
          expect(count, 1,
              reason:
                  'Entry ${entry.id} value $value is not unique, occurs $count times');

          // Check for entries where the reverse is present
          // This reduces the solution count to 2
          var s = value.toString();
          var rs = s.split('').reversed.join('');
          if (s != rs) {
            var rvalue = int.parse(rs);
            var rcount = puzzle.entries.values
                .where((e) => e.possibleValues!.single == rvalue)
                .length;
            if (rcount > 0) {
              // return false;
            }
          }
        }
        solveCount++;
        return true;
      }

      solver.solve(callback);
      // expect(solveCount, 2); // Without reversible pairs
      expect(solveCount, 6);
    }, skip: disabled);
  });
}

PrimeGenerator? primeGenerator;

List<int> getReversiblePrimesNDigits(int n) {
  primeGenerator ??= GeneratorRegistry().get('prime') as PrimeGenerator;
  var min = pow(10, n - 1).toInt();
  var max = pow(10, n).toInt() - 1;
  var primes = primeGenerator!.getValues(min, max);
  return primes.where((p) {
    var s = p.toString();
    var rs = s.split('').reversed.join('');
    return s != rs && primes.contains(int.parse(rs));
  }).toList();
}
