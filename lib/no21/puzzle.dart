import 'package:crossnumber/no21/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/variable.dart';

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
  17
];

class No21Variable extends Variable {
  No21Variable(letter) : super(letter) {
    this.values = Set.from(VARIABLE_VALUES);
  }
  String get letter => this.name;
}

class No21Puzzle extends VariablePuzzle<No21Clue, No21Entry, No21Variable> {
  // Puzzle has Letter variables that are restricted to values 0..17
  late final VariableList variableList;
  No21Puzzle() : super(List.from(VARIABLE_VALUES));
  No21Puzzle.grid(List<String> gridString)
      : super.grid(List.from(VARIABLE_VALUES), gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingValues => variableList.remainingValues;
  Set<String> updateLetters(String letter, Set<int> possibleValues) =>
      variableList.updateVariables(letter, possibleValues);
}
