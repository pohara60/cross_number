import 'package:test/test.dart';
import 'package:crossnumber/src/solver.dart';
import '../puzzles/simple_puzzle.dart';

void main() {
  group('Simple Puzzle', () {
    test('should solve the simple puzzle correctly', () {
      final puzzle = simplePuzzle();
      final solver = Solver(puzzle);
      solver.solve();

      // After constraint propagation, only A=17 should be left
      expect(puzzle.variables['A']!.possibleValues, contains(17));
      expect(puzzle.variables['A']!.possibleValues.length, 1);

      // Check clue values
      expect(puzzle.clues['1A']!.possibleValues, contains(34));
      expect(puzzle.clues['1A']!.possibleValues!.length, 1);
      expect(puzzle.clues['1D']!.possibleValues, contains(34));
      expect(puzzle.clues['1D']!.possibleValues!.length, 1);

      // Check entry values
      expect(puzzle.entries['A1']!.possibleValues, contains(34));
      expect(puzzle.entries['A1']!.possibleValues.length, 1);
      expect(puzzle.entries['D1']!.possibleValues, contains(34));
      expect(puzzle.entries['D1']!.possibleValues.length, 1);
    });
  });
}
