import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class AbsurdClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  AbsurdClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.addDesc,
      super.solve,
      super.entryNames});
}

class AbsurdEntry extends AbsurdClue with EntryMixin {
  AbsurdEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
    super.entryNames,
  }) {
    initEntry(this);
  }
}