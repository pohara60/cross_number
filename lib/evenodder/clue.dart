import '../clue.dart';

/// A [LettersPuzzle] clue
class EvenOdderClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  EvenOdderClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(
            name: name,
            length: length,
            valueDesc: valueDesc,
            solve: solve,
            variablePrefix: name[0]); // Prefix for Across and Down clues
}

class EvenOdderEntry extends EvenOdderClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  EvenOdderEntry({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
