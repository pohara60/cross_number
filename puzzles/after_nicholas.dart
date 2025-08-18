// ignore_for_file: unused_import

import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition afterNicholas() {
// After Nicholas by Czecker

// Nicholas Parsons chaired the panel game Just a Minute on BBC Radio for over fifty years.  After he died, the ten people in this puzzle each chaired an episode of Series 86, before Sue Perkins was chosen as the new permanent chair. Each letter used in the puzzle represents a different number from 1 to 16 and the ^ symbol denotes to the power of.  All entries are distinct, and none starts with zero.

  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :3 |4 :5 |',
    '+::+::+::+::+::+',
    '|6 :  |7 :  :  |',
    '+--+::+--+--+::+',
    '|8 :  |  |9 :  |',
    '+::+--+--+::+--+',
    '|10:11:12|13:14|',
    '+::+::+::+::+::+',
    '|15:  |16:  :  |',
    '+--+--+--+--+--+',
  ];
  final variableValues = List.generate(16, (index) => index + 1).toSet();
  return PuzzleDefinition.fromString(
    name: 'AfterNicholas',
    gridString: gridString.join('\n'),
    clues: {
      '1A': Clue('1A', [ExpressionConstraint('P*A + U*L')]),
      '4A': Clue('4A', [ExpressionConstraint('S^(U/E)')]),
      '6A': Clue('6A', [ExpressionConstraint('-N + I*S - H')]),
      '7A': Clue('7A', [ExpressionConstraint('( J + E*N ) * ( N - Y )')]),
      '8A': Clue('8A', [ExpressionConstraint('G * ( Y - L/E + S )')]),
      '9A': Clue('9A', [ExpressionConstraint('L - U + C*Y')]),
      '10A': Clue('10A', [ExpressionConstraint('S^(T/E) + P + ( H - E )*N')]),
      '13A': Clue('13A', [ExpressionConstraint('-J + U + L + I - A + N')]),
      '15A': Clue('15A', [ExpressionConstraint('T*O + M')]),
      '16A': Clue('16A', [ExpressionConstraint('J*O')]),
      '1D': Clue('1D', [ExpressionConstraint('P*A - U*L')]),
      '2D': Clue('2D', [ExpressionConstraint('( S + U ) ^E')]),
      '3D': Clue('3D', [ExpressionConstraint('N + ( I - S ) * H')]),
      '4D': Clue('4D', [ExpressionConstraint('J + E*N - N*Y')]),
      '5D': Clue('5D', [ExpressionConstraint('( G + Y )*L + E^S')]),
      '8D': Clue('8D', [ExpressionConstraint('L*U*( C - Y )')]),
      '9D': Clue('9D', [ExpressionConstraint('S*(( T/E )*P - H ) - E*N')]),
      '11D': Clue('11D', [ExpressionConstraint('J + ( U + ( L - I )/A )*N')]),
      '12D': Clue('12D', [ExpressionConstraint('T*O/M')]),
      '14D': Clue('14D', [ExpressionConstraint('J + O')]),
    },
    variables: {
      'A': Variable('A', Set.from(variableValues)),
      'C': Variable('C', Set.from(variableValues)),
      'E': Variable('E', Set.from(variableValues)),
      'G': Variable('G', Set.from(variableValues)),
      'H': Variable('H', Set.from(variableValues)),
      'I': Variable('I', Set.from(variableValues)),
      'J': Variable('J', Set.from(variableValues)),
      'L': Variable('L', Set.from(variableValues)),
      'M': Variable('M', Set.from(variableValues)),
      'N': Variable('N', Set.from(variableValues)),
      'O': Variable('O', Set.from(variableValues)),
      'P': Variable('P', Set.from(variableValues)),
      'S': Variable('S', Set.from(variableValues)),
      'T': Variable('T', Set.from(variableValues)),
      'U': Variable('U', Set.from(variableValues)),
      'Y': Variable('Y', Set.from(variableValues)),
    },
  );
}
