import 'package:crossnumber/generators.dart';

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
      var tokens = Scanner.generateTokens(text).toList();
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
  group('Enhancements', () {
    void expectToken(Token token, String name, String type) {
      expect(token.name, equals(name));
      expect(token.type, equals(type));
    }

    var text = r'$DS #prime A1 d23 CD';
    test(text, () {
      var tokens = Scanner.generateTokens(text).toList();
      expectToken(tokens[0]!, 'DS', 'MONADIC');
      expectToken(tokens[1]!, 'prime', 'GENERATOR');
      expectToken(tokens[2]!, 'A1', 'CLUE');
      expectToken(tokens[3]!, 'D23', 'CLUE');
      expectToken(tokens[4]!, 'C', 'VAR');
      expectToken(tokens[5]!, 'D', 'VAR');
    });

    var text2 = '#prime';
    test(text2, () {
      // var exp = ExpressionEvaluator(text2);
      // expect(exp.evaluate(), equals(2));
      // expect(exp.evaluate(), equals(3));
      // expect(exp.evaluate(), equals(5));
      // expect(exp.evaluate(), equals(7));
      var primes = generatePrimes(1, 9).toList();
      expect(primes, equals([2, 3, 5, 7]));

      primes = generatePrimes(10, 99).toList();
      expect(
          primes,
          equals([
            11,
            13,
            17,
            19,
            23,
            29,
            31,
            37,
            41,
            43,
            47,
            53,
            59,
            61,
            67,
            71,
            73,
            79,
            83,
            89,
            97
          ]));
      primes = generatePrimes(80, 110).toList();
      expect(
          primes,
          equals([
            83,
            89,
            97,
            101,
            103,
            107,
            109,
          ]));
    });
    var text3 = r'$DS #prime';
    test(text3, () {
      var exp = ExpressionEvaluator(text3);
      //Does not return 4 values because range check applies to DS as well as Prime!
      //expect(exp.generate(10, 19).toList(), equals([2, 4, 8, 10]));
      expect(exp.generate(10, 19).toList(), equals([10]));
    });
  });
}
