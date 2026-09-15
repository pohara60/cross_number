import 'package:test/test.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/expressions/expression.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/variable.dart';

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
    test('should parse exponent expression', () {
      final parser = Parser('2 ^ 3');
      final expression = parser.parse();

      expect(expression, isA<BinaryExpression>());
      final binaryExpression = expression as BinaryExpression;
      expect(binaryExpression.left, isA<NumberExpression>());
      expect((binaryExpression.left as NumberExpression).value, 2);
      expect(binaryExpression.operator.type, TokenType.EXPONENT);
      expect(binaryExpression.right, isA<NumberExpression>());
      expect((binaryExpression.right as NumberExpression).value, 3);
    });

    test('should parse NOT as a unary operator', () {
      final expression = Parser('NOT #prime').parse() as UnaryExpression;

      expect(expression.operator.type, TokenType.NOT);
      expect(expression.right, isA<GeneratorExpression>());
      expect(expression.toString(), '(NOT#prime)');
    });

    test('should parse modulus with multiplicative precedence', () {
      final expression = Parser('10 + 8 % 3 * 2').parse() as BinaryExpression;

      expect(expression.operator.type, TokenType.PLUS);
      final right = expression.right as BinaryExpression;
      expect(right.operator.type, TokenType.STAR);
      expect((right.left as BinaryExpression).operator.type, TokenType.MODULUS);
    });

    test('should parse IF as a reserved token', () {
      final parser = Parser('10 IF 1 = 1');
      final tokens = parser.scanTokens();

      expect(tokens.map((token) => token.type), [
        TokenType.NUMBER,
        TokenType.IF,
        TokenType.NUMBER,
        TokenType.EQUAL,
        TokenType.NUMBER,
        TokenType.EOF,
      ]);

      final expression = parser.parse();
      expect(expression, isA<IfExpression>());
      final ifExpression = expression as IfExpression;
      expect(ifExpression.value, isA<NumberExpression>());
      expect(ifExpression.condition, isA<BinaryExpression>());
    });

    test('should parse IF with low precedence and right associativity', () {
      final expression = Parser('A + 1 IF B > 2').parse() as IfExpression;
      expect(expression.value, isA<BinaryExpression>());
      expect(expression.condition, isA<BinaryExpression>());

      final chained = Parser('A IF B IF C').parse() as IfExpression;
      expect(chained.value, isA<VariableExpression>());
      expect(chained.condition, isA<IfExpression>());
    });

    test('should leave lowercase if as an identifier', () {
      final tokens = Parser('if').scanTokens();
      expect(tokens.first.type, TokenType.IDENTIFIER);
    });

    test('should resolve self-reference to a variable', () {
      final expression = Parser('@ IF 1 = 1', currentExpressableId: 'A').parse() as IfExpression;

      expect(expression.value, isA<VariableExpression>());
      expect((expression.value as VariableExpression).name, 'A');
      expect(expression.toString(), '(A IF (1=1))');
    });

    test('should resolve a grid self-reference', () {
      final expression = Parser('@', currentExpressableId: 'left.A1').parse();

      expect(expression, isA<GridReferenceExpression>());
      expect((expression as GridReferenceExpression).gridReferenceId, 'left.A1');
    });

    test('should reject self-reference without an owner', () {
      expect(() => Parser('@').parse(), throwsA(isA<ParseException>()));
    });

    test('should resolve a reused constraint for each expressable', () {
      final constraint = ExpressionConstraint('@');
      final first = Variable('A', {1});
      final second = Variable('B', {2});

      expect(first.addExpression(constraint), isTrue);
      expect(second.addExpression(constraint), isTrue);

      expect(first.expressionTrees.single, isA<VariableExpression>());
      expect((first.expressionTrees.single as VariableExpression).name, 'A');
      expect(first.variableLists.single, ['A']);
      expect(second.expressionTrees.single, isA<VariableExpression>());
      expect((second.expressionTrees.single as VariableExpression).name, 'B');
      expect(second.variableLists.single, ['B']);
      expect(constraint.expressionTreeOwnerId, 'B');
    });
  });
}
