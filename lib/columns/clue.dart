import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class ColumnsClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  ColumnsClue({
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

class ColumnsEntry extends ColumnsClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  ColumnsEntry({
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
