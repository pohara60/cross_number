import 'package:collection/collection.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/models/clue_group.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import '../expressions/variable_visitor.dart';
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

  /// A flag indicating whether the mapping between clues and entries is known.
  /// If `true`, the solver will use a direct solving method.
  /// If `false`, the solver will use a backtracking algorithm to find the mapping.
  final bool mappingIsKnown;

  factory PuzzleDefinition.fromString({
    required String name,
    required String gridString,
    required Map<String, Clue> clues,
    required Map<String, Variable> variables,
  }) {
    final grid = Grid.fromString(gridString);
    final Map<String, Entry> entries = {};

    // Extract entries from the grid
    for (var r = 0; r < grid.rows; r++) {
      for (var c = 0; c < grid.cols; c++) {
        final cell = grid.cells[r][c];
        if (cell.acrossEntry != null) {
          var entryId = cell.acrossEntry!.id;
          if (!entries.containsKey(entryId)) {
            entries[entryId] = cell.acrossEntry!;
          }
        }
        if (cell.downEntry != null) {
          var entryId = cell.downEntry!.id;
          if (!entries.containsKey(entryId)) {
            entries[entryId] = cell.downEntry!;
          }
        }
      }
    }

    return PuzzleDefinition(
      name: name,
      grids: {'main': grid}, // Assuming a single grid named 'main'
      entries: entries,
      clues: clues,
      variables: variables,
      mappingIsKnown: true, // Assuming mapping is known from gridString
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
    // Parse all expressions
    var exception = false;
    for (final clue in clues.values) {
      for (final constraint in clue.constraints) {
        if (constraint is ExpressionConstraint) {
          final parser = Parser(constraint.expression);
          try {
            final expression = parser.parse();
            constraint.expressionTree = expression;
            final variableVisitor = VariableVisitor();
            expression.accept(variableVisitor,
                min: 1, max: 1); // min, max not used here
            constraint.variables = variableVisitor.variables.toList();
          } on ParseException catch (e) {
            exception = true;
            print(
                'Error parsing clue ${clue.id} expression "${constraint.expression}": ${e.msg}');
          }
        }
      }
    }
    if (exception) {
      throw PuzzleException('One or more clues could not be parsed.');
    }
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
    for (var variables in variableGroups.keys) {
      final clueIds = variableGroups[variables]!;
      if (clueIds.length > 1) {
        clueGroups
            .add(ClueGroup(clues: clueIds, variables: variables.split(',')));
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
}

/// An error thrown when the parser encounters a syntax error.
class PuzzleException implements Exception {
  String? msg;
  PuzzleException([this.msg]);
}
