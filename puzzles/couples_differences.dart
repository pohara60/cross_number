// ignore_for_file: unused_import

import 'package:collection/collection.dart';
import 'package:crossnumber/src/expressions/monadic.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/ordering_constraint.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:crossnumber/src/utils/set.dart';

class CouplesDifferencesConstraint extends PuzzleConstraint {
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
    // Get sum of digits
    final sum = puzzle.grids.values.first.getDigitsSum()!;
    final valid = sum % 99 == 0;
    print('Solution grid sum digits $sum, valid is $valid');
    return valid;
  }

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}

PuzzleDefinition couplesDifferences() {
// Couples Differences by Moog
// Each clue refers to an across entry and a down entry, which are reverses of one another with the larger number first. The clue answer is the difference of the two entries with the number in brackets referring to the entry length. There are no leading zeros and all answers and entries are distinct. The solution that solvers require is the one in which the sum of the entered digits could be a clue answer in this puzzle.

  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :  |2 :3 :  |4 |',
    '+::+--+::+::+--+::+',
    '|5 :6 |7 :  :8 :  |',
    '+::+::+::+--+::+--+',
    '|  |  |9 :10:  :  |',
    '+--+::+::+::+::+--+',
    '|11:  :  :  |  |12|',
    '+--+::+--+::+::+::+',
    '|13:  :14:  |15:  |',
    '+::+--+::+::+--+::+',
    '|  |16:  :  |17:  |',
    '+--+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  final MonadicFunctionRegistry monadicFunctionRegistry =
      MonadicFunctionRegistry();
  monadicFunctionRegistry.registerFunction(
      'isDivisibleNine',
      (values, {int? min, int? max}) =>
          values.where((v) => v % 9 == 0).toList());

  var puzzle = PuzzleDefinition.fromString(
    name: 'CouplesDifferences',
    mappingIsKnown: true, // No mapping of Clues to Entries needed
    gridString: gridString.join('\n'),
    entries: {
      'A1': Entry(
          id: 'A1', constraints: [ExpressionConstraint(r"A1>D4 & A1 = 'D4")]),
      'A2': Entry(
          id: 'A2', constraints: [ExpressionConstraint(r"A2<D1 & A2 = 'D1")]),
      'A5': Entry(
          id: 'A5', constraints: [ExpressionConstraint(r"A5>D14 & A5 = 'D14")]),
      'A7': Entry(
          id: 'A7', constraints: [ExpressionConstraint(r"A7<D10 & A7 = 'D10")]),
      'A9': Entry(
          id: 'A9', constraints: [ExpressionConstraint(r"A9>D6 & A9 = 'D6")]),
      'A13': Entry(
          id: 'A13',
          constraints: [ExpressionConstraint(r"A13<D2 & A13 = 'D2")]),
      'A15': Entry(
          id: 'A15',
          constraints: [ExpressionConstraint(r"A15<D3 & A15 = 'D3")]),
      'A16': Entry(
          id: 'A16',
          constraints: [ExpressionConstraint(r"A16<D12 & A16 = 'D12")]),
      'A17': Entry(
          id: 'A17',
          constraints: [ExpressionConstraint(r"A17>D13 & A17 = 'D13")]),
      'D1': Entry(
          id: 'D1', constraints: [ExpressionConstraint(r"D1>A2 & D1 = 'A2")]),
      'D2': Entry(
          id: 'D2', constraints: [ExpressionConstraint(r"D2>A13 & D2 = 'A13")]),
      'D3': Entry(
          id: 'D3', constraints: [ExpressionConstraint(r"D3>A15 & D3 = 'A15")]),
      'D4': Entry(
          id: 'D4', constraints: [ExpressionConstraint(r"D4<A1 & D4 = 'A1")]),
      'D6': Entry(
          id: 'D6', constraints: [ExpressionConstraint(r"D6<A9 & D6 = 'A9")]),
      'D10': Entry(
          id: 'D10',
          constraints: [ExpressionConstraint(r"D10>A7 & D10 = 'A7")]),
      'D12': Entry(
          id: 'D12',
          constraints: [ExpressionConstraint(r"D12>A16 & D12 = 'A16")]),
      'D13': Entry(
          id: 'D13',
          constraints: [ExpressionConstraint(r"D13<A17 & D13 = 'A17")]),
      'D14': Entry(
          id: 'D14',
          constraints: [ExpressionConstraint(r"D14<A5 & D14 = 'A5")]),
    },
    // Difference of reversed numbers
    // 2 digits: (10a+b)-(10b+a) = 9(a-b)
    // 3 digits: (100a+10b+c)-(100c+10b+a) = 99(a-c)
    // 4 digits: (1000a+100b+10c+d)-(1000d+100c+10b+a) = 999(a-d)+90(b-c)
    // So all are multiple of 9
    // Clue I is reversed in clue IX, so its length must be greater than 1
    clues: {
      'I': Clue(
          'I', [ExpressionConstraint(r'$isDivisibleNine (A1-D4) = #square')],
          length: 2), // length 2 as it is reversed in clue IX
      'II': Clue(
          'II', [ExpressionConstraint(r'$isDivisibleNine (A5-D14) = #square')]),
      'III': Clue('III',
          [ExpressionConstraint(r'$isDivisibleNine (A9-D6) = #triangular')]),
      'IV': Clue('IV',
          [ExpressionConstraint(r'$isDivisibleNine (A11-D8) = #triangular')]),
      'V': Clue('V',
          [ExpressionConstraint(r'$isDivisibleNine (A17-D13) = #triangular')]),
      'VI': Clue(
        'VI',
        [
          ExpressionConstraint(r'$isDivisibleNine (D1-A2) = $multiple (VIII)')
        ], // D3-A1
      ),
      'VII': Clue(
        'VII',
        [
          ExpressionConstraint(r'$isDivisibleNine (D2-A13) = $multiple (I)')
        ], // A1-D
      ),
      'VIII': Clue(
          'VIII', [ExpressionConstraint(r'$isDivisibleNine (D3-A15) = #cube')]),
      'IX': Clue(
        'IX',
        [
          ExpressionConstraint(r"$isDivisibleNine (D10-A7) = $multiple '(I)")
        ], // A1-D
      ),
      'X': Clue('X', [
        ExpressionConstraint(r'$isDivisibleNine (D12-A16) = 2*(VI)')
      ]), // D1-A2
    },
    variables: {},
    puzzleConstraints: [CouplesDifferencesConstraint()],
  );
  setAnswers(puzzle);

  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  puzzle.clues['I']!.answer = 36;
  puzzle.clues['II']!.answer = 9;
  puzzle.clues['III']!.answer = 630;
  puzzle.clues['IV']!.answer = 2628;
  puzzle.clues['V']!.answer = 45;
  puzzle.clues['VI']!.answer = 297;
  puzzle.clues['VII']!.answer = 3996;
  puzzle.clues['VIII']!.answer = 27;
  puzzle.clues['IX']!.answer = 819;
  puzzle.clues['X']!.answer = 594;
  puzzle.entries['A1']!.answer = 84;
  puzzle.entries['A2']!.answer = 588;
  puzzle.entries['A5']!.answer = 87;
  puzzle.entries['A7']!.answer = 7538;
  puzzle.entries['A9']!.answer = 7817;
  puzzle.entries['A11']!.answer = 5813;
  puzzle.entries['A13']!.answer = 1775;
  puzzle.entries['A15']!.answer = 58;
  puzzle.entries['A16']!.answer = 187;
  puzzle.entries['A17']!.answer = 61;
  puzzle.entries['D1']!.answer = 885;
  puzzle.entries['D2']!.answer = 5771;
  puzzle.entries['D3']!.answer = 85;
  puzzle.entries['D4']!.answer = 48;
  puzzle.entries['D6']!.answer = 7187;
  puzzle.entries['D8']!.answer = 3185;
  puzzle.entries['D10']!.answer = 8357;
  puzzle.entries['D12']!.answer = 781;
  puzzle.entries['D13']!.answer = 16;
  puzzle.entries['D14']!.answer = 78;
}
