import '../clue.dart';
import '../variable.dart';

/// A [WheelsPuzzle] clue
class WheelsClue extends ExpressionClue {
  WheelsClue(
      {required String name,
      VariableType type = VariableType.C,
      required int? length,
      String? valueDesc,
      SolveFunction? solve})
      : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {}
}

class WheelsEntry extends WheelsClue with EntryMixin {
  WheelsEntry({
    required String name,
    VariableType type = VariableType.E,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {
    initEntry(this);
  }
}
