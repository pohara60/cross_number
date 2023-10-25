import '../clue.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class KnightsVariable extends Variable {
  KnightsVariable(letter) : super(letter.$1) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class KnightsPuzzle
    extends VariablePuzzle<KnightsClue, KnightsEntry, KnightsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  KnightsPuzzle() : super(null) {
    EntryMixin.maxDigit = 6;
  }
  KnightsPuzzle.grid(List<String> gridString) : super.grid(null, gridString) {
    EntryMixin.maxDigit = 6;
  }

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
