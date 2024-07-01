import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class ColumnsVariable extends Variable {
  ColumnsVariable(letter) : super(letter.$1) {
    values = <int>{};
  }
  String get letter => name;
}

class ColumnsPuzzle
    extends VariablePuzzle<ColumnsClue, ColumnsEntry, ColumnsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  ColumnsPuzzle() : super(null);
  ColumnsPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString);
}
