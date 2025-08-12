import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:test/test.dart';

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
    expectValues(clue.possibleValues!, expectedValues);
  }
}

void expectVariableValues(
    PuzzleDefinition puzzle, String variableId, List<int> expectedValues) {
  // Check variable values
  var variable = puzzle.variables[variableId]!;
  expectValues(variable.possibleValues, expectedValues);
}
