library needlematch;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the NeedleMatch API.
class NeedleMatch extends Crossnumber<NeedleMatchPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :  :2 |3 :  :4 :5 |',
    '+::+--+::+::+--+::+::+',
    '|6 :7 :  |  |8 :  :  |',
    '+--+::+::+::+::+::+::+',
    '|9 |10:  :  :  :  |  |',
    '+::+::+::+::+::+::+--+',
    '|11:  :  |  |12:  :13|',
    '+::+::+--+::+::+--+::+',
    '|14:  :  :  |15:  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  NeedleMatch() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = NeedleMatchPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Select the appropriate branch in the test below
    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = NeedleMatchEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveNeedleMatchClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A3', length: 4, valueDesc: r'#triangular');
    clueWrapper(name: 'A6', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A8', length: 3, valueDesc: r'#odd');
    clueWrapper(name: 'A10', length: 5, valueDesc: r'#cube');
    clueWrapper(name: 'A11', length: 3, valueDesc: r'#difftwootherentry');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A14', length: 4, valueDesc: r'#square');
    clueWrapper(name: 'A15', length: 3, valueDesc: r'#factorotherentry');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'D2', length: 4, valueDesc: r'#triangular');
    clueWrapper(name: 'D3', length: 5, valueDesc: r'#cube');
    clueWrapper(name: 'D4', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D7', length: 4, valueDesc: r'#Fibonacci');
    clueWrapper(name: 'D8', length: 4, valueDesc: r'#square');
    clueWrapper(name: 'D9', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D13', length: 2, valueDesc: r'#prime');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(NeedleMatchVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    puzzle.clues['A3']!.answer = 2415;
    puzzle.clues['A8']!.answer = 559;
    puzzle.clues['A11']!.answer = 486;
    puzzle.clues['D4']!.answer = 1597;
    super.solve(iteration);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }

    // Each value's digits contains exactly two of the digits between 3 and 7 inclusive
    var digits = value.toString();
    var count = 0;
    for (var digit in digits.split('')) {
      if (int.parse(digit) >= 3 && int.parse(digit) <= 7) {
        count++;
      }
    }
    if (count != 2) return false;

    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveNeedleMatchClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as NeedleMatchPuzzle;
    var clue = v as NeedleMatchClue;
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
      } else {
        // Get values from digits
        var values = clue.getValuesFromDigits();
        if (values != null) {
          possibleValue.addAll(values);
        } else {
          // No further action
          throw SolveException();
        }
      }
    }
    return updated;
  }

  @override
  bool updateClues(NeedleMatchPuzzle thisPuzzle, Clue clue,
      Set<int> possibleValues, Set<Variable> updatedVariables,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(
        thisPuzzle, clue, possibleValues, updatedVariables,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {}
    return updated;
  }
}
