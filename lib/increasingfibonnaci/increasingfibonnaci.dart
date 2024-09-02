library increasingfibonnaci;

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

  @override
  void initCrossnumber() {
    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = IncreasingFibonnaciEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          solve: solveIncreasingFibonnaciClue,
        );
        puzzle.addEntry(entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += '${e.msg}\n';
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
        clueErrors += '${e.msg}\n';
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

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(IncreasingFibonnaciVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    puzzle.clues['I']!.answer = 15;
    puzzle.clues['II']!.answer = 24;
    puzzle.clues['III']!.answer = 39;
    puzzle.clues['IV']!.answer = 40;
    puzzle.clues['V']!.answer = 65;
    puzzle.clues['VI']!.answer = 104;
    puzzle.clues['VII']!.answer = 120;
    puzzle.clues['VIII']!.answer = 195;
    puzzle.clues['IX']!.answer = 312;
    puzzle.clues['X']!.answer = 520;
    puzzle.entries['A']!.answer = 244;
    puzzle.entries['a']!.answer = 45;
    puzzle.entries['b']!.answer = 481;
    puzzle.entries['B']!.answer = 21;
    puzzle.entries['c']!.answer = 18;
    puzzle.entries['C']!.answer = 95;
    puzzle.entries['d']!.answer = 92;
    puzzle.entries['D']!.answer = 68;
    puzzle.entries['e']!.answer = 60;
    puzzle.entries['E']!.answer = 27;
    puzzle.entries['F']!.answer = 100;
    super.solve(iteration);
  }

  List<int> fibonnaciLessThan20 = [];
  List<int> getFibonnaciLessThan20() {
    if (fibonnaciLessThan20.isEmpty) {
      fibonnaciLessThan20 = generateFibonacci(1, 20).toList();
    }
    return fibonnaciLessThan20;
  }

  List<int> product3FibonnaciLessThan20 = [];
  Map<int, List<int>> product3Fibonnaci = {};
  List<int> getProduct3FibonnaciLessThan20() {
    if (product3FibonnaciLessThan20.isEmpty) {
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
    /// Each answer may be expressed as  F1 x F2 x F3 where the Fi are distinct
    /// and come from five distinct Fibonacci numbers less than 20 to be determined
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
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }
    if ((clue is! EntryMixin) && !check5Fibonnaci(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveIncreasingFibonnaciClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as IncreasingFibonnaciPuzzle;
    var clue = v as IncreasingFibonnaciClue;

    var updated = false;
    if (clue.valueDesc?.isNotEmpty ?? false) {
      updated = puzzle.solveExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables!, validClue);
    } else {
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
  bool updateClues(IncreasingFibonnaciPuzzle thisPuzzle, Clue clue,
      Set<int> possibleValues, Set<Variable> updatedVariables,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    var updated = super.updateClues(
        thisPuzzle, clue, possibleValues, updatedVariables,
        isFocus: isFocus, isEntry: isEntry, focusClue: focusClue);
    if (!isEntry && updated) {
      thisPuzzle.maintainClueValueOrder(
        clue,
        updatedVariables,
        (String a, String b) => romanToDecimal(a) - romanToDecimal(b),
      );
      if (clue.isSet) {
        set5Fibonnaci(clue.values!.first);
      }
    }
    return updated;
  }
}
