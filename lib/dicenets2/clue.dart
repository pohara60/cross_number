import '../clue.dart';
import '../variable.dart';

/// A [DiceNetsPuzzle] clue
class DiceNetsClue extends ExpressionClue {
  DiceNetsClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    super.valueDesc,
    super.solve,
  });
}

class DiceNetsEntry extends DiceNetsClue with EntryMixin {
  DiceNetsEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
