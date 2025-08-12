import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition puzzle3() {
  return PuzzleDefinition(
    name: 'Puzzle3',
    grids: {
      'main': Grid(3, 5),
    },
    entries: {
      'A1': Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 3,
          orientation: EntryOrientation.across,
          clueId: '1A'),
      'D1': Entry(
          id: 'D1',
          row: 0,
          col: 0,
          length: 3,
          orientation: EntryOrientation.down,
          clueId: '1D'),
      'D2': Entry(
          id: 'D2',
          row: 0,
          col: 2,
          length: 3,
          orientation: EntryOrientation.down,
          clueId: '2D'),
      'A3': Entry(
          id: 'A3',
          row: 0,
          col: 3,
          length: 2,
          orientation: EntryOrientation.across,
          clueId: '3A'),
      'D4': Entry(
          id: 'D4',
          row: 0,
          col: 4,
          length: 3,
          orientation: EntryOrientation.down,
          clueId: '4D'),
      'A5': Entry(
          id: 'A5',
          row: 1,
          col: 1,
          length: 4,
          orientation: EntryOrientation.across,
          clueId: '5A'),
      'A6': Entry(
          id: 'A6',
          row: 2,
          col: 0,
          length: 3,
          orientation: EntryOrientation.across,
          clueId: '6A'),
      'A7': Entry(
          id: 'A7',
          row: 2,
          col: 3,
          length: 2,
          orientation: EntryOrientation.across,
          clueId: '7A'),
    },
    clues: {
      '1A': Clue('1A', [ExpressionConstraint('#square')]),
      '1D': Clue('1D', [ExpressionConstraint('7A * 7A')]),
      '2D': Clue('2D', [ExpressionConstraint('3A * 3A')]),
      '3A': Clue('3A', [ExpressionConstraint('\$squareroot 2D')]),
      '4D': Clue('4D', [ExpressionConstraint('#square')]),
      '6A': Clue('6A', [ExpressionConstraint('#square')]),
      '7A': Clue('7A', [ExpressionConstraint('\$squareroot 1D')]),
      '5A': Clue('5A', [ExpressionConstraint('1A+1D+2D+4D+6A')]),
    },
    variables: {},
  );
}
