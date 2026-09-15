import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:test/test.dart';
import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';

void main() {
  group('Evaluator', () {
    test('should evaluate a negative expression', () {
      expectExpression('-15', [], -99, 99, -15);
      expectExpression('-15 + 11*9', [], 10, 99, 84);
      expectExpression('-15 + 11*9 - 10', [], 10, 99, 74);
    });

    test('should evaluate NOT as the bounded complement of its operand', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {},
      );

      final results = Evaluator(puzzle).evaluateExpressionNoVariables(Parser('NOT 11').parse(), [], min: 10, max: 12);
      expect(results, unorderedEquals([10, 12]));
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

    test('should evaluate modulus', () {
      expectExpression('17 % 5', [], 1, 20, 2);
      expectExpression('0 % 5', [], -20, 20, 0);
      expectExpression('-17 % 5', [], -20, 20, 3);
      expectExpression('17 % -5', [], -20, 20, 2);
      expectExpression('17 % 0', [], 1, 20, null);
      expectExpression('10 + 8 % 3 * 2', [], 1, 20, 14);
      expectExpression('17711 % 4', [], 1, 99999, 3);
      expectExpression('17711 % 4 IF 17711 % 4 = 3', [], 1, 99999, 3);
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
      final evaluatedResult = evaluator.evaluateExpression(expression, ['A'], min: 1, max: 20);
      // For A=3, (3/2)*4 = 6
      // For A=4, (4/2)*4 = 8
      // For A=5, (5/2)*4 = 10
      expect(evaluatedResult.map((r) => r.value), unorderedEquals([6, 8, 10]));
      expect(evaluatedResult.map((r) => r.variableValues['A']), unorderedEquals([3, 4, 5]));
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
      final evaluatedResult = evaluator.evaluateExpression(expression, [], min: 1, max: 20);
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
      final evaluatedResult = evaluator.evaluateExpression(expression, ['A', 'B'], min: 1, max: 20);
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
      final evaluatedResult = evaluator.evaluateExpression(expression, ['A'], min: 1, max: 999);
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
      var evaluatedResult = evaluator.evaluateExpression(expression, [], min: 1, max: 20);
      expect(evaluatedResult.map((r) => r.value), equals({2}));

      parser = Parser('3 < 2');
      expression = parser.parse();
      evaluator = Evaluator(puzzle);
      evaluatedResult = evaluator.evaluateExpression(expression, [], min: 1, max: 20);
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
      var evaluatedResult = evaluator.evaluateExpression(expression, [], min: 1, max: 20);
      expect(evaluatedResult.map((r) => r.value), equals({3}));

      parser = Parser('2 > 3');
      expression = parser.parse();
      evaluator = Evaluator(puzzle);
      evaluatedResult = evaluator.evaluateExpression(expression, [], min: 1, max: 20);
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
      final evaluatedResult = evaluator.evaluateExpression(expression, ['A', 'B'], min: 1, max: 20);
      // A=1, B=2,3,4 -> 1
      // A=2, B=3,4 -> 2
      // A=3, B=4 -> 3
      expect(evaluatedResult.map((r) => r.value).toSet(), unorderedEquals({1, 2, 3}));
      expect(
          evaluatedResult.where((r) => r.value == 1).map((r) => r.variableValues),
          unorderedEquals([
            {'A': 1, 'B': 2},
            {'A': 1, 'B': 3},
            {'A': 1, 'B': 4},
          ]));
      expect(
          evaluatedResult.where((r) => r.value == 2).map((r) => r.variableValues),
          unorderedEquals([
            {'A': 2, 'B': 3},
            {'A': 2, 'B': 4},
          ]));
      expect(
          evaluatedResult.where((r) => r.value == 3).map((r) => r.variableValues),
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
      final evaluatedResult = evaluator.evaluateExpression(expression, ['A', 'B'], min: 1, max: 20);
      // B=2, A=1 -> 2
      // B=3, A=1,2 -> 3
      // B=4, A=1,2,3 -> 4
      expect(evaluatedResult.map((r) => r.value).toSet(), unorderedEquals([2, 3, 4]));
      expect(
          evaluatedResult.where((r) => r.value == 2).map((r) => r.variableValues),
          unorderedEquals([
            {'A': 1, 'B': 2},
          ]));
      expect(
          evaluatedResult.where((r) => r.value == 3).map((r) => r.variableValues),
          unorderedEquals([
            {'A': 1, 'B': 3},
            {'A': 2, 'B': 3},
          ]));
      expect(
          evaluatedResult.where((r) => r.value == 4).map((r) => r.variableValues),
          unorderedEquals([
            {'A': 1, 'B': 4},
            {'A': 2, 'B': 4},
            {'A': 3, 'B': 4},
          ]));
    });
  });
  group('IF', () {
    test('IF returns the value only when the condition has a result', () {
      expectExpression('10 IF 1 = 1', [], 1, 20, 10);
      expectExpression('10 IF 1 = 2', [], 1, 20, null);
      expectExpression('10 IF 7', [], 1, 20, 10);
    });

    test('IF filters variable values and retains condition bindings', () {
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
      final evaluator = Evaluator(puzzle);

      final filtered = evaluator.evaluateExpression(Parser('A IF A > 2').parse(), ['A'], min: 1, max: 20);
      expect(filtered.map((result) => result.value), equals([3]));
      expect(filtered.single.variableValues, {'A': 3});

      final compatible = evaluator.evaluateExpression(Parser('A IF B > A').parse(), ['A', 'B'], min: 1, max: 20);
      expect(
          compatible.map((result) => result.variableValues),
          unorderedEquals([
            {'A': 1, 'B': 2},
            {'A': 1, 'B': 3},
            {'A': 1, 'B': 4},
            {'A': 2, 'B': 3},
            {'A': 2, 'B': 4},
            {'A': 3, 'B': 4},
          ]));
    });

    test('IF with result', () {
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {
          'A': Variable('A', {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}),
        },
      );
      final evaluator = Evaluator(puzzle);

      final filtered =
          evaluator.evaluateExpression(Parser(r'A IF $isOdd $digitproduct A').parse(), ['A'], min: 1, max: 20);
      expect(filtered.map((result) => result.value), equals([1, 3, 5, 7, 9, 11, 13, 15, 17, 19]));
      expect(
          filtered.map((result) => result.variableValues),
          unorderedEquals([
            {'A': 1},
            {'A': 3},
            {'A': 5},
            {'A': 7},
            {'A': 9},
            {'A': 11},
            {'A': 13},
            {'A': 15},
            {'A': 17},
            {'A': 19},
          ]));
    });

    test('self-reference is resolved in an expressable constraint', () {
      final variable = Variable('A', {1, 2, 3, 4, 5, 6, 7, 8, 9, 10});
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {},
        variables: {'A': variable},
      );
      final constraint = ExpressionConstraint(r'@ IF $isOdd $digitproduct @');

      expect(variable.addExpression(constraint), isTrue);
      final results = Evaluator(puzzle).evaluate(variable, min: 1, max: 10);

      expect(results.map((result) => result.value), unorderedEquals([1, 3, 5, 7, 9]));
      expect(results.every((result) => result.variableValues['A'] == result.value), isTrue);
    });

    test('reuses correlated assignments between expressions', () {
      final variableA = Variable('A', {1, 2, 3});
      final variableB = Variable('B', {1, 2, 3});
      final clue = Clue('C', [
        ExpressionConstraint('A * 10 + B'),
        ExpressionConstraint('A * 10 + B IF A + B = 4'),
      ]);
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {'C': clue},
        variables: {'A': variableA, 'B': variableB},
      );

      final optimized = Evaluator(puzzle).evaluate(clue, min: 1, max: 99);
      final first =
          Evaluator(puzzle).evaluateExpression(clue.expressionTrees[0], clue.variableLists[0], min: 1, max: 99);
      final second =
          Evaluator(puzzle).evaluateExpression(clue.expressionTrees[1], clue.variableLists[1], min: 1, max: 99);
      final unoptimized = resultsIntersection(first, second);

      expect(optimized.map((result) => result.value), unorderedEquals([13, 31]));
      expect(
        optimized.map((result) => result.variableValues),
        unorderedEquals(unoptimized.map((result) => result.variableValues)),
      );
    });

    test('uses earlier values for a later self-reference', () {
      final variable = Variable('A', {1, 2, 3});
      final clue = Clue('C', [
        ExpressionConstraint('A'),
        ExpressionConstraint('@ IF @ = 2'),
      ]);
      final puzzle = PuzzleDefinition(
        name: 'test',
        grids: {},
        entries: {},
        clues: {'C': clue},
        variables: {'A': variable},
      );

      final results = Evaluator(puzzle).evaluate(clue, min: 1, max: 3);

      expect(results.map((result) => result.value), equals([2]));
      expect(results.single.variableValues, {'A': 2, 'C': 2});
    });

    test('restricts the first self-reference from previous results', () {
      final clue = Clue('C', [ExpressionConstraint('@ IF @ % 2 = 0')]);
      final puzzle = PuzzleDefinition(name: 'test', grids: {}, entries: {}, clues: {'C': clue}, variables: {});

      final results = Evaluator(puzzle).evaluate(clue, min: 1, max: 4, previousResults: {2, 3, 4});

      expect(results.map((result) => result.value), unorderedEquals([2, 4]));
    });

    test('restricts NOT to known self values', () {
      final clue = Clue('C', [ExpressionConstraint('NOT (@ IF @ = 2)')]);
      final puzzle = PuzzleDefinition(name: 'test', grids: {}, entries: {}, clues: {'C': clue}, variables: {});

      final results = Evaluator(puzzle).evaluate(clue, min: 1, max: 4, previousResults: {2, 3, 4});

      expect(results.map((result) => result.value), unorderedEquals([3, 4]));
    });
  });
}

void expectExpression(String text, List<String> variables, int min, int max, int? result) {
  final puzzle = PuzzleDefinition(name: 'test', grids: {}, entries: {}, clues: {}, variables: {});
  final parser = Parser(text);
  final expression = parser.parse();
  final evaluator = Evaluator(puzzle);
  final evaluatedResult = evaluator.evaluateExpressionNoVariables(expression, variables, min: min, max: max);
  if (result == null) {
    expect(evaluatedResult, isEmpty);
  } else {
    expect(evaluatedResult.single, result);
  }
}
