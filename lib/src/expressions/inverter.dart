// ignore_for_file: curly_braces_in_flow_control_structures

import '../expressions/expression.dart';
import '../models/entry.dart';
import '../models/expressable.dart';

class ExpressionInverter {
  final Expression expression;
  final Expressable subject;
  final Entry target;

  ExpressionInverter(this.expression, this.subject, this.target);

  Expression? invert() {
    // Check if the expression contains the entry
    final expressableVisitor = _ExpressableVisitor(target);
    expression.accept(expressableVisitor, min: 1, max: 1);
    if (expressableVisitor.found) {
      try {
        return _rearrange(expression);
      } on InvertException catch (e) {
        print(e.message);
      }
    }
    return null;
  }

  Expression? _rearrange(Expression expressionToSolve, [Expression? child]) {
    if (expressionToSolve is GridEntryExpression &&
            expressionToSolve.entryId == target.id ||
        expressionToSolve is VariableExpression &&
            expressionToSolve.name == target.id) {
      if (child != null) return child;
      return VariableExpression(subject.id);
    }

    final entryVisitor = _ExpressableVisitor(target);
    switch (expressionToSolve.runtimeType) {
      case BinaryExpression:
        final binary = expressionToSolve as BinaryExpression;
        entryVisitor.found = false;
        var left = binary.left;
        left.accept(entryVisitor, min: 1, max: 1);
        final leftContainsEntry = entryVisitor.found;
        entryVisitor.found = false;
        var right = binary.right;
        right.accept(entryVisitor, min: 1, max: 1);
        final rightContainsEntry = entryVisitor.found;

        if (leftContainsEntry && !rightContainsEntry) {
        } else if (!leftContainsEntry && rightContainsEntry) {}
        if (leftContainsEntry && rightContainsEntry) {
          throw InvertException(
              'Cannot invert expression with entry on both sides: $expressionToSolve');
        } else if (!leftContainsEntry && !rightContainsEntry) {
          throw InvertException(
              'Cannot invert expression without entry: $expressionToSolve');
        }
        var operator = expressionToSolve.operator;
        switch (operator.type) {
          case TokenType.PLUS:
          case TokenType.MINUS:
          case TokenType.STAR:
          case TokenType.SLASH:
            var newToken = operator;
            if (leftContainsEntry) {
              if (operator.type == TokenType.PLUS)
                newToken = Token(TokenType.MINUS, "-");
              if (operator.type == TokenType.MINUS)
                newToken = Token(TokenType.PLUS, "+");
              if (operator.type == TokenType.STAR)
                newToken = Token(TokenType.SLASH, "/");
              if (operator.type == TokenType.SLASH)
                newToken = Token(TokenType.STAR, "*");
              var other = child ?? VariableExpression(subject.id);
              child = BinaryExpression(other, newToken, right);
              return _rearrange(left, child);
            }
            if (rightContainsEntry) {
              if (operator.type == TokenType.PLUS)
                newToken = Token(TokenType.MINUS, "-");
              if (operator.type == TokenType.MINUS)
                newToken = Token(TokenType.MINUS, "-");
              if (operator.type == TokenType.STAR)
                newToken = Token(TokenType.SLASH, "/");
              if (operator.type == TokenType.SLASH)
                newToken = Token(TokenType.SLASH, "/");
              var other = child ?? VariableExpression(subject.id);
              if (operator.type == TokenType.PLUS ||
                  operator.type == TokenType.STAR) {
                child = BinaryExpression(other, newToken, left);
              } else {
                child = BinaryExpression(left, newToken, other);
              }
              return _rearrange(right, child);
            }
          case TokenType.AMPERSAND:
          case TokenType.EQUAL:
            if (leftContainsEntry) {
              return _rearrange(left, null);
            }
            if (rightContainsEntry) {
              return _rearrange(right, null);
            }
          default:
            throw InvertException(
                'Unsupported operator for inversion: ${expressionToSolve.operator.lexeme}');
        }
      case UnaryExpression:
        final unary = expressionToSolve as UnaryExpression;
        entryVisitor.found = false;
        var right = unary.right;
        right.accept(entryVisitor, min: 1, max: 1);
        final rightContainsEntry = entryVisitor.found;
        if (!rightContainsEntry) {
          throw InvertException(
              'Cannot invert unary expression without entry: $expressionToSolve');
        }
        // For unary expressions, we can only handle negation
        var operator = unary.operator;
        if (operator.type == TokenType.MINUS) {
          var newToken = Token(TokenType.MINUS, "-");
          var other = child ?? VariableExpression(subject.id);
          child = UnaryExpression(newToken, other);
          return _rearrange(right, child);
        } else if (operator.type == TokenType.REVERSE) {
          throw InvertException('Cannot invert REVERSE expressions');
        } else {
          throw InvertException(
              'Unsupported unary operator for inversion: ${unary.operator.lexeme}');
        }
      case GroupingExpression:
        final grouping = expressionToSolve as GroupingExpression;
        var expression = grouping.expression;
        expression.accept(entryVisitor, min: 1, max: 1);
        final containsEntry = entryVisitor.found;
        if (!containsEntry) {
          throw InvertException(
              'Cannot invert grouping expression without entry: $expressionToSolve');
        }
        return _rearrange(expression, child);
      default:
        throw InvertException(
            'Unsupported expression for inversion: ${expressionToSolve.runtimeType}');
    }

    return null;
  }
}

class InvertException implements Exception {
  final String message;
  InvertException(this.message);
}

class _ExpressableVisitor implements ExpressionVisitor<void> {
  final Entry entry;
  bool found = false;

  _ExpressableVisitor(this.entry);

  @override
  void visitBinaryExpression(BinaryExpression expression,
      {required num min, required num max}) {
    expression.left.accept(this, min: min, max: max);
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitGeneratorExpression(GeneratorExpression expression,
      {required num min, required num max}) {}

  @override
  void visitGridEntryExpression(GridEntryExpression expression,
      {required num min, required num max}) {
    if (expression.entryId == entry.id) {
      found = true;
    }
  }

  @override
  void visitGroupingExpression(GroupingExpression expression,
      {required num min, required num max}) {
    expression.expression.accept(this, min: min, max: max);
  }

  @override
  void visitMonadicExpression(MonadicExpression expression,
      {required num min, required num max}) {
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitNumberExpression(NumberExpression expression,
      {required num min, required num max}) {}

  @override
  void visitUnaryExpression(UnaryExpression expression,
      {required num min, required num max}) {
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitVariableExpression(VariableExpression expression,
      {required num min, required num max}) {
    if (expression.name == entry.id) {
      found = true;
    }
  }
}
