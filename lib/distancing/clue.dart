import '../clue.dart';
import '../variable.dart';

/// A [DistancingPuzzle] clue
class DistancingClue extends Clue {
  DistancingClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    super.valueDesc,
    super.solve,
  });
}

class DistancingEntry extends DistancingClue with EntryMixin {
  DistancingEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
