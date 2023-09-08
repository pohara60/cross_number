/// An API for solving Letters puzzles.
library sequences;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
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
    puzzle = ChessboardPuzzle.grid(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, Function? solve}) {
      try {
        var entry = ChessboardEntry(
            name: name, length: length, valueDesc: valueDesc, solve: solve);
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
    puzzle.addDigitIdentityFromGrid();

    var clueError = puzzle.checkClueReferences();
    if (clueError != '') throw PuzzleException(clueError);

    if (Crossnumber.traceInit) {
      print(puzzle.toString());
    }
  }

  // Validate possible clue value
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!clue.digitsMatch(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveChessboardClue(ChessboardClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables) {
    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, possibleValue, possibleVariables, validClue);
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
}
