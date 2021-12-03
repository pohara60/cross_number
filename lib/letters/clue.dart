import 'package:crossnumber/clue.dart';
import 'package:crossnumber/set.dart';

/// A [LettersPuzzle] clue
class LettersClue extends VariableClue {
  /// List of referenced primes
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  LettersClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}
