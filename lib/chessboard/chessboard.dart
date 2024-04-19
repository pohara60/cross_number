/// An API for solving Letters puzzles.
library sequences;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Chessboard API.
class Chessboard extends Crossnumber<ChessboardPuzzle> {
  var gridString = [
    '+--+--+--+--+',
    '|1 :  |2 :3 |',
    '+::+--+::+::+',
    '|4 :5 :  |  |',
    '+::+::+--+::+',
    '|  |6 :7 :  |',
    '+--+::+::+--+',
    '|8 :  |9 :  |',
    '+--+--+--+--+',
  ];

  Chessboard() {
    puzzle = ChessboardPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, SolveFunction? solve}) {
      try {
        var entry = ChessboardEntry(
            name: name!, length: length, valueDesc: valueDesc, solve: solve);
        puzzle.addEntry(entry);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(
        name: 'A1',
        length: 2,
        valueDesc: r"#sumdigits",
        solve: solveChessboardClue);
    clueWrapper(
        name: 'A2',
        length: 2,
        valueDesc: r"#prime",
        solve: solveChessboardClue);
    clueWrapper(
        name: 'A4',
        length: 3,
        valueDesc: r"$multiple A8",
        solve: solveChessboardClue);
    clueWrapper(
        name: 'A6',
        length: 3,
        valueDesc: r"$divisor D5",
        solve: solveChessboardClue);
    clueWrapper(
        name: 'A8',
        length: 2,
        valueDesc: r"#square",
        solve: solveChessboardClue);
    clueWrapper(
        name: 'A9',
        length: 2,
        valueDesc: r"A8 = A1 % #result",
        solve: solveChessboardClue);

    clueWrapper(
        name: 'D1',
        length: 3,
        valueDesc: r"#square - A4",
        solve: solveChessboardClue);
    clueWrapper(
        name: 'D2',
        length: 2,
        valueDesc: r"$dp A6",
        solve: solveChessboardClue);
    clueWrapper(
        name: 'D3',
        length: 3,
        valueDesc: r"#square",
        solve: solveChessboardClue);
    clueWrapper(
        name: 'D5',
        length: 3,
        valueDesc: r"#palindrome",
        solve: solveChessboardClue);
    clueWrapper(
        name: 'D7',
        length: 2,
        valueDesc: r"$multiple A9",
        solve: solveChessboardClue);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();
    puzzle.linkEntriesToGrid();

    var clueError = puzzle.checkClueClueReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveChessboardClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as ChessboardPuzzle;
    var clue = v as ChessboardClue;
    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables!, validClue);
    } else {
      // Values may have been set by other Clue
      if (clue.values != null) {
        var values =
            clue.values!.where((value) => validClue(clue, value, [], []));
        possibleValue.addAll(values);
      }
    }
    return updated;
  }

  // Override solveClue to check chessboard
  @override
  bool solveClue(Clue clue) {
    var updated = super.solveClue(clue);
    if (updated) {
      // Check entry digits for chessboard
      var entry = clue.entry as ChessboardEntry?;
      if (entry != null) {
        for (var d = 0; d < entry.length!; d++) {
          if (entry.digits[d].length == 1) {
            // Chessboard logic
            // Remove the digit from similarly shaded squares
            var value = entry.digits[d].first;
            if (entry.row != null && entry.col != null) {
              // Is the digit square even or odd?
              var mod = (entry.row! + entry.col! + d) % 2;
              var index = entry.cellDigitIndex(d);
              for (var otherClue
                  in puzzle.clues.values.where((element) => element != entry)) {
                var otherEntry = otherClue.entry as ChessboardEntry;
                var otherUpdated = false;
                for (var d = 0; d < otherEntry.length!; d++) {
                  var otherMod = (otherEntry.row! + otherEntry.col! + d) % 2;
                  if (otherMod != mod) {
                    // Check not the same cell
                    if (otherEntry.cellDigitIndex(d) != index) {
                      if (otherEntry.digits[d].remove(value)) {
                        otherUpdated = true;
                        if (otherEntry.digits[d].isEmpty) {
                          throw SolveException(
                              'Chessboard ${entry.name} removing $value from entry ${otherEntry.name} leaves no valid digits!');
                        }
                      }
                    }
                  }
                }
                if (otherUpdated) {
                  // Add Entry clue to solve queue
                  addToUpdateQueue(otherEntry);
                }
              }
            }
          }
        }
      }
    }
    return updated;
  }
}
