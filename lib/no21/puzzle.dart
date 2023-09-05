import '../no21/clue.dart';
import '../puzzle.dart';
import '../variable.dart';

import '../clue.dart';

const VARIABLE_VALUES = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
];

class No21Variable extends Variable {
  No21Variable(letter) : super(letter) {
    this.values = Set.from(VARIABLE_VALUES);
  }
  String get letter => this.name;
}

class No21Puzzle extends VariablePuzzle<No21Clue, No21Entry, No21Variable> {
  // Puzzle has Letter variables that are restricted to values 0..16
  late final VariableList variableList;
  No21Puzzle() : super(List.from(VARIABLE_VALUES)) {
    EntryMixin.maxDigit = 16;
  }
  No21Puzzle.grid(List<String> gridString)
      : super.grid(List.from(VARIABLE_VALUES), gridString) {
    EntryMixin.maxDigit = 16;
  }

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingValues => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleValues) =>
      variableList.updateVariables(letter, possibleValues);
}
