import 'package:crossnumber/src/solver.dart';
import '../puzzles/puzzle3.dart';

void main(List<String> arguments) {
  print('Cross Number Solver v2 CLI');

  // For now, directly load the simple puzzle.
  final puzzle = puzzle3();
  print('Puzzle: ${puzzle.name}');

  final solver = Solver(puzzle, trace: false, traceBacktrace: false);
  solver.solve();
}
