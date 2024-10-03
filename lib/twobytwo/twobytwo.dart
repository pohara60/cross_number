library twobytwo;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the TwoByTwo API.
class TwoByTwo extends Crossnumber<TwoByTwoPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :2 :3 |4 :5 |6 :7 |',
    '+::+::+::+::+::+::+::+',
    '|8 :  |9 :  |10:  :  |',
    '+--+::+--+--+::+--+::+',
    '|11:  :12|13:  |14:  |',
    '+::+--+::+::+--+::+--+',
    '|15:16|17:  :18|19:20|',
    '+--+::+--+::+::+--+::+',
    '|21:  |22:  |23:24:  |',
    '+::+--+::+--+--+::+--+',
    '|25:26:  |27:28|29:30|',
    '+::+::+::+::+::+::+::+',
    '|31:  |32:  |33:  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  TwoByTwo() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = TwoByTwoPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);
    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = TwoByTwoEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveTwoByTwoClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'');
    clueWrapper(name: 'A4', length: 2, valueDesc: r'');
    clueWrapper(name: 'A6', length: 2, valueDesc: r'');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'#cube');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'');
    clueWrapper(
        name: 'A10', length: 3, valueDesc: r'A8 = $sumDigitSquares #result');
    clueWrapper(name: 'A11', length: 3, valueDesc: r'');
    clueWrapper(name: 'A13', length: 2, valueDesc: r'$reverse A32');
    clueWrapper(name: 'A14', length: 2, valueDesc: r'');
    clueWrapper(name: 'A15', length: 2, valueDesc: r'');
    clueWrapper(name: 'A17', length: 3, valueDesc: r'');
    clueWrapper(name: 'A19', length: 2, valueDesc: r'$prime $reverse A29');
    clueWrapper(name: 'A21', length: 2, valueDesc: r'$multiple D16');
    clueWrapper(name: 'A22', length: 2, valueDesc: r'');
    clueWrapper(name: 'A23', length: 3, valueDesc: r'#cube');
    clueWrapper(name: 'A25', length: 3, valueDesc: r'');
    clueWrapper(name: 'A27', length: 2, valueDesc: r'');
    clueWrapper(name: 'A29', length: 2, valueDesc: r'$prime $reverse A19');
    clueWrapper(name: 'A31', length: 2, valueDesc: r'');
    clueWrapper(name: 'A32', length: 2, valueDesc: r'');
    clueWrapper(name: 'A33', length: 3, valueDesc: r'');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'#powerof2');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'#palindrome');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'');
    clueWrapper(name: 'D6', length: 2, valueDesc: r'');
    clueWrapper(name: 'D7', length: 3, valueDesc: r'$multiple D5');
    clueWrapper(name: 'D11', length: 2, valueDesc: r'');
    clueWrapper(name: 'D12', length: 2, valueDesc: r'');
    clueWrapper(name: 'D13', length: 3, valueDesc: r'');
    clueWrapper(name: 'D14', length: 2, valueDesc: r'');
    clueWrapper(name: 'D16', length: 2, valueDesc: r'');
    clueWrapper(name: 'D18', length: 2, valueDesc: r'');
    clueWrapper(name: 'D20', length: 2, valueDesc: r'');
    clueWrapper(name: 'D21', length: 3, valueDesc: r'');
    clueWrapper(name: 'D22', length: 3, valueDesc: r'');
    clueWrapper(name: 'D24', length: 3, valueDesc: r'');
    clueWrapper(name: 'D26', length: 2, valueDesc: r'');
    clueWrapper(name: 'D27', length: 2, valueDesc: r'');
    clueWrapper(name: 'D28', length: 2, valueDesc: r'');
    clueWrapper(name: 'D30', length: 2, valueDesc: r'');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(TwoByTwoVariable(letter));
    }

    addTwoByTwo();

    puzzle.finalize();

    super.initCrossnumber();
  }

  void addTwoByTwo() {
    // Each 3-digit entry is the last three digits of the product of the
    // two 2-digit entries in its row or column
    // Add constraint expression: e3 = last3digits(e2a*e2b)
    var grid = puzzle.grid!;
    for (var row in grid.rows) {
      var entries =
          row.expand((cell) => cell.entries.where((entry) => entry.isAcross));
      var entryLength3 =
          entries.firstWhere((element) => element.length == 3) as TwoByTwoEntry;
      var entryLength2 =
          entries.where((element) => element.length == 2).toSet();
      var expDesc =
          '£last3digits(${entryLength2.first.name},${entryLength2.last.name})';
      // print(
      //     'Across entry3=${entryLength3.name}, entry2=${entryLength2.map((e) => e.name)}, $expDesc');
      entryLength3.addExpression(expDesc);
    }
    for (var col = 0; col < grid.numCols; col++) {
      var entries = grid.rows
          .map((r) => r[col])
          .expand((cell) => cell.entries.where((entry) => entry.isDown));
      var entryLength3 =
          entries.firstWhere((element) => element.length == 3) as TwoByTwoEntry;
      var entryLength2 =
          entries.where((element) => element.length == 2).toSet();
      // print(
      //     'Down entry3=${entryLength3.name}, entry2=${entryLength2.map((e) => e.name)}');
      var expDesc =
          '£last3digits(${entryLength2.first.name},${entryLength2.last.name})';
      entryLength3.addExpression(expDesc);
    }
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

    super.solve(false);
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
  bool solveTwoByTwoClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as TwoByTwoPuzzle;
    var clue = v as TwoByTwoClue;
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
  bool updateClues(TwoByTwoPuzzle thisPuzzle, Clue clue,
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
