import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class CoupletsVariable extends Variable {
  CoupletsVariable(letter) : super(letter.$1) {
    values = <int>{};
  }
  String get letter => name;
}

class CoupletsPuzzle
    extends VariablePuzzle<CoupletsClue, CoupletsEntry, CoupletsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  CoupletsPuzzle({String name = ''}) : super(null, name: name);
  CoupletsPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}
