// ignore_for_file: unused_import

import 'package:crossnumber/src/expressions/expression.dart';
import 'package:crossnumber/src/expressions/monadic.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

void main() {
  group('Monadic functions', () {
    test('should evaluate multiple', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser(r'$multiple 7').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 10, max: 30);
      expect(result, equals([14, 21, 28]));
    });

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

    test(r'$power 3', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser(r'$power 3').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 10, max: 100);
      expect(result, equals([16, 27, 32, 64, 81]));
    });

    test(r'$digitsum', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser(r'$digitsum #prime').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 1, max: 11)
        ..sort();
      expect(result, equals([2, 3, 4, 5, 7, 8, 10, 11]));
    });

    test(r'$digitproduct', () {
      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression = Parser(r'$digitproduct #prime').parse();
      final result = evaluator.evaluateExpressionNoVariables(expression, [],
          min: 1, max: 11)
        ..sort();
      expect(result, equals([1, 2, 3, 4, 5, 6, 7, 9]));
    });

    test(r'$jumble', () {
      var monadicFunctionRegistry = MonadicFunctionRegistry();
      var jumble = monadicFunctionRegistry.get('jumble')!;
      var result1 = jumble([123, 789]);
      expect(
          result1, equals([132, 213, 231, 312, 321, 798, 879, 897, 978, 987]));

      final puzzle = PuzzleDefinition(
          name: 'Test', grids: {}, entries: {}, clues: {}, variables: {});
      final evaluator = Evaluator(puzzle);
      final expression2 = Parser(r'$jumble 123').parse();
      final result2 = evaluator.evaluateExpressionNoVariables(expression2, [],
          min: 100, max: 999)
        ..sort();
      expect(result2, equals([132, 213, 231, 312, 321]));
      final expression3 = Parser(r'$jumble 789').parse();
      final result3 = evaluator.evaluateExpressionNoVariables(expression3, [],
          min: 100, max: 999)
        ..sort();
      expect(result3, equals([798, 879, 897, 978, 987]));
    });
  });
}
