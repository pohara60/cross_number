import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class ThirtyVariable extends Variable {
  ThirtyVariable(letter) : super(letter.$1) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class ThirtyPuzzle
    extends VariablePuzzle<ThirtyClue, ThirtyEntry, ThirtyVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  ThirtyPuzzle() : super(null);
  ThirtyPuzzle.grid(List<String> gridString, {String name = ''})
      : super.grid(null, gridString, name: name);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
