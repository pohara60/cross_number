import 'package:collection/collection.dart';
import 'package:crossnumber/src/models/clue_group.dart';
import 'package:crossnumber/src/models/expressable.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import '../expressions/inverter.dart';
import 'clue.dart';
import 'entry.dart';
import 'grid.dart';
import 'variable.dart';

/// A container for all the components of a cross number puzzle.
///
/// This class brings together the grids, entries, clues, and variables
/// that define a puzzle.
class PuzzleDefinition {
  /// Name
  final String name;

  /// A map of grid IDs to [Grid] objects.
  final Map<String, Grid> grids;

  /// A map of entry IDs to [Entry] objects.
  final Map<String, Entry> entries;

  /// A map of clue IDs to [Clue] objects.
  final Map<String, Clue> clues;

  /// A map of variable names to [Variable] objects.
  final Map<String, Variable> variables;

  /// A map of expressable IDs to [Expressable] objects.
  final Map<String, Expressable> expressables = {};

  /// A flag indicating whether the mapping between clues and entries is known.
  /// If `true`, the solver will use a direct solving method.
  /// If `false`, the solver will use a backtracking algorithm to find the mapping.
  final bool mappingIsKnown;

  factory PuzzleDefinition.fromString({
    required String name,
    required String gridString,
    required Map<String, Clue> clues,
    required Map<String, Variable> variables,
    Map<String, Entry>? entries,
    mappingIsKnown = true,
  }) {
    final grid = Grid.fromString(gridString);
    final Map<String, Entry> gridEntries = {};

    // Extract entries from the grid
    for (var r = 0; r < grid.rows; r++) {
      for (var c = 0; c < grid.cols; c++) {
        final cell = grid.cells[r][c];
        if (cell.acrossEntry != null) {
          var entryId = cell.acrossEntry!.id;
          if (!gridEntries.containsKey(entryId)) {
            gridEntries[entryId] = cell.acrossEntry!;
          }
        }
        if (cell.downEntry != null) {
          var entryId = cell.downEntry!.id;
          if (!gridEntries.containsKey(entryId)) {
            gridEntries[entryId] = cell.downEntry!;
          }
        }
      }
    }

    // If entries provided, validate against grid entries
    if (entries != null) {
      for (var entry in entries.values) {
        if (!gridEntries.containsKey(entry.id)) {
          throw PuzzleException(
              'Entry ${entry.id} not found in grid definition.');
        }
        // Override grid entry with provided entry clue and constraints
        // Keep position, length, orientation from grid
        var gridEntry = gridEntries[entry.id]!;
        gridEntry.clueId = entry.clueId;
        if (entry.constraints.isNotEmpty) {
          gridEntry = gridEntry.copyWith(constraints: entry.constraints);
          gridEntries[entry.id] = gridEntry;
        }
      }
    }

    return PuzzleDefinition(
      name: name,
      grids: {'main': grid}, // Assuming a single grid named 'main'
      entries: gridEntries,
      clues: clues,
      variables: variables,
      mappingIsKnown:
          mappingIsKnown, // Assuming mapping is known from gridString
    );
  }

  /// Creates a new puzzle definition with the given components.
  PuzzleDefinition({
    required this.name,
    required this.grids,
    required this.entries,
    required this.clues,
    required this.variables,
    this.mappingIsKnown = true,
  }) {
    // Set clue entry references where applicable
    for (final clue in clues.values) {
      var entry = entries.values.firstWhereOrNull((e) => e.clueId == clue.id);
      if (entry != null) {
        clue.entry = entry;
      }
    }
    // Check all entries with clues have a matching clue
    var errorEntries = entries.values
        .where(
            (entry) => entry.clueId != null && !clues.containsKey(entry.clueId))
        .toList();
    if (errorEntries.isNotEmpty) {
      throw PuzzleException(
          'Entries with clues not found in clues map: ${errorEntries.map((e) => e.id).join(', ')}');
    }
    // Parse all expressions
    var exception = false;
    final allExpressables = [
      ...clues.values,
      ...variables.values,
      ...entries.values
    ];
    for (final expressable in allExpressables) {
      for (final constraint in expressable.expressionConstraints) {
        if (expressable.addExpression(constraint)) {
          expressables.putIfAbsent(expressable.id, () => expressable);
        } else {
          exception = true;
        }
      }
    }
    // Check all variables are defined for expressables
    // Invert clue expressions for entries
    for (final expressable in List<Expressable>.from(expressables.values)) {
      var index = 0;
      // ignore: unused_local_variable
      for (final constraint in expressable.expressionConstraints) {
        var expressionTree = expressable.expressionTrees[index];
        var variableList = expressable.variableLists[index];
        for (final variable in variableList) {
          if (!clues.containsKey(variable) &&
              !variables.containsKey(variable) &&
              !entries.containsKey(variable)) {
            exception = true;
            print(
                'Variable $variable used in expression for ${expressable.id} is not defined.');
          }
          if (expressable is Clue && entries.containsKey(variable)) {
            var entry = entries[variable]!;
            final inverter =
                ExpressionInverter(expressionTree, expressable, entry);
            final invertedExpression = inverter.invert();
            if (invertedExpression != null) {
              entry.addExpressionFromTree(invertedExpression);
              expressables.putIfAbsent(entry.id, () => entry);
            }
          }
        }
        index++;
      }
    }

    if (exception) {
      throw PuzzleException('One or more clues could not be parsed.');
    }

    print(this);
  }

  List<ClueGroup> findClueGroups() {
    final clueGroups = <ClueGroup>[];
    final clueVariables = <String, List<String>>{};

    // Find variables for each clue
    for (var clue in clues.values) {
      final variables = <String>{};
      for (var constraint in clue.constraints) {
        if (constraint is ExpressionConstraint) {
          variables.addAll(constraint.variables);
        }
      }
      if (variables.isNotEmpty) {
        var sortedVariables = variables.toList()..sort();
        clueVariables[clue.id] = sortedVariables;
      }
    }

    // Group clues by common variables
    final variableGroups = <String, List<String>>{};
    for (var clueId in clueVariables.keys) {
      final variables = clueVariables[clueId]!.join(',');
      variableGroups.putIfAbsent(variables, () => []).add(clueId);
    }

    // Create ClueGroup objects
    for (var group in variableGroups.keys) {
      var variables = group.split(',');
      if (variables.length == 1) continue; // Skip single variable groups
      final clueIds = variableGroups[group]!;
      if (clueIds.length > 1) {
        clueGroups.add(ClueGroup(clues: clueIds, variables: variables));
      }
    }

    return clueGroups;
  }

  PuzzleDefinition copyWith({
    String? name,
    Map<String, Grid>? grids,
    Map<String, Entry>? entries,
    Map<String, Clue>? clues,
    Map<String, Variable>? variables,
    bool? mappingIsKnown,
  }) {
    return PuzzleDefinition(
      name: name ?? this.name,
      grids: grids ??
          this.grids.map((key, value) => MapEntry(key, value.copyWith())),
      entries: entries ??
          this.entries.map((key, value) => MapEntry(key, value.copyWith())),
      clues: clues ??
          this.clues.map((key, value) => MapEntry(key, value.copyWith())),
      variables: variables ??
          this.variables.map((key, value) => MapEntry(key, value.copyWith())),
      mappingIsKnown: mappingIsKnown ?? this.mappingIsKnown,
    );
  }

  @override
  String toString() {
    var b = StringBuffer();
    b.writeln('Puzzle: $name');
    b.writeln('Grids: ${grids.keys}');
    b.writeln('Entries:{');
    for (var entry in entries.values) {
      b.writeln('  $entry');
    }
    b.writeln('}');
    b.writeln('Clues:{');
    for (var clue in clues.values) {
      b.writeln('  $clue');
    }
    b.writeln('}');
    b.writeln('Variables:{');
    for (var variable in variables.values) {
      b.writeln('  $variable');
    }
    b.writeln('}');
    return b.toString();
  }
}

/// An error thrown when the parser encounters a syntax error.
class PuzzleException implements Exception {
  String? msg;
  PuzzleException([this.msg]);
}
