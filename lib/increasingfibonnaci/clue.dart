import 'package:crossnumber/variable.dart';

import '../clue.dart';

/// A Puzzle clue
class IncreasingFibonnaciClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  IncreasingFibonnaciClue(
      {required String name,
      required int? length,
      String? valueDesc,
      SolveFunction? solve,
      List<String>? entryNames})
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
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
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
