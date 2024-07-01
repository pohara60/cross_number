import './clue.dart';
import '../puzzle.dart';
import '../variable.dart';

class PandigitalsVariable extends Variable {
  PandigitalsVariable(super.letter);
  String get letter => name;
}

class PandigitalsPuzzle extends VariablePuzzle<PandigitalsClue,
    PandigitalsEntry, PandigitalsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  PandigitalsPuzzle() : super(null);
  PandigitalsPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString);
}
