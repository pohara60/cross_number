import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/ordering_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

void main() {
  group('OrderingConstraint', () {
    test('should prune possible values correctly', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {
          'A': Clue('A', [ExpressionConstraint('X')]),
          'B': Clue('B', [ExpressionConstraint('Y')]),
        },
        variables: {
          'X': Variable('X', {10, 20}),
          'Y': Variable('Y', {15, 25}),
        },
        orderingConstraints: [
          OrderingConstraint(ids: ['A', 'B']),
        ],
      );

      final solver = Solver(puzzle);
      solver.solve();

      // The solver should not be able to solve this puzzle completely,
      // but it should prune the possible values.
      // After the first iteration of constraint propagation, we expect:
      // A.possibleValues to be {10, 20}
      // B.possibleValues to be {15, 25}
      // After the ordering constraint is applied:
      // max(A) must be less than max(B)
      // min(B) must be greater than min(A)
      // A={10, 20}, B={15, 25}
      // A can be 20, B can be 15, which is not allowed.
      // The logic is more complex.
      // For each value x in X, there must be a value y in Y such that y > x.
      // For each value y in Y, there must be a value x in X such that x < y.
      // So, 20 in A is only valid if there is a value in B > 20, which is 25.
      // And 15 in B is only valid if there is a value in A < 15, which is 10.
      // So the possible values should not be pruned in this case.

      // Let's try another case
      final puzzle2 = PuzzleDefinition(
        name: 'test2',
        grids: {},
        entries: {},
        clues: {
          'A': Clue('A', [ExpressionConstraint('X')]),
          'B': Clue('B', [ExpressionConstraint('Y')]),
        },
        variables: {
          'X': Variable('X', {10, 20}),
          'Y': Variable('Y', {5, 15}),
        },
        orderingConstraints: [
          OrderingConstraint(ids: ['A', 'B']),
        ],
      );

      final solver2 = Solver(puzzle2);
      solver2.solve();

      // A.possibleValues should be {10}
      // B.possibleValues should be {15}
      expect(puzzle2.clues['A']!.possibleValues, equals({10}));
      expect(puzzle2.clues['B']!.possibleValues, equals({15}));
    });
  });
}
