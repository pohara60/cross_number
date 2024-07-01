import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class IncreasingPrimeClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  IncreasingPrimeClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.solve,
      super.entryNames});
}

class IncreasingPrimeEntry extends IncreasingPrimeClue with EntryMixin {
  /// List of referenced primes
  @override
  List<String> get letterReferences => variableNameReferences;
  @override
  addLetterReference(String letter) => addVariableReference(letter);

  IncreasingPrimeEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
    super.entryNames,
  }) {
    initEntry(this);
  }

  @override
  void initDigits() {
    super.initDigits();
    // possible digits are 1..9
    for (var d = 0; d < length!; d++) {
      digits[d].remove(0);
    }
  }
}
