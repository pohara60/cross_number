import '../clue.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class Knights2Variable extends Variable {
  Knights2Variable(letter) : super(letter.$1) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class Knights2Puzzle
    extends VariablePuzzle<Knights2Clue, Knights2Entry, Knights2Variable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  Knights2Puzzle() : super(null) {
    EntryMixin.maxDigit = 6;
    EntryMixin.zeroDigit = false;
  }
  Knights2Puzzle.fromGridString(List<String> gridString)
      : super.fromGridString(null, gridString) {
    EntryMixin.maxDigit = 6;
    EntryMixin.zeroDigit = false;
  }

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
