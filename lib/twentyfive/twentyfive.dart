library twentyfive;

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
      var puzzle = TwentyFivePuzzle.fromGridString(gridString,
          name: i == 0 ? 'Left' : 'Right');
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

      puzzle.linkEntriesToGrid();

      var letters = [
        // variables
      ];
      for (var letter in letters) {
        puzzle.addAnyVariable(TwentyFiveVariable(letter));
      }

      puzzle.finalize();
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

    addPairConstraint();
    // A13, #Cube, values={216,729}
    puzzles[0].clues['A13']!.value = 216;
    puzzles[1].clues['A13']!.value = 729;
    super.solve(false);
  }

  @override
  void initPairs() {
    pairs[0] = 0; // Invalid
    for (var i = 0; i < 10; i += 2) {
      for (var j = 1; j < 10; j += 2) {
        var pair = j * 10 + i;
        pairs[pair] = -1;
      }
    }
  }

  @override
  int getPairValue(int i, int j) {
    if (i % 2 == 1) {
      if (j % 2 == 1) return 0;
      return i * 10 + j;
    } else {
      if (j % 2 == 0) return 0;
      return j * 10 + i;
    }
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
      updatePairs(puzzle, clue);
    }
    return updated;
  }
}
