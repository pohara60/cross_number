/*
# Triples Puzzle Solver

## Puzzle

Triples by Arden

Each clue describes a characteristic of three 3 -digit numbers that between them contain the digits 1 – 9 exactly once.
Upper-case letters denote across entries and lower-case down entries. The letters show the grid entries and where
appropriate these are given in the correct order. All entries are distinct and the normal rules of algebra apply.

```+--+--+--+--+--+--+--+--+--+--+
|a |A :b :c |Bd:e :f |Cg:  :h |
+::+--+::+::+::+::+::+::+--+::+
|D :j :  |E :  :  |F :  :  |  |
+::+::+::+::+::+::+::+::+--+::+
|  |G :  :  |H :  :  |J :k :  |
+--+::+--+--+--+--+--+--+::+--+
|Km:  :n |Mp:q :r |Ns:t :  |u |
+::+--+::+::+::+::+::+::+::+::+
|  |P :  :  |Q :  :  |R :  :  |
+::+--+::+::+::+::+::+::+--+::+
|S :  :  |T :  :  |U :  :  |  |
+--+--+--+--+--+--+--+--+--+--+


Clues
I £pandigital(A,M,K)
II  £pandigital(B + P,C - H,j + u)
III £pandigital(C,N,S)
IV  £pandigital(D,G,U)
V £pandigital(E,g,j)
VI  £pandigital(J,R,e)
VII £pandigital(P,Q,F)
VIII  £pandigital(a,d,f)
IX  £pandigital(c,s,b)
X £pandigital(h,t,T)
XI  £pandigital(k,m,p)
XII £pandigital(q,r,n)
Ia  A = $multiple 29 
Ib  M = $multiple 29 
Ic  K = $multiple 29 
Iia $isHarshad (B+P)
Iib $isHarshad (C-H)
Iic $isHarshad (j+u)
IIIa  $isSquare C
IIIb  $isSquare N
IIIc  $isSquare S
IVa 15 = $digitsum D
IVb 15 = $digitsum G
IVc 15 = $digitsum U
Va  $isHalfTriangular E
Vb  $isHalfTriangular g
Vc  $isHalfTriangular j
VIa $isLucky $isPrime J
VIb $isLucky $isPrime R
VIc $isLucky $isPrime e
VIIa  P + Q = F
VIIIa $isPrime a
VIIIb $isPrime d
VIIIc $isPrime f
IXa c = 3*s = 5*b
Xa  T - t = t - h
XIa 16 = $numfactors  k
XIb 16 = $numfactors m
XIc 16 = $numfactors p
XIIa  $isTriangular q
XIIb  $isTriangular r
XIIc  $isSquare n
```

## Solution

```
+--+--+--+--+--+--+--+--+--+--+
| 5| 2  6  1| 2  5  1| 7  8  4|
+  +--+  +  +  +  +  +  +--+  +
| 8  3  4| 2  6  4| 4  9  5| 9|
+  +  +  +  +  +  +  +  +--+  +
| 7| 1  5  9| 3  1  9| 8  2  3|
+--+  +--+--+--+--+--+--+  +--+
| 9  5  7| 3  4  8| 3  6  1| 5|
+  +--+  +  +  +  +  +  +  +  +
| 4| 1  2  7| 3  6  8| 7  6  9|
+  +--+  +  +  +  +  +  +--+  +
| 5  2  9| 8  5  1| 7  2  6| 7|
+--+--+--+--+--+--+--+--+--+--+
```

## Lessons Learned

Add triples puzzle
- puzzle clues imposed constraints on three expressions
- puzzle specific polyadic pandigital(a,b,c) for the first constraint for each clue
- up to 3 additional clues for each clue for the other expression constraints
- add monadics isHarshad, isHalfTriangular, isLucky, numfactors
- fix MonadicMaxOp for digitsum


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

// ignore: non_constant_identifier_names
PuzzleDefinition triples() {
  var gridString = [
    '+--+--+--+--+--+--+--+--+--+--+',
    '|a |A :b :c |Bd:e :f |Cg:  :h |',
    '+::+--+::+::+::+::+::+::+--+::+',
    '|D :j :  |E :  :  |F :  :  |  |',
    '+::+::+::+::+::+::+::+::+--+::+',
    '|  |G :  :  |H :  :  |J :k :  |',
    '+--+::+--+--+--+--+--+--+::+--+',
    '|Km:  :n |Mp:q :r |Ns:t :  |u |',
    '+::+--+::+::+::+::+::+::+::+::+',
    '|  |P :  :  |Q :  :  |R :  :  |',
    '+::+--+::+::+::+::+::+::+--+::+',
    '|S :  :  |T :  :  |U :  :  |  |',
    '+--+--+--+--+--+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  final PolyadicFunctionRegistry polyadicFunctionRegistry = PolyadicFunctionRegistry();
  polyadicFunctionRegistry.registerFunction('pandigital', pandigital, PolyadicMaxOp.limit);
  // monadicFunctionRegistry.registerFunction('firstfactor',
  //     (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));

  final puzzle = PuzzleDefinition.fromString(
    name: 'Triples',
    gridString: gridString.join('\n'),
    mappingIsKnown: true,
    puzzleConstraints: [TriplesConstraint()],
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    distinctConstraint: DistinctConstraint(allClues: false),
    entries: {},
    clues: {
      'I': Clue('I', [ExpressionConstraint(r'£pandigital(A,M,K)')]),
      'II': Clue('II', [
        ExpressionConstraint(r'£pandigital(B + P,C - H,j + u)'),
      ]),
      'III': Clue('III', [ExpressionConstraint(r'£pandigital(C,N,S)')]),
      'IV': Clue('IV', [ExpressionConstraint(r'£pandigital(D,G,U)')]),
      'V': Clue('V', [ExpressionConstraint(r'£pandigital(E,g,j)')]),
      'VI': Clue('VI', [ExpressionConstraint(r'£pandigital(J,R,e)')]),
      'VII': Clue('VII', [ExpressionConstraint(r'£pandigital(P,Q,F)')]),
      'VIII': Clue('VIII', [ExpressionConstraint(r'£pandigital(a,d,f)')]),
      'IX': Clue('IX', [ExpressionConstraint(r'£pandigital(c,s,b)')]),
      'X': Clue('X', [ExpressionConstraint(r'£pandigital(h,t,T)')]),
      'XI': Clue('XI', [ExpressionConstraint(r'£pandigital(k,m,p)')]),
      'XII': Clue('XII', [ExpressionConstraint(r'£pandigital(q,r,n)')]),
      'Ia': Clue('Ia', [ExpressionConstraint(r'A = $multiple 29 ')]),
      'Ib': Clue('Ib', [ExpressionConstraint(r'M = $multiple 29 ')]),
      'Ic': Clue('Ic', [ExpressionConstraint(r'K = $multiple 29 ')]),
      'Iia': Clue('Iia', [ExpressionConstraint(r'$isHarshad (B+P)')]),
      'Iib': Clue('Iib', [ExpressionConstraint(r'$isHarshad (C-H)')]),
      'Iic': Clue('Iic', [ExpressionConstraint(r'$isHarshad (j+u)')]),
      'IIIa': Clue('IIIa', [ExpressionConstraint(r'$isSquare C')]),
      'IIIb': Clue('IIIb', [ExpressionConstraint(r'$isSquare N')]),
      'IIIc': Clue('IIIc', [ExpressionConstraint(r'$isSquare S')]),
      'IVa': Clue('IVa', [ExpressionConstraint(r'15 = $digitsum D')]),
      'IVb': Clue('IVb', [ExpressionConstraint(r'15 = $digitsum G')]),
      'IVc': Clue('IVc', [ExpressionConstraint(r'15 = $digitsum U')]),
      'Va': Clue('Va', [ExpressionConstraint(r'$isHalfTriangular E')]),
      'Vb': Clue('Vb', [ExpressionConstraint(r'$isHalfTriangular g')]),
      'Vc': Clue('Vc', [ExpressionConstraint(r'$isHalfTriangular j')]),
      'VIa': Clue('VIa', [ExpressionConstraint(r'$isLucky $isPrime J')]),
      'VIb': Clue('VIb', [ExpressionConstraint(r'$isLucky $isPrime R')]),
      'VIc': Clue('VIc', [ExpressionConstraint(r'$isLucky $isPrime e')]),
      'VIIa': Clue('VIIa', [ExpressionConstraint(r'P + Q = F')]),
      'VIIIa': Clue('VIIIa', [ExpressionConstraint(r'$isPrime a')]),
      'VIIIb': Clue('VIIIb', [ExpressionConstraint(r'$isPrime d')]),
      'VIIIc': Clue('VIIIc', [ExpressionConstraint(r'$isPrime f')]),
      'IXa': Clue('IXa', [ExpressionConstraint(r'c = s/3 = b/5')]),
      'Xa': Clue('Xa', [ExpressionConstraint(r'T + h = 2*t')]),
      'XIa': Clue('XIa', [ExpressionConstraint(r'16 = $numfactors k')]),
      'XIb': Clue('XIb', [ExpressionConstraint(r'16 = $numfactors m')]),
      'XIc': Clue('XIc', [ExpressionConstraint(r'16 = $numfactors p')]),
      // 'XIIa': Clue('XIIa', [ExpressionConstraint(r'$isTriangular q')]),
      // 'XIIb': Clue('XIIb', [ExpressionConstraint(r'$isTriangular r')]),
      // 'XIIc': Clue('XIIc', [ExpressionConstraint(r'$isSquare n')]),
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
  puzzle.entries['A']!.answer = 261;
  puzzle.entries['B']!.answer = 251;
  puzzle.entries['C']!.answer = 784;
  puzzle.entries['D']!.answer = 834;
  puzzle.entries['E']!.answer = 264;
  puzzle.entries['F']!.answer = 495;
  puzzle.entries['G']!.answer = 159;
  puzzle.entries['H']!.answer = 319;
  puzzle.entries['J']!.answer = 823;
  puzzle.entries['K']!.answer = 957;
  puzzle.entries['M']!.answer = 348;
  puzzle.entries['N']!.answer = 361;
  puzzle.entries['P']!.answer = 127;
  puzzle.entries['Q']!.answer = 368;
  puzzle.entries['R']!.answer = 769;
  puzzle.entries['S']!.answer = 529;
  puzzle.entries['T']!.answer = 851;
  puzzle.entries['U']!.answer = 726;
  puzzle.entries['a']!.answer = 587;
  puzzle.entries['b']!.answer = 645;
  puzzle.entries['c']!.answer = 129;
  puzzle.entries['d']!.answer = 263;
  puzzle.entries['e']!.answer = 541;
  puzzle.entries['f']!.answer = 149;
  puzzle.entries['g']!.answer = 798;
  puzzle.entries['h']!.answer = 493;
  puzzle.entries['j']!.answer = 315;
  puzzle.entries['k']!.answer = 216;
  puzzle.entries['m']!.answer = 945;
  puzzle.entries['n']!.answer = 729;
  puzzle.entries['p']!.answer = 378;
  puzzle.entries['q']!.answer = 435;
  puzzle.entries['r']!.answer = 861;
  puzzle.entries['s']!.answer = 387;
  puzzle.entries['t']!.answer = 672;
  puzzle.entries['u']!.answer = 597;
}

class TriplesConstraint extends PuzzleConstraint {
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

List<int> pandigital(List<dynamic> args, {int? max, int? min}) {
  // Three arguments are 3 digit numbers
  // Together they have digits 1-9
  assert(args.length == 3);
  var a0 = args[0];
  var a1 = args[1];
  var a2 = args[2];
  if (a0 < 100 || a0 > 999) return [];
  if (a1 < 100 || a1 > 999) return [];
  if (a2 < 100 || a2 > 999) return [];
  var str = a0.toString() + a1.toString() + a2.toString();
  var digits = Set.from(str.split(""));
  if (digits.length != 9 || digits.contains("0")) return [];
  return [1];
}
