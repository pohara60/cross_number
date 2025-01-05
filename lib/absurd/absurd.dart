library absurd;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Absurd API.
class Absurd extends Crossnumber<AbsurdPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 |3 :4 :5 |',
    '+::+::+--+::+::+',
    '|6 :  :7 :  |  |',
    '+::+--+::+::+--+',
    '|  |8 :  :  |9 |',
    '+--+::+::+--+::+',
    '|10|11:  :12:  |',
    '+::+::+--+::+::+',
    '|13:  :  |14:  |',
    '+--+--+--+--+--+',
  ];

  Absurd() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = AbsurdPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = AbsurdEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveAbsurdClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(
        name: 'A1',
        length: 2,
        valueDesc: r'=CONCATENATE("(",G19,"+√",H19,")*(",I19,"-√",J19,")")');
    clueWrapper(
        name: 'A3',
        length: 3,
        valueDesc: r'=CONCATENATE("(",G20,"+√",H20,")*(",I20,"-√",J20,")")');
    clueWrapper(
        name: 'A6',
        length: 4,
        valueDesc: r'=CONCATENATE("(",G21,"+√",H21,")*(",I21,"-√",J21,")")');
    clueWrapper(
        name: 'A8',
        length: 3,
        valueDesc: r'=CONCATENATE("(",G22,"+√",H22,")*(",I22,"-√",J22,")")');
    clueWrapper(
        name: 'A11',
        length: 4,
        valueDesc: r'=CONCATENATE("(",G23,"+√",H23,")*(",I23,"-√",J23,")")');
    clueWrapper(
        name: 'A13',
        length: 3,
        valueDesc: r'=CONCATENATE("(",G24,"+√",H24,")*(",I24,"-√",J24,")")');
    clueWrapper(
        name: 'A14',
        length: 2,
        valueDesc: r'=CONCATENATE("(",G25,"+√",H25,")*(",I25,"-√",J25,")")');
    clueWrapper(
        name: 'D1',
        length: 3,
        valueDesc: r'=CONCATENATE("(",G28,"+√",H28,")*(",I28,"-√",J28,")")');
    clueWrapper(
        name: 'D2',
        length: 2,
        valueDesc: r'=CONCATENATE("(",G29,"+√",H29,")*(",I29,"-√",J29,")")');
    clueWrapper(
        name: 'D4',
        length: 3,
        valueDesc: r'=CONCATENATE("(",G30,"+√",H30,")*(",I30,"-√",J30,")")');
    clueWrapper(
        name: 'D5',
        length: 2,
        valueDesc: r'=CONCATENATE("(",G31,"+√",H31,")*(",I31,"-√",J31,")")');
    clueWrapper(
        name: 'D7',
        length: 3,
        valueDesc: r'=CONCATENATE("(",G32,"+√",H32,")*(",I32,"-√",J32,")")');
    clueWrapper(
        name: 'D8',
        length: 3,
        valueDesc: r'=CONCATENATE("(",G33,"+√",H33,")*(",I33,"-√",J33,")")');
    clueWrapper(
        name: 'D9',
        length: 3,
        valueDesc: r'=CONCATENATE("(",G34,"+√",H34,")*(",I34,"-√",J34,")")');
    clueWrapper(
        name: 'D10',
        length: 2,
        valueDesc: r'=CONCATENATE("(",G35,"+√",H35,")*(",I35,"-√",J35,")")');
    clueWrapper(
        name: 'D12',
        length: 2,
        valueDesc: r'=CONCATENATE("(",G36,"+√",H36,")*(",I36,"-√",J36,")")');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
    ];
    for (var letter in letters) {
      puzzle.addVariable(AbsurdVariable(letter));
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
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveAbsurdClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as AbsurdPuzzle;
    var clue = v as AbsurdClue;
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
}
