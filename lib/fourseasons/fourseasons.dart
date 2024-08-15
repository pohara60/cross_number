library fourseasons;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../gcf.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the FourSeasons API.
class FourSeasons extends Crossnumber<FourSeasonsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 :3 :4 |5 :6 |',
    '+::+::+::+::+::+::+',
    '|7 :  :  |8 :  :  |',
    '+--+::+::+--+::+::+',
    '|9 :  |10:11:  :  |',
    '+::+--+::+::+--+::+',
    '|12:13:  :  |14:  |',
    '+::+::+--+::+::+--+',
    '|15:  :16|17:  :18|',
    '+::+::+::+::+::+::+',
    '|19:  |20:  :  :  |',
    '+--+--+--+--+--+--+',
  ];

  FourSeasons() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = FourSeasonsPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = FourSeasonsEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveFourSeasonsClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 4, valueDesc: r'');
    clueWrapper(name: 'A5', length: 2, valueDesc: r'');
    clueWrapper(name: 'A7', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'A8', length: 3, valueDesc: r'#palindrome');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'');
    clueWrapper(name: 'A10', length: 4, valueDesc: r'');
    clueWrapper(name: 'A12', length: 4, valueDesc: r'');
    clueWrapper(name: 'A14', length: 2, valueDesc: r'');
    clueWrapper(name: 'A15', length: 3, valueDesc: r'#palindrome');
    clueWrapper(name: 'A17', length: 3, valueDesc: r'');
    clueWrapper(name: 'A19', length: 2, valueDesc: r'');
    clueWrapper(name: 'A20', length: 4, valueDesc: r'');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'');
    clueWrapper(name: 'D3', length: 4, valueDesc: r'');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'');
    clueWrapper(name: 'D6', length: 4, valueDesc: r'');
    clueWrapper(name: 'D9', length: 4, valueDesc: r'');
    clueWrapper(name: 'D11', length: 4, valueDesc: r'');
    clueWrapper(name: 'D13', length: 3, valueDesc: r'');
    clueWrapper(name: 'D14', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D16', length: 2, valueDesc: r'');
    clueWrapper(name: 'D18', length: 2, valueDesc: r'');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(FourSeasonsVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
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
    // Any two entries that intersect in a cell in the
    // NW quadrant of the grid have an HCF of 4.
    // NE quadrant of the grid have an HCF of 9.
    // SW quadrant of the grid have an HCF of 7.
    // SE quadrant of the grid have an HCF of 5.
    var entryMixin = clue as EntryMixin;
    for (var cell in entryMixin.cells) {
      var isN = cell.row < 3;
      var isW = cell.col < 3;
      var hcf = isN && isW
          ? 4
          : isN && !isW
              ? 9
              : !isN && isW
                  ? 7
                  : /*!isN && !isW */ 5;
      // This value must be divisible by hcf
      if (value % hcf != 0) {
        return false;
      }
      for (var otherEntry in cell.entries) {
        if (otherEntry != entryMixin) {
          var ok = false;
          if (otherEntry.values == null) {
            ok = true;
          } else {
            for (var otherValue in otherEntry.values!) {
              var gcf = getGCF(value, otherValue);
              // Check entries have the required common factor
              if (gcf == hcf) {
                ok = true;
                break;
              }
            }
          }
          if (!ok) {
            return false;
          }
        }
      }
    }

    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveFourSeasonsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as FourSeasonsPuzzle;
    var clue = v as FourSeasonsClue;
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
  bool updateClues(
      FourSeasonsPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(thisPuzzle, clue, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue value order
      // var clue = thisPuzzle.clues[clueName]!;
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
    }
    return updated;
  }
}
