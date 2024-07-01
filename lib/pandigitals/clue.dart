import '../clue.dart';
import '../variable.dart';

/// A [Puzzle] clue
class PandigitalsClue extends VariableClue {
  PandigitalsClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    super.valueDesc,
    super.solve,
  });
}

class PandigitalsEntry extends PandigitalsClue with EntryMixin {
  PandigitalsEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
