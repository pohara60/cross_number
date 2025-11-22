// The Listener Crossword No 4790 Die Another Day by IOA

// Some while ago, I threw a standard die (ie one where each pair of opposite
// faces has seven spots in total, pictured) and noted the number of spots on
// the top face, which I entered in the first cell of the Top grid. I also noted
// the numbers of spots on the front face and on the right-hand face, which I
// entered in the corresponding cells of the Front and Right grids. I repeated
// this exercise with the same die 15 more times in order to fill all the grids.

// In the clues W, X, Y and Z are different digits from 1 to 6.
// W occurs exactly W time(s) in the Top grid.
// X occurs exactly X time(s) in the Top grid.
// Y occurs exactly Y time(s) in the Front grid.
// Z occurs exactly Z time(s) in the Right grid.

import 'package:collection/collection.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition dieAnotherDay() {
  var gridString = [
    '+--+--+--+--+',
    '|1 :2 :3 :4 |',
    '+::+::+::+::+',
    '|5 :  :  :  |',
    '+::+::+::+::+',
    '|6 :  :  :  |',
    '+::+::+::+::+',
    '|7 :  :  :  |',
    '+--+--+--+--+',
  ];

  var puzzle = PuzzleDefinition.fromString(
    name: 'DieAnotherDay',
    mappingIsKnown: true, // No mapping of Clues to Entries needed
    gridString: gridString.join('\n'),
    gridNames: ['T', 'F', 'R'], // Top, Front, Right
    puzzleConstraints: [DieAnotherDayConstraint()],
    digitConstraint: '1,6',
    entries: {
      'T.A1': Entry(
          id: 'T.A1', constraints: [ExpressionConstraint(r"#square - Y^2")]),
      'T.A6': Entry(
          id: 'T.A6', constraints: [ExpressionConstraint(r"$multiple A")]),
      'T.A7':
          Entry(id: 'T.A7', constraints: [ExpressionConstraint(r"#square")]),
      'T.D1':
          Entry(id: 'T.D1', constraints: [ExpressionConstraint(r"$power 3")]),
      'T.D2': Entry(
          id: 'T.D2', constraints: [ExpressionConstraint(r"$multiple X*Y")]),
      'T.D3': Entry(
          id: 'T.D3', constraints: [ExpressionConstraint(r"$multiple X*Y")]),
      'F.A7':
          Entry(id: 'F.A7', constraints: [ExpressionConstraint(r"#square")]),
      'F.D1': Entry(
          id: 'F.D1', constraints: [ExpressionConstraint(r"#square + W*Y*Z")]),
      'F.D3': Entry(
          id: 'F.D3', constraints: [ExpressionConstraint(r"#sumdigits * X")]),
      'F.D4':
          Entry(id: 'F.D4', constraints: [ExpressionConstraint(r"$power 3")]),
      'R.A5':
          Entry(id: 'R.A5', constraints: [ExpressionConstraint(r"A^2 - W")]),
      'R.A7':
          Entry(id: 'R.A7', constraints: [ExpressionConstraint(r"#square")]),
      'R.D2': Entry(
          id: 'R.D2',
          constraints: [ExpressionConstraint(r"$multiple (X + Z)")]),
    },
    clues: {},
    variables: {
      'A': Variable('A', Set.from(List.generate(79, (i) => 21 + i))),
      'W': Variable('W', Set.from(List.generate(6, (i) => 1 + i))),
      'X': Variable('X', Set.from(List.generate(2, (i) => 5 + i))),
      'Y': Variable('Y', Set.from(List.generate(6, (i) => 1 + i))),
      'Z': Variable('Z', Set.from(List.generate(6, (i) => 1 + i))),
    },
  );
  setAnswers(puzzle);

  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  puzzle.variables['A']!.answer = 66;
  puzzle.variables['W']!.answer = 1;
  puzzle.variables['X']!.answer = 6;
  puzzle.variables['Y']!.answer = 4;
  puzzle.variables['Z']!.answer = 5;
  // Top Puzzle Summary
  puzzle.entries['T.A1']!.answer = 6545;
  puzzle.entries['T.A5']!.answer = 5644;
  puzzle.entries['T.A6']!.answer = 6666;
  puzzle.entries['T.A7']!.answer = 1444;
  puzzle.entries['T.D1']!.answer = 6561;
  puzzle.entries['T.D2']!.answer = 5664;
  puzzle.entries['T.D3']!.answer = 4464;
  puzzle.entries['T.D4']!.answer = 5464;
  // Front Puzzle Summary
  puzzle.entries['F.A1']!.answer = 4413;
  puzzle.entries['F.A5']!.answer = 6511;
  puzzle.entries['F.A6']!.answer = 4522;
  puzzle.entries['F.A7']!.answer = 4225;
  puzzle.entries['F.D1']!.answer = 4644;
  puzzle.entries['F.D2']!.answer = 1122;
  puzzle.entries['F.D4']!.answer = 3125;
  // Right Puzzle Summary
  puzzle.entries['R.A1']!.answer = 5156;
  puzzle.entries['R.A5']!.answer = 4355;
  puzzle.entries['R.A6']!.answer = 5344;
  puzzle.entries['R.A7']!.answer = 2116;
  puzzle.entries['R.D1']!.answer = 5452;
  puzzle.entries['R.D2']!.answer = 1331;
  puzzle.entries['R.D3']!.answer = 5541;
  puzzle.entries['R.D4']!.answer = 6546;
}

class DieAnotherDayConstraint extends PuzzleConstraint {
  // Possible dice faces in order Top, Front, Right
  final diceFaces = [
    [1, 2, 3],
    [1, 3, 5],
    [1, 5, 4],
    [1, 4, 2],
    [2, 1, 4],
    [2, 4, 6],
    [2, 6, 3],
    [2, 3, 1],
    [3, 1, 2],
    [3, 2, 6],
    [3, 6, 5],
    [3, 5, 1],
    [4, 1, 5],
    [4, 5, 6],
    [4, 6, 2],
    [4, 2, 1],
    [5, 1, 3],
    [5, 3, 6],
    [5, 6, 4],
    [5, 4, 1],
    [6, 2, 4],
    [6, 4, 5],
    [6, 5, 3],
    [6, 3, 2],
  ];

  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {}

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) =>
      (true, false);

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) {
    // Check puzzle variables W, X, Y, Z constraints
    var knownEntries = puzzle.entries.values.where((e) => e.solution != null);
    if (knownEntries.isEmpty) {
      return (true, false); // No entries known yet
    }

    var updated = false;
    Iterable<int>? topDigits;
    Iterable<int>? frontDigits;
    Iterable<int>? rightDigits;
    var topHasKnownEntries = knownEntries.any((e) => e.id.startsWith('T.'));
    if (topHasKnownEntries) {
      topDigits = puzzle.grids['T']!.getDigits();
      var (consistent, faceUpdated) =
          _enforceVariables(puzzle, topDigits, ['W', 'X'], trace);
      if (faceUpdated) updated = true;
      if (!consistent) return (false, updated);
    }
    var frontHasKnownEntries = knownEntries.any((e) => e.id.startsWith('F.'));
    if (frontHasKnownEntries) {
      frontDigits = puzzle.grids['F']!.getDigits();
      var (consistent, faceUpdated) =
          _enforceVariables(puzzle, frontDigits, ['Y'], trace);
      if (faceUpdated) updated = true;
      if (!consistent) return (false, updated);
    }
    var rightHasKnownEntries = knownEntries.any((e) => e.id.startsWith('R.'));
    if (rightHasKnownEntries) {
      rightDigits = puzzle.grids['R']!.getDigits();
      var (consistent, faceUpdated) =
          _enforceVariables(puzzle, rightDigits, ['Z'], trace);
      if (faceUpdated) updated = true;
      if (!consistent) return (false, updated);
    }

    // Check that the cells correspond to valid dice faces
    if (topHasKnownEntries && frontHasKnownEntries && rightHasKnownEntries) {
      topDigits ??= puzzle.grids['T']!.getDigits();
      frontDigits ??= puzzle.grids['F']!.getDigits();
      rightDigits ??= puzzle.grids['R']!.getDigits();
      if (!_checkFaces(topDigits, frontDigits, rightDigits)) {
        return (false, updated);
      }
    }

    return (true, updated);
  }

  (bool, bool) _enforceVariables(PuzzleDefinition puzzle, Iterable<int> digits,
      List<String> variableNames, bool trace) {
    var digitCount = <int, int>{};
    for (var digit in digits) {
      digitCount[digit] = (digitCount[digit] ?? 0) + 1;
    }
    var updated = false;
    for (var varName in variableNames) {
      var variable = puzzle.variables[varName]!;
      // Remove impossible values
      var newPossible = variable.possibleValues
          .where((v) => (digitCount[v] ?? 0) <= v)
          .toSet();
      if (newPossible.isEmpty) {
        if (trace) {
          print('DieAnotherDayConstraint: No $varName possible values');
        }
        return (false, false); // No possible values left
      }
      if (variable.possibleValues.length != newPossible.length) {
        variable.possibleValues = newPossible;
        updated = true;
        if (trace) {
          print(
              'DieAnotherDayConstraint: Updated $varName possible values ${variable.possibleValues}');
        }
      }
    }
    return (true, updated);
  }

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) {
    // Check that the cells correspond to valid dice faces
    var topDigits = puzzle.grids['T']!.getDigits();
    var frontDigits = puzzle.grids['F']!.getDigits();
    var rightDigits = puzzle.grids['R']!.getDigits();
    if (!_checkFaces(topDigits, frontDigits, rightDigits)) return false;

    // Check W, X, Y, Z constraints
    // var W = puzzle.variables['W']!.solution!;
    // var X = puzzle.variables['X']!.solution!;
    // var Y = puzzle.variables['Y']!.solution!;
    // var Z = puzzle.variables['Z']!.solution!;
    // if (W < 1 || W > 6 || X < 1 || X > 6 || Y < 1 || Y > 6 || Z < 1 || Z > 6) {
    //   return false; // W, X, Y, Z must be between 1 and 6
    // }

    var W = puzzle.variables['W']!.solution!;
    var X = puzzle.variables['X']!.solution!;
    var Y = puzzle.variables['Y']!.solution!;
    var Z = puzzle.variables['Z']!.solution!;

    if (topDigits.where((v) => v == W).length != W) {
      return false; // W does not occur exactly W times in Top grid
    }
    if (topDigits.where((v) => v == X).length != X) {
      return false; // X does not occur exactly X times in Top grid
    }
    if (frontDigits.where((v) => v == Y).length != Y) {
      return false; // Y does not occur exactly Y times in Front grid
    }
    if (rightDigits.where((v) => v == Z).length != Z) {
      return false; // Z does not occur exactly Z times in Right grid
    }

    return true;
  }

  bool _checkFaces(Iterable<int> topDigits, Iterable<int> frontDigits,
      Iterable<int> rightDigits) {
    for (final triple in IterableZip([topDigits, frontDigits, rightDigits])) {
      var topDigit = triple[0];
      var frontDigit = triple[1];
      var rightDigit = triple[2];
      if (topDigit == 0 || frontDigit == 0 || rightDigit == 0) {
        continue; // Ignore unknown cells
      }
      var validFaces = diceFaces.where((face) =>
          face[0] == topDigit &&
          face[1] == frontDigit &&
          face[2] == rightDigit);
      if (validFaces.isEmpty) {
        return false; // No valid dice face found
      }
    }
    return true;
  }

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}
