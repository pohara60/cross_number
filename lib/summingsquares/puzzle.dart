import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class SummingSquaresVariable extends Variable {
  SummingSquaresVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class SummingSquaresPuzzle extends VariablePuzzle<SummingSquaresClue, SummingSquaresEntry, SummingSquaresVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  SummingSquaresPuzzle({String name = ''}) : super(null, name: name);
  SummingSquaresPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}