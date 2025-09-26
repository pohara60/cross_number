import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/die_another_day.dart';

void main() {
  var disabled = true;
  test('DieAnotherDay should solve the puzzle', () {
    final puzzle = dieAnotherDay();
    final solver = Solver(puzzle, traceSolve: true, allowBacktracking: false);
    solver.solve();
    expect(puzzle.isSolutionValid(), isTrue);
  }, skip: disabled);
}
