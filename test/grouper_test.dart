import 'package:crossnumber/src/grouper.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:test/test.dart';

void main() {
  group('TransitiveExpressableGrouper', () {
    test('should group two expressables referencing each other', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {
          'A': Clue('A', [ExpressionConstraint('B')]),
          'B': Clue('B', [ExpressionConstraint('A')]),
        },
        variables: {},
      );
      final grouper = TransitiveExpressableGrouper();
      final groups = grouper.findGroups(puzzle, false);
      expect(groups.length, 1);
      expect(groups[0].map((e) => e.id).toSet(), {'A', 'B'});
    });

    test('should group a chain of references', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {
          'A': Clue('A', [ExpressionConstraint('B')]),
          'B': Clue('B', [ExpressionConstraint('C')]),
          'C': Clue('C', []),
        },
        variables: {},
      );
      final grouper = TransitiveExpressableGrouper();
      final groups = grouper.findGroups(puzzle, false);
      expect(groups.length, 1);
      expect(groups[0].map((e) => e.id).toSet(), {'A', 'B'});
    });

    test('should handle complex reference graphs', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {
          'A': Clue('A', [ExpressionConstraint('B')]),
          'B': Clue('B', [ExpressionConstraint('C')]),
          'C': Clue('C', [ExpressionConstraint('A')]),
          'D': Clue('D', [ExpressionConstraint('E')]),
          'E': Clue('E', []),
        },
        variables: {},
      );
      final grouper = TransitiveExpressableGrouper();
      final groups = grouper.findGroups(puzzle, false);
      expect(groups.length, 1);
      final group1 = groups.firstWhere((g) => g.any((e) => e.id == 'A'));
      expect(group1.map((e) => e.id).toSet(), {'A', 'B', 'C'});
    });

    test('should not group disconnected expressables', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {
          'A': Clue('A', [ExpressionConstraint('1')]),
          'B': Clue('B', [ExpressionConstraint('2')]),
        },
        variables: {},
      );
      final grouper = TransitiveExpressableGrouper();
      final groups = grouper.findGroups(puzzle, false);
      expect(groups.length, 0);
    });
  });
}
