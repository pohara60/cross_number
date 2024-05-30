library twoprimes;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the TwoPrimes API.
class TwoPrimes extends Crossnumber<TwoPrimesPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :  |2 |3 :4 :  |',
    '+::+--+::+::+::+--+',
    '|  |5 :  :  :  |6 |',
    '+::+::+::+--+--+::+',
    '|7 :  |8 :9 |10:  |',
    '+::+--+--+::+::+::+',
    '|  |11:12:  :  |  |',
    '+--+::+::+::+--+::+',
    '|13:  :  |  |14:  |',
    '+--+--+--+--+--+--+',
  ];

  TwoPrimes() {
    puzzle = TwoPrimesPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var entry = TwoPrimesEntry(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            solve: solveTwoPrimesClue);
        puzzle.addEntry(entry);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 2, valueDesc: r"$variablevalue I");
    clueWrapper(name: 'A3', length: 3, valueDesc: r"PR");
    clueWrapper(
        name: 'A5',
        length: 4,
        valueDesc: r"$variablevalue M * $variablevalue R");
    clueWrapper(name: 'A7', length: 2, valueDesc: r"$variablevalue P");
    clueWrapper(name: 'A8', length: 2, valueDesc: r"$variablevalue P");
    clueWrapper(name: 'A10', length: 2, valueDesc: r"$variablevalue S");
    clueWrapper(
        name: 'A11',
        length: 4,
        valueDesc: r"$variablevalue E * $variablevalue E");
    clueWrapper(
        name: 'A13',
        length: 3,
        valueDesc: r"$variablevalue E + $variablevalue R");
    clueWrapper(name: 'A14', length: 2, valueDesc: r"$variablevalue E");

    clueWrapper(
        name: 'D1',
        length: 4,
        valueDesc: r"$variablevalue I * $variablevalue M");
    clueWrapper(
        name: 'D2',
        length: 3,
        valueDesc: r"$variablevalue M * $variablevalue R");
    clueWrapper(
        name: 'D3',
        length: 2,
        valueDesc: r"$variablevalue M * $variablevalue R");
    clueWrapper(
        name: 'D4',
        length: 2,
        valueDesc: r"$variablevalue P - $variablevalue R - $variablevalue S");
    clueWrapper(name: 'D5', length: 2, valueDesc: r"$variablevalue R");
    clueWrapper(
        name: 'D6',
        length: 4,
        valueDesc: r"$variablevalue P * $variablevalue S");
    clueWrapper(
        name: 'D9',
        length: 3,
        valueDesc: r"$variablevalue P + $variablevalue S");
    clueWrapper(name: 'D10', length: 2, valueDesc: r"$variablevalue I");
    clueWrapper(name: 'D11', length: 2, valueDesc: r"$variablevalue E");
    clueWrapper(
        name: 'D12',
        length: 2,
        valueDesc: r"$variablevalue P - $variablevalue P");

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();
    puzzle.linkEntriesToGrid();

    var letters = ['E', 'I', 'M', 'P', 'R', 'S'];
    for (var letter in letters) {
      puzzle.addAnyVariable(TwoPrimesVariable(letter));
    }

    var clueError = '';
    clueError += puzzle.checkPuzzleVariableReferences();
    clueError += puzzle.checkClueClueReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveTwoPrimesClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as TwoPrimesPuzzle;
    var clue = v as TwoPrimesClue;

    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables!, validClue);
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
