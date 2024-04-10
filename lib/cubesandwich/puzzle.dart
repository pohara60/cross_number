import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class CubeSandwichVariable extends Variable {
  CubeSandwichVariable(letter) : super(letter.$1) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class CubeSandwichPuzzle extends VariablePuzzle<CubeSandwichClue,
    CubeSandwichEntry, CubeSandwichVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  CubeSandwichPuzzle() : super(null);
  CubeSandwichPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(null, gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
