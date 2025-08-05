import 'package:test/test.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/expressions/expression.dart';

void main() {
  group('Scanner', () {
    test('should scan a simple expression', () {
      final parser = Parser('1 + 2');
      final tokens = parser.scanTokens();
      expect(tokens.map((t) => t.type), [
        TokenType.NUMBER,
        TokenType.PLUS,
        TokenType.NUMBER,
        TokenType.EOF,
      ]);
      expect(tokens[0].literal, 1);
      expect(tokens[2].literal, 2);
    });

    test('should scan an expression with variables', () {
      final parser = Parser('A * B - C');
      final tokens = parser.scanTokens();
      expect(tokens.map((t) => t.type), [
        TokenType.IDENTIFIER,
        TokenType.STAR,
        TokenType.IDENTIFIER,
        TokenType.MINUS,
        TokenType.IDENTIFIER,
        TokenType.EOF,
      ]);
      expect(tokens[0].lexeme, 'A');
      expect(tokens[2].lexeme, 'B');
      expect(tokens[4].lexeme, 'C');
    });

    test('should scan an expression with parentheses', () {
      final parser = Parser('(1 + A) / 2');
      final tokens = parser.scanTokens();
      expect(tokens.map((t) => t.type), [
        TokenType.LEFT_PAREN,
        TokenType.NUMBER,
        TokenType.PLUS,
        TokenType.IDENTIFIER,
        TokenType.RIGHT_PAREN,
        TokenType.SLASH,
        TokenType.NUMBER,
        TokenType.EOF,
      ]);
    });
  });
}
