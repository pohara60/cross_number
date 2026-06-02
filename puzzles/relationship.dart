/*

A, B and C correspond to 2 digit clues. D corresponds to a 3 digit clue.
*/

// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:crossnumber/src/expressions/generators.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:powers/powers.dart';

/*
The Listener Crossword No 4922 Relationship by Elap

Each clue is an algebraic expression for the value to be entered, with the
number of digits given in brackets. The 32 letters in the clues stand for
different squares that are in the range from 4 to 2500. The clues contain only
letters, not digits; the lower-case letters are in italics for legibility. The
grid entries are all different and none of them starts with zero.

In each set of clues, the sum of the four answers is a square number and the
answers can be split into two pairs with something in common. Sorted by numeric
value, the letters from clues will give a message that cryptically describes how
to obtain an instruction (9,5,6) for the first step in establishing the
relationship between the pairs of answers. The two unclued entries must be
completed to satisfy the relationship for their sets.

*/
/*

Set 1
1ac K - I(3)
12ac O = ss - K - uu(3)
23ac L + Y + y - a(3)
1dn n + s - G(2)

Set 2
10ac S - o - o - W(2)
24ac B + B + B(2)
15dn B + s + y(2)
26dn L - a - B(2)

Set 3
21ac ss + uu(3)
2dn C + N + N(3)
17dn N + P + u(3)
23dn I + u + u + w(3)

Set 4
5dn D + S - n - n(3)
6dn e + R - i - n(3)
11dn t - K - L(2)
21dn ss + w(3)

Set 5
8dn r - B - T(3)
18dn U + u - c - t(2)
20dn c + c + T - E(3)
22dn Y - u - u(3)

Set 6
11ac U + y - l - n(3)
16ac N - u(3)
28ac a + H - L - Y(3)
3dn A + A - e - w(3)

Set 7
4ac O + W - n(3)
9ac E - A - c - w(3)
7dn Unclued
13dn s - B(2)

Set 8
14ac B + r + T - c(3)
25ac n + U - r - t(3)
27ac I + r - N - t(3)
19dn Unclued


Notes
21ac ss + uu(3), so ss, uu <1000-16=996, s,u<31 => 4,9,16, 25
24ac B + B + B(2), so B<=33, B=4,9,16,25, 24ac=12,27,48,75
22dn Y - u - u(3), so 75<=Y<=992
21dn ss + w(3), so 4<=w<=983
13dn s - B(2), 3dn=12,16,21, s=16,25, B=4,9
15dn B + s + y(2), B+s=20,29,34, 4<=y<=79, y=4,9,16,25,36,49,64
*/

PuzzleDefinition relationship() {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|1 :  :2 |3 |4 :5 :6 |7 |',
    '+::+--+::+::+--+::+::+::+',
    '|  |8 |9 :  :  |  |10:  |',
    '+--+::+::+::+--+::+::+::+',
    '|11:  :  |12:13:  |  |  |',
    '+::+::+--+--+::+--+--+--+',
    '|  |14:  :15|16:  :17|18|',
    '+--+--+--+::+--+--+::+::+',
    '|19|20|21:  :22|23:  :  |',
    '+::+::+::+--+::+::+::+--+',
    '|24:  |  |25:  :  |  |26|',
    '+::+::+::+--+::+::+--+::+',
    '|  |27:  :  |  |28:  :  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  return PuzzleDefinition.fromString(
    name: 'Relationship',
    gridString: gridString.join('\n'),
    puzzleConstraints: [RelationshipConstraint()],
    entries: {
      'A1': Entry(id: 'A1', constraints: [ExpressionConstraint('K - I')]),
      'A4': Entry(id: 'A4', constraints: [ExpressionConstraint('O + W - n')]),
      'A9': Entry(id: 'A9', constraints: [ExpressionConstraint('E - A - c - w')]),
      'A10': Entry(id: 'A10', constraints: [ExpressionConstraint('S - o - o - W')]),
      'A11': Entry(id: 'A11', constraints: [ExpressionConstraint('U + y - l - n')]),
      'A12': Entry(id: 'A12', constraints: [ExpressionConstraint('O = s*s - K - u*u')]),
      'A14': Entry(id: 'A14', constraints: [ExpressionConstraint('B + r + T - c')]),
      'A16': Entry(id: 'A16', constraints: [ExpressionConstraint('N - u')]),
      'A21': Entry(id: 'A21', constraints: [ExpressionConstraint('s*s + u*u')]),
      'A23': Entry(id: 'A23', constraints: [ExpressionConstraint('L + Y + y - a')]),
      'A24': Entry(id: 'A24', constraints: [ExpressionConstraint('B + B + B')]),
      'A25': Entry(id: 'A25', constraints: [ExpressionConstraint('n + U - r - t')]),
      'A27': Entry(id: 'A27', constraints: [ExpressionConstraint('I + r - N - t')]),
      'A28': Entry(id: 'A28', constraints: [ExpressionConstraint('a + H - L - Y')]),
      'D1': Entry(id: 'D1', constraints: [ExpressionConstraint('n + s - G')]),
      'D2': Entry(id: 'D2', constraints: [ExpressionConstraint('C + N + N')]),
      'D3': Entry(id: 'D3', constraints: [ExpressionConstraint('A + A - e - w')]),
      'D5': Entry(id: 'D5', constraints: [ExpressionConstraint('D + S - n - n')]),
      'D6': Entry(id: 'D6', constraints: [ExpressionConstraint('e + R - i - n')]),
      'D7': Entry(id: 'D7', constraints: []),
      'D8': Entry(id: 'D8', constraints: [ExpressionConstraint('r - B - T')]),
      'D11': Entry(id: 'D11', constraints: [ExpressionConstraint('t - K - L')]),
      'D13': Entry(id: 'D13', constraints: [ExpressionConstraint('s - B')]),
      'D15': Entry(id: 'D15', constraints: [ExpressionConstraint('B + s + y')]),
      'D17': Entry(id: 'D17', constraints: [ExpressionConstraint('N + P + u')]),
      'D18': Entry(id: 'D18', constraints: [ExpressionConstraint('U + u - c - t')]),
      'D19': Entry(id: 'D19', constraints: []),
      'D20': Entry(id: 'D20', constraints: [ExpressionConstraint('c + c + T - E')]),
      'D21': Entry(id: 'D21', constraints: [ExpressionConstraint('s*s + w')]),
      'D22': Entry(id: 'D22', constraints: [ExpressionConstraint('Y - u - u')]),
      'D23': Entry(id: 'D23', constraints: [ExpressionConstraint('I + u + u + w')]),
      'D26': Entry(id: 'D26', constraints: [ExpressionConstraint('L - a - B')]),
    },
    clues: {},
    variables: {
      'a': Variable('a', getVariableValues()),
      'A': Variable('A', getVariableValues()),
      'B': Variable('B', getVariableValues()),
      'c': Variable('c', getVariableValues()),
      'C': Variable('C', getVariableValues()),
      'D': Variable('D', getVariableValues()),
      'e': Variable('e', getVariableValues()),
      'E': Variable('E', getVariableValues()),
      'G': Variable('G', getVariableValues()),
      'H': Variable('H', getVariableValues()),
      'i': Variable('i', getVariableValues()),
      'I': Variable('I', getVariableValues()),
      'K': Variable('K', getVariableValues()),
      'l': Variable('l', getVariableValues()),
      'L': Variable('L', getVariableValues()),
      'n': Variable('n', getVariableValues()),
      'N': Variable('N', getVariableValues()),
      'o': Variable('o', getVariableValues()),
      'O': Variable('O', getVariableValues()),
      'P': Variable('P', getVariableValues()),
      'r': Variable('r', getVariableValues()),
      'R': Variable('R', getVariableValues()),
      's': Variable('s', getVariableValues()),
      'S': Variable('S', getVariableValues()),
      't': Variable('t', getVariableValues()),
      'T': Variable('T', getVariableValues()),
      'u': Variable('u', getVariableValues()),
      'U': Variable('U', getVariableValues()),
      'w': Variable('w', getVariableValues()),
      'W': Variable('W', getVariableValues()),
      'y': Variable('y', getVariableValues()),
      'Y': Variable('Y', getVariableValues()),
    },
  );
}

SquareGenerator? squareGenerator;
Set<int> getVariableValues() {
// get squares of length
  var min = 4;
  var max = 2500;
  squareGenerator ??= GeneratorRegistry().get('square') as SquareGenerator;
  final variableList = squareGenerator!.getValues(min, max).toSet();
  return variableList;
}

class ClueSet {
  final String name;
  final List<Entry> clues;
  ClueSet(this.name, this.clues);
}

class RelationshipConstraint extends PuzzleConstraint {
  var allClueSets = <ClueSet>[];

  void createSet(PuzzleDefinition puzzle, String name, List<String> clueNames) {
    var clues = clueNames.map<Entry>((clueName) => puzzle.entries[clueName]!).toList();
    allClueSets.add(ClueSet(name, clues));
  }

  bool checkSets() {
    // Check all sets
    for (var clueSet in allClueSets) {
      if (clueSet.clues.any((clue) => clue.isNotSolved)) {
        continue; // Skip if any clue is not yet assigned
      }
      var values = clueSet.clues.map((clue) => clue.possibleValues!.first).toList();
      var totalValue = values.reduce((a, b) => a + b);
      if (!totalValue.isSquare) {
        // Not consistent if sum is not a square
        return false;
      }
    }
    return true;
  }

  @override
  bool printSets() {
    // Print all sets
    for (var clueSet in allClueSets) {
      print('Set ${clueSet.name}:');
      for (var clue in clueSet.clues) {
        var value = clue.isSolved ? clue.possibleValues!.first : '?';
        print(
            '${clue.id}=${value.toString().padLeft(4)} ${clue.constraints.map((c) => (c as ExpressionConstraint).expression).join(', ')}');
      }
    }
    return true;
  }

  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {
    // Create sets
    createSet(puzzle, '1', ['A1', 'A12', 'A23', 'D1']);
    createSet(puzzle, '2', ['A10', 'A24', 'D15', 'D26']);
    createSet(puzzle, '3', ['A21', 'D2', 'D17', 'D23']);
    createSet(puzzle, '4', ['D5', 'D6', 'D11', 'D21']);
    createSet(puzzle, '5', ['D8', 'D18', 'D20', 'D22']);
    createSet(puzzle, '6', ['A11', 'A16', 'A28', 'D3']);
    createSet(puzzle, '7', ['A4', 'A9', 'D7', 'D13']);
    createSet(puzzle, '8', ['A14', 'A25', 'A27', 'D19']);
  }

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) => (true, false);

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) {
    // Check all sets
    if (!checkSets()) return (false, false);
    return (true, false);
  }

  @override
  var numSolutions = 0;
  var savedVariableValueStrings = <int, String>{};
  var savedEntryValueStrings = <int, String>{};
  var savedMessage = <int, String>{};
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) {
    if (!checkSets()) return false;
    // Sort variables by numeric value and check message
    var variableWithValues = puzzle.variables.values.where((v) => v.isSolved).toList();
    var sortedVariableWithValues = List.from(variableWithValues);
    sortedVariableWithValues.sort((a, b) => a.possibleValues!.first.compareTo(b.possibleValues!.first));
    var message = sortedVariableWithValues.map((v) => v.id).join();
    var variableValues = variableWithValues.map((v) => v.possibleValues!.first).toList();
    var variableValueString = variableWithValues.map((v) => '${v.id}=${v.possibleValues!.first}').join(', ');
    var entryWithValues = puzzle.entries.values.where((e) => e.isSolved && e.expressionConstraints.isNotEmpty).toList();
    var entryValues = entryWithValues.map((e) => e.possibleValues!.first).toList();
    var entryValueString = entryWithValues.map((e) => '${e.id}=${e.possibleValues!.first}').join(', ');
    // Message: By usInG WoNKY wORDS PiTCH a LAter clUE
    // If new solution, save message, variable and cell values
    var found = false;
    for (var index = 0; index < numSolutions; index++) {
      if (savedMessage[index] != message) continue;
      if (savedVariableValueStrings[index] != variableValueString) continue;
      if (savedEntryValueStrings[index] != entryValueString) continue;
      found = true;
      break;
    }
    if (!found) {
      savedMessage[numSolutions] = message;
      savedVariableValueStrings[numSolutions] = variableValueString;
      savedEntryValueStrings[numSolutions] = entryValueString;
      numSolutions++;

      // Print solution
      print('Solution: $numSolutions');
      print('Message: $message');
      print('Variables: $variableValueString');
      print('Entries: $entryValueString');
      printSets();
    }

    return true;
  }

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}
