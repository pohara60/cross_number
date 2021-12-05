import 'package:crossnumber/frequency/clue.dart';
import 'package:crossnumber/puzzle.dart';

class FrequencyPuzzle extends Puzzle<FrequencyClue> {
  FrequencyPuzzle();

  bool checkSolution() {
    if (!super.checkSolution()) return false;
    if (!checkFrequencyAllDigits()) return false;
    return true;
  }

  bool checkFrequencyAllDigits() {
    var digits = getAllDigits();
    if (digits == null) return false;
    var set = Set.from(digits);
    var frequencies = <int>[];
    for (var digit in set) {
      var count = digits.where((element) => element == digit).length;
      if (digit % 2 == 0 && count % 2 == 1) return false;
      if (digit % 2 == 1 && count % 2 == 0) return false;
      if (frequencies.contains(count)) return false;
      frequencies.add(count);
    }
    return true;
  }

  List<int>? getAllDigits() {
    var digits = <int>[];
    // Do not double count digits that appear in Across and Down clues
    var index = 0;
    for (var clue in this.clues.values) {
      if (clues.values == null || clue.values!.length != 1) return null;
      var value = clue.values!.first.toString();
      // Get all digits of Across clues
      for (var d = 0; d < clue.length; d++) {
        var digit = int.parse(value[d]);
        // Exclude digits of Down clues that intersect with Across clues
        if (clue.name[0] == 'D') {
          if (clue.digitIdentities[d] != null) digit = 0;
        }
        digits.add(digit);
      }
      index++;
    }
    return digits;
  }
}
