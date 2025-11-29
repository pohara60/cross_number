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
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 10, max: 99);
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
    test('#twodigitprime generator', () {
      final parser = Parser('#twodigitprime');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 1, max: 999);
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
    test('#productfiveprimes generator', () {
      final parser = Parser('#productfiveprimes');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 2000, max: 5000);
      expect(result, containsAll([2310, 2730, 3570, 3990, 4290, 4830]));
    });
    test('#twodigitprimetoprimepower generator', () {
      final parser = Parser('#twodigitprimetoprimepower');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 1000, max: 2999);
      expect(result, containsAll([1331, 1369, 1681, 1849, 2197, 2209, 2809]));
    });

    test('#triangular generator with clue length', () {
      final parser = Parser('#triangular');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 10, max: 99);
      expect(result, containsAll([10, 15, 21, 28, 36, 45, 55, 66, 78, 91]));
    });

    test('#square generator with clue length', () {
      final parser = Parser('#square');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 10, max: 99);
      expect(result, containsAll([16, 25, 36, 49, 64, 81]));
    });

    test('#fibonacci generator with clue length', () {
      final parser = Parser('#fibonacci');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 10, max: 99);
      expect(result, containsAll([13, 21, 34, 55, 89]));
    });

    test('#harshad generator with clue length', () {
      final parser = Parser('#harshad');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 10, max: 99);
      expect(
          result,
          containsAll([
            10,
            12,
            18,
            20,
            21,
            24,
            27,
            30,
            36,
            40,
            42,
            45,
            48,
            50,
            54,
            60,
            63,
            70,
            72,
            80,
            81,
            84,
            90
          ]));
    });

    test('#palindrome generator with clue length', () {
      final parser = Parser('#palindrome');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result1 = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 10, max: 50);
      expect(result1, containsAll([11, 22, 33, 44]));
      final result2 = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 100, max: 250);
      expect(
          result2,
          containsAll([
            101,
            111,
            121,
            131,
            141,
            151,
            161,
            171,
            181,
            191,
            202,
            212,
            222,
            232,
            242
          ]));
    });

    test('Generator with binary operation', () {
      final parser = Parser('#prime + A');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 1, max: 10);

      // Primes in range (1-10): 2, 3, 5, 7
      // Primes + 2: 4, 5, 7, 9
      // Primes + 3: 5, 6, 8, 10
      expect(result, containsAll([4, 5, 6, 7, 8, 9, 10]));
    });
    test('Generator with binary operation edge cases', () {
      final parser = Parser('#prime + 5');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 11, max: 20);

      // Primes in range (1-10): 2, 3, 5, 7
      // Primes + 2: 4, 5, 7, 9
      // Primes + 3: 5, 6, 8, 10
      expect(result, containsAll([12, 16, 18]));
    });
  });
}
