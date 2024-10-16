library magicarray;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the MagicArray API.
class MagicArray extends Crossnumber<MagicArrayPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :  |3 :  |',
    '+::+::+--+::+--+',
    '|  |4 :  :  |5 |',
    '+--+::+--+::+::+',
    '|6 :  |  |7 :  |',
    '+::+::+--+::+--+',
    '|  |8 :  :  |9 |',
    '+--+::+--+::+::+',
    '|10:  |11:  :  |',
    '+--+--+--+--+--+',
  ];

  MagicArray() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = MagicArrayPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = MagicArrayEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveMagicArrayClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'A3 * A3');
    clueWrapper(name: 'A3', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'A4', length: 3, valueDesc: r'( A6 - D9 ) * ( A3 + D9 )');
    clueWrapper(name: 'A6', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A8', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A10', length: 2, valueDesc: r'D1 = $DP #result');
    clueWrapper(name: 'A11', length: 3, valueDesc: r'#palindrome');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'D2', length: 5, valueDesc: r'$multiple (D1 * D1)');
    clueWrapper(
        name: 'D3', length: 5, valueDesc: r'$multiple (A7 * ( A6 - D1 ))');
    clueWrapper(name: 'D5', length: 2, valueDesc: r'#Fibonacci');
    clueWrapper(name: 'D6', length: 2, valueDesc: r'D5 - #cube');
    clueWrapper(name: 'D9', length: 2, valueDesc: r'');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(MagicArrayVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  var firstPhase = true;
  @override
  // ignore: unnecessary_overrides
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

    puzzle.clues['A1']!.answer = 225;
    puzzle.clues['A3']!.answer = 15;
    puzzle.clues['A4']!.answer = 584;
    puzzle.clues['A6']!.answer = 66;
    puzzle.clues['A7']!.answer = 59;
    puzzle.clues['A8']!.answer = 251;
    puzzle.clues['A10']!.answer = 55;
    puzzle.clues['A11']!.answer = 848;
    puzzle.clues['D1']!.answer = 25;
    puzzle.clues['D2']!.answer = 25625;
    puzzle.clues['D3']!.answer = 14514;
    puzzle.clues['D5']!.answer = 89;
    puzzle.clues['D6']!.answer = 62;
    puzzle.clues['D9']!.answer = 58;

    super.solve(true);
    // firstPhase = false;
    // super.solve(iteration);
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
  bool solveMagicArrayClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as MagicArrayPuzzle;
    var clue = v as MagicArrayClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        if (firstPhase) {
          updated = puzzle.solveExpressionEvaluator(
              clue, clue.exp, possibleValue, possibleVariables!, validClue);
        } else {
          updated = puzzle.solveRelatedClues(
              clue, clue.exp, possibleValue, possibleVariables!, validClue);
        }
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
  bool updateClues(MagicArrayPuzzle thisPuzzle, Clue clue,
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
    if (!isEntry && updated) {
      // Maintain clue value order
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
      // }
    }
    return updated;
  }
}
