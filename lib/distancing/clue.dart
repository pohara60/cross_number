import 'package:crossnumber/clue.dart';

/// A [DistancingPuzzle] clue
class DistancingClue extends Clue {
  DistancingClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);
}
