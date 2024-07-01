import 'clue.dart';
import '../generators.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class ABCDVariable extends Variable {
  ABCDVariable(letter) : super(letter.$1) {
    values = Set.from(generateNDigitPrimes(letter.$2));
  }
  String get letter => name;
}

class ABCDPuzzle extends VariablePuzzle<ABCDClue, ABCDEntry, ABCDVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  ABCDPuzzle() : super(null);
  ABCDPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString);
}
