import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

class ChessboardVariable extends Variable {
  ChessboardVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class ChessboardPuzzle extends VariablePuzzle<ChessboardClue, ChessboardEntry,
    ChessboardVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  ChessboardPuzzle() : super(null);
  ChessboardPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString);
}
