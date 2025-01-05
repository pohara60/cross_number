import 'package:crossnumber/generators.dart';

import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class AbsurdVariable extends Variable {
  AbsurdVariable(super.letter) {
    values = Set.from(twoDigitPrimes);
    values!.addAll([2, 3, 5, 7]);
  }
  String get letter => name;
}

class AbsurdPuzzle
    extends VariablePuzzle<AbsurdClue, AbsurdEntry, AbsurdVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  AbsurdPuzzle({String name = ''}) : super(null, name: name);
  AbsurdPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}
