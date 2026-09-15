import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/statement.dart';
import 'package:test/test.dart';

void main() {
  test('orders entry statements by descending priority with stable ties', () {
    final entry = Entry(id: 'A1', length: 1, statements: 'low first second');
    final puzzle = PuzzleDefinition(
      name: 'test',
      grids: {'main': Grid(1, 1)},
      entries: {'A1': entry},
      clues: <String, Clue>{},
      variables: {},
      statements: {
        'low': Statement('low', '1', priority: 1),
        'first': Statement('first', '2', priority: 5),
        'second': Statement('second', '3', priority: 5),
      },
    );

    expect(
      puzzle.entries['A1']!.expressionConstraints.map((constraint) => constraint.expression),
      ['2', '3', '1'],
    );
  });

  test('copies statement priority', () {
    final statement = Statement('id', 'expression', priority: 4);

    expect(statement.copyWith().priority, 4);
    expect(statement.copyWith(priority: 8).priority, 8);
  });

  test('keeps direct constraints before reordered statement constraints', () {
    final entry = Entry(
      id: 'A1',
      length: 1,
      constraints: [ExpressionConstraint('4')],
      statements: 'statement',
    );
    final puzzle = PuzzleDefinition(
      name: 'test',
      grids: {'main': Grid(1, 1)},
      entries: {'A1': entry},
      clues: <String, Clue>{},
      variables: {},
      statements: {'statement': Statement('statement', '5', priority: 10)},
    );

    expect(
      puzzle.entries['A1']!.expressionConstraints.map((constraint) => constraint.expression),
      ['4', '5'],
    );
  });
}
