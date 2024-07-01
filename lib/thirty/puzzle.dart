import '../clue.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'thirty.dart';

// Numbers < 200 that are a power of a prime number

class ThirtyVariable extends Variable {
  ThirtyVariable(letter) : super(letter.$1) {
    values = <int>{};
  }
  String get letter => name;
}

class ThirtyPuzzle
    extends VariablePuzzle<ThirtyClue, ThirtyEntry, ThirtyVariable> {
  final Thirty thirty;
  // Puzzle has Letter variables that are restricted to values 1..9
  ThirtyPuzzle(this.thirty) : super(null);
  ThirtyPuzzle.fromGridString(this.thirty, List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  bool clueValuesMatch(Clue clue, int value) {
    var match = super.clueValuesMatch(clue, value);
    // Check value in other puzzle?
    return match;
  }

  @override
  int iterate([Function? callback]) {
    return iterateValues(thirty.callback);
  }

  int sumdigits() {
    var sum = 0;
    for (var entry in entries.isNotEmpty ? entries.values : clues.values) {
      var digits = entry.entryMixin!.digitsFromValue;
      for (var d = entry.length! - 1; d >= 0; d--) {
        // Avoid double-counting overlapping digits
        // If trying value then cannot use digits
        if (digits[d].length > 1) return -1;
        var digit = digits[d].first;
        if (entry.isAcross ||
            entry.isDown && entry.digitIdentities[d] == null) {
          sum += digit;
        }
      }
    }
    return sum;
  }
}
