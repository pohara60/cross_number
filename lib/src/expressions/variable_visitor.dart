import 'package:crossnumber/src/expressions/expression.dart';

class VariableVisitor implements ExpressionVisitor<void> {
  final Set<String> _variables = {};

  Set<String> get variables => _variables;

  @override
  void visitBinaryExpression(BinaryExpression expression,
      {required int min, required int max}) {
    expression.left.accept(this, min: min, max: max);
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitGroupingExpression(GroupingExpression expression,
      {required int min, required int max}) {
    expression.expression.accept(this, min: min, max: max);
  }

  @override
  void visitNumberExpression(NumberExpression expression,
      {required int min, required int max}) {}

  @override
  void visitUnaryExpression(UnaryExpression expression,
      {required int min, required int max}) {
    expression.right.accept(this, min: min, max: max);
  }

  @override
  void visitVariableExpression(VariableExpression expression,
      {required int min, required int max}) {
    _variables.add(expression.name);
  }

  @override
  void visitGeneratorExpression(GeneratorExpression expression,
      {required int min, required int max}) {}

  @override
  void visitGridEntryExpression(GridEntryExpression expression,
      {required int min, required int max}) {}

  @override
  void visitMonadicExpression(MonadicExpression expression,
      {required int min, required int max}) {
    expression.right.accept(this, min: min, max: max);
  }
}
