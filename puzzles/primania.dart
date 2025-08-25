/*
Primania by Arden

The prime factors of each of the numbers given below must be found. Each value is the product of a 2-digit prime and a 3-digit prime. The factors must be used as the down entries in the diagram. Across entries are prime both forwards and backwards. All entries are distinct.



Clues
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

PuzzleDefinition primania() {
  // ABCD by Nod

  // A, B, C and D are four primes such that D > C > B > A. The normal rules of
  // algebra apply, all entries are distinct and no entry starts with zero.

  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '+1 :2 :3 :4 |5 |6 :7 :8 +',
    '+::+::+::+::+::+::+::+::+',
    '+9 :  |10:  :  :  |  |  +',
    '+::+--+::+--+::+--+::+--+',
    '+11:12:  |13|  |14:  :15+',
    '+--+::+--+::+--+::+--+::+',
    '+16|  |17:  :18:  |19:  +',
    '+::+::+::+::+::+::+::+::+',
    '+20:  :  |  |21:  :  :  +',
    '+--+--+--+--+--+--+--+--+',
  ];

  return PuzzleDefinition.fromString(
    name: 'Primania',
    gridString: gridString.join('\n'),
    entries: {
      'A1': Entry(id: 'A1', constraints: [
        ExpressionConstraint(r'$prime A1 & $prime $reverse A1')
      ]),
      'A6': Entry(id: 'A6', constraints: [
        ExpressionConstraint(r'$prime A6 & $prime $reverse A6')
      ]),
      'A9': Entry(id: 'A9', constraints: [
        ExpressionConstraint(r'$prime A9 & $prime $reverse A9')
      ]),
      'A10': Entry(id: 'A10', constraints: [
        ExpressionConstraint(r'$prime A10 & $prime $reverse A10')
      ]),
      'A11': Entry(id: 'A11', constraints: [
        ExpressionConstraint(r'$prime A11 & $prime $reverse A11')
      ]),
      'A14': Entry(id: 'A14', constraints: [
        ExpressionConstraint(r'$prime A14 & $prime $reverse A14')
      ]),
      'A17': Entry(id: 'A17', constraints: [
        ExpressionConstraint(r'$prime A17 & $prime $reverse A17')
      ]),
      'A19': Entry(id: 'A19', constraints: [
        ExpressionConstraint(r'$prime A19 & $prime $reverse A19')
      ]),
      'A20': Entry(id: 'A20', constraints: [
        ExpressionConstraint(r'$prime A20 & $prime $reverse A20')
      ]),
      'A21': Entry(id: 'A21', constraints: [
        ExpressionConstraint(r'$prime A21 & $prime $reverse A21')
      ]),
    },
    clues: {
      '1': Clue('1', [ExpressionConstraint(r'$firstfactor 10109')]),
      '2': Clue('2', [ExpressionConstraint(r'$secondfactor 10109')]),
      '3': Clue('3', [ExpressionConstraint(r'$firstfactor 14687')]),
      '4': Clue('4', [ExpressionConstraint(r'$secondfactor 14687')]),
      '5': Clue('5', [ExpressionConstraint(r'$firstfactor 15479')]),
      '6': Clue('6', [ExpressionConstraint(r'$secondfactor 15479')]),
      '7': Clue('7', [ExpressionConstraint(r'$firstfactor 22681')]),
      '8': Clue('8', [ExpressionConstraint(r'$secondfactor 22681')]),
      '9': Clue('9', [ExpressionConstraint(r'$firstfactor 24067')]),
      '10': Clue('10', [ExpressionConstraint(r'$secondfactor 24067')]),
      '11': Clue('11', [ExpressionConstraint(r'$firstfactor 25043')]),
      '12': Clue('12', [ExpressionConstraint(r'$secondfactor 25043')]),
      '13': Clue('13', [ExpressionConstraint(r'$firstfactor 30167')]),
      '14': Clue('14', [ExpressionConstraint(r'$secondfactor 30167')]),
      '15': Clue('15', [ExpressionConstraint(r'$firstfactor 38179')]),
      '16': Clue('16', [ExpressionConstraint(r'$secondfactor 38179')]),
    },
    variables: {},
  );
}
