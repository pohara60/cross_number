import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class FourSeasonsVariable extends Variable {
  FourSeasonsVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class FourSeasonsPuzzle extends VariablePuzzle<FourSeasonsClue, FourSeasonsEntry, FourSeasonsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  FourSeasonsPuzzle({String name = ''}) : super(null, name: name);
  FourSeasonsPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}