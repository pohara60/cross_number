import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:test/test.dart';
import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/expressions/parser.dart';

void main() {
  group('Evaluator', () {
    test('should evaluate a negative expression', () {
      expectExpression('-15', [], -99, 99, -15);
      expectExpression('-15 + 11*9', [], 10, 99, 84);
      expectExpression('-15 + 11*9 - 10', [], 10, 99, 74);
    });

    test('should evaluate a complex expression', () {
      expectExpression('6/2', [], 1, 9, 3);
      expectExpression('( 6/2 )*13', [], 10, 99, 39);
      expectExpression('( 6/2 )*13 - 10', [], 10, 99, 29);
      expectExpression('9*(( 6/2 )*13 - 10 )', [], 100, 999, 261);
      expectExpression('9*(( 6/2 )*13 - 10 ) - 2*15', [], 100, 999, 231);
    });

    test('should handle intermediate non-integer results', () {
      expectExpression('(3/2)*2', [], 1, 9, 3);
      expectExpression('9^(3/2)', [], 20, 30, 27);
    });

    test('should return empty for non-integer final results', () {
      expectExpression('3/2', [], 1, 9, null);
    });

    test('should handle variables with intermediate non-integer results', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {
          'A': Variable('A', {3, 4, 5}),
        },
      );
      final parser = Parser('(A/2)*4');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final evaluatedResult =
          evaluator.evaluateExpression(expression, ['A'], min: 1, max: 20);
      // For A=3, (3/2)*4 = 6
      // For A=4, (4/2)*4 = 8
      // For A=5, (5/2)*4 = 10
      expect(evaluatedResult.map((r) => r.value), unorderedEquals([6, 8, 10]));
      expect(evaluatedResult.map((r) => r.variableValues['A']),
          unorderedEquals([3, 4, 5]));
    });

    test('Equality Operator', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {},
      );
      final parser = Parser('1+2 = 3+0');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final evaluatedResult =
          evaluator.evaluateExpression(expression, [], min: 1, max: 20);
      expect(evaluatedResult.map((r) => r.value), equals({3}));
    });

    test('Logical AND Operator', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {
          'A': Variable('A', {1, 2, 3}),
          'B': Variable('B', {2, 3, 4}),
        },
      );
      final parser = Parser(r'$isEven A & $isOdd B');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final evaluatedResult =
          evaluator.evaluateExpression(expression, ['A', 'B'], min: 1, max: 20);
      expect(evaluatedResult.map((r) => r.value), unorderedEquals([2]));
    });

    test('Reverse Operator', () {
      expectExpression("'123", [], 1, 999, 321);
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {
          'A': Variable('A', {12, 345}),
        },
      );
      final parser = Parser("'A");
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final evaluatedResult =
          evaluator.evaluateExpression(expression, ['A'], min: 1, max: 999);
      expect(evaluatedResult.map((r) => r.value), unorderedEquals([21, 543]));
    });
  });

  group('Relational Operators', () {
    test('Less Than Operator', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {},
      );
      var parser = Parser('2 < 3');
      var expression = parser.parse();
      var evaluator = Evaluator(puzzle);
      var evaluatedResult =
          evaluator.evaluateExpression(expression, [], min: 1, max: 20);
      expect(evaluatedResult.map((r) => r.value), equals({2}));

      parser = Parser('3 < 2');
      expression = parser.parse();
      evaluator = Evaluator(puzzle);
      evaluatedResult =
          evaluator.evaluateExpression(expression, [], min: 1, max: 20);
      expect(evaluatedResult.map((r) => r.value), isEmpty);
    });

    test('Greater Than Operator', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {},
      );
      var parser = Parser('3 > 2');
      var expression = parser.parse();
      var evaluator = Evaluator(puzzle);
      var evaluatedResult =
          evaluator.evaluateExpression(expression, [], min: 1, max: 20);
      expect(evaluatedResult.map((r) => r.value), equals({3}));

      parser = Parser('2 > 3');
      expression = parser.parse();
      evaluator = Evaluator(puzzle);
      evaluatedResult =
          evaluator.evaluateExpression(expression, [], min: 1, max: 20);
      expect(evaluatedResult.map((r) => r.value), isEmpty);
    });

    test('Less Than with variables', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {
          'A': Variable('A', {1, 2, 3}),
          'B': Variable('B', {2, 3, 4}),
        },
      );
      final parser = Parser('A < B');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final evaluatedResult =
          evaluator.evaluateExpression(expression, ['A', 'B'], min: 1, max: 20);
      // A=1, B=2,3,4 -> 1
      // A=2, B=3,4 -> 2
      // A=3, B=4 -> 3
      expect(evaluatedResult.map((r) => r.value).toSet(),
          unorderedEquals({1, 2, 3}));
      expect(
          evaluatedResult
              .where((r) => r.value == 1)
              .map((r) => r.variableValues),
          unorderedEquals([
            {'A': 1, 'B': 2},
            {'A': 1, 'B': 3},
            {'A': 1, 'B': 4},
          ]));
      expect(
          evaluatedResult
              .where((r) => r.value == 2)
              .map((r) => r.variableValues),
          unorderedEquals([
            {'A': 2, 'B': 3},
            {'A': 2, 'B': 4},
          ]));
      expect(
          evaluatedResult
              .where((r) => r.value == 3)
              .map((r) => r.variableValues),
          unorderedEquals([
            {'A': 3, 'B': 4},
          ]));
    });

    test('Greater Than with variables', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {
          'A': Variable('A', {1, 2, 3}),
          'B': Variable('B', {2, 3, 4}),
        },
      );
      final parser = Parser('B > A');
      final expression = parser.parse();
      final evaluator = Evaluator(puzzle);
      final evaluatedResult =
          evaluator.evaluateExpression(expression, ['A', 'B'], min: 1, max: 20);
      // B=2, A=1 -> 2
      // B=3, A=1,2 -> 3
      // B=4, A=1,2,3 -> 4
      expect(evaluatedResult.map((r) => r.value).toSet(),
          unorderedEquals([2, 3, 4]));
      expect(
          evaluatedResult
              .where((r) => r.value == 2)
              .map((r) => r.variableValues),
          unorderedEquals([
            {'A': 1, 'B': 2},
          ]));
      expect(
          evaluatedResult
              .where((r) => r.value == 3)
              .map((r) => r.variableValues),
          unorderedEquals([
            {'A': 1, 'B': 3},
            {'A': 2, 'B': 3},
          ]));
      expect(
          evaluatedResult
              .where((r) => r.value == 4)
              .map((r) => r.variableValues),
          unorderedEquals([
            {'A': 1, 'B': 4},
            {'A': 2, 'B': 4},
            {'A': 3, 'B': 4},
          ]));
    });
  });
}

void expectExpression(
    String text, List<String> variables, int min, int max, int? result) {
  final puzzle = PuzzleDefinition(
      name: 'test', grids: {}, entries: {}, clues: {}, variables: {});
  final parser = Parser(text);
  final expression = parser.parse();
  final evaluator = Evaluator(puzzle);
  final evaluatedResult = evaluator
      .evaluateExpressionNoVariables(expression, variables, min: min, max: max);
  if (result == null) {
    expect(evaluatedResult, isEmpty);
  } else {
    expect(evaluatedResult.single, result);
  }
}
