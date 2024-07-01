import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class CubeSandwichClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  CubeSandwichClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.solve,
      super.entryNames});
}

class CubeSandwichEntry extends CubeSandwichClue with EntryMixin {
  /// List of referenced primes
  @override
  List<String> get letterReferences => variableNameReferences;
  @override
  addLetterReference(String letter) => addVariableReference(letter);

  CubeSandwichEntry({
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
