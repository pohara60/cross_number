import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class ChessboardClue extends ExpressionClue {
  ChessboardClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    super.valueDesc,
    super.solve,
  });
}

class ChessboardEntry extends ChessboardClue with EntryMixin {
  ChessboardEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
