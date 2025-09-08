import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/thirty.dart';

void main() {
  var disabled = true;
  test('Thirty should solve the puzzle', () {
    final puzzle = thirty();
    final solver = Solver(puzzle, traceSolve: true, allowBacktracking: false);
    solver.solve();
    expect(puzzle.isSolutionValid(), isTrue);
  }, skip: disabled);
}
