import '../puzzle.dart';
import '../dicenets/clue.dart';

import '../clue.dart';

class DiceNetsPuzzle extends Puzzle<DiceNetsClue, DiceNetsEntry> {
  DiceNetsPuzzle() {
    EntryMixin.maxDigit = 6;
  }
}
