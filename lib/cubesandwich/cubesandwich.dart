library cubesandwich;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the CubeSandwich API.
class CubeSandwich extends Crossnumber<CubeSandwichPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :  :3 :4 |',
    '+::+::+--+::+::+',
    '|5 :  |6 |7 :  |',
    '+::+::+::+::+::+',
    '|8 :  :  :  :  |',
    '+--+--+--+--+--+',
  ];

  CubeSandwich() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = CubeSandwichPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = CubeSandwichEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveCubeSandwichClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 5, valueDesc: r'#cube');
    clueWrapper(name: 'A5', length: 2, valueDesc: r'');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'');
    clueWrapper(name: 'A8', length: 5, valueDesc: r'#cube');
    clueWrapper(name: 'D1', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D3', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D4', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D6', length: 2, valueDesc: r'$reverse(A5 + A7)');

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
      puzzle.addAnyVariable(CubeSandwichVariable(letter));
    }

    puzzle.finalize();
    super.initCrossnumber();
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveCubeSandwichClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as CubeSandwichPuzzle;
    var clue = v as CubeSandwichClue;
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
      CubeSandwichPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    var updated = super.updateClues(thisPuzzle, clue, possibleValues,
        isFocus: isFocus, isEntry: isEntry, focusClue: focusClue);
    return updated;
  }
}
