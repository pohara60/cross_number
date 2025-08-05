/// The base class for all expression nodes in the syntax tree.
///
/// This class uses the Visitor pattern to allow for different operations
/// to be performed on the expression tree, such as evaluation or variable extraction.
// ignore_for_file: constant_identifier_names

abstract class Expression {
  /// Accepts a [visitor] and calls the appropriate visit method.
  R accept<R>(ExpressionVisitor<R> visitor);
}

/// A visitor for [Expression] nodes.
///
/// This interface defines a method for each type of expression node.
abstract class ExpressionVisitor<R> {
  R visitNumberExpression(NumberExpression expression);
  R visitVariableExpression(VariableExpression expression);
  R visitBinaryExpression(BinaryExpression expression);
  R visitUnaryExpression(UnaryExpression expression);
  R visitGroupingExpression(GroupingExpression expression);
  R visitGridEntryExpression(GridEntryExpression expression);
}

/// An expression node representing a literal number.
class NumberExpression extends Expression {
  final num value;

  NumberExpression(this.value);

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitNumberExpression(this);
  }
}

/// An expression node representing a variable.
class VariableExpression extends Expression {
  final String name;

  VariableExpression(this.name);

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitVariableExpression(this);
  }
}

/// An expression node representing a binary operation.
class BinaryExpression extends Expression {
  final Expression left;
  final Token operator;
  final Expression right;

  BinaryExpression(this.left, this.operator, this.right);

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitBinaryExpression(this);
  }
}

/// An expression node representing a unary operation.
class UnaryExpression extends Expression {
  final Token operator;
  final Expression right;

  UnaryExpression(this.operator, this.right);

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitUnaryExpression(this);
  }
}

/// An expression node representing a grouping of expressions.
class GroupingExpression extends Expression {
  final Expression expression;

  GroupingExpression(this.expression);

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitGroupingExpression(this);
  }
}

/// An expression node representing a reference to a grid entry.
class GridEntryExpression extends Expression {
  final String gridId;
  final String entryId;

  GridEntryExpression(this.gridId, this.entryId);

  @override
  R accept<R>(ExpressionVisitor<R> visitor) {
    return visitor.visitGridEntryExpression(this);
  }
}

/// The types of tokens that can be produced by the scanner.
enum TokenType {
  // Single-character tokens.
  LEFT_PAREN,
  RIGHT_PAREN,
  PLUS,
  MINUS,
  STAR,
  SLASH,

  // Literals.
  NUMBER,
  IDENTIFIER,

  // Keywords.
  EOF,
  DOT,
}

/// A token produced by the scanner.
class Token {
  final TokenType type;
  final String lexeme;
  final Object? literal;
  final int line; // For error reporting.

  Token(this.type, this.lexeme, this.literal, this.line);

  @override
  String toString() {
    return '$type $lexeme $literal';
  }
}

/// A visitor that extracts the names of all variables and grid entries from an expression.
class VariableExtractorVisitor implements ExpressionVisitor<void> {
  final Set<String> variables = {};
  final Set<String> gridEntries = {};

  @override
  void visitNumberExpression(NumberExpression expression) {}

  @override
  void visitVariableExpression(VariableExpression expression) {
    variables.add(expression.name);
  }

  @override
  void visitBinaryExpression(BinaryExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
  }

  @override
  void visitUnaryExpression(UnaryExpression expression) {
    expression.right.accept(this);
  }

  @override
  void visitGroupingExpression(GroupingExpression expression) {
    expression.expression.accept(this);
  }

  @override
  void visitGridEntryExpression(GridEntryExpression expression) {
    gridEntries.add('${expression.gridId}.${expression.entryId}');
  }
}
