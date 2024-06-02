import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

class ChessboardVariable extends Variable {
  ChessboardVariable(letter) : super(letter) {
    this.values = {};
  }
  String get letter => this.name;
}

class ChessboardPuzzle extends VariablePuzzle<ChessboardClue, ChessboardEntry,
    ChessboardVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  ChessboardPuzzle() : super(null);
  ChessboardPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString);
}
