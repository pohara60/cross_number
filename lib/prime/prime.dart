/// An API for solving Letters puzzles.
library sequences;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Prime Cuts API.
class Prime extends Crossnumber<PrimePuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+--+--+',
    '|1 :  :2 :  :3 |4 :  :5 :  :6 |',
    '+::+--+::+--+::+::+--+::+--+::+',
    '|  |7 :  :  :  :  |8 :  :  :  |',
    '+::+::+::+--+::+::+::+::+--+::+',
    '|9 :  :  :  |10:  :  :  :  :  |',
    '+--+::+::+--+--+::+::+::+--+::+',
    '|11|  |  |12:13:  |  |14:15:  |',
    '+::+::+--+::+::+::+::+--+::+::+',
    '|16:  :17|  |18:  :  |19|  |  |',
    '+::+--+::+::+::+--+--+::+::+--+',
    '|20:  :  :  :  :21|22:  :  :23|',
    '+::+--+::+::+::+::+--+::+::+::+',
    '|24:  :  :  |25:  :  :  :  |  |',
    '+::+--+::+--+::+::+--+::+--+::+',
    '|26:  :  :  :  |27:  :  :  :  |',
    '+--+--+--+--+--+--+--+--+--+--+',
  ];

  Prime() {
    puzzle = PrimePuzzle.grid(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, Function? solve}) {
      try {
        var entry = PrimeEntry(
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
        length: 5,
        valueDesc: r"353*√D21 + 239*√D17 = 521*√D21 + 181*√D17",
        solve: solvePrimeClue);
    clueWrapper(
        name: 'A4',
        length: 5,
        valueDesc: r"67*A14 + 41*A16",
        solve: solvePrimeClue);
    clueWrapper(
        name: 'A7',
        length: 5,
        valueDesc: r"263*√D8 + 317*A16 = 113*D1 + 467*√D8",
        solve: solvePrimeClue);
    clueWrapper(
        name: 'A8',
        length: 4,
        valueDesc: r"11*A14+2*D1",
        solve: solvePrimeClue);
    clueWrapper(name: 'A9', length: 4, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(
        name: 'A10',
        length: 6,
        valueDesc: r"17*A1 + 181*D15",
        solve: solvePrimeClue);
    clueWrapper(name: 'A12', length: 3, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(name: 'A14', length: 3, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(name: 'A16', length: 3, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(
        name: 'A18', length: 3, valueDesc: r"#square", solve: solvePrimeClue);
    clueWrapper(
        name: 'A20',
        length: 6,
        valueDesc: r"359*A9 + 599*A14 = 479*D23+251*d12",
        solve: solvePrimeClue);
    clueWrapper(name: 'A22', length: 4, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(name: 'A24', length: 4, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(
        name: 'A25',
        length: 5,
        valueDesc: r"167*A12 + 113*√D8 = 53*√D21 + 383*D23",
        solve: solvePrimeClue);
    clueWrapper(
        name: 'A26',
        length: 5,
        valueDesc: r"5*D5 + 3*D8 = 199*√D1 + 2*A22",
        solve: solvePrimeClue);
    clueWrapper(
        name: 'A27',
        length: 5,
        valueDesc: r"5*D8 + 79*√D21",
        solve: solvePrimeClue);

    clueWrapper(
        name: 'D1', length: 3, valueDesc: r"#square", solve: solvePrimeClue);
    clueWrapper(name: 'D2', length: 4, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(name: 'D3', length: 3, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(
        name: 'D4',
        length: 5,
        valueDesc: r"7*D3 + 2*A24",
        solve: solvePrimeClue);
    clueWrapper(name: 'D5', length: 4, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(
        name: 'D6',
        length: 5,
        valueDesc: r"13*A16 + 277*D3",
        solve: solvePrimeClue);
    clueWrapper(
        name: 'D7',
        length: 4,
        valueDesc: r"19*√D1 + 2*D2",
        solve: solvePrimeClue);
    clueWrapper(
        name: 'D8', length: 4, valueDesc: r"#square", solve: solvePrimeClue);
    clueWrapper(
        name: 'D11',
        length: 5,
        valueDesc: r"641*√D1 + 229*D3",
        solve: solvePrimeClue);
    clueWrapper(name: 'D12', length: 4, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(
        name: 'D13',
        length: 5,
        valueDesc: r"127*√A18 + 5*D19",
        solve: solvePrimeClue);
    clueWrapper(name: 'D15', length: 4, valueDesc: r"", solve: solvePrimeClue);
    clueWrapper(
        name: 'D17', length: 4, valueDesc: r"#square", solve: solvePrimeClue);
    clueWrapper(
        name: 'D19',
        length: 4,
        valueDesc: r"13*√D8 + 7*D21",
        solve: solvePrimeClue);
    clueWrapper(
        name: 'D21', length: 3, valueDesc: r"#square", solve: solvePrimeClue);
    clueWrapper(name: 'D23', length: 3, valueDesc: r"", solve: solvePrimeClue);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();
    puzzle.addDigitIdentityFromGrid();

    var clueError = puzzle.checkClueClueReferences();
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
  bool solvePrimeClue(PrimeClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables) {
    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables, validClue);
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
