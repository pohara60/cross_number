import './clue.dart';
import '../puzzle.dart';
import '../variable.dart';

class PandigitalsVariable extends Variable {
  PandigitalsVariable(letter) : super(letter);
  String get letter => this.name;
}

class PandigitalsPuzzle extends VariablePuzzle<PandigitalsClue,
    PandigitalsEntry, PandigitalsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  PandigitalsPuzzle() : super(null);
  PandigitalsPuzzle.grid(List<String> gridString)
      : super.grid(null, gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
