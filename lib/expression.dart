// Evaluate expression strings, with variable references

// Token specification
import 'dart:math';

import 'generators.dart';
import 'monadic.dart';

var NUM = r'(?<NUM>\d+)';
var PLUS = r'(?<PLUS>\+)';
var MINUS = r'(?<MINUS>-)';
var TIMES = r'(?<TIMES>\*)';
var DIVIDE = r'(?<DIVIDE>/)';
var ROOT = r'(?<ROOT>√)';
var FACTORIAL = r'(?<FACTORIAL>!)';
var EXPONENT = r'(?<EXPONENT>\^)';
var LPAREN = r'(?<LPAREN>\()';
var RPAREN = r'(?<RPAREN>\))';
var EQUAL = r'(?<EQUAL>=)';
var CLUE = r'(?<CLUE>[adAD]\d+)';
var VAR = r'(?<VAR>\w)';
var GENERATOR = r'(?<GENERATOR>\#\w+)';
var MONADIC = r'(?<MONADIC>\$\w+)';
var WS = r'(?<WS>\s+)';
var ERROR = r'(?<ERROR>.)';
var regExp = RegExp([
  NUM,
  PLUS,
  MINUS,
  TIMES,
  DIVIDE,
  ROOT,
  FACTORIAL,
  EXPONENT,
  LPAREN,
  RPAREN,
  EQUAL,
  CLUE,
  VAR,
  GENERATOR,
  MONADIC,
  WS,
  ERROR,
].join('|'));

typedef GeneratorFunc = Iterable<int> Function(num min, num max);

class Generator {
  String name;
  GeneratorFunc func;
  Generator(this.name, this.func);
}

typedef MonadicFunc = int Function(int arg);

class Monadic {
  String name;
  MonadicFunc func;
  Monadic(this.name, this.func);
}

var generators = <String, Generator>{};
var monadics = <String, Monadic>{};

class Token {
  final String type;
  final String str;
  final int value;
  final String name;
  Token(this.str, this.type, {this.value = 0, this.name = ''});
  String toLongString() {
    return '$type' +
        (value != 0 ? '=${value.toString()}' : '') +
        (name != '' ? '=$name' : '');
  }

  String toString() => this.str;
}

class Scanner {
// Token Scanner

  static var initialized = false;

  static void initialize() {
    generators['prime'] = Generator('prime', generatePrimes);
    monadics['DS'] = Monadic('DS', digitSum);
    monadics['DP'] = Monadic('DP', digitProduct);
    monadics['MP'] = Monadic('MP', multiplicativePersistence);
    initialized = true;
  }

  static Iterable<Token?> generateTokens(String text,
      [String variablePrefix = '']) sync* {
    if (!initialized) initialize();
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    for (final m in matches) {
      var match = m[0];
      if (m.namedGroup('NUM') != null) {
        yield Token(match!, 'NUM', value: int.parse(match));
      }
      if (m.namedGroup('CLUE') != null) {
        yield Token(match!, 'CLUE', name: match.toUpperCase());
      }
      if (m.namedGroup('VAR') != null) {
        yield Token(match!, 'VAR', name: variablePrefix + match);
      }
      if (m.namedGroup('GENERATOR') != null) {
        var name = match!.substring(1);
        if (generators.containsKey(name)) {
          yield Token(match, 'GENERATOR', name: name);
        } else {
          yield Token(match, 'ERROR');
        }
      }
      if (m.namedGroup('MONADIC') != null) {
        var name = match!.substring(1);
        if (monadics.containsKey(name)) {
          yield Token(match, 'MONADIC', name: name);
        } else {
          yield Token(match, 'ERROR');
        }
      }
      if (m.namedGroup('PLUS') != null) {
        yield Token(match!, 'PLUS');
      }
      if (m.namedGroup('TIMES') != null) {
        yield Token(match!, 'TIMES');
      }
      if (m.namedGroup('MINUS') != null) {
        yield Token(match!, 'MINUS');
      }
      if (m.namedGroup('DIVIDE') != null) {
        yield Token(match!, 'DIVIDE');
      }
      if (m.namedGroup('ROOT') != null) {
        yield Token(match!, 'ROOT');
      }
      if (m.namedGroup('FACTORIAL') != null) {
        yield Token(match!, 'FACTORIAL');
      }
      if (m.namedGroup('EXPONENT') != null) {
        yield Token(match!, 'EXPONENT');
      }
      if (m.namedGroup('LPAREN') != null) {
        yield Token(match!, 'LPAREN');
      }
      if (m.namedGroup('RPAREN') != null) {
        yield Token(match!, 'RPAREN');
      }
      if (m.namedGroup('EQUAL') != null) {
        yield Token(match!, 'EQUAL');
      }
      if (m.namedGroup('ERROR') != null) {
        throw ExpressionInvalid('Invalid character ${text[m.start]}');
      }
    }
  }
}

// AST
class Node {
  final Token token;
  List<Node>? operands;
  Node(this.token, [this.operands]);
  String toString() => operands == null
      ? '$token'
      : operands!.length == 1
          ? '$token${operands![0]}'
          : '(${operands![0]}$token${operands![1]})';
//      '($token${operands == null ? '' : operands!.map<String>((e) => ' $e')})';
}

class ExpressionError implements Exception {
  final String msg;
  ExpressionError(this.msg);
}

class ExpressionInvalid implements Exception {
  final String msg;
  ExpressionInvalid(this.msg);
}

// Parser
class ExpressionEvaluator {
  // Implementation of a recursive descent parser.   Each method
  // implements a single grammar rule.  Use the ._accept() method
  // to test and accept the current lookahead token.  Use the ._expect()
  // method to exactly match and discard the next token on on the input
  // (or throw a SyntaxError if it doesn't match).

  final String text;
  final String variablePrefix;
  List<String> variableRefs = [];
  late final Iterator tokenIterator;
  Token? tok;
  Token? nexttok;
  Node? tree;

  // Evaluation context
  List<String>? variableNames;
  List<int>? variableValues;

  ExpressionEvaluator(this.text, [this.variablePrefix = '']) {
    var tokenIterable = Scanner.generateTokens(text, variablePrefix);
    this.tokenIterator = tokenIterable.iterator;
    this.tok = null; // Last symbol consumed
    this.nexttok = null; // Next symbol tokenized
    this._advance(); // Load first lookahead token
    this._parse(); // Build tree
  }

  String toString() => this.tree == null ? '' : this.tree.toString();

  void _parse() {
    this.tree = this.logical();
    if (this.nexttok != null) {
      throw ExpressionError('Parse error at ${this.nexttok.toString()}');
    }
  }

  void integerException() {
    throw ExpressionInvalid('Non-integer expression');
  }

  void checkInteger(num value) {
    if (!isIntegerValue(value)) {
      integerException();
    }
  }

  int evaluate([List<String>? variableNames, List<int>? variableValues]) {
    this.variableNames = variableNames;
    this.variableValues = variableValues;
    var value = this.eval(this.tree);
    checkInteger(value);
    return value.toInt();
  }

  Iterable<num> generate(num min, num max,
      [List<String>? variableNames, List<int>? variableValues]) sync* {
    this.variableNames = variableNames;
    this.variableValues = variableValues;
    for (var value in this.gen(min, max, this.tree)) {
      if (isIntegerValue(value)) yield value.toInt();
    }
  }

  bool isIntegerValue(num value) {
    return value is int || value == value.roundToDouble();
  }

  void _advance() {
    // Advance one token ahead
    this.tok = this.nexttok;
    if (tokenIterator.moveNext()) {
      this.nexttok = tokenIterator.current;
    } else {
      this.nexttok = null;
    }
  }

  bool _accept(toktype) {
    // Test and consume the next token if it matches toktype
    if (this.nexttok?.type == toktype) {
      this._advance();
      return true;
    }
    return false;
  }

  void _expect(toktype) {
    // Consume next token if it matches toktype or throw SyntaxError
    if (!this._accept(toktype)) {
      throw ExpressionError('Expected ' + toktype);
    }
  }

  // Grammar rules follow

  Node logical() {
    // logical ::= expr { '=' expr }*

    var node = this.expr();
    while (this._accept('EQUAL')) {
      var token = this.tok!;
      var right = this.expr();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node expr() {
    // expression ::= term { ('+'|'-') term }*

    var node = this.term();
    while (this._accept('PLUS') || this._accept('MINUS')) {
      var token = this.tok!;
      var right = this.term();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node term() {
    // term ::= exponent { ('*'|'/') exponent }*
    var node = this.exponent();
    while (this._accept('TIMES') || this._accept('DIVIDE')) {
      var token = this.tok!;
      var right = this.exponent();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node exponent() {
    // exponent ::= unary { '^') unary }*
    var node = this.unary();
    while (this._accept('EXPONENT')) {
      var token = this.tok!;
      var right = this.unary();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node unary() {
    // term ::= { '-' | '√' | MONADIC } multiplication
    if (this._accept('MINUS')) {
      var token = this.tok!;
      var left = Node(Token('', 'NUM', value: 0));
      var right = this.multiplication();
      var node = Node(token, [left, right]);
      return node;
    }
    if (this._accept('ROOT') || this._accept('MONADIC')) {
      var token = this.tok!;
      var right = this.multiplication();
      var node = Node(token, [right]);
      return node;
    }
    return this.multiplication();
  }

  Node multiplication() {
    // multiplication ::= factorial { factorial }*
    var node = this.factorial();
    if (node != null) {
      while (true) {
        var node2 = this.factorial();
        if (node2 == null) return node!;
        var token = Token('', 'TIMES');
        node = Node(token, [node!, node2]);
      }
    } else {
      throw ExpressionError('Expected NUMBER, VARIABLE, GENERATOR or LPAREN');
    }
  }

  Node? factorial() {
    // factorial ::= factor { '!' }
    var node = this.factor();
    if (node != null && this._accept('FACTORIAL')) {
      var token = this.tok!;
      node = Node(token, [node]);
    }
    return node;
  }

  Node? factor() {
    // factor ::= VAR | NUM | GENERATOR| ( expr )
    if (this._accept('VAR') ||
        this._accept('NUM') ||
        this._accept('GENERATOR')) {
      var token = this.tok!;
      if (token.type == 'VAR') {
        this.variableRefs.add(token.name);
      }
      return Node(token);
    } else if (this._accept('LPAREN')) {
      var node = this.expr();
      this._expect('RPAREN');
      return node;
    } else {
      return null;
    }
  }

  num eval(Node? node) {
    if (node == null) return 0;
    switch (node.token.type) {
      case 'NUM':
        return node.token.value;
      case 'PLUS':
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        return left + right;
      case 'MINUS':
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        return left - right;
      case 'TIMES':
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        return left * right;
      case 'DIVIDE':
        // Require exact integer result
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        // if (left % right != 0) {
        //   throw ExpressionInvalid('Non-integer division');
        // }
        return left / right;
      case 'ROOT':
        var square = eval(node.operands![0]);
        var root = sqrt(square).toInt();
        if (root * root != square) {
          throw ExpressionInvalid('Non-integer root');
        }
        return root;
      case 'FACTORIAL':
        var left = eval(node.operands![0]);
        int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);
        checkInteger(left);
        return factorial(left.toInt());
      case 'EXPONENT':
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        var exp = pow(left, right);
        var result = exp;
        return result;
      case 'EQUAL':
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        if (left != right) {
          throw ExpressionInvalid('Unequal expressions');
        }
        return left;
      case 'VAR':
        var name = node.token.name;
        var index = this.variableNames!.indexOf(name);
        if (index < 0) {
          throw ExpressionError('Unknown variable $name');
        }
        return this.variableValues![index];
      case 'GENERATOR':
        var name = node.token.name;
        var generator = generators[name];
        if (generator == null) {
          throw ExpressionError('Unknown generator $name');
        }
        // TODO multiple values
        // TODO min/max
        return generator.func(10, 99).first;
      case 'MONADIC':
        var name = node.token.name;
        var monadic = monadics[name];
        if (monadic == null) {
          throw ExpressionError('Unknown monadic $name');
        }
        var left = eval(node.operands![0]);
        checkInteger(left);
        return monadic.func(left.toInt());
      default:
        throw ExpressionError('Invalid AST');
    }
  }

  Iterable<num> gen(num min, num max, Node? node) sync* {
    if (node == null) return;
    switch (node.token.type) {
      case 'NUM':
        var result = node.token.value;
        if (result >= min && result <= max) yield result;
        break;
      case 'PLUS':
        for (var left in gen(min, max, node.operands![0])) {
          if (left > max) break;
          for (var right in gen(min, max, node.operands![1])) {
            var result = left + right;
            if (result > max) break;
            if (result >= min && result <= max) yield result;
          }
        }
        break;
      case 'MINUS':
        for (var left in gen(min, max, node.operands![0])) {
          if (left < min) break;
          for (var right in gen(min, max, node.operands![1])) {
            var result = left - right;
            if (result < min) break;
            if (result >= min && result <= max) yield result;
          }
        }
        break;
      case 'TIMES':
        for (var left in gen(min, max, node.operands![0])) {
          if (left > max) break;
          for (var right in gen(min, max, node.operands![1])) {
            var result = left * right;
            if (result > max) break;
            if (result >= min && result <= max) yield result;
          }
        }
        break;
      case 'DIVIDE':
        // Require exact integer result
        for (var left in gen(min, max, node.operands![0])) {
          if (left < min) break;
          for (var right in gen(min, max, node.operands![1])) {
            var result = left / right;
            if (result < min) break;
            if (result >= min && result <= max) yield result;
          }
        }
        break;
      case 'ROOT':
        for (var square in gen(min, max, node.operands![0])) {
          var root = sqrt(square).toInt();
          if (root * root == square) {
            var result = root;
            if (result >= min && result <= max) yield result;
          }
          if (root > max) break;
        }
        break;
      case 'FACTORIAL':
        for (var left in gen(min, max, node.operands![0])) {
          int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);
          if (isIntegerValue(left)) {
            var result = factorial(left.toInt());
            if (result > max) break;
            if (result >= min && result <= max) yield result;
          }
        }
        break;
      case 'EXPONENT':
        exp1:
        for (var left in gen(min, max, node.operands![0])) {
          if (left == 0 || left == 1) {
            yield left;
          } else {
            if (left > max) break;
            exp2:
            for (var right in gen(min, max, node.operands![1])) {
              var any = false;
              var result = pow(left, right);
              if (result > max) {
                if (!any) break exp1;
                break exp2;
              }
              if (result >= min && result <= max) {
                any = true;
                yield result;
              }
            }
          }
        }
        break;
      case 'EQUAL':
        for (var left in gen(min, max, node.operands![0])) {
          if (left > max) break;
          for (var right in gen(min, max, node.operands![1])) {
            if (left == right) {
              var result = left;
              if (result >= min && result <= max) yield result;
            } else if (right > left) break;
          }
        }
        break;
      case 'VAR':
        var name = node.token.name;
        var index = this.variableNames!.indexOf(name);
        if (index < 0) {
          throw ExpressionError('Unknown variable $name');
        }
        var result = this.variableValues![index];
        if (result >= min && result <= max) yield result;
        break;
      case 'GENERATOR':
        var name = node.token.name;
        var generator = generators[name];
        if (generator == null) {
          throw ExpressionError('Unknown generator $name');
        }
        for (var result in generator.func(min, max)) {
          if (result >= min && result <= max) yield result;
        }
        break;
      case 'MONADIC':
        var name = node.token.name;
        var monadic = monadics[name];
        if (monadic == null) {
          throw ExpressionError('Unknown monadic $name');
        }
        for (var left in gen(min, max, node.operands![0])) {
          checkInteger(left);
          var result = monadic.func(left.toInt());
          if (result >= min && result <= max) yield result;
        }
        break;
      default:
        throw ExpressionError('Invalid AST');
    }
  }
}
