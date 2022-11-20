import 'package:crossnumber/clue.dart';

/// A [LettersPuzzle] clue
class EvenOdderClue extends VariableClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  EvenOdderClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}
