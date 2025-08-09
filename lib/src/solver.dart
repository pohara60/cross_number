import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/expressions/expression.dart';

/// The main solver for cross number puzzles.
///
/// The solver orchestrates the process of solving a puzzle by iteratively
/// applying constraints and propagating the results until a solution is found.
/// It can handle puzzles with both known and unknown mappings between clues
/// and entries.
class Solver {
  /// The puzzle definition to be solved.
  final PuzzleDefinition puzzle;

  /// A flag to track if any updates were made in the last iteration of the solver.
  bool _updated = false;

  /// A map of variable names to the clues that depend on them.
  final Map<String, List<Clue>> _variableDependencies = {};

  /// Creates a new solver for the given [puzzle].
  Solver(this.puzzle) {
    // Initialize variable dependencies
    for (var clue in puzzle.clues.values) {
      for (final constraint in clue.constraints) {
        if (constraint is ExpressionConstraint) {
          final parser = Parser(constraint.expression);
          final expression = parser.parse();
          final variableExtractor = VariableExtractorVisitor();
          expression.accept(variableExtractor, min: -10000, max: 10000);
          for (final varName in variableExtractor.variables) {
            _variableDependencies.putIfAbsent(varName, () => []).add(clue);
          }
        }
      }
    }

    // Populate the grids
    for (var grid in puzzle.grids.values) {
      grid.populate(puzzle.entries);
    }
  }

  /// Solves the puzzle.
  ///
  /// This method will delegate to the appropriate solving strategy based on
  /// whether the clue-to-entry mapping is known.
  void solve() {
    if (puzzle.mappingIsKnown) {
      _solveKnownMapping();
    } else {
      _solveUnknownMapping();
    }
    printPuzzle();
  }

  void printPuzzle() {
    print('Grid:');
    for (var grid in puzzle.grids.values) {
      print(grid.toString());
    }
    print('Variables:');
    for (var variable in puzzle.variables.values) {
      print(
          '${variable.name}: ${variable.possibleValues.length} possible values');
      if (variable.possibleValues.length < 10) {
        print('  ${variable.possibleValues}');
      }
    }
    print('Clues:');
    for (var clue in puzzle.clues.values) {
      print('${clue.id}: ${clue.possibleValues.length} possible values');
      if (clue.possibleValues.length < 10) {
        print('  ${clue.possibleValues}');
      }
    }
    print('Entries:');
    for (var entry in puzzle.entries.values) {
      print('${entry.id}: ');
      if (entry.possibleValues.length == 1) {
        print('  ${entry.possibleValues.first.toString().split('').join(':')}');
      } else {
        print('  ?');
      }
    }
  }

  /// Solves the puzzle when the clue-to-entry mapping is known.
  ///
  /// This method iteratively applies constraints to all clues and propagates
  /// variable changes until no more updates can be made.
  void _solveKnownMapping() {
    do {
      _updated = false;

      // Solve clues first
      for (var clue in puzzle.clues.values) {
        if (clue.solve(puzzle)) {
          _updated = true;
        }
      }

      _propagateConstraints();
    } while (_updated);
  }

  void _propagateConstraints() {
    bool changed;
    do {
      changed = false;

      // Propagate clue values to entries
      for (var entry in puzzle.entries.values) {
        if (entry.clueId != null) {
          final clue = puzzle.clues[entry.clueId!];
          if (clue != null) {
            final originalCount = entry.possibleValues.length;
            entry.possibleValues
                .retainWhere((value) => clue.possibleValues.contains(value));
            if (entry.possibleValues.length < originalCount) {
              changed = true;
            }
          }
        }
      }

      // Enforce grid constraints
      for (var grid in puzzle.grids.values) {
        for (int r = 0; r < grid.rows; r++) {
          for (int c = 0; c < grid.cols; c++) {
            final cell = grid.cells[r][c];
            if (cell.acrossEntry != null && cell.downEntry != null) {
              final acrossEntry = cell.acrossEntry!;
              final downEntry = cell.downEntry!;
              final acrossDigitIndex = c - acrossEntry.col;
              final downDigitIndex = r - downEntry.row;

              bool crossChanged;
              do {
                crossChanged = false;
                final acrossValues = acrossEntry.possibleValues;
                final downValues = downEntry.possibleValues;

                final newAcrossValues = <int>{};
                for (final acrossValue in acrossValues) {
                  final acrossDigit = acrossValue.toString()[acrossDigitIndex];
                  if (downValues.any((downValue) =>
                      downValue.toString()[downDigitIndex] == acrossDigit)) {
                    newAcrossValues.add(acrossValue);
                  }
                }

                if (newAcrossValues.length < acrossValues.length) {
                  acrossEntry.possibleValues = newAcrossValues;
                  changed = true;
                  crossChanged = true;
                }

                final newDownValues = <int>{};
                for (final downValue in downValues) {
                  final downDigit = downValue.toString()[downDigitIndex];
                  if (acrossEntry.possibleValues.any((acrossValue) =>
                      acrossValue.toString()[acrossDigitIndex] == downDigit)) {
                    newDownValues.add(downValue);
                  }
                }

                if (newDownValues.length < downValues.length) {
                  downEntry.possibleValues = newDownValues;
                  changed = true;
                  crossChanged = true;
                }
              } while (crossChanged);
            }
          }
        }
      }

      // Propagate entry values back to clues
      for (var entry in puzzle.entries.values) {
        if (entry.clueId != null) {
          final clue = puzzle.clues[entry.clueId!];
          if (clue != null) {
            final originalSize = clue.possibleValues.length;
            clue.possibleValues
                .retainWhere((value) => entry.possibleValues.contains(value));
            if (clue.possibleValues.length < originalSize) {
              changed = true;
            }
          }
        }
      }

      // Update variables from clue values
      for (var clue in puzzle.clues.values) {
        if (clue.updateVariables(puzzle)) {
          changed = true;
        }
      }

      // Re-solve clues with updated variable values
      for (var clue in puzzle.clues.values) {
        if (clue.solve(puzzle)) {
          changed = true;
        }
      }
    } while (changed);
  }

  /// Solves the puzzle when the clue-to-entry mapping is unknown.
  ///
  /// This method uses a backtracking algorithm to try all possible mappings
  /// of clues to entries until a valid solution is found.
  void _solveUnknownMapping() {
    // This is where the backtracking logic will go.
    // For now, it's a placeholder.
    print("Solving puzzle with unknown mapping...");
    _solveWithBacktracking(puzzle.clues.values.toList(), 0);
  }

  /// The recursive backtracking function for solving puzzles with unknown mappings.
  ///
  /// This function tries to map each clue to an available entry and then
  /// recursively calls itself to map the next clue. If a dead end is reached,
  /// it backtracks and tries a different mapping.
  bool _solveWithBacktracking(List<Clue> remainingClues, int clueIndex) {
    if (clueIndex == remainingClues.length) {
      // All clues have been mapped, now try to solve the puzzle.
      _solveKnownMapping();
      // Check if a solution was found (e.g., all clues have a single possible value)
      return puzzle.clues.values
          .every((clue) => clue.possibleValues.length == 1);
    }

    final currentClue = remainingClues[clueIndex];

    // Find available entries for this clue
    final availableEntries = puzzle.entries.values
        .where((entry) =>
                entry.clueId == null &&
                entry.length == currentClue.id.length // Simplified length check
            // Add more sophisticated checks here (e.g., orientation, grid compatibility)
            )
        .toList();

    for (final entry in availableEntries) {
      // Try mapping the current clue to this entry
      entry.clueId = currentClue.id;

      // Recursively try to solve with the new mapping
      if (_solveWithBacktracking(remainingClues, clueIndex + 1)) {
        return true; // Found a solution
      }

      // Backtrack: unmap the clue from the entry
      entry.clueId = null;
    }

    return false; // No solution found with this branch
  }
}
