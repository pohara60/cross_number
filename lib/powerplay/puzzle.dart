import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class PowerPlayVariable extends Variable {
  PowerPlayVariable(letter) : super(letter.$1) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class PowerPlayPuzzle
    extends VariablePuzzle<PowerPlayClue, PowerPlayEntry, PowerPlayVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  PowerPlayPuzzle() : super(null);
  PowerPlayPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(null, gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
