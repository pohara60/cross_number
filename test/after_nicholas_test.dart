import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/solver.dart';
import 'package:test/test.dart';

import '../puzzles/after_nicholas.dart';

void main() {
  group('After Nicholas', () {
    test('should solve the puzzle', () {
      final puzzle = afterNicholas();
      // final solver = Solver(puzzle, traceSolve: true);
      final solver = Solver(puzzle, traceSolve: false, traceBacktrace: false);
      setAnswers(puzzle);
      solver.solve();
      expect(solver.isSolutionValid(), isTrue);
    });
  });
}

void setAnswers(PuzzleDefinition puzzle) {
  puzzle.entries['A1']!.answer = 113;
  puzzle.entries['A4']!.answer = 27;
  puzzle.entries['A6']!.answer = 74;
  puzzle.entries['A7']!.answer = 532;
  puzzle.entries['A8']!.answer = 24;
  puzzle.entries['A9']!.answer = 20;
  puzzle.entries['A10']!.answer = 862;
  puzzle.entries['A13']!.answer = 32;
  puzzle.entries['A15']!.answer = 88;
  puzzle.entries['A16']!.answer = 112;
  puzzle.entries['D1']!.answer = 17;
  puzzle.entries['D2']!.answer = 144;
  puzzle.entries['D3']!.answer = 35;
  puzzle.entries['D4']!.answer = 23;
  puzzle.entries['D5']!.answer = 720;
  puzzle.entries['D8']!.answer = 288;
  puzzle.entries['D9']!.answer = 231;
  puzzle.entries['D11']!.answer = 68;
  puzzle.entries['D12']!.answer = 21;
  puzzle.entries['D14']!.answer = 22;

  puzzle.variables['A']!.answer = 5;
  puzzle.variables['C']!.answer = 7;
  puzzle.variables['E']!.answer = 2;
  puzzle.variables['G']!.answer = 12;
  puzzle.variables['H']!.answer = 10;
  puzzle.variables['I']!.answer = 11;
  puzzle.variables['J']!.answer = 8;
  puzzle.variables['L']!.answer = 16;
  puzzle.variables['M']!.answer = 4;
  puzzle.variables['N']!.answer = 15;
  puzzle.variables['O']!.answer = 14;
  puzzle.variables['P']!.answer = 13;
  puzzle.variables['S']!.answer = 9;
  puzzle.variables['T']!.answer = 6;
  puzzle.variables['U']!.answer = 3;
  puzzle.variables['Y']!.answer = 1;
}
