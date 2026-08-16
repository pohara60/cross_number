/*
# OneSumAmuse Puzzle Solver

## Puzzle

One Sum Amuse, No? by Arden

In each clue the first three elements are 3-digit numbers that together comprise the nine non-zero digits. The fourth
element is the sum of the squares of the other three. Clues are given in pairs, in each pair one set of 3-digit numbers
are the reverses of the other set. Normal rules of algebra apply, all entries are distinct and do not start with zero.
The symbol ′ indicates the reverse of.

```+--+--+--+--+--+--+--+
|Aa:  :b :  :c :  :d |
+::+--+::+--+::+--+::+
|  |Be:  :  |C :  :  |
+::+::+::+--+::+--+::+
|D :  :  |Ef:  :  |  |
+::+::+--+::+--+--+::+
|F :  |G :  :  |Hg:  |
+::+--+--+::+--+::+::+
|  |J :h :  |Kj:  :  |
+::+--+::+--+::+::+::+
|L :  :  |M :  :  |  |
+::+--+::+--+::+--+::+
|N :  :  :  :  :  :  |
+--+--+--+--+--+--+--+


Clues
I sum3digitsquares(e,G,L,A)
II  sum3digitsquares(b,G',H+j,A)
III sum3digitsquares(C,B,G,a)
IV  sum3digitsquares(G',J,M-c,a)
V sum3digitsquares(G,h,M,d)
VI  sum3digitsquares(E+f+H,G',L-F,d)
VII sum3digitsquares(7*D/12,G,g,N)
VIII  sum3digitsquares(f-b/2,G',K,N)
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
import 'package:crossnumber/src/expressions/polyadic.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

import "onesumamuse_sum_squares.dart";

PuzzleDefinition onesumamuse() {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|Aa:  :b :  :c :  :d |',
    '+::+--+::+--+::+--+::+',
    '|  |Be:  :  |C :  :  |',
    '+::+::+::+--+::+--+::+',
    '|D :  :  |Ef:  :  |  |',
    '+::+::+--+::+--+--+::+',
    '|F :  |G :  :  |Hg:  |',
    '+::+--+--+::+--+::+::+',
    '|  |J :h :  |Kj:  :  |',
    '+::+--+::+--+::+::+::+',
    '|L :  :  |M :  :  |  |',
    '+::+--+::+--+::+--+::+',
    '|N :  :  :  :  :  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final monadicFunctionRegistry = MonadicFunctionRegistry();
  // monadicFunctionRegistry.registerFunction('firstfactor',
  //     (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));

  final polyadicFunctionRegistry = PolyadicFunctionRegistry();
  polyadicFunctionRegistry.registerFunction(
      'sum3digitsquares', (values, {int? min, int? max}) => sum3DigitSquares(values));

  final puzzle = PuzzleDefinition.fromString(
    name: 'OneSumAmuse',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    puzzleConstraints: [OneSumAmuseConstraint()],
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {
      'A': Entry(id: 'A', constraints: [
        ExpressionConstraint(r"£sum3digitsquares(e,G,L)"),
        ExpressionConstraint(r"£sum3digitsquares(b,'G,H+j)")
      ]),
      'a': Entry(id: 'a', constraints: [
        ExpressionConstraint(r"£sum3digitsquares(C,B,G)"),
        ExpressionConstraint(r"£sum3digitsquares('G,J,M-c)")
      ]),
      'd': Entry(id: 'd', constraints: [
        ExpressionConstraint(r"£sum3digitsquares(G,h,M)"),
        ExpressionConstraint(r"£sum3digitsquares(E+f+H,'G,L-F)")
      ]),
      'N': Entry(id: 'N', constraints: [
        ExpressionConstraint(r"£sum3digitsquares(7*D/12,G,g)"),
        ExpressionConstraint(r"£sum3digitsquares(f-b/2,'G,K)")
      ]),
    },
    clues: {
      // 'I': Clue('I', [ExpressionConstraint(r"£sum3digitsquares4(e,G,L,A)")]),
      // 'II': Clue('II', [ExpressionConstraint(r"£sum3digitsquares4(b,'G,H+j,A)")]),
      // 'III': Clue('III', [ExpressionConstraint(r"£sum3digitsquares4(C,B,G,a)")]),
      // 'IV': Clue('IV', [ExpressionConstraint(r"£sum3digitsquares4('G,J,M-c,a)")]),
      // 'V': Clue('V', [ExpressionConstraint(r"£sum3digitsquares4(G,h,M,d)")]),
      // 'VI': Clue('VI', [ExpressionConstraint(r"£sum3digitsquares4(E+f+H,'G,L-F,d)")]),
      // 'VII': Clue('VII', [ExpressionConstraint(r"£sum3digitsquares4(7*D/12,G,g,N)")]),
      // 'VIII': Clue('VIII', [ExpressionConstraint(r"£sum3digitsquares4(f-b/2,'G,K,N)")]),
    },
    variables: {
      // 'A': Variable('A', getVariableValues(2)),
    },
  );
  initPuzzle(puzzle);
  setAnswers(puzzle);
  return puzzle;
}

void initPuzzle(PuzzleDefinition puzzle) {
  computeSumOfSquares();
  var argEntryNames = "e,G,L,b,G,C,B,G,G,J,G,h,M,G,G,g,G,K".split(",").toSet().toList()..sort();
  for (var entryName in argEntryNames) {
    var entry = puzzle.entries[entryName]!;
    entry.possibleValues = allArgs;
  }
  var argSumNames = ["A", "a", "d", "N"];
  for (var entryName in argSumNames) {
    var entry = puzzle.entries[entryName]!;
    entry.possibleValues = sumOfSquares;
  }
}

List<int> sum3DigitSquares(List<dynamic> values) {
  // In each clue the first three elements are 3-digit numbers that together comprise the nine non-zero digits. The
  // fourth element is the sum of the squares of the other three.
  // Clues are given in pairs, in each pair one set of 3-digit numbers are the reverses of the other set.
  assert(values.length == 3);
  final a = values[0] as int;
  final b = values[1] as int;
  final c = values[2] as int;
  // final d = values[3] as int;

  var ordered = [a, b, c]..sort();
  final sumOfSquares = getSumOfSquaresForOrdered(ordered);
  // if (sumOfSquares == d) {
  if (sumOfSquares != null) {
    return [sumOfSquares];
  }
  return [];
  // }
  // return [];
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

class OneSumAmuseConstraint extends PuzzleConstraint {
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

Map<List<int>, int> results = {};
var firstArg = <int>{};
var secondArg = <int>{};
var thirdArg = <int>{};
var sumOfSquares = <int>{};
var allArgs = <int>{};

void computeSumOfSquares() {
  results = getSumOfSquares();
  print('Total results found: ${results.length}');
  firstArg = results.keys.map((k) => k[0]).toSet();
  secondArg = results.keys.map((k) => k[1]).toSet();
  thirdArg = results.keys.map((k) => k[2]).toSet();
  sumOfSquares = results.values.toSet();
  allArgs = firstArg.union(secondArg).union(thirdArg);
  print('Unique A value count: ${firstArg.length}');
  print('Unique B value count: ${secondArg.length}');
  print('Unique C value count: ${thirdArg.length}');
  print('Unique Sum value count: ${sumOfSquares.length}');
  print('Unique All Args value count: ${allArgs.length}');
}

int? getSumOfSquaresForOrdered(List<int> ordered) {
  return results[ordered];
}
