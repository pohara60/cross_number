library gallivanting;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Gallivanting API.
class Gallivanting extends Crossnumber<GallivantingPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 |3 :4 |5 :6 |',
    '+::+::+::+::+::+::+',
    '|7 :  :  |8 :  :  |',
    '+::+::+::+--+::+--+',
    '|  |9 :  |10:  :11|',
    '+::+--+::+::+--+::+',
    '|12:13|14:  |15:  |',
    '+::+::+--+::+::+::+',
    '|  |16:17|18:  :  |',
    '+::+--+::+--+::+::+',
    '|19:  |20:  :  |  |',
    '+--+--+--+--+--+--+',
  ];

  Gallivanting() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = GallivantingPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Select the appropriate branch in the test below
    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = GallivantingEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveGallivantingClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 2, valueDesc: r'');
    clueWrapper(name: 'A3', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A5', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'A7', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A8', length: 3, valueDesc: r'$multiple D6 ');
    clueWrapper(
        name: 'A9', length: 2, valueDesc: r'$multiple A14 = $reverse A15');
    clueWrapper(
        name: 'A10', length: 3, valueDesc: r'#palindrome = $divisor D1');
    clueWrapper(
        name: 'A12', length: 2, valueDesc: r'$divisor D1 = $reverse A19');
    clueWrapper(name: 'A14', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A15', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'A16', length: 2, valueDesc: r'A19 + D13 = $reverse A1');
    clueWrapper(
        name: 'A18',
        length: 3,
        valueDesc: r'$digits $prime #result = $digits D10');
    clueWrapper(name: 'A19', length: 2, valueDesc: r'$fibonacci $divisor D3');
    clueWrapper(name: 'A20', length: 3, valueDesc: r'#ascendingconsecutive');
    clueWrapper(name: 'D1', length: 6, valueDesc: r'$allDigits1to6 #integer');
    clueWrapper(
        name: 'D2',
        length: 3,
        valueDesc: r'$firstTwoDigitsSumToThird #integer');
    clueWrapper(name: 'D3', length: 4, valueDesc: r'#descending');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'#Catalan = $reverse D6');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'$descending #prime');
    clueWrapper(name: 'D6', length: 2, valueDesc: r'$divisor A8');
    clueWrapper(name: 'D10', length: 3, valueDesc: r'#descending');
    clueWrapper(name: 'D11', length: 4, valueDesc: r'#descending');
    clueWrapper(name: 'D13', length: 2, valueDesc: r'$multiple A12');
    clueWrapper(name: 'D15', length: 3, valueDesc: r'$multiple D17');
    clueWrapper(name: 'D17', length: 2, valueDesc: r'$divisor D1');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(GallivantingVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

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
  bool solveGallivantingClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as GallivantingPuzzle;
    var clue = v as GallivantingClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        updated = puzzle.solveExpressionEvaluator(clue, clue.exp, possibleValue,
            possibleVariables!, validClue, null, 100000);
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
  bool updateClues(GallivantingPuzzle thisPuzzle, Clue clue,
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
