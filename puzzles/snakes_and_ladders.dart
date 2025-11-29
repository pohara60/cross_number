// ignore_for_file: unused_local_variable

import 'package:crossnumber/src/expressions/monadic.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/snakes_and_ladders_grid.dart';

/// You throw a standard die and gradually work up the board, climbing a ladder
/// if you land at the foot of it, and sliding down a snake if you land on its
/// head. So, for example, if you consistently threw a 3 on your die you would
/// land on cells 3, 6, 9, 12, 46, 49 and so on. In one special game I
/// consistently threw the same particular number and ended up landing on 100.
/// Your task today is to use the following clues to fill in the grid in such a
/// way that the cells I landed on in that special game all contain different
/// digits. The clue answers are all different and none of them starts with
/// zero.

PuzzleDefinition snakesAndLadders() {
  final grid = SnakesAndLaddersGrid(10, 10);

  var puzzle = PuzzleDefinition(
    name: 'Snakes and Ladders',
    grids: {'main': grid},
    puzzleConstraints: [SnakesAndLaddersConstraint()],
    entries: {
      'D94': Entry(
          id: 'D94',
          row: 0,
          col: 6,
          length: 3,
          orientation: EntryOrientation.down,
          clueId: 'D94'),
      'D68': Entry(
          id: 'D68',
          row: 3,
          col: 7,
          length: 4,
          orientation: EntryOrientation.down,
          clueId: 'D68'),
      'D61': Entry(
          id: 'D61',
          row: 3,
          col: 0,
          length: 4,
          orientation: EntryOrientation.down,
          clueId: 'D61'),
      'D42': Entry(
          id: 'D42',
          row: 5,
          col: 1,
          length: 4,
          orientation: EntryOrientation.down,
          clueId: 'D42'),
      'U45': Entry(
          id: 'U45',
          row: 5,
          col: 4,
          length: 5,
          orientation: EntryOrientation.up,
          clueId: 'U45'),
      // 'U38': Entry(
      //     id: 'U38',
      //     row: 6,
      //     col: 2,
      //     length: 3,
      //     orientation: EntryOrientation.up,
      //     clueId: 'U38'),
      'U15': Entry(
          id: 'U15',
          row: 8,
          col: 5,
          length: 4,
          orientation: EntryOrientation.up,
          clueId: 'U15'),
      'U11': Entry(
          id: 'U11',
          row: 8,
          col: 9,
          length: 4,
          orientation: EntryOrientation.up,
          clueId: 'U11'),
      'A1': Entry(
        id: 'A1',
        clueId: 'A1',
        row: 9,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
      'A20': Entry(
        id: 'A20',
        clueId: 'A20',
        row: 8,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
      'A21': Entry(
        id: 'A21',
        clueId: 'A21',
        row: 7,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
      'A40': Entry(
        id: 'A40',
        clueId: 'A40',
        row: 6,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
      'A41': Entry(
        id: 'A41',
        clueId: 'A41',
        row: 5,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
      'A60': Entry(
        id: 'A60',
        clueId: 'A60',
        row: 4,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
      'A61': Entry(
        id: 'A61',
        clueId: 'A61',
        row: 3,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
      'A80': Entry(
        id: 'A80',
        clueId: 'A80',
        row: 2,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
      'A81': Entry(
        id: 'A81',
        clueId: 'A81',
        row: 1,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
      'A100': Entry(
        id: 'A100',
        clueId: 'A100',
        row: 0,
        col: 0,
        length: 10,
        orientation: EntryOrientation.across,
      ),
    },
    clues: {
      'D42':
          Clue('D42', [ExpressionConstraint(r'$multiple #numberevendigits')]),
      'D61': Clue('D61', [ExpressionConstraint(r'$square #square')]),
      'D68': Clue('D68', [ExpressionConstraint(r'#productfiveprimes')]),
      'D94':
          Clue('D94', [ExpressionConstraint(r'$multiple #numberevendigits')]),
      'U11': Clue('U11', [ExpressionConstraint(r'$cuberoot A41')]),
      'U15': Clue('U15', [ExpressionConstraint(r'$double #square')]),
      // 'U38': Clue('U38', [ExpressionConstraint(r'$half #sumdigits')]),
      'U45': Clue('U45', [ExpressionConstraint(r'#square')]),
      'A1': Clue('A1', [ExpressionConstraint(r'$ishighestacross #cube')]),
      'A20': Clue('A20', [ExpressionConstraint(r'$islowestacross #cube')]),
      'A21': Clue(
          'A21', [ExpressionConstraint(r'1 + $primepower #twodigitprime')]),
      'A40': Clue('A40', [ExpressionConstraint(r'$cube #square')]),
      'A41': Clue('A41', [ExpressionConstraint(r'#cube')]),
      'A60': Clue('A60', [ExpressionConstraint(r'$primepower #twodigitprime')]),
      'A61': Clue('A61', [ExpressionConstraint(r'$primepower #twodigitprime')]),
      'A80': Clue('A80', [ExpressionConstraint(r'$primepower #twodigitprime')]),
      'A81': Clue('A81', [ExpressionConstraint(r'$primepower #twodigitprime')]),
      'A100': Clue('A100', [ExpressionConstraint(r'$cube #cube')]),
    },
    variables: {},
  );
  setAnswers(puzzle);
  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  puzzle.clues['A1']!.answer = 9380581029;
  puzzle.clues['A20']!.answer = 1287913472;
  puzzle.clues['A21']!.answer = 5584059450;
  puzzle.clues['A40']!.answer = 6321363049;
  puzzle.clues['A41']!.answer = 9208180736;
  puzzle.clues['A60']!.answer = 2073071593;
  puzzle.clues['A61']!.answer = 1804229351;
  puzzle.clues['A80']!.answer = 3077056399;
  puzzle.clues['A81']!.answer = 1350125107;
  puzzle.clues['A100']!.answer = 2357947691;
  puzzle.clues['U11']!.answer = 2096;
  puzzle.clues['U15']!.answer = 1568;
  // puzzle.clues['U38']!.answer = 201;
  puzzle.clues['U45']!.answer = 10201;
  puzzle.clues['D42']!.answer = 2352;
  puzzle.clues['D61']!.answer = 1296;
  puzzle.clues['D68']!.answer = 3570;
  puzzle.clues['D94']!.answer = 756;
}

class SnakesAndLaddersConstraint extends PuzzleConstraint {
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
    // var digits = puzzle.grids.values.first.getDigits();

    var a1 = puzzle.clues['A1']!.solution!;
    var a20 = puzzle.clues['A20']!.solution!;
    var a21 = puzzle.clues['A21']!.solution!;
    var a40 = puzzle.clues['A40']!.solution!;
    var a41 = puzzle.clues['A41']!.solution!;
    var a60 = puzzle.clues['A60']!.solution!;
    var a61 = puzzle.clues['A61']!.solution!;
    var a80 = puzzle.clues['A80']!.solution!;
    var a81 = puzzle.clues['A81']!.solution!;
    var a100 = puzzle.clues['A100']!.solution!;
    var d94 = puzzle.clues['D94']!.solution!;

    var a1Str = a1.toString();
    var a20Str = a20.toString();
    var a21Str = a21.toString();
    var a40Str = a40.toString();
    var a41Str = a41.toString();
    var a60Str = a60.toString();
    var a61Str = a61.toString();
    var a80Str = a80.toString();
    var a81Str = a81.toString();
    var a100Str = a100.toString();
    // Check unique digits on path [5, 10, 46, 51, 56, 40, 85, 90, 95, 100];
    var pathValueStr = a1Str[4] +
        a1Str[9] +
        a41Str[5] +
        a60Str[9] +
        a60Str[4] +
        a40Str[0] +
        a81Str[4] +
        a81Str[9] +
        a100Str[5] +
        a100Str[0];
    var duplicate = false;
    for (var index = 1; index < pathValueStr.length; index++) {
      var digit = pathValueStr[index];
      if (pathValueStr.substring(0, index).contains(digit)) {
        duplicate = true;
        break;
      }
    }
    if (duplicate) return false;
    ;

    // Check d94 has multiple of number of even digits
    var numberOfEvenDigits = countEvenDigits(a1Str) +
        countEvenDigits(a20Str) +
        countEvenDigits(a21Str) +
        countEvenDigits(a40Str) +
        countEvenDigits(a41Str) +
        countEvenDigits(a60Str) +
        countEvenDigits(a61Str) +
        countEvenDigits(a80Str) +
        countEvenDigits(a81Str) +
        countEvenDigits(a100Str);
    if (d94 % numberOfEvenDigits != 0) return false;

    return true;
  }

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}

countEvenDigits(String str) {
  var count = 0;
  for (var i = 0; i < str.length; i++) {
    var digit = str[i];
    if ("02468".contains(digit)) {
      count++;
    }
  }
  return count;
}
