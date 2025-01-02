import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class NeedleMatchVariable extends Variable {
  NeedleMatchVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class NeedleMatchPuzzle extends VariablePuzzle<NeedleMatchClue, NeedleMatchEntry, NeedleMatchVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  NeedleMatchPuzzle({String name = ''}) : super(null, name: name);
  NeedleMatchPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}