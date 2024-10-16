import 'package:trotter/trotter.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class MagicArrayVariable extends Variable {
  MagicArrayVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class MagicArrayPuzzle extends VariablePuzzle<MagicArrayClue, MagicArrayEntry,
    MagicArrayVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  MagicArrayPuzzle({String name = ''}) : super(null, name: name);
  MagicArrayPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  bool checkSolution() {
    if (!super.checkSolution()) return false;

    // Debug - Check any known answers
    // for (var clue in clues.values) {
    //   if (clue.answer != null && clue.value != clue.answer) {
    //     return false;
    //   }
    // }

    // if any five cells are chosen, each from a different row and column, then
    // the digits they contain sum to the same number
    // So far the centre digit is unknown.
    var ok = true;
    var grid = this.grid!;
    final bagOfItems = List.generate(grid.numRows, (index) => index),
        permutations = Permutations(bagOfItems.length, bagOfItems);
    for (final permutation in permutations()) {
      //print(permutation);
      var expectedSum = -1;
      var expectedMiddleDigit = -1;
      var sum = 0;
      var middleDigit = false;
      for (var r = 0; r < grid.numRows; r++) {
        var c = permutation[r];
        if (r == grid.numRows ~/ 2 && c == grid.numCols ~/ 2) {
          // Middle digit
          middleDigit = true;
        } else {
          var digit = grid.rows[r][c].entryDigit;
          sum += digit;
        }
      }
      if (expectedSum == -1) {
        expectedSum = sum;
      } else if (middleDigit) {
        if (expectedMiddleDigit == -1) {
          expectedMiddleDigit = expectedSum - sum;
          if (expectedMiddleDigit < 0 || expectedMiddleDigit > 9) {
            ok = false;
            break;
          }
        } else {
          if (expectedSum != sum + expectedMiddleDigit) {
            ok = false;
            break;
          }
        }
      } else {
        if (expectedSum != sum) {
          ok = false;
          break;
        }
      }
    }
    return ok;
  }
}

void main() {
  final bagOfItems = [0, 1, 2, 3, 4],
      permutations = Permutations(bagOfItems.length, bagOfItems);
  for (final permutation in permutations()) {
    print(permutation);
  }
}
