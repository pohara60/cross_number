import '../sequences/clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number
const variableValues = [
  1,
  2,
  3,
  4,
  5,
  7,
  8,
  9,
  11,
  13,
  16,
  17,
  19,
  23,
  25,
  27,
  29,
  31,
  32,
  37,
  41,
  43,
  47,
  49,
  53,
  59,
  61,
  64,
  67,
  71,
  73,
  79,
  81,
  83,
  89,
  97,
  101,
  103,
  107,
  109,
  113,
  121,
  125,
  127,
  128,
  131,
  137,
  139,
  149,
  151,
  157,
  163,
  167,
  169,
  173,
  179,
  181,
  191,
  193,
  197,
  199
];

class SequenceVariable extends Variable {
  SequenceVariable(letter) : super(letter) {
    this.values = Set.from(variableValues);
  }
  String get letter => this.name;
}

class SequencesPuzzle
    extends VariablePuzzle<SequencesClue, SequencesEntry, SequenceVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  SequencesPuzzle() : super(List.from(variableValues));
  SequencesPuzzle.grid(List<String> gridString)
      : super.grid(List.from(variableValues), gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
