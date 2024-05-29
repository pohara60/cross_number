import '../expression.dart';
import '../grid.dart';
import '../set.dart';
import '../variable.dart';

class FactorsCell extends Cell with Expression {
  var expDesc = '';

  FactorsCell(
    row,
    col, [
    face = '',
  ]) : super(row, col, face);

  String toString() =>
      super.toString() +
      ',$expDesc=${values != null ? values!.toShortString() : 'null'}';

  void setExp(String cellExpresssion, SolveFunction solve) {
    expDesc = cellExpresssion;
    initExpression(expDesc, '', name, variableRefs);
    this.solve = solve;
  }
}
