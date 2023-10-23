import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class ColumnsVariable extends Variable {
  ColumnsVariable(letter) : super(letter.$1) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class ColumnsPuzzle extends VariablePuzzle<ColumnsClue, ColumnsEntry, ColumnsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  ColumnsPuzzle() : super(null);
  ColumnsPuzzle.grid(List<String> gridString) : super.grid(null, gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}