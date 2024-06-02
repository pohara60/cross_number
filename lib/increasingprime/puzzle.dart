import 'package:crossnumber/crossnumber.dart';

import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class IncreasingPrimeVariable extends Variable {
  IncreasingPrimeVariable(letter) : super(letter.$1) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class IncreasingPrimePuzzle extends VariablePuzzle<IncreasingPrimeClue,
    IncreasingPrimeEntry, IncreasingPrimeVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  IncreasingPrimePuzzle() : super(null);
  IncreasingPrimePuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString);

  @override
  postProcessing([bool iteration = false, int Function(Puzzle)? callback]) {
    // Prevent iteration as too slow
    Crossnumber.traceSolve = false;
    super.postProcessing(true, callback);
  }
}
