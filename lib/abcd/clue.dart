import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class ABCDClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  ABCDClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    super.valueDesc,
    super.solve,
  });
}

class ABCDEntry extends ABCDClue with EntryMixin {
  /// List of referenced primes
  @override
  List<String> get letterReferences => variableNameReferences;
  @override
  addLetterReference(String letter) => addVariableReference(letter);

  ABCDEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
