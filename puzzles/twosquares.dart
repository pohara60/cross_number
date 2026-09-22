/*
# TwoSquares Puzzle Solver

## Puzzle

Two Squares by Rad

A person whose life has included two years with square numbers may be called a Two-Square Person, or TSP. The across
entries show, in chronological order, twelve years in the second millennium, omitting the initial digit 1, in which a
TSP might have been alive, having had his/her two square years, but not having reached his/her 90th birthday. The pair
of years is different for every across entry. All entries are distinct and none begins with zero.

```+--+--+--+--+--+--+--+
|1 :2 :3 |4 :5 :6 |7 |
+--+::+::+--+::+::+::+
|8 |9 :  :10|11:  :  |
+::+::+--+::+--+::+--+
|12:  :13|14:15:  |16|
+::+--+::+::+::+--+::+
|  |17:  :  |18:19:  |
+--+::+--+--+--+::+::+
|20:  :21|22:23:  |  |
+::+::+::+::+::+::+--+
|  |24:  :  |25:  :  |
+--+--+--+--+--+--+--+


Across
1 7*#square
4 3*D5
9 4*D20
11  #prime
12  $ispalindrome #prime
14  #prime
17  #prime
18  #Fibonacci
20  #prime
22  #prime
24  #prime
25  #prime
Down
2 #prime
3 #factorial
5 #prime
6 #prime
7 $reverse D22
8 6*D22
10  #prime
13  $reverse #prime
15  A1/2
16  3*D21
17  12*#square
19  #prime
20  A18/10
21  $reverse D5
22  #prime
23  3*#prime
```

## Solution

```
+--+--+--+--+--+--+--+
| 1  1  2| 1  5  9| 3|
+--+  +  +--+  +  +  +
| 4| 2  4  4| 3  0  7|
+  +  +--+  +--+  +--+
| 3  7  3| 4  5  7| 1|
+  +--+  +  +  +--+  +
| 8| 5  2  3| 6  1  0|
+--+  +--+--+--+  +  +
| 6  8  3| 7  6  9| 5|
+  +  +  +  +  +  +--+
| 1| 8  5  3| 9  3  7|
+--+--+--+--+--+--+--+
```

## Lessons Learned

Two Square puzzle has unique Entry value checking constraint
Add factorial generator
Add isPalindrome and reverse Monadic functions

 */

// ignore_for_file: unused_import
import 'dart:collection';
import 'dart:math';

import 'package:crossnumber/src/expressions/generators.dart';
import 'package:crossnumber/src/expressions/monadic.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition twosquares() {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :2 :3 |4 :5 :6 |7 |',
    '+--+::+::+--+::+::+::+',
    '|8 |9 :  :10|11:  :  |',
    '+::+::+--+::+--+::+--+',
    '|12:  :13|14:15:  |16|',
    '+::+--+::+::+::+--+::+',
    '|  |17:  :  |18:19:  |',
    '+--+::+--+--+--+::+::+',
    '|20:  :21|22:23:  |  |',
    '+::+::+::+::+::+::+--+',
    '|  |24:  :  |25:  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  // monadicFunctionRegistry.registerFunction('firstfactor',
  //     (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));

  final puzzle = PuzzleDefinition.fromString(
    name: 'TwoSquares',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    puzzleConstraints: [TwoSquaresConstraint()],
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {
      'A1': Entry(id: 'A1', constraints: [ExpressionConstraint(r'7*#square')]),
      'A4': Entry(id: 'A4', constraints: [ExpressionConstraint(r'3*D5')]),
      'A9': Entry(id: 'A9', constraints: [ExpressionConstraint(r'4*D20')]),
      'A11': Entry(id: 'A11', constraints: [ExpressionConstraint(r'#prime')]),
      'A12': Entry(
        id: 'A12',
        constraints: [ExpressionConstraint(r'$isPalindrome #prime')],
      ),
      'A14': Entry(id: 'A14', constraints: [ExpressionConstraint(r'#prime')]),
      'A17': Entry(id: 'A17', constraints: [ExpressionConstraint(r'#prime')]),
      'A18': Entry(
        id: 'A18',
        constraints: [ExpressionConstraint(r'#fibonacci')],
      ),
      'A20': Entry(id: 'A20', constraints: [ExpressionConstraint(r'#prime')]),
      'A22': Entry(id: 'A22', constraints: [ExpressionConstraint(r'#prime')]),
      'A24': Entry(id: 'A24', constraints: [ExpressionConstraint(r'#prime')]),
      'A25': Entry(id: 'A25', constraints: [ExpressionConstraint(r'#prime')]),
      'D2': Entry(id: 'D2', constraints: [ExpressionConstraint(r'#prime')]),
      'D3': Entry(id: 'D3', constraints: [ExpressionConstraint(r'#factorial')]),
      'D5': Entry(id: 'D5', constraints: [ExpressionConstraint(r'#prime')]),
      'D6': Entry(id: 'D6', constraints: [ExpressionConstraint(r'#prime')]),
      'D7': Entry(
        id: 'D7',
        constraints: [ExpressionConstraint(r'$reverse D22')],
      ),
      'D8': Entry(id: 'D8', constraints: [ExpressionConstraint(r'6*D22')]),
      'D10': Entry(id: 'D10', constraints: [ExpressionConstraint(r'#prime')]),
      'D13': Entry(
        id: 'D13',
        constraints: [ExpressionConstraint(r'$reverse #prime')],
      ),
      'D15': Entry(id: 'D15', constraints: [ExpressionConstraint(r'A1/2')]),
      'D16': Entry(id: 'D16', constraints: [ExpressionConstraint(r'3*D21')]),
      'D17': Entry(
        id: 'D17',
        constraints: [ExpressionConstraint(r'12*#square')],
      ),
      'D19': Entry(id: 'D19', constraints: [ExpressionConstraint(r'#prime')]),
      'D20': Entry(id: 'D20', constraints: [ExpressionConstraint(r'A18/10')]),
      'D21': Entry(
        id: 'D21',
        constraints: [ExpressionConstraint(r'$reverse D5')],
      ),
      'D22': Entry(id: 'D22', constraints: [ExpressionConstraint(r'#prime')]),
      'D23': Entry(id: 'D23', constraints: [ExpressionConstraint(r'3*#prime')]),
    },
    clues: {},
    variables: {
      // 'A': Variable('A', getVariableValues(2)),
    },
  );
  setAnswers(puzzle);
  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  // puzzle.clues['1D']!.answer = 11;
  // puzzle.entries['D1']!.answer = 11;
}

class TwoSquaresConstraint extends PuzzleConstraint {
  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {}

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) => (true, false);

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) {
    // Ensure that entry values are three digit two square years and that across entries have different pairs of two square years
    var updated = false;
    var knownValues = <int>{};
    for (var entry in puzzle.entries.values.where((entry) => entry.isAcross)) {
      if (entry.possibleValues != null) {
        if (entry.isSolved) {
          if (!knownValues.add(entry.solution!)) {
            return (false, updated); // Duplicate solution found
          }
          continue;
        }
        var valuesToRemove = <int>{};
        for (var value in entry.possibleValues!) {
          if (!isTwoSquareThreeDigitYear(value)) {
            valuesToRemove.add(value);
          }
        }
        if (valuesToRemove.isNotEmpty) {
          for (var value in valuesToRemove) {
            if (entry.possibleValues!.remove(value)) {
              // if (trace) print('    Removed $value from ${entry.id} as not a two-square three-digit year.');
              updated = true;
            }
          }
        }
      }
    }
    // Ensure that across entries have different pairs of two square years

    for (var entry in puzzle.entries.values.where((entry) => entry.isAcross)) {
      if (entry.possibleValues != null) {
        var valuesToRemove = <int>{};
        for (var value in entry.possibleValues!) {
          for (var knownValue in knownValues) {
            if (entry.isSolved && value == knownValue) {
              continue; // Skip checking against its own solution
            }
            if (isSameTwoSquareYearPair(value, knownValue)) {
              valuesToRemove.add(value);
              break;
            }
          }
        }
        if (valuesToRemove.isNotEmpty) {
          for (var value in valuesToRemove) {
            if (entry.possibleValues!.remove(value)) {
              // if (trace) print('    Removed $value from ${entry.id} as same two-square pair.');
              updated = true;
            }
          }
        }
        if (entry.possibleValues!.isEmpty) {
          return (false, updated); // No possible values left
        }
      }
    }

    return (true, updated);
  }

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) => true;

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}

/*
A person whose life has included two years with square numbers may be called a Two-Square Person, or TSP. The across
entries show, in chronological order, twelve years in the second millennium, omitting the initial digit 1, in which a
TSP might have been alive, having had his/her two square years, but not having reached his/her 90th birthday. The pair
of years is different for every across entry.
*/
var squareYears = <int>[];
List<int> getSquareYears() {
  var squareGenerator = GeneratorRegistry().get('square') as SquareGenerator;
  squareYears = squareGenerator.getValues(1000, 1999).toList();
  return squareYears;
}

var twoSquareYearPairs = <(int, int)>[];
List<(int, int)> getTwoSquareYearPairs() {
  if (twoSquareYearPairs.isNotEmpty) {
    return twoSquareYearPairs;
  }
  var squareYears = getSquareYears();
  for (var i = 0; i < squareYears.length; i++) {
    for (var j = i + 1; j < squareYears.length && (squareYears[j] - squareYears[i]) <= 90; j++) {
      twoSquareYearPairs.add((squareYears[i], squareYears[j]));
    }
  }
  return twoSquareYearPairs;
}

var twoSquareYearPairsMap = <int, List<(int, int)>>{};
Map<int, List<(int, int)>> getTwoSquareYearPairsMap() {
  if (twoSquareYearPairsMap.isNotEmpty) {
    return twoSquareYearPairsMap;
  }
  for (var year = 1000; year <= 1999; year++) {
    var twoSquareYearPairs = getTwoSquareYearPairs();
    for (var (y1, y2) in twoSquareYearPairs) {
      if (year >= y1 && year >= y2 && (year - y1) <= 90) {
        twoSquareYearPairsMap.putIfAbsent(year, () => []).add((y1, y2));
      }
    }
  }
  return twoSquareYearPairsMap;
}

var twoSquareThreeDigitYears = <int>[];
List<int> getTwoSquareThreeDigitYears() {
  if (twoSquareThreeDigitYears.isNotEmpty) {
    return twoSquareThreeDigitYears;
  }
  var twoSquareYearPairsMap = getTwoSquareYearPairsMap();
  twoSquareThreeDigitYears =
      twoSquareYearPairsMap.keys.where((year) => year >= 1000 && year <= 1999).map((year) => year - 1000).toList();
  return twoSquareThreeDigitYears;
}

bool isTwoSquareThreeDigitYear(int threeDigitYear) {
  return getTwoSquareThreeDigitYears().contains(threeDigitYear);
}

bool isSameTwoSquareYearPair(int threeDigitYear1, int threeDigitYear2) {
  var twoSquareYearPairsMap = getTwoSquareYearPairsMap();
  var year1 = threeDigitYear1 + 1000;
  var year2 = threeDigitYear2 + 1000;
  if (!twoSquareYearPairsMap.containsKey(year1) || !twoSquareYearPairsMap.containsKey(year2)) {
    return false;
  }
  var pairs1 = twoSquareYearPairsMap[year1]!;
  var pairs2 = twoSquareYearPairsMap[year2]!;
  for (var pair1 in pairs1) {
    for (var pair2 in pairs2) {
      if (pair1 != pair2) {
        return false;
      }
    }
  }
  return true;
}

main() {
  print(isTwoSquareThreeDigitYear(89));
  print(isSameTwoSquareYearPair(89, 90));
  print(isTwoSquareThreeDigitYear(225));
  print(isSameTwoSquareYearPair(89, 225));
}
