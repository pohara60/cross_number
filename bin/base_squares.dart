import 'package:crossnumber/src/base/base_solver.dart';

import '../puzzles/base_squares.dart';

void main() {
  final puzzle = baseSquares();
  final result = BaseSolver(puzzle).solveAll();

  print('Puzzle: ${puzzle.name}');
  print('Solutions: ${result.solutions.length}');
  print('');

  for (var i = 0; i < result.solutions.length; i++) {
    final solution = result.solutions[i];
    print('Solution ${i + 1}');
    print(result.render(solution));
    print('');
  }

  final ambiguous = result.ambiguousAlwaysSquareValues();
  if (ambiguous.isEmpty) {
    print('No ambiguous always-square entries.');
  } else {
    print('Ambiguous always-square entries:');
    for (final entry in ambiguous.entries) {
      final values = entry.value.toList()..sort();
      print('  ${entry.key}: $values');
    }
  }
}
