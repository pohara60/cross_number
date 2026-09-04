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

```+--+--+--+--+--+--+--+--+--+
| 7  2  6| 1  9  5| 8| 3| 4|
+--+--+--+--+--+  +  +  +  +
| 1  9  3| 8  2| 4| 5| 6| 7|
+--+--+--+--+--+  +  +  +  +
| 8  4  5| 3  7| 6| 2| 1| 9|
+--+--+--+--+--+--+--+--+--+
| 3| 7| 2| 6  8| 1| 4  9  5|
+  +  +  +--+--+  +--+--+--+
| 4| 1| 8| 9  5| 7| 6  2  3|
+  +  +  +--+--+  +--+--+--+
| 6| 5| 9| 2  4  3| 1  7  8|
+--+--+--+--+--+--+--+--+--+
| 5| 3| 4| 7| 1| 2| 9  8| 6|
+  +  +--+  +  +  +--+--+  +
| 2  8  7| 4| 6| 9| 3  5  1|
+  +  +--+  +  +  +--+--+  +
| 9  6  1| 5| 3| 8| 7  4| 2|
+--+--+--+--+--+--+--+--+--+
```

## Lessons Learned

Implemented SudokuConstraint to enforce Sudoku rules on the puzzle.
Added sumSWNEdiagonal and sumNWSEdiagonal generators.
Support merging generators for powerN generator.

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
import 'package:crossnumber/src/models/sudoku_constraint.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition yetAnotherSudoku() {
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
