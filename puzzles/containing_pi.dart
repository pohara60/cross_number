/*
# ContainingPi Puzzle Solver

## Puzzle

Containing Pi by MatriX

Each quadrant uses a pandigital set of the digits 1 – 9. In addition, the shaded cells contain π, the first twelve
digits of which are entered clockwise. Entries are distinct and do not start with zero.
The "shaded" digits are a square with corners [1,1] and [4,4].

```+--+--+--+--+--+--+
|1 :  :2 |3 :  :4 |
+::+--+::+::+--+::+
|  |5 :  :  |6 |  |
+::+--+--+::+::+::+
|7 |8 |  |  |9 :  |
+--+::+--+--+::+--+
|10:  |11|12:  :13|
+::+::+::+--+--+::+
|  |  |14:15:  |  |
+::+--+::+::+--+::+
|16:  :  |17:  :  |
+--+--+--+--+--+--+


Across
1 $jumble D8 - D10
3 #square
9 #prime
10  #square - D15
16  #square
Down
1 #square
2 #square -A9
4 $jumble D13
10  #prime
11  $jumble A17
13  #square
15  #prime
```

## Solution

```
+--+--+--+--+--+--+
| 5  8  2| 3  2  4|
+  +--+  +  +--+  +
| 7| 1  4  1| 5| 8|
+  +--+--+  +  +  +
| 6  3  9| 6| 9  7|
+--+  +--+--+  +--+
| 2  8| 4| 1  2  7|
+  +  +  +--+--+  +
| 7| 5| 3  5  6| 8|
+  +--+  +  +--+  +
| 1  6  9| 3  9  4|
+--+--+--+--+--+--+
```

## Lessons Learned

Add ContainingPi puzzle
- Puzzle constraint enforces the pi digits
- Make reverse() function in monadics
- Add Cell row/col for debug print
- Add grid.quadrants to get quadrant regions
- Add Region.propagate to ensure no duplicate digits in region
- Puzzle initialisation enforces min/max digits

 */

// ignore_for_file: unused_import
import 'dart:collection';
import 'dart:math';

import 'package:crossnumber/src/expressions/generators.dart';
import 'package:crossnumber/src/expressions/monadic.dart';
import 'package:crossnumber/src/models/cell.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/digit_range_constraint.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

// ignore: non_constant_identifier_names
PuzzleDefinition containing_pi() {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :  :2 |3 :  :4 |',
    '+::+--+::+::+--+::+',
    '|  |5 :  :  |6 |  |',
    '+::+--+--+::+::+::+',
    '|7 :8 :  |  |9 :  |',
    '+--+::+--+--+::+--+',
    '|10:  |11|12:  :13|',
    '+::+::+::+--+--+::+',
    '|  |  |14:15:  |  |',
    '+::+--+::+::+--+::+',
    '|16:  :  |17:  :  |',
    '+--+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  // monadicFunctionRegistry.registerFunction('firstfactor',
  //     (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));

  final puzzle = PuzzleDefinition.fromString(
    name: 'ContainingPi',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    digitConstraint: '1,9',
    puzzleConstraints: [ContainingPiConstraint()],
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {
      'A1': Entry(
        id: 'A1',
        constraints: [ExpressionConstraint(r'($jumble D8) - D10')],
      ),
      'A3': Entry(id: 'A3', constraints: [ExpressionConstraint(r'#square')]),
      'A9': Entry(id: 'A9', constraints: [ExpressionConstraint(r'#prime')]),
      'A10': Entry(
        id: 'A10',
        constraints: [ExpressionConstraint(r'#square - D15')],
      ),
      'A16': Entry(id: 'A16', constraints: [ExpressionConstraint(r'#square')]),
      'D1': Entry(id: 'D1', constraints: [ExpressionConstraint(r'#square')]),
      'D2': Entry(
        id: 'D2',
        constraints: [ExpressionConstraint(r'#square -A9')],
      ),
      'D4': Entry(
        id: 'D4',
        constraints: [ExpressionConstraint(r'$jumble D13')],
      ),
      'D10': Entry(id: 'D10', constraints: [ExpressionConstraint(r'#prime')]),
      'D11': Entry(
        id: 'D11',
        constraints: [ExpressionConstraint(r'$jumble A17')],
      ),
      'D13': Entry(id: 'D13', constraints: [ExpressionConstraint(r'#square')]),
      'D15': Entry(id: 'D15', constraints: [ExpressionConstraint(r'#prime')]),
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
  puzzle.entries['A1']!.answer = 582;
  puzzle.entries['A3']!.answer = 324;
  puzzle.entries['A5']!.answer = 141;
  puzzle.entries['A7']!.answer = 639;
  puzzle.entries['A9']!.answer = 97;
  puzzle.entries['A10']!.answer = 28;
  puzzle.entries['A12']!.answer = 127;
  puzzle.entries['A14']!.answer = 356;
  puzzle.entries['A16']!.answer = 169;
  puzzle.entries['A17']!.answer = 394;
  puzzle.entries['D1']!.answer = 576;
  puzzle.entries['D2']!.answer = 24;
  puzzle.entries['D3']!.answer = 316;
  puzzle.entries['D4']!.answer = 487;
  puzzle.entries['D6']!.answer = 592;
  puzzle.entries['D8']!.answer = 385;
  puzzle.entries['D10']!.answer = 271;
  puzzle.entries['D11']!.answer = 439;
  puzzle.entries['D13']!.answer = 784;
  puzzle.entries['D15']!.answer = 53;
}

class ContainingPiConstraint extends PuzzleConstraint {
  static const pi = '314159265358';
  static final piDigits = <int>[];
  static final piNextTriple = <int, int>{};
  static final Region piRegion = Region('pi', []);
  static initPi(puzzle) {
    for (var ch in pi.split("")) {
      piDigits.add(int.parse(ch));
    }
    if (piNextTriple.isEmpty) {
      int? value;
      int? first;
      int count = 0;
      for (var triple in piTriples()) {
        if (value == null) {
          first = triple;
        } else {
          piNextTriple[value] = triple;
        }
        value = triple;
        count = count + 1;
        if (count == 4) {
          piNextTriple[value] = first!;
          value = null;
          count = 0;
        }
      }
    }
    if (piRegion.cells.isEmpty) {
      // Add "square"
      var cells = puzzle.grid.cells;
      for (var c in [1, 2, 3, 4]) {
        piRegion.cells.add(cells[1][c]);
      }
      piRegion.cells.add(cells[2][4]);
      piRegion.cells.add(cells[3][4]);
      for (var c in [4, 3, 2, 1]) {
        piRegion.cells.add(cells[4][c]);
      }
      piRegion.cells.add(cells[3][1]);
      piRegion.cells.add(cells[2][1]);
    }
  }

  static Iterable<Iterable<Cell>> piSequences() sync* {
    for (var offset = 0; offset < 12; offset++) {
      yield piSequence(offset);
    }
  }

  static Iterable<Cell> piSequence(int offset) sync* {
    var index = offset;
    for (var seq = 0; seq < 12; seq++) {
      yield piRegion.cells[index];
      index += 1;
      if (index >= 12) index = 0;
    }
  }

  static List<int> piTriples() => [
        for (var offset = 0; offset < 3; offset++) ...piTriple(offset),
      ];

  static Iterable<int> piTriple(int offset) sync* {
    for (var i = 0; i < 12; i += 3) {
      yield piDigits[(offset + i) % 12] * 100 + piDigits[(offset + i + 1) % 12] * 10 + piDigits[(offset + i + 2) % 12];
    }
  }

  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {
    initPi(puzzle);
    // The "square" with pi comprises 4 3-digit clues:
    // A5, D6, A14 backwards, D8 backwards
    var triples = piTriples();
    triples.sort();
    puzzle.entries['A5']!.possibleValues = triples.toSet();
    puzzle.entries['D6']!.possibleValues = triples.toSet();
    var reverseTriples = triples.map((v) => int.parse(v.toString().split("").reversed.join())).toList();
    reverseTriples.sort();
    puzzle.entries['A14']!.possibleValues = reverseTriples.toSet();
    puzzle.entries['D8']!.possibleValues = reverseTriples.toSet();
    // for (var seq in piSequences()) {
    //   print('seq=${[for (var cell in seq) cell].join(",")}');
    // }
    return;
  }

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) {
    var changed = false;
    // Enforce region constraints
    for (var grid in puzzle.grids.values) {
      var localChanged = true;
      while (localChanged) {
        localChanged = false;
        for (var region in grid.quadrants) {
          final (consistent, updated) = region.propagate(trace: trace);
          if (updated) localChanged = true;
          if (!consistent) {
            if (trace) {
              print('    Inconsistency: Grid constraint for region ${region.id} leads to empty possible values.');
            }
            return (false, localChanged);
          }
        }
        changed = changed || localChanged;
      }
    }
    return (true, changed);
  }

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) {
    var anyUpdate = false;
    // Examine 4 entries in turn
    var (consistent, updated) = checkEntries(puzzle, ['A5', 'D6', 'A14', 'D8']);
    anyUpdate = anyUpdate || updated;
    if (!consistent) return (false, anyUpdate);
    // Examine 12 possible sequences until find a consistent one
    for (var seq in piSequences()) {
      var index = 0;
      for (var cell in seq) {
        if (!cell.possibleDigits.contains(piDigits[index])) break;
        index++;
      }
      if (index == 12) {
        return (true, anyUpdate);
      }
    }
    return (false, anyUpdate);
  }

  (bool, bool) checkEntries(PuzzleDefinition puzzle, List<String> clues) {
    var anyUpdate = false;
    int? previousValue;
    for (var clue in [...clues, ...clues]) {
      // Examine 4 entries in turn, then first again
      var (consistent, updated, value) = checkEntry(puzzle, clue, previousValue);
      anyUpdate = anyUpdate || updated;
      if (!consistent) return (false, anyUpdate);
      previousValue = value;
    }
    return (true, anyUpdate);
  }

  (bool, bool, int?) checkEntry(PuzzleDefinition puzzle, String clue, int? previousValue) {
    var updated = false;
    var entry = puzzle.entries[clue]!;
    if (entry.isSolved) {
      var nextValue = entry.solution!;
      if (['A14', 'D8'].contains(clue)) nextValue = reverse(nextValue);
      if (previousValue != null) {
        if (piNextTriple[previousValue]! != nextValue) return (false, updated, previousValue);
      }
      previousValue = nextValue;
    } else {
      if (previousValue != null) {
        var nextValue = piNextTriple[previousValue]!;
        previousValue = nextValue;
        if (['A14', 'D8'].contains(clue)) nextValue = reverse(nextValue);
        if (!entry.possibleValues!.contains(nextValue)) return (false, updated, previousValue);
      }
    }
    return (true, updated, previousValue);
  }

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) => true;

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}
