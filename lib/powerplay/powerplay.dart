library powerplay;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the PowerPlay API.
class PowerPlay extends Crossnumber<PowerPlayPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :  :3 :4 |',
    '+::+::+--+::+::+',
    '|5 :  |6 |7 :  |',
    '+::+::+::+::+::+',
    '|8 :  :  :  :  |',
    '+--+--+--+--+--+',
  ];

  PowerPlay() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = PowerPlayPuzzle.fromGridString(gridString);
    this.puzzles.add(puzzle);

    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = PowerPlayEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solvePowerPlayClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 5, valueDesc: r'#square');
    clueWrapper(name: 'A5', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'A8', length: 5, valueDesc: r'$power D6');
    clueWrapper(name: 'D1', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D3', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D4', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D6', length: 2, valueDesc: r'#triangular');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    // Not needed when create entries from grid
    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(PowerPlayVariable(letter));
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkPuzzleVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  @override
  void solve([bool iteration = true]) {
    super.solve(iteration);
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
  bool solvePowerPlayClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as PowerPlayPuzzle;
    var clue = v as PowerPlayClue;
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
      PowerPlayPuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry, focusClueName: focusClueName);
    return updated;
  }
}
