// ignore_for_file: unused_import

import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:test/test.dart';
import 'package:crossnumber/src/solver.dart';
import '../puzzles/puzzle3.dart';
import 'test_utils.dart';

void main() {
  group('Puzzle3', () {
    test('should solve the third puzzle correctly', () {
      final puzzle = puzzle3();
      final solver = Solver(puzzle);

      bool callback() {
        // Check entry/clue values
        expectEntryValues(puzzle, 'A1', [324]);
        expectEntryValues(puzzle, 'A3', [21]);
        expectEntryValues(puzzle, 'A5', [1416]);
        expectEntryValues(puzzle, 'A6', [121]);
        expectEntryValues(puzzle, 'A7', [19]);
        expectEntryValues(puzzle, 'D1', [361]);
        expectEntryValues(puzzle, 'D2', [441]);
        expectEntryValues(puzzle, 'D4', [169]);
        return true;
      }

      solver.solve(callback);
    });
  });
}
