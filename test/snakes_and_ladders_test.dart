import 'package:test/test.dart';
import 'package:crossnumber/src/solver.dart';
import '../puzzles/snakes_and_ladders.dart';

void main() {
  group('Snakes and Ladders Puzzle', () {
    test('should solve the simple puzzle correctly', () {
      final puzzle = snakesAndLadders();
      final solver = Solver(puzzle);
      int solveCount = 0;

      bool callback() {
        solveCount++;
        return true;
      }

      solver.solve(callback);
      expect(solveCount, 1);
    });
  });
}
