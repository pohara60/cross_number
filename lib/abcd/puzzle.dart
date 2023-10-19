import 'clue.dart';
import '../generators.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class ABCDVariable extends Variable {
  ABCDVariable(letter) : super(letter.$1) {
    this.values = Set.from(generateNDigitPrimes(letter.$2));
  }
  String get letter => this.name;
}

class ABCDPuzzle extends VariablePuzzle<ABCDClue, ABCDEntry, ABCDVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  ABCDPuzzle() : super(null);
  ABCDPuzzle.grid(List<String> gridString) : super.grid(null, gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
