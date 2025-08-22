// ignore_for_file: unused_import

import 'package:crossnumber/src/expressions/expression.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

void main() {
  group('Monadic functions', () {
    test('should evaluate squareroot', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$squareroot 4').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, equals([2]));
    });

    test('should evaluate isOdd', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isOdd 3').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, equals([3]));
    });

    test('should evaluate isEven', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isEven 4').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, equals([4]));
    });

    test('should evaluate isAscendingDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isAscendingDigits 123').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 1000);
      expect(result, equals([123]));
    });

    test('should evaluate isDescendingDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isDescendingDigits 321').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 1000);
      expect(result, equals([321]));
    });

    test('should evaluate isUniqueDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isUniqueDigits 123').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 1000);
      expect(result, equals([123]));
    });

    test('should evaluate isPrime', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isPrime 7').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, equals([7]));
    });

    test('should evaluate isSquare', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isSquare 9').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, equals([9]));
    });

    test('should evaluate isCube', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isCube 8').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, equals([8]));
    });

    test('should evaluate isFibonacci', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isFibonacci 13').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, equals([13]));
    });

    test('should not evaluate isAscendingDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isAscendingDigits 132').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 1000);
      expect(result, isEmpty);
    });

    test('should not evaluate isDescendingDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isDescendingDigits 312').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 1000);
      expect(result, isEmpty);
    });

    test('should not evaluate isUniqueDigits', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isUniqueDigits 121').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 1000);
      expect(result, isEmpty);
    });

    test('should not evaluate isPrime', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isPrime 6').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, isEmpty);
    });

    test('should not evaluate isSquare', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isSquare 10').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, isEmpty);
    });

    test('should not evaluate isCube', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isCube 9').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, isEmpty);
    });

    test('should not evaluate isFibonacci', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser('\$isFibonacci 12').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 0, max: 100);
      expect(result, isEmpty);
    });
  });
  group('Monadic Functions', () {
    test(r'$lte', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser(r'$lte(5)').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 1, max: 100);
      expect(result, equals({1, 2, 3, 4, 5}));
    });

    test(r'$lt', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser(r'$lt(5)').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 1, max: 100);
      expect(result, equals({1, 2, 3, 4}));
    });

    test(r'$lte', () {
      final puzzle = PuzzleDefinition(
          name: 'Test',
          grids: {},
          entries: {},
          clues: {},
          variables: {
            'A': Variable('A', {14, 15, 16, 17, 18, 19, 20}),
            'B':
                Variable('B', {15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26}),
            'b': Variable('b', {4, 5}),
            'C': Variable('C', {3},
                constraints: [ExpressionConstraint(r'$lte(60-A +b -B +c)')]),
            'c': Variable('c', {17, 18, 19, 20, 21, 22, 23, 24, 25}),
          });
      // final evaluator = Evaluator(puzzle);
      // final expression = Parser(r'$lte(60-A +b -B +c)').parse();
      // final result = evaluator.evaluate(expression, [], min: 10, max: 100);
      // expect(result, equals({1, 2, 3, 4, 5}));
      final solver = Solver(puzzle, traceSolve: true, allowBacktracking: false);
      puzzle.variables['A']!.answer = 14;
      puzzle.variables['b']!.answer = 4;
      puzzle.variables['B']!.answer = 26;
      puzzle.variables['c']!.answer = 17;
      solver.solve();
      print('result');
    });

    test(r'$factor 50', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser(r'$factor 50').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 1, max: 100);
      expect(result, equals([2, 5, 10, 25]));
    });

    test(r'$factor $lt 50', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser(r'$factor $lt 50').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 1, max: 100);
      expect(
          result,
          equals([
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
            24
          ]));
    });
  });
}
