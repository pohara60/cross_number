/*
# SummingSquares Puzzle Solver

## Puzzle

Summing Squares

The sum in question is 5ac which is the total of the five 3-digit entries.

```+--+--+--+--+--+
|1 :  :2 |3 :4 |
+::+--+::+--+::+
|  |5 :  :  :  |
+::+--+::+--+::+
|6 :  :  |7 :  |
+--+--+--+--+--+


Across
1	#square
3	
5	A1+A6+D1+D2+D4
6	#square
7	
Down
1	$square A7
2	$square A3
4	#square
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

PuzzleDefinition summingsquares() {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :  :2 |3 :4 |',
    '+::+--+::+--+::+',
    '|  |5 :  :  :  |',
    '+::+--+::+--+::+',
    '|6 :  :  |7 :  |',
    '+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  // monadicFunctionRegistry.registerFunction('firstfactor',
  //     (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));

  final puzzle = PuzzleDefinition.fromString(
    name: 'SummingSquares',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    puzzleConstraints: [SummingSquaresConstraint()],
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {
      'A1': Entry(id: 'A1', constraints: [ExpressionConstraint(r'#square')]),
      'A3': Entry(id: 'A3', constraints: []),
      'A5': Entry(id: 'A5', constraints: [ExpressionConstraint(r'A1+A6+D1+D2+D4')]),
      'A6': Entry(id: 'A6', constraints: [ExpressionConstraint(r'#square')]),
      'A7': Entry(id: 'A7', constraints: []),
      'D1': Entry(id: 'D1', constraints: [ExpressionConstraint(r'#square'), ExpressionConstraint(r'$square A7')]),
      'D2': Entry(id: 'D2', constraints: [ExpressionConstraint(r'#square'), ExpressionConstraint(r'$square A3')]),
      'D4': Entry(id: 'D4', constraints: [ExpressionConstraint(r'#square')]),
    },
    clues: {
      // '1A': Clue('1A', [ExpressionConstraint(r'#square')], length: 3),
      // '3A': Clue('3A', [], length: 2),
      // '5A': Clue('5A', [ExpressionConstraint(r'A1+A6+D1+D2+D4')], length: 4),
      // '6A': Clue('6A', [ExpressionConstraint(r'#square')], length: 3),
      // '7A': Clue('7A', [], length: 2),
      // '1D': Clue('1D', [ExpressionConstraint(r'$square A7')], length: 3),
      // '2D': Clue('2D', [ExpressionConstraint(r'$square A3')], length: 3),
      // '4D': Clue('4D', [ExpressionConstraint(r'#square')], length: 3),
    },
    variables: {
      // 'A': Variable('A', getVariableValues(2)),
    },
  );
  setAnswers(puzzle);
  return puzzle;
}

// PrimeGenerator? primeGenerator;
// Set<int> getVariableValues(int length) {
// // get primes of length
//   var min = pow(10, length - 1).toInt();
//   var max = pow(10, length).toInt() - 1;
//   primeGenerator ??= GeneratorRegistry().get('prime') as PrimeGenerator;
//   final variableList = primeGenerator!.getValues(min, max).toSet();
//   return variableList;
// }

// List<int> getReversiblePrimesNDigits(int n) {
//   primeGenerator ??= GeneratorRegistry().get('prime') as PrimeGenerator;
//   var min = pow(10, n - 1).toInt();
//   var max = pow(10, n).toInt() - 1;
//   var primes = primeGenerator!.getValues(min, max);
//   return primes.where((p) {
//     var s = p.toString();
//     var rs = s.split('').reversed.join('');
//     return s != rs && primes.contains(int.parse(rs));
//   }).toList();
// }

void setAnswers(PuzzleDefinition puzzle) {
  // puzzle.clues['1D']!.answer = 11;
  // puzzle.entries['D1']!.answer = 11;
}

class SummingSquaresConstraint extends PuzzleConstraint {
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
