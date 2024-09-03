import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class NumeriItalianoVariable extends Variable {
  NumeriItalianoVariable(super.letter) {
    values = Set.from({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13});
  }
  String get letter => name;
}

class NumeriItalianoPuzzle extends VariablePuzzle<NumeriItalianoClue,
    NumeriItalianoEntry, NumeriItalianoVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  NumeriItalianoPuzzle({String name = ''}) : super(null, name: name);
  NumeriItalianoPuzzle.fromGridString(List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name);
}
