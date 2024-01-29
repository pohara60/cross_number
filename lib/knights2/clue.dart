import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class Knights2Clue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  Knights2Clue(
      {required String name, required int? length, String? valueDesc, SolveFunction? solve, List<String>? entryNames})
      : super(
            name: name,
            length: length,
            valueDesc: valueDesc,
            solve: solve,
            entryNames: entryNames);
}

class Knights2Entry extends Knights2Clue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  Knights2Entry({
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