import '../clue.dart';

/// A Puzzle clue
class IncreasingFibonnaciClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  IncreasingFibonnaciClue(
      {required name, required length, valueDesc, solve, entryNames})
      : super(
            name: name,
            length: length,
            valueDesc: valueDesc,
            solve: solve,
            entryNames: entryNames);
}

class IncreasingFibonnaciEntry extends IncreasingFibonnaciClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  IncreasingFibonnaciEntry({
    required name,
    required length,
    valueDesc,
    solve,
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
