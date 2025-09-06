// ignore_for_file: unused_import

import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

// Thirty by Czecker

// Every digit is even and there are fifteen pairs of even digits, from {0,0}, {0,2} up to {8,8}.  For this purpose, {p,q} is the same as {q,p}.  Each of the fifteen pairs fills one of the matching cells of the two grids, one in each grid.  All entries are distinct, and none starts with zero.

// The sum of the digits in the first grid equals the sum of the digits in the second grid.
// No entry is a jumble of another entry.

// Puzzle Left
// 86624
// 06800
// 26624
// Puzzle Right
// 82644
// 24480
// 20880

PuzzleDefinition thirty() {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :  |3 :4 |',
    '+::+::+--+::+::+',
    '|  |5 :6 :  |  |',
    '+::+::+::+::+::+',
    '|7 :  |8 :  :  |',
    '+--+--+--+--+--+',
  ];
  return PuzzleDefinition.fromString(
    name: 'Puzzle3',
    gridString: gridString.join('\n'),
    gridNames: ['L', 'R'], // Left, Right
    entries: {
      'L.A1': Entry(
          id: 'L.A1', constraints: [ExpressionConstraint('L.A1 = R.D1+R.A3')]),
      'L.A8': Entry(
          id: 'L.A8', constraints: [ExpressionConstraint('L.A8 = L.A2+L.A&')]),
      'R.A1': Entry(
          id: 'R.A1', constraints: [ExpressionConstraint('R.A1 = L.D1+L.A3')]),
      'R.A8': Entry(
          id: 'R.A8', constraints: [ExpressionConstraint('R.A8 = R.A2+R.A&')]),
    },
    clues: {},
    variables: {},
  );
}
