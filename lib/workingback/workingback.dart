library workingback;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the WorkingBack API.
class WorkingBack extends Crossnumber<WorkingBackPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :  :2 |3 :4 :5 |',
    '+::+--+::+::+::+::+',
    '|  |6 :  :  |7 :  |',
    '+--+--+::+--+::+::+',
    '|8 |9 :  |10:  |  |',
    '+::+::+--+::+--+--+',
    '|11:  |12:  :  |13|',
    '+::+::+::+::+--+::+',
    '|14:  :  |15:  :  |',
    '+--+--+--+--+--+--+',
  ];

  WorkingBack() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = WorkingBackPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = WorkingBackEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveWorkingBackClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'$divisor A3');
    clueWrapper(name: 'A3', length: 3, valueDesc: r'#palindrome');
    clueWrapper(name: 'A6', length: 3, valueDesc: r'$multiple A10');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'A10', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'A11', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'A7 * D12');
    clueWrapper(name: 'A14', length: 3, valueDesc: r'A12 - D12');
    clueWrapper(name: 'A15', length: 3, valueDesc: r'D4 - $reverse D4');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'#fibonacci');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'$multiple A9');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'D4', length: 3, valueDesc: r'$reverse D9');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'D4 - D10');
    clueWrapper(name: 'D8', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D9', length: 3, valueDesc: r'');
    clueWrapper(name: 'D10', length: 3, valueDesc: r'#palindrome');
    clueWrapper(name: 'D12', length: 2, valueDesc: r'');
    clueWrapper(name: 'D13', length: 2, valueDesc: r'#cube');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(WorkingBackVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    super.solve(true);
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
  bool solveWorkingBackClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as WorkingBackPuzzle;
    var clue = v as WorkingBackClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        updated = puzzle.solveRelatedClues(
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
  bool updateClues(WorkingBackPuzzle thisPuzzle, Clue clue,
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
    if (!isEntry && updated) {
      // Maintain clue value order
      // var newMin = clue.values!.reduce(min);
      // if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      // var newMax = clue.values!.reduce(max);
      // if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // // Clues are defined in ascending order of value
      // for (var otherClue in thisPuzzle.clues.values) {
      //   if (romanToDecimal(otherClue.name) > romanToDecimal(clue.name)) {
      //     if ((otherClue.min == null || otherClue.min! <= clue.min!)) {
      //       otherClue.min = clue.min! + 1;
      //     }
      //   }
      //   if (romanToDecimal(otherClue.name) < romanToDecimal(clue.name)) {
      //     if ((otherClue.max == null || otherClue.max! >= clue.max!)) {
      //       otherClue.max = clue.max! - 1;
      //     }
      //   }
      // }
    }
    return updated;
  }
}
