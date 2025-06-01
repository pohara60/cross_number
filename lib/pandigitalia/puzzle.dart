import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class PandigitaliaVariable extends Variable {
  PandigitaliaVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class PandigitaliaPuzzle extends VariablePuzzle<PandigitaliaClue, PandigitaliaEntry, PandigitaliaVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  PandigitaliaPuzzle({String name = ''}) : super(null, name: name);
  PandigitaliaPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}