library sumsquares;

import 'dart:math';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the SumSquares API.
class SumSquares extends Crossnumber<SumSquaresPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :  :2 |3 :4 :5 |6 |',
    '+::+--+::+::+::+::+::+',
    '|7 :  :  :  |8 :  :  |',
    '+::+--+::+::+::+--+::+',
    '|9 :10:  |11:  :12:  |',
    '+::+::+::+--+--+::+--+',
    '|  |  |13:  :14|  |15|',
    '+--+::+--+--+::+::+::+',
    '|16:  :17:18|19:  :  |',
    '+::+--+::+::+::+--+::+',
    '|20:21:  |22:  :  :  |',
    '+::+::+::+::+::+--+::+',
    '|  |23:  :  |24:  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  SumSquares() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = SumSquaresPuzzle.fromGridString(gridString);
    this.puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = SumSquaresEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          solve: solveSumSquaresClue,
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
    void clueWrapper(
        {String? name, int? length, String? valueDesc, List<String>? addDesc}) {
      try {
        // Fix expression
        var valueExp =
            '${valueDesc![0]}*${valueDesc[0]}+${valueDesc[1]}*${valueDesc[1]}+${valueDesc[2]}*${valueDesc[2]}';
        var clue = SumSquaresClue(
            name: name!,
            length: length,
            valueDesc: valueExp,
            addDesc: addDesc,
            solve: solveSumSquaresClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'i', valueDesc: r'DIM', length: 2);
    clueWrapper(name: 'ii', valueDesc: r'AIM', length: 2);
    clueWrapper(name: 'iii', valueDesc: r'ADN', length: 3);
    clueWrapper(name: 'iv', valueDesc: r'BIM', length: 3);
    clueWrapper(name: 'v', valueDesc: r'BDN', length: 3);
    clueWrapper(name: 'vi', valueDesc: r'DIK', length: 3);
    clueWrapper(name: 'vii', valueDesc: r'BMN', length: 3);
    clueWrapper(name: 'viii', valueDesc: r'ABN', length: 3);
    clueWrapper(name: 'ix', valueDesc: r'BDK', length: 3);
    clueWrapper(name: 'x', valueDesc: r'DEN', length: 3);
    clueWrapper(name: 'xi', valueDesc: r'AGI', length: 3);
    clueWrapper(name: 'xii', valueDesc: r'ADG', length: 3);
    clueWrapper(name: 'xiii', valueDesc: r'AGM', length: 3);
    clueWrapper(name: 'xiv', valueDesc: r'BEN', length: 3);
    clueWrapper(name: 'xv', valueDesc: r'GIN', length: 3);
    clueWrapper(name: 'xvi', valueDesc: r'ADJ', length: 3);
    clueWrapper(name: 'xvii', valueDesc: r'GKN', length: 3);
    clueWrapper(name: 'xviii', valueDesc: r'DIL', length: 3);
    clueWrapper(name: 'xix', valueDesc: r'ILM', length: 3);
    clueWrapper(name: 'xx', valueDesc: r'FIN', length: 4);
    clueWrapper(name: 'xxi', valueDesc: r'AHM', length: 4);
    clueWrapper(name: 'xxii', valueDesc: r'EHN', length: 4);
    clueWrapper(name: 'xxiii', valueDesc: r'FLM', length: 4);
    clueWrapper(name: 'xxiv', valueDesc: r'CIL', length: 4);
    clueWrapper(name: 'xxv', valueDesc: r'FHN', length: 4);
    clueWrapper(name: 'xxvi', valueDesc: r'CJL', length: 4);
    clueWrapper(name: 'xxvii', valueDesc: r'CDH', length: 4);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    // Get Entry expressions from Clue expressions
    // Only needed when Clue expressions refer to Entries
    for (var clue in puzzle.clues.values) {
      for (var exp in clue.expressions) {
        for (var entryName in clue.entryReferences) {
          // Rearrange expression for new subject
          var expText = exp.rearrangeExpressionText(entryName, clue.name);
          if (expText != null) {
            puzzle.entries[entryName]!
                .addExpression(expText, entryNames: entryNames);
          }
        }
      }
    }

    puzzle.linkEntriesToGrid();

    var letters = [
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
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(SumSquaresVariable(letter));
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkPuzzleVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    initSumSquares();

    super.initCrossnumber();
  }

  void mapCallback() {
    var mapping =
        "${puzzle.entries.values.where((e) => e.clue != null).map((e) {
      var c = e.clue!;
      return '${e.name}=${c.name}${c.values})';
    }).join(',')}";
    print('Mapping $mapping');
    print(puzzle.toSolution());
  }

  @override
  void solve([bool iteration = false]) {
    super.solve(iteration);

    // Match clues to entries
    // Map clues to entries, updates entry values and digits
    puzzle.mapCluesToEntries(mapCallback);

    print("SOLUTION-----------------------------");
    print(puzzle.toSummary());
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveSumSquaresClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as SumSquaresPuzzle;
    var clue = v as SumSquaresClue;
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
      SumSquaresPuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue value order
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

  void initSumSquares() {
    // Variables are first 14 prime numbers
    // Each clue PQR is evaluated as P*P+Q*Q+R*R
    // Clues are in ascending order

    // Get clue lengths
    // var lengths = <int>[];
    // var maxLength = -1;
    // var minLength = 5;
    // for (var entry in puzzle.entries.values) {
    //   lengths.add(entry.length!);
    //   if (entry.length! < minLength) minLength = entry.length!;
    //   if (entry.length! > maxLength) maxLength = entry.length!;
    // }
    // lengths.sort();
    // print('lengths=$lengths');

    // Get possible values
    // var minValue = pow(10, minLength - 1);
    // var maxValue = pow(10, maxLength) - 1;
    // var clueValuesSet = <int>{};
    // for (var p1 in first14primes) {
    //   for (var p2 in first14primes.where((element) => element > p1)) {
    //     for (var p3 in first14primes.where((element) => element > p2)) {
    //       var value = p1 * p2 * p3;
    //       if (value >= minValue && value <= maxValue) {
    //         clueValuesSet.add(value);
    //       }
    //     }
    //   }
    // }
    // var clueValues = List.from(clueValuesSet)..sort();
    // print('clueValues=$clueValues');
  }
}
