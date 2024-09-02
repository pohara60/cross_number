library eraser;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Eraser API.
class Eraser extends Crossnumber<EraserPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :  |2 :  :3 |',
    '+::+--+::+--+::+',
    '|4 :5 :  |6 :  |',
    '+::+::+--+::+--+',
    '|  |7 :  :  |8 |',
    '+--+::+--+::+::+',
    '|9 :  |10:  :  |',
    '+::+--+::+--+::+',
    '|11:  :  |12:  |',
    '+--+--+--+--+--+',
  ];

  Eraser() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = EraserPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = EraserEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveEraserClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 2, valueDesc: r'#cube');
    clueWrapper(name: 'A2', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A4', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A6', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'A7', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'A10', length: 3, valueDesc: r'#cube');
    clueWrapper(name: 'A11', length: 3, valueDesc: r'#cube');
    clueWrapper(name: 'A12', length: 2, valueDesc: r'#cube');
    clueWrapper(name: 'D1', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D2', length: 2, valueDesc: r'#Lucas');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'D1 - D8');
    clueWrapper(name: 'D6', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D8', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D9', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'D10', length: 2, valueDesc: r'#square');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(EraserVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  int callback(Puzzle puzzle) {
    var eraserPuzzle = puzzle as EraserPuzzle;
    // Puzzle has found a valid solution, check variables clues
    var index = unfinishedPuzzles.indexOf(puzzle);
    if (index + 1 == unfinishedPuzzles.length) {
      // Finished clues!
      var erased = eraserPuzzle.checkVariables();
      if (erased != 0) {
        print("SOLUTION-----------------------------");
        for (var puzzle in puzzles) {
          if (puzzle.uniqueSolution()) {
            print(puzzle.toSummary());
          }
        }
        print('Erased cells value $erased');
        return 1;
      }
      return 0;
    }

    return unfinishedPuzzles[index + 1].iterate(callback);
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
  bool solveEraserClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as EraserPuzzle;
    var clue = v as EraserClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        updated = puzzle.solveExpressionEvaluator(
            clue, clue.exp, possibleValue, possibleVariables!, validClue);
      } else {
        var first = true;
        String? exceptionMessage;
        for (var exp in clue.expressions) {
          var possibleValueExp = <int>{};
          try {
            // Previous evaluation may have cleared variables
            if (possibleVariables!.isEmpty) return updated;
            updated = puzzle.solveExpressionEvaluator(
              clue,
              exp,
              first ? possibleValue : possibleValueExp,
              possibleVariables,
              validClue,
            );
            // Combine values
            if (first) {
              first = false;
              // Got first values above
            } else {
              // Keep intersection of values
              var remove = possibleValue
                  .where((value) => !possibleValueExp.contains(value))
                  .toList();
              possibleValue.removeAll(remove);
            }
          } on SolveException catch (e) {
            // Keep processing other expressions
            exceptionMessage = e.msg;
          }
        }
        if (first) {
          // All expressions threw exception
          throw SolveException(exceptionMessage);
        }
      }
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
  bool updateClues(EraserPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      Set<Variable> updatedVariables,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    var updated = super.updateClues(
        thisPuzzle, clue, possibleValues, updatedVariables,
        isFocus: isFocus, isEntry: isEntry);
    return updated;
  }
}
