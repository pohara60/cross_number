import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class DieAnotherDayClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  DieAnotherDayClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.solve,
      super.entryNames});

  static const powers = [1000, 100, 10, 1];
  @override
  List<int> clueDigits(int digit) {
    if (values == null) return [];
    var digits = <int>{};
    for (var value in values!) {
      var v = value ~/ powers[digit] % 10;
      digits.add(v);
    }
    return digits.toList()..sort();
  }
}

class DieAnotherDayEntry extends DieAnotherDayClue with EntryMixin {
  /// List of referenced primes
  @override
  List<String> get letterReferences => variableNameReferences;
  @override
  addLetterReference(String letter) => addVariableReference(letter);

  DieAnotherDayEntry({
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
    // possible digits are 1..6
    for (var d = 0; d < length!; d++) {
      digits[d].remove(0);
    }
  }
}
