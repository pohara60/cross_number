import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/wheels.dart';

void main() {
  group('Wheels', () {
    test('should solve the puzzle', () {
      final puzzle = wheels();
      // final solver = Solver(puzzle, trace: true);
      final solver = Solver(puzzle, trace: false, traceBacktrace: false);
      solver.solve();
      expect(solver.isSolutionValid(), isTrue);
    });
  });
}
