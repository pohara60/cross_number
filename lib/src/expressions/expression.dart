/// The base class for all expression nodes in the syntax tree.
///
/// This class uses the Visitor pattern to allow for different operations
/// to be performed on the expression tree, such as evaluation or variable extraction.
// ignore_for_file: constant_identifier_names

abstract class Expression {
  /// Accepts a [visitor] and calls the appropriate visit method.
  R accept<R>(ExpressionVisitor<R> visitor, {required int min, required int max});
}

/// A visitor for [Expression] nodes.
///
/// This interface defines a method for each type of expression node.
abstract class ExpressionVisitor<R> {
  R visitNumberExpression(NumberExpression expression, {required int min, required int max});
  R visitVariableExpression(VariableExpression expression, {required int min, required int max});
  R visitBinaryExpression(BinaryExpression expression, {required int min, required int max});
  R visitUnaryExpression(UnaryExpression expression, {required int min, required int max});
  R visitGroupingExpression(GroupingExpression expression, {required int min, required int max});
  R visitGridEntryExpression(GridEntryExpression expression, {required int min, required int max});
  R visitGeneratorExpression(GeneratorExpression expression, {required int min, required int max});
}

/// An expression node representing a literal number.
class NumberExpression extends Expression {
  final num value;

  NumberExpression(this.value);

  @override
  R accept<R>(ExpressionVisitor<R> visitor, {required int min, required int max}) {
    return visitor.visitNumberExpression(this, min: min, max: max);
  }
}

/// An expression node representing a variable.
class VariableExpression extends Expression {
  final String name;

  VariableExpression(this.name);

  @override
  R accept<R>(ExpressionVisitor<R> visitor, {required int min, required int max}) {
    return visitor.visitVariableExpression(this, min: min, max: max);
  }
}

/// An expression node representing a generator.
class GeneratorExpression extends Expression {
  final String name;

  GeneratorExpression(this.name);

  @override
  R accept<R>(ExpressionVisitor<R> visitor, {required int min, required int max}) {
    return visitor.visitGeneratorExpression(this, min: min, max: max);
  }
}

/// An expression node representing a binary operation.
class BinaryExpression extends Expression {
  final Expression left;
  final Token operator;
  final Expression right;

  BinaryExpression(this.left, this.operator, this.right);

  @override
  R accept<R>(ExpressionVisitor<R> visitor, {required int min, required int max}) {
    return visitor.visitBinaryExpression(this, min: min, max: max);
  }
}

/// An expression node representing a unary operation.
class UnaryExpression extends Expression {
  final Token operator;
  final Expression right;

  UnaryExpression(this.operator, this.right);

  @override
  R accept<R>(ExpressionVisitor<R> visitor, {required int min, required int max}) {
    return visitor.visitUnaryExpression(this, min: min, max: max);
  }
}

/// An expression node representing a grouping of expressions.
class GroupingExpression extends Expression {
  final Expression expression;

  GroupingExpression(this.expression);

  @override
  R accept<R>(ExpressionVisitor<R> visitor, {required int min, required int max}) {
    return visitor.visitGroupingExpression(this, min: min, max: max);
  }
}

/// An expression node representing a reference to a grid entry.
class GridEntryExpression extends Expression {
  final String gridId;
  final String entryId;

  GridEntryExpression(this.gridId, this.entryId);

  @override
  R accept<R>(ExpressionVisitor<R> visitor, {required int min, required int max}) {
    return visitor.visitGridEntryExpression(this, min: min, max: max);
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
  HASH,

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
  void visitNumberExpression(NumberExpression expression, {required int min, required int max}) {}

  @override
  void visitVariableExpression(VariableExpression expression, {required int min, required int max}) {
    variables.add(expression.name);
  }

  @override
  void visitBinaryExpression(BinaryExpression expression, {required int min, required int max}) {
    expression.left.accept(this, min: min, max: max);
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitUnaryExpression(UnaryExpression expression, {required int min, required int max}) {
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitGroupingExpression(GroupingExpression expression, {required int min, required int max}) {
    expression.expression.accept(this, min: min, max: max);
  }

  @override
  void visitGridEntryExpression(GridEntryExpression expression, {required int min, required int max}) {
    gridEntries.add('${expression.gridId}.${expression.entryId}');
  }

  @override
  void visitGeneratorExpression(GeneratorExpression expression, {required int min, required int max}) {
    // TODO: Handle generator expressions if needed for variable extraction.
  }
}