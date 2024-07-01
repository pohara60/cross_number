import '../clue.dart';
import '../variable.dart';

/// A [InstructionPuzzle] clue
class InstructionClue extends Clue {
  InstructionClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    super.valueDesc,
    super.solve,
  });
}

class InstructionEntry extends InstructionClue with EntryMixin {
  InstructionEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
