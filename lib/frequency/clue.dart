import '../clue.dart';
import '../variable.dart';

/// A [FrequencyPuzzle] clue
class FrequencyClue extends Clue {
  FrequencyClue({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class FrequencyEntry extends FrequencyClue with EntryMixin {
  FrequencyEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
