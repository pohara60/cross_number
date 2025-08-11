import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class DecisionsClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  // Dave actual values, and reversed values, in separate sets
  Set<int>? possibleValue;
  Set<int>? reversedValue;

  DecisionsClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.addDesc,
      super.solve,
      super.entryNames});
}

class DecisionsEntry extends DecisionsClue with EntryMixin {
  DecisionsEntry({
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
