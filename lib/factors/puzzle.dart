import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class FactorsVariable extends Variable {
  FactorsVariable(letter) : super(letter) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class FactorsPuzzle extends VariablePuzzle<FactorsClue, FactorsEntry, FactorsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  FactorsPuzzle({String name = ''}) : super(null, name: name);
  FactorsPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString(null, gridString, name: name);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}