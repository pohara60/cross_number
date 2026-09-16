/*
# all_square Puzzle Solver

## Puzzle

All Change by Nod

Answers are jumbled to form the actual entry in such a way that no digit stays in the same place. Entries are distinct
and do not start with zero.

```+--+--+--+--+--+--+--+
|1 :  :2 :3 |4 |5 :6 |
+::+--+::+::+::+::+::+
|7 :8 :  |9 :  :  |  |
+::+::+::+::+::+::+::+
|10:  :  |11:  :  :  |
+--+::+--+--+::+--+::+
|12:  |13:  :  |14:  |
+::+--+::+--+--+::+--+
|15:16:  :17|18:  :19|
+::+::+::+::+::+::+::+
|  |20:  :  |21:  :  |
+::+::+::+::+::+--+::+
|22:  |  |23:  :  :  |
+--+--+--+--+--+--+--+


Across
1 #cube
5 #fibonacci
7 #square
9 #square
10  #square
11  #fibonacci
12  #fibonacci
13  #fibonacci
14  #perfect
15  #square
18  #cube
20  #perfect
21  #square
22  #fibonacci
23  #perfect
Down
1 #square
2 #cube
3 #fibonacci
4 #square
5 #perfect
6 #fibonacci
8 #cube
12  #cube
13  #cube
14  #fibonacci
16  #cube
17  #square
18  #square
19  #cube
```

## Solution

```+--+--+--+--+--+--+--+
| 2  8  1  7| 4| 9  8|
+  +--+  +  +  +  +  +
| 5  6  2| 9  1  6| 4|
+  +  +  +  +  +  +  +
| 6  2  5| 8  2  4  5|
+--+  +--+--+  +--+  +
| 3  1| 1  0  6| 8  2|
+  +--+  +--+--+  +--+
| 4  1  3  8| 9  7  2|
+  +  +  +  +  +  +  +
| 9| 6  4  9| 2  9  5|
+  +  +  +  +  +--+  +
| 1  2| 9| 2  8  8  1|
+--+--+--+--+--+--+--+
```

## Lessons Learned

Added all_square puzzle
- Added perfect generator and derange monadic
- puzzle.isSolutionValid() just checks entries, as clues may be ambiguous


 */

// ignore_for_file: unused_import
import 'dart:collection';
import 'dart:math';

import 'package:crossnumber/src/expressions/generators.dart';
import 'package:crossnumber/src/expressions/monadic.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/distinct_constraint.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition all_square() {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :  :2 :3 |4 |5 :6 |',
    '+::+--+::+::+::+::+::+',
    '|7 :8 :  |9 :  :  |  |',
    '+::+::+::+::+::+::+::+',
    '|10:  :  |11:  :  :  |',
    '+--+::+--+--+::+--+::+',
    '|12:  |13:  :  |14:  |',
    '+::+--+::+--+--+::+--+',
    '|15:16:  :17|18:  :19|',
    '+::+::+::+::+::+::+::+',
    '|  |20:  :  |21:  :  |',
    '+::+::+::+::+::+--+::+',
    '|22:  |  |23:  :  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  // monadicFunctionRegistry.registerFunction('firstfactor',
  //     (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));

  final puzzle = PuzzleDefinition.fromString(
    name: 'all_square',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    puzzleConstraints: [all_squareConstraint()],
    distinctConstraint: DistinctConstraint(allClues: false),
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {
      'A1': Entry(id: 'A1', constraints: [ExpressionConstraint(r'$derange 1A')]),
      'A5': Entry(id: 'A5', constraints: [ExpressionConstraint(r'$derange 5A')]),
      'A7': Entry(id: 'A7', constraints: [ExpressionConstraint(r'$derange 7A')]),
      'A9': Entry(id: 'A9', constraints: [ExpressionConstraint(r'$derange 9A')]),
      'A10': Entry(id: 'A10', constraints: [ExpressionConstraint(r'$derange 10A')]),
      'A11': Entry(id: 'A11', constraints: [ExpressionConstraint(r'$derange 11A')]),
      'A12': Entry(id: 'A12', constraints: [ExpressionConstraint(r'$derange 12A')]),
      'A13': Entry(id: 'A13', constraints: [ExpressionConstraint(r'$derange 13A')]),
      'A14': Entry(id: 'A14', constraints: [ExpressionConstraint(r'$derange 14A')]),
      'A15': Entry(id: 'A15', constraints: [ExpressionConstraint(r'$derange 15A')]),
      'A18': Entry(id: 'A18', constraints: [ExpressionConstraint(r'$derange 18A')]),
      'A20': Entry(id: 'A20', constraints: [ExpressionConstraint(r'$derange 20A')]),
      'A21': Entry(id: 'A21', constraints: [ExpressionConstraint(r'$derange 21A')]),
      'A22': Entry(id: 'A22', constraints: [ExpressionConstraint(r'$derange 22A')]),
      'A23': Entry(id: 'A23', constraints: [ExpressionConstraint(r'$derange 23A')]),
      'D1': Entry(id: 'D1', constraints: [ExpressionConstraint(r'$derange 1D')]),
      'D2': Entry(id: 'D2', constraints: [ExpressionConstraint(r'$derange 2D')]),
      'D3': Entry(id: 'D3', constraints: [ExpressionConstraint(r'$derange 3D')]),
      'D4': Entry(id: 'D4', constraints: [ExpressionConstraint(r'$derange 4D')]),
      'D5': Entry(id: 'D5', constraints: [ExpressionConstraint(r'$derange 5D')]),
      'D6': Entry(id: 'D6', constraints: [ExpressionConstraint(r'$derange 6D')]),
      'D8': Entry(id: 'D8', constraints: [ExpressionConstraint(r'$derange 8D')]),
      'D12': Entry(id: 'D12', constraints: [ExpressionConstraint(r'$derange 12D')]),
      'D13': Entry(id: 'D13', constraints: [ExpressionConstraint(r'$derange 13D')]),
      'D14': Entry(id: 'D14', constraints: [ExpressionConstraint(r'$derange 14D')]),
      'D16': Entry(id: 'D16', constraints: [ExpressionConstraint(r'$derange 16D')]),
      'D17': Entry(id: 'D17', constraints: [ExpressionConstraint(r'$derange 17D')]),
      'D18': Entry(id: 'D18', constraints: [ExpressionConstraint(r'$derange 18D')]),
      'D19': Entry(id: 'D19', constraints: [ExpressionConstraint(r'$derange 19D')]),
    },
    clues: {
      '1A': Clue('1A', [ExpressionConstraint(r'#cube')], length: 4),
      '5A': Clue('5A', [ExpressionConstraint(r'#fibonacci')], length: 2),
      '7A': Clue('7A', [ExpressionConstraint(r'#square')], length: 3),
      '9A': Clue('9A', [ExpressionConstraint(r'#square')], length: 3),
      '10A': Clue('10A', [ExpressionConstraint(r'#square')], length: 3),
      '11A': Clue('11A', [ExpressionConstraint(r'#fibonacci')], length: 4),
      '12A': Clue('12A', [ExpressionConstraint(r'#fibonacci')], length: 2),
      '13A': Clue('13A', [ExpressionConstraint(r'#fibonacci')], length: 3),
      '14A': Clue('14A', [ExpressionConstraint(r'#perfect')], length: 2),
      '15A': Clue('15A', [ExpressionConstraint(r'#square')], length: 4),
      '18A': Clue('18A', [ExpressionConstraint(r'#cube')], length: 3),
      '20A': Clue('20A', [ExpressionConstraint(r'#perfect')], length: 3),
      '21A': Clue('21A', [ExpressionConstraint(r'#square')], length: 3),
      '22A': Clue('22A', [ExpressionConstraint(r'#fibonacci')], length: 2),
      '23A': Clue('23A', [ExpressionConstraint(r'#perfect')], length: 4),
      '1D': Clue('1D', [ExpressionConstraint(r'#square')], length: 3),
      '2D': Clue('2D', [ExpressionConstraint(r'#cube')], length: 3),
      '3D': Clue('3D', [ExpressionConstraint(r'#fibonacci')], length: 3),
      '4D': Clue('4D', [ExpressionConstraint(r'#square')], length: 4),
      '5D': Clue('5D', [ExpressionConstraint(r'#perfect')], length: 3),
      '6D': Clue('6D', [ExpressionConstraint(r'#fibonacci')], length: 4),
      '8D': Clue('8D', [ExpressionConstraint(r'#cube')], length: 3),
      '12D': Clue('12D', [ExpressionConstraint(r'#cube')], length: 4),
      '13D': Clue('13D', [ExpressionConstraint(r'#cube')], length: 4),
      '14D': Clue('14D', [ExpressionConstraint(r'#fibonacci')], length: 3),
      '16D': Clue('16D', [ExpressionConstraint(r'#cube')], length: 3),
      '17D': Clue('17D', [ExpressionConstraint(r'#square')], length: 3),
      '18D': Clue('18D', [ExpressionConstraint(r'#square')], length: 3),
      '19D': Clue('19D', [ExpressionConstraint(r'#cube')], length: 3),
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

/*
The 2-digit entries must be the reverse of the answer and none of them can be a palindrome.
14ac answer is 28 so the entry is 82. 14dn answer is 987 with its entry 879.
5dn answer is 496 and taken with 5ac clue means that 5ac answer is 89 and the entry
98. 5dn entry can only be 964 from the no digit in the same place rule.
6dn answer is 2584 and using the digits already in place gives 6dn entry 8452.
11ac answer is also 2584 with the entry 8245.
3dn answer is also 987 with the entry this time being 798.
The possible answers for 9ac are 169, 196 and 961. The answer must be 169 with the
entry 916.
18ac answer must be 729 so the entry must be 972.
19dn answer can be 125, 216, 512 or 729. We can rule out 216 as the entry starts with
a 2. 729 would give an entry of 297 which would require 21ac to be square with 99x
which is impossible. If the answer is 125 then the entry is 251 and is the same if the
answer is 512. So, the 19dn entry is 251.
The only square for 21ac is 529 with the entry being 295.
The only possible squares for 18dn are 289, 529 and 729. 529 and 729 have the 2 in
its original position so the answer is 289 and the entry 928.
23ac answer is 8128 so the entry must be 2881.
20ac answer is 496 so the entry must end in a 4 or 9. If it ends in 4 then the 17dn
square can only be 324 which gives an entry of 342 but that has the 3 in the same
position. So, the 20ac entry ends in 9 and is 649. The possible squares for 7dn are the
same as those for 18dn. 529 and 729 answers have their first digit in the same place
so the answer is 289 and the entry 892.
16dn answer must be 216 and the entry 162.
22ac answer can only be 21 and the entry 12.
12ac answer can be 13 or 34. If it’s 34 then the entry is 43 and the 8dn cube can only
be 343 but that has the 3 unmoved. Thus, 12ac is 13 and the entry 31.
12dn answer can be 1331 or 4913. It can’t be 1331 as the terminal digit is in the same
place. 12dn answer is 4913 with the entry 3491.
15ac answers can be 3481 or 5184. 5184 has a digit in the same place so the answer
is 3481 and the entry 4138.
The only answer for 13dn is 4913 with possible entries of 1349 or 9341. 9341 can be
rejected from 13ac clue as the only Fibonacci fit is 987 and the 9 is in the same place.
13dn entry is 1349.
13ac answer is 610 and the entry 106.
4dn answers can be 1296, 2116, 2601, 2916, 6241 and 9216. All that end in 6 can be
eliminated leaving 2601 and 6241. 2601 would have an entry starting in 0 so the 4dn
entry is 4126.
8dn answers can be 125, 216 and 512. If it’s 125 or 512 then the entry is 251 which
duplicates 19dn. So, the answer is 216 and the entry 621.
1ac answers can be 1728, 2197, 2744 and 3375. Of these 2197 has the last digit in the
same place and is eliminated; 3375 must have a 3 in the same place and is eliminated
also. If it’s 2744 then the entry is 4427 and the 1dn square must contain a 4. Of the 7
possible squares only 324, 784 and 841 can give valid entries which are 423, 478 and
418 respectively. Taking those that end in 8 forces the 10ac answer must be 289 but
the 9 remains in place. The one ending in 3 gives 10ac answer 324 and all the digits
remain in place. 1ac answer is 1728 with potential entries of 2187, 2817 and 8217.
We can discount 2187 as 2dn is a cube and no 3-digit cube contains an 8. If 1ac entry
is 8217 then of the four squares that contain an 8 only 289 and 784 are viable with
entries 892 and 847. Of these 892 has 10ac 22x for a square and although 225 is a
square all the digits remain in place and 847 has no valid entry for 7ac square as no
3-digit square contains 4 and 6 together.
1ac entry is thus 2817. The valid options for 2dn answers are 216 and 512. If it’s 216
then the entry is 162 but that fails on 7ac. Thus, 2dn answer is 512 and the entry 125.
The only squares to contain a 2 and a 6 for 7ac are 256 and 625. Both of which give an
entry of 562 for 7ac.
The only option left for 1dn and 10ac is for the 1dn answer to be 625 and the 10ac
answer to be 256 giving 1dn entry 256 and 10ac entry 625. The 529 option fails in
that the 9 is in the same place for 1dn*/
}

class all_squareConstraint extends PuzzleConstraint {
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
