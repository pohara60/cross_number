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
    puzzleConstraints: [DieAnotherDayConstraint()],
  );
  setAnswers(puzzle);

  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  // puzzle.entries['A1']!.answer = 84;
}

class DieAnotherDayConstraint extends PuzzleConstraint {
  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {}

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) =>
      (true, false);

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) =>
      (true, false);

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) => true;
}
