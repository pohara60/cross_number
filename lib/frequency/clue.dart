import '../clue.dart';
import '../variable.dart';

/// A [FrequencyPuzzle] clue
class FrequencyClue extends Clue {
  FrequencyClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    super.valueDesc,
    super.solve,
  });
}

class FrequencyEntry extends FrequencyClue with EntryMixin {
  FrequencyEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
