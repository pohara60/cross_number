import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/abcd.dart';
import 'test_utils.dart';

void main() {
  group('ABCD', () {
    test('should solve the puzzle', () {
      final puzzle = abcd();
      // final solver = Solver(puzzle, traceSolve: true);
      final solver = Solver(puzzle, traceSolve: false, traceBacktrace: false);
      int solveCount = 0;

      bool callback() {
        // Check entry/clue values
        expectEntryValues(puzzle, 'A1', [4554]);
        expectEntryValues(puzzle, 'A4', [51]);
        expectEntryValues(puzzle, 'A6', [17]);
        expectEntryValues(puzzle, 'A7', [3096]);
        expectEntryValues(puzzle, 'A8', [142]);
        expectEntryValues(puzzle, 'A10', [34]);
        expectEntryValues(puzzle, 'A11', [23]);
        expectEntryValues(puzzle, 'A12', [618]);
        expectEntryValues(puzzle, 'A14', [2640]);
        expectEntryValues(puzzle, 'A17', [21]);
        expectEntryValues(puzzle, 'A18', [19]);
        expectEntryValues(puzzle, 'A19', [2754]);
        expectEntryValues(puzzle, 'D1', [410]);
        expectEntryValues(puzzle, 'D2', [57]);
        expectEntryValues(puzzle, 'D3', [40]);
        expectEntryValues(puzzle, 'D4', [59]);
        expectEntryValues(puzzle, 'D5', [164]);
        expectEntryValues(puzzle, 'D7', [346]);
        expectEntryValues(puzzle, 'D8', [13]);
        expectEntryValues(puzzle, 'D9', [210]);
        expectEntryValues(puzzle, 'D10', [38]);
        expectEntryValues(puzzle, 'D11', [221]);
        expectEntryValues(puzzle, 'D13', [714]);
        expectEntryValues(puzzle, 'D15', [69]);
        expectEntryValues(puzzle, 'D16', [42]);
        expectEntryValues(puzzle, 'D17', [25]);

        expectVariableValues(puzzle, 'A', [17]);
        expectVariableValues(puzzle, 'B', [19]);
        expectVariableValues(puzzle, 'C', [23]);
        expectVariableValues(puzzle, 'D', [181]);

        solveCount++;
        return true;
      }

      solver.solve(callback);
      expect(solveCount, 1);
    });
  });
}
