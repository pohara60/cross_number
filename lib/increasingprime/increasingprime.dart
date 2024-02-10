library increasingprime;

import 'dart:math';
import 'package:collection/collection.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import "../set.dart";
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the IncreasingPrime API.
class IncreasingPrime extends Crossnumber<IncreasingPrimePuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|A :a :b |B :c |',
    '+--+::+::+--+::+',
    '|C :  |D :d :  |',
    '+--+::+--+::+::+',
    '|e |E :f :  :  |',
    '+::+--+::+--+::+',
    '|F :g :  :h |  |',
    '+::+::+--+::+--+',
    '|G :  :j |H :  |',
    '+::+--+::+::+--+',
    '|J :  |K :  :  |',
    '+--+--+--+--+--+',
  ];

  IncreasingPrime() {
    puzzle = IncreasingPrimePuzzle.grid(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = IncreasingPrimeEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          solve: solveIncreasingPrimeClue,
        );
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
        var clue = IncreasingPrimeClue(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            solve: solveIncreasingPrimeClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'I', valueDesc: r'j( f - C )');
    clueWrapper(name: 'II', valueDesc: r'C + e - g - h');
    clueWrapper(name: 'III', valueDesc: r'G - 2*b');
    clueWrapper(name: 'IV', valueDesc: r'G - J + K');
    clueWrapper(name: 'V', valueDesc: r'D - H - j');
    clueWrapper(name: 'VI', valueDesc: r'A + B - K');
    clueWrapper(name: 'VII', valueDesc: r'd + e - K');
    clueWrapper(name: 'VIII', valueDesc: r'F - a - H');
    clueWrapper(name: 'IX', valueDesc: r'b + E - G');
    clueWrapper(name: 'X', valueDesc: r'C + c + h');

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
      puzzle.letters[letter] = IncreasingPrimeVariable(letter);
    }

    // Get Entry expressions from Clue expressions
    for (var clue in puzzle.clues.values) {
      for (var entryName in clue.entryReferences) {
        // Rearrange expression for new subject
        var expText = clue.exp.rearrangeExpressionText(entryName, clue.name);
        if (expText != null) {
          puzzle.entries[entryName]!
              .addExpression(expText, entryNames: entryNames);
        }
      }
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    // clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as prceeding may update them
    clueError += puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  List<int> primes = [3, 5, 11, 17, 23];
  List<int> getPrimes() {
    return primes;
  }

  List<int> product3Primes = [];
  Map<int, List<int>> product3PrimesList = {};
  List<int> getProduct3Primes() {
    if (product3Primes.length == 0) {
      for (var f1 in getPrimes()) {
        for (var f2 in getPrimes().where((f2) => f2 > f1)) {
          for (var f3 in getPrimes().where((f3) => f3 > f2)) {
            var product = f1 * f2 * f3;
            product3Primes.add(product);
            product3PrimesList[product] = [f1, f2, f3];
          }
        }
      }
      product3Primes.sort();
    }
    return product3Primes;
  }

  bool check3Primes(int product) {
    if (!getProduct3Primes().contains(product)) return false;
    return true;
  }

  @override
  void solve([bool iteration = true]) {
    // Initialise clue values
    var numClues = puzzle.clues.length;
    var products = getProduct3Primes();
    for (var clue in puzzle.clues.values) {
      var clueIndex = romanToDecimal(clue.name);
      clue.values = Set.from(products.whereIndexed((index, element) =>
          index >= clueIndex - 1 &&
          index <= clueIndex + products.length - numClues - 1));
      clue.min = clue.values!.first;
      clue.max = clue.values!.last;
      if (Crossnumber.traceSolve) {
        print(
            'solve: ${clue.runtimeType} ${clue.name} values=${clue.values!.toShortString()}');
      }
    }

    super.solve(iteration);
  }

  // Validate possible clue value
  // Each answer may be expressed as p1 x p2 x p3 where the pi are distinct primes
  // and come from the set {3, 5, 11, 17, 23}.
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
    if (!(clue is IncreasingPrimeEntry) && !check3Primes(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveIncreasingPrimeClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as IncreasingPrimePuzzle;
    var clue = v as IncreasingPrimeClue;

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
      IncreasingPrimePuzzle puzzle, clueName, Set<int> possibleValues,
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
    }
    return updated;
  }
}
