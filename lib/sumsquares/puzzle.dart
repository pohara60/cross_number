import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

const first14primes = [
  2,
  3,
  5,
  7,
  11,
  13,
  17,
  19,
  23,
  29,
  31,
  37,
  41,
  43,
];

class SumSquaresVariable extends Variable {
  SumSquaresVariable(super.letter) {
    values = Set.from(first14primes);
  }
  String get letter => name;
}

class SumSquaresPuzzle extends VariablePuzzle<SumSquaresClue, SumSquaresEntry,
    SumSquaresVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  SumSquaresPuzzle({String name = ''}) : super(null, name: name);
  SumSquaresPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}
