import '../clue.dart';
import '../variable.dart';

/// A [WheelsPuzzle] clue
class WheelsClue extends ExpressionClue {
  WheelsClue(
      {required String name,
      required int? length,
      String? valueDesc,
      SolveFunction? solve})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {}
}

class WheelsEntry extends WheelsClue with EntryMixin {
  WheelsEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
