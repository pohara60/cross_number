import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition simplePuzzle() {
  return PuzzleDefinition(
    name: 'Simple Puzzle',
    grids: {
      'main': Grid(2, 2),
    },
    entries: {
      'A1': Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across,
          clueId: '1A'),
      'D1': Entry(
          id: 'D1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.down,
          clueId: '1D'),
    },
    clues: {
      '1A': Clue('1A', [ExpressionConstraint('A * 2')]),
      '1D': Clue('1D', [ExpressionConstraint('A * 6 - 68')]),
    },
    variables: {
      'A': Variable('A', {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}),
    },
  );
}
