import 'dart:math';

import '../utils/set.dart';
import 'constraint.dart';
import 'expressable.dart';

/// The orientation of an entry in the grid.
enum EntryOrientation { across, down, up }

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

  /// Skip grid entry propagation if no clue or expression is attached.
  bool forcePropagation = false;
  bool get skipGridPropagation =>
      clueId == null && expressionTrees.isEmpty && !forcePropagation;

  /// Creates a new entry with the given properties.
  /// The position, length and orientation ,ay come from a grid definition.
  Entry({
    required this.id,
    this.row = 0,
    this.col = 0,
    this.length = 1,
    this.orientation = EntryOrientation.across,
    this.clueId,
    this.constraints = const [],
  }) {
    // Initialize possible values based on length
    final min = pow(10, length - 1).toInt();
    final max = pow(10, length).toInt() - 1;
    possibleValues = List<int>.generate(max - min + 1, (i) => i + min).toSet();
  }

  bool intersects(Entry other) {
    if (orientation == other.orientation) {
      return false;
    }
    if (orientation == EntryOrientation.across) {
      // this is across, other is down or up
      return other.col >= col &&
          other.col < col + length &&
          row >= other.row &&
          row < other.row + other.length;
    } else if (orientation == EntryOrientation.down) {
      // this is down, other is across
      return other.orientation == EntryOrientation.across &&
          col >= other.col &&
          col < other.col + other.length &&
          other.row >= row &&
          other.row < row + length;
    } else {
      // this is up, other is across
      return other.orientation == EntryOrientation.across &&
          col >= other.col &&
          col < other.col + other.length &&
          other.row >= row &&
          other.row < row + length;
    }
  }

  Entry copyWith({
    String? id,
    int? row,
    int? col,
    int? length,
    EntryOrientation? orientation,
    String? clueId,
    Set<int>? possibleValues,
    List<Constraint>? constraints,
  }) {
    return Entry(
      id: id ?? this.id,
      row: row ?? this.row,
      col: col ?? this.col,
      length: length ?? this.length,
      orientation: orientation ?? this.orientation,
      clueId: clueId ?? this.clueId,
      constraints: constraints ?? this.constraints,
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
