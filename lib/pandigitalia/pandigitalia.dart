library pandigitalia;

import 'package:crossnumber/pandigitalia/pandigital_set.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Pandigitalia API.
class Pandigitalia extends Crossnumber<PandigitaliaPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :  |2 :  :  :3 |',
    '+::+--+::+--+--+::+',
    '|  |4 :  :  |5 |  |',
    '+::+::+::+--+::+--+',
    '|6 :  |7 :  :  |8 |',
    '+::+::+--+--+::+::+',
    '|  |9 :  :10|11:  |',
    '+--+::+--+::+::+::+',
    '|12|  |13:  :  |  |',
    '+::+--+--+::+--+::+',
    '|14:  :  :  |15:  |',
    '+--+--+--+--+--+--+',
  ];

  Pandigitalia() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = PandigitaliaPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = PandigitaliaEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solvePandigitaliaClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A2', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'A4', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A6', length: 2, valueDesc: r'');
    clueWrapper(name: 'A7', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'A9', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'A11', length: 2, valueDesc: r'$multiple A6');
    clueWrapper(name: 'A13', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A14', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'A15', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'D1', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'A1 - #square');
    clueWrapper(name: 'D4', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'D5', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'D8', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'D10', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D12', length: 2, valueDesc: r'A15 - #square');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(PandigitaliaVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
    puzzle.initPandigitalSets();
  }

  void setAnswers() {
    puzzle.clues['A1']!.answer = 83;
    puzzle.clues['A2']!.answer = 6143;
    puzzle.clues['A4']!.answer = 729;
    puzzle.clues['A6']!.answer = 26;
    puzzle.clues['A7']!.answer = 561;
    puzzle.clues['A9']!.answer = 378;
    puzzle.clues['A11']!.answer = 52;
    puzzle.clues['A13']!.answer = 349;
    puzzle.clues['A14']!.answer = 8971;
    puzzle.clues['A15']!.answer = 67;
    puzzle.clues['D1']!.answer = 8521;
    puzzle.clues['D2']!.answer = 625;
    puzzle.clues['D3']!.answer = 34;
    puzzle.clues['D4']!.answer = 7639;
    puzzle.clues['D5']!.answer = 4159;
    puzzle.clues['D8']!.answer = 4297;
    puzzle.clues['D10']!.answer = 841;
    puzzle.clues['D12']!.answer = 58;
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    setAnswers();
    super.solve(iteration);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }

    return puzzle.validClue(clue as PandigitaliaClue, value);
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solvePandigitaliaClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as PandigitaliaPuzzle;
    var clue = v as PandigitaliaClue;
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

  // @override
  // bool updateClues(PandigitaliaPuzzle thisPuzzle, Clue clue,
  //     Set<int> possibleValues, Set<Variable> updatedVariables,
  //     {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
  //   var updated = super.updateClues(
  //       thisPuzzle, clue, possibleValues, updatedVariables,
  //       isFocus: isFocus, isEntry: isEntry);

  //   // Update pandigital sets for update clues
  //   var updatedVars = Set.from(updatedVariables);
  //   for (var updatedVar in updatedVars) {
  //     if (updatedVar is PandigitaliaEntry) {
  //       var set = pandigitalSetForClue[updatedVar];
  //       if (set != null) {
  //         // Update digits for all clues in the set
  //         var setUpdated = set.updateDigits(updatedVariables);
  //         if (setUpdated) {
  //           updated = true;
  //         }
  //       }
  //     }
  //   }
  //   return updated;
  // }
}
