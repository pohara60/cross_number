import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class IncreasingFibonnaciVariable extends Variable {
  IncreasingFibonnaciVariable(letter) : super(letter.$1) {
    values = <int>{};
  }
  String get letter => name;
}

class IncreasingFibonnaciPuzzle extends VariablePuzzle<IncreasingFibonnaciClue,
    IncreasingFibonnaciEntry, IncreasingFibonnaciVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  IncreasingFibonnaciPuzzle() : super(null);
  IncreasingFibonnaciPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString);
}
