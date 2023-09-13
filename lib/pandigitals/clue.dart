import '../clue.dart';

/// A [Puzzle] clue
class PandigitalsClue extends VariableClue {
  PandigitalsClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class PandigitalsEntry extends PandigitalsClue with EntryMixin {
  PandigitalsEntry({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
