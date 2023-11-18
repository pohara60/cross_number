import '../clue.dart';
import '../variable.dart';

/// A [DistancingPuzzle] clue
class DistancingClue extends Clue {
  DistancingClue({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}

class DistancingEntry extends DistancingClue with EntryMixin {
  DistancingEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
