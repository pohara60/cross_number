import 'package:crossnumber/generators.dart';

import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

class FactorsVariable extends Variable {
  FactorsVariable(letter) : super(letter) {
    this.values = Set.from([2, 3, 5, 7]);
    this.values!.addAll(twoDigitPrimes);
  }
  String get letter => this.name;
}

class FactorsPuzzle
    extends VariablePuzzle<FactorsClue, FactorsEntry, FactorsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  FactorsPuzzle({String name = ''}) : super(null, name: name);
  FactorsPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString(null, gridString, name: name);

  @override
  String toSummary() {
    var text = super.toSummary();
    text += grid!.rows.fold(
        '',
        (previousValue, row) => row.fold(previousValue,
            (previousValue, cell) => previousValue + cell.toString() + '\n'));
    return text;
  }
}
