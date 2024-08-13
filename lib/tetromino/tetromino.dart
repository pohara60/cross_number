library tetronomino;

import 'dart:math';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Tetromino API.
class Tetromino extends Crossnumber<TetrominoPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 :3 |4 :5 :6 |',
    '+::+::+::+::+::+::+',
    '|  |7 :  :  |  |  |',
    '+::+--+::+--+::+--+',
    '|8 :9 :  |10:  :11|',
    '+--+::+--+::+--+::+',
    '|12|  |13:  :14|  |',
    '+::+::+::+::+::+::+',
    '|15:  :  |16:  :  |',
    '+--+--+--+--+--+--+',
  ];

  Tetromino() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = TetrominoPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = TetrominoEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          solve: solveTetrominoClue,
        );
        puzzle.addEntry(entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += '${e.msg}\n';
      }
    }

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, List<String>? addDesc}) {
      try {
        var clue = TetrominoClue(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solveTetrominoClue);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'EF');
    clueWrapper(name: 'A2', length: 3, valueDesc: r'JK+(G-I)/D');
    clueWrapper(name: 'A3', length: 3, valueDesc: r'A(G-I+J)');
    clueWrapper(name: 'A4', length: 3, valueDesc: r'A(C-I)-B');
    clueWrapper(name: 'A5', length: 3, valueDesc: r'D(B+C+E+J)');
    clueWrapper(name: 'A6', length: 3, valueDesc: r'GJ+I');
    clueWrapper(name: 'A7', length: 3, valueDesc: r'FHJL');
    clueWrapper(name: 'A8', length: 3, valueDesc: r'A+GL+K');

    clueWrapper(name: 'D9', valueDesc: r'FH', length: 2);
    clueWrapper(name: 'D10', valueDesc: r'A+K', length: 2);
    clueWrapper(name: 'D11', valueDesc: r'AH', length: 2);
    clueWrapper(name: 'D12', valueDesc: r'(D^F)(F^D)', length: 2);
    clueWrapper(name: 'D13', valueDesc: r'A(D+H)', length: 2);
    clueWrapper(name: 'D14', valueDesc: r'C+FH', length: 2);
    clueWrapper(name: 'D15', valueDesc: r'BDF', length: 3);
    clueWrapper(name: 'D16', valueDesc: r'D^H-AH', length: 3);
    clueWrapper(name: 'D17', valueDesc: r'KL-E/E', length: 3);
    clueWrapper(name: 'D18', valueDesc: r'DI+EJ', length: 3);
    clueWrapper(name: 'D19', valueDesc: r'(A-J)^H-BL', length: 3);
    clueWrapper(name: 'D20', valueDesc: r'BI+CF', length: 3);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.linkEntriesToGrid();

    var letters = [
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
      'L',
    ];
    for (var letter in letters) {
      puzzle.addVariable(TetrominoVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  void solve([bool iteration = true]) {
    // Initialise clue values
    // var numClues = puzzle.clues.length;
    // var products = getProduct3Primes();
    // for (var clue in puzzle.clues.values) {
    //   var clueIndex = romanToDecimal(clue.name);
    //   clue.values = Set.from(products.whereIndexed((index, element) =>
    //       index >= clueIndex - 1 &&
    //       index <= clueIndex + products.length - numClues - 1));
    //   clue.min = clue.values!.first;
    //   clue.max = clue.values!.last;
    //   if (Crossnumber.traceSolve) {
    //     print(
    //         'solve: ${clue.runtimeType} ${clue.name} values=${clue.values!.toShortString()}');
    //   }

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
  bool solveTetrominoClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as TetrominoPuzzle;
    var clue = v as TetrominoClue;
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
      }
    }
    return updated;
  }

  @override
  bool updateClues(
      TetrominoPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
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
      var newMin = clue.values!.reduce(min);
      if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      var newMax = clue.values!.reduce(max);
      if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // Clues are defined in ascending order of value
      for (var otherClue in thisPuzzle.clues.values
          .where((element) => element.isAcross == clue.isAcross)) {
        if (int.parse(otherClue.name.substring(1)) >
            int.parse(clue.name.substring(1))) {
          if ((otherClue.min == null || otherClue.min! <= clue.min!)) {
            otherClue.min = clue.min! + 1;
          }
        }
        if (int.parse(otherClue.name.substring(1)) <
            int.parse(clue.name.substring(1))) {
          if ((otherClue.max == null || otherClue.max! >= clue.max!)) {
            otherClue.max = clue.max! - 1;
          }
        }
      }
    }
    return updated;
  }
}
