import '../letters/clue.dart';
import '../puzzle.dart';
import '../variable.dart';

class LetterVariable extends Variable {
  LetterVariable(letter) : super(letter) {
    this.values = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  }
  String get letter => this.name;
}

class LettersPuzzle
    extends VariablePuzzle<LettersClue, LettersEntry, LetterVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  LettersPuzzle() : super(List.from([1, 2, 3, 4, 5, 6, 7, 8, 9]));
  LettersPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(
            List.from([1, 2, 3, 4, 5, 6, 7, 8, 9]), gridString);
}
