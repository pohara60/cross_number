// ignore_for_file: unused_import

import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/solver.dart';
import '../puzzles/abcd.dart';
import '../puzzles/after_nicholas.dart';
import '../puzzles/couples_differences.dart';
import '../puzzles/die_another_day.dart';
import '../puzzles/increasing_prime.dart';
import '../puzzles/mathematical_inspiration.dart';
import '../puzzles/primania.dart';
import '../puzzles/puzzle2.dart';
import '../puzzles/puzzle3.dart';
import '../puzzles/simple_puzzle.dart';
import '../puzzles/sum_squares.dart';
import '../puzzles/thirty.dart';
import '../puzzles/threes.dart';
import '../puzzles/wheels.dart';

void main(List<String> arguments) {
  print('Cross Number Solver v2 CLI');

  // For now, directly load the simple puzzle.
  try {
    // final puzzle = increasingPrimes();
    // final puzzle = wheels();
    // final puzzle = afterNicholas();
    // final puzzle = simplePuzzle();
    // final puzzle = puzzle2();
    // final puzzle = puzzle3();
    // final puzzle = threes();
    // final puzzle = abcd();
    // final puzzle = primania();
    // final puzzle = couplesDifferences();
    // final puzzle = thirty();
    // final puzzle = dieAnotherDay();
    final puzzle = mathematicalInspiration();
    // final puzzle = sumsquares();
    print('Puzzle: ${puzzle.name}');

    final solver = Solver(puzzle,
        // useTransitiveGrouping: true,
        traceSolve: true,
        allowBacktracking: true,
        traceBacktrace: false);
    solver.solve();
  } on PuzzleException catch (e) {
    print('Error loading puzzle: ${e.msg}');
    return;
  }
}
