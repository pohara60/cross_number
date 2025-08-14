import 'package:crossnumber/src/solver.dart';
import '../puzzles/after_nicholas.dart';

void main(List<String> arguments) {
  print('Cross Number Solver v2 CLI');

  // For now, directly load the simple puzzle.
  final puzzle = afterNicholas();
  print('Puzzle: ${puzzle.name}');

  final solver = Solver(puzzle, trace: true, traceBacktrace: false);
  solver.solve();
}
