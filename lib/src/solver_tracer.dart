import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expressable.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:crossnumber/src/utils/set.dart';

/// Handles tracing and logging for the Solver.
class SolverTracer {
  /// Enable tracing for the solve process.
  bool traceSolve;

  /// Enable tracing for the backtracking process.
  bool traceBacktrace;

  SolverTracer({
    this.traceSolve = false,
    this.traceBacktrace = false,
  });

  bool get trace => traceSolve;
  set trace(bool value) => traceSolve = value;

  void log(String message) {
    print(message);
  }

  void logSolve(String message) {
    if (traceSolve) print(message);
  }

  void logBacktrace(String message) {
    if (traceBacktrace) print(message);
  }

  void printSolution(PuzzleDefinition puzzle) {
    var buffer = StringBuffer();
    buffer.writeln("Solution:");
    if (puzzle.grids.isNotEmpty) {
      var allGridLines = <List<String>>[];
      var maxWidth = 0;
      for (var grid in puzzle.grids.values) {
        var gridLines = grid.toString().split('\n');
        allGridLines.add(gridLines);
        maxWidth = gridLines.fold(
            maxWidth, (prev, line) => prev > line.length ? prev : line.length);
      }
      for (var lineIndex = 0;
          lineIndex < allGridLines.first.length;
          lineIndex++) {
        for (var gridIndex = 0; gridIndex < puzzle.grids.length; gridIndex++) {
          buffer.write(allGridLines[gridIndex][lineIndex].padRight(maxWidth));
          buffer.write('  ');
        }
        buffer.writeln();
      }
    } else {
      buffer.writeln("No grid to display.");
    }

    if (puzzle.clues.isNotEmpty) {
      buffer.writeln("Clue values:");
      for (var clue in puzzle.clues.values) {
        buffer.writeln("${clue.id}: ${clue.possibleValues!.single}");
      }
    }

    if (puzzle.variables.isNotEmpty) {
      buffer.writeln('Variables:');
      for (var variable in puzzle.variables.values) {
        buffer.writeln(
            '${variable.name}: ${variable.possibleValues.length} ${variable.possibleValues.toShortString()}');
      }
    }
    print(buffer.toString());
  }

  void printPuzzle(PuzzleDefinition puzzle) {
    print('Grid:');
    for (var grid in puzzle.grids.values) {
      print(grid.toString());
    }
    print('Variables:');
    for (var variable in puzzle.variables.values) {
      print(
          '${variable.name}: ${variable.possibleValues.length} ${variable.possibleValues.toShortString()}');
    }
    print('Clues:');
    for (var clue in puzzle.clues.values) {
      if (clue.possibleValues == null) {
        print('${clue.id}: uninitialised');
        continue;
      }
      print(
          '${clue.id}: ${clue.possibleValues!.length}  ${clue.possibleValues!.toShortString()}');
    }
    print('Entries:');
    for (var entry in puzzle.entries.values) {
      if (entry.possibleValues == null) {
        print('${entry.id}: uninitialised');
        continue;
      }
      print(
          '${entry.id}:! ${entry.possibleValues!.length}!  ${entry.possibleValues!.toShortString()}');
    }
  }

  void printUpdatedExpressable(Expressable expressable, int? originalCount) {
    if (expressable is Clue) {
      printUpdatedClue(expressable, originalCount);
    }
    if (expressable is Variable) {
      printUpdatedVariable(expressable, originalCount);
    }
    if (expressable is Entry) {
      printUpdatedEntry(expressable, originalCount);
    }
  }

  void printUpdatedExpressables(
      PuzzleDefinition puzzle, List<String> expressables, Map<String, int?> originalCounts) {
    for (var expressableName in expressables) {
      Expressable expressable = puzzle.getExpressable(expressableName);
      printUpdatedExpressable(expressable, originalCounts[expressableName]);
    }
  }

  void printUpdatedClue(Clue clue, int? originalCount) {
    print(
        '    Clue ${clue.id}: $originalCount -> ${clue.possibleValues!.length} ${clue.possibleValues!.toShortString()}');
  }

  void printUpdatedVariable(Variable variable, int? originalCount) {
    print(
        '    Variable ${variable.name}: $originalCount -> ${variable.possibleValues.length} ${variable.possibleValues.toShortString()}');
  }

  void printUpdatedEntry(Entry entry, int? originalCount) {
    print(
        '    Entry ${entry.id}: $originalCount -> ${entry.possibleValues!.length} ${entry.possibleValues!.toShortString()}');
  }
}
