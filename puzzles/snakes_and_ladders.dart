import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/snakes_and_ladders_grid.dart';
import 'package:crossnumber/src/models/variable.dart';

/// You throw a standard die and gradually work up the board, climbing a ladder
/// if you land at the foot of it, and sliding down a snake if you land on its
/// head. So, for example, if you consistently threw a 3 on your die you would
/// land on cells 3, 6, 9, 12, 46, 49 and so on. In one special game I
/// consistently threw the same particular number and ended up landing on 100.
/// Your task today is to use the following clues to fill in the grid in such a
/// way that the cells I landed on in that special game all contain different
/// digits. The clue answers are all different and none of them starts with
/// zero.

PuzzleDefinition snakesAndLadders() {
  final grid = SnakesAndLaddersGrid(10, 10);
  return PuzzleDefinition(
    name: 'Snakes and Ladders',
    grids: {'main': grid},
    entries: {
      // Across clues
      'A1': Entry(
          id: 'A1',
          row: 9,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across,
          clueId: 'A1'),
      'A2': Entry(
          id: 'A2',
          row: 8,
          col: 0,
          length: 3,
          orientation: EntryOrientation.across,
          clueId: 'A2'),
      'D1': Entry(
          id: 'D1',
          row: 8,
          col: 0,
          length: 2,
          orientation: EntryOrientation.down,
          clueId: 'D1'),
      'D2': Entry(
          id: 'D2',
          row: 9,
          col: 1,
          length: 2,
          orientation: EntryOrientation.up,
          clueId: 'D2'),
    },
    clues: {
      'A1': Clue('A1', [ExpressionConstraint('A * 11')]),
      'A2': Clue('A2', [ExpressionConstraint('#square')]),
      'D1': Clue('D1', [ExpressionConstraint('B * 11+1')]),
      'D2': Clue('D2', [ExpressionConstraint('A * 12')]),
    },
    variables: {
      'A': Variable('A', Set.from(List.generate(9, (i) => i + 1))),
      'B': Variable('B', Set.from(List.generate(9, (i) => i + 1))),
    },
  );
}
