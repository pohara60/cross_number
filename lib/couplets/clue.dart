import 'package:powers/powers.dart';

import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class CoupletsClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  CoupletsClue(
      {required super.name,
      super.type = VariableType.C,
      required int? length,
      bool? isDouble,
      super.valueDesc,
      super.addDesc,
      super.solve,
      super.entryNames})
      : super(length: isDouble != null && isDouble ? null : length) {
    if (isDouble != null && isDouble) {
      // Couplets clues are sum of two values of "length"
      min = 2 * (10.pow(length! - 1) as int);
      max = 2 * ((10.pow(length) as int) - 1);
    }
  }
}

class CoupletsEntry extends CoupletsClue with EntryMixin {
  /// List of referenced primes
  @override
  List<String> get letterReferences => variableNameReferences;
  @override
  addLetterReference(String letter) => addVariableReference(letter);

  CoupletsEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
    super.entryNames,
  }) {
    initEntry(this);
  }
}
