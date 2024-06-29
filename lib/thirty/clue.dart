import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class ThirtyClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  ThirtyClue(
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
      var v = value ~/ powers[digit + 4 - length!] % 10;
      digits.add(v);
    }
    return digits.toList()..sort();
  }
}

class ThirtyEntry extends ThirtyClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  String puzzleName;

  ThirtyEntry(
      {required String name,
      VariableType type = VariableType.E,
      required int? length,
      String? valueDesc,
      SolveFunction? solve,
      entryNames,
      String this.puzzleName = ''})
      : super(
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
    digits.clear(); // Clear for reset
    // possible digits are even 0..8, except cannot have leading 0
    for (var d = 0; d < this.length!; d++) {
      digits.add(Set.from(List.generate(5, (index) => index * 2)));
      if (d == 0) digits[d].remove(0);
    }
  }

  @override
  String toString() =>
      super.toString().replaceFirst('name=$name', 'name=$puzzleName$name');
}
