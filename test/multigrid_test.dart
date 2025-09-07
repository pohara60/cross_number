import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/solver.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:test/test.dart';

void main() {
  test('Multi-grid puzzle', () {
    final puzzle = PuzzleDefinition(
      name: 'Multi-grid test',
      grids: {
        'L': Grid(1, 2, name: 'L'),
        'R': Grid(1, 2, name: 'R'),
      },
      entries: {
        'L.A1': Entry(
            id: 'L.A1',
            clueId: 'L.1A',
            row: 0,
            col: 0,
            length: 2,
            orientation: EntryOrientation.across),
        'R.A1': Entry(
            id: 'R.A1',
            clueId: 'R.1A',
            row: 0,
            col: 0,
            length: 2,
            orientation: EntryOrientation.across),
      },
      clues: {
        'L.1A': Clue('L.1A', [ExpressionConstraint('R.1A + 1')]),
        'R.1A': Clue('R.1A', [ExpressionConstraint('10')]),
      },
      variables: {},
    );
    final solver = Solver(puzzle);
    solver.solve();
    expect(puzzle.clues['L.1A']!.possibleValues, equals({11}));
    expect(puzzle.clues['R.1A']!.possibleValues, equals({10}));
  });
  test('Multi-grid puzzle validation', () {
    PuzzleDefinition getPuzzle() {
      return PuzzleDefinition(
        name: 'Multi-grid test',
        grids: {
          'L': Grid(1, 2, name: 'L'),
          'R': Grid(1, 2, name: 'R'),
        },
        entries: {
          'A1': Entry(
              id: 'A1',
              clueId: '1A',
              row: 0,
              col: 0,
              length: 2,
              orientation: EntryOrientation.across),
          'X.A1': Entry(
              id: 'X.A1',
              clueId: 'X.1A',
              row: 0,
              col: 0,
              length: 2,
              orientation: EntryOrientation.across),
        },
        clues: {
          'L.1A': Clue('L.1A', [ExpressionConstraint('R.1A + 1')]),
          'R.1A': Clue('R.1A', [ExpressionConstraint('10')]),
        },
        variables: {},
      );
    }

    expect(() => getPuzzle(), throwsA(TypeMatcher<PuzzleException>()));
  });
}
