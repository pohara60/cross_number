import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class DifferentClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);
  final int difference;

  DifferentClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      required this.difference,
      super.addDesc,
      super.solve,
      super.entryNames});
}

class DifferentEntry extends DifferentClue with EntryMixin {
  DifferentEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.difference = 0,
    super.solve,
    super.entryNames,
  }) {
    initEntry(this);
  }
}
