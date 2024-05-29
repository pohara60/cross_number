import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class PrimeVariable extends Variable {
  PrimeVariable(letter) : super(letter) {
    this.values = {};
  }
  String get letter => this.name;
}

class PrimePuzzle extends VariablePuzzle<PrimeClue, PrimeEntry, PrimeVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  PrimePuzzle() : super(null);
  PrimePuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(null, gridString);
}
