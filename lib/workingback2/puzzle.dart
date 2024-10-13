import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class WorkingBack2Variable extends Variable {
  WorkingBack2Variable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class WorkingBack2Puzzle extends VariablePuzzle<WorkingBack2Clue,
    WorkingBack2Entry, WorkingBack2Variable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  WorkingBack2Puzzle({String name = ''}) : super(null, name: name);
  WorkingBack2Puzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  String toSummary() {
    var text = super.toSummary();

    // Get middle 3 values
    var finished = true;
    var values = <int>[];
    for (var r = 1; r < grid!.numRows - 1; r++) {
      var value = 0;
      for (var c = 1; c < grid!.numCols - 1; c++) {
        var digit = grid!.rows[r][c].entryDigit;
        // if (digit == 0) {
        //   finished = false;
        //   break;
        // }
        value = value * 10 + digit;
      }
      // if (!finished) break;
      values.add(value);
    }

    /// v1 = a+b
    /// v2 = b+c
    /// v3 = c+a
    /// v1-v2+v3 = 2a
    /// v2-v3+v1 = 2b
    /// v2-v1+v2 = 2c
    if (finished) {
      var v1 = values[0];
      var v2 = values[1];
      var v3 = values[2];
      var a = (v1 - v2 + v3) ~/ 2;
      var b = (v2 - v3 + v1) ~/ 2;
      var c = (v3 - v1 + v2) ~/ 2;
      text += 'a=$a, b=$b, c=$c, a+b+c=${a + b + c}';
    }
    return text;
  }
}
