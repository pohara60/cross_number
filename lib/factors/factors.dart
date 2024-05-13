library factors;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'grid.dart';
import 'puzzle.dart';

/// Provide access to the Factors API.
class Factors extends Crossnumber<FactorsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :3 |4 :5 |',
    '+::+::+::+::+::+',
    '|6 :  |7 :  :  |',
    '+--+::+--+--+::+',
    '|8 :  |  |9 :  |',
    '+::+--+--+::+--+',
    '|10:11:12|13:14|',
    '+::+::+::+::+::+',
    '|15:  |16:  :  |',
    '+--+--+--+--+--+',
  ];

  Factors() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = FactorsPuzzle.fromGridString(gridString);
    this.puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = FactorsEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveFactorsClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'');
    clueWrapper(name: 'A4', length: 2, valueDesc: r'');
    clueWrapper(name: 'A6', length: 2, valueDesc: r'');
    clueWrapper(name: 'A7', length: 3, valueDesc: r'');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'');
    clueWrapper(name: 'A10', length: 3, valueDesc: r'');
    clueWrapper(name: 'A13', length: 2, valueDesc: r'');
    clueWrapper(name: 'A15', length: 2, valueDesc: r'');
    clueWrapper(name: 'A16', length: 3, valueDesc: r'');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'');
    clueWrapper(name: 'D8', length: 3, valueDesc: r'');
    clueWrapper(name: 'D9', length: 3, valueDesc: r'');
    clueWrapper(name: 'D11', length: 2, valueDesc: r'');
    clueWrapper(name: 'D12', length: 2, valueDesc: r'');
    clueWrapper(name: 'D14', length: 2, valueDesc: r'');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid(
        (int row, int col, String face) => FactorsCell(row, col, face));

    var letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
    ];
    for (var letter in letters) {
      puzzle.letters[letter] = FactorsVariable(letter);
    }
    var cellExpresssions = [
      ['BBB', 'AABB', 'AB', 'D', 'BD'],
      ['BB', 'ABB', 'AD', 'AAD', 'CD'],
      ['AAAB', 'AAB', '', 'C', 'BC'],
      ['AE', 'A', 'F', 'G', 'AA'],
      ['AAA', 'AC', 'B', 'CC', 'ABC'],
    ];
    // Cells have expressions with variable references
    int r = 0;
    for (var row in puzzle.grid!.rows) {
      int c = 0;
      for (var cell in row) {
        var factorsCell = cell as FactorsCell;
        factorsCell.setExp(cellExpresssions[r][c]);
        c++;
      }
      r++;
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkVariableReferences();
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

  // Clue solver
  bool solveFactorsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as FactorsPuzzle;
    var clue = v as FactorsClue;
    var updated = false;
    // Values may have been set by other Clue
    if (clue.values == null) {
      clue.values = clue.getValuesFromDigits();
    }
    if (clue.values != null) {
      var values =
          clue.values!.where((value) => validClue(clue, value, [], []));
      possibleValue.addAll(values);
    }
    return updated;
  }

  @override
  bool updateClues(
      FactorsPuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    return updated;
  }
}
