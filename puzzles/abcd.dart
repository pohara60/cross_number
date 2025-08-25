/*

A, B and C correspond to 2 digit clues. D corresponds to a 3 digit clue.
*/

// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:math';

import 'package:crossnumber/src/expressions/generators.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition abcd() {
  // ABCD by Nod

  // A, B, C and D are four primes such that D > C > B > A. The normal rules of
  // algebra apply, all entries are distinct and no entry starts with zero.

  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 :  :3 |4 :5 |',
    '+::+::+--+::+::+::+',
    '|6 :  |7 :  :  :  |',
    '+::+--+::+--+--+::+',
    '|  |8 :  :9 |10:  |',
    '+--+::+::+::+::+--+',
    '|11:  |12:  :  |13|',
    '+::+--+--+::+--+::+',
    '|14:15:16:  |17:  |',
    '+::+::+::+--+::+::+',
    '|18:  |19:  :  :  |',
    '+--+--+--+--+--+--+',
  ];

  return PuzzleDefinition.fromString(
    name: 'ABCD',
    gridString: gridString.join('\n'),
    entries: {
      'A1': Entry(id: 'A1', constraints: [ExpressionConstraint(r'A*C+C*D')]),
      'A4': Entry(id: 'A4', constraints: [ExpressionConstraint(r'A+A+A')]),
      'A6': Entry(id: 'A6', constraints: [ExpressionConstraint(r'A')]),
      'A7': Entry(id: 'A7', constraints: [ExpressionConstraint(r'B+A*D')]),
      'A8': Entry(id: 'A8', constraints: [ExpressionConstraint(r'A*B-D')]),
      'A10': Entry(id: 'A10', constraints: [ExpressionConstraint(r'A+A')]),
      'A11': Entry(id: 'A11', constraints: [ExpressionConstraint(r'C')]),
      'A12': Entry(id: 'A12', constraints: [ExpressionConstraint(r'B*C+D')]),
      'A14': Entry(id: 'A14', constraints: [ExpressionConstraint(r'A*D-B*C')]),
      'A17': Entry(id: 'A17', constraints: [ExpressionConstraint(r'A+C-B')]),
      'A18': Entry(id: 'A18', constraints: [ExpressionConstraint(r'B')]),
      'A19': Entry(id: 'A19', constraints: [ExpressionConstraint(r'A*D-A*B')]),
      'D1': Entry(id: 'D1', constraints: [ExpressionConstraint(r'B+A*C')]),
      'D2': Entry(id: 'D2', constraints: [ExpressionConstraint(r'B+B+B')]),
      'D3': Entry(id: 'D3', constraints: [ExpressionConstraint(r'A+C')]),
      'D4': Entry(id: 'D4', constraints: [ExpressionConstraint(r'A+B+C')]),
      'D5': Entry(id: 'D5', constraints: [ExpressionConstraint(r'D-A')]),
      'D7': Entry(id: 'D7', constraints: [ExpressionConstraint(r'A*B+C')]),
      'D8': Entry(id: 'D8', constraints: [ExpressionConstraint(r'A+B-C')]),
      'D9': Entry(id: 'D9', constraints: [ExpressionConstraint(r'A*C-D')]),
      'D10': Entry(id: 'D10', constraints: [ExpressionConstraint(r'B+B')]),
      'D11': Entry(id: 'D11', constraints: [ExpressionConstraint(r'A+C+D')]),
      'D13': Entry(id: 'D13', constraints: [ExpressionConstraint(r'A*B+A*C')]),
      'D15': Entry(id: 'D15', constraints: [ExpressionConstraint(r'C+C+C')]),
      'D16': Entry(id: 'D16', constraints: [ExpressionConstraint(r'B+C')]),
      'D17': Entry(id: 'D17', constraints: [ExpressionConstraint(r'B+C-A')]),
    },
    clues: {},
    variables: {
      'A': Variable('A', getVariableValues(2)),
      'B': Variable('B', getVariableValues(2)),
      'C': Variable('C', getVariableValues(2)),
      'D': Variable('D', getVariableValues(3)),
    },
  );
}

PrimeGenerator? primeGenerator;
Set<int> getVariableValues(int length) {
// get primes of length
  var min = pow(10, length - 1).toInt();
  var max = pow(10, length).toInt() - 1;
  primeGenerator ??= GeneratorRegistry().get('prime') as PrimeGenerator;
  final variableList = primeGenerator!.getValues(min, max).toSet();
  return variableList;
}

/*
Grid:
+---+---+---+---+---+---+
| 4   5   5   4 | 5   1 |
+   +   +---+   +   +   +
| 1   7 | 3   0   9   6 |
+   +---+   +---+---+   +
| 0 | 1   4   2 | 3   4 |
+---+   +   +   +   +---+
| 2   3 | 6   1   8 | 7 |
+   +---+---+   +---+   +
| 2   6   4   0 | 2   1 |
+   +   +   +---+   +   +
| 1   9 | 2   7   5   4 |
+---+---+---+---+---+---+
Variables:
A: 1 {17}
B: 1 {19}
C: 1 {23}
D: 1 {181}
Clues:
Entries:
A1: 1  {4554}
A4: 1  {51}
A6: 1  {17}
A7: 1  {3096}
A8: 1  {142}
A10: 1  {34}
A11: 1  {23}
A12: 1  {618}
A14: 1  {2640}
A17: 1  {21}
A18: 1  {19}
A19: 1  {2754}
D1: 1  {410}
D2: 1  {57}
D3: 1  {40}
D4: 1  {59}
D5: 1  {164}
D7: 1  {346}
D8: 1  {13}
D9: 1  {210}
D10: 1  {38}
D11: 1  {221}
D13: 1  {714}
D15: 1  {69}
D16: 1  {42}
D17: 1  {25}
*/
