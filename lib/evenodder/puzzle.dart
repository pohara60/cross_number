import '../evenodder/clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number
const variableValues = [
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31,
  32,
  33,
];

class EvenOdderVariable extends Variable {
  late EvenOdderVariable _link;
  EvenOdderVariable(letter) : super(letter) {
    this.values = Set.from(variableValues);
  }
  String get letter => this.name;

  @override
  bool updatePossible(Set<int> possibleValues) {
    var updated = super.updatePossible(possibleValues);
    if (updated) {
      // Update corresponding Across/Down variable
      var otherValues = <int>{};
      for (var value in this.values!) {
        // Even add one, odd sutract one
        var otherValue = value + (value % 2 == 0 ? 1 : -1);
        otherValues.add(otherValue);
      }
      this._link.updatePossible(otherValues);
    }
    return updated;
  }

  static void link(EvenOdderVariable letter, EvenOdderVariable letter2) {
    letter._link = letter2;
    letter2._link = letter;
  }
}

class EvenOdderPuzzle
    extends VariablePuzzle<EvenOdderClue, EvenOdderEntry, EvenOdderVariable> {
  // Puzzle has Letter variables with restricted values
  late final VariableList variableList;
  EvenOdderPuzzle() : super(List.from(variableValues));
  EvenOdderPuzzle.grid(List<String> gridString)
      : super.grid(List.from(variableValues), gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
