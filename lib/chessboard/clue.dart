import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class ChessboardClue extends ExpressionClue {
  ChessboardClue({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class ChessboardEntry extends ChessboardClue with EntryMixin {
  ChessboardEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
