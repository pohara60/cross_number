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

    clueWrapper(name: 'A1', length: 2, valueDesc: r'(H*H - D)');
    clueWrapper(name: 'A3', length: 3, valueDesc: r'(D*D - I)');
    clueWrapper(name: 'A6', length: 4, valueDesc: r'(F*F - F)');
    clueWrapper(name: 'A8', length: 3, valueDesc: r'(J*J - K)');
    clueWrapper(name: 'A11', length: 4, valueDesc: r'(K*K - J)');
    clueWrapper(name: 'A13', length: 3, valueDesc: r'(J*J - D)');
    clueWrapper(name: 'A14', length: 2, valueDesc: r'(H*H - H)');
    clueWrapper(name: 'D1', length: 3, valueDesc: r'(B*B - B)');
    clueWrapper(name: 'D2', length: 2, valueDesc: r'(A*A - E)');
    clueWrapper(name: 'D4', length: 3, valueDesc: r'(B*B - K)');
    clueWrapper(name: 'D5', length: 2, valueDesc: r'(A*A - I)');
    clueWrapper(name: 'D7', length: 3, valueDesc: r'(D*D - G)');
    clueWrapper(name: 'D8', length: 3, valueDesc: r'(J*J - J)');
    clueWrapper(name: 'D9', length: 3, valueDesc: r'(D*D - F)');
    clueWrapper(name: 'D10', length: 2, valueDesc: r'(H*H - C)');
    clueWrapper(name: 'D12', length: 2, valueDesc: r'(A*A - F)');

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
