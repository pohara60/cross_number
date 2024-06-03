library inbetweeners;

import 'dart:math';

import 'package:powers/powers.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../generators.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Inbetweeners API.
class Inbetweeners extends Crossnumber<InbetweenersPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :2 :  :3 |4 :  :5 |',
    '+--+::+--+::+::+--+::+',
    '|6 :  :7 |8 :  :9 :  |',
    '+::+::+::+--+::+::+::+',
    '|10:  :  :11|12:  :  |',
    '+::+--+::+::+--+::+--+',
    '|13:  :  |14:  :  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  Inbetweeners() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = InbetweenersPuzzle.fromGridString(gridString);
    this.puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, List<String>? addDesc}) {
      try {
        var clue = InbetweenersEntry(
          name: name!,
          length: length,
          addDesc: addDesc,
          solve: solveInbetweenersClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 4, addDesc: [r'BN^S', r'ABE']);
    clueWrapper(name: 'A4', length: 3, addDesc: [r'EI', r'BDS']);
    clueWrapper(name: 'A6', length: 3, addDesc: [r'I*I', r'DINN']);
    clueWrapper(name: 'A8', length: 4, addDesc: [r'ADDNNU', r'DDEOS']);
    clueWrapper(name: 'A10', length: 4, addDesc: [r'ND^U', r'AESS']);
    clueWrapper(name: 'A12', length: 3, addDesc: [r'OS', r'EE']);
    clueWrapper(name: 'A13', length: 3, addDesc: [r'DDRU', r'OU']);
    clueWrapper(name: 'A14', length: 4, addDesc: [r'EUU', r'BBN']);
    clueWrapper(name: 'D2', length: 3, addDesc: [r'DRRR', r'NNRU']);
    clueWrapper(name: 'D3', length: 2, addDesc: [r'AS', r'DRR']);
    clueWrapper(name: 'D4', length: 3, addDesc: [r'AE', r'BU']);
    clueWrapper(name: 'D5', length: 3, addDesc: [r'DDDRR', r'ANR']);
    clueWrapper(name: 'D6', length: 3, addDesc: [r'N^S', r'ADR']);
    clueWrapper(name: 'D7', length: 3, addDesc: [r'NUU', r'BDDDD']);
    clueWrapper(name: 'D9', length: 3, addDesc: [r'BU', r'NNO']);
    clueWrapper(name: 'D11', length: 2, addDesc: [r'B', r'DI']);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      'A',
      'B',
      'D',
      'E',
      'I',
      'N',
      'O',
      'R',
      'S',
      'U',
    ];
    for (var letter in letters) {
      puzzle.addVariable(InbetweenersVariable(letter));
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkPuzzleVariableReferences();
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

    super.solve(iteration);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (value < 0) return false;
    // The expression value gives a bound for the actual value
    // if (clue.min != null && value < clue.min!) return false;
    // if (clue.max != null && value > clue.max!) return false;
    // if (clue.values != null && !clue.values!.contains(value)) return false;
    // if (!clue.digitsMatch(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveInbetweenersClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as InbetweenersPuzzle;
    var clue = v as InbetweenersClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        updated = puzzle.solveExpressionEvaluator(
            clue, clue.exp, possibleValue, possibleVariables!, validClue);
      } else {
        var first = true;
        var minValue = clue.min! - 1;
        var maxValue = clue.max! + 1;
        // Reset clue min/max to allow bounds outside values
        clue.min = 10.pow(clue.length! - 1) as int;
        clue.max = (10.pow(clue.length!) as int) - 1;
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
            if (first) {
              first = false;
              if (possibleValue.isEmpty)
                throw SolveException('${clue.name} No values for exp $exp');
              minValue = possibleValue.reduce(min);
            } else {
              if (possibleValueExp.isEmpty)
                throw SolveException('${clue.name} No values for exp $exp');
              maxValue = possibleValueExp.reduce(max);
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
        // Values are primes in range min to max
        possibleValue.clear();
        possibleValue.addAll(generatePrimes(minValue, maxValue));
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
      InbetweenersPuzzle puzzle, String clueName, Set<int> possibleValues,
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
