import 'package:test/test.dart';
import 'package:crossnumber/src/solver.dart';
import '../puzzles/puzzle2.dart';

void main() {
  group('Puzzle2', () {
    test('should solve the second puzzle correctly', () {
      final puzzle = puzzle2();
      final solver = Solver(puzzle);
      solver.solve();

      // check variable values
      expect(puzzle.variables['A']!.possibleValues, contains(4));
      // expect(puzzle.variables['A']!.possibleValues.length, 1);
      expect(puzzle.variables['B']!.possibleValues, contains(25));
      // expect(puzzle.variables['B']!.possibleValues.length, 1);
      expect(puzzle.variables['C']!.possibleValues, contains(9));
      expect(puzzle.variables['C']!.possibleValues.length, 1);
      expect(puzzle.variables['D']!.possibleValues, contains(11));
      expect(puzzle.variables['D']!.possibleValues.length, 1);
      expect(puzzle.variables['E']!.possibleValues, contains(14));
      // expect(puzzle.variables['E']!.possibleValues.length, 1);

      // Check clue values
      expect(puzzle.clues['1A']!.possibleValues, contains(16));
      // expect(puzzle.clues['1A']!.possibleValues.length, 1);
      expect(puzzle.clues['2D']!.possibleValues, contains(625));
      // expect(puzzle.clues['2D']!.possibleValues.length, 1);

      // Check entry values
      expect(puzzle.entries['A1']!.possibleValues, contains(16));
      // expect(puzzle.entries['A1']!.possibleValues.length, 1);
      expect(puzzle.entries['D2']!.possibleValues, contains(625));
      // expect(puzzle.entries['D2']!.possibleValues.length, 1);
    });
  });
}
