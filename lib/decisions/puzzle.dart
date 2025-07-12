import '../clue.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class DecisionsVariable extends Variable {
  DecisionsVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class DecisionsPuzzle
    extends VariablePuzzle<DecisionsClue, DecisionsEntry, DecisionsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  DecisionsPuzzle({String name = ''}) : super(null, name: name);
  DecisionsPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  bool checkSolution() {
    if (!super.checkSolution()) return false;
    // Check for one value and one reverded value in clues row or column
    // return true;
    for (var clue in clues.values) {
      // Get other clue in row/column
      var otherClue = clues.values.firstWhere((c) =>
          c != clue &&
          c.isAcross == clue.isAcross &&
          (c.isDown && (c as EntryMixin).col == (clue as EntryMixin).col ||
              c.isAcross && (c as EntryMixin).row == (clue as EntryMixin).row));
      // Check that each value appears once, and its reverse appears once
      var value = clue.value!;
      var otherValue = otherClue.value!;
      var ok = clue.possibleValue!.contains(value) &&
              otherClue.reversedValue!.contains(otherValue) ||
          clue.reversedValue!.contains(value) &&
              otherClue.possibleValue!.contains(otherValue);
      if (!ok) {
        return false;
      }
    }
    return true;
  }
}
