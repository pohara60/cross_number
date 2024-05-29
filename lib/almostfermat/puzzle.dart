import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class AlmostFermatVariable extends Variable {
  AlmostFermatVariable(letter) : super(letter.$1) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class AlmostFermatPuzzle extends VariablePuzzle<AlmostFermatClue,
    AlmostFermatEntry, AlmostFermatVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  AlmostFermatPuzzle() : super(null);
  AlmostFermatPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(null, gridString) {
    distinctClues = false;
  }

  @override
  bool uniqueSolution() {
    // Puzzle has multiple clue values
    // if (this
    //     .clues
    //     .values
    //     .any((clue) => clue.values == null || clue.values!.length != 3))
    //   return false;
    if (this
        .entries
        .values
        .any((entry) => entry.values == null || entry.values!.length != 1))
      return false;
    return true;
  }
}
