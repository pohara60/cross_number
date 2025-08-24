import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/increasing_prime.dart';
import 'test_utils.dart';

void main() {
  group('Increasing Primes', () {
    test('should solve the puzzle', () {
      final puzzle = increasingPrimes();
      // final solver = Solver(puzzle, traceSolve: true);
      final solver = Solver(puzzle, traceSolve: false, traceBacktrace: false);
      int solveCount = 0;

      bool callback() {
        // Check entry/clue values
        expectEntryValues(puzzle, 'A', [984]);
        expectEntryValues(puzzle, 'a', [812]);
        expectEntryValues(puzzle, 'b', [48]);
        expectEntryValues(puzzle, 'B', [83]);
        expectEntryValues(puzzle, 'c', [3287]);
        expectEntryValues(puzzle, 'C', [21]);
        expectEntryValues(puzzle, 'D', [862]);
        expectEntryValues(puzzle, 'd', [64]);
        expectEntryValues(puzzle, 'e', [1241]);
        expectEntryValues(puzzle, 'E', [2348]);
        expectEntryValues(puzzle, 'f', [36]);
        expectEntryValues(puzzle, 'F', [2169]);
        expectEntryValues(puzzle, 'g', [14]);
        expectEntryValues(puzzle, 'h', [993]);
        expectEntryValues(puzzle, 'G', [441]);
        expectEntryValues(puzzle, 'j', [11]);
        expectEntryValues(puzzle, 'H', [92]);
        expectEntryValues(puzzle, 'J', [12]);
        expectEntryValues(puzzle, 'K', [132]);

        solveCount++;
        return true;
      }

      solver.solve(callback);
      expect(solveCount, 1);
    });
  });
}
