import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition puzzle2() {
  var variableValues = <int>{
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30
  };
  return PuzzleDefinition(
    name: 'Puzzle2',
    grids: {
      'main': Grid(3, 3),
    },
    entries: {
      'A1': Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across,
          clueId: '1A'),
      'D2': Entry(
          id: 'D2',
          row: 0,
          col: 1,
          length: 3,
          orientation: EntryOrientation.down,
          clueId: '2D'),
      'D3': Entry(
          id: 'D3',
          row: 0,
          col: 2,
          length: 2,
          orientation: EntryOrientation.down,
          clueId: '3D'),
      'D4': Entry(
          id: 'D4',
          row: 1,
          col: 0,
          length: 2,
          orientation: EntryOrientation.down,
          clueId: '4D'),
      'A4': Entry(
          id: 'A4',
          row: 1,
          col: 0,
          length: 3,
          orientation: EntryOrientation.across,
          clueId: '4A'),
      'A5': Entry(
          id: 'A5',
          row: 2,
          col: 1,
          length: 2,
          orientation: EntryOrientation.across,
          clueId: '5A'),
    },
    clues: {
      '1A': Clue('1A', [ExpressionConstraint('A * A')]),
      '2D': Clue('2D', [ExpressionConstraint('B * 25')]),
      '3D': Clue('3D', [ExpressionConstraint('C * 9')]),
      '4D': Clue('4D', [ExpressionConstraint('C * 2')]),
      '4A': Clue('4A', [ExpressionConstraint('D * D')]),
      '5A': Clue('5A', [ExpressionConstraint('E * 4')]),
    },
    variables: {
      'A': Variable('A', Set.from(variableValues)),
      'B': Variable('B', Set.from(variableValues)),
      'C': Variable('C', Set.from(variableValues)),
      'D': Variable('D', Set.from(variableValues)),
      'E': Variable('E', Set.from(variableValues)),
    },
  );
}
