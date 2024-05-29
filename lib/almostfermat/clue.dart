import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class AlmostFermatClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  AlmostFermatClue(
      {required String name,
      VariableType type = VariableType.C,
      required int? length,
      String? valueDesc,
      List<String>? addDesc,
      SolveFunction? solve,
      List<String>? entryNames})
      : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solve,
            entryNames: entryNames);
}

class AlmostFermatEntry extends AlmostFermatClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  AlmostFermatEntry({
    required String name,
    VariableType type = VariableType.E,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
    entryNames,
  }) : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve,
            entryNames: entryNames) {
    initEntry(this);
  }
}
