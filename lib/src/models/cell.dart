import 'entry.dart';

/// Represents a single cell in the puzzle grid.
class Cell {
  /// The entry that passes through this cell horizontally (if any).
  Entry? acrossEntry;
  int acrossIndex = 0;

  /// The entry that passes through this cell vertically (if any).
  Entry? downEntry;
  int downIndex = 0;

  /// The entry that passes through this cell vertically (if any).
  Entry? upEntry;
  int upIndex = 0;

  Cell copyWith({
    Entry? acrossEntry,
    int? acrossIndex,
    Entry? downEntry,
    int? downIndex,
    Entry? upEntry,
    int? upIndex,
    String? char,
  }) {
    return Cell()
      ..acrossEntry = acrossEntry ?? this.acrossEntry
      ..downEntry = downEntry ?? this.downEntry
      ..upEntry = upEntry ?? this.upEntry
      ..acrossIndex = acrossIndex ?? this.acrossIndex
      ..downIndex = downIndex ?? this.downIndex
      ..upIndex = upIndex ?? this.upIndex;
  }

  Set<int> get possibleDigits {
    var possibleDigits = <int>{1, 2, 3, 4, 5, 6, 7, 8, 9};
    for (var entry in [acrossEntry, downEntry, upEntry]) {
      if (entry != null && entry.possibleValues != null) {
        possibleDigits =
            possibleDigits.intersection(entry.possibleValues!.map((v) => v.toString()[acrossIndex]).toSet());
      }
    }
    return possibleDigits;
  }

  get value => possibleDigits.length == 1 ? possibleDigits.first : null;

  bool removeDigits(Set<int> knownValues) {
    var updated = false;
    for (var entry in [acrossEntry, downEntry, upEntry]) {
      if (entry != null && entry.possibleValues != null) {
        if (entry.possibleValues!.intersection(knownValues).isNotEmpty) {
          entry.possibleValues!.removeAll(knownValues);
          updated = true;
        }
      }
    }
    return updated;
  }
}
