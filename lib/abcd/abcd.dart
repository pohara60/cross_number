/// An API for solving Letters puzzles.
library sequences;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the ABCD API.
class ABCD extends Crossnumber<ABCDPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 :  :3 |4 :5 |',
    '+::+::+--+::+::+::+',
    '|6 :  |7 :  :  :  |',
    '+::+--+::+--+--+::+',
    '|  |8 :  :9 |10:  |',
    '+--+::+::+::+::+--+',
    '|11:  |12:  :  |13|',
    '+::+--+--+::+--+::+',
    '|14:15:16:  |17:  |',
    '+::+::+::+--+::+::+',
    '|18:  |19:  :  :  |',
    '+--+--+--+--+--+--+',
  ];

  ABCD() {
    puzzle = ABCDPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, SolveFunction? solve}) {
      try {
        var entry = ABCDEntry(
            name: name!, length: length, valueDesc: valueDesc, solve: solve);
        puzzle.addEntry(entry);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(
        name: 'A1', length: 4, valueDesc: r"AC+CD", solve: solveABCDClue);
    clueWrapper(
        name: 'A4', length: 2, valueDesc: r"A+A+A", solve: solveABCDClue);
    clueWrapper(name: 'A6', length: 2, valueDesc: r"A", solve: solveABCDClue);
    clueWrapper(
        name: 'A7', length: 4, valueDesc: r"B+AD", solve: solveABCDClue);
    clueWrapper(
        name: 'A8', length: 3, valueDesc: r"AB-D", solve: solveABCDClue);
    clueWrapper(
        name: 'A10', length: 2, valueDesc: r"A+A", solve: solveABCDClue);
    clueWrapper(name: 'A11', length: 2, valueDesc: r"C", solve: solveABCDClue);
    clueWrapper(
        name: 'A12', length: 3, valueDesc: r"BC+D", solve: solveABCDClue);
    clueWrapper(
        name: 'A14', length: 4, valueDesc: r"AD-BC", solve: solveABCDClue);
    clueWrapper(
        name: 'A17', length: 2, valueDesc: r"A+C-B", solve: solveABCDClue);
    clueWrapper(name: 'A18', length: 2, valueDesc: r"B", solve: solveABCDClue);
    clueWrapper(
        name: 'A19', length: 4, valueDesc: r"AD-AB", solve: solveABCDClue);

    clueWrapper(
        name: 'D1', length: 3, valueDesc: r"B+AC", solve: solveABCDClue);
    clueWrapper(
        name: 'D2', length: 2, valueDesc: r"B+B+B", solve: solveABCDClue);
    clueWrapper(name: 'D3', length: 2, valueDesc: r"A+C", solve: solveABCDClue);
    clueWrapper(
        name: 'D4', length: 2, valueDesc: r"A+B+C", solve: solveABCDClue);
    clueWrapper(name: 'D5', length: 3, valueDesc: r"D-A", solve: solveABCDClue);
    clueWrapper(
        name: 'D7', length: 3, valueDesc: r"AB+C", solve: solveABCDClue);
    clueWrapper(
        name: 'D8', length: 2, valueDesc: r"A+B-C", solve: solveABCDClue);
    clueWrapper(
        name: 'D9', length: 3, valueDesc: r"AC-D", solve: solveABCDClue);
    clueWrapper(
        name: 'D10', length: 2, valueDesc: r"B+B", solve: solveABCDClue);
    clueWrapper(
        name: 'D11', length: 3, valueDesc: r"A+C+D", solve: solveABCDClue);
    clueWrapper(
        name: 'D13', length: 3, valueDesc: r"AB+AC", solve: solveABCDClue);
    clueWrapper(
        name: 'D15', length: 2, valueDesc: r"C+C+C", solve: solveABCDClue);
    clueWrapper(
        name: 'D16', length: 2, valueDesc: r"B+C", solve: solveABCDClue);
    clueWrapper(
        name: 'D17', length: 2, valueDesc: r"B+C-A", solve: solveABCDClue);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();
    puzzle.linkEntriesToGrid();

    // A, B, C and D are four primes such that D > C > B > A.
    // A, B and C are 2 digits, D is 3.
    var letters = [
      ('A', 2),
      ('B', 2),
      ('C', 2),
      ('D', 3),
    ];
    for (var letter in letters) {
      puzzle.letters[letter.$1] = ABCDVariable(letter);
    }

    var clueError = puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
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
  bool solveABCDClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as ABCDPuzzle;
    var clue = v as ABCDClue;
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
