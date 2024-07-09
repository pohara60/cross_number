library squarestriangles;

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:powers/powers.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../generators.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the SquaresTriangles API.
class SquaresTriangles extends Crossnumber<SquaresTrianglesPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :  :2 :  |3 :4 :5 |',
    '+::+--+::+--+::+::+::+',
    '|6 :  :  |7 :  :  |  |',
    '+::+--+::+::+::+--+::+',
    '|8 :9 :  :  |10:  :  |',
    '+::+::+::+::+::+--+--+',
    '|  |11:  :  :  :  |12|',
    '+--+::+--+::+--+--+::+',
    '|13:  |14|15:16:  :  |',
    '+::+--+::+::+::+--+::+',
    '|17:  :  :  |  |18:  |',
    '+::+--+::+--+::+--+::+',
    '|19:  :  :  |20:  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  SquaresTriangles() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = SquaresTrianglesPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = SquaresTrianglesEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          valueDesc: entrySpec.name[0] == 'A' ? '#square' : '#triangular',
          solve: solveSquaresTrianglesClue,
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
        {String? name, int? length, String? valueDesc, List<String>? addDesc}) {
      try {
        var clue = SquaresTrianglesClue(
            name: name!,
            length: null,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solveSquaresTrianglesClue,
            entryNames: entryNames);
        puzzle.addClue(clue);

        var maxValue = (10.pow(length!) - 1).toInt();
        var minValue = (10.pow(length - 1)).toInt();
        if (name[0] == 'A') {
          maxValue = sqrt(maxValue).toInt();
          minValue = sqrt(minValue).toInt();
        } else {
          maxValue = sqrt(maxValue * 2).toInt() + 1;
          minValue = sqrt(minValue * 2).toInt();
        }
        clue.min = minValue;
        clue.max = maxValue;
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 4, valueDesc: r'');
    clueWrapper(name: 'A3', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A6', length: 3, valueDesc: r'');
    clueWrapper(name: 'A7', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A8', length: 4, valueDesc: r'');
    clueWrapper(name: 'A10', length: 3, valueDesc: r'');
    clueWrapper(name: 'A11', length: 5, valueDesc: r'');
    clueWrapper(name: 'A13', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'A15', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'A17', length: 4, valueDesc: r'');
    clueWrapper(name: 'A18', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A19', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'A20', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D1', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'D2', length: 4, valueDesc: r'');
    clueWrapper(name: 'D3', length: 4, valueDesc: r'');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D7', length: 5, valueDesc: r'#prime');
    clueWrapper(name: 'D9', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D12', length: 4, valueDesc: r'#prime');
    clueWrapper(name: 'D13', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D14', length: 3, valueDesc: r'');
    clueWrapper(name: 'D16', length: 3, valueDesc: r'#prime');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    // Clues and Entries refer to each other
    for (var clue in puzzle.clues.values) {
      for (var entry in puzzle.entries.values) {
        clue.addReferrer(entry);
        entry.addReferrer(clue);
      }
    }
    // Pairs of clues refer to each other
    puzzle.clues['A1']!.addReferrer(puzzle.clues['D14']!);
    puzzle.clues['D14']!.addReferrer(puzzle.clues['A1']!);
    puzzle.clues['D4']!.addReferrer(puzzle.clues['A6']!);
    puzzle.clues['A6']!.addReferrer(puzzle.clues['D4']!);
    puzzle.clues['D5']!.addReferrer(puzzle.clues['D9']!);
    puzzle.clues['D9']!.addReferrer(puzzle.clues['D5']!);

    puzzle.linkEntriesToGrid();

    int priorityCompareTo(Variable a, Variable b) {
      var cmp = b.priorityCompareTo(a);
      if (cmp == 0) {
        // Attempt consistent order - Entries before Clues
        if (b.variableType == VariableType.E) {
          cmp = 1;
        } else {
          cmp = -1;
        }
      }
      return cmp;
    }

    priorityQueue = PriorityQueue<Variable>(priorityCompareTo);

    puzzle.finalize();
    super.initCrossnumber();
  }

  @override
  void solve([bool iteration = true]) {
    // puzzle.clues['A7']!.answer = 16;
    super.solve(true);
  }

  // Validate possible clue value
  @override
  // ignore: avoid_renaming_method_parameters
  bool validClue(VariableClue variable, int value,
      List<String> variableReferences, List<int> variableValues) {
    // Super method checks digits which is incorrect for clues
    if (value < 0) return false;
    if (variable.min != null && value < variable.min!) return false;
    if (variable.max != null && value > variable.max!) return false;
    if (variable.values != null && !variable.values!.contains(value)) {
      return false;
    }
    if (variable.variableType == VariableType.E &&
        !variable.digitsMatch(value)) {
      return false;
    }

    // Across entries are square numbers and down entries are triangular numbers.
    // In the across clues, the clues give any properties of the square root of
    // the answer.
    // Triangular numbers can be written as n(n+1)/2 and the down clues give any
    // properties of n and (n+1).
    // All instances of square, prime and triangular numbers are given.
    // There are no cases in the down answers where both n and (n+1) have a
    // property.
    // The square roots, ns and (n+1)s are all distinct except that the three
    // pairs 1ac and 14dn, 4dn and 6ac, 5dn and 9dn each share a value.
    var clue = puzzle.clues[variable.name]!;
    var entry = puzzle.entries[variable.name]!;
    if (clue == variable && entry.values != null) {
      if (variable.isAcross) {
        var square = value * value;
        if (!entry.values!.contains(square)) {
          return false;
        }
      } else {
        var triangular1 = value * (value + 1) ~/ 2;
        var triangular2 = value * (value - 1) ~/ 2;
        if (!entry.values!.contains(triangular1) &&
            !entry.values!.contains(triangular2)) {
          return false;
        }
      }
      // The square roots, ns and (n+1)s are all distinct except that the three
      // pairs 1ac and 14dn, 4dn and 6ac, 5dn and 9dn each share a value.
      var otherClue = puzzle.getPairClue(clue);
      var knownValues = puzzle.getKnownValues(clue);
      if (otherClue != null) {
        // Pairs share a value
        if (otherClue.values != null) {
          if (clue.isAcross && otherClue.isAcross) {
            // Both squares, so the same
            if (!otherClue.values!.contains(value) ||
                knownValues.contains(value)) {
              return false;
            }
          } else {
            // For triangular clues, value may differ by one
            if (!knownValues.contains(value - 1) &&
                !otherClue.values!.contains(value) &&
                !knownValues.contains(value - 1) &&
                !otherClue.values!.contains(value - 1) &&
                !knownValues.contains(value + 1) &&
                !otherClue.values!.contains(value + 1)) {
              if (!clue.isAcross && !otherClue.isAcross) {
                // double triangular, so allow +/-2
                if (!knownValues.contains(value - 2) &&
                    !otherClue.values!.contains(value - 2) &&
                    !knownValues.contains(value + 2) &&
                    !otherClue.values!.contains(value + 2)) {
                  return false;
                }
              } else {
                return false;
              }
            }
          }
        }
      } else {
        // Distinct
        if (knownValues.contains(value)) {
          return false;
        }
      }
    } else if (entry == variable && clue.values != null) {
      if (variable.isAcross) {
        var squareRoot = sqrt(value).toInt();
        if (!clue.values!.contains(squareRoot)) {
          return false;
        }
      } else {
        var n = (sqrt(8 * value + 1) - 1) ~/ 2;
        if (!clue.values!.contains(n) && !clue.values!.contains(n + 1)) {
          return false;
        }
      }
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveSquaresTrianglesClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as SquaresTrianglesPuzzle;
    var clue = v as SquaresTrianglesClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        updated = puzzle.solveExpressionEvaluator(
            clue, clue.exp, possibleValue, possibleVariables!, validClue);
      }
    } else {
      // Values may have been set by other Clue
      var values = clue.values;
      if (clue.values == null) {
        if (clue.variableType == VariableType.E) {
          values = clue.getValuesFromDigits();
        } else {
          values = Set.from(generateIntegers(clue.min!, clue.max!));
        }
      }
      if (values != null) {
        var newValues = values.where((value) => validClue(clue, value, [], []));
        possibleValue.addAll(newValues);
      }
    }
    return updated;
  }

  @override
  bool updateClues(
      SquaresTrianglesPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(thisPuzzle, clue, possibleValues,
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
