import 'package:crossnumber/generators.dart';

import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class TransformationVariable extends Variable {
  TransformationVariable(super.letter) {
    // The 28 letters in the clues stand for different cubes that are greater
    // than 1 and less than 100,000
    values = Set.from(getCubesInRange(2, 99999));
  }
  String get letter => name;
}

class TransformationPuzzle extends VariablePuzzle<TransformationClue,
    TransformationEntry, TransformationVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  TransformationPuzzle({String name = ''}) : super(null, name: name);
  TransformationPuzzle.fromGridString(List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name);
}
