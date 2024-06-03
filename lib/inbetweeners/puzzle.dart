import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class InbetweenersVariable extends Variable {
  InbetweenersVariable(letter) : super(letter) {
    this.values = Set.from([
      2,
      3,
      5,
      7,
      11,
      13,
      17,
      19,
      23,
      29,
    ]);
  }
  String get letter => this.name;
}

class InbetweenersPuzzle extends VariablePuzzle<InbetweenersClue,
    InbetweenersEntry, InbetweenersVariable> {
  // Puzzle has Letter variables that are restricted to the first 10 primes
  InbetweenersPuzzle({String name = ''}) : super(null, name: name);
  InbetweenersPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  bool checkSolution() {
    if (!super.checkSolution()) return false;
    if (!checkFrequencyAllDigits()) return false;
    return true;
  }

  bool checkFrequencyAllDigits() {
    var digits = getAllDigits();
    if (digits == null) return false;
    var set = Set.from(digits);
    var frequencies =
        set.map<int>((e) => digits.where((element) => element == e).length);
    print('frequencies=$frequencies');
    var frequencySet = Set.from(frequencies);
    return frequencySet.length == 1;
  }
}
