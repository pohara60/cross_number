import 'package:crossnumber/clue.dart';

/// A [InstructionPuzzle] clue
class InstructionClue extends Clue {
  InstructionClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}
