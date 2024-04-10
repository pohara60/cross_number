library increasingfibonnaci;

import 'dart:math';

import 'package:crossnumber/generators.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the IncreasingFibonnaci API.
class IncreasingFibonnaci extends Crossnumber<IncreasingFibonnaciPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|A :a :b |B :c |',
    '+--+::+::+--+::+',
    '|Cd:  |  |De:  |',
    '+::+--+::+::+--+',
    '|E :  |F :  :  |',
    '+--+--+--+--+--+',
  ];

  IncreasingFibonnaci() {
    puzzle = IncreasingFibonnaciPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = IncreasingFibonnaciEntry(
            name: entrySpec.name, length: entrySpec.length);
        puzzle.addEntry(entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += e.msg + '\n';
      }
    }

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    // For alpha entry names we pass the names to clue expression parsing
    // Until we create a clue, then entries are returned as clues (legacy)
    var entryNames = puzzle.clues.keys.toList();

    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = IncreasingFibonnaciClue(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            solve: solveIncreasingFibonnaciClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'I', valueDesc: r'e - a');
    clueWrapper(name: 'II', valueDesc: r'a - B');
    clueWrapper(name: 'III', valueDesc: r'B + c');
    clueWrapper(name: 'IV', valueDesc: r'F - e');
    clueWrapper(name: 'V', valueDesc: r'd - E');
    clueWrapper(name: 'VI', valueDesc: r'A/2 - c');
    clueWrapper(name: 'VII', valueDesc: r'e + e');
    clueWrapper(name: 'VIII', valueDesc: r'C + F');
    clueWrapper(name: 'IX', valueDesc: r'A + D');
    clueWrapper(name: 'X', valueDesc: r'B + b + c');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    // Not needed when create entries from grid
    // puzzle.validateEntriesFromGrid();

    puzzle.addDigitIdentityFromGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.letters[letter] = IncreasingFibonnaciVariable(letter);
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    // clueError = puzzle.checkClueClueReferences();
    // clueError += puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  List<int> fibonnaciLessThan20 = [];
  List<int> getFibonnaciLessThan20() {
    if (fibonnaciLessThan20.length == 0) {
      fibonnaciLessThan20 = generateFibonacci(1, 20).toList();
    }
    return fibonnaciLessThan20;
  }

  List<int> product3FibonnaciLessThan20 = [];
  Map<int, List<int>> product3Fibonnaci = {};
  List<int> getProduct3FibonnaciLessThan20() {
    if (product3FibonnaciLessThan20.length == 0) {
      for (var f1 in getFibonnaciLessThan20()) {
        for (var f2 in getFibonnaciLessThan20().where((f2) => f2 > f1)) {
          for (var f3 in getFibonnaciLessThan20().where((f3) => f3 > f2)) {
            var product = f1 * f2 * f3;
            product3FibonnaciLessThan20.add(product);
            product3Fibonnaci[product] = [f1, f2, f3];
          }
        }
      }
      product3FibonnaciLessThan20.sort();
    }
    return product3FibonnaciLessThan20;
  }

  Set<int> known5Fibonnaci = {};
  bool check5Fibonnaci(int product) {
    if (!getProduct3FibonnaciLessThan20().contains(product)) return false;
    var unknown = 0;
    for (var f in product3Fibonnaci[product]!) {
      if (!known5Fibonnaci.contains(f)) unknown++;
    }
    if (unknown > 5 - known5Fibonnaci.length) return false;
    return true;
  }

  void set5Fibonnaci(int product) {
    assert(product3FibonnaciLessThan20.contains(product));
    assert(check5Fibonnaci(product));
    for (var f in product3Fibonnaci[product]!) {
      known5Fibonnaci.add(f);
    }
  }

  // Validate possible clue value
  // Each answer may be expressed as  F1 x F2 x F3 where the Fi are distinct and
  // come from five distinct Fibonacci numbers less than 20 to be determined.
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
    if (!check5Fibonnaci(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveIncreasingFibonnaciClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as IncreasingFibonnaciPuzzle;
    var clue = v as IncreasingFibonnaciClue;

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

  @override
  bool updateClues(IncreasingFibonnaciPuzzle puzzle, String clueName,
      Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry, focusClueName: focusClueName);
    if (!isEntry && updated) {
      var clue = puzzle.clues[clueName]!;
      var newMin = clue.values!.reduce(min);
      if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      var newMax = clue.values!.reduce(max);
      if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // Clues are defined in ascending order of value
      for (var otherClue in puzzle.clues.values) {
        if (romanToDecimal(otherClue.name) > romanToDecimal(clue.name)) {
          if ((otherClue.min == null || otherClue.min! <= clue.min!)) {
            otherClue.min = clue.min! + 1;
          }
        }
        if (romanToDecimal(otherClue.name) < romanToDecimal(clue.name)) {
          if ((otherClue.max == null || otherClue.max! >= clue.max!)) {
            otherClue.max = clue.max! - 1;
          }
        }
      }
      if (clue.isSet) {
        set5Fibonnaci(clue.values!.first);
      }
    }
    return updated;
  }
}
