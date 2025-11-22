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
import 'grouper.dart';

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

enum MappingStrategy {
  cluePriority,
  entryPriority,
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

  final bool useTransitiveGrouping;

  /// Creates a new solver for the given [puzzle].
  Solver(
    this.puzzle, {
    this.traceSolve = false,
    this.allowBacktracking = true,
    this.traceBacktrace = false,
    this.useTransitiveGrouping = false,
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

    // Enforce puzzle-specific distinct constraints
    for (var constraint in puzzle.puzzleConstraints) {
      constraint.initialise(puzzle, trace: trace);
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

  List<Expressable> _backtrackExpressables() {
    // Order expressables for backtracking
    final expressables = puzzle.allExpressables;
    final unsolved =
        expressables.where((expressable) => expressable.isNotSolved).toList();
    // Order with least possible values first
    unsolved.sort((a, b) => a.possibleValues == null
        ? 1
        : b.possibleValues == null
            ? -1
            : a.possibleValues!.length - b.possibleValues!.length);
    return unsolved;
  }

  int _backtrack(
      List<Expressable> expressables, expressableIndex, int solutionCount,
      [bool Function()? callback]) {
    if (expressableIndex == expressables.length) {
      // Base case: All expressables assigned. Check if it's a valid solution.
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

    final currentExpressable = expressables.elementAt(expressableIndex);
    if (currentExpressable.possibleValues == null ||
        currentExpressable.possibleValues!.isEmpty) {
      if (traceBacktrace) {
        print(
            'Backtracking: Clue ${currentExpressable.id} has no possible values, backtracking.');
      }
      return solutionCount; // No possible values, backtrack
    }

    final originalPossibleValues =
        Set<int>.from(currentExpressable.possibleValues!);
    if (traceBacktrace) {
      print(
          'Backtracking: Trying expressable ${currentExpressable.id} -> ${originalPossibleValues.length} ${originalPossibleValues.toShortString()}');
    }

    for (final value in originalPossibleValues) {
      if (traceBacktrace) {
        print(
            'Backtracking: Trying value $value for expressable ${currentExpressable.id}');
      }
      final savedState =
          _saveState(); // Save the current state before trying a value

      // Try assigning the value
      currentExpressable.possibleValues = {value};

      // Solve the expressable with this value, to update variables
      if (currentExpressable.expressionTrees.isNotEmpty) {
        var updatedVariables = <String>[];
        var originalCounts = <String, int?>{};
        solveExpression(currentExpressable, updatedVariables, originalCounts);
        if (traceBacktrace) {
          _printUpdatedExpressables(updatedVariables, originalCounts);
        }
      }

      // For clues update the associated entry's possible values
      if (currentExpressable is Clue) {
        final entry = puzzle.entries.values
            .firstWhereOrNull((e) => e.clueId == currentExpressable.id);
        if (entry != null) {
          entry.possibleValues = {value};
        }
      }

      var (consistent, _) =
          _propagateConstraints(traceBacktrace); // Propagate the change

      if (consistent) {
        if (traceBacktrace) {
          print('Backtracking: Propagation consistent. Recursing...');
        }
        solutionCount = _backtrack(expressables, expressableIndex + 1,
            solutionCount, callback); // Recurse
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
    return puzzle.isSolutionValid();
  }

  void _printSolution() {
    var buffer = StringBuffer();
    buffer.writeln("Solution:");
    // Assuming puzzle.grids has a single grid for simplicity, or iterate if multiple
    if (puzzle.grids.isNotEmpty) {
      // final solvedGrid = puzzle.grids.values.first; // Get the first grid
      // buffer.writeln(solvedGrid.toString());
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

  /// Solves the puzzle.
  ///
  /// This method will delegate to the appropriate solving strategy based on
  /// whether the clue-to-entry mapping is known.
  void solve(
      [bool Function()? callback,
      MappingStrategy strategy = MappingStrategy.entryPriority]) {
    if (puzzle.mappingIsKnown) {
      _solveKnownMapping(callback, allowBacktracking);
    } else {
      _solveUnknownMapping(callback, strategy);
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
      if (clue.possibleValues == null) {
        print('${clue.id}: uninitialised');
        continue;
      }
      print(
          '${clue.id}: ${clue.possibleValues!.length}  ${clue.possibleValues!.toShortString()}');
    }
    print('Entries:');
    for (var entry in puzzle.entries.values) {
      print(
          '${entry.id}: ${entry.possibleValues.length}  ${entry.possibleValues.toShortString()}');
    }
  }

  void _solveKnownMapping(
      [bool Function()? callback, bool valueBacktracking = true]) {
    if (trace) print('Solving puzzle with known mapping...');
    final stopwatch = Stopwatch()..start();

    // Calculate groups once
    final List<List<Expressable>> expressableGroups;
    if (useTransitiveGrouping) {
      final grouper = TransitiveExpressableGrouper();
      expressableGroups = grouper.findGroups(puzzle, trace);
    } else {
      final clueGroups = puzzle.findClueGroups();
      if (trace) {
        print('Found ${clueGroups.length} clue groups:');
        for (final group in clueGroups) {
          print('  Group: ${group.clues.join(', ')}');
        }
      }
      expressableGroups = clueGroups
          .map((g) => g.clues.map((c) => puzzle.clues[c]!).toList())
          .toList();
    }

    int iteration = 0;
    do {
      iteration++;
      if (trace) print('Iteration $iteration');
      _updated = false;

      // Solve groups
      for (var group in expressableGroups) {
        if (solveExpressableGroup(group)) {
          _updated = true;
        }
      }

      // Solve expressables not in groups
      if (trace) print('  Solving expressables...');
      var (consistent, updated) = _solveExpressables(expressableGroups);
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
    stopwatch.stop();
    if (isSolutionValid()) {
      if (callback != null) callback.call();
      printPuzzle();
      print('Solve time: ${stopwatch.elapsedMilliseconds}ms');
    } else if (!valueBacktracking) {
      printPuzzle();
      print('Solve time: ${stopwatch.elapsedMilliseconds}ms');
      print('Solution not complete, backtracking disabled');
    } else {
      printPuzzle();
      print('Solve time: ${stopwatch.elapsedMilliseconds}ms');
      print('Solution not complete, backtracking');

      // Disable answer checking during backtracking
      Expressable.checkAnswer = false;
      trace = traceBacktrace; // Use traceBacktrace for backtracking
      stopwatch.reset();
      stopwatch.start();
      var expressables = _backtrackExpressables();
      var solutionCount = _backtrack(expressables, 0, 0, callback);
      if (solutionCount == 0) {
        print("Backtracking: no solutions found.");
      } else {
        print("Backtracking: $solutionCount solutions found.");
      }
      stopwatch.stop();
      print('Backtracking time: ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  (bool consistent, bool updated) _solveExpressables(
      List<List<Expressable>>? groups) {
    var updated = false;
    final groupedExpressableIds =
        groups?.expand((g) => g.map((e) => e.id)).toSet() ?? <String>{};

    for (var expressable in puzzle.expressables.values) {
      if (groupedExpressableIds.contains(expressable.id)) {
        continue; // Skip expressables already in groups
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

  // void _printUpdatedVariables(List<String> updatedVariables) {
  //   for (var variableName in updatedVariables) {
  //     var variable = puzzle.variables[variableName]!;
  //     print(
  //         '      Updated Variable: $variableName: ${variable.possibleValues.length} ${variable.possibleValues.toShortString()}');
  //   }
  // }

  void _printUpdatedClue(Clue clue, int? originalCount) {
    print(
        '    Clue ${clue.id}: $originalCount -> ${clue.possibleValues!.length} ${clue.possibleValues!.toShortString()}');
  }

  void _printUpdatedVariable(Variable variable, int? originalCount) {
    print(
        '    Variable ${variable.name}: $originalCount -> ${variable.possibleValues.length} ${variable.possibleValues.toShortString()}');
  }

  void _printUpdatedEntry(Entry entry, int? originalCount) {
    print(
        '    Entry ${entry.id}: $originalCount -> ${entry.possibleValues.length} ${entry.possibleValues.toShortString()}');
  }

  void _printUpdatedExpressable(Expressable expressable, int? originalCount) {
    if (expressable is Clue) {
      _printUpdatedClue(expressable, originalCount);
    }
    if (expressable is Variable) {
      _printUpdatedVariable(expressable, originalCount);
    }
    if (expressable is Entry) {
      _printUpdatedEntry(expressable, originalCount);
    }
  }

  void _printUpdatedExpressables(
      List<String> expressables, Map<String, int?> originalCounts) {
    for (var expressableName in expressables) {
      Expressable expressable = puzzle.getExpressable(expressableName);
      _printUpdatedExpressable(expressable, originalCounts[expressableName]);
    }
  }

  (bool consistent, bool updated) solveExpression(Expressable expressable,
      List<String> updatedVariables, Map<String, int?> originalCounts) {
    var updated = false;

    // If no expression, then nothing to do
    if (expressable.expressionTrees.isEmpty) return (true, false);

    // If solved then do not re-evaluate
    // if (expressable.possibleValues != null &&
    //     expressable.possibleValues!.length == 1) {
    //   return (true, false);
    // }

    // if expressable.possibleValues == null then the min and max are not known
    final solveMin = expressable.min ?? 1;
    final solveMax = expressable.max ?? 100000; // Arbitrarily large

    final evaluator = Evaluator(puzzle);

    var results = <EvaluationFinalResult>[];
    try {
      results = evaluator.evaluate(expressable, min: solveMin, max: solveMax);
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

    // Reduce resutls to only those that match the possible values
    if (possibleValues.length < newPossibleValues.length) {
      results = results
          .where((r) => expressable.possibleValues!.contains(r.value))
          .toList();
    }

    // Update variables
    if (_updateVariablesFromResults(expressable.allVariables, results, updated,
        updatedVariables, originalCounts)) {
      updated = true;
    }
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
      var expressable = puzzle.getExpressable(variableName);

      final newVariableValues = results
          .map((r) => r[variableName])
          .where((v) => v != null)
          .map((v) => v as int)
          .toSet();
      if (newVariableValues.isEmpty) continue;
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
    var expressables = group.clues.map((e) => puzzle.clues[e]!).toList();
    return solveExpressableGroup(expressables);
  }

  bool solveExpressableGroup(List<Expressable> group) {
    if (trace) {
      print(
          '  Solving group with expressables: ${group.map((e) => e.id).join(', ')}');
    }

    var updated = false;
    final validCombinations = <Map<String, int>>[];
    try {
      var consistent = _solveExpressableGroup(group, {}, validCombinations);
      if (consistent && validCombinations.isNotEmpty) {
        // Update expressable values
        for (var expressable in group) {
          final newPossibleValues = validCombinations
              .map((combination) => combination[expressable.id])
              .where((value) => value != null)
              .map((v) => v as int)
              .toSet();
          if (newPossibleValues.isNotEmpty &&
              (expressable.possibleValues == null ||
                  newPossibleValues.length <
                      expressable.possibleValues!.length)) {
            final originalCount = expressable.possibleValues?.length;
            expressable.possibleValues = newPossibleValues;
            updated = true;
            if (trace) _printUpdatedExpressable(expressable, originalCount);
          }
        }

        // Update variables
        var variables = group.expand((e) => e.allVariables).toSet().toList();
        var updateVariables = <String>[];
        var originalCounts = <String, int?>{};
        if (_updateVariables(variables, validCombinations, updated,
            updateVariables, originalCounts)) {
          updated = true;
        }
        if (trace) _printUpdatedExpressables(updateVariables, originalCounts);
      }
    } on EvaluatorNotPossiblexception {
      // Message already printed where it occurred
    }
    return updated;
  }

  bool _solveExpressableGroup(
      List<Expressable> expressables,
      Map<String, int> pinnedVariables,
      List<Map<String, int>> validCombinations) {
    if (expressables.isEmpty) {
      validCombinations.add(pinnedVariables);
      return true;
    }

    final expressable = expressables.first;
    final remainingExpressables = expressables.sublist(1);
    final evaluator = Evaluator(puzzle, pinnedVariables);

    var results = <EvaluationFinalResult>[];
    try {
      results = evaluator.evaluate(expressable,
          min: expressable.min ?? 1, max: expressable.max ?? 99999);
    } on EvaluatorNotPossiblexception catch (e) {
      if (trace) {
        print(
            '    Expression for ${expressable.id} could not be evaluated: ${e.msg}');
      }
      rethrow;
    }

    var anyConsistent = false;
    for (var result in results) {
      if (expressable.possibleValues?.contains(result.value) ?? true) {
        final newPinnedVariables = {
          ...pinnedVariables,
          expressable.id: result.value,
          ...result.variableValues
        };
        var consistent = _solveExpressableGroup(
            remainingExpressables, newPinnedVariables, validCombinations);
        if (consistent) {
          anyConsistent = true;
        }
      }
    }
    return anyConsistent;
  }

  (bool consistent, bool updated) _enforceDistinctValues(bool trace) {
    bool changed = false;
    bool consistent = true;
    bool updated = false;

    var loopChanged = true;
    while (loopChanged) {
      loopChanged = false;

      // Enforce distinct clue values
      (consistent, updated) = _enforceDistinctValuesForExressable(
          puzzle, puzzle.clues.values, trace);
      if (updated) loopChanged = changed = true;
      if (!consistent) return (false, changed);

      // Enforce distinct variable values
      (consistent, updated) = _enforceDistinctValuesForExressable(
          puzzle, puzzle.variables.values, trace);
      if (updated) loopChanged = changed = true;
      if (!consistent) return (false, changed);

      // Enforce distinct entry values - necessary when not mapped to clues
      (consistent, updated) = _enforceDistinctValuesForExressable(
          puzzle, puzzle.entries.values, trace);
      if (updated) loopChanged = changed = true;
      if (!consistent) return (false, changed);

      // Enforce puzzle-specific distinct constraints
      for (var constraint in puzzle.puzzleConstraints) {
        var (consistent, updated) =
            constraint.enforceDistinct(puzzle, trace: trace);
        if (updated) loopChanged = changed = true;
        if (!consistent) return (false, changed);
      }
    }

    return (true, changed);
  }

  (bool consistent, bool updated) _enforceDistinctValuesForExressable(
      PuzzleDefinition puzzle, Iterable<Expressable> expressables, bool trace) {
    var updated = false;
    var consistent = true;

    // Find expressables with more than one possible value and less than 5
    final unsolved =
        expressables.where((expressable) => expressable.isNotSolved).toList();
    final consider =
        unsolved.where((expressable) => expressable.possibleValues!.length < 5);

    // Group unsolved expressables by their possible values
    final valueGroups = <String, Map<String, dynamic>>{};
    for (var expressable in consider) {
      final key = expressable.possibleValues!.toList()..sort();
      final keyString = key.join(',');
      valueGroups.putIfAbsent(
          keyString,
          () => {
                'values': expressable.possibleValues!,
                'expressables': <Expressable>[]
              });
      valueGroups[keyString]!['expressables'].add(expressable);
    }

    // Look for groups of size N with N values
    for (var entry in valueGroups.entries) {
      final possibleValues = entry.value['values'] as Set<int>;
      final group = entry.value['expressables'] as List<Expressable>;
      final n = possibleValues.length;
      if (n > 1 && n == group.length) {
        // Found a group of N expressables with N values.
        // Remove these values from all other expressables.
        bool traced = false;
        for (var expressable in unsolved) {
          if (!group.contains(expressable)) {
            final originalCount = expressable.possibleValues!.length;
            if (expressable.possibleValues!
                .any((v) => possibleValues.contains(v))) {
              expressable.possibleValues = expressable.possibleValues!
                  .where((v) => !possibleValues.contains(v))
                  .toSet();
              updated = true;
              if (trace) {
                if (!traced) {
                  traced = true;
                  print(
                      '    Found group of $n expressables (${group.map((e) => e.id).join(', ')}) with $n values');
                }
                _printUpdatedExpressable(expressable, originalCount);
              }
              if (expressable.possibleValues!.isEmpty) {
                consistent = false;
                break;
              }
            }
          }
        }
      }
      if (!consistent) break;
    }

    // Original logic for solved expressables (N=1)
    final solvedExpressables =
        expressables.where((expressable) => expressable.isSolved).toList();
    if (solvedExpressables.isNotEmpty) {
      final solvedExpressableValues =
          solvedExpressables.map((clue) => clue.possibleValues!.single).toSet();
      if (solvedExpressableValues.length < solvedExpressables.length) {
        return (false, true); // Inconsistency
      }

      for (var expressable in expressables) {
        if (expressable.possibleValues == null) {
          continue; // Skip if expressable has no values yet
        }
        if (expressable.isNotSolved) {
          if (expressable.possibleValues!
              .any((v) => solvedExpressableValues.contains(v))) {
            final originalCount = expressable.possibleValues!.length;
            expressable.possibleValues = expressable.possibleValues!
                .where((v) => !solvedExpressableValues.contains(v))
                .toSet();
            updated = true;
            if (trace) {
              _printUpdatedExpressable(expressable, originalCount);
            }
            if (expressable.possibleValues!.isEmpty) {
              consistent = false;
              break;
            }
          }
        }
      }
    }

    return (consistent, updated);
  }

  (bool consistent, bool updated) _propagateConstraints(bool trace) {
    bool changed = false;
    bool localChanged;
    do {
      localChanged = false;
      if (trace) print('  Propagating constraints...');

      // Enforce ordering constraints
      var (orderingConsistent, orderingUpdated) =
          _enforceOrderingConstraints(trace);
      if (!orderingConsistent) return (false, true);
      if (orderingUpdated) localChanged = true;

      // Propagate puzzle-specific constraints
      for (var constraint in puzzle.puzzleConstraints) {
        var (consistent, updated) = constraint.propagate(puzzle, trace: trace);
        if (!consistent) return (false, true);
        if (updated) {
          localChanged = true;
        }
      }

      // Propagate clue values to entries
      for (var entry in puzzle.entries.values) {
        if (entry.clueId != null) {
          final clue = puzzle.clues[entry.clueId!];
          if (clue != null) {
            if (clue.possibleValues == null) {
              continue; // Skip if clue has no values yet
            }
            final originalCount = clue.possibleValues!.length;
            entry.possibleValues = entry.possibleValues
                .where((value) => clue.possibleValues!.contains(value))
                .toSet();
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

      // Cache to avoid repeated toString calls
      final haveEntryValueStrings = <Entry, bool>{};
      final valueStrings = <int, String>{};
      String getValueString(Entry entry, int value) {
        if (!haveEntryValueStrings.containsKey(entry)) {
          haveEntryValueStrings[entry] = true;
          for (var v in entry.possibleValues) {
            if (!valueStrings.containsKey(v)) {
              valueStrings[v] = v.toString();
            }
          }
        }
        return valueStrings[value]!;
      }

      // Enforce grid constraints
      for (var grid in puzzle.grids.values) {
        for (int r = 0; r < grid.rows; r++) {
          for (int c = 0; c < grid.cols; c++) {
            final cell = grid.cells[r][c];
            if (cell.acrossEntry != null && cell.downEntry != null) {
              final acrossEntry = cell.acrossEntry!;
              if (acrossEntry.skipGridPropagation) continue;
              final downEntry = cell.downEntry!;
              if (downEntry.skipGridPropagation) continue;
              // checkCellEntry(grid, acrossEntry);
              // checkCellEntry(grid, downEntry);
              final acrossDigitIndex = c - acrossEntry.col;
              final downDigitIndex = r - downEntry.row;

              bool crossChanged;
              do {
                crossChanged = false;
                final acrossValues = acrossEntry.possibleValues;
                final downValues = downEntry.possibleValues;

                final newAcrossValues = <int>{};
                for (final acrossValue in acrossValues) {
                  final acrossDigit = getValueString(
                      acrossEntry, acrossValue)[acrossDigitIndex];
                  if (downValues.any((downValue) =>
                      getValueString(downEntry, downValue)[downDigitIndex] ==
                      acrossDigit)) {
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
                  final downDigit =
                      getValueString(downEntry, downValue)[downDigitIndex];
                  if (acrossEntry.possibleValues.any((acrossValue) =>
                      getValueString(
                          acrossEntry, acrossValue)[acrossDigitIndex] ==
                      downDigit)) {
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
            clue.possibleValues = clue.possibleValues!
                .where((value) => entry.possibleValues.contains(value))
                .toSet();
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

  (bool consistent, bool updated) _enforceOrderingConstraints(bool trace) {
    var updated = false;
    for (var constraint in puzzle.orderingConstraints) {
      var expressables = <Expressable>[];
      if (constraint.allClues) {
        expressables = puzzle.clues.values.toList();
      } else if (constraint.allVariables) {
        expressables = puzzle.variables.values.toList();
      } else {
        expressables =
            constraint.ids!.map((id) => puzzle.getExpressable(id)).toList();
      }

      var oldCounts = {
        for (var e in expressables) e.id: e.possibleValues?.length
      };

      bool changedInPass;
      do {
        changedInPass = false;

        // Forward pass
        var prevMin = -1;
        for (var expressable in expressables) {
          if (expressable.possibleValues == null ||
              expressable.possibleValues!.isEmpty) {
            continue;
          }
          var currentMin = expressable.possibleValues!.reduce(min);
          if (prevMin >= 0 && currentMin <= prevMin) {
            final originalLength = expressable.possibleValues!.length;
            expressable.possibleValues =
                expressable.possibleValues!.where((v) => v > prevMin).toSet();
            if (expressable.possibleValues!.isEmpty) return (false, true);
            if (expressable.possibleValues!.length < originalLength) {
              updated = true;
              changedInPass = true;
            }
          }
          if (expressable.possibleValues!.isEmpty) return (false, true);
          prevMin = expressable.possibleValues!.reduce(min);
        }

        // Backward pass
        var nextMax = 1000000; // Arbitrarily large
        for (var expressable in expressables.reversed) {
          if (expressable.possibleValues == null ||
              expressable.possibleValues!.isEmpty) {
            continue;
          }
          var currentMax = expressable.possibleValues!.reduce(max);
          if (nextMax < 1000000 && currentMax >= nextMax) {
            final originalLength = expressable.possibleValues!.length;
            expressable.possibleValues =
                expressable.possibleValues!.where((v) => v < nextMax).toSet();
            if (expressable.possibleValues!.isEmpty) return (false, true);
            if (expressable.possibleValues!.length < originalLength) {
              updated = true;
              changedInPass = true;
            }
          }
          if (expressable.possibleValues!.isEmpty) return (false, true);
          nextMax = expressable.possibleValues!.reduce(max);
        }
      } while (changedInPass);

      if (updated && trace) {
        for (var expressable in expressables) {
          var oldLength = oldCounts[expressable.id];
          if (oldLength != null &&
              expressable.possibleValues != null &&
              expressable.possibleValues!.length < oldLength) {
            _printUpdatedExpressable(expressable, oldLength);
          }
        }
      }
    }
    return (true, updated);
  }

  void _solveUnknownMapping(
      [bool Function()? callback,
      MappingStrategy strategy = MappingStrategy.cluePriority]) {
    if (trace) print('Solving puzzle with unknown mapping...');

    // First, solve as much as possible without any mappings
    _solveKnownMapping(callback, false);

    // Get unmapped clues and available entries
    final unmappedClues =
        puzzle.clues.values.where((c) => c.entry == null).toList();
    final availableEntries =
        puzzle.entries.values.where((e) => e.clueId == null).toList();

    if (traceBacktrace) {
      print(
          'Backtracking mappings: ${unmappedClues.length} clues, ${availableEntries.length} entries');
    }

    // Start backtracking to find a valid mapping
    Expressable.checkAnswer = false;
    trace = traceBacktrace; // Use traceBacktrace for backtracking
    var solutionCount = 0;
    final stopwatch = Stopwatch()..start();

    // Invoke any backtracking constraint logic
    var updated = false;
    for (var constraint in puzzle.puzzleConstraints) {
      constraint.onBacktrackingStart(puzzle, trace: traceBacktrace);
      updated = true;
    }
    if (updated) {
      var (consistent, _) = _propagateConstraints(traceBacktrace);
      if (!consistent) {
        print(
            'Backtracking mappings:     onBacktrackingStart is ${consistent ? 'consistent' : 'inconsistent'}');
        return;
      }
    }
    switch (strategy) {
      case MappingStrategy.cluePriority:
        Map<Clue, List<Entry>> cluePossibleEntries =
            puzzle.getPossibleEntriesForClues(unmappedClues, availableEntries);
        final unmappedCluesSorted = cluePossibleEntries.keys.toList();
        solutionCount = _solveWithBacktrackingByClue(unmappedCluesSorted,
            availableEntries, cluePossibleEntries, solutionCount, callback);
        break;
      case MappingStrategy.entryPriority:
        final entryGroups = _groupEntriesByIntersection(availableEntries);
        Map<Entry, List<Clue>> entryPossibleClues =
            puzzle.getPossibleCluesForEntries(unmappedClues, availableEntries);
        solutionCount = _solveWithBacktrackingByEntry(entryGroups, 0, 0,
            unmappedClues, entryPossibleClues, solutionCount, callback);
        break;
    }

    stopwatch.stop();
    print('Backtracking time: ${stopwatch.elapsedMilliseconds}ms');
    if (solutionCount > 0) {
      print('Backtracking mappings: $solutionCount solution(s) found!');
    } else {
      if (traceBacktrace) print('Backtracking mappings: No solution found.');
    }
  }

  List<List<Entry>> _groupEntriesByIntersection(List<Entry> entries) {
    final adj = <Entry, List<Entry>>{};
    for (var e1 in entries) {
      adj[e1] = [];
      for (var e2 in entries) {
        if (e1 != e2 && e1.intersects(e2)) {
          adj[e1]!.add(e2);
        }
      }
    }

    final groups = <List<Entry>>[];
    final visited = <Entry>{};

    void findGroup(Entry entry, List<Entry> currentGroup) {
      visited.add(entry);
      currentGroup.add(entry);
      if (adj[entry] == null) return; // No neighbors, unlikely!
      var neighbors = adj[entry]!;
      for (var neighbor in neighbors) {
        if (!visited.contains(neighbor)) {
          // Do not follow links to entries with only one other intersection
          var neighborNeighbors =
              adj[neighbor]!.where((n) => n != entry).toList();
          var neighborNeighborsNeighbors =
              neighborNeighbors.expand((e) => adj[e]!).toList();
          var overlap = neighborNeighborsNeighbors
              .firstWhereOrNull((n) => n != neighbor && neighbors.contains(n));
          if (overlap == null) {
            continue;
          }
          // Skip entries with 2 or fewer intersections to avoid chains
          if (adj[neighbor]!.length <= 2) continue;
          findGroup(neighbor, currentGroup);
        }
      }
    }

    for (var entry in entries) {
      if (!visited.contains(entry)) {
        final newGroup = <Entry>[];
        findGroup(entry, newGroup);
        groups.add(newGroup);
      }
    }

    // Sort groups by size descending
    groups.sort((a, b) => b.length.compareTo(a.length));
    return groups;
  }

  int _solveWithBacktrackingByEntry(
    List<List<Entry>> entryGroups,
    int groupIndex,
    int entryIndex,
    List<Clue> availableClues,
    Map<Entry, List<Clue>> entryPossibleClues,
    int solutionCount,
    bool Function()? callback,
  ) {
    if (groupIndex == entryGroups.length) {
      // Base case: All entries have been mapped
      if (isSolutionValid()) {
        if (traceBacktrace) print('Backtracking: Solution found!');
        if (callback != null) {
          if (!callback()) {
            if (traceBacktrace) print('Backtracking: Callback returned false.');
            return solutionCount;
          }
        }
        _printSolution();
        print(
            'Clue mapping: ${puzzle.clues.values.where((c) => c.entry != null).map((clue) => '${clue.id}->${clue.entry!.id}').join(', ')}');
        solutionCount++;
      } else {
        if (traceBacktrace) print('Backtracking: Not a valid solution.');
      }
      return solutionCount;
    }

    final currentGroup = entryGroups[groupIndex];
    final currentEntry = currentGroup[entryIndex];

    if (entryPossibleClues[currentEntry] == null) {
      int nextEntryIndex = entryIndex + 1;
      int nextGroupIndex = groupIndex;
      if (nextEntryIndex == currentGroup.length) {
        nextGroupIndex++;
        nextEntryIndex = 0;
      }
      solutionCount = _solveWithBacktrackingByEntry(
          entryGroups,
          nextGroupIndex,
          nextEntryIndex,
          availableClues,
          entryPossibleClues,
          solutionCount,
          callback);
    } else {
      final matchingClues = entryPossibleClues[currentEntry]!
          .where((clue) => availableClues.contains(clue))
          .toList();

      if (traceBacktrace) {
        print(
            'Backtracking mappings: Trying to map entry ${currentEntry.id} to one of ${matchingClues.length} clues');
      }

      for (final clue in matchingClues) {
        // Map entry to clue
        currentEntry.clueId = clue.id;
        clue.entry = currentEntry;

        // Reduce possible values
        // final intersection =
        //     clue.possibleValues!.intersection(currentEntry.possibleValues);
        // if (intersection.isEmpty) {
        //   currentEntry.clueId = null;
        //   clue.entry = null;
        //   continue;
        // }

        for (final value in clue.possibleValues!) {
          // Check if value is compatible with other set entries
          var consistent = puzzle.grids.values.first
              .isEntryValueCompatibleSolvedEntries(currentEntry, value);
          if (!consistent) {
            if (traceBacktrace) {
              print(
                  'Backtracking mappings:   Value $value for clue ${clue.id} is not compatible with other entries');
            }
            continue;
          }

          final savedState = _saveState();
          clue.possibleValues = {value};
          currentEntry.possibleValues = {value};
          if (traceBacktrace) {
            print(
                'Backtracking mappings:   Trying clue ${clue.id} value $value');
          }

          // var (consistent, _) = _propagateConstraints(traceBacktrace);
          // if (traceBacktrace) {
          //   print(
          //       'Backtracking mappings:     Propagation is ${consistent ? 'consistent' : 'inconsistent'}');
          // }

          if (consistent) {
            final remainingClues =
                availableClues.where((c) => c != clue).toList();
            int nextEntryIndex = entryIndex + 1;
            int nextGroupIndex = groupIndex;
            if (nextEntryIndex == currentGroup.length) {
              nextGroupIndex++;
              nextEntryIndex = 0;
            }
            solutionCount = _solveWithBacktrackingByEntry(
                entryGroups,
                nextGroupIndex,
                nextEntryIndex,
                remainingClues,
                entryPossibleClues,
                solutionCount,
                callback);
          }

          // Backtrack values
          _restoreState(savedState);
        }

        // Backtrack mapping
        currentEntry.clueId = null;
        clue.entry = null;
      }
    }

    return solutionCount;
  }

  /// The recursive backtracking function for solving puzzles with unknown mappings.
  ///
  /// This function tries to map each clue to an available entry and then
  /// recursively calls itself to map the next clue. If a dead end is reached,
  /// it backtracks and tries a different mapping.
  int _solveWithBacktrackingByClue(
    List<Clue> unmappedClues,
    List<Entry> availableEntries,
    Map<Clue, List<Entry>> cluePossibleEntries,
    int solutionCount,
    bool Function()? callback,
  ) {
    if (unmappedClues.isEmpty) {
      // Base case: All expressables assigned. Check if it's a valid solution.
      // All clues have been mapped, now try to solve the puzzle.
      // _solveKnownMapping(callback);
      if (isSolutionValid()) {
        if (traceBacktrace) print('Backtracking: Solution found!');
        if (callback != null) {
          if (!callback()) {
            if (traceBacktrace) print('Backtracking: Callback returned false.');
            return solutionCount; // Stop if callback returns false
          }
        }
        _printSolution();
        // Print mapping
        print(
            'Clue mapping: ${puzzle.clues.values.map((clue) => '${clue.id}->${clue.entry?.id}').join(', ')}');

        solutionCount++;
      } else {
        if (traceBacktrace) print('Backtracking: Not a valid solution.');
      }
      return solutionCount;
    }

    final currentClue = unmappedClues.first;
    final remainingClues = unmappedClues.sublist(1);

    final matchingEntries = cluePossibleEntries[currentClue]!
        .where((entry) => availableEntries.contains(entry))
        .toList();

    if (traceBacktrace) {
      print(
          'Backtracking mappings: Trying to map clue ${currentClue.id} to one of ${matchingEntries.length} entries');
    }

    for (final entry in matchingEntries) {
      if (traceBacktrace) {
        print('Backtracking mappings:   Trying entry ${entry.id}');
      }
      // final savedState = _saveState();

      // Try mapping the current clue to this entry
      entry.clueId = currentClue.id;
      currentClue.entry = entry;

      // Update clue's possible values based on entry length
      // if (currentClue.length == null) {
      //   final min = pow(10, entry.length - 1).toInt();
      //   final max = pow(10, entry.length).toInt() - 1;
      //   if (currentClue.possibleValues != null) {
      //     var originalCount = currentClue.possibleValues!.length;
      //     currentClue.possibleValues = currentClue.possibleValues!
      //         .where((v) => v >= min && v <= max)
      //         .toSet();
      //     if (traceBacktrace) {
      //       print(
      //           'Backtracking mappings:     Clue ${currentClue.id} values reduced from $originalCount to ${currentClue.possibleValues!.length}');
      //     }
      //     if (currentClue.possibleValues!.isEmpty) {
      //       // This mapping is not possible, backtrack
      //       _restoreState(savedState);
      //       entry.clueId = null;
      //       currentClue.entry = null;
      //       continue;
      //     }
      //   }
      // }

      // New check:
      // final intersection =
      //     currentClue.possibleValues!.intersection(entry.possibleValues);
      // if (intersection.isEmpty) {
      //   // This mapping is not possible, backtrack
      //   _restoreState(savedState);
      //   entry.clueId = null;
      //   currentClue.entry = null;
      //   continue;
      // }
      // currentClue.possibleValues = intersection;
      // entry.possibleValues = Set.from(intersection);

      for (final value in currentClue.possibleValues!) {
        // Check if value is compatible with other set entries
        var consistent = puzzle.grids.values.first
            .isEntryValueCompatibleSolvedEntries(entry, value);
        if (!consistent) {
          if (traceBacktrace) {
            print(
                'Backtracking mappings:   Value $value for clue ${currentClue.id} is not compatible with other entries');
          }
          continue;
        }

        final savedState = _saveState();
        currentClue.possibleValues = {value};
        entry.possibleValues = {value};
        if (traceBacktrace) {
          print(
              'Backtracking mappings:   Trying clue ${currentClue.id} value $value');
        }

        // // Propagate constraints
        // var (consistent, _) = _propagateConstraints(traceBacktrace);
        // if (traceBacktrace) {
        //   print(
        //       'Backtracking mappings:     Propagation is ${consistent ? 'consistent' : 'inconsistent'}');
        // }

        if (consistent) {
          final remainingEntries =
              availableEntries.where((e) => e != entry).toList();
          solutionCount = _solveWithBacktrackingByClue(remainingClues,
              remainingEntries, cluePossibleEntries, solutionCount, callback);
        }

        // Backtrack values
        _restoreState(savedState);
      }

      // Backtrack mapping
      entry.clueId = null;
      currentClue.entry = null;
    }

    return solutionCount;
  }

  void checkCellEntry(Grid grid, Entry entry) {
    // Check that the cell entry is a puzzle entry, i.e. not stale
    var entryId = entry.id;
    if (!puzzle.entries.containsKey(entryId)) {
      throw PuzzleException('Cell entry $entryId not in puzzle entries');
    }
  }
}
