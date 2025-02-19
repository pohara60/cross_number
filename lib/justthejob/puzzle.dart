import 'dart:math';

import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

var restrictedValues = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

class JustTheJobVariable extends Variable {
  JustTheJobVariable(super.letter) {
    values = Set.from(restrictedValues);
  }
  String get letter => name;
}

class JustTheJobPuzzle extends VariablePuzzle<JustTheJobClue, JustTheJobEntry,
    JustTheJobVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  JustTheJobPuzzle({String name = ''}) : super(restrictedValues, name: name);
  JustTheJobPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString(restrictedValues, gridString, name: name);

  @override
  void initVariablePuzzle(List<int>? possibleValues,
      {bool variableListInitialized = false}) {
    // Two variables may have each value
    variableList = VariableList(VariableType.V, possibleValues, 2);
    super.initVariablePuzzle(possibleValues, variableListInitialized: true);
  }
}
