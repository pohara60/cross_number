import '../clue.dart';
import '../variable.dart';

/// A [DiceNetsPuzzle] clue
class DiceNetsClue extends ExpressionClue {
  DiceNetsClue({
    required String name,
    VariableType type = VariableType.C,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve);
}

class DiceNetsEntry extends DiceNetsClue with EntryMixin {
  DiceNetsEntry({
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
