import '../expression.dart';
import '../grid.dart';
import '../set.dart';
import '../variable.dart';

class FactorsCell extends Cell with Expression {
  var expDesc = '';
  final _variableRefs = VariableRefList();
  List<String> get variableReferences => _variableRefs.variableNames;

  Set<int>? _values;

  FactorsCell(
    row,
    col, [
    face = '',
  ]) : super(row, col, face);
  String toString() =>
      super.toString() +
      ',$expDesc=${_values != null ? _values!.toShortString() : 'null'}';

  void setExp(String cellExpresssion) {
    expDesc = cellExpresssion;
    initExpression(expDesc, '', name, _variableRefs);
  }
}
