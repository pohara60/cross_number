import 'package:crossnumber/src/solver.dart';
import '../puzzles/puzzle3.dart';

void main(List<String> arguments) {
  print('Cross Number Solver v2 CLI');

  // For now, directly load the simple puzzle.
  final puzzle = puzzle3();

  final solver = Solver(puzzle, trace: true);
  solver.solve();

  print('\nSolution:');
  for (var clue in puzzle.clues.values) {
    print('${clue.id}: ${clue.possibleValues}');
  }
}
