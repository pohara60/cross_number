// ignore_for_file: unused_import

import 'dart:collection';

import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition threes() {
// The Listener Crossword No 4882 Threes by Elap

  /// Clues are given in ascending order of their answers and consist of a normal algebraic expression for the answer. The 27 letters in the clues stand for the last one, two or three digits of a four-digit square of a number divisible by three; the values are all distinct and greater than zero. The grid entries are all distinct and none starts with a zero.

  /// The 33 three-digit entries (including the unclued 15ac and 18ac) can be ordered to form a sequence in which each term after the first is derived from the previous one using a rule that is to be discovered. Using a method related to the title, a message about the rule can be extracted from the clue letters when sorted by ascending numeric value. Solvers must write below the grid the sum of all 33 terms and the sum of the letter values, each expressed in a three-digit form that relates to the rule for the sequence, and highlight the grid entry that is the first term of the sequence.

  var gridString = [
    '+--+--+--+--+--+--+--+--+--+',
    '|1 :2 :  |3 |4 :  :5 |6 :7 |',
    '+::+::+--+::+::+--+::+--+::+',
    '|  |8 :  :  |9 :10:  |11|  |',
    '+::+::+--+::+::+::+::+::+::+',
    '|12:  :  |13:  :  |14:  :  |',
    '+--+--+--+--+--+::+--+::+--+',
    '|15:16:  |17:  :  |18:  :  |',
    '+--+::+--+::+--+--+--+--+--+',
    '|19:  :20|21:22:23|24:25:26|',
    '+::+::+::+::+::+::+--+::+::+',
    '|  |  |27:  :  |28:  :  |  |',
    '+::+--+::+--+::+::+--+::+::+',
    '|29:  |30:  :  |  |31:  :  |',
    '+--+--+--+--+--+--+--+--+--+',
  ];
  final variableValues = getVariableValues();
  return PuzzleDefinition.fromString(
    name: 'Threes',
    gridString: gridString.join('\n'),
    entries: {
      'A29': Entry(id: 'A29', constraints: [ExpressionConstraint('I+I+I')]),
      'A6': Entry(id: 'A6', constraints: [ExpressionConstraint('h*h*h')]),
      'A19': Entry(id: 'A19', constraints: [ExpressionConstraint('h*h+I*I+a')]),
      'D16': Entry(id: 'D16', constraints: [ExpressionConstraint('i*n-R')]),
      'A28': Entry(id: 'A28', constraints: [ExpressionConstraint('i*n+L')]),
      'D19': Entry(id: 'D19', constraints: [ExpressionConstraint('C+I+N')]),
      'A24': Entry(id: 'A24', constraints: [ExpressionConstraint('r-e-h')]),
      'D23': Entry(id: 'D23', constraints: [ExpressionConstraint('O+o+s')]),
      'D10': Entry(id: 'D10', constraints: [ExpressionConstraint('a*a*a+a*I')]),
      'D2': Entry(id: 'D2', constraints: [ExpressionConstraint('m-L')]),
      'A17': Entry(id: 'A17', constraints: [ExpressionConstraint('a*a*a+C')]),
      'A31': Entry(id: 'A31', constraints: [ExpressionConstraint('a*t-T')]),
      'A9': Entry(id: 'A9', constraints: [ExpressionConstraint('h*h*I+u')]),
      'D20': Entry(id: 'D20', constraints: [ExpressionConstraint('U-L')]),
      'A27': Entry(id: 'A27', constraints: [ExpressionConstraint('i+p+s+s')]),
      'D17': Entry(id: 'D17', constraints: [ExpressionConstraint('R*t-f')]),
      'D7': Entry(id: 'D7', constraints: [ExpressionConstraint('i*i+n*R')]),
      'D4': Entry(id: 'D4', constraints: [ExpressionConstraint('c+c+h')]),
      'A12': Entry(id: 'A12', constraints: [ExpressionConstraint('i*N+a')]),
      'A4': Entry(id: 'A4', constraints: [ExpressionConstraint('F+N+N+u')]),
      'D22': Entry(id: 'D22', constraints: [ExpressionConstraint('a+y')]),
      'A30': Entry(id: 'A30', constraints: [ExpressionConstraint('L+n+y')]),
      'D26': Entry(id: 'D26', constraints: [ExpressionConstraint('n+S+y')]),
      'D11': Entry(id: 'D11', constraints: [ExpressionConstraint('a*O+h*O')]),
      'A14': Entry(id: 'A14', constraints: [ExpressionConstraint('a*L+b')]),
      'A21': Entry(id: 'A21', constraints: [ExpressionConstraint('f+o+o-s')]),
      'A13': Entry(id: 'A13', constraints: [ExpressionConstraint('a+b+F+F')]),
      'A8': Entry(id: 'A8', constraints: [ExpressionConstraint('I*I*I+L+L')]),
      'A1': Entry(id: 'A1', constraints: [ExpressionConstraint('b+i+i+p')]),
      'D1': Entry(id: 'D1', constraints: [ExpressionConstraint('E+u-T')]),
      'D5': Entry(id: 'D5', constraints: [ExpressionConstraint('L*L+L*L+h')]),
      'D3': Entry(id: 'D3', constraints: [ExpressionConstraint('h*h*S+L')]),
      'D25': Entry(id: 'D25', constraints: [ExpressionConstraint('a*r-a*f')]),
    },
    clues: {},
    variables: {
      'a': Variable('a', Set.from(variableValues)),
      'b': Variable('b', Set.from(variableValues)),
      'c': Variable('c', Set.from(variableValues)),
      'C': Variable('C', Set.from(variableValues)),
      'e': Variable('e', Set.from(variableValues)),
      'E': Variable('E', Set.from(variableValues)),
      'f': Variable('f', Set.from(variableValues)),
      'F': Variable('F', Set.from(variableValues)),
      'h': Variable('h', Set.from(variableValues)),
      'i': Variable('i', Set.from(variableValues)),
      'I': Variable('I', Set.from(variableValues)),
      'L': Variable('L', Set.from(variableValues)),
      'm': Variable('m', Set.from(variableValues)),
      'n': Variable('n', Set.from(variableValues)),
      'N': Variable('N', Set.from(variableValues)),
      'o': Variable('o', Set.from(variableValues)),
      'O': Variable('O', Set.from(variableValues)),
      'p': Variable('p', Set.from(variableValues)),
      'r': Variable('r', Set.from(variableValues)),
      'R': Variable('R', Set.from(variableValues)),
      's': Variable('s', Set.from(variableValues)),
      'S': Variable('S', Set.from(variableValues)),
      't': Variable('t', Set.from(variableValues)),
      'T': Variable('T', Set.from(variableValues)),
      'u': Variable('u', Set.from(variableValues)),
      'U': Variable('U', Set.from(variableValues)),
      'y': Variable('y', Set.from(variableValues)),
    },
  );
}

List<int> getVariableValues() {
// The 27 letters in the clues stand for the last one, two or three digits of a
// four-digit square of a number divisible by three
  final min = 1000;
  final max = 9999;
  final squares = <int>[];
  for (var i = 32; i * i <= max; i++) {
    if (i % 3 == 0) {
      final square = i * i;
      if (square >= min && square <= max) {
        squares.add(square);
      }
    }
  }
  final variableValues = <int>{};
  for (var square in squares) {
    variableValues.add(square % 1000);
    variableValues.add(square % 100);
    variableValues.add(square % 10);
  }
  variableValues.remove(0);
  var variableList = variableValues.toList();
  variableList.sort();
  return variableList;
}


/*
Grid:
+---+---+---+---+---+---+---+---+---+
| 8   2   8 | 9 | 4   5   8 | 6   4 |
+   +   +---+   +   +---+   +---+   +
| 8 | 7   7   1 | 3   2   8 | 6 | 2 |
+   +   +---+   +   +   +   +   +   +
| 4   5   1 | 7   6   7 | 6   9   5 |
+---+---+---+---+---+   +---+   +---+
| ?   1   ? | 3   0   0 | ?   0   ? |
+---+   +---+   +---+---+---+---+---+
| 1   0   3 | 7   5   2 | 1   9   6 |
+   +   +   +   +   +   +---+   +   +
| 8 | 9 | 3   5   2 | 1   4   6 | 0 |
+   +---+   +---+   +   +---+   +   +
| 2   7 | 5   6   7 | 8 | 3   0   2 |
+---+---+---+---+---+---+---+---+---+
Variables:
a: 6
b: 569
c: 216
C: 84
e: 561
E: 764
f: 601
F: 96
h: 4
i: 5
I: 9
L: 21
m: 296
n: 25
N: 89
o: 100
O: 69
p: 249
r: 761
R: 16
s: 49
S: 56
t: 61
T: 64
u: 184
U: 356
y: 521
Clues:
Entries:
A29: 27
A6: 64
A19: 103
D16: 109
A28: 146
D19: 182
A24: 196
D23: 218
D10: 270
D2: 275
A17: 300
A31: 302
A9: 328
D20: 335
A27: 352
D17: 375
D7: 425
D4: 436
A12: 451
A4: 458
D22: 527
A30: 567
D26: 602
D11: 690
A14: 695
A21: 752
A13: 767
A8: 771
A1: 828
D1: 884
D5: 886
D3: 917
D25: 960

Ordered variables by value:
h	i	a	I	R	L	n	s	S	t	T	O	C	N	F	o	u	c	p	m	U	y	e	b	f	r	E

Every third variable:
h	I	n	t	C	o	p	y	f i	R	s	T	N	u	m	e	r a	L	S	O	F	c	U	b	E

Three digit values in sequence
Val	Left(Cube,3)
302	275
275	207
207	886 A18
886	695
695	335
335	375
375	527
527	146
146	311
311	300 A15
300	270
270	196
196	752
752	425
425	767
767	451
451	917
917	771
771	458
458	960
960	884
884	690
690	328
328	352
352	436
436	828
828	567
567	182
182	602
602	218
218	103
103	109
109	129


*/