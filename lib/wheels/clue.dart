import '../clue.dart';
import '../variable.dart';

/// A [WheelsPuzzle] clue
class WheelsClue extends ExpressionClue {
  WheelsClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.solve});
}

class WheelsEntry extends WheelsClue with EntryMixin {
  WheelsEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
