// Mathematical Inspiration by Zag

// Solving the puzzle still leaves 4dn in doubt. Reading left to right from top
// to bottom the sequence of 21 digits should be translated into letters using
// the correspondence A=1, B=2, …, Z=26. The result provides a two-part answer
// to the title thereby removing all doubt as to the entry at 4dn. No entry
// starts with zero and entries are distinct.

import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';

PuzzleDefinition mathematicalInspiration() {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :2 :3 |4 |5 |6 :7 |',
    '+::+::+::+::+::+--+::+',
    '|  |  |8 :  :  |9 |  |',
    '+::+--+::+::+::+::+::+',
    '|10:  |  |  |11:  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  var puzzle = PuzzleDefinition.fromString(
    name: 'MathematicalInspiration',
    mappingIsKnown: true, // No mapping of Clues to Entries needed
    gridString: gridString.join('\n'),
    puzzleConstraints: [MathematicalInspirationConstraint()],
    entries: {
      'A1':
          Entry(id: 'A1', constraints: [ExpressionConstraint(r"A6 + D2 + D9")]),
      'A6': Entry(id: 'A6', constraints: [ExpressionConstraint(r"#harshad")]),
      'A8':
          Entry(id: 'A8', constraints: [ExpressionConstraint(r"#palindrome")]),
      'A10': Entry(id: 'A10'),
      'A11':
          Entry(id: 'A11', constraints: [ExpressionConstraint(r"$jumble A1")]),
      'D1': Entry(
          id: 'D1', constraints: [ExpressionConstraint(r"#triangular + D2")]),
      'D2': Entry(
          id: 'D2',
          constraints: [ExpressionConstraint(r"A10 + $digitproduct A10")]),
      'D3':
          Entry(id: 'D3', constraints: [ExpressionConstraint(r"#triangular")]),
      'D4': Entry(id: 'D4', constraints: [ExpressionConstraint(r"$jumble D7")]),
      'D5': Entry(
          id: 'D5',
          constraints: [ExpressionConstraint(r"$square $digitsum A11")]),
      'D7': Entry(id: 'D7', constraints: [ExpressionConstraint(r"D2 + D5")]),
      'D9':
          Entry(id: 'D9', constraints: [ExpressionConstraint(r"#square + A6")]),
    },
    clues: {},
    variables: {},
  );
  setAnswers(puzzle);

  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  puzzle.entries['A1']!.answer = 191;
  puzzle.entries['A6']!.answer = 42;
  puzzle.entries['A8']!.answer = 212;
  puzzle.entries['A10']!.answer = 82;
  puzzle.entries['A11']!.answer = 119;
  puzzle.entries['D1']!.answer = 108;
  puzzle.entries['D2']!.answer = 98;
  puzzle.entries['D3']!.answer = 120;
  puzzle.entries['D4']!.answer = 912;
  puzzle.entries['D5']!.answer = 121;
  puzzle.entries['D7']!.answer = 219;
  puzzle.entries['D9']!.answer = 51;
}

class MathematicalInspirationConstraint extends PuzzleConstraint {
  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {}

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) =>
      (true, false);

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) =>
      (true, false);

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) {
    var digits = puzzle.grids.values.first.getDigits();
    var sequence = digits.join();
    // 191914208212518202119 is correct
    // S AIN T HU BER T U S
    if (sequence != '191914208212518202119') {
      if (trace) {
        print(
            'MathematicalInspirationConstraint: Sequence $sequence is not correct');
      }
      return false;
    }
    return true;
  }
}
