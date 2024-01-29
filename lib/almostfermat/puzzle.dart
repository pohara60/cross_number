import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class AlmostFermatVariable extends Variable {
  AlmostFermatVariable(letter) : super(letter.$1) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class AlmostFermatPuzzle extends VariablePuzzle<AlmostFermatClue,
    AlmostFermatEntry, AlmostFermatVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  AlmostFermatPuzzle() : super(null);
  AlmostFermatPuzzle.grid(List<String> gridString)
      : super.grid(null, gridString) {
    distinctClues = false;
  }

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  @override
  bool uniqueSolution() {
    // Puzzle has multiple clue values
    // if (this
    //     .clues
    //     .values
    //     .any((clue) => clue.values == null || clue.values!.length != 3))
    //   return false;
    if (this
        .entries
        .values
        .any((entry) => entry.values == null || entry.values!.length != 1))
      return false;
    return true;
  }
}
