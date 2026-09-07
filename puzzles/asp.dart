/*
# ASP Puzzle Solver

## Puzzle

ASP by Oyler

Symmetrically opposite pairs have the same answer which must be modified to form the grid entries. One entry has the
digit product of its partner entry  added to the answer whilst the other entry has the digit sum of its partner entry
added to the answer. Answers (not symmetrically opposite) and entries are distinct and of the same length. There are
no zeros entered in the grid. 7ac is considered symmetrically opposite to itself.

```+--+--+--+--+--+
|1 :  |2 :  |3 |
+::+--+::+--+::+
|4 :5 :  |6 :  |
+::+::+--+::+--+
|  |7 :  :  |8 |
+--+::+--+::+::+
|9 :  |10:  :  |
+::+--+::+--+::+
|  |11:  |12:  |
+--+--+--+--+--+


Across
1 Catalan number
2 power of
4 palindrome
6 triangular
7 square
9 triangular
10  palindrome
11  power of
12  Catalan number
Down
1 prime
2 square
3 cube
5 palindrome
6 palindrome
8 prime
9 cube
10  square
```

## Solution

```
+--+--+--+--+--+
| 2  1| 4  4| 4|
+  +--+  +--+  +
| 3  2  9| 2  5|
+  +  +--+  +--+
| 9| 2  3  1| 2|
+--+  +--+  +  +
| 3  1| 3  6  7|
+  +--+  +--+  +
| 6| 4  8| 1  7|
+--+--+--+--+--+
```

## Lessons Learned

Support expressable groups, not just clue groups. 
Support Catalan number generator.
On successful solution, print the puzzle to the console even if no trace.
Cope with expressions that include the variable being solved for.
Puzzle specific Polyadic functions are the key to solving the puzzle.

 */

// ignore_for_file: unused_import
import 'dart:collection';
import 'dart:math';
import 'package:crossnumber/src/expressions/generators.dart';
import 'package:crossnumber/src/expressions/monadic.dart';
import 'package:crossnumber/src/expressions/polyadic.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/distinct_constraint.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition asp() {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :  |2 :  |3 |',
    '+::+--+::+--+::+',
    '|4 :5 :  |6 :  |',
    '+::+::+--+::+--+',
    '|  |7 :  :  |8 |',
    '+--+::+--+::+::+',
    '|9 :  |10:  :  |',
    '+::+--+::+--+::+',
    '|  |11:  |12:  |',
    '+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final PolyadicFunctionRegistry polyadicFunctionRegistry = PolyadicFunctionRegistry();
  polyadicFunctionRegistry.registerFunction('aspCheck', aspCheck, PolyadicMaxOp.limit);
  polyadicFunctionRegistry.registerFunction('aspCheck2', aspCheck2, PolyadicMaxOp.limit);
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  monadicFunctionRegistry.registerFunction('digitSumEqualProduct', digitSumEqualProduct);

  final puzzle = PuzzleDefinition.fromString(
    name: 'ASP',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    puzzleConstraints: [ASPConstraint()],
    digitConstraint: "1,9",
    distinctConstraint: DistinctConstraint(allClues: false),
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {
      'A1': Entry(id: 'A1', constraints: [ExpressionConstraint(r'£aspCheck(A12,1A)')]),
      'A2': Entry(id: 'A2', constraints: [ExpressionConstraint(r'£aspCheck(A11,2A)')]),
      'A4': Entry(id: 'A4', constraints: [ExpressionConstraint(r'£aspCheck(A10,4A)')]),
      'A6': Entry(id: 'A6', constraints: [ExpressionConstraint(r'£aspCheck(A9,6A)')]),
      'A7': Entry(id: 'A7', constraints: [ExpressionConstraint(r'£aspCheck2(A7,7A)')]),
      'A9': Entry(id: 'A9', constraints: [ExpressionConstraint(r'£aspCheck(A6,6A)')]),
      'A10': Entry(id: 'A10', constraints: [ExpressionConstraint(r'£aspCheck(A4,4A)')]),
      'A11': Entry(id: 'A11', constraints: [ExpressionConstraint(r'£aspCheck(A2,2A)')]),
      'A12': Entry(id: 'A12', constraints: [ExpressionConstraint(r'£aspCheck(A1,1A)')]),
      'D1': Entry(id: 'D1', constraints: [ExpressionConstraint(r'£aspCheck(D8,1D)')]),
      'D2': Entry(id: 'D2', constraints: [ExpressionConstraint(r'£aspCheck(D10,2D)')]),
      'D3': Entry(id: 'D3', constraints: [ExpressionConstraint(r'£aspCheck(D9,3D)')]),
      'D5': Entry(id: 'D5', constraints: [ExpressionConstraint(r'£aspCheck(D6,5D)')]),
      'D6': Entry(id: 'D6', constraints: [ExpressionConstraint(r'£aspCheck(D5,5D)')]),
      'D8': Entry(id: 'D8', constraints: [ExpressionConstraint(r'£aspCheck(D1,1D)')]),
      'D9': Entry(id: 'D9', constraints: [ExpressionConstraint(r'£aspCheck(D3,3D)')]),
      'D10': Entry(id: 'D10', constraints: [ExpressionConstraint(r'£aspCheck(D2,2D)')]),
    },
    clues: {
      '1A': Clue('1A', [ExpressionConstraint(r'#catalan')], length: 2),
      '2A': Clue('2A', [ExpressionConstraint(r'$power 2')], length: 2),
      '4A': Clue('4A', [ExpressionConstraint(r'#palindrome')], length: 3),
      '6A': Clue('6A', [ExpressionConstraint(r'#triangular')], length: 2),
      '7A': Clue('7A', [ExpressionConstraint(r'#square')], length: 3),
      '1D': Clue('1D', [ExpressionConstraint(r'#prime')], length: 3),
      '2D': Clue('2D', [ExpressionConstraint(r'#square')], length: 2),
      '3D': Clue('3D', [ExpressionConstraint(r'#cube')], length: 2),
      '5D': Clue('5D', [ExpressionConstraint(r'#palindrome')], length: 3),
    },
    variables: {
      // 'A': Variable('A', getVariableValues(2)),
    },
  );
  setAnswers(puzzle);
  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  // puzzle.clues['1A']!.answer =21;
  // puzzle.clues['2A']!.answer =;
  // puzzle.clues['4A']!.answer =;
  // puzzle.clues['6A']!.answer =;
  // puzzle.clues['7A']!.answer =225;
  // puzzle.clues['9A']!.answer =;
  // puzzle.clues['10A']!.answer =;
  // puzzle.clues['11A']!.answer =;
  // puzzle.clues['12A']!.answer =21;
  // puzzle.clues['1D']!.answer =225;
  // puzzle.clues['2D']!.answer =;
  // puzzle.clues['3D']!.answer =;
  // puzzle.clues['5D']!.answer =;
  // puzzle.clues['6D']!.answer =;
  // puzzle.clues['8D']!.answer =;
  // puzzle.clues['9D']!.answer =;
  // puzzle.clues['10D']!.answer =;

  puzzle.entries['A1']!.answer = 21;
  puzzle.entries['A2']!.answer = 44;
  puzzle.entries['A4']!.answer = 329;
  puzzle.entries['A6']!.answer = 25;
  puzzle.entries['A7']!.answer = 231;
  puzzle.entries['A9']!.answer = 31;
  puzzle.entries['A10']!.answer = 367;
  puzzle.entries['A11']!.answer = 48;
  puzzle.entries['A12']!.answer = 17;
  puzzle.entries['D1']!.answer = 239;
  puzzle.entries['D2']!.answer = 49;
  puzzle.entries['D3']!.answer = 45;
  puzzle.entries['D5']!.answer = 221;
  puzzle.entries['D6']!.answer = 216;
  puzzle.entries['D8']!.answer = 277;
  puzzle.entries['D9']!.answer = 36;
  puzzle.entries['D10']!.answer = 38;
}

class ASPConstraint extends PuzzleConstraint {
  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {}

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) => (true, false);

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) => (true, false);

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) => true;

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}

int digitSum(int value) => value.toString().split('').map(int.parse).reduce((a, b) => a + b);
int digitProduct(int value) => value.toString().split('').map(int.parse).reduce((a, b) => a * b);

// One entry has the digit product of its partner entry added to the answer whilst the other entry has the digit sum of
// its partner entry added to the answer.
List<int> aspCheck(List<dynamic> args, {int? max, int? min}) {
  assert(args.length == 2);
  var otherEntryValue = args[0] as int;
  var clueValue = args[1] as int;
  var clueValuePlusDigitSum = clueValue + digitSum(otherEntryValue);
  var clueValuePlusDigitProduct = clueValue + digitProduct(otherEntryValue);
  var results = <int>[];
  if (otherEntryValue == clueValue + digitProduct(clueValuePlusDigitSum)) {
    results.add(clueValuePlusDigitSum);
  }
  if (otherEntryValue == clueValue + digitSum(clueValuePlusDigitProduct)) {
    results.add(clueValuePlusDigitProduct);
  }
  return results;
}

// One entry has the digit product of its partner entry added to the answer whilst the other entry has the digit sum of
// its partner entry added to the answer.
// 7ac is considered symmetrically opposite to itself, so the digit sum and digit product of the entry must be equal.
List<int> aspCheck2(List<dynamic> args, {int? max, int? min}) {
  assert(args.length == 2);
  var otherEntryValue = args[0] as int;
  var clueValue = args[1] as int;
  var clueValuePlusDigitSum = clueValue + digitSum(otherEntryValue);
  var clueValuePlusDigitProduct = clueValue + digitProduct(otherEntryValue);
  if (clueValuePlusDigitSum != clueValuePlusDigitProduct) return [];
  return [clueValuePlusDigitProduct];
}

List<int> digitSumEqualProduct(List<int> values, {int? max, int? min}) {
  return values
      .where((value) => digitSum(value) == digitProduct(value))
      .map((value) => value + digitSum(value))
      .toList();
}
