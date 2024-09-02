library cyclingprimes;

import 'dart:math';

import 'package:collection/collection.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../generators.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the CyclingPrimes API.
class CyclingPrimes extends Crossnumber<CyclingPrimesPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :  :2 :3 |4 |',
    '+::+--+::+::+::+',
    '|5 :6 |7 :  :  |',
    '+::+::+::+::+::+',
    '|8 :  :  |9 :  |',
    '+--+::+::+--+::+',
    '|10:  |11:12:  |',
    '+::+::+--+::+--+',
    '|  |13:  :  :  |',
    '+--+--+--+--+--+',
  ];

  CyclingPrimes() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = CyclingPrimesPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = CyclingPrimesEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          solve: solveCyclingPrimesClue,
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
    void clueWrapper(
        {String? name,
        int? length,
        String? valueDesc,
        List<String>? addDesc,
        List<String>? clueNames}) {
      try {
        var clue = CyclingPrimesClue(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          addDesc: addDesc,
          solve: solveCyclingPrimesClue,
          entryNames: entryNames,
          clueNames: clueNames,
        );
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    var clueNames = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O'
    ];

    clueWrapper(name: 'A', length: 2);
    clueWrapper(name: 'B', length: 2);
    clueWrapper(
        name: 'C', valueDesc: r'2 * B', clueNames: clueNames, length: 2);
    clueWrapper(
        name: 'D', valueDesc: r'A^2 - E', clueNames: clueNames, length: 2);
    clueWrapper(name: 'E', length: 2);
    clueWrapper(name: 'F', length: 3);
    clueWrapper(name: 'G', length: 3);
    clueWrapper(name: 'H', length: 3);
    clueWrapper(name: 'I', length: 3);
    clueWrapper(name: 'J', length: 3);
    clueWrapper(name: 'K', length: 4);
    clueWrapper(
        name: 'L',
        valueDesc: r'A( B + D ) + G',
        clueNames: clueNames,
        length: 4);
    clueWrapper(
        name: 'M', valueDesc: r'N - AB - E', clueNames: clueNames, length: 4);
    clueWrapper(
        name: 'N', valueDesc: r'(B^2)*C', clueNames: clueNames, length: 4);
    clueWrapper(
        name: 'O',
        valueDesc: r'AH',
        addDesc: ['BG', 'CF'],
        clueNames: clueNames,
        length: 4);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    // Get Clue expressions from other Clue expressions
    for (var clue in puzzle.clues.values) {
      for (var exp in clue.expressions) {
        for (var otherClueName in clue.clueNameReferences) {
          // Rearrange expression for new subject
          var expText = exp.rearrangeExpressionText(otherClueName, clue.name);
          if (expText != null) {
            puzzle.clues[otherClueName]!
                .addExpression(expText, clueNames: clueNames);
          }
        }
      }
    }

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(CyclingPrimesVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  void mapCallback() {
    var mapping = puzzle.entries.values.where((e) => e.clue != null).map((e) {
      var c = e.clue!;
      return 'Entry ${e.name}${e.values} = Clue ${c.name}${c.values}';
    }).join('\n');
    print('Mapping\n$mapping');
    print(puzzle.toSolution());
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    puzzle.clues['A']!.answer = 13;
    puzzle.clues['H']!.answer = 736;
    puzzle.clues['B']!.answer = 16;
    puzzle.clues['G']!.answer = 598;
    puzzle.clues['C']!.answer = 32;
    puzzle.clues['F']!.answer = 299;
    puzzle.clues['N']!.answer = 8192;
    puzzle.clues['O']!.answer = 9568;
    super.solve(false);

    // Map Clues to Entries
    print('MAPPING CLUES TO ENTRIES-----------------------------');
    var clueEntries = findClueEntries();
    puzzle.mapOrderedCluesToEntries(clueEntries, mapCallback);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }
    if (!isCyclicPrime(value)) {
      return false;
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveCyclingPrimesClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as CyclingPrimesPuzzle;
    var clue = v as CyclingPrimesClue;
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
        var values = clue.getValuesFromDigits() ?? clue.getValuesFromLength();
        if (values != null) {
          var okValues =
              values.where((value) => validClue(clue, value, [], []));
          possibleValue.addAll(okValues);
        } else {
          // No further action
          throw SolveException();
        }
      }
    }
    return updated;
  }

  @override
  bool updateClues(CyclingPrimesPuzzle thisPuzzle, Clue clue,
      Set<int> possibleValues, Set<Variable> updatedVariables,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    // if (!isFocus && !isEntry) {
    //   return false;
    // }
    var updated = super.updateClues(
        thisPuzzle, clue, possibleValues, updatedVariables,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue value order
      var newMin = clue.values!.reduce(min);
      if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      var newMax = clue.values!.reduce(max);
      if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // Clues are defined in ascending order of value
      var lowerClues = thisPuzzle.clues.values
          .where((otherClue) => clue.name.compareTo(otherClue.name) > 0)
          .sorted((clue, otherClue) => -clue.name.compareTo(otherClue.name));
      var higherClues = thisPuzzle.clues.values
          .where((otherClue) => clue.name.compareTo(otherClue.name) < 0)
          .sorted((clue, otherClue) => clue.name.compareTo(otherClue.name));

      var prevMin = clue.min!;
      var prevMax = clue.max!;
      for (var otherClue in lowerClues) {
        if ((otherClue.max == null || otherClue.max! >= prevMax)) {
          otherClue.max = prevMax - 1;
          if (otherClue.values != null) {
            // Remove some values
            var removeValues = otherClue.values!
                .where((value) => value > otherClue.max!)
                .toList();
            if (removeValues.isNotEmpty) {
              otherClue.removeValues(removeValues);
              updatedVariables.add(otherClue);
              otherClue.max = otherClue.values!.reduce(max);
            }
          }
        }
        prevMax = otherClue.max!;
      }
      for (var otherClue in higherClues) {
        if ((otherClue.min == null || otherClue.min! <= prevMin)) {
          otherClue.min = prevMin + 1;
          if (otherClue.values != null) {
            // Remove some values
            var removeValues = otherClue.values!
                .where((value) => value < otherClue.min!)
                .toList();
            if (removeValues.isNotEmpty) {
              otherClue.removeValues(removeValues);
              updatedVariables.add(otherClue);
              otherClue.min = otherClue.values!.reduce(min);
            }
          }
        }
        prevMin = otherClue.min!;
      }
    }
    return updated;
  }

  Map<CyclingPrimesClue, List<CyclingPrimesEntry>> findClueEntries() {
    var clueEntries = <CyclingPrimesClue, List<CyclingPrimesEntry>>{};
    for (var clue in puzzle.clues.values) {
      var entries = findPossibleEntriesForClue(clue);
      clueEntries[clue] = entries;
    }
    // for (var clue in puzzle.clues.values) {
    //   var entries = clueEntries[clue]!;
    //   print(
    //       'Clue ${clue.name}, entries, ${puzzle.entries.values.map((e) => entries.contains(e) ? e.name : '').join(',')}');
    // }
    return clueEntries;
  }

  List<CyclingPrimesEntry> findPossibleEntriesForClue(CyclingPrimesClue clue) {
    var result = <CyclingPrimesEntry>[];
    for (var entry in puzzle.entries.values) {
      var value = clue.value;
      var ok = true;
      if (entry.length == clue.length) {
        if (clue.value != null) {
          for (var d = entry.length! - 1; d >= 0; d--) {
            var digit = value! % 10;
            if (!entry.digits[d].contains(digit)) {
              ok = false;
              break;
            }
            value ~/= 10;
          }
        }
        if (ok) result.add(entry);
      }
    }
    return result;
  }
}
