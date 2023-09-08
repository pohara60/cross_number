import '../clue.dart';

/// A Puzzle clue
class ChessboardClue extends ExpressionClue {
  ChessboardClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class ChessboardEntry extends ChessboardClue with EntryMixin {
  ChessboardEntry({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
