import 'package:crossnumber/letters/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/variable.dart';

class LetterVariable extends Variable {
  LetterVariable(letter) : super(letter) {
    this.values = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  }
  String get letter => this.name;
}

class LettersPuzzle extends VariablePuzzle<LettersClue, LetterVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  LettersPuzzle() : super(List.from([1, 2, 3, 4, 5, 6, 7, 8, 9]));

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
