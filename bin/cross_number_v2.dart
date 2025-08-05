import 'package:crossnumber/src/solver.dart';
import '../puzzles/simple_puzzle.dart';

void main(List<String> arguments) {
  print('Cross Number Solver v2 CLI');

  // For now, directly load the simple puzzle.
  final puzzle = simplePuzzle();

  final solver = Solver(puzzle);
  solver.solve();

  print('\nSolution:');
  puzzle.clues.values.forEach((clue) {
    print('${clue.id}: ${clue.possibleValues}');
  });
}