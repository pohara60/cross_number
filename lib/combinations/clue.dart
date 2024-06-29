import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class CombinationsClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  CombinationsClue(
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

class CombinationsEntry extends CombinationsClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  CombinationsEntry({
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
