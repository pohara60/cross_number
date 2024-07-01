import '../no21/clue.dart';
import '../puzzle.dart';
import '../variable.dart';

import '../clue.dart';

// ignore: constant_identifier_names
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
  No21Variable(super.letter) {
    values = Set.from(VARIABLE_VALUES);
  }
  String get letter => name;
}

class No21Puzzle extends VariablePuzzle<No21Clue, No21Entry, No21Variable> {
  // Puzzle has Letter variables that are restricted to values 0..16
  No21Puzzle() : super(List.from(VARIABLE_VALUES)) {
    EntryMixin.maxDigit = 16;
  }
  No21Puzzle.fromGridString(List<String> gridString)
      : super.fromGridString(List.from(VARIABLE_VALUES), gridString) {
    EntryMixin.maxDigit = 16;
  }

  Map<String, Variable> get letters => variableList.variables;
  @override
  List<int> get remainingValues => variableList.restrictedValues!;
  Set<Variable> updateLetters(String letter, Set<int> possibleValues) =>
      variableList.updateVariables(letter, possibleValues);
}
