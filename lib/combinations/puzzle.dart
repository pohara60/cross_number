import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class CombinationsVariable extends Variable {
  CombinationsVariable(letter) : super(letter) {
    this.values = Set.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  }
  String get letter => this.name;
}

class CombinationsPuzzle extends VariablePuzzle<CombinationsClue,
    CombinationsEntry, CombinationsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  CombinationsPuzzle({String name = ''}) : super(null, name: name);
  CombinationsPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString(null, gridString, name: name);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
