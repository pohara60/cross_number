import '../clue.dart';

/// A Puzzle clue
class IncreasingPrimeClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  IncreasingPrimeClue(
      {required name, required length, valueDesc, solve, entryNames})
      : super(
            name: name,
            length: length,
            valueDesc: valueDesc,
            solve: solve,
            entryNames: entryNames);
}

class IncreasingPrimeEntry extends IncreasingPrimeClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  IncreasingPrimeEntry({
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

  @override
  void initDigits() {
    super.initDigits();
    // possible digits are 1..9
    for (var d = 0; d < this.length!; d++) {
      digits[d].remove(0);
    }
  }
}
