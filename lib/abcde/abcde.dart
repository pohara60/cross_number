library abcde;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the ABCDE API.
class ABCDE extends Crossnumber<ABCDEPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :  :2 :3 |4 |5 :6 |',
    '+::+--+::+::+::+::+::+',
    '|7 :8 :  |9 :  |10:  |',
    '+--+::+::+::+::+::+::+',
    '|11:  :  :  |12:  |  |',
    '+--+::+--+--+::+--+::+',
    '|13:  :14:  |15:16:  |',
    '+::+--+::+--+--+::+--+',
    '|  |17:  |18:19:  :  |',
    '+::+::+::+::+::+::+--+',
    '|20:  |21:  |22:  :23|',
    '+::+::+::+::+::+--+::+',
    '|24:  |  |25:  :  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  ABCDE() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = ABCDEPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = ABCDEEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveABCDEClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 4, valueDesc: r'AB + BD');
    clueWrapper(name: 'A5', length: 2, valueDesc: r'B + C');
    clueWrapper(name: 'A7', length: 3, valueDesc: r'D - C');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'AB - E');
    clueWrapper(name: 'A10', length: 2, valueDesc: r'B + B');
    clueWrapper(name: 'A11', length: 4, valueDesc: r'CD - A');
    clueWrapper(name: 'A12', length: 2, valueDesc: r'A + B');
    clueWrapper(name: 'A13', length: 4, valueDesc: r'A + CD');
    clueWrapper(name: 'A15', length: 3, valueDesc: r'E + E');
    clueWrapper(name: 'A17', length: 2, valueDesc: r'B + C - A');
    clueWrapper(name: 'A18', length: 4, valueDesc: r'BD - C');
    clueWrapper(name: 'A20', length: 2, valueDesc: r'C + C + C');
    clueWrapper(name: 'A21', length: 2, valueDesc: r'A + A + A');
    clueWrapper(name: 'A22', length: 3, valueDesc: r'C + D - A');
    clueWrapper(name: 'A24', length: 2, valueDesc: r'B + B + B');
    clueWrapper(name: 'A25', length: 4, valueDesc: r'BE - D');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'C');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'C + D');
    clueWrapper(name: 'D3', length: 3, valueDesc: r'D + BC');
    clueWrapper(name: 'D4', length: 4, valueDesc: r'BD + CD');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'D + AB');
    clueWrapper(name: 'D6', length: 4, valueDesc: r'B + CD');
    clueWrapper(name: 'D8', length: 3, valueDesc: r'A + D');
    clueWrapper(name: 'D13', length: 4, valueDesc: r'CD - B');
    clueWrapper(name: 'D14', length: 4, valueDesc: r'E + BD');
    clueWrapper(name: 'D16', length: 3, valueDesc: r'BC - A');
    clueWrapper(name: 'D17', length: 3, valueDesc: r'C + E - B');
    clueWrapper(name: 'D18', length: 3, valueDesc: r'A + E - C');
    clueWrapper(name: 'D19', length: 3, valueDesc: r'E - A');
    clueWrapper(name: 'D23', length: 2, valueDesc: r'A + A');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
      'A', 'B', 'C', 'D', 'E'
    ];
    for (var letter in letters) {
      puzzle.addVariable(ABCDEVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    super.solve(iteration);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }
    if (variableReferences.length > 1) {
      for (var v1 = 0; v1 < variableReferences.length - 1; v1++) {
        for (var v2 = v1 + 1; v2 < variableReferences.length; v2++) {
          // Variables are in alpha order,and values must increase
          if (variableValues[v1] >= variableValues[v2]) return false;
        }
      }
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveABCDEClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as ABCDEPuzzle;
    var clue = v as ABCDEClue;
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
  bool updateClues(ABCDEPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      Set<Variable> updatedVariables,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(
        thisPuzzle, clue, possibleValues, updatedVariables,
        isFocus: isFocus, isEntry: isEntry);
    return updated;
  }
}
