// ignore_for_file: unused_import

import 'package:crossnumber/src/expressions/expression.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:test/test.dart';

void main() {
  group('Monadic functions', () {
    test('should evaluate squareroot', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$squareroot 4').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, equals([2]));
    });

    test('should evaluate isOdd', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isOdd 3').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, equals([3]));
    });

    test('should evaluate isEven', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isEven 4').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, equals([4]));
    });

    test('should evaluate isAscendingDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isAscendingDigits 123').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 1000);
      expect(result, equals([123]));
    });

    test('should evaluate isDescendingDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isDescendingDigits 321').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 1000);
      expect(result, equals([321]));
    });

    test('should evaluate isUniqueDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isUniqueDigits 123').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 1000);
      expect(result, equals([123]));
    });

    test('should evaluate isPrime', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isPrime 7').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, equals([7]));
    });

    test('should evaluate isSquare', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isSquare 9').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, equals([9]));
    });

    test('should evaluate isCube', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isCube 8').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, equals([8]));
    });

    test('should evaluate isFibonacci', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isFibonacci 13').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, equals([13]));
    });

    test('should not evaluate isAscendingDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isAscendingDigits 132').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 1000);
      expect(result, isEmpty);
    });

    test('should not evaluate isDescendingDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isDescendingDigits 312').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 1000);
      expect(result, isEmpty);
    });

    test('should not evaluate isUniqueDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isUniqueDigits 121').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 1000);
      expect(result, isEmpty);
    });

    test('should not evaluate isPrime', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isPrime 6').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, isEmpty);
    });

    test('should not evaluate isSquare', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isSquare 10').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, isEmpty);
    });

    test('should not evaluate isCube', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isCube 9').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, isEmpty);
    });

    test('should not evaluate isFibonacci', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isFibonacci 12').parse();
      final result =
          evaluator.evaluateNoVariables(expression, [], min: 0, max: 100);
      expect(result, isEmpty);
    });
  });
}
