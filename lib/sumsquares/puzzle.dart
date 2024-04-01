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
  SumSquaresVariable(letter) : super(letter) {
    this.values = Set.from(first14primes);
  }
  String get letter => this.name;
}

class SumSquaresPuzzle extends VariablePuzzle<SumSquaresClue, SumSquaresEntry,
    SumSquaresVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  SumSquaresPuzzle({String name = ''}) : super(null, name: name);
  SumSquaresPuzzle.grid(List<String> gridString, {String name = ''})
      : super.grid(null, gridString, name: name);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}