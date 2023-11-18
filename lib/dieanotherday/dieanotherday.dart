library dieanotherday;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the DieAnotherDay API.
class DieAnotherDay extends Crossnumber<DieAnotherDayPuzzle> {
  late DieAnotherDayPuzzle puzzleTop;
  late DieAnotherDayPuzzle puzzleFront;
  late DieAnotherDayPuzzle puzzleRight;

  var gridStringTop = [
    '+--+--+--+--+',
    '|1 :2 :3 :4 |',
    '+::+::+::+::+',
    '|5 :  :  :  |',
    '+::+::+::+::+',
    '|6 :  :  :  |',
    '+::+::+::+::+',
    '|7 :  :  :  |',
    '+--+--+--+--+',
  ];
  var gridStringFront = [
    '+--+--+--+--+',
    '|1 :2 :3 :4 |',
    '+::+::+::+::+',
    '|5 :  :  :  |',
    '+::+::+::+::+',
    '|6 :  :  :  |',
    '+::+::+::+::+',
    '|7 :  :  :  |',
    '+--+--+--+--+',
  ];
  var gridStringRight = [
    '+--+--+--+--+',
    '|1 :2 :3 :4 |',
    '+::+::+::+::+',
    '|5 :  :  :  |',
    '+::+::+::+::+',
    '|6 :  :  :  |',
    '+::+::+::+::+',
    '|7 :  :  :  |',
    '+--+--+--+--+',
  ];

  DieAnotherDay() {
    puzzleTop = DieAnotherDayPuzzle.grid(gridStringTop);
    puzzleFront = DieAnotherDayPuzzle.grid(gridStringFront);
    puzzleRight = DieAnotherDayPuzzle.grid(gridStringRight);
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    // Create variables once

    var letters = [
      ('A', 21, 99),
      ('W', 1, 16),
      ('X', 1, 16),
      ('Y', 1, 16),
      ('Z', 1, 16),
    ];
    var variables = <DieAnotherDayVariable>[];
    for (var letter in letters) {
      variables.add(DieAnotherDayVariable(letter));
    }

    for (var puzzle in [puzzleTop]) {
      this.puzzles.add(puzzle);

      var clueErrors = '';
      void clueWrapper({String? name, int? length, String? valueDesc}) {
        try {
          var clue = DieAnotherDayEntry(
              name: name!,
              length: length,
              valueDesc: valueDesc,
              solve: solveDieAnotherDayClue);
          puzzle.addEntry(clue);
          return;
        } on ExpressionError catch (e) {
          clueErrors += e.msg + '\n';
          return;
        }
      }

      if (puzzle == puzzleTop) {
        clueWrapper(name: 'A1', length: 4, valueDesc: r'#square - Y^2');
        clueWrapper(name: 'A4', length: 4, valueDesc: r'');
        clueWrapper(name: 'A5', length: 4, valueDesc: r'');
        clueWrapper(name: 'A6', length: 4, valueDesc: r'$multiple A');
        clueWrapper(name: 'A7', length: 4, valueDesc: r'#square');
        clueWrapper(name: 'D1', length: 4, valueDesc: r'#power3');
        clueWrapper(name: 'D2', length: 4, valueDesc: r'$multiple X*Y');
        clueWrapper(name: 'D3', length: 4, valueDesc: r'$multiple X*Y');
        clueWrapper(name: 'D4', length: 4, valueDesc: r'');
        clueWrapper(name: 'D5', length: 4, valueDesc: r'');
      }
      if (puzzle == puzzleFront) {
        clueWrapper(name: 'A1', length: 4, valueDesc: r'');
        clueWrapper(name: 'A5', length: 4, valueDesc: r'');
        clueWrapper(name: 'A6', length: 4, valueDesc: r'');
        clueWrapper(name: 'A7', length: 4, valueDesc: r'#square');
        clueWrapper(name: 'D1', length: 4, valueDesc: r'#square + W*Y*Z');
        clueWrapper(name: 'D3', length: 4, valueDesc: r'$sumdigits * X');
        clueWrapper(name: 'D4', length: 4, valueDesc: r'$power3');
      }
      if (puzzle == puzzleRight) {
        clueWrapper(name: 'A1', length: 4, valueDesc: r'');
        clueWrapper(name: 'A5', length: 4, valueDesc: r'A^2 - W');
        clueWrapper(name: 'A6', length: 4, valueDesc: r'');
        clueWrapper(name: 'A7', length: 4, valueDesc: r'#square');
        clueWrapper(name: 'D1', length: 4, valueDesc: r'');
        clueWrapper(name: 'D2', length: 4, valueDesc: r'$multiple (X + Z)');
        clueWrapper(name: 'D3', length: 4, valueDesc: r'');
        clueWrapper(name: 'D4', length: 4, valueDesc: r'');
      }

      if (clueErrors != '') {
        throw PuzzleException(clueErrors);
      }

      // Not needed when create entries from grid
      puzzle.validateEntriesFromGrid();

      puzzle.addDigitIdentityFromGrid();

      // Add variables to puzzle
      for (var variable in variables) {
        puzzle.letters[variable.name] = variable;
      }

      var clueError = '';
      // clueError = puzzle.checkClueEntryReferences();
      clueError = puzzle.checkClueClueReferences();
      // clueError += puzzle.checkEntryClueReferences();
      // clueError += puzzle.checkEntryEntryReferences();
      // Check variabes last, as prceeding may update them
      clueError += puzzle.checkVariableReferences();
      if (clueError != '') throw PuzzleException(clueError);
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
  bool solveDieAnotherDayClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as DieAnotherDayPuzzle;
    var clue = v as DieAnotherDayClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
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

  @override
  bool updateClues(
      DieAnotherDayPuzzle puzzle, String clueName, Set<int> possibleValues,
      [bool isEntry = false]) {
    var updated = super.updateClues(puzzle, clueName, possibleValues, isEntry);
    return updated;
  }
}
