import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class CyclingPrimesClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  CyclingPrimesClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    super.valueDesc,
    super.addDesc,
    super.solve,
    super.entryNames,
    super.clueNames,
  });
}

class CyclingPrimesEntry extends CyclingPrimesClue with EntryMixin {
  CyclingPrimesEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
    super.entryNames,
    super.clueNames,
  }) {
    initEntry(this);
  }
}
