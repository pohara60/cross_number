import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class SquaresTrianglesClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  SquaresTrianglesClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.addDesc,
      super.solve,
      super.entryNames});

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
  @override
  List<String> get letterReferences => variableNameReferences;
  @override
  addLetterReference(String letter) => addVariableReference(letter);

  SquaresTrianglesEntry({
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
