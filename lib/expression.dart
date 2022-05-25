// Evaluate expression strings, with variable references

// Token specification
var NUM = r'(?<NUM>\d+)';
var PLUS = r'(?<PLUS>\+)';
var MINUS = r'(?<MINUS>-)';
var TIMES = r'(?<TIMES>\*)';
var DIVIDE = r'(?<DIVIDE>/)';
var LPAREN = r'(?<LPAREN>\()';
var RPAREN = r'(?<RPAREN>\))';
var EQUAL = r'(?<EQUAL>=)';
var VAR = r'(?<VAR>\w)';
var WS = r'(?<WS>\s+)';
var regExp = RegExp([
  NUM,
  PLUS,
  MINUS,
  TIMES,
  DIVIDE,
  LPAREN,
  RPAREN,
  EQUAL,
  VAR,
  WS
].join('|'));

class Token {
  final String type;
  final int value;
  final String name;
  Token(this.type, {this.value = 0, this.name = ''});
  String toString() {
    return '$type' +
        (value != 0 ? '=${value.toString()}' : '') +
        (name != '' ? '=$name' : '');
  }
}

// Token Scanner
Iterable<Token?> generateTokens(String text) sync* {
  Iterable<RegExpMatch> matches = regExp.allMatches(text);
  for (final m in matches) {
    var match = m[0];
    if (m.namedGroup('NUM') != null) {
      yield Token('NUM', value: int.parse(match!));
    }
    if (m.namedGroup('VAR') != null) {
      yield Token('VAR', name: match!);
    }
    if (m.namedGroup('PLUS') != null) {
      yield Token('PLUS');
    }
    if (m.namedGroup('TIMES') != null) {
      yield Token('TIMES');
    }
    if (m.namedGroup('MINUS') != null) {
      yield Token('MINUS');
    }
    if (m.namedGroup('DIVIDE') != null) {
      yield Token('DIVIDE');
    }
    if (m.namedGroup('LPAREN') != null) {
      yield Token('LPAREN');
    }
    if (m.namedGroup('RPAREN') != null) {
      yield Token('RPAREN');
    }
    if (m.namedGroup('EQUAL') != null) {
      yield Token('EQUAL');
    }
  }
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
  final List<String> variableNames;
  final List<int> variableValues;
  late final Iterator tokenIterator;
  Token? tok;
  Token? nexttok;

  ExpressionEvaluator(this.text, this.variableNames, this.variableValues) {
    var tokenIterable = generateTokens(text);
    this.tokenIterator = tokenIterable.iterator;
    this.tok = null; // Last symbol consumed
    this.nexttok = null; // Next symbol tokenized
    this._advance(); // Load first lookahead token
  }

  int evaluate() {
    var value = this.logical();
    if (this.nexttok != null) {
      throw ExpressionError('Parse error at ${this.nexttok.toString()}');
    }
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

  int logical() {
    // logical ::= expr { '=' expr }*

    var exprval = this.expr();
    while (this._accept('EQUAL')) {
      var right = this.expr();
      if (exprval != right) {
        throw ExpressionInvalid('Unequal expressions');
      }
    }
    return exprval;
  }

  int expr() {
    //expression ::= term { ('+'|'-') term }*

    var exprval = this.term();
    while (this._accept('PLUS') || this._accept('MINUS')) {
      var op = this.tok!.type;
      var right = this.term();
      if (op == 'PLUS') {
        exprval += right;
      } else if (op == 'MINUS') {
        exprval -= right;
      }
    }
    return exprval;
  }

  int term() {
    // term ::= factor { ('*'|'/') factor }*
    var termval = this.factor();
    while (this._accept('TIMES') || this._accept('DIVIDE')) {
      var op = this.tok!.type;
      var right = this.factor();
      if (op == 'TIMES') {
        termval *= right;
      } else if (op == 'DIVIDE') {
        // Require exact integer result
        if (termval % right != 0) {
          throw ExpressionInvalid('Non-integer division');
        }
        termval ~/= right;
      }
    }
    return termval;
  }

  int factor() {
    // factor ::= NUM | ( expr )
    if (this._accept('NUM')) {
      return this.tok!.value;
    } else if (this._accept('VAR')) {
      var name = this.tok!.name;
      var index = this.variableNames.indexOf(name);
      if (index < 0) {
        throw ExpressionError('Unknown variable $name');
      }
      return this.variableValues[index];
    } else if (this._accept('LPAREN')) {
      var exprval = this.expr();
      this._expect('RPAREN');
      return exprval;
    } else {
      throw ExpressionError('Expected NUMBER or LPAREN');
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
    var exp =
        ExpressionEvaluator(text2, ['S', 'I', 'G', 'M', 'a'], [5, 4, 3, 2, 1]);
    var value = exp.evaluate();
    print('$text2=$value');
    var exp2 =
        ExpressionEvaluator(text, ['S', 'I', 'G', 'M', 'a'], [5, 4, 3, 2, 1]);
    var value2 = exp2.evaluate();
    print('$text=$value2');
  } on ExpressionError catch (se) {
    print('Error ${se.msg}');
  }
}
