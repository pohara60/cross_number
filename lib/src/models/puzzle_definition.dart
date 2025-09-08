import 'package:collection/collection.dart';
import 'package:crossnumber/src/models/clue_group.dart';
import 'package:crossnumber/src/models/expressable.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/ordering_constraint.dart';
import '../expressions/inverter.dart';
import 'clue.dart';
import 'entry.dart';
import 'grid.dart';
import 'puzzle_constraint.dart';
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
  bool get isMultiGrid => grids.length > 1;

  /// A map of entry IDs to [Entry] objects.
  final Map<String, Entry> entries;

  /// A map of clue IDs to [Clue] objects.
  final Map<String, Clue> clues;

  /// A map of variable names to [Variable] objects.
  final Map<String, Variable> variables;

  /// A list of ordering constraints.
  final List<OrderingConstraint> orderingConstraints;

  /// A list of puzzle constraints.
  final List<PuzzleConstraint> puzzleConstraints;

  /// All Expressables, i.e. clue, expressions and variables
  final List<Expressable> allExpressables = [];

  /// A map of expressable IDs to [Expressable] objects that have expressions.
  final Map<String, Expressable> expressables = {};

  /// A flag indicating whether the mapping between clues and entries is known.
  /// If `true`, the solver will use a direct solving method.
  /// If `false`, the solver will use a backtracking algorithm to find the mapping.
  final bool mappingIsKnown;

  factory PuzzleDefinition.fromString({
    required String name,
    required String gridString,
    List<String>? gridNames,
    required Map<String, Clue> clues,
    required Map<String, Variable> variables,
    Map<String, Entry>? entries,
    List<OrderingConstraint> orderingConstraints = const [],
    List<PuzzleConstraint> puzzleConstraints = const [],
    mappingIsKnown = true,
  }) {
    final (grids, puzzleEntries) = fromStringInternal(
      name: name,
      gridString: gridString,
      gridNames: gridNames,
      clues: clues,
      variables: variables,
      entries: entries,
      orderingConstraints: orderingConstraints,
      puzzleConstraints: puzzleConstraints,
      mappingIsKnown: mappingIsKnown,
    );
    return PuzzleDefinition(
      name: name,
      grids: grids,
      entries: puzzleEntries,
      clues: clues,
      variables: variables,
      orderingConstraints: orderingConstraints,
      puzzleConstraints: puzzleConstraints,
      mappingIsKnown: mappingIsKnown,
    );
  }

  static (Map<String, Grid> grid, Map<String, Entry> entries)
      fromStringInternal({
    required String name,
    required String gridString,
    List<String>? gridNames,
    required Map<String, Clue> clues,
    required Map<String, Variable> variables,
    Map<String, Entry>? entries,
    List<OrderingConstraint> orderingConstraints = const [],
    List<PuzzleConstraint> puzzleConstraints = const [],
    mappingIsKnown = true,
  }) {
    final Map<String, Grid> grids = {};
    final Map<String, Entry> puzzleEntries = {};

    if (gridNames == null || gridNames.isEmpty) {
      // Backward compatibility: single grid
      final grid = Grid.fromString(gridString);
      grids['main'] = grid;
      final gridEntries = grid.entries;
      if (entries != null) {
        for (var entry in entries.values) {
          if (!gridEntries.containsKey(entry.id)) {
            throw PuzzleException(
                'Entry ${entry.id} not found in grid definition.');
          }
          // Override entry with grid entry position, length, orientation
          var gridEntry = gridEntries[entry.id]!;
          var puzzleEntry = updateEntry(entry, gridEntry, grid);
          puzzleEntries[entry.id] = puzzleEntry;
        }
        // Check all grid entries are provided, add any missing ones
        var additionalEntries = gridEntries.values
            .where((entry) => !puzzleEntries.containsKey(entry.id))
            .toList();
        for (var entry in additionalEntries) {
          entry.clueId = null; // Ensure no default clue mapping
          puzzleEntries[entry.id] = entry;
        }
      } else {
        puzzleEntries.addAll(gridEntries);
      }
    } else {
      // Multiple grids
      final Map<String, Entry> gridEntries = {};
      for (var gridName in gridNames) {
        final grid = Grid.fromString(gridString, name: gridName);
        grids[gridName] = grid;
        for (var entry in grid.entries.values) {
          final prefixedId = '$gridName.${entry.id}';
          gridEntries[prefixedId] = entry.copyWith(id: prefixedId);
        }
      }

      if (entries != null) {
        for (var entry in entries.values) {
          if (!gridEntries.containsKey(entry.id)) {
            throw PuzzleException(
                'Entry ${entry.id} not found in grid definitions.');
          }
          var gridEntry = gridEntries[entry.id]!;
          var grid = grids[gridEntry.id.split('.').first]!;
          var puzzleEntry = updateEntry(entry, gridEntry, grid);
          puzzleEntries[entry.id] = puzzleEntry;
        }
        // Add any grid entries that were not in the provided entries
        var additionalEntries = gridEntries.values
            .where((entry) => !puzzleEntries.containsKey(entry.id))
            .toList();
        for (var entry in additionalEntries) {
          entry.clueId = null; // Ensure no default clue mapping
          puzzleEntries[entry.id] = entry;
          puzzleEntries[entry.id] = entry;
        }
      } else {
        puzzleEntries.addAll(gridEntries);
      }
    }
    return (grids, puzzleEntries);
  }

  /// Creates a new puzzle definition with the given components.
  PuzzleDefinition({
    required this.name,
    required this.grids,
    required this.entries,
    required this.clues,
    required this.variables,
    this.orderingConstraints = const [],
    this.puzzleConstraints = const [],
    this.mappingIsKnown = true,
  }) {
    var exception = false;
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
      exception = true;
      print(
          'Entries with clues not found in clues map: ${errorEntries.map((e) => e.id).join(', ')}');
    }
    // If multi-grid, then entries and linked clues must have grid prefix
    for (final entry in entries.values) {
      if (checkGridReference('Entry', entry.id)) exception = true;
      if (entry.clueId != null && entry.clueId!.isNotEmpty) {
        if (checkGridReference('Entry ${entry.id} Clue', entry.clueId!)) {
          exception = true;
        }
      }
    }
    // Parse all expressions
    allExpressables.addAll(clues.values);
    allExpressables.addAll(variables.values);
    allExpressables.addAll(entries.values);
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
    // Invert entry expressions for other entries that do not have expressions
    final entriesWithExpressions = entries.values
        .where((e) => e.expressionTrees.isNotEmpty)
        .map((e) => e.id)
        .toList();
    for (final expressable in List<Expressable>.from(expressables.values)) {
      var index = 0;
      // ignore: unused_local_variable
      for (final constraint in expressable.expressionConstraints) {
        var expressionTree = expressable.expressionTrees[index];
        var variableList = expressable.variableLists[index];
        for (final variable in variableList) {
          try {
            getExpressable(variable);
          } on PuzzleException {
            exception = true;
            print(
                'Variable $variable used in expression for ${expressable.id} is not defined.');
          }

          // if (expressable is Clue && entries.containsKey(variable)) {
          if (entries.containsKey(variable) &&
              !entriesWithExpressions.contains(variable)) {
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

  bool checkGridReference(String type, String name) {
    var exception = false;
    if (name.contains('.')) {
      final names = name.split('.');
      if (!grids.containsKey(names[0])) {
        exception = true;
        print('$type $name has unknown grid prefix ${names[0]}');
      }
    } else if (isMultiGrid) {
      exception = true;
      print('$type $name should have grid prefix');
    }
    return exception;
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
    List<OrderingConstraint>? orderingConstraints,
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
      orderingConstraints: orderingConstraints ?? this.orderingConstraints,
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

  /// For each clue in [unmappedClues], find the list of possible entries
  /// from [availableEntries] that match the clue's length and constraints.
  Map<Clue, List<Entry>> getPossibleEntriesForClues(
      List<Clue> unmappedClues, List<Entry> availableEntries) {
    final Map<Clue, List<Entry>> cluePossibleEntries = {};
    for (var clue in unmappedClues) {
      var matchAcross = clue.id.startsWith('A') || clue.id.endsWith('A');
      var matchDown = clue.id.startsWith('D') || clue.id.endsWith('D');
      if (!matchDown && !matchAcross) {
        // No heuristic mapping
        matchAcross = true;
        matchDown = true;
      }
      final possibleEntries = availableEntries.where((entry) {
        // Check orientation
        if (!(matchAcross && entry.orientation == EntryOrientation.across ||
            matchDown && entry.orientation == EntryOrientation.down)) {
          return false;
        }
        // Check possible values, if known
        if (clue.possibleValues != null) {
          assert(entry.possibleValues.isNotEmpty);
          if (clue.possibleValues!.intersection(entry.possibleValues).isEmpty) {
            return false;
          }
        } else {
          // If entry has no possible values, but clue does, filter by length
          if (!clue.possibleValues!
              .any((v) => v.toString().length == entry.length)) {
            return false;
          }
        }
        return true;
      }).toList();
      assert(possibleEntries.isNotEmpty);
      cluePossibleEntries[clue] = possibleEntries;
    }
    // Order the map by number of entries (fewest first)
    var sortedEntries = cluePossibleEntries.entries.toList()
      ..sort((a, b) => a.value.length.compareTo(b.value.length));
    cluePossibleEntries
      ..clear()
      ..addEntries(sortedEntries);
    return cluePossibleEntries;
  }

  /// For each entry in [availableEntries], find the list of possible clues
  /// from [unmappedClues] that match the entry's length and constraints.
  Map<Entry, List<Clue>> getPossibleCluesForEntries(
      List<Clue> unmappedClues, List<Entry> availableEntries) {
    final Map<Entry, List<Clue>> entryPossibleClues = {};
    for (var entry in availableEntries) {
      final possibleClues = <Clue>[];
      for (var clue in unmappedClues) {
        var matchAcross = clue.id.startsWith('A') || clue.id.endsWith('A');
        var matchDown = clue.id.startsWith('D') || clue.id.endsWith('D');
        if (!matchDown && !matchAcross) {
          // No heuristic mapping
          matchAcross = true;
          matchDown = true;
        }
        // Check orientation
        if (!(matchAcross && entry.orientation == EntryOrientation.across ||
            matchDown && entry.orientation == EntryOrientation.down)) {
          continue;
        }
        // Filter by length if available
        if (clue.length != null && clue.length! != entry.length) {
          continue;
        }
        // Check possible values, if known
        if (clue.possibleValues != null) {
          assert(entry.possibleValues.isNotEmpty);
          if (clue.possibleValues!.intersection(entry.possibleValues).isEmpty) {
            continue;
          }
        }
        possibleClues.add(clue);
      }
      if (possibleClues.isEmpty) continue;
      entryPossibleClues[entry] = possibleClues;
    }
    // Order the map by number of clues (fewest first)
    var sortedEntries = entryPossibleClues.entries.toList()
      ..sort((a, b) => a.value.length.compareTo(b.value.length));
    entryPossibleClues
      ..clear()
      ..addEntries(sortedEntries);
    return entryPossibleClues;
  }

  Expressable getExpressable(String expressableName) {
    if (expressableName.contains('.')) {
      // Grid-specific reference
      var expressable = entries[expressableName] ?? clues[expressableName];
      if (expressable != null) return expressable;
    }

    // Non-prefixed reference
    var expressable = variables[expressableName] as Expressable?;
    expressable ??= clues[expressableName];
    expressable ??= entries[expressableName];

    // Backward compatibility for single-grid puzzles
    if (expressable == null &&
        grids.length == 1 &&
        grids.keys.first == 'main') {
      // Already checked entries and clues without prefix
    }

    if (expressable == null) {
      throw PuzzleException('Expressable $expressableName not found.');
    }
    return expressable;
  }

  bool isSolutionValid() {
    // Check if all expressables have a single value
    return allExpressables.every((expressable) => expressable.isSolved);
  }

  static Entry updateEntry(Entry entry, Entry gridEntry, Grid grid) {
    var puzzleEntry = entry.copyWith(
      row: gridEntry.row,
      col: gridEntry.col,
      length: gridEntry.length,
      orientation: gridEntry.orientation,
      possibleValues: gridEntry.possibleValues,
    );
    grid.replaceEntry(puzzleEntry);
    return puzzleEntry;
  }
}

/// An error thrown when the parser encounters a syntax error.
class PuzzleException implements Exception {
  String? msg;
  PuzzleException([this.msg]);
}
