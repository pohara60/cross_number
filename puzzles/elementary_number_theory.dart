/*
# elementary_number_theory Puzzle Solver

## Puzzle

Elementary Number Theory by Oyler

Fifteen statements lettered A to O are given below.  The clues detail all the statements from the list that apply to the
associated entry.  There are two unclued entries and, whilst keeping the title in mind, hints to their statements can be
found by decoding the individual digits to letters for the entries to their associated clues.  No entry starts with zero
and all are distinct.

```+--+--+--+--+--+--+--+
|1 :2 |3 :  |4 :  :5 |
+--+::+::+--+::+--+::+
|6 :  :  |7 |8 :9 :  |
+--+::+::+::+::+::+--+
|10:  |11:  :  |12:13|
+::+::+--+::+--+--+::+
|  |14:  :  :  :15|  |
+::+--+--+::+--+::+::+
|16:17|18:  :19|20:  |
+--+::+::+::+::+::+--+
|21:  :  |  |22:  :  |
+::+--+::+--+::+::+--+
|23:  :  |24:  |25:  |
+--+--+--+--+--+--+--+


Across
1 C F J
3 C E J L
4 C F
6 H I
8 C D H
10  C
11  C G I K L M
12  D H
14  see 8 ac and preamble
16  C G J K
18  A B C O
20  D
21  B G I
22  A D M
23  C D G H M
24  B C E
25  D G H M
Down
2 B G N
3 C
4 B G H K M
5 B C E G K N
7 see 21ac and preamble
9 A B G H I K
10  A C I J
13  D G H O
15  C E G I L
17  C
18  B G M
19  C
21  C G J L
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
import 'package:crossnumber/src/models/statement.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition elementary_number_theory() {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :2 |3 :  |4 :  :5 |',
    '+--+::+::+--+::+--+::+',
    '|6 :  :  |7 |8 :9 :  |',
    '+--+::+::+::+::+::+--+',
    '|10:  |11:  :  |12:13|',
    '+::+::+--+::+--+--+::+',
    '|  |14:  :  :  :15|  |',
    '+::+--+--+::+--+::+::+',
    '|16:17|18:  :19|20:  |',
    '+--+::+::+::+::+::+--+',
    '|21:  :  |  |22:  :  |',
    '+::+--+::+--+::+::+--+',
    '|23:  :  |24:  |25:  |',
    '+--+--+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  // monadicFunctionRegistry.registerFunction('firstfactor',
  //     (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));

  final puzzle = PuzzleDefinition.fromString(
    name: 'elementary_number_theory',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    puzzleConstraints: [elementary_number_theoryConstraint()],
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {
      'A1': Entry(id: 'A1', statements: 'C F J'),
      'A3': Entry(id: 'A3', statements: 'C E J L'),
      'A4': Entry(id: 'A4', statements: 'C F'),
      'A6': Entry(id: 'A6', statements: 'H I'),
      'A8': Entry(id: 'A8', statements: 'C D H'),
      'A10': Entry(id: 'A10', statements: 'C'),
      'A11': Entry(
        id: 'A11',
        statements: 'C G I K L M',
      ),
      'A12': Entry(id: 'A12', statements: 'D H'),
      'A14': Entry(
        id: 'A14',
        // see A8 and preamble - A8 = 571 = elements H B N
        statements: 'H B N',
      ),
      'A16': Entry(id: 'A16', statements: 'C G J K'),
      'A18': Entry(id: 'A18', statements: 'A B C O'),
      'A20': Entry(id: 'A20', statements: 'D'),
      'A21': Entry(id: 'A21', statements: 'B G I'),
      'A22': Entry(id: 'A22', statements: 'A D M'),
      'A23': Entry(
        id: 'A23',
        statements: 'C D G H M',
      ),
      'A24': Entry(id: 'A24', statements: 'B C E'),
      'A25': Entry(id: 'A25', statements: 'D G H M'),
      'D2': Entry(id: 'D2', statements: 'B G N'),
      'D3': Entry(id: 'D3', statements: 'C'),
      'D4': Entry(id: 'D4', statements: 'B G H K M'),
      'D5': Entry(
        id: 'D5',
        statements: 'B C E G K N',
      ),
      'D7': Entry(
        id: 'D7',
        // see 21ac = 869 = elements O C F
        statements: 'O C F',
      ),
      'D9': Entry(
        id: 'D9',
        statements: 'A B G H I K',
      ),
      'D10': Entry(id: 'D10', statements: 'A C I J'),
      'D13': Entry(id: 'D13', statements: 'D G H O'),
      'D15': Entry(
        id: 'D15',
        statements: 'C E G I L',
      ),
      'D17': Entry(id: 'D17', statements: 'C'),
      'D18': Entry(id: 'D18', statements: 'B G M'),
      'D19': Entry(id: 'D19', statements: 'C'),
      'D21': Entry(id: 'D21', statements: 'C G J L'),
    },
    clues: {},
    variables: {
      // 'A': Variable('A', getVariableValues(2)),
    },
    statements: {
      'A': Statement('A', r'#palindrome'),
      'B': Statement('B', r'#prime * #prime'),
      'C': Statement('C', r'#prime + #prime'),
      'D': Statement('D', r'#prime'),
      'E': Statement('E', r'#triangular'),
      'F': Statement('F', r'#cube'),
      'G': Statement('G', r'@ IF @ % 4 = 1'), // It has a remainder of 1 when divided by 4
      'H': Statement('H', r'@ IF $isOdd $digitproduct @'),
      'I': Statement('I', r'$multiple 11'),
      'J': Statement('J', r'#square'),
      'K': Statement('K', r'$multiple 7'),
      'L': Statement('L', r'$multiple 9'),
      'M': Statement('M', r'@ IF @ % 10 = 3'), // Its units digit is 3
      'N': Statement('N', r'#fibonacci'),
      'O': Statement('O', r'@ IF ($digitsum @) > 24'), // Its digit sum is greater than 24
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
  puzzle.entries['A1']!.answer = 64;
  puzzle.entries['A3']!.answer = 36;
  puzzle.entries['A4']!.answer = 512;
  puzzle.entries['A6']!.answer = 715;
  puzzle.entries['A8']!.answer = 571;
  puzzle.entries['A10']!.answer = 48;
  puzzle.entries['A11']!.answer = 693;
  puzzle.entries['A12']!.answer = 79;
  puzzle.entries['A14']!.answer = 17711;
  puzzle.entries['A16']!.answer = 49;
  puzzle.entries['A18']!.answer = 898;
  puzzle.entries['A20']!.answer = 47;
  puzzle.entries['A21']!.answer = 869;
  puzzle.entries['A22']!.answer = 383;
  puzzle.entries['A23']!.answer = 193;
  puzzle.entries['A24']!.answer = 10;
  puzzle.entries['A25']!.answer = 53;

  puzzle.entries['D2']!.answer = 4181;
  puzzle.entries['D3']!.answer = 356;
  puzzle.entries['D4']!.answer = 553;
  puzzle.entries['D5']!.answer = 21;
  puzzle.entries['D7']!.answer = 29791;
  puzzle.entries['D9']!.answer = 77;
  puzzle.entries['D10']!.answer = 484;
  puzzle.entries['D13']!.answer = 997;
  puzzle.entries['D15']!.answer = 1485;
  puzzle.entries['D17']!.answer = 96;
  puzzle.entries['D18']!.answer = 893;
  puzzle.entries['D19']!.answer = 830;
  puzzle.entries['D21']!.answer = 81;
}

class elementary_number_theoryConstraint extends PuzzleConstraint {
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
