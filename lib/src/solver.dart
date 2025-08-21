// ignore_for_file: unused_import

import 'dart:math';
import 'package:collection/collection.dart';
import 'package:crossnumber/src/models/evaluation_result.dart';
import 'package:crossnumber/src/models/expressable.dart';
import 'package:crossnumber/src/models/clue_group.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/expressions/expression.dart';
import 'package:crossnumber/src/utils/set.dart';
import 'package:crossnumber/src/models/entry.dart'; // Added for SolverState
import 'package:crossnumber/src/models/grid.dart';

import 'expressions/evaluator.dart';
import 'models/variable.dart'; // Added for _printSolution

class SolverState {
  final Map<String, Set<int>?> cluePossibleValues;
  final Map<String, Set<int>> entryPossibleValues;
  final Map<String, Set<int>> variablePossibleValues;

  SolverState(this.cluePossibleValues, this.entryPossibleValues,
      this.variablePossibleValues);

  SolverState copy() {
    return SolverState(
      cluePossibleValues.map((key, value) =>
          MapEntry(key, value == null ? null : Set.from(value))),
      entryPossibleValues.map((key, value) => MapEntry(key, Set.from(value))),
      variablePossibleValues
          .map((key, value) => MapEntry(key, Set.from(value))),
    );
  }
}

/// The main solver for cross number puzzles.
///
/// The solver orchestrates the process of solving a puzzle by iteratively
/// applying constraints and propagating the results until a solution is found.
/// It can handle puzzles with both known and unknown mappings between clues
/// and entries.
class Solver {
  /// The puzzle definition to be solved.
  final PuzzleDefinition puzzle;

  /// Allow backtracking
  final bool allowBacktracking;

  /// Flags to enable or disable tracing.
  bool trace; // Currently tracing
  final bool traceSolve;
  final bool traceBacktrace;

  /// A flag to track if any updates were made in the last iteration of the solver.
  bool _updated = false;

  /// A map of variable names to the clues that depend on them.
  final Map<String, List<Clue>> _variableDependencies = {};

  /// Creates a new solver for the given [puzzle].
  Solver(
    this.puzzle, {
    this.traceSolve = false,
    this.allowBacktracking = true,
    this.traceBacktrace = false,
  }) : trace = traceSolve {
    // Initialize clues with possible values based on entry length
    for (var clue in puzzle.clues.values) {
      final entry =
          puzzle.entries.values.firstWhereOrNull((e) => e.clueId == clue.id);
      if (entry != null) {
        clue.possibleValues = List<int>.generate(
            pow(10, entry.length).toInt() - pow(10, entry.length - 1).toInt(),
            (i) => i + pow(10, entry.length - 1).toInt()).toSet();
      } else {
        // If no entry is found, leave it null to indicate uninitialised
      }
    }

    // Initialize variable dependencies
    for (var clue in puzzle.clues.values) {
      for (final constraint in clue.constraints) {
        if (constraint is ExpressionConstraint) {
          for (final varName in constraint.variables) {
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

  SolverState _saveState() {
    final clueValues = <String, Set<int>?>{};
    for (var clue in puzzle.clues.values) {
      clueValues[clue.id] =
          clue.possibleValues == null ? null : Set.from(clue.possibleValues!);
    }
    final entryValues = <String, Set<int>>{};
    for (var entry in puzzle.entries.values) {
      entryValues[entry.id] = Set.from(entry.possibleValues);
    }
    final variableValues = <String, Set<int>>{};
    for (var variable in puzzle.variables.values) {
      variableValues[variable.name] = Set.from(variable.possibleValues);
    }
    return SolverState(clueValues, entryValues, variableValues);
  }

  void _restoreState(SolverState state) {
    for (var clue in puzzle.clues.values) {
      var possibleValues = state.cluePossibleValues[clue.id];
      clue.possibleValues =
          possibleValues == null ? null : Set.from(possibleValues);
    }
    for (var entry in puzzle.entries.values) {
      entry.possibleValues = Set.from(state.entryPossibleValues[entry.id]!);
    }
    for (var variable in puzzle.variables.values) {
      variable.possibleValues =
          Set.from(state.variablePossibleValues[variable.name]!);
    }
  }

  int _backtrack(int clueIndex, int solutionCount,
      [bool Function()? callback]) {
    if (clueIndex == puzzle.clues.length) {
      // Base case: All clues assigned. Check if it's a valid solution.
      if (isSolutionValid()) {
        if (traceBacktrace) print('Backtracking: Solution found!');
        if (callback != null) {
          if (!callback()) {
            if (traceBacktrace) print('Backtracking: Callback returned false.');
            return solutionCount; // Stop if callback returns false
          }
        }
        _printSolution();
        solutionCount++;
      } else {
        if (traceBacktrace) print('Backtracking: Not a valid solution.');
      }
      return solutionCount;
    }

    final currentClue = puzzle.clues.values.elementAt(clueIndex);
    final originalPossibleValues = Set<int>.from(currentClue.possibleValues!);

    if (traceBacktrace) {
      print(
          'Backtracking: Trying clue ${currentClue.id} -> ${originalPossibleValues.length} ${originalPossibleValues.toShortString()}');
    }

    for (final value in originalPossibleValues) {
      if (traceBacktrace) {
        print('Backtracking: Trying value $value for clue ${currentClue.id}');
      }
      final savedState =
          _saveState(); // Save the current state before trying a value

      // Try assigning the value
      currentClue.possibleValues = {value};

      // Solve the clue with this value, to update variables
      var updatedVariables = <String>[];
      var originalCounts = <String, int?>{};
      solveExpression(currentClue, updatedVariables, originalCounts);
      if (traceBacktrace) {
        _printUpdatedExpressables(updatedVariables, originalCounts);
      }

      // Also update the associated entry's possible values
      final entry = puzzle.entries.values
          .firstWhereOrNull((e) => e.clueId == currentClue.id);
      if (entry != null) {
        entry.possibleValues = {value};
      }

      var (consistent, _) =
          _propagateConstraints(traceBacktrace); // Propagate the change

      if (consistent) {
        if (traceBacktrace) {
          print('Backtracking: Propagation consistent. Recursing...');
        }
        solutionCount =
            _backtrack(clueIndex + 1, solutionCount, callback); // Recurse
      } else {
        if (traceBacktrace) {
          print('Backtracking: Propagation inconsistent. Backtracking...');
        }
      }

      _restoreState(savedState); // Undo the assignment and restore state
    }
    return solutionCount;
  }

  bool isSolutionValid() {
    // Check if all clues have a single value
    for (var clue in puzzle.clues.values) {
      if (clue.possibleValues == null || clue.possibleValues!.length != 1) {
        return false;
      }
    }
    // Check if all entries have a single value
    for (var entry in puzzle.entries.values) {
      if (entry.possibleValues.length != 1) {
        return false;
      }
    }
    // Additional check: Ensure consistency after all assignments
    // This is implicitly handled by _propagateConstraints returning false on inconsistency
    // but a final check for any remaining inconsistencies is good.
    // For now, if all possibleValues are singletons, and propagation was consistent, it's valid.
    return true;
  }

  void _printSolution() {
    print("Solution:");
    // Assuming puzzle.grids has a single grid for simplicity, or iterate if multiple
    if (puzzle.grids.isNotEmpty) {
      final solvedGrid = puzzle.grids.values.first; // Get the first grid
      print(solvedGrid
          .toString()); // Grid's toString() already displays solved values
    } else {
      print("No grid to display.");
    }

    print("Clue values:");
    for (var clue in puzzle.clues.values) {
      print("${clue.id}: ${clue.possibleValues!.single}");
    }

    if (puzzle.variables.isNotEmpty) {
      print('Variables:');
      for (var variable in puzzle.variables.values) {
        print(
            '${variable.name}: ${variable.possibleValues.length} ${variable.possibleValues.toShortString()}');
      }
    }
  }

  /// Solves the puzzle.
  ///
  /// This method will delegate to the appropriate solving strategy based on
  /// whether the clue-to-entry mapping is known.
  void solve([bool Function()? callback]) {
    if (puzzle.mappingIsKnown) {
      _solveKnownMapping(callback);
    } else {
      _solveUnknownMapping(callback);
    }
  }

  void printPuzzle() {
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
      print(
          '${clue.id}: ${clue.possibleValues!.length}  ${clue.possibleValues!.toShortString()}');
    }
    print('Entries:');
    for (var entry in puzzle.entries.values) {
      print(
          '${entry.id}: ${entry.possibleValues.length}  ${entry.possibleValues.toShortString()}');
    }
  }

  /// Solves the puzzle when the clue-to-entry mapping is known.
  ///
  /// This method iteratively applies constraints to all clues and propagates
  /// variable changes until no more updates can be made.
  void _solveKnownMapping([bool Function()? callback]) {
    if (trace) print('Solving puzzle with known mapping...');
    int iteration = 0;
    do {
      iteration++;
      if (trace) print('Iteration $iteration');
      _updated = false;

      // Solve clue groups
      final clueGroups = puzzle.findClueGroups();
      for (var group in clueGroups) {
        if (solveClueGroup(group)) {
          _updated = true;
        }
      }

      // Solve expressables
      if (trace) print('  Solving expressables...');
      var (consistent, updated) = _solveExpressables(clueGroups);
      if (consistent) {
        if (updated) _updated = true;
        (consistent, updated) = _propagateConstraints(trace);
        if (consistent) {
          if (updated) _updated = true;
        }
      }
      if (!consistent) {
        // If propagation leads to inconsistency, this path is invalid.
        // In the context of _solveKnownMapping, this means the initial state
        // was inconsistent, or a previous step made it inconsistent.
        // Here, we just break the loop as no further progress can be made.
        _updated = false; // Stop iterating if inconsistent
      }
    } while (_updated);

    // If solution not exact, start backtracking
    if (isSolutionValid()) {
      if (callback != null) callback.call();
      printPuzzle();
    } else if (!allowBacktracking) {
      printPuzzle();
      print('Solution not complete, backtracking disabled');
    } else {
      printPuzzle();
      print('Solution not complete, backtracking');
      Expressable.checkAnswer =
          false; // Disable answer checking during backtracking
      trace = traceBacktrace; // Use traceBacktrace for backtracking
      var solutionCount = _backtrack(0, 0, callback);
      if (solutionCount == 0) {
        print("Backtracking: no solutions found.");
      } else {
        print("Backtracking: $solutionCount solutions found.");
      }
    }
  }

  (bool consistent, bool updated) _solveExpressables(
      List<ClueGroup>? clueGroups) {
    var updated = false;
    for (var expressable in puzzle.expressables.values) {
      if (expressable is Clue &&
          clueGroups != null &&
          clueGroups.any((g) => g.clues.contains(expressable.id))) {
        continue; // Skip clues already in groups
      }
      final updatedVariables = <String>[];
      var originalCounts = <String, int?>{};
      var (consistent, changed) =
          solveExpression(expressable, updatedVariables, originalCounts);
      if (!consistent) return (false, true);
      if (changed) {
        updated = true;
        if (trace) {
          _printUpdatedExpressable(
              expressable, expressable.possibleValues?.length);
          _printUpdatedExpressables(updatedVariables, originalCounts);
        }
      }
    }
    return (true, updated);
  }

  void _printUpdatedVariables(List<String> updatedVariables) {
    for (var variableName in updatedVariables) {
      var variable = puzzle.variables[variableName]!;
      print(
          '      Updated Variable: $variableName: ${variable.possibleValues.length} ${variable.possibleValues.toShortString()}');
    }
  }

  void _printUpdatedClue(Clue clue, int? originalCount) {
    print(
        '    Clue ${clue.id}: $originalCount -> ${clue.possibleValues!.length} ${clue.possibleValues!.toShortString()}');
  }

  void _printUpdatedVariable(Variable variable, int? originalCount) {
    print(
        '    Clue ${variable.name}: $originalCount -> ${variable.possibleValues.length} ${variable.possibleValues.toShortString()}');
  }

  void _printUpdatedEntry(Entry entry, int originalSize) {
    print(
        '    ${entry.orientation == EntryOrientation.across ? 'Across' : 'Down'} Entry ${entry.id}: $originalSize -> ${entry.possibleValues.length} ${entry.possibleValues.toShortString()}');
  }

  void _printUpdatedExpressable(Expressable expressable, int? originalCount) {
    if (expressable is Clue) {
      _printUpdatedClue(expressable, originalCount);
    }
    if (expressable is Variable) {
      _printUpdatedVariable(expressable, originalCount);
    }
  }

  void _printUpdatedExpressables(
      List<String> expressables, Map<String, int?> originalCounts) {
    for (var expressableName in expressables) {
      var expressable = puzzle.variables[expressableName] as Expressable?;
      expressable ??= puzzle.clues[expressableName];
      _printUpdatedExpressable(expressable!, originalCounts[expressableName]);
    }
  }

  (bool consistent, bool updated) solveExpression(Expressable expressable,
      List<String> updatedVariables, Map<String, int?> originalCounts) {
    var updated = false;

    // if expressable.possibleValues == null then the min and max are not known
    final solveMin = expressable.min ?? 1;
    final solveMax = expressable.max ?? 100000; // Arbitrarily large

    final evaluator = Evaluator(puzzle);

    var results = <EvaluationFinalResult>[];
    try {
      results = evaluator.evaluate(
          expressable.expressionTree, expressable.variables,
          min: solveMin, max: solveMax);
    } on EvaluatorNotPossiblexception catch (e) {
      if (trace) {
        print(
            '    Expression for ${expressable.id} could not be evaluated: ${e.msg}');
      }
      return (true, false);
    }

    final newPossibleValues = results.map((r) => r.value).toSet();
    var possibleValues =
        _updatePossibleValues(expressable.possibleValues, newPossibleValues);
    if (possibleValues.isEmpty) {
      if (trace) {
        print(
            '    Expression for ${expressable.id} has no possible values after evaluation');
      }
      return (false, false); // Inconsistency
    }
    if (expressable.possibleValues != possibleValues) {
      expressable.possibleValues = possibleValues;
      updated = true;
    }

    // Update variables
    updated = _updateVariablesFromResults(expressable.variables, results,
        updated, updatedVariables, originalCounts);
    return (true, updated);
  }

  Set<int> _updatePossibleValues(
      Set<int>? possibleValues, Set<int> newPossibleValues) {
    if (possibleValues == null) {
      possibleValues = newPossibleValues;
    } else {
      final oldPossibleValuesLength = possibleValues.length;
      if (newPossibleValues.length < oldPossibleValuesLength) {
        possibleValues = possibleValues.intersection(newPossibleValues);
      }
    }
    return possibleValues;
  }

  bool _updateVariablesFromResults(
      List<String> variables,
      List<EvaluationFinalResult> results,
      bool updated,
      List<String> updatedVariables,
      Map<String, int?> originalCounts) {
    var variableValues = results.map((r) => r.variableValues).toList();
    return _updateVariables(
        variables, variableValues, updated, updatedVariables, originalCounts);
  }

  bool _updateVariables(
      List<String> variables,
      List<Map<String, int>> results,
      bool updated,
      List<String> updatedVariables,
      Map<String, int?> originalCounts) {
    for (var variableName in variables) {
      var expressable = puzzle.variables[variableName] as Expressable?;
      if (expressable == null) {
        expressable = puzzle.clues[variableName] as Expressable?;
        if (expressable == null) continue;
      }

      final newVariableValues = results
          .map((r) => r[variableName]!)
          // .where((v) => v != null)
          .toSet();
      var originalCount = expressable.possibleValues?.length;
      var possibleValues =
          _updatePossibleValues(expressable.possibleValues, newVariableValues);
      if (expressable.possibleValues != possibleValues) {
        expressable.possibleValues = possibleValues;
        updated = true;
        updatedVariables.add(variableName);
        originalCounts[variableName] = originalCount;
      }
    }
    return updated;
  }

  bool solveClueGroup(ClueGroup group) {
    if (trace) print('  Solving group with clues: ${group.clues}');

    var updated = false;
    final validCombinations = <Map<String, int>>[];
    var consistent = _solveClueGroup(
        group.clues.map((e) => puzzle.clues[e]!).toList(),
        {},
        validCombinations);
    if (consistent && validCombinations.isNotEmpty) {
      // Update clue values
      for (var clueId in group.clues) {
        final clue = puzzle.clues[clueId]!;
        final newPossibleValues = validCombinations
            .map((combination) => combination[clueId]!)
            .toSet();
        if (newPossibleValues.length < clue.possibleValues!.length) {
          final originalCount = clue.possibleValues?.length ?? 0;
          clue.possibleValues = newPossibleValues;
          updated = true;
          if (trace) _printUpdatedClue(clue, originalCount);
        }
      }

      // Update variables
      var updateVariables = <String>[];
      var originalCounts = <String, int?>{};
      updated = _updateVariables(group.variables, validCombinations, updated,
          updateVariables, originalCounts);
      if (trace) _printUpdatedExpressables(updateVariables, originalCounts);
    }
    return updated;
  }

  bool _solveClueGroup(List<Clue> clues, Map<String, int> pinnedVariables,
      List<Map<String, int>> validCombinations) {
    if (clues.isEmpty) {
      validCombinations.add(pinnedVariables);
      return true;
    }

    final clue = clues.first;
    final remainingClues = clues.sublist(1);
    final evaluator = Evaluator(puzzle, pinnedVariables);
    // Assume the clue has only one expression constraint for simplicity
    final constraint = clue.constraints
        .firstWhere((c) => c is ExpressionConstraint) as ExpressionConstraint;

    var results = <EvaluationFinalResult>[];
    try {
      results = evaluator.evaluate(
          constraint.expressionTree!, constraint.variables,
          min: clue.min!, max: clue.max!);
    } on EvaluatorNotPossiblexception catch (e) {
      if (trace) {
        print('    Expression for ${clue.id} could not be evaluated: ${e.msg}');
      }
      return false;
    }

    var anyConsistent = false;
    for (var result in results) {
      if (clue.possibleValues!.contains(result.value)) {
        final newPinnedVariables = {
          ...pinnedVariables,
          clue.id: result.value,
          ...result.variableValues
        };
        var consistent = _solveClueGroup(
            remainingClues, newPinnedVariables, validCombinations);
        if (consistent) {
          anyConsistent = true;
        }
      }
    }
    return anyConsistent;
  }

  (bool consistent, bool updated) _enforceDistinctValues(bool trace) {
    bool changed = false;

    // Enforce distinct clue values
    final solvedClues = puzzle.clues.values
        .where((clue) =>
            clue.possibleValues != null && clue.possibleValues!.length == 1)
        .toList();
    if (solvedClues.isNotEmpty) {
      final solvedClueValues =
          solvedClues.map((clue) => clue.possibleValues!.single).toSet();
      if (solvedClueValues.length < solvedClues.length) {
        return (false, true); // Inconsistency
      }

      for (var clue in puzzle.clues.values) {
        if (clue.possibleValues == null) {
          continue; // Skip if clue has no values yet
        }
        if (clue.possibleValues!.length > 1) {
          final originalCount = clue.possibleValues!.length;
          clue.possibleValues!.removeAll(solvedClueValues);
          if (clue.possibleValues!.length < originalCount) {
            changed = true;
            if (trace) {
              print(
                  '    Clue ${clue.id} distinct values: $originalCount -> ${clue.possibleValues!.length} ${clue.possibleValues!.toShortString()}');
            }
          }
          if (clue.possibleValues!.isEmpty) {
            return (false, true); // Inconsistency
          }
        }
      }
    }

    // Enforce distinct variable values
    final solvedVariables = puzzle.variables.values
        .where((variable) => variable.possibleValues.length == 1)
        .toList();
    if (solvedVariables.isNotEmpty) {
      final solvedVariableValues = solvedVariables
          .map((variable) => variable.possibleValues.single)
          .toSet();
      if (solvedVariableValues.length < solvedVariables.length) {
        return (false, true); // Inconsistency
      }

      for (var variable in puzzle.variables.values) {
        if (variable.possibleValues.length > 1) {
          final originalCount = variable.possibleValues.length;
          variable.possibleValues = Set.from(variable.possibleValues)
            ..removeAll(solvedVariableValues);
          if (variable.possibleValues.length < originalCount) {
            changed = true;
            if (trace) {
              print(
                  '    Variable ${variable.name} distinct values: $originalCount -> ${variable.possibleValues.length} ${variable.possibleValues.toShortString()}');
            }
          }
        }
        if (variable.possibleValues.isEmpty) {
          return (false, true); // Inconsistency
        }
      }
    }

    return (true, changed);
  }

  (bool consistent, bool updated) _propagateConstraints(bool trace) {
    bool changed = false;
    bool localChanged;
    do {
      localChanged = false;
      if (trace) print('  Propagating constraints...');

      // Propagate clue values to entries
      for (var entry in puzzle.entries.values) {
        if (entry.clueId != null) {
          final clue = puzzle.clues[entry.clueId!];
          if (clue != null) {
            if (clue.possibleValues == null) {
              continue; // Skip if clue has no values yet
            }
            final originalCount = clue.possibleValues!.length;
            entry.possibleValues
                .retainWhere((value) => clue.possibleValues!.contains(value));
            if (entry.possibleValues.length < originalCount) {
              localChanged = true;
              if (trace) {
                print(
                    '    Entry ${entry.id}: $originalCount -> ${entry.possibleValues.length} ${entry.possibleValues.toShortString()}');
              }
            }
            if (entry.possibleValues.isEmpty) {
              return (false, true); // Inconsistency
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
                  if (acrossEntry.possibleValues.isEmpty) {
                    return (false, true); // Inconsistency
                  }
                  localChanged = true;
                  crossChanged = true;
                  if (trace) {
                    _printUpdatedEntry(acrossEntry, acrossValues.length);
                  }
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
                  if (downEntry.possibleValues.isEmpty) {
                    return (false, true); // Inconsistency
                  }
                  localChanged = true;
                  crossChanged = true;
                  if (trace) {
                    _printUpdatedEntry(downEntry, downValues.length);
                  }
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
            if (clue.possibleValues == null) {
              continue; // Skip if clue has no values yet
            }
            final originalSize = clue.possibleValues!.length;
            clue.possibleValues!
                .retainWhere((value) => entry.possibleValues.contains(value));
            if (clue.possibleValues!.isEmpty) {
              return (false, true); // Inconsistency
            }
            if (clue.possibleValues!.length < originalSize) {
              localChanged = true;
              if (trace) {
                _printUpdatedClue(clue, originalSize);
              }
            }
          }
        }
      }

      // Update variables from clue values
      // for (var clue in puzzle.clues.values) {
      //   if (clue.possibleValues == null) {
      //     continue; // Skip if clue has no values yet
      //   }
      //   if (clue.updateVariables(puzzle, trace: trace)) {
      //     localChanged = true;
      //   }
      //   if (clue.possibleValues!.isEmpty) {
      //     return (false, true); // Inconsistency after variable update
      //   }
      // }

      // Re-solve expressions
      var (consistent, changed) = _solveExpressables(null);
      if (changed) localChanged = true;
      if (!consistent) return (false, true); // Inconsistency after re-solve

      // Enforce distinct values
      var (distinctConsistent, distinctUpdated) = _enforceDistinctValues(trace);
      if (!distinctConsistent) return (false, true);
      if (distinctUpdated) localChanged = true;

      if (localChanged) changed = true;
    } while (localChanged);
    return (true, changed);
  }

  /// Solves the puzzle when the clue-to-entry mapping is unknown.
  ///
  /// This method uses a backtracking algorithm to try all possible mappings
  /// of clues to entries until a valid solution is found.
  void _solveUnknownMapping([bool Function()? callback]) {
    // This is where the backtracking logic will go.
    // For now, it's a placeholder.
    print("Solving puzzle with unknown mapping...");
    _solveWithBacktracking(puzzle.clues.values.toList(), 0);
    printPuzzle();
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
          .every((clue) => clue.possibleValues!.length == 1);
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
