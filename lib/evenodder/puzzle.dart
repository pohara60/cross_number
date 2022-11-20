import 'package:crossnumber/evenodder/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/variable.dart';

// Numbers < 200 that are a power of a prime number
const variableValues = [
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
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31,
  32,
  33,
];

class EvenOdderVariable extends Variable {
  EvenOdderVariable(letter) : super(letter) {
    this.values = Set.from(variableValues);
  }
  String get letter => this.name;
}

class EvenOdderPuzzle extends VariablePuzzle<EvenOdderClue, EvenOdderVariable> {
  // Puzzle has Letter variables with restricted values
  late final VariableList variableList;
  EvenOdderPuzzle() : super(List.from(variableValues));
  EvenOdderPuzzle.grid(List<String> gridString)
      : super.grid(List.from(variableValues), gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
