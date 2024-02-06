library twentyfive;

import '../cartesian.dart';
import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the TwentyFive API.
class TwentyFive extends Crossnumber<TwentyFivePuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :  :3 :4 |',
    '+::+::+--+::+::+',
    '|5 :  :6 :  :  |',
    '+::+--+::+::+--+',
    '|7 :8 :  |9 :10|',
    '+::+::+::+::+::+',
    '|  |11:  :  |  |',
    '+::+::+::+::+::+',
    '|12:  |13:  :  |',
    '+--+--+--+--+--+',
  ];

  TwentyFive() {
    initCrossnumber();
  }

  void initCrossnumber() {
    for (var i = 0; i < 2; i++) {
      var puzzle =
          TwentyFivePuzzle.grid(gridString, name: i == 0 ? 'Left' : 'Right');
      this.puzzles.add(puzzle);

      // Clue definitions define the Entries
      var clueErrors = '';
      void clueWrapper({String? name, int? length, String? valueDesc}) {
        try {
          var clue = TwentyFiveEntry(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            solve: solveTwentyFiveClue,
          );
          puzzle.addEntry(clue);
          return;
        } on ExpressionError catch (e) {
          clueErrors += e.msg + '\n';
          return;
        }
      }

      clueWrapper(name: 'A1', length: 5, valueDesc: r'$Multiple A12');
      clueWrapper(name: 'A5', length: 5, valueDesc: r'$Jumble #palindrome');
      clueWrapper(name: 'A7', length: 3, valueDesc: r'#Triangular');
      clueWrapper(name: 'A9', length: 2, valueDesc: r'$Power #prime');
      clueWrapper(name: 'A11', length: 3, valueDesc: r'$Multiple A9'); // fix
      clueWrapper(name: 'A12', length: 2, valueDesc: r'#Square');
      clueWrapper(name: 'A13', length: 3, valueDesc: r'#Cube');
      clueWrapper(name: 'D1', length: 5, valueDesc: r'#different');
      clueWrapper(name: 'D2', length: 2, valueDesc: r'#Sum2Fibonacci');
      clueWrapper(name: 'D3', length: 5, valueDesc: r'$Multiple D10'); // fix
      clueWrapper(name: 'D4', length: 2, valueDesc: r'$divisor A5');
      clueWrapper(name: 'D6', length: 4, valueDesc: r'$Multiple 9');
      clueWrapper(name: 'D8', length: 3, valueDesc: r'#Square');
      clueWrapper(name: 'D10', length: 3, valueDesc: r'#Square');

      if (clueErrors != '') {
        throw PuzzleException(clueErrors);
      }

      puzzle.validateEntriesFromGrid();

      puzzle.addDigitIdentityFromGrid();

      var letters = [
        // variables
      ];
      for (var letter in letters) {
        puzzle.letters[letter] = TwentyFiveVariable(letter);
      }

      var clueError = '';
      clueError = puzzle.checkClueEntryReferences();
      clueError = puzzle.checkClueClueReferences();
      clueError += puzzle.checkEntryClueReferences();
      clueError += puzzle.checkEntryEntryReferences();
      // Check variabes last, as preceeding may update them
      clueError += puzzle.checkVariableReferences();
      if (clueError != '') throw PuzzleException(clueError);
    }

    // All clues refer to clue in opposite puzzle
    for (var i = 0; i < 2; i++) {
      var puzzle = puzzles[i];
      var otherPuzzle = puzzles[(i + 1) % 2];
      for (var clue in puzzle.clues.values) {
        clue.addReferrer(otherPuzzle.clues[clue.name]!);
      }
    }

    // Fix references between puzzle clues
    // clueWrapper(name: 'A11', length: 3, valueDesc: r'$Multiple A9'); // fix
    // clueWrapper(name: 'D3', length: 5, valueDesc: r'$Multiple D10'); // fix
    for (var i = 0; i < 2; i++) {
      var puzzle = puzzles[i];
      var otherPuzzle = puzzles[(i + 1) % 2];
      puzzle.updateClueReference('A11', 'A9', otherPuzzle);
      puzzle.updateClueReference('D3', 'D10', otherPuzzle);
    }

    super.initCrossnumber();
  }

  var iterating = false;
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

    initPairs();
    // A13, #Cube, values={216,729}
    puzzles[0].clues['A13']!.value = 216;
    puzzles[1].clues['A13']!.value = 729;
    super.solve(false);
  }

  var pairs = <int, int>{};

  void initPairs() {
    pairs[0] = 0; // Invalid
    for (var i = 0; i < 10; i += 2) {
      for (var j = 1; j < 10; j += 2) {
        var pair = j * 10 + i;
        pairs[pair] = -1;
      }
    }
  }

  int getPairValue(int i, int j) {
    if (i % 2 == 1) {
      if (j % 2 == 1) return 0;
      return i * 10 + j;
    } else {
      if (j % 2 == 0) return 0;
      return j * 10 + i;
    }
  }

  List<int> clueDigits(TwentyFiveClue clue, int d) {
    return iterating ? clue.clueDigits(d) : List.from(clue.digits[d]);
  }

  // Validate possible clue value
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (value < 0) return false;
    if (clue.min != null && value < clue.min!) return false;
    if (clue.max != null && value > clue.max!) return false;
    if (clue.values != null && !clue.values!.contains(value)) return false;
    if (!clue.digitsMatch(value)) return false;

    // Pairs
    var otherPuzzle =
        puzzles[0].clues.containsValue(clue) ? puzzles[1] : puzzles[0];
    var otherClue = otherPuzzle.clues[clue.name]!;
    var v = value;
    var newPairs = <int>[];
    for (var d = clue.length! - 1; d >= 0; d--) {
      var digit = v % 10;
      v = v ~/ 10;
      var otherDigits = clueDigits(otherClue, d);

      // Possible pairs for this digit must intersect with other digits
      // var ok = false;
      // for (var otherDigit in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
      //   var pair = getPairValue(digit, otherDigit);
      //   if (pairs[pair] == -1) {
      //       if (otherDigits.contains(otherDigit)) {
      //       ok = true;
      //       break;
      //     }
      //   }
      // }
      // if (!ok) {
      //   return false;
      // }

      // Possible pair with any other digit means ok
      var ok = false;
      var newPair = -1; // No new pair
      for (var otherDigit in otherDigits) {
        var pair = getPairValue(digit, otherDigit);
        if (newPairs.contains(pair)) {
          continue; // This pair consumed by earlier digit in this value
        }
        if (pairs[pair] == -1) {
          if (newPair == -1)
            newPair = pair; // New pair consumed by this digit
          else
            newPair = 0; // Multiple new pairs for this digit
          ok = true;
        } else if (pairs[pair] == clue.entryMixin!.cellDigitIndex(d)) {
          ok = true;
        }
      }
      if (!ok) {
        return false;
      }
      if (newPair > 0) newPairs.add(newPair);
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveTwentyFiveClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as TwentyFivePuzzle;
    var clue = v as TwentyFiveClue;
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
      TwentyFivePuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry, focusClueName: focusClueName);
    if (!isEntry && updated) {
      // Digits
      var clue = puzzle.clues[clueName]!;
      var otherPuzzle = puzzle == puzzles[0] ? puzzles[1] : puzzles[0];
      var otherClue = otherPuzzle.clues[clueName]!;
      for (var d = 0; d < clue.length!; d++) {
        // Get clue digits from values as may not have finalised digits
        var digits = clue.clueDigits(d);
        if (digits.length == 1) {
          if (otherClue.digits[d].length == 1) {
            var pair = getPairValue(digits.first, otherClue.digits[d].first);
            if (!(pairs[pair] == -1 ||
                pairs[pair] == clue.entryMixin!.cellDigitIndex(d))) {
              throw SolveException('Pair violation');
            }
            // Cannot have side effect if iterating
            if (!iterating && pairs[pair] == -1) {
              pairs[pair] = clue.entryMixin!.cellDigitIndex(d);
            }
          }
        }
        var p1 = digitsParity(digits);
        var p2 = digitsParity(otherClue.digits[d]);
        if (p1 == 1 && p2 == 1 || p1 == 2 && p2 == 2) {
          throw SolveException('Parity violation');
        }
      }
    }
    return updated;
  }

  var unfinishedPuzzles = <TwentyFivePuzzle>[];
  @override
  void endSolve(bool iteration) {
    iterating = true;
    // Unique solution?
    for (var puzzle in puzzles) {
      if (!puzzle.uniqueSolution()) {
        unfinishedPuzzles.add(puzzle);
        if (Crossnumber.traceSolve) {
          print("PARTIAL SOLUTION-----------------------------");
          print(puzzle.toSummary());
          // print(puzzle.toString());
        }
      } else {
        print("SOLUTION-----------------------------");
        print(puzzle.toSummary());
      }
    }
    if (unfinishedPuzzles.isNotEmpty) {
      unfinishedPuzzles = puzzles;
      unfinishedPuzzles.first.postProcessing(iteration);
    }
  }

  int callback(TwentyFivePuzzle puzzle) {
    // Puzzle has found a valid solution, check futher puzzles
    var index = unfinishedPuzzles.indexOf(puzzle);
    if (index + 1 == unfinishedPuzzles.length) {
      // Finished!
      print("SOLUTION-----------------------------");
      for (var puzzle in puzzles) {
        if (puzzle.uniqueSolution()) {
          print(puzzle.toSummary());
        }
      }
      return 1;
    }

    return unfinishedPuzzles[index + 1].iterate(callback);
  }

  Set<int>? getValuesFromDigits(TwentyFiveClue clue) {
    var allDigits =
        List<List<int>>.generate(clue.length!, (d) => clueDigits(clue, d));
    var count = cartesianCount(allDigits);
    if (count > 1000) return null;
    var values = <int>{};
    for (var product in cartesian(allDigits, true)) {
      int value = product.reduce((value, element) => value * 10 + element);
      values.add(value);
    }
    return values;
  }
}

int digitsParity(Iterable<int> digits) {
  var isOdd = false;
  var isEven = false;
  for (var d in digits) {
    if (d % 2 == 0) isEven = true;
    if (d % 2 == 1) isOdd = true;
  }
  return (isOdd ? 1 : 0) + (isEven ? 2 : 0);
}
