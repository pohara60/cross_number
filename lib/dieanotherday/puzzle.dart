import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class DieAnotherDayVariable extends Variable {
  DieAnotherDayVariable(letter) : super(letter.$1) {
    this.values = Set.from([for (var i = letter.$2; i <= letter.$3; i++) i]);
  }
  String get letter => this.name;
}

class DieAnotherDayPuzzle extends VariablePuzzle<DieAnotherDayClue,
    DieAnotherDayEntry, DieAnotherDayVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  DieAnotherDayPuzzle() : super(null);
  DieAnotherDayPuzzle.grid(List<String> gridString)
      : super.grid(null, gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
