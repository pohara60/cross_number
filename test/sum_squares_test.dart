import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/sum_squares.dart';

void main() {
  // Disable slow test
  final disabled = true;
  group('SumSquares', () {
    test('should solve the puzzle', () {
      final puzzle = sumsquares();
      // final solver = Solver(puzzle, traceSolve: true);
      final solver = Solver(puzzle, traceSolve: false, traceBacktrace: false);
      int solveCount = 0;

      bool callback() {
        solveCount++;
        return true;
      }

      solver.solve(callback);
      expect(solveCount, 1);
    }, skip: disabled);
  });
}
