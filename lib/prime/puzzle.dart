import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class PrimeVariable extends Variable {
  PrimeVariable(letter) : super(letter) {
    this.values = {};
  }
  String get letter => this.name;
}

class PrimePuzzle extends VariablePuzzle<PrimeClue, PrimeEntry, PrimeVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  PrimePuzzle() : super(null);
  PrimePuzzle.grid(List<String> gridString) : super.grid(null, gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
