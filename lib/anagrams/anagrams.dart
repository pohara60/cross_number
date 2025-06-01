library anagrams;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Anagrams API.
class Anagrams extends Crossnumber<AnagramsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|1 :2 :3 :  |4 :5 :  :6 |',
    '+::+::+::+--+--+::+--+::+',
    '|  |  |  |7 |8 |  |9 :  |',
    '+::+--+::+::+::+::+--+::+',
    '|10:  :  :  |11:  :  :  |',
    '+::+--+::+::+::+::+--+::+',
    '|  |12:  :  :  :  :  |  |',
    '+--+--+--+::+::+--+--+--+',
    '|13|14:15:  :  :16:  |17|',
    '+::+--+::+::+::+::+--+::+',
    '|18:  :  :  |19:  :  :  |',
    '+::+--+::+::+::+::+--+::+',
    '|20:  |  |  |  |  |21|  |',
    '+::+--+::+--+--+::+::+::+',
    '|22:  :  :  |23:  :  :  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  Anagrams() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = AnagramsPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Select the appropriate branch in the test below
    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = AnagramsEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveAnagramsClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 4, valueDesc: r'£primeFactors(6,2,4)');
    clueWrapper(name: 'A4', length: 4, valueDesc: r'£primeFactors(3,69,4)');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'£primeFactors(5,1,2)');
    clueWrapper(name: 'A10', length: 4, valueDesc: r'£primeFactors(3,104,4)');
    clueWrapper(name: 'A11', length: 4, valueDesc: r'£primeFactors(4,11,4)');
    clueWrapper(name: 'A12', length: 6, valueDesc: r'');
    clueWrapper(name: 'A14', length: 6, valueDesc: r'');
    clueWrapper(name: 'A18', length: 4, valueDesc: r'£primeFactors(10,0,4)');
    clueWrapper(name: 'A19', length: 4, valueDesc: r'£primeFactors(7,9,4)');
    clueWrapper(name: 'A20', length: 2, valueDesc: r'£primeFactors(5,0,2)');
    clueWrapper(name: 'A22', length: 4, valueDesc: r'£primeFactors(2,1427,4)');
    clueWrapper(name: 'A23', length: 4, valueDesc: r'£primeFactors(6,4,4)');
    clueWrapper(name: 'D1', length: 4, valueDesc: r'£primeFactors(4,16,4)');
    clueWrapper(name: 'D2', length: 2, valueDesc: r'£primeFactors(2,2,2)');
    clueWrapper(name: 'D3', length: 4, valueDesc: r'£primeFactors(10,1,4)');
    clueWrapper(name: 'D5', length: 4, valueDesc: r'£primeFactors(11,0,4)');
    clueWrapper(name: 'D6', length: 4, valueDesc: r'£primeFactors(2,594,4)');
    clueWrapper(name: 'D7', length: 6, valueDesc: r'');
    clueWrapper(name: 'D8', length: 6, valueDesc: r'');
    clueWrapper(name: 'D13', length: 4, valueDesc: r'£primeFactors(3,1281,4)');
    clueWrapper(name: 'D15', length: 4, valueDesc: r'£primeFactors(4,8,4)');
    clueWrapper(name: 'D16', length: 4, valueDesc: r'£primeFactors(4,29,4)');
    clueWrapper(name: 'D17', length: 4, valueDesc: r'£primeFactors(4,0,4)');
    clueWrapper(name: 'D21', length: 2, valueDesc: r'£primeFactors(4,0,2)');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(AnagramsVariable(letter));
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
  bool solveAnagramsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as AnagramsPuzzle;
    var clue = v as AnagramsClue;
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
  bool updateClues(AnagramsPuzzle thisPuzzle, Clue clue,
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
    return updated;
  }
}
