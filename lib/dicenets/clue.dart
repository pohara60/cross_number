import 'package:crossnumber/clue.dart';

import '../variable.dart';

/// A [DiceNetsPuzzle] clue
class DiceNetsClue extends Clue {
  DiceNetsClue({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class DiceNetsEntry extends DiceNetsClue with EntryMixin {
  DiceNetsEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
