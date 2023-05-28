// Evaluate expression strings, with variable references

// Token specification
import 'dart:math';

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
var VAR = r'(?<VAR>\w)';
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
  VAR,
  WS,
  ERROR,
].join('|'));

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

// Token Scanner
Iterable<Token?> generateTokens(String text,
    [String variablePrefix = '']) sync* {
  Iterable<RegExpMatch> matches = regExp.allMatches(text);
  for (final m in matches) {
    var match = m[0];
    if (m.namedGroup('NUM') != null) {
      yield Token(match!, 'NUM', value: int.parse(match));
    }
    if (m.namedGroup('VAR') != null) {
      yield Token(match!, 'VAR', name: variablePrefix + match);
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
    var tokenIterable = generateTokens(text, variablePrefix);
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

  int evaluate(variableNames, variableValues) {
    this.variableNames = variableNames;
    this.variableValues = variableValues;
    var value = this.eval(this.tree);
    return value;
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
    // term ::= { '-' | '√' } multiplication
    if (this._accept('MINUS')) {
      var token = this.tok!;
      var left = Node(Token('', 'NUM', value: 0));
      var right = this.multiplication();
      var node = Node(token, [left, right]);
      return node;
    }
    if (this._accept('ROOT')) {
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
      throw ExpressionError('Expected NUMBER, VARIABLE or LPAREN');
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
    // factor ::= VAR | NUM | ( expr )
    if (this._accept('VAR') || this._accept('NUM')) {
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

  int eval(Node? node) {
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
        if (left % right != 0) {
          throw ExpressionInvalid('Non-integer division');
        }
        return left ~/ right;
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
        return factorial(left);
      case 'EXPONENT':
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        var exp = pow(left, right);
        var result = exp.toInt();
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
      default:
        throw ExpressionError('Invalid AST');
    }
  }
}

void main(List<String> args) {
  try {
    var text = 'S+I*G/M-a';
    for (var token in generateTokens(text)) {
      print('$token');
    }
    var text2 = '5+4*3/2-1';
    var exp = ExpressionEvaluator(text2);
    var value = exp.evaluate(['S', 'I', 'G', 'M', 'a'], [5, 4, 3, 2, 1]);
    print('$text2=$value');

    final stopwatch = Stopwatch()..start();
    var value2 = 0;
    var exp2 = ExpressionEvaluator(text);
    for (var i = 0; i < 1000000; i++) {
      value2 = exp2.evaluate(['S', 'I', 'G', 'M', 'a'], [5, 4, 3, 2, 1]);
    }
    print(
        '$text=$value2, elapsed ${stopwatch.elapsed}'); // 15 secs reduced to 0.2 secs with AST
  } on ExpressionError catch (se) {
    print('Error ${se.msg}');
  }
}
