/*
# BorderSeries Puzzle Solver

## Puzzle

Border Series by Zag

1ac, 6dn, 11ac and 3dn in that order form an increasing arithmetic sequence. No entry starts with zero and all entries are distinct.

```+--+--+--+--+--+
|  |1 :  :2 |  |
+--+::+--+::+--+
|3 :  :4 |5 :6 |
+::+--+::+::+::+
|  |7 :  :  |  |
+::+::+::+--+::+
|8 :  |9 :10:  |
+--+::+--+::+--+
|  |11:  :  |  |
+--+--+--+--+--+


Across
1	
3	#square - d4
5	$factor d2
7	A1 + a11 + d3 + d6
8	
9	$multiple d10
11	
Down
1	D7 % a8
2	$multiple a5
3	
4	#square - a3
6	
7	
10	$sqrt a7
```

## Solution

```
```

## Lessons Learned


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

// ignore: non_constant_identifier_names
PuzzleDefinition borderseries() {
  var gridString = [
    '+--+--+--+--+--+',
    '|  |1 :  :2 |  |',
    '+--+::+--+::+--+',
    '|3 :  :4 |5 :6 |',
    '+::+--+::+::+::+',
    '|  |7 :  :  |  |',
    '+::+::+::+--+::+',
    '|8 :  |9 :10:  |',
    '+--+::+--+::+--+',
    '|  |11:  :  |  |',
    '+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  // monadicFunctionRegistry.registerFunction('firstfactor',
  //     (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));

  final puzzle = PuzzleDefinition.fromString(
    name: 'BorderSeries',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    puzzleConstraints: [BorderSeriesConstraint()],
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {
      'A1': Entry(id: 'A1', constraints: [ExpressionConstraint(r'A1 < D6')]),
      'A3': Entry(
        id: 'A3',
        constraints: [ExpressionConstraint(r'#square - D4')],
      ),
      'A5': Entry(id: 'A5', constraints: [ExpressionConstraint(r'$factor D2')]),
      'A7': Entry(
        id: 'A7',
        constraints: [ExpressionConstraint(r'$isSquare (A1 + A11 + D3 + D6)')],
      ),
      'A8': Entry(id: 'A8', constraints: []),
      'A9': Entry(
        id: 'A9',
        constraints: [ExpressionConstraint(r'$multiple D10')],
      ),
      'A11': Entry(id: 'A11', constraints: [ExpressionConstraint(r'A11 < D3')]),
      'D1': Entry(id: 'D1', constraints: [ExpressionConstraint(r'D7 % A8')]),
      'D2': Entry(
        id: 'D2',
        constraints: [ExpressionConstraint(r'$multiple A5')],
      ),
      'D3': Entry(id: 'D3', constraints: [ExpressionConstraint(r'D3 > A11')]),
      'D4': Entry(
        id: 'D4',
        constraints: [ExpressionConstraint(r'#square - A3')],
      ),
      'D6': Entry(id: 'D6', constraints: [ExpressionConstraint(r'D6 < A11')]),
      'D7': Entry(id: 'D7', constraints: []),
      'D10': Entry(id: 'D10', constraints: [ExpressionConstraint(r'$squareroot A7')]),
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

class BorderSeriesConstraint extends PuzzleConstraint {
  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {}

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) {
    // 1ac, 6dn, 11ac and 3dn in that order form an increasing arithmetic sequence.
    var updated = false;
    const arithmeticSequence = ['A1', 'D6', 'A11', 'D3'];
    for (var i = 0; i < arithmeticSequence.length - 2; i++) {
      final currentEntry = puzzle.entries[arithmeticSequence[i]];
      final nextEntry = puzzle.entries[arithmeticSequence[i + 1]];
      if (currentEntry != null &&
          nextEntry != null &&
          currentEntry.possibleValues != null &&
          nextEntry.possibleValues != null) {
        var minCurrent = currentEntry.possibleValues!.reduce(min);
        var minNext = nextEntry.possibleValues!.reduce(min);
        if (minNext <= minCurrent) {
          nextEntry.possibleValues = nextEntry.possibleValues!.where((v) => v > minCurrent).toSet();
          updated = true;
          if (nextEntry.possibleValues!.isEmpty) {
            return (false, updated);
          }
        }
      }
    }
    return (true, updated);
  }

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) => (true, false);

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) => true;

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}
