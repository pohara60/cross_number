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
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition sumsquares() {
  // A2 + B2 + C2 by Nod

  // Letters in the clues stand for the first fourteen prime numbers in an order to be determined with the same letter representing the same prime throughout. The clue PQR is evaluated as P2+Q2+R2 to give the value of the entry. No entry starts with zero and all entries are distinct. Clues are given in ascending order of their entries, i-xxvii and must be entered where they fit.

  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :  :2 |3 :4 :5 |6 |',
    '+::+--+::+::+::+::+::+',
    '|7 :  :  :  |8 :  :  |',
    '+::+--+::+::+::+--+::+',
    '|9 :10:  |11:  :12:  |',
    '+::+::+::+--+--+::+--+',
    '|  |  |13:  :14|  |15|',
    '+--+::+--+--+::+::+::+',
    '|16:  :17:18|19:  :  |',
    '+::+--+::+::+::+--+::+',
    '|20:21:  |22:  :  :  |',
    '+::+::+::+::+::+--+::+',
    '|  |23:  :  |24:  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  const first14primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43];

  final puzzle = PuzzleDefinition.fromString(
    name: 'SumSquares',
    mappingIsKnown: false,
    gridString: gridString.join('\n'),
    entries: {},
    clues: {
      // Clues are in value order
      'i': Clue('i', [ExpressionConstraint(r'D*D+I*I+M*M')], length: 2),
      'ii': Clue('ii', [ExpressionConstraint(r'A*A+I*I+M*M')], length: 2),
      'iii': Clue('iii', [ExpressionConstraint(r'A*A+D*D+N*N')], length: 3),
      'iv': Clue('iv', [ExpressionConstraint(r'B*B+I*I+M*M')], length: 3),
      'v': Clue('v', [ExpressionConstraint(r'B*B+D*D+N*N')], length: 3),
      'vi': Clue('vi', [ExpressionConstraint(r'D*D+I*I+K*K')], length: 3),
      'vii': Clue('vii', [ExpressionConstraint(r'B*B+M*M+N*N')], length: 3),
      'viii': Clue('viii', [ExpressionConstraint(r'A*A+B*B+N*N')], length: 3),
      'ix': Clue('ix', [ExpressionConstraint(r'B*B+D*D+K*K')], length: 3),
      'x': Clue('x', [ExpressionConstraint(r'D*D+E*E+N*N')], length: 3),
      'xi': Clue('xi', [ExpressionConstraint(r'A*A+G*G+I*I')], length: 3),
      'xii': Clue('xii', [ExpressionConstraint(r'A*A+D*D+G*G')], length: 3),
      'xiii': Clue('xiii', [ExpressionConstraint(r'A*A+G*G+M*M')], length: 3),
      'xiv': Clue('xiv', [ExpressionConstraint(r'B*B+E*E+N*N')], length: 3),
      'xv': Clue('xv', [ExpressionConstraint(r'G*G+I*I+N*N')], length: 3),
      'xvi': Clue('xvi', [ExpressionConstraint(r'A*A+D*D+J*J')], length: 3),
      'xvii': Clue('xvii', [ExpressionConstraint(r'G*G+K*K+N*N')], length: 3),
      'xviii': Clue('xviii', [ExpressionConstraint(r'D*D+I*I+L*L')], length: 3),
      'xix': Clue('xix', [ExpressionConstraint(r'I*I+L*L+M*M')], length: 3),
      'xx': Clue('xx', [ExpressionConstraint(r'F*F+I*I+N*N')], length: 4),
      'xxi': Clue('xxi', [ExpressionConstraint(r'A*A+H*H+M*M')], length: 4),
      'xxii': Clue('xxii', [ExpressionConstraint(r'E*E+H*H+N*N')], length: 4),
      'xxiii': Clue('xxiii', [ExpressionConstraint(r'F*F+L*L+M*M')], length: 4),
      'xxiv': Clue('xxiv', [ExpressionConstraint(r'C*C+I*I+L*L')], length: 4),
      'xxv': Clue('xxv', [ExpressionConstraint(r'F*F+H*H+N*N')], length: 4),
      'xxvi': Clue('xxvi', [ExpressionConstraint(r'C*C+J*J+L*L')], length: 4),
      'xxvii': Clue('xxvii', [ExpressionConstraint(r'C*C+D*D+H*H')], length: 4),
    },
    variables: {
      'A': Variable('A', Set.from(first14primes)),
      'B': Variable('B', Set.from(first14primes)),
      'C': Variable('C', Set.from(first14primes)),
      'D': Variable('D', Set.from(first14primes)),
      'E': Variable('E', Set.from(first14primes)),
      'F': Variable('F', Set.from(first14primes)),
      'G': Variable('G', Set.from(first14primes)),
      'H': Variable('H', Set.from(first14primes)),
      'I': Variable('I', Set.from(first14primes)),
      'J': Variable('J', Set.from(first14primes)),
      'K': Variable('K', Set.from(first14primes)),
      'L': Variable('L', Set.from(first14primes)),
      'M': Variable('M', Set.from(first14primes)),
      'N': Variable('N', Set.from(first14primes)),
    },
    orderingConstraints: [OrderingConstraint(allClues: true)],
  );
  setAnswers(puzzle);
  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  puzzle.clues['i']!.answer = 38;
  puzzle.clues['ii']!.answer = 78;
  puzzle.clues['iii']!.answer = 179;
  puzzle.clues['iv']!.answer = 198;
  puzzle.clues['v']!.answer = 299;
  puzzle.clues['vi']!.answer = 302;
  puzzle.clues['vii']!.answer = 315;
  puzzle.clues['viii']!.answer = 339;
  puzzle.clues['ix']!.answer = 467;
  puzzle.clues['x']!.answer = 491;
  puzzle.clues['xi']!.answer = 582;
  puzzle.clues['xii']!.answer = 587;
  puzzle.clues['xiii']!.answer = 603;
  puzzle.clues['xiv']!.answer = 651;
  puzzle.clues['xv']!.answer = 654;
  puzzle.clues['xvi']!.answer = 899;
  puzzle.clues['xvii']!.answer = 939;
  puzzle.clues['xviii']!.answer = 974;
  puzzle.clues['xix']!.answer = 990;
  puzzle.clues['xx']!.answer = 1494;
  puzzle.clues['xxi']!.answer = 1923;
  puzzle.clues['xxii']!.answer = 2331;
  puzzle.clues['xxiii']!.answer = 2355;
  puzzle.clues['xxiv']!.answer = 2646;
  puzzle.clues['xxv']!.answer = 3339;
  puzzle.clues['xxvi']!.answer = 3483;
  puzzle.clues['xxvii']!.answer = 3539;
  puzzle.entries['A1']!.answer = 302;
  puzzle.entries['D1']!.answer = 3339;
  puzzle.entries['D2']!.answer = 2355;
  puzzle.entries['A3']!.answer = 467;
  puzzle.entries['D3']!.answer = 491;
  puzzle.entries['D4']!.answer = 654;
  puzzle.entries['D5']!.answer = 78;
  puzzle.entries['D6']!.answer = 974;
  puzzle.entries['A7']!.answer = 3539;
  puzzle.entries['A8']!.answer = 587;
  puzzle.entries['A9']!.answer = 315;
  puzzle.entries['D10']!.answer = 179;
  puzzle.entries['A11']!.answer = 1494;
  puzzle.entries['D12']!.answer = 990;
  puzzle.entries['A13']!.answer = 582;
  puzzle.entries['D14']!.answer = 2646;
  puzzle.entries['D15']!.answer = 2331;
  puzzle.entries['A16']!.answer = 1923;
  puzzle.entries['D16']!.answer = 198;
  puzzle.entries['D17']!.answer = 299;
  puzzle.entries['D18']!.answer = 339;
  puzzle.entries['A19']!.answer = 603;
  puzzle.entries['A20']!.answer = 939;
  puzzle.entries['D21']!.answer = 38;
  puzzle.entries['A22']!.answer = 3483;
  puzzle.entries['A23']!.answer = 899;
  puzzle.entries['A24']!.answer = 651;
  puzzle.variables['A']!.answer = 7;
  puzzle.variables['B']!.answer = 13;
  puzzle.variables['C']!.answer = 41;
  puzzle.variables['D']!.answer = 3;
  puzzle.variables['E']!.answer = 19;
  puzzle.variables['F']!.answer = 37;
  puzzle.variables['G']!.answer = 23;
  puzzle.variables['H']!.answer = 43;
  puzzle.variables['I']!.answer = 2;
  puzzle.variables['J']!.answer = 29;
  puzzle.variables['K']!.answer = 17;
  puzzle.variables['L']!.answer = 31;
  puzzle.variables['M']!.answer = 5;
  puzzle.variables['N']!.answer = 11;
}
