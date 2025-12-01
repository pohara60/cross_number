// ignore_for_file: unused_import

import 'dart:io';

import 'package:args/args.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/snakes_and_ladders_grid.dart';
import 'package:crossnumber/src/solver.dart';
import 'package:crossnumber/src/solver_tracer.dart';
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
import '../puzzles/snakes_and_ladders.dart';
import '../puzzles/splits.dart';
import '../puzzles/sum_squares.dart';
import '../puzzles/thirty.dart';
import '../puzzles/threes.dart';
import '../puzzles/wheels.dart';

final puzzleMap = <String, PuzzleDefinition Function()>{
  'abcd': abcd,
  'after_nicholas': afterNicholas,
  'couples_differences': couplesDifferences,
  'die_another_day': dieAnotherDay,
  'increasing_prime': increasingPrimes,
  'mathematical_inspiration': mathematicalInspiration,
  'primania': primania,
  'puzzle2': puzzle2,
  'puzzle3': puzzle3,
  'simple_puzzle': simplePuzzle,
  'snakes_and_ladders': snakesAndLadders,
  'splits': splits,
  'sum_squares': sumsquares,
  'thirty': thirty,
  'threes': threes,
  'wheels': wheels,
};

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('puzzle', abbr: 'p', help: 'The name of the puzzle to solve.')
    ..addFlag('list',
        abbr: 'l', negatable: false, help: 'List available puzzles.')
    ..addFlag('trace', abbr: 't', help: 'Enable solver tracing.')
    ..addFlag('backtrace', abbr: 'b', help: 'Enable backtrace tracing.')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help.');

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      print('Cross Number Solver v2 CLI');
      print('Usage: dart run bin/cross_number_v2.dart [options]');
      print(parser.usage);
      return;
    }

    if (results['list'] as bool) {
      print('Available puzzles:');
      print(puzzleMap.keys.join('\n'));
      return;
    }

    final puzzleName = results['puzzle'] as String?;
    if (puzzleName == null) {
      print('Please specify a puzzle using --puzzle or -p.');
      print('Use --list to see available puzzles.');
      exit(1);
    }

    if (!puzzleMap.containsKey(puzzleName)) {
      print('Unknown puzzle: $puzzleName');
      print('Use --list to see available puzzles.');
      exit(1);
    }

    print('Cross Number Solver v2 CLI');
    print('Loading puzzle: $puzzleName');

    final puzzle = puzzleMap[puzzleName]!();

    // Special handling for Snakes and Ladders pre-processing
    if (puzzleName == 'snakes_and_ladders') {
      final grid = puzzle.grids['main']! as SnakesAndLaddersGrid;
      grid.populate(puzzle.entries);
      final result = grid.getWinningRolls();
      print('Winning die rolls: $result');
    }

    print('Puzzle: ${puzzle.name}');

    final tracer = SolverTracer(
      traceSolve: results['trace'] as bool,
      traceBacktrace: results['backtrace'] as bool,
    );

    final solver = Solver(
      puzzle,
      allowBacktracking: true,
      tracer: tracer,
    );

    solver.solve(null, MappingStrategy.cluePriority);
  } on FormatException catch (e) {
    print(e.message);
    print('');
    print(parser.usage);
    exit(1);
  } on PuzzleException catch (e) {
    print('Error loading puzzle: ${e.msg}');
    exit(1);
  }
}
