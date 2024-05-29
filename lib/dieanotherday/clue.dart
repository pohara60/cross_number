import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class DieAnotherDayClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  DieAnotherDayClue(
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

  static const powers = [1000, 100, 10, 1];
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
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  DieAnotherDayEntry({
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

  @override
  void initDigits() {
    super.initDigits();
    // possible digits are 1..6
    for (var d = 0; d < this.length!; d++) {
      digits[d].remove(0);
    }
  }
}
