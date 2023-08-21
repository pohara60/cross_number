import 'package:crossnumber/clue.dart';

/// A [FrequencyPuzzle] clue
class FrequencyClue extends Clue {
  FrequencyClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class FrequencyEntry extends FrequencyClue with EntryMixin {
  FrequencyEntry({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
