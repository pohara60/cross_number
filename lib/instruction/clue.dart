import '../clue.dart';
import '../variable.dart';

/// A [InstructionPuzzle] clue
class InstructionClue extends Clue {
  InstructionClue({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class InstructionEntry extends InstructionClue with EntryMixin {
  InstructionEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
