library workingback2;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the WorkingBack2 API.
class WorkingBack2 extends Crossnumber<WorkingBack2Puzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :  :2 |3 :4 :5 |',
    '+::+--+::+::+::+::+',
    '|  |6 :  :  |7 :  |',
    '+--+--+::+--+::+::+',
    '|8 |9 :  |10:  |  |',
    '+::+::+--+::+--+--+',
    '|11:  |12:  :  |13|',
    '+::+::+::+::+--+::+',
    '|14:  :  |15:  :  |',
    '+--+--+--+--+--+--+',
  ];

  WorkingBack2() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = WorkingBack2Puzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = WorkingBack2Entry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveWorkingBack2Clue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'A12 - D10');
    clueWrapper(name: 'A3', length: 3, valueDesc: r'$ds A7 = $ds #result');
    clueWrapper(name: 'A6', length: 3, valueDesc: r'$multiple D13');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'D5 - D3');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'A10', length: 2, valueDesc: r'#Fibonacci');
    clueWrapper(name: 'A11', length: 2, valueDesc: r'D12 - D1');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A14', length: 3, valueDesc: r'A15 - A6');
    clueWrapper(name: 'A15', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'$squareroot A1');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'#palindrome');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'$reverse D1');
    clueWrapper(name: 'D4', length: 3, valueDesc: r'$multiple A10');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'$factor D2');
    clueWrapper(name: 'D8', length: 3, valueDesc: r'#palindrome');
    clueWrapper(name: 'D9', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D10', length: 3, valueDesc: r'$multiple D5');
    clueWrapper(name: 'D12', length: 2, valueDesc: r'#Lucas');
    clueWrapper(name: 'D13', length: 2, valueDesc: r'$reverse D12');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(WorkingBack2Variable(letter));
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
  bool solveWorkingBack2Clue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as WorkingBack2Puzzle;
    var clue = v as WorkingBack2Clue;
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
  bool updateClues(WorkingBack2Puzzle thisPuzzle, Clue clue,
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
