import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class CombinationsVariable extends Variable {
  CombinationsVariable(super.letter) {
    values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  }
  String get letter => name;
}

class CombinationsPuzzle extends VariablePuzzle<CombinationsClue,
    CombinationsEntry, CombinationsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  CombinationsPuzzle({String name = ''}) : super(null, name: name);
  CombinationsPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}
