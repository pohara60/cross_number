import 'dart:math';

import '../utils/set.dart';
import 'constraint.dart';
import 'expressable.dart';

/// The orientation of an entry in the grid.
enum EntryOrientation { across, down }

/// Represents a single entry in the cross number grid.
///
/// An entry is a location in the grid where a number can be placed.
/// It has a specific [id], position ([row], [col]), [length], and [orientation].
class Entry extends Expressable {
  /// The unique identifier for the entry (e.g., "A1", "B2").
  @override
  final String id;

  /// The starting row of the entry in the grid (0-based).
  final int row;

  /// The starting column of the entry in the grid (0-based).
  final int col;

  /// The number of digits in the entry.
  final int length;

  /// The orientation of the entry (across or down).
  final EntryOrientation orientation;

  /// The ID of the clue that corresponds to this entry.
  /// This can be null if the mapping is not known initially.
  String? clueId;

  @override
  Set<int> get possibleValues => super.possibleValues!;

  /// The list of constraints that apply to this entry.
  @override
  final List<Constraint> constraints;

  /// Creates a new entry with the given properties.
  Entry({
    required this.id,
    required this.row,
    required this.col,
    required this.length,
    required this.orientation,
    this.clueId,
    this.constraints = const [],
  }) {
    // Initialize possible values based on length
    final min = pow(10, length - 1).toInt();
    final max = pow(10, length).toInt() - 1;
    possibleValues = List<int>.generate(max - min + 1, (i) => i + min).toSet();
  }

  Entry copyWith({
    String? id,
    int? row,
    int? col,
    int? length,
    EntryOrientation? orientation,
    String? clueId,
    Set<int>? possibleValues,
  }) {
    return Entry(
      id: id ?? this.id,
      row: row ?? this.row,
      col: col ?? this.col,
      length: length ?? this.length,
      orientation: orientation ?? this.orientation,
      clueId: clueId ?? this.clueId,
    )..possibleValues = Set<int>.from(possibleValues ?? this.possibleValues);
  }

  @override
  String toString() {
    var b = StringBuffer();
    b.write('$id: ');
    if (expressionTrees.isNotEmpty) {
      b.write(expressionTrees.map((e) => e.toString()).join(', '));
    }
    b.write(' ${possibleValues.length} ${possibleValues.toShortString()}');
    return b.toString();
  }
}
