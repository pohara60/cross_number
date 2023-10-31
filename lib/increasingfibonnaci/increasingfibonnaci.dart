library increasingfibonnaci;

import 'dart:math';

import 'package:crossnumber/generators.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
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
    puzzle = IncreasingFibonnaciPuzzle.grid(gridString);
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
            name: name,
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

    if (Crossnumber.traceInit) {
      print(puzzle.toString());
    }
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
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (value < 0) return false;
    if (clue.min != null && value < clue.min!) return false;
    if (clue.max != null && value > clue.max!) return false;
    if (!check5Fibonnaci(value)) return false;
    if (!clue.digitsMatch(value)) return false;
    return true;
  }

  int romanToDecimal(String str) {
    int value(String r) {
      if (r == 'I') return 1;
      if (r == 'V') return 5;
      if (r == 'X') return 10;
      if (r == 'L') return 50;
      if (r == 'C') return 100;
      if (r == 'D') return 500;
      if (r == 'M') return 1000;
      return -1;
    }

    int res = 0;
    for (int i = 0; i < str.length; i++) {
      int s1 = value(str[i]);
      if (i + 1 < str.length) {
        int s2 = value(str[i + 1]);
        if (s1 >= s2) {
          res = res + s1;
        } else {
          res = res + s2 - s1;
          i++;
        }
      } else {
        res = res + s1;
      }
    }
    return res;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveIncreasingFibonnaciClue(IncreasingFibonnaciClue clue,
      Set<int> possibleValue, Map<String, Set<int>> possibleVariables) {
    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, possibleValue, possibleVariables, validClue);
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
  bool updateClues(String clueName, Set<int> possibleValues) {
    var updated = super.updateClues(clueName, possibleValues);
    if (updated) {
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
