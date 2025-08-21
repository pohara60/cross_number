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
  puzzle.clues['1A']!.answer = 113;
  puzzle.clues['4A']!.answer = 27;
  puzzle.clues['6A']!.answer = 74;
  puzzle.clues['7A']!.answer = 532;
  puzzle.clues['8A']!.answer = 24;
  puzzle.clues['9A']!.answer = 20;
  puzzle.clues['10A']!.answer = 862;
  puzzle.clues['13A']!.answer = 32;
  puzzle.clues['15A']!.answer = 88;
  puzzle.clues['16A']!.answer = 112;
  puzzle.clues['1D']!.answer = 17;
  puzzle.clues['2D']!.answer = 144;
  puzzle.clues['3D']!.answer = 35;
  puzzle.clues['4D']!.answer = 23;
  puzzle.clues['5D']!.answer = 720;
  puzzle.clues['8D']!.answer = 288;
  puzzle.clues['9D']!.answer = 231;
  puzzle.clues['11D']!.answer = 68;
  puzzle.clues['12D']!.answer = 21;
  puzzle.clues['14D']!.answer = 22;

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
