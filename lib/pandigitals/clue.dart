import '../clue.dart';
import '../variable.dart';

/// A [Puzzle] clue
class PandigitalsClue extends VariableClue {
  PandigitalsClue({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class PandigitalsEntry extends PandigitalsClue with EntryMixin {
  PandigitalsEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
