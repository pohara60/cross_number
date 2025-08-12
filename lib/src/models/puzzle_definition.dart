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

  /// Creates a new puzzle definition with the given components.
  PuzzleDefinition({
    required this.name,
    required this.grids,
    required this.entries,
    required this.clues,
    required this.variables,
    this.mappingIsKnown = true,
  });

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
