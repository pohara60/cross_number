import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class ThirtyClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  ThirtyClue(
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
      var v = value ~/ powers[digit + 4 - length!] % 10;
      digits.add(v);
    }
    return digits.toList()..sort();
  }
}

class ThirtyEntry extends ThirtyClue with EntryMixin {
  /// List of referenced primes
  @override
  List<String> get letterReferences => variableNameReferences;
  @override
  addLetterReference(String letter) => addVariableReference(letter);

  String puzzleName;

  ThirtyEntry(
      {required super.name,
      super.type = VariableType.E,
      required super.length,
      super.valueDesc,
      super.solve,
      super.entryNames,
      this.puzzleName = ''}) {
    initEntry(this);
  }

  @override
  void initDigits() {
    digits.clear(); // Clear for reset
    // possible digits are even 0..8, except cannot have leading 0
    for (var d = 0; d < length!; d++) {
      digits.add(Set.from(List.generate(5, (index) => index * 2)));
      if (d == 0) digits[d].remove(0);
    }
  }

  @override
  String toString() =>
      super.toString().replaceFirst('name=$name', 'name=$puzzleName$name');
}
