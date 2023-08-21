import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/dicenets2/clue.dart';

import '../clue.dart';
import '../variable.dart';

class DiceNetsPuzzle
    extends VariablePuzzle<DiceNetsClue, DiceNetsEntry, Variable> {
  DiceNetsPuzzle() : super([]) {
    Clue.maxDigit = 6;
  }
  DiceNetsPuzzle.grid(List<String> gridString) : super.grid([], gridString) {
    Clue.maxDigit = 6;
  }
}
