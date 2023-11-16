library columns;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Columns API.
class Columns extends Crossnumber<ColumnsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :  :2 |3 :4 |',
    '+::+--+::+::+::+',
    '|5 :6 |7 :  :  |',
    '+::+::+--+::+::+',
    '|8 :  :9 |10:  |',
    '+::+::+::+--+::+',
    '|11:  |12:  :  |',
    '+--+--+--+--+--+',
  ];

  Columns() {
    puzzle = ColumnsPuzzle.grid(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var entry = ColumnsEntry(
            name: name,
            length: length,
            valueDesc: valueDesc,
            solve: solveColumnsClue);
        puzzle.addEntry(entry);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'$palindrome $lessthan A12');
    clueWrapper(name: 'A3', length: 2, valueDesc: r'#triangular - A1');
    clueWrapper(name: 'A5', length: 2, valueDesc: r'#Harshad');
    clueWrapper(
        name: 'A7',
        length: 3,
        valueDesc: r'$ascending #result % $ds #result = 0');
    clueWrapper(name: 'A8', length: 3, valueDesc: r'$descending $multiple A10');
    clueWrapper(name: 'A10', length: 2, valueDesc: r'$reverse $dp A5');
    clueWrapper(name: 'A11', length: 2, valueDesc: r'$adjacentprime A10');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'A8 - #triangular');
    clueWrapper(name: 'D1', length: 4, valueDesc: r'#product4primes');
    clueWrapper(name: 'D2', length: 2, valueDesc: r'$divisor A5');
    clueWrapper(name: 'D3', length: 3, valueDesc: r'#triangular - D6');
    clueWrapper(name: 'D4', length: 4, valueDesc: r'#product4primes');
    clueWrapper(name: 'D6', length: 3, valueDesc: r'$multiple A3');
    clueWrapper(name: 'D9', length: 2, valueDesc: r'$divisor D2');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();
    puzzle.addDigitIdentityFromGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.letters[letter] = ColumnsVariable(letter);
    }

    var clueError = puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    if (Crossnumber.traceInit) {
      print(puzzle.toString());
    }
  }

  // Validate possible clue value
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!clue.digitsMatch(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveColumnsClue(ColumnsClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables) {
    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables, validClue);
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
}
