import 'package:test/test.dart';
import 'package:crossnumber/src/solver.dart';
import '../puzzles/simple_puzzle.dart';
import 'test_utils.dart';

void main() {
  group('Simple Puzzle', () {
    test('should solve the simple puzzle correctly', () {
      final puzzle = simplePuzzle();
      final solver = Solver(puzzle);
      solver.solve();

      // After constraint propagation, only A=17 should be left
      expectVariableValues(puzzle, 'A', [17]);

      // Check entry values
      expectEntryValues(puzzle, 'A1', [34]);
      expectEntryValues(puzzle, 'D1', [35]);
    });
  });
}
