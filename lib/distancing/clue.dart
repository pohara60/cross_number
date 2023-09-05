import '../clue.dart';

/// A [DistancingPuzzle] clue
class DistancingClue extends Clue {
  DistancingClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class DistancingEntry extends DistancingClue with EntryMixin {
  DistancingEntry({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
