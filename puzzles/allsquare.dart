/*
# AllSquare Puzzle Solver

## Puzzle

All Square by Nod

Clues are in ascending order of their answers. All entries in the grid are perfect squares and solvers must square the
answer to each clue to find the entry. The letters in the clues represent the first 10 square numbers (1, 4, 9, …, 100),
in an order to be determined. All entries are different, none starts with a zero and normal rules of algebra apply.  The
Unclued entry could have been clued by the word SMART with the appropriate signs and solvers should write this missing
clue below the completed grid.

+--+--+--+--+--+--+--+--+
|1 |2 |3 |4 |  |5 |6 |7 |
+--+--+--+--+--+--+--+--+
|8 |  |  |  |  |9 |  |  |
+--+--+--+--+--+--+--+--+
|10|  |  |  |11|  |  |  |
+--+--+--+--+--+--+--+--+
|12|13|  |14|15|  |  |  |
+--+--+--+--+--+--+--+--+
|16|  |  |  |  |17|  |  |
+--+--+--+--+--+--+--+--+
|18|  |19|  |  |20|21|22|
+--+--+--+--+--+--+--+--+
|23|  |  |24|  |  |  |  |
+--+--+--+--+--+--+--+--+
|25|  |  |26|  |  |  |  |
+--+--+--+--+--+--+--+--+


Clues
1 S + M - A - R + T
2 (T - R) / I + A - L
3 T / (R - A - S/ H)
4 G + L (O - A - T)
5 (TR - A) / (IL)
6 (S - I - G + M) A
7 G - H - O + S - T
8 TO / (R - AH)
9 S - L(O - T + H)
10  (S + O)(L + A) / R
11  
12  T - R/ (I + A) L
13  (S / T + R / I)A
14  (S - T) / AI - R
15  (S - H ) / IR - T
16  G - H - O + S + T
17  T + (A + I) / L - O + R
18  TR / A - I - L
19  M - A + R + SH
20  G + H + O + S + T
21  GL + O + A + T
22  H + O + I + S + T
23  SL - O - T - H
24  S / M(I - T) + H
25  S / TI - G + MA
26  L(O - A + T) + H
27  (H + O)I - ST
28  RI / G - H + T
29  R + A + T + I + O = 265
30  S + H + O + R + T = 267
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
import 'package:crossnumber/src/models/ordering_constraint.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition allsquare() {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|1 :2 :3 :4 :  |5 :6 :7 |',
    '+::+::+::+::+--+::+::+::+',
    '|8 :  :  :  :  |9 :  :  |',
    '+::+::+::+::+--+::+::+::+',
    '|10:  :  |  |11:  :  :  |',
    '+--+--+::+::+--+--+::+::+',
    '|12|13|  |14:15:  :  :  |',
    '+::+::+--+::+::+::+::+::+',
    '|16:  :  :  :  |17|  |  |',
    '+::+::+--+--+::+::+--+--+',
    '|18:  :19:  |  |20:21:22|',
    '+::+::+::+--+::+::+::+::+',
    '|23:  :  |24:  :  :  :  |',
    '+::+::+::+--+::+::+::+::+',
    '|25:  :  |26:  :  :  :  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  // ignore: unused_local_variable
  final MonadicFunctionRegistry monadicFunctionRegistry = MonadicFunctionRegistry();
  // monadicFunctionRegistry.registerFunction('firstfactor',
  //     (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));

  // Entry values are squares of clue values
  int mappingFunction(int clueValue) => clueValue * clueValue;

  final puzzle = PuzzleDefinition.fromString(
    name: 'AllSquare',
    gridString: gridString.join('\n'),
    mappingIsKnown: false,
    mappingFunction: mappingFunction,
    puzzleConstraints: [AllSquareConstraint()],
    // orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {},
    clues: {
      '1': Clue('1', [ExpressionConstraint(r'S + M - A - R + T')]),
      '2': Clue('2', [ExpressionConstraint(r'(T - R) / I + A - L')]),
      '3': Clue('3', [ExpressionConstraint(r'T / (R - A - S/ H)')]),
      '4': Clue('4', [ExpressionConstraint(r'G + L * (O - A - T)')]),
      '5': Clue('5', [ExpressionConstraint(r'(T*R - A) / (I*L)')]),
      '6': Clue('6', [ExpressionConstraint(r'(S - I - G + M) * A')]),
      '7': Clue('7', [ExpressionConstraint(r'G - H - O + S - T')]),
      '8': Clue('8', [ExpressionConstraint(r'T*O / (R - A*H)')]),
      '9': Clue('9', [ExpressionConstraint(r'S - L * (O - T + H)')]),
      '10': Clue('10', [ExpressionConstraint(r'(S + O) * (L + A) / R')]),
      '11': Clue('11', []),
      '12': Clue('12', [ExpressionConstraint(r'T - R/ (I + A) * L')]),
      '13': Clue('13', [ExpressionConstraint(r'(S / T + R / I) * A')]),
      '14': Clue('14', [ExpressionConstraint(r'(S - T) / A*I - R')]),
      '15': Clue('15', [ExpressionConstraint(r'(S - H ) / I*R - T')]),
      '16': Clue('16', [ExpressionConstraint(r'G - H - O + S + T')]),
      '17': Clue('17', [ExpressionConstraint(r'T + (A + I) / L - O + R')]),
      '18': Clue('18', [ExpressionConstraint(r'T*R / A - I - L')]),
      '19': Clue('19', [ExpressionConstraint(r'M - A + R + S*H')]),
      '20': Clue('20', [ExpressionConstraint(r'G + H + O + S + T')]),
      '21': Clue('21', [ExpressionConstraint(r'G*L + O + A + T')]),
      '22': Clue('22', [ExpressionConstraint(r'H + O + I + S + T')]),
      '23': Clue('23', [ExpressionConstraint(r'S*L - O - T - H')]),
      '24': Clue('24', [ExpressionConstraint(r'S / M * (I - T) + H')]),
      '25': Clue('25', [ExpressionConstraint(r'S / T*I - G + M*A')]),
      '26': Clue('26', [ExpressionConstraint(r'L * (O - A + T) + H')]),
      '27': Clue('27', [ExpressionConstraint(r'(H + O) * I - S*T')]),
      '28': Clue('28', [ExpressionConstraint(r'R*I / G - H + T')]),
      '29': Clue('29', [ExpressionConstraint(r'R + A + T + I + O = 265')]),
      '30': Clue('30', [ExpressionConstraint(r'S + H + O + R + T = 267')]),
    },
    variables: {
      'A': Variable('A', getVariableValues()),
      'G': Variable('G', getVariableValues()),
      'H': Variable('H', getVariableValues()),
      'I': Variable('I', getVariableValues()),
      'L': Variable('L', getVariableValues()),
      'M': Variable('M', getVariableValues()),
      'O': Variable('O', getVariableValues()),
      'R': Variable('R', getVariableValues()),
      'S': Variable('S', getVariableValues()),
      'T': Variable('T', getVariableValues()),
    },
  );
  setAnswers(puzzle);

  // Initialise possible values for unclued clue - square must be less than or equal to 5 digits
  puzzle.clues['11']!.possibleValues = List.generate(316, (i) => i + 1).toSet();
  return puzzle;
}

Set<int>? getVariableValues() {
  return Set.from(List.generate(10, (n) => (n + 1) * (n + 1)));
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
  puzzle.clues['1']!.answer = 10;
  puzzle.clues['2']!.answer = 11;
  puzzle.clues['3']!.answer = 12;
  puzzle.clues['4']!.answer = 13;
  puzzle.clues['5']!.answer = 14;
  puzzle.clues['6']!.answer = 16;
  puzzle.clues['7']!.answer = 20;
  puzzle.clues['8']!.answer = 21;
  puzzle.clues['9']!.answer = 25;
  puzzle.clues['10']!.answer = 26;
  puzzle.clues['11']!.answer = 29;
  puzzle.clues['12']!.answer = 31;
  puzzle.clues['13']!.answer = 61;
  puzzle.clues['14']!.answer = 80;
  puzzle.clues['15']!.answer = 89;
  puzzle.clues['16']!.answer = 92;
  puzzle.clues['17']!.answer = 107;
  puzzle.clues['18']!.answer = 157;
  puzzle.clues['19']!.answer = 174;
  puzzle.clues['20']!.answer = 192;
  puzzle.clues['21']!.answer = 201;
  puzzle.clues['22']!.answer = 231;
  puzzle.clues['23']!.answer = 238;
  puzzle.clues['24']!.answer = 253;
  puzzle.clues['25']!.answer = 263;
  puzzle.clues['26']!.answer = 277;
  puzzle.clues['27']!.answer = 284;
  puzzle.clues['28']!.answer = 291;

  // puzzle.entries['D1']!.answer = 11;

  puzzle.variables['A']!.answer = 16;
  puzzle.variables['G']!.answer = 25;
  puzzle.variables['H']!.answer = 1;
  puzzle.variables['I']!.answer = 64;
  puzzle.variables['L']!.answer = 4;
  puzzle.variables['M']!.answer = 9;
  puzzle.variables['O']!.answer = 49;
  puzzle.variables['R']!.answer = 100;
  puzzle.variables['S']!.answer = 81;
  puzzle.variables['T']!.answer = 36;
}

class AllSquareConstraint extends PuzzleConstraint {
  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {}

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) => (true, false);

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) => (true, false);

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) => true;

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {
    var clue10 = puzzle.clues['10']!;
    var clue11 = puzzle.clues['11']!;
    var clue12 = puzzle.clues['12']!;
    // Clue 11 without clues is between clue 10 and 12
    clue11.possibleValues = clue11.possibleValues!.where((v) => v > clue10.solution! && v <= clue12.solution!).toSet();
  }
}
