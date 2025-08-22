// ignore_for_file: unused_import

import 'package:collection/collection.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:crossnumber/src/utils/set.dart';

PuzzleDefinition wheels() {
// The Wheels on the Bus by Moog

// Muffit and Duffit operate a daily coach service from Aberdeen to Edinburgh which has a single
// stop, in order, at Brechin, Crieff and Dundee before reaching its destination. The coach can
// hold a maximum of 60 passengers. All entries are distinct and none start with zero.

  final gridString = [
    '+--+--+--+--+--+--+',
    '|1 :  :2 |  |3 :4 |',
    '+::+--+::+--+--+::+',
    '|  |  |5 :  |  |  |',
    '+--+--+::+--+--+::+',
    '|  |6 :  |  |7 :  |',
    '+--+::+--+--+::+--+',
    '|8 :  |  |9 :  |  |',
    '+::+--+--+::+--+--+',
    '|  |  |10:  |  |11|',
    '+::+--+--+::+--+::+',
    '|12:  |  |13:  :  |',
    '+--+--+--+--+--+--+',
  ];
  Set<int> getVariableValues(min, max) =>
      Set.from(List.generate(max - min + 1, (index) => index + min));
  final variableValues60 = getVariableValues(1, 60);
  final puzzle = PuzzleDefinition.fromString(
    name: 'Wheels',
    gridString: gridString.join('\n'),
    clues: {
      '1A': Clue('1A', [ExpressionConstraint(r"$square 1D")]),
      '3A': Clue('3A', [ExpressionConstraint("B")]),
      '5A': Clue('5A', [ExpressionConstraint("T")]),
      '6A': Clue('6A', [ExpressionConstraint("F")]),
      '7A': Clue('7A', [ExpressionConstraint(r"$square b")]),
      '8A': Clue('8A', [ExpressionConstraint("f")]),
      '9A': Clue('9A', [ExpressionConstraint(r"$cube C")]),
      '10A': Clue('10A', [ExpressionConstraint("e")]),
      '12A': Clue('12A', [ExpressionConstraint(r"$factor 3A")]),
      '13A': Clue('13A', [ExpressionConstraint(r"$square 11D")]),
      '1D': Clue('1D', [ExpressionConstraint("A")]),
      '2D': Clue('2D', [ExpressionConstraint("20 * Y")]),
      '4D': Clue('4D', [ExpressionConstraint(r"$square 3A")]),
      '6D': Clue('6D', [ExpressionConstraint(r"$lt 3A")]),
      '7D': Clue('7D', [ExpressionConstraint("c")]),
      '8D': Clue('8D', [ExpressionConstraint(r"$square 8A")]),
      '9D': Clue('9D', [ExpressionConstraint(r"$cube d")]),
      '11D': Clue('11D', [ExpressionConstraint("D")]),
    },
    variables: {
      "B": Variable("B", variableValues60,
          constraints: [ExpressionConstraint(r"$lte (60-A+b)")]),
      "T": Variable("T", getVariableValues(1, 240),
          constraints: [ExpressionConstraint("A+B+C+D = b+c+d+e")]),
      "F": Variable("F", getVariableValues(1, 99)),
      "b": Variable("b", variableValues60,
          constraints: [ExpressionConstraint(r"$lte A")]),
      "f": Variable("f", getVariableValues(1, 99),
          constraints: [ExpressionConstraint(r"$lt F")]),
      "C": Variable("C", variableValues60,
          constraints: [ExpressionConstraint(r"$lte (60-A+b-B+c)")]),
      "e": Variable("e", variableValues60,
          constraints: [ExpressionConstraint("A+B+C+D-b-c-d")]),
      "A": Variable("A", variableValues60),
      "Y": Variable("Y", getVariableValues(17, 50)),
      "c": Variable("c", variableValues60,
          constraints: [ExpressionConstraint(r"$lte (A-b+B)")]),
      "d": Variable("d", variableValues60,
          constraints: [ExpressionConstraint(r"$lte (A-b+B-c+C)")]),
      "D": Variable("D", variableValues60,
          constraints: [ExpressionConstraint(r"$lte (60-A+b-B+c-C+d)")]),
    },
  );

  // Set the answers for the puzzle
  setAnswers(puzzle);

  return puzzle;
}

void setAnswers(PuzzleDefinition puzzle) {
  puzzle.clues['1A']!.answer = 196;
  puzzle.clues['3A']!.answer = 26;
  puzzle.clues['5A']!.answer = 68;
  puzzle.clues['6A']!.answer = 20;
  puzzle.clues['7A']!.answer = 16;
  puzzle.clues['8A']!.answer = 11;
  puzzle.clues['9A']!.answer = 27;
  puzzle.clues['10A']!.answer = 41;
  puzzle.clues['12A']!.answer = 13;
  puzzle.clues['13A']!.answer = 625;
  puzzle.clues['1D']!.answer = 14;
  puzzle.clues['2D']!.answer = 660;
  puzzle.clues['4D']!.answer = 676;
  puzzle.clues['6D']!.answer = 21;
  puzzle.clues['7D']!.answer = 17;
  puzzle.clues['8D']!.answer = 121;
  puzzle.clues['9D']!.answer = 216;
  puzzle.clues['11D']!.answer = 25;

  puzzle.variables['A']!.answer = 14;
  puzzle.variables['B']!.answer = 26;
  puzzle.variables['C']!.answer = 3;
  puzzle.variables['D']!.answer = 25;
  puzzle.variables['F']!.answer = 20;
  puzzle.variables['T']!.answer = 68;
  puzzle.variables['Y']!.answer = 33;
  puzzle.variables['b']!.answer = 4;
  puzzle.variables['c']!.answer = 17;
  puzzle.variables['d']!.answer = 6;
  puzzle.variables['e']!.answer = 41;
  puzzle.variables['f']!.answer = 11;
}
