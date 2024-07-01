import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class InbetweenersClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  InbetweenersClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.addDesc,
      super.solve,
      super.entryNames});
}

class InbetweenersEntry extends InbetweenersClue with EntryMixin {
  /// List of referenced primes
  @override
  List<String> get letterReferences => variableNameReferences;
  @override
  addLetterReference(String letter) => addVariableReference(letter);

  InbetweenersEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.addDesc,
    super.solve,
    super.entryNames,
  }) {
    initEntry(this);
  }
}
