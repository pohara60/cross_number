import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/solver.dart';
import '../puzzles/after_nicholas.dart';

void main(List<String> arguments) {
  print('Cross Number Solver v2 CLI');

  // For now, directly load the simple puzzle.
  try {
    final puzzle = afterNicholas();
    print('Puzzle: ${puzzle.name}');

    final solver = Solver(puzzle, trace: true, traceBacktrace: false);
    solver.solve();
  } on PuzzleException catch (e) {
    print('Error loading puzzle: ${e.msg}');
    return;
  }
}
