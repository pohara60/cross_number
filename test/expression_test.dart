import '../lib/expression.dart';
import 'package:test/test.dart';

void main() {
  group('Original tests', () {
    void expectToken(Token token, String name, String type) {
      expect(token.name, equals(name));
      expect(token.type, equals(type));
    }

    var text = 'S+I*G/M-a';
    test(text, () {
      // for (var token in generateTokens(text)) {
      //   print('$token');
      // }
      var tokens = generateTokens(text).toList();
      expectToken(tokens[0]!, 'S', 'VAR');
      expectToken(tokens[1]!, '', 'PLUS');
      expectToken(tokens[2]!, 'I', 'VAR');
      expectToken(tokens[3]!, '', 'TIMES');
      expectToken(tokens[4]!, 'G', 'VAR');
      expectToken(tokens[5]!, '', 'DIVIDE');
      expectToken(tokens[6]!, 'M', 'VAR');
      expectToken(tokens[7]!, '', 'MINUS');
      expectToken(tokens[8]!, 'a', 'VAR');
    });
    var text2 = '5+4*3/2-1';
    test(text2, () {
      var exp = ExpressionEvaluator(text2);
      var value = exp.evaluate(['S', 'I', 'G', 'M', 'a'], [5, 4, 3, 2, 1]);
      expect(value, equals(10));
    });
  });
  group('Integer tests', () {
    var text3 = '3/2';
    test(text3, () {
      var exp = ExpressionEvaluator(text3);
      expect(() => exp.evaluate(), throwsA(TypeMatcher<ExpressionInvalid>()));
    });
    var text4 = '3/2*2';
    test(text4, () {
      var exp = ExpressionEvaluator(text4);
      var value = exp.evaluate();
      expect(value, equals(3));
    });
    var text5 = '(3/2)!';
    test(text5, () {
      var exp = ExpressionEvaluator(text5);
      expect(() => exp.evaluate(), throwsA(TypeMatcher<ExpressionInvalid>()));
    });
    var text6 = '(3/2*2)!';
    test(text6, () {
      var exp = ExpressionEvaluator(text6);
      var value = exp.evaluate();
      expect(value, equals(6));
    });
  });
}
