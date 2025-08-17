import 'package:crossnumber/src/expressions/expression.dart';

class VariableVisitor implements ExpressionVisitor<void> {
  final Set<String> _variables = {};

  Set<String> get variables => _variables;

  @override
  void visitBinaryExpression(BinaryExpression expression,
      {required num min, required num max}) {
    expression.left.accept(this, min: min, max: max);
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitGroupingExpression(GroupingExpression expression,
      {required num min, required num max}) {
    expression.expression.accept(this, min: min, max: max);
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
    _variables.add(expression.name);
  }

  @override
  void visitGeneratorExpression(GeneratorExpression expression,
      {required num min, required num max}) {}

  @override
  void visitGridEntryExpression(GridEntryExpression expression,
      {required num min, required num max}) {}

  @override
  void visitMonadicExpression(MonadicExpression expression,
      {required num min, required num max}) {
    expression.right.accept(this, min: min, max: max);
  }
}
