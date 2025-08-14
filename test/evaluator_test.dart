import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:test/test.dart';
import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/expressions/expression.dart';
import 'package:crossnumber/src/expressions/parser.dart';

void main() {
  group('Evaluator', () {
    test('should evaluate a negative expression', () {
      expectExpression('-15', -99, 99, -15);
      expectExpression('-15 + 11*9', 10, 99, 84);
      expectExpression('-15 + 11*9 - 10', 10, 99, 74);
    });

    test('should evaluate a complex expression', () {
      expectExpression('6/2', 1, 9, 3);
      expectExpression('( 6/2 )*13', 10, 99, 39);
      expectExpression('( 6/2 )*13 - 10', 10, 99, 29);
      expectExpression('9*(( 6/2 )*13 - 10 )', 100, 999, 261);
      expectExpression('9*(( 6/2 )*13 - 10 ) - 2*15', 100, 999, 231);
    });
  });
}

void expectExpression(String text, int min, int max, int result) {
  final puzzle = PuzzleDefinition(
      name: 'test', grids: {}, entries: {}, clues: {}, variables: {});
  final parser = Parser(text);
  final expression = parser.parse();
  final evaluator = Evaluator(puzzle);
  final evaluatedResult = evaluator.evaluate(expression, min: min, max: max);
  expect(evaluatedResult.single, result);
}
