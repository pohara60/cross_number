import 'package:crossnumber/clue.dart';

/// A [InstructionPuzzle] clue
class No21Clue extends ExpressionClue {
  No21Clue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class No21Entry extends No21Clue with EntryMixin {
  No21Entry({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
