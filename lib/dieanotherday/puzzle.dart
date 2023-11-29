import '../clue.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'dieanotherday.dart';

// Numbers < 200 that are a power of a prime number

class DieAnotherDayVariable extends Variable {
  DieAnotherDayVariable(letter) : super(letter.$1) {
    this.values = Set.from([
      for (var i = letter.$2; i <= letter.$3; i++)
        if (!letter.$4.contains(i)) i
    ]);
  }
  String get letter => this.name;
}

class DieAnotherDayPuzzle extends VariablePuzzle<DieAnotherDayClue,
    DieAnotherDayEntry, DieAnotherDayVariable> {
  final DieAnotherDay dieAnotherDay;
  final checkVariables = <DieAnotherDayVariable>[];
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  DieAnotherDayPuzzle(this.dieAnotherDay,
      {String name = '', List<DieAnotherDayVariable>? check})
      : super(null, name: name) {
    if (check != null) checkVariables.addAll(check);
  }
  DieAnotherDayPuzzle.grid(this.dieAnotherDay, List<String> gridString,
      {String name = '', List<DieAnotherDayVariable>? check})
      : super.grid([1, 2, 3, 4, 5, 6], gridString, name: name) {
    if (check != null) checkVariables.addAll(check);
  }

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

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
    dieAnotherDay.getPuzzleDigitCountFromClues(this);
    var allUpdatedVariables = <String>{};
    ok = dieAnotherDay.checkPuzzleVariables(
        this, allUpdatedVariables, false, true);
    return ok;
  }
}
