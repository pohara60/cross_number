import 'package:test/test.dart';
import 'package:crossnumber/src/solver.dart';
import '../puzzles/puzzle2.dart';
import 'test_utils.dart';

void main() {
  group('Puzzle2', () {
    test('should solve the second puzzle correctly', () {
      final puzzle = puzzle2();
      final solver = Solver(puzzle);

      bool callback() {
        // check variable values
        expectValues(puzzle.variables['A']!.possibleValues, [4]);
        expectValues(puzzle.variables['B']!.possibleValues, [25]);
        expectValues(puzzle.variables['C']!.possibleValues, [9]);
        expectValues(puzzle.variables['D']!.possibleValues, [11]);
        expectValues(puzzle.variables['E']!.possibleValues, [13]);

        // Check entry values
        expectEntryValues(puzzle, 'A1', [16]);
        expectEntryValues(puzzle, 'D2', [625]);
        expectEntryValues(puzzle, 'D3', [81]);
        expectEntryValues(puzzle, 'D4', [18]);
        expectEntryValues(puzzle, 'A4', [121]);
        expectEntryValues(puzzle, 'A5', [52]);
        return true;
      }

      solver.solve(callback);
    });
  });
}
