import 'package:crossnumber/clue.dart';

/// A [WheelsPuzzle] clue
class WheelsClue extends ExpressionClue {
  WheelsClue({required name, required length, valueDesc, solve})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {}
}

class WheelsEntry extends WheelsClue with EntryMixin {
  WheelsEntry({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
