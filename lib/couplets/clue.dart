import 'package:powers/powers.dart';

import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class CoupletsClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  CoupletsClue(
      {required String name,
      VariableType type = VariableType.C,
      required int? length,
      bool? isDouble,
      String? valueDesc,
      List<String>? addDesc,
      SolveFunction? solve,
      List<String>? entryNames})
      : super(
            name: name,
            type: type,
            length: isDouble != null && isDouble ? null : length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solve,
            entryNames: entryNames) {
    if (isDouble != null && isDouble) {
      // Couplets clues are sum of two values of "length"
      min = 2 * (10.pow(length! - 1) as int);
      max = 2 * ((10.pow(length) as int) - 1);
    }
  }
}

class CoupletsEntry extends CoupletsClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  CoupletsEntry({
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
}
