import 'package:test/test.dart';
import 'package:crossnumber/src/solver.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:crossnumber/src/models/entry.dart';

void main() {
  group('Solver', () {
    test('should evaluate simple expression constraints', () {
      final clue = Clue('1A', [ExpressionConstraint('10 + 5')]);
      final puzzle = PuzzleDefinition(
        name: 'Test Puzzle',
        grids: {'test': Grid(1, 1)},
        entries: {},
        clues: {'1A': clue},
        variables: {},
      );
      final solver = Solver(puzzle, allowBacktracking: false, trace: true);
      solver.solve();

      expect(clue.possibleValues, contains(15));
      expect(clue.possibleValues!.length, 1);
    });

    test('should evaluate expression constraints with variables', () {
      final variableA = Variable('A', {1, 2, 3});
      final clue = Clue('1A', [ExpressionConstraint('A * 2')]);
      final puzzle = PuzzleDefinition(
        name: 'Test Puzzle',
        grids: {'test': Grid(1, 1)},
        entries: {},
        clues: {'1A': clue},
        variables: {'A': variableA},
      );
      final solver = Solver(puzzle, allowBacktracking: false);
      solver.solve();

      expect(clue.possibleValues, containsAll({2, 4, 6}));
      expect(clue.possibleValues!.length, 3);
    });

    test('should evaluate multi-grid expression constraints', () {
      final entry1 = Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 1,
          orientation: EntryOrientation.across);
      entry1.possibleValues = {10}; // Set a known value
      final entry2 = Entry(
          id: 'B1',
          row: 0,
          col: 0,
          length: 1,
          orientation: EntryOrientation.across);
      entry2.possibleValues = {5}; // Set a known value

      final clue = Clue('1A', [ExpressionConstraint('Grid1.A1 + Grid2.B1')]);

      final puzzle = PuzzleDefinition(
        name: 'Test Puzzle',
        grids: {
          'Grid1': Grid(1, 1),
          'Grid2': Grid(1, 1),
        },
        entries: {'A1': entry1, 'B1': entry2},
        clues: {'1A': clue},
        variables: {},
      );
      final solver = Solver(puzzle, allowBacktracking: false);
      solver.solve();

      expect(clue.possibleValues, contains(15));
      expect(clue.possibleValues!.length, 1);
    });

    test('should propagate variable changes to dependent clues', () {
      final variableA = Variable('A', {1, 2});
      final clue1 = Clue('1A', [ExpressionConstraint('A * 2')]);
      clue1.possibleValues = {2, 4}; // Initial possible values
      final clue2 = Clue('2A', [ExpressionConstraint('A + 1')]);
      clue2.possibleValues = {2, 3}; // Initial possible values

      final puzzle = PuzzleDefinition(
        name: 'Test Puzzle',
        grids: {'test': Grid(1, 1)},
        entries: {},
        clues: {'1A': clue1, '2A': clue2},
        variables: {'A': variableA},
      );
      final solver = Solver(puzzle, allowBacktracking: false);

      // Manually reduce variable A's possible values
      variableA.possibleValues = {1};
      solver.solve();

      // Expect clue1 and clue2 to be re-evaluated based on the new variable A value
      expect(clue1.possibleValues, contains(2));
      expect(clue1.possibleValues!.length, 1);
      expect(clue2.possibleValues, contains(2));
      expect(clue2.possibleValues!.length, 1);
    });
  });
}
