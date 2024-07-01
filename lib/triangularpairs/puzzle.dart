import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class TriangularPairsVariable extends Variable {
  TriangularPairsVariable(super.letter) {
    values = <int>{};
  }
  String get letter => name;
}

class TriangularPairsPuzzle extends VariablePuzzle<TriangularPairsClue,
    TriangularPairsEntry, TriangularPairsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  TriangularPairsPuzzle({String name = ''}) : super(null, name: name);
  TriangularPairsPuzzle.fromGridString(List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name);
}
