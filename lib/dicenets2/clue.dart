import 'package:crossnumber/clue.dart';

/// A [DiceNetsPuzzle] clue
class DiceNetsClue extends VariableClue {
  DiceNetsClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}