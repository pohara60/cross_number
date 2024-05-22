import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class TransformationClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  TransformationClue(
      {required String name,
      required int? length,
      String? valueDesc,
      List<String>? addDesc,
      SolveFunction? solve,
      List<String>? entryNames})
      : super(
            name: name,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solve,
            entryNames: entryNames);
}

class TransformationEntry extends TransformationClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  TransformationEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
    entryNames,
  }) : super(
            name: name,
            length: length,
            valueDesc: valueDesc,
            solve: solve,
            entryNames: entryNames) {
    initEntry(this);
  }
}