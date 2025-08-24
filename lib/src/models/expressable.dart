import 'package:crossnumber/src/expressions/expression.dart';
import 'package:crossnumber/src/expressions/parser.dart';

import '../expressions/evaluator.dart';
import '../expressions/variable_visitor.dart';
import 'constraint.dart';
import 'expression_constraint.dart';

abstract class Expressable {
  String get id;

  /// The set of possible integer values for this clue.
  /// This set is narrowed down by the solver as constraints are applied.
  Set<int>? _possibleValues;
  Set<int>? get possibleValues => _possibleValues;
  static bool checkAnswer = true;
  set possibleValues(Set<int>? values) {
    if (checkAnswer) _checkAnswer(values);
    _possibleValues = values;
  }

  int? get min => possibleValues == null || possibleValues!.isEmpty
      ? null
      : possibleValues!.reduce((a, b) => a < b ? a : b);

  int? get max => possibleValues == null || possibleValues!.isEmpty
      ? null
      : possibleValues!.reduce((a, b) => a > b ? a : b);

  /// The expression trees from the expression constraints for this expressable.
  Iterable<Constraint> get constraints;
  Iterable<ExpressionConstraint> get expressionConstraints =>
      constraints.whereType<ExpressionConstraint>();

  final expressionTrees = <Expression>[];
  Expression get expressionTree => expressionTrees.first;
  final variableLists = <List<String>>[];
  final allVariables = <String>[];
  List<String> get variables => variableLists.first;

  bool addExpression(ExpressionConstraint constraint) {
    final parser = Parser(constraint.expression);
    try {
      final expressionTree = parser.parse();
      constraint.expressionTree = expressionTree;
      final variableVisitor = VariableVisitor();
      expressionTree.accept(variableVisitor,
          min: 1, max: 1); // min, max not used here
      constraint.variables = variableVisitor.variables.toList();
      expressionTrees.add(constraint.expressionTree!);
      variableLists.add(constraint.variables);
      for (var v in constraint.variables) {
        if (!allVariables.contains(v)) {
          allVariables.add(v);
        }
      }
    } on ParseException catch (e) {
      print(
          'Error parsing expressable $id expression "${constraint.expression}": ${e.msg}');
      return false;
    }
    return true;
  }

  void addExpressionFromTree(Expression expressionTree) {
    final variableVisitor = VariableVisitor();
    expressionTree.accept(variableVisitor,
        min: 1, max: 1); // min, max not used here
    expressionTrees.add(expressionTree);
    var variableList = variableVisitor.variables.toList();
    variableLists.add(variableList);
    for (var v in variableList) {
      if (!allVariables.contains(v)) {
        allVariables.add(v);
      }
    }
  }

  /// Answer used for debugging
  /// This is not used in the solver.
  int? _answer;
  set answer(int value) {
    _answer = value;
  }

  void _checkAnswer(Set<int>? values) {
    if (values != null && _answer != null) {
      if (!values.contains(_answer)) {
        throw EvaluatorException(
            'Expressable $id: Answer $_answer is not in the possible values $values');
      }
    }
  }
}
