import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/increasing_prime.dart';

void main() {
  group('Increasing Primes', () {
    test('should solve the puzzle', () {
      final puzzle = increasingPrimes();
      // final solver = Solver(puzzle, traceSolve: true);
      final solver = Solver(puzzle, traceSolve: false, traceBacktrace: false);
      solver.solve();
      expect(solver.isSolutionValid(), isTrue);
    });
  });
}
