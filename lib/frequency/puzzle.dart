import '../frequency/clue.dart';
import '../puzzle.dart';

class FrequencyPuzzle extends Puzzle<FrequencyClue, FrequencyEntry> {
  FrequencyPuzzle();
  FrequencyPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(gridString);

  @override
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
}
