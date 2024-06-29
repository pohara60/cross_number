import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class SquaresTrianglesClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  SquaresTrianglesClue(
      {required String name,
      VariableType type = VariableType.C,
      required int? length,
      String? valueDesc,
      List<String>? addDesc,
      SolveFunction? solve,
      List<String>? entryNames})
      : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solve,
            entryNames: entryNames);

  @override
  String toString() {
    var text = super.toString();
    if (variableType == VariableType.C) {
      text += ', min=$min, max=$max';
    }
    return text;
  }
}

class SquaresTrianglesEntry extends SquaresTrianglesClue with EntryMixin {
  /// List of referenced primes
  List<String> get letterReferences => this.variableNameReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  SquaresTrianglesEntry({
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
