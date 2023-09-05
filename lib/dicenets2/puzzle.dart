import '../puzzle.dart';
import '../dicenets2/clue.dart';

import '../clue.dart';
import '../variable.dart';

class DiceNetsPuzzle
    extends VariablePuzzle<DiceNetsClue, DiceNetsEntry, Variable> {
  DiceNetsPuzzle() : super([]) {
    EntryMixin.maxDigit = 6;
  }
  DiceNetsPuzzle.grid(List<String> gridString) : super.grid([], gridString) {
    EntryMixin.maxDigit = 6;
  }
}
