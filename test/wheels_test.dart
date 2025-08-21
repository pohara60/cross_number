import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/wheels.dart';

var solutionCount = 0;
bool callback() {
  // Found a solution (with or without backtracking)
  solutionCount++;
  return true;
}

void main() {
  group('Wheels', () {
    test('should solve the puzzle', () {
      final puzzle = wheels();
      // final solver = Solver(puzzle, traceSolve: true);
      final solver = Solver(puzzle, traceSolve: false, traceBacktrace: false);
      solver.solve(callback);
      expect(solutionCount, 1);
    });
  });
}
