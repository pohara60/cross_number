import 'package:crossnumber/src/expressions/expression.dart';

abstract class Expressable {
  Set<int>? get possibleValues;
  set possibleValues(Set<int>? values);
  String get id;
  Expression get expressionTree;
  List<String> get variables;
  int? get min;
  int? get max;
}
