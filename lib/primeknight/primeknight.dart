library primeknight;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../grid.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the PrimeKnight API.
class PrimeKnight extends Crossnumber<PrimeKnightPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :  |3 :4 |',
    '+::+::+--+--+::+',
    '|  |5 :6 |7 :  |',
    '+--+::+::+::+--+',
    '|8 :  |9 :  |10|',
    '+::+--+--+::+::+',
    '|11:  |12:  :  |',
    '+--+--+--+--+--+',
  ];

  PrimeKnight() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = PrimeKnightPuzzle.fromGridString(gridString);
    this.puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = PrimeKnightEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solvePrimeKnightClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A3', length: 2, valueDesc: r'A7-A9');
    clueWrapper(name: 'A5', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A11', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'D6', length: 2, valueDesc: r'A3 = $DP #result');
    clueWrapper(name: 'D7', length: 3, valueDesc: r'$multiple A5');
    clueWrapper(name: 'D8', length: 2, valueDesc: r'A3+A7');
    clueWrapper(name: 'D10', length: 2, valueDesc: r'#prime');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.addDigitIdentityFromGrid();

    puzzle.grid = Grid.fromGridSpec(puzzle);

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.letters[letter] = PrimeKnightVariable(letter);
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

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

    super.solve(false);

    var tours = puzzle.knightTours();
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
  bool solvePrimeKnightClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as PrimeKnightPuzzle;
    var clue = v as PrimeKnightClue;
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
      PrimeKnightPuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue value order
      // var clue = puzzle.clues[clueName]!;
      // var newMin = clue.values!.reduce(min);
      // if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      // var newMax = clue.values!.reduce(max);
      // if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // // Clues are defined in ascending order of value
      // for (var otherClue in puzzle.clues.values) {
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
