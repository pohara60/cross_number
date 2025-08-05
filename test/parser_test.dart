import 'package:test/test.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/expressions/expression.dart';

void main() {
  group('Parser', () {
    test('should parse a simple expression', () {
      final parser = Parser('1 + 2 * 3');
      final expression = parser.parse();

      expect(expression, isA<BinaryExpression>());
      final binaryExpression = expression as BinaryExpression;
      expect(binaryExpression.left, isA<NumberExpression>());
      expect((binaryExpression.left as NumberExpression).value, 1);
      expect(binaryExpression.operator.type, TokenType.PLUS);
      expect(binaryExpression.right, isA<BinaryExpression>());

      final rightBinaryExpression = binaryExpression.right as BinaryExpression;
      expect(rightBinaryExpression.left, isA<NumberExpression>());
      expect((rightBinaryExpression.left as NumberExpression).value, 2);
      expect(rightBinaryExpression.operator.type, TokenType.STAR);
      expect(rightBinaryExpression.right, isA<NumberExpression>());
      expect((rightBinaryExpression.right as NumberExpression).value, 3);
    });
  });
}
