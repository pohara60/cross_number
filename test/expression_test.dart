import 'package:crossnumber/generators.dart';
import 'package:crossnumber/monadic.dart';

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
  group('Scanner Enhancements', () {
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
  });
  group('Generator Enhancements', () {
    var text1 = '#prime';
    test(text1, () {
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
    var text2 = '#triangular';
    test(text2, () {
      var primes = generateTriangles(1, 9).toList();
      expect(primes, equals([1, 3, 6]));
      primes = generateTriangles(10, 99).toList();
      expect(primes, equals([10, 15, 21, 28, 36, 45, 55, 66, 78, 91]));
      primes = generateTriangles(80, 110).toList();
      expect(primes, equals([91, 105]));
    });
    var text3 = '#pyramidal';
    test(text3, () {
      var primes = generateSquarePyramidals(1, 9).toList();
      expect(primes, equals([1, 5]));
      primes = generateSquarePyramidals(10, 99).toList();
      expect(primes, equals([14, 30, 55, 91]));
      primes = generateSquarePyramidals(80, 110).toList();
      expect(primes, equals([91]));
    });
    var text4 = '#square';
    test(text4, () {
      var primes = generateSquares(1, 9).toList();
      expect(primes, equals([1, 4, 9]));
      primes = generateSquares(10, 99).toList();
      expect(primes, equals([16, 25, 36, 49, 64, 81]));
      primes = generateSquares(80, 110).toList();
      expect(primes, equals([81, 100]));
    });
    var text5 = '#cube';
    test(text5, () {
      var primes = generateCubes(1, 9).toList();
      expect(primes, equals([1, 8]));
      primes = generateCubes(10, 99).toList();
      expect(primes, equals([27, 64]));
      primes = generateCubes(80, 110).toList();
      expect(primes, equals([]));
    });
    var text6 = '#power';
    test(text6, () {
      var primes = generatePowers(1, 9).toList();
      expect(primes, equals([1, 2, 4, 8, 9]));
      primes = generatePowers(10, 99).toList();
      expect(primes, equals([16, 25, 27, 32, 36, 49, 64, 81]));
      primes = generatePowers(80, 110).toList();
      expect(primes, equals([81, 100]));
    });
    var text7 = '#product2primes';
    test(text7, () {
      var primes = generateProduct2Primes(1, 9).toList();
      expect(primes, equals([6]));
      primes = generateProduct2Primes(10, 40).toList();
      expect(primes, equals([10, 14, 15, 21, 22, 26, 33, 34, 35, 38, 39]));
    });
    var text8 = '#product3primes';
    test(text8, () {
      var primes = generateProduct3Primes(1, 9).toList();
      expect(primes, equals([]));
      primes = generateProduct3Primes(10, 40).toList();
      expect(primes, equals([30]));
      primes = generateProduct3Primes(10, 99).toList();
      expect(primes, equals([30, 42, 66, 70, 78]));
    });
    var text9 = '#sumConsecutiveSquares';
    test(text9, () {
      var primes = generateSumConsecutiveSquares(1, 9).toList();
      expect(primes, equals([5]));
      primes = generateSumConsecutiveSquares(10, 40).toList();
      expect(primes, equals([13, 25]));
      primes = generateSumConsecutiveSquares(10, 99).toList();
      expect(primes, equals([13, 25, 41, 61, 85]));
    });
  });
  group('Monadic Enhancements', () {
    var text1 = '#jumble';
    test(text1, () {
      var values = jumble(123).toList();
      expect(values, equals([123, 132, 213, 231, 312, 321]));
    });
  });
  group('Expression Enhancements', () {
    var text3 = r'41 + #prime + 40';
    test(text3, () {
      var exp = ExpressionEvaluator(text3);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.ASCENDING));
      expect(
          exp.generate(10, 99).toList(), equals([83, 84, 86, 88, 92, 94, 98]));
    });
    var text4 = r'#prime - 20';
    test(text4, () {
      var exp = ExpressionEvaluator(text4);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.ASCENDING));
      expect(exp.generate(10, 29).toList(), equals([11, 17, 21, 23, 27]));
    });
    var text5 = r'111 - #prime + 40';
    test(text5, () {
      var exp = ExpressionEvaluator(text5);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.DESCENDING));
      expect(
          exp.generate(80, 99).toList(),
          equals([
            98,
            92,
            90,
            84,
            80,
          ]));
    });
    var text6 = r'2 * #prime';
    test(text6, () {
      var exp = ExpressionEvaluator(text6);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.ASCENDING));
      expect(exp.generate(10, 29).toList(), equals([10, 14, 22, 26]));
    });
    var text7 = r'(#prime+1) / 3';
    test(text7, () {
      var exp = ExpressionEvaluator(text7);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.ASCENDING));
      expect(exp.generate(10, 19).toList(), equals([10, 14, 16, 18]));
    });
    var text8 = r'330 / #prime';
    test(text8, () {
      var exp = ExpressionEvaluator(text8);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.DESCENDING));
      expect(exp.generate(10, 150).toList(), equals([110, 66, 30]));
    });
    var text9 = r'#integer !';
    test(text9, () {
      var exp = ExpressionEvaluator(text9);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.ASCENDING));
      expect(exp.generate(10, 150).toList(), equals([24, 120]));
    });
    var text10 = r'√ #integer';
    test(text10, () {
      var exp = ExpressionEvaluator(text10);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.ASCENDING));
      expect(exp.generate(10, 12).toList(), equals([10, 11, 12]));
    });
    var text11 = r'#integer ^ 2';
    test(text11, () {
      var exp = ExpressionEvaluator(text11);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.ASCENDING));
      expect(exp.generate(10, 49).toList(), equals([16, 25, 36, 49]));
    });
    var text12 = r'2 ^ #integer';
    test(text12, () {
      var exp = ExpressionEvaluator(text12);
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILD));
      expect(exp.tree!.order, equals(NodeOrder.ASCENDING));
      expect(exp.generate(10, 99).toList(), equals([16, 32, 64]));
    });
    var text13 = r'#prime = #integer';
    test(text13, () {
      var exp = ExpressionEvaluator(text13);
      expect(exp.generate(10, 19).toList(), equals([11, 13, 17, 19]));
    });
    var text14 = r'$square #integer';
    test(text14, () {
      var exp = ExpressionEvaluator(text14);
      expect(exp.generate(10, 49).toList(), equals([16, 25, 36, 49]));
    });
    var text15 = r'$even #integer';
    test(text15, () {
      var exp = ExpressionEvaluator(text15);
      expect(exp.generate(10, 19).toList(), equals([10, 12, 14, 16, 18]));
    });
    var text16 = r'$even 12';
    test(text16, () {
      var exp = ExpressionEvaluator(text16);
      expect(() => exp.generate(10, 19), throwsException);
    });
    var text17 = r'$multiple #prime';
    test(text17, () {
      var exp = ExpressionEvaluator(text17);
      // Note unknown order and duplicates due to nested generators
      expect(exp.tree!.complexity, equals(NodeComplexity.GENERATOR_CHILDREN));
      expect(exp.tree!.order, equals(NodeOrder.UNKNOWN));
      expect(exp.generate(10, 19).toList(),
          equals([10, 12, 14, 16, 18, 12, 15, 18, 10, 15, 14]));
    });
  });
  group('Performance', () {
    var text1 = '#product3primes';
    test(text1, () {
      final stopwatch = Stopwatch()..start();
      for (var prime in generateProduct3Primes(10000, 99999)
          .skipWhile((value) => value < 100000)) {
        print('Next prime $prime');
      }
      print('#product3primes 99999 elapsed ${stopwatch.elapsed}');
      // expect(primes, equals([]));
    });
  });
}
