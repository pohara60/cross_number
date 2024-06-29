import '../clue.dart';
import '../variable.dart';

/// A [LettersPuzzle] clue
class SequencesClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  SequencesClue({
    required String name,
    VariableType type = VariableType.C,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve);
}

class SequencesEntry extends SequencesClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  SequencesEntry({
    required String name,
    VariableType type = VariableType.E,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {
    initEntry(this);
  }
}
