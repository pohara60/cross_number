import 'expression.dart';

/// A recursive descent parser for mathematical and logical expressions.
///
/// It includes a scanner (lexer) to convert the source string into a sequence
/// of tokens, and a parser to build an expression tree from those tokens.
class Parser {
  final String source;
  final List<Token> _tokens = [];
  int _start = 0;
  int _current = 0;
  int _line = 1;

  Parser(this.source);

  /// Scans the source string and returns a list of tokens.
  List<Token> scanTokens() {
    while (!_isAtEnd()) {
      // We are at the beginning of the next lexeme.
      _start = _current;
      _scanToken();
    }

    _tokens.add(Token(TokenType.EOF, "", line: _line));
    return _tokens;
  }

  void _scanToken() {
    final c = _advance();
    switch (c) {
      case '(':
        _addToken(TokenType.LEFT_PAREN);
        break;
      case ')':
        _addToken(TokenType.RIGHT_PAREN);
        break;
      case '+':
        _addToken(TokenType.PLUS);
        break;
      case '-':
        _addToken(TokenType.MINUS);
        break;
      case '*':
        _addToken(TokenType.STAR);
        break;
      case '/':
        _addToken(TokenType.SLASH);
        break;
      case '^':
        _addToken(TokenType.EXPONENT);
        break;
      case '=':
        _addToken(TokenType.EQUAL);
        break;
      case '<':
        _addToken(TokenType.LESS);
        break;
      case '>':
        _addToken(TokenType.GREATER);
        break;
      case '&':
        _addToken(TokenType.AMPERSAND);
        break;
      case "'":
        _addToken(TokenType.REVERSE);
        break;
      case '.':
        _addToken(TokenType.DOT);
        break;
      case '#':
        _addToken(TokenType.HASH);
        break;
      case '\$':
        _addToken(TokenType.DOLLAR);
        break;
      case '\n':
        _line++;
        break;
      case ' ':
      case '\r':
      case '\t':
        // Ignore whitespace.
        break;
      default:
        if (_isDigit(c)) {
          _numberOrIdentifier();
        } else if (_isAlpha(c)) {
          _identifier();
        } else {
          // Error reporting for unexpected characters.
        }
        break;
    }
  }

  void _numberOrIdentifier() {
    while (_isDigit(_peek())) {
      _advance();
    }

    if (_isAlpha(_peek())) {
      while (_isAlphaNumeric(_peek())) {
        _advance();
      }
      _addToken(TokenType.IDENTIFIER);
    } else {
      _addToken(
          TokenType.NUMBER, num.parse(source.substring(_start, _current)));
    }
  }

  void _identifier() {
    while (_isAlphaNumeric(_peek())) {
      _advance();
    }
    _addToken(TokenType.IDENTIFIER);
  }

  bool _isAtEnd() {
    return _current >= source.length;
  }

  String _advance() {
    return source[_current++];
  }

  void _addToken(TokenType type, [Object? literal]) {
    final text = source.substring(_start, _current);
    _tokens.add(Token(type, text, literal: literal, line: _line));
  }

  String _peek() {
    if (_isAtEnd()) return '\x00';
    return source[_current];
  }

  // ignore: unused_element
  String _peekNext() {
    if (_current + 1 >= source.length) return '\x00';
    return source[_current + 1];
  }

  bool _isDigit(String c) {
    return c.compareTo('0') >= 0 && c.compareTo('9') <= 0;
  }

  bool _isAlpha(String c) {
    return (c.compareTo('a') >= 0 && c.compareTo('z') <= 0) ||
        (c.compareTo('A') >= 0 && c.compareTo('Z') <= 0) ||
        c == '_';
  }

  bool _isAlphaNumeric(String c) {
    return _isAlpha(c) || _isDigit(c);
  }

  /// Parses the scanned tokens into an [Expression] tree.
  Expression parse() {
    scanTokens();
    _current = 0; // Reset for the parser.
    var expr = _expression();
    if (!_isAtEndParser()) {
      throw _error(_peekParser(), "Unexpected token after expression.");
    }
    return expr;
  }

  Expression _expression() {
    return _logicalAnd();
  }

  Expression _logicalAnd() {
    var expr = _comparison();

    while (_match([TokenType.AMPERSAND])) {
      final operator = _previous();
      final right = _comparison();
      expr = BinaryExpression(expr, operator, right);
    }

    return expr;
  }

  Expression _comparison() {
    var expr = _term();

    while (_match([TokenType.EQUAL, TokenType.LESS, TokenType.GREATER])) {
      final operator = _previous();
      final right = _term();
      expr = BinaryExpression(expr, operator, right);
    }

    return expr;
  }

  Expression _term() {
    var expr = _factor();

    while (_match([TokenType.MINUS, TokenType.PLUS])) {
      final operator = _previous();
      final right = _factor();
      expr = BinaryExpression(expr, operator, right);
    }

    return expr;
  }

  Expression _factor() {
    var expr = _exponent();

    while (_match([TokenType.SLASH, TokenType.STAR])) {
      final operator = _previous();
      final right = _exponent();
      expr = BinaryExpression(expr, operator, right);
    }

    return expr;
  }

  Expression _exponent() {
    var expr = _unary();

    while (_match([TokenType.EXPONENT])) {
      final operator = _previous();
      final right = _unary();
      expr = BinaryExpression(expr, operator, right);
    }

    return expr;
  }

  Expression _unary() {
    if (_match([TokenType.MINUS, TokenType.REVERSE])) {
      final operator = _previous();
      final right = _unary();
      return UnaryExpression(operator, right);
    }
    if (_match([TokenType.DOLLAR])) {
      final operator =
          _consume(TokenType.IDENTIFIER, "Expect function name after '\$'");
      final right = _unary();
      return MonadicExpression(operator, right);
    }

    return _primary();
  }

  Expression _primary() {
    if (_match([TokenType.NUMBER])) {
      return NumberExpression(_previous().literal as num);
    }

    if (_match([TokenType.HASH])) {
      _consume(TokenType.IDENTIFIER, "Expect generator name after '#'.");
      return GeneratorExpression(_previous().lexeme);
    }

    if (_match([TokenType.IDENTIFIER])) {
      final identifierToken = _previous();
      if (_match([TokenType.DOT])) {
        _consume(TokenType.IDENTIFIER, "Expect entry ID after '.'");
        final entryToken = _previous();
        return GridReferenceExpression(
            identifierToken.lexeme, entryToken.lexeme);
      } else {
        return VariableExpression(identifierToken.lexeme);
      }
    }

    if (_match([TokenType.LEFT_PAREN])) {
      final expr = _expression();
      _consume(TokenType.RIGHT_PAREN, "Expect ')' after expression.");
      return GroupingExpression(expr);
    }

    throw _error(_peekParser(), "Expect expression.");
  }

  bool _match(List<TokenType> types) {
    for (final type in types) {
      if (_check(type)) {
        _advanceParser();
        return true;
      }
    }

    return false;
  }

  Token _consume(TokenType type, String message) {
    if (_check(type)) return _advanceParser();

    throw _error(_peekParser(), message);
  }

  bool _check(TokenType type) {
    if (_isAtEndParser()) return false;
    return _peekParser().type == type;
  }

  Token _advanceParser() {
    if (!_isAtEndParser()) _current++;
    return _previous();
  }

  bool _isAtEndParser() {
    return _peekParser().type == TokenType.EOF;
  }

  Token _peekParser() {
    return _tokens[_current];
  }

  Token _previous() {
    return _tokens[_current - 1];
  }

  ParseException _error(Token token, String message) {
    // In a real application, you would report this error to the user.
    var msg = 'Parse error at token ${token.lexeme}: $message';
    return ParseException(msg);
  }
}

/// An error thrown when the parser encounters a syntax error.
class ParseException implements Exception {
  String? msg;
  ParseException([this.msg]);
}
