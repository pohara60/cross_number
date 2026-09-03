/*
# Yet Another Sudoku Puzzle Solver

## Puzzle

The Listener Crossword No 4934 Yet Another Sudoku by IOA                      

The grid must be completed as a sudoku puzzle (ie where every row, column and barred-off 3×3 box contains all of the
digits 1 to 9), using the clued entries to get started. The clue answers are all different three-digit numbers.                     

+--+--+--+--+--+--+--+--+--+
|  :  :  |1 :  :2 |  :3 :4 |
+::+::+::+::+::+::+::+::+::+
|5 :  :  |  :  :  |  :  :  |
+::+::+::+::+::+::+::+::+::+
|  :  :  |  :  :  |  :  :  |
+--+--+--+--+--+--+--+--+--+
|6 :  :7 |  :  :8 |  :  :  |
+::+::+::+::+::+::+::+::+::+
|  :  :  |  :  :  |  :  :  |
+::+::+::+::+::+::+::+::+::+
|  :  :  |9 :  :  |  :  :  |
+--+--+--+--+--+--+--+--+--+
|10:11:  |  :12:  |  :  :13|
+::+::+::+::+::+::+::+::+::+
|14:  :  |  :  :  |15:  :  |
+::+::+::+::+::+::+::+::+::+
|16:  :  |  :  :  |  :  :  |
+--+--+--+--+--+--+--+--+--+

Across											          Down
1 2dn minus 15ac						          2 lac plus 15ac
5 A prime										          3 A square
9 A number raised to a power of       4 A prime
  more than two											  6 Double 8dn
14 A multiple of the sum of the nine  7 A square
   digits in the SW-NE diagonal	      8 A prime										
15 80 per cent more than lac				  10 A square
16 A square											      11 Double 5ac
                											12 A prime
								                			13 A multiple of the sum of the nine digits 
                                         in the NW-SE diagonal


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
import 'package:crossnumber/src/expressions/polyadic.dart';
import 'package:crossnumber/src/models/cell.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/constraint.dart';
import 'package:crossnumber/src/models/distinct_constraint.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition yet_another_sudoku() {
  var gridString = [
    '+--+--+--+--+--+--+--+--+--+',
    '|  :  :  |1 :  :2 |  :3 :4 |',
    '+::+::+::+::+::+::+::+::+::+',
    '|5 :  :  |  :  :  |  :  :  |',
    '+::+::+::+::+::+::+::+::+::+',
    '|  :  :  |  :  :  |  :  :  |',
    '+--+--+--+--+--+--+--+--+--+',
    '|6 :  :7 |  :  :8 |  :  :  |',
    '+::+::+::+::+::+::+::+::+::+',
    '|  :  :  |  :  :  |  :  :  |',
    '+::+::+::+::+::+::+::+::+::+',
    '|  :  :  |9 :  :  |  :  :  |',
    '+--+--+--+--+--+--+--+--+--+',
    '|10:11:  |  :12:  |  :  :13|',
    '+::+::+::+::+::+::+::+::+::+',
    '|14:  :  |  :  :  |15:  :  |',
    '+::+::+::+::+::+::+::+::+::+',
    '|16:  :  |  :  :  |  :  :  |',
    '+--+--+--+--+--+--+--+--+--+',
  ];

  final puzzle = PuzzleDefinition.fromString(
    name: 'Yet Another Sudoku',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    puzzleConstraints: [SudokuConstraint()],
    digitConstraint: "1,9",
    distinctConstraint: DistinctConstraint(allClues: false),
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {
      'A1': Entry(id: 'A1', constraints: [ExpressionConstraint(r'D2-A15')]),
      'A5': Entry(id: 'A5', constraints: [ExpressionConstraint(r'#prime')]),
      'A9': Entry(id: 'A9', constraints: [ExpressionConstraint(r'#powers3')]),
      'A14': Entry(id: 'A14', constraints: [ExpressionConstraint(r'$multiple #sumSWNEdiagonal')]),
      'A15': Entry(id: 'A15', constraints: [ExpressionConstraint(r'A1*9/5')]),
      'A16': Entry(id: 'A16', constraints: [ExpressionConstraint(r'#square')]),
      'D2': Entry(id: 'D2', constraints: [ExpressionConstraint(r'A1*14/5')]),
      'D3': Entry(id: 'D3', constraints: [ExpressionConstraint(r'#square')]),
      'D4': Entry(id: 'D4', constraints: [ExpressionConstraint(r'#prime')]),
      'D6': Entry(id: 'D6', constraints: [ExpressionConstraint(r'D8*2')]),
      'D7': Entry(id: 'D7', constraints: [ExpressionConstraint(r'#square')]),
      'D8': Entry(id: 'D8', constraints: [ExpressionConstraint(r'#prime')]),
      'D10': Entry(id: 'D10', constraints: [ExpressionConstraint(r'#square')]),
      'D11': Entry(id: 'D11', constraints: [ExpressionConstraint(r'A5*2')]),
      'D12': Entry(id: 'D12', constraints: [ExpressionConstraint(r'#prime')]),
      'D13': Entry(id: 'D13', constraints: [ExpressionConstraint(r'$multiple #sumNWSEdiagonal')]),
    },
    clues: {},
    variables: {},
  );

  // Register puzzle specific functions
  final GeneratorRegistry generatorRegistry = GeneratorRegistry();
  generatorRegistry.register('sumNWSEdiagonal', SumDiagonalGenerator(puzzle, isSWNE: false));
  generatorRegistry.register('sumSWNEdiagonal', SumDiagonalGenerator(puzzle, isSWNE: true));
  // ignore: unused_local_variable
  final PolyadicFunctionRegistry polyadicFunctionRegistry = PolyadicFunctionRegistry();
  // polyadicFunctionRegistry.registerFunction('aspCheck', aspCheck);
  // ignore: unused_local_variable
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  // monadicFunctionRegistry.registerFunction('digitSumEqualProduct', digitSumEqualProduct);

  setAnswers(puzzle);
  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  // puzzle.entries['A1']!.answer = 21;
}

class SumDiagonalGenerator extends Generator {
  final PuzzleDefinition puzzle;
  final bool isSWNE;
  SumDiagonalGenerator(this.puzzle, {this.isSWNE = true});
  @override
  List<int> getValues(int min, int max) {
    assert(!puzzle.isMultiGrid);
    var (minSum, maxSum) = puzzle.grid.getDiagonalDigitSumRange(isSWNE);
    if (minSum < min) minSum = min;
    if (maxSum > max) maxSum = max;
    return List.generate(maxSum - minSum + 1, (index) => minSum + index).toList();
  }
}

/// A constraint that enforces the Sudoku rules on the puzzle.
/// Rows, Columns and Boxes must contain distinct digits from 1 to 9.

class SudokuConstraint extends PuzzleConstraint {
  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {
    // Create entries for empty cells in the grid that are not already part of an entry
    for (var r = 0; r < puzzle.grid.rows; r++) {
      for (var c = 0; c < puzzle.grid.cols; c++) {
        var cell = puzzle.grid.cells[r][c];
        if (cell.acrossEntry == null && cell.downEntry == null && cell.upEntry == null) {
          var entryId = 'R${r}C${c}';
          // Compute longest possible length for across and down entries
          // For clarity, entries should not span boxes
          var acrossLength = 0;
          for (var endCol = c;
              endCol < puzzle.grid.cols && puzzle.grid.cells[r][endCol].acrossEntry == null;
              endCol++) {
            if (puzzle.grid.cells[r][endCol].downEntry != null) break;
            if ((endCol ~/ 3) != (c ~/ 3)) break; // Stop if we cross a box boundary
            acrossLength++;
          }
          var downLength = 0;
          for (var endRow = r; endRow < puzzle.grid.rows && puzzle.grid.cells[endRow][c].downEntry == null; endRow++) {
            if (puzzle.grid.cells[endRow][c].acrossEntry != null) break;
            if ((endRow ~/ 3) != (r ~/ 3)) break; // Stop if we cross a box boundary
            downLength++;
          }
          // Make entry of longest length
          if (acrossLength >= downLength) {
            var entry = Entry(
                id: entryId,
                row: r,
                col: c,
                length: acrossLength,
                orientation: EntryOrientation.across,
                constraints: []);

            puzzle.entries[entryId] = entry;
            for (var i = 0; i < acrossLength; i++) {
              cell = puzzle.grid.cells[r][c + i];
              cell.acrossEntry = entry;
              cell.acrossIndex = i;
            }
          } else {
            var entry = Entry(
                id: entryId, row: r, col: c, length: downLength, orientation: EntryOrientation.down, constraints: []);

            puzzle.entries[entryId] = entry;
            for (var i = 0; i < downLength; i++) {
              cell = puzzle.grid.cells[r][c + i];
              cell.downEntry = entry;
              cell.downIndex = i;
            }
          }
        }
      }
    }
  }

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) {
    var changed = false;
    // Enforce grid constraints
    for (var grid in puzzle.grids.values) {
      var localChanged = false;
      while (true) {
        for (var region in grid.regions) {
          final (consistent, updated) = propagateRegion(region, trace: trace);
          if (updated) localChanged = true;
          if (!consistent) {
            if (trace) print('    Inconsistency: Grid constraint for row ${region.id} leads to empty possible values.');
            return (false, localChanged);
          }
        }
        if (!localChanged) break;
        changed = true;
      }
    }
    return (true, changed);
  }

  (bool, bool) propagateRegion(Region region, {bool trace = false}) {
    var updated = false;
    // Get known and unknown cells in the region
    var knownValues = <int>{};
    var knownCells = <Cell>[];
    var unknownCells = <Cell>[];
    for (var cell in region.cells) {
      if (cell.value != null) {
        knownValues.add(cell.value!);
        knownCells.add(cell);
      } else {
        unknownCells.add(cell);
      }
    }
    if (knownValues.isEmpty) return (true, false); // No known values to propagate

    // Remove known value from possible values of unknown cells in the region
    for (var cell in unknownCells) {
      if (cell.removeDigits(knownValues)) updated = true;
    }

    return (true, updated);
  }

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) {
    // Ensure that entry values do not have repeated digits
    var updated = false;
    for (var entry in puzzle.entries.values) {
      if (entry.possibleValues != null) {
        var valuesToRemove = <int>{};
        for (var value in entry.possibleValues!) {
          var digits = value.toString().split('').toSet();
          if (digits.length != entry.length) {
            valuesToRemove.add(value);
          }
        }
        if (valuesToRemove.isNotEmpty) {
          for (var value in valuesToRemove) {
            if (entry.possibleValues!.remove(value)) {
              // if (trace) print('    Removed $value from ${entry.id} due to repeated digits.');
              updated = true;
            }
          }
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
