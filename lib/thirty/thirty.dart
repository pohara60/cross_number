library thirty;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Thirty API.
class Thirty extends Crossnumber<ThirtyPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 |2 |  |3 |4 |',
    '+--+--+--+--+--+',
    '|  |5 |6 |  |  |',
    '+--+--+--+--+--+',
    '|7 |  |8 |  |  |',
    '+--+--+--+--+--+',
  ];

  Thirty() {
    initCrossnumber();
  }

  void initCrossnumber() {
    for (var i = 0; i < 2; i++) {
      var puzzle =
          ThirtyPuzzle.grid(gridString, name: i == 0 ? 'Left' : 'Right');
      this.puzzles.add(puzzle);

      // Get entries from grid
      var entryErrors = '';
      for (var entrySpec in puzzle.getEntriesFromGrid()) {
        try {
          var entry = ThirtyEntry(
            name: entrySpec.name,
            length: entrySpec.length,
            solve: solveThirtyClue,
          );
          puzzle.addEntry(entry);
        } on ExpressionInvalid catch (e) {
          entryErrors += e.msg + '\n';
        }
      }

      if (entryErrors != '') {
        throw PuzzleException(entryErrors);
      }

      puzzle.addDigitIdentityFromGrid();
    }

    super.initCrossnumber();
  }

  @override
  void solve([bool iteration = true]) {
    super.solve(iteration);
  }

  // Validate possible clue value
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (value < 0) return false;
    if (clue.min != null && value < clue.min!) return false;
    if (clue.max != null && value > clue.max!) return false;
    if (clue.values != null && !clue.values!.contains(value)) return false;
    if (!clue.digitsMatch(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveThirtyClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as ThirtyPuzzle;
    var clue = v as ThirtyClue;
    var updated = false;
    // Values may have been set by other Clue
    if (clue.values != null) {
      var values =
          clue.values!.where((value) => validClue(clue, value, [], []));
      possibleValue.addAll(values);
    }
    return updated;
  }

  @override
  bool updateClues(
      ThirtyPuzzle puzzle, String clueName, Set<int> possibleValues,
      [bool isEntry = false]) {
    var updated = super.updateClues(puzzle, clueName, possibleValues, isEntry);
    if (updated) {
      // Maintain clue value order
      // var clue = puzzle.clues[clueName]!;
      // var newMin = clue.values!.reduce(min);
      // if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      // var newMax = clue.values!.reduce(max);
      // if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // // Clues are defined in ascending order of value
      // for (var otherClue in puzzle.clues.values) {
      //   if (romanToDecimal(otherClue.name) > romanToDecimal(clue.name)) {
      //     if ((otherClue.min == null || otherClue.min! <= clue.min!)) {
      //       otherClue.min = clue.min! + 1;
      //     }
      //   }
      //   if (romanToDecimal(otherClue.name) < romanToDecimal(clue.name)) {
      //     if ((otherClue.max == null || otherClue.max! >= clue.max!)) {
      //       otherClue.max = clue.max! - 1;
      //     }
      //   }
      // }
    }
    return updated;
  }
}
