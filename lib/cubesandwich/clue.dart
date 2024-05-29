import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class CubeSandwichClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  CubeSandwichClue(
      {required String name,
      VariableType type = VariableType.C,
      required int? length,
      String? valueDesc,
      SolveFunction? solve,
      List<String>? entryNames})
      : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve,
            entryNames: entryNames);
}

class CubeSandwichEntry extends CubeSandwichClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  CubeSandwichEntry({
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
