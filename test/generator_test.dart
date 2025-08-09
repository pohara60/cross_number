import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:test/test.dart';

void main() {
  group('Generator Expressions', () {
    test('#prime generator', () {
      final puzzle = PuzzleDefinition(
        grids: {},
        entries: {},
        clues: {},
        variables: {},
      );
      final parser = Parser('#prime');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluate(expression);
      // The default range in the evaluator is 1-99999.
      // Let's check for a few known primes in that range.
      expect(result, containsAll([2, 3, 5, 7, 11, 13, 17, 19, 23, 29]));
    });

    test('#triangular generator', () {
      final puzzle = PuzzleDefinition(
        grids: {},
        entries: {},
        clues: {},
        variables: {},
      );
      final parser = Parser('#triangular');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluate(expression);
      expect(result, containsAll([1, 3, 6, 10, 15, 21, 28, 36, 45, 55]));
    });

    test('#square generator', () {
      final puzzle = PuzzleDefinition(
        grids: {},
        entries: {},
        clues: {},
        variables: {},
      );
      final parser = Parser('#square');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluate(expression);
      expect(result, containsAll([1, 4, 9, 16, 25, 36, 49, 64, 81, 100]));
    });

    test('#fibonacci generator', () {
      final puzzle = PuzzleDefinition(
        grids: {},
        entries: {},
        clues: {},
        variables: {},
      );
      final parser = Parser('#fibonacci');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluate(expression);
      expect(result, containsAll([1, 2, 3, 5, 8, 13, 21, 34, 55, 89]));
    });

    test('Generator with binary operation', () {
      final puzzle = PuzzleDefinition(
        grids: {},
        entries: {},
        clues: {},
        variables: {
          'A': Variable('A', {2, 3}),
        },
      );
      final parser = Parser('#prime + A');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluate(expression);

      // Primes in range + 2: 4, 5, 7, 9, ...
      // Primes in range + 3: 5, 6, 8, 10, ...
      expect(result, containsAll([4, 5, 6, 7, 8, 9, 10]));
    });
  });
}
