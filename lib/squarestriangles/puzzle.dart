import 'dart:math';
import 'package:collection/collection.dart';

import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class SquaresTrianglesVariable extends Variable {
  SquaresTrianglesVariable(letter) : super(letter) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class SquaresTrianglesPuzzle extends VariablePuzzle<SquaresTrianglesClue,
    SquaresTrianglesEntry, SquaresTrianglesVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  SquaresTrianglesPuzzle({String name = ''}) : super(null, name: name);
  SquaresTrianglesPuzzle.fromGridString(List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name) {
    this.distinctClues = false;
  }

  // Iteration generates duplicate solutions, so filter them
  var previousSolutions = <Set<int>>{};

  @override
  bool checkSolution() {
    if (!super.checkSolution()) return false;

    // Check that Down Entry values do not need n or n+1 that is already used
    var pairs = ['A1', 'D14', 'D4', 'A6', 'D5', 'D9'];
    for (var clue in clues.values) {
      if (clue.isAcross) continue;
      // Pairs allow duplicates
      if (pairs.contains(clue.name)) continue;

      var knownValues = getKnownValues(clue);
      var entry = entries[clue.name]!;
      var n = sqrt(entry.value! * 2).toInt();
      var nPlus1 = n + 1;
      if (knownValues.contains(n) || knownValues.contains(nPlus1)) {
        return false;
      }
    }

    // Check for duplicate solution
    var thisSolution = entries.values.map((e) => e.value!).toSet();
    for (var previousSolution in previousSolutions) {
      if (SetEquality().equals(previousSolution, thisSolution)) {
        return false;
      }
    }
    previousSolutions.add(thisSolution);
    return true;
  }

  Set<int> getKnownValues(SquaresTrianglesClue clue) {
    SquaresTrianglesClue? otherClue = getPairClue(clue);
    return clues.values
        .where((c) => c != clue && c != otherClue && c.isSet)
        .map((e) => e.value!)
        .toSet();
  }

  SquaresTrianglesClue? getPairClue(SquaresTrianglesClue clue) {
    var pairs = ['A1', 'D14', 'D4', 'A6', 'D5', 'D9'];
    var index = pairs.indexOf(clue.name);
    if (index == -1) return null;
    var otherIndex = index % 2 == 0 ? index + 1 : index - 1;
    var otherClue = clues[pairs[otherIndex]]!;
    return otherClue;
  }
}
