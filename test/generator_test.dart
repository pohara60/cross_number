import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:test/test.dart';

void main() {
  group('Generator Expressions', () {
    final puzzle = PuzzleDefinition(
      name: 'Test Puzzle',
      grids: {},
      entries: {
        'A1': Entry(
            id: 'A1',
            length: 2,
            row: 0,
            col: 0,
            orientation: EntryOrientation.across),
      },
      clues: {
        'A1': Clue('A1', []),
      },
      variables: {
        'A': Variable('A', {2, 3}),
      },
    );

    test('#prime generator with clue length', () {
      final parser = Parser('#prime');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 10, max: 99);
      expect(
          result,
          containsAll([
            11,
            13,
            17,
            19,
            23,
            29,
            31,
            37,
            41,
            43,
            47,
            53,
            59,
            61,
            67,
            71,
            73,
            79,
            83,
            89,
            97
          ]));
    });

    test('#triangular generator with clue length', () {
      final parser = Parser('#triangular');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 10, max: 99);
      expect(result, containsAll([10, 15, 21, 28, 36, 45, 55, 66, 78, 91]));
    });

    test('#square generator with clue length', () {
      final parser = Parser('#square');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 10, max: 99);
      expect(result, containsAll([16, 25, 36, 49, 64, 81]));
    });

    test('#fibonacci generator with clue length', () {
      final parser = Parser('#fibonacci');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 10, max: 99);
      expect(result, containsAll([13, 21, 34, 55, 89]));
    });

    test('Generator with binary operation', () {
      final parser = Parser('#prime + A');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 1, max: 10);

      // Primes in range (1-10): 2, 3, 5, 7
      // Primes + 2: 4, 5, 7, 9
      // Primes + 3: 5, 6, 8, 10
      expect(result, containsAll([4, 5, 6, 7, 8, 9, 10]));
    });
    test('Generator with binary operation edge cases', () {
      final parser = Parser('#prime + 5');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 11, max: 20);

      // Primes in range (1-10): 2, 3, 5, 7
      // Primes + 2: 4, 5, 7, 9
      // Primes + 3: 5, 6, 8, 10
      expect(result, containsAll([12, 16, 18]));
    });
  });
}
