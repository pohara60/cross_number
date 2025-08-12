import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:test/test.dart';
import 'package:crossnumber/src/solver.dart';
import '../puzzles/puzzle3.dart';

void main() {
  group('Puzzle3', () {
    test('should solve the third puzzle correctly', () {
      final puzzle = puzzle3();
      final solver = Solver(puzzle);
      solver.solve();

      // Check clue values
      expectEntryValues(puzzle, 'A1', [324]);
      expectEntryValues(puzzle, 'A3', [21]);
      expectEntryValues(puzzle, 'A5', [1416]);
      expectEntryValues(puzzle, 'A6', [121]);
      expectEntryValues(puzzle, 'A7', [19]);
      expectEntryValues(puzzle, 'D1', [361]);
      expectEntryValues(puzzle, 'D2', [441]);
      expectEntryValues(puzzle, 'D3', [169]);
    });
  });
}

void expectValues(Set<int> possibleValues, List<int> expected) {
  expect(possibleValues.length, expected.length);
  expect(possibleValues, containsAll(expected));
}

void expectEntryValues(
    PuzzleDefinition puzzle, String entryId, List<int> expectedValues) {
  // Check entry values
  var entry = puzzle.entries[entryId]!;
  expectValues(entry.possibleValues, expectedValues);
  if (entry.clueId != null) {
    // Check clue values
    var clue = puzzle.clues[entry.clueId]!;
    expectValues(clue.possibleValues, expectedValues);
  }
}
