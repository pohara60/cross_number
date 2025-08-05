import 'entry.dart';

/// Represents a single cell in the puzzle grid.
class Cell {
  /// The entry that passes through this cell horizontally (if any).
  Entry? acrossEntry;

  /// The entry that passes through this cell vertically (if any).
  Entry? downEntry;

  /// The character representing this cell (e.g., a digit or a block).
  String char = '';

  Cell copyWith({
    Entry? acrossEntry,
    Entry? downEntry,
    String? char,
  }) {
    return Cell()
      ..acrossEntry = acrossEntry ?? this.acrossEntry
      ..downEntry = downEntry ?? this.downEntry
      ..char = char ?? this.char;
  }
}