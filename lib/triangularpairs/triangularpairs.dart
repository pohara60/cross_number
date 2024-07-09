library triangularpairs;

import 'package:crossnumber/generators.dart';
import 'package:crossnumber/monadic.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the TriangularPairs API.
class TriangularPairs extends Crossnumber<TriangularPairsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 |3 |4 :  :5 |',
    '+::+::+::+::+--+::+',
    '|  |6 :  :  |7 :  |',
    '+--+::+--+::+--+::+',
    '|8 |  |9 :  |10|  |',
    '+::+--+::+--+::+--+',
    '|11:  |12:13:  |14|',
    '+::+--+::+::+::+::+',
    '|15:  :  |  |16:  |',
    '+--+--+--+--+--+--+',
  ];

  TriangularPairs() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = TriangularPairsPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = TriangularPairsEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveTriangularPairsClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'A4', length: 3, valueDesc: r'');
    clueWrapper(name: 'A6', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'$reverse #triangular');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'A11', length: 2, valueDesc: r'$reverse #triangular');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'#cube');
    clueWrapper(name: 'A15', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A16', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'D4', length: 3, valueDesc: r'');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'#palindrome');
    clueWrapper(name: 'D8', length: 3, valueDesc: r'$reverse A12');
    clueWrapper(name: 'D9', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D10', length: 3, valueDesc: r'');
    clueWrapper(name: 'D13', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'D14', length: 2, valueDesc: r'#triangular');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(TriangularPairsVariable(letter));
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkPuzzleVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    // Symmetric pairs
    puzzle.clues['A4']!.pair = puzzle.clues['A15']!;
    puzzle.clues['A6']!.pair = puzzle.clues['A12']!;
    puzzle.clues['A12']!.pair = puzzle.clues['A6']!;
    puzzle.clues['A15']!.pair = puzzle.clues['A4']!;
    puzzle.clues['D2']!.pair = puzzle.clues['D10']!;
    puzzle.clues['D4']!.pair = puzzle.clues['D9']!;
    puzzle.clues['D5']!.pair = puzzle.clues['D8']!;
    puzzle.clues['D8']!.pair = puzzle.clues['D5']!;
    puzzle.clues['D9']!.pair = puzzle.clues['D4']!;
    puzzle.clues['D10']!.pair = puzzle.clues['D2']!;

    puzzle.clues['A4']!.addReferrer(puzzle.clues['A15']!);
    puzzle.clues['A6']!.addReferrer(puzzle.clues['A12']!);
    puzzle.clues['A12']!.addReferrer(puzzle.clues['A6']!);
    puzzle.clues['A15']!.addReferrer(puzzle.clues['A4']!);
    puzzle.clues['D2']!.addReferrer(puzzle.clues['D10']!);
    puzzle.clues['D4']!.addReferrer(puzzle.clues['D9']!);
    puzzle.clues['D5']!.addReferrer(puzzle.clues['D8']!);
    puzzle.clues['D8']!.addReferrer(puzzle.clues['D5']!);
    puzzle.clues['D9']!.addReferrer(puzzle.clues['D4']!);
    puzzle.clues['D10']!.addReferrer(puzzle.clues['D2']!);

    // Two digit clues are distinct triangular numbers
    for (var clue1 in puzzle.clues.values)
      // ignore: curly_braces_in_flow_control_structures
      for (var clue2 in puzzle.clues.values) {
        if (clue1 != clue2) clue1.addReferrer(clue2);
      }

    initTwoDigitTriangular();
    initSixDigitTriangular();

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

    super.solve(iteration);
  }

  Set<int>? sixDigitTriangular;
  void initSixDigitTriangular() {
    sixDigitTriangular = Set.from(getNDigitTriangles(6));
  }

  bool checkPairTriangular(int value1, int value2) {
    var value = value1 * 1000 + value2;
    return sixDigitTriangular!.contains(value);
  }

  Set<int>? twoDigitTriangular;
  Set<int>? knownTwoDigitTriangular;
  void initTwoDigitTriangular() {
    twoDigitTriangular = Set.from(getNDigitTriangles(2));
    knownTwoDigitTriangular = <int>{};
  }

  void addKnownTwoDigitTriangular(int value) {
    var triangular = value;
    if (!twoDigitTriangular!.contains(value)) triangular = reverse(value);
    knownTwoDigitTriangular!.add(triangular);
  }

  bool checkKnownTwoDigitTriangular(int value) {
    var triangular = value;
    if (!twoDigitTriangular!.contains(value)) triangular = reverse(value);
    return (!knownTwoDigitTriangular!.contains(triangular));
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }
    // Check pairs of 3 digit numbers
    var pair = (clue as TriangularPairsClue).pair;
    if (pair != null) {
      if (pair.values != null) {
        // Check this value concatenated with any pair value is 6 digit triangular
        for (var pairValue in pair.values!) {
          if (checkPairTriangular(value, pairValue)) return true;
          if (checkPairTriangular(pairValue, value)) return true;
        }
        return false;
      }
    }
    // Check 2 digit triangular numbers
    if (clue.length == 2) {
      if (!checkKnownTwoDigitTriangular(value)) return false;
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveTriangularPairsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as TriangularPairsPuzzle;
    var clue = v as TriangularPairsClue;
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
  bool updateClues(
      TriangularPairsPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    var updated = super.updateClues(thisPuzzle, clue, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    // Maintain clue value order
    if (clue.isSet && clue.length == 2) {
      addKnownTwoDigitTriangular(clue.value!);
    }
    return updated;
  }
}
