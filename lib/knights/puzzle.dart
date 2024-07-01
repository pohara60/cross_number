import '../clue.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class KnightsVariable extends Variable {
  KnightsVariable(letter) : super(letter.$1) {
    values = <int>{};
  }
  String get letter => name;
}

class KnightsPuzzle
    extends VariablePuzzle<KnightsClue, KnightsEntry, KnightsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  KnightsPuzzle() : super(null) {
    EntryMixin.maxDigit = 6;
  }
  KnightsPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString) {
    EntryMixin.maxDigit = 6;
  }

  @override
  postProcessing([bool iteration = true, int Function(Puzzle)? callback]) {
    return super.postProcessing(false, callback);
  }
}
