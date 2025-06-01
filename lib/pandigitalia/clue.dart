import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class PandigitaliaClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  PandigitaliaClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.addDesc,
      super.solve,
      super.entryNames});
}

class PandigitaliaEntry extends PandigitaliaClue with EntryMixin {
  PandigitaliaEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
    super.entryNames,
  }) {
    EntryMixin.zeroDigit = false;
    initEntry(this);
  }
}
