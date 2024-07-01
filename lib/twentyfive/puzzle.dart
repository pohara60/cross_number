import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class TwentyFiveVariable extends Variable {
  TwentyFiveVariable(letter) : super(letter.$1) {
    values = <int>{};
  }
  String get letter => name;
}

class TwentyFivePuzzle extends VariablePuzzle<TwentyFiveClue, TwentyFiveEntry,
    TwentyFiveVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  TwentyFivePuzzle({String name = ''}) : super(null, name: name);
  TwentyFivePuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}
