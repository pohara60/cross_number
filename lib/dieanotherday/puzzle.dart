import '../clue.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'dieanotherday.dart';

// Numbers < 200 that are a power of a prime number

class DieAnotherDayVariable extends Variable {
  DieAnotherDayVariable(letter) : super(letter.$1) {
    values = {
      for (var i = letter.$2; i <= letter.$3; i++)
        if (!letter.$4.contains(i)) i
    };
  }
  String get letter => name;
}

class DieAnotherDayPuzzle extends VariablePuzzle<DieAnotherDayClue,
    DieAnotherDayEntry, DieAnotherDayVariable> {
  final DieAnotherDay dieAnotherDay;
  final checkVariables = <DieAnotherDayVariable>[];
  // Puzzle has Letter variables that are restricted to values 1..9
  DieAnotherDayPuzzle(this.dieAnotherDay,
      {String name = '', List<DieAnotherDayVariable>? check})
      : super(null, name: name) {
    if (check != null) checkVariables.addAll(check);
  }
  DieAnotherDayPuzzle.fromGridString(
      this.dieAnotherDay, List<String> gridString,
      {String name = '', List<DieAnotherDayVariable>? check})
      : super.fromGridString([1, 2, 3, 4, 5, 6], gridString, name: name) {
    if (check != null) checkVariables.addAll(check);
  }

  @override
  int iterate([Function? callback]) {
    return iterateValues(dieAnotherDay.callback);
  }

  @override
  bool clueValuesMatch(Clue clue, int value) {
    if (!super.clueValuesMatch(clue, value)) return false;
    return dieAnotherDay.facesMatch(this, clue, value);
  }

  @override
  bool checkSolution() {
    var ok = super.checkSolution();
    if (!ok) return ok;

    ok = dieAnotherDay.checkSolution(this);
    if (!ok) return ok;

    // Check variables
    dieAnotherDay.getPuzzleDigitCount(this);
    var allUpdatedVariables = <Variable>{};
    ok = dieAnotherDay.checkPuzzleVariables(
        this, allUpdatedVariables, false, true);
    return ok;
  }
}
