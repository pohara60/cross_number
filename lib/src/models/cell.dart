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
        var index = entry == acrossEntry
            ? acrossIndex
            : entry == downEntry
                ? downIndex
                : upIndex;
        var entryDigits = entry.possibleValues!.map((v) => int.parse(v.toString()[index])).toSet();
        possibleDigits = possibleDigits.intersection(entryDigits);
      }
    }
    return possibleDigits;
  }

  get value => possibleDigits.length == 1 ? possibleDigits.first : null;

  bool removeDigits(Set<int> digits) {
    var updated = false;
    for (var entry in [acrossEntry, downEntry, upEntry]) {
      if (entry != null && entry.possibleValues != null) {
        var index = entry == acrossEntry
            ? acrossIndex
            : entry == downEntry
                ? downIndex
                : upIndex;
        var valuesToRemove = [];
        for (var value in entry.possibleValues!) {
          var digit = int.parse(value.toString()[index]);
          if (digits.contains(digit)) {
            valuesToRemove.add(value);
          }
        }
        if (valuesToRemove.isNotEmpty) {
          entry.possibleValues!.removeAll(valuesToRemove);
          updated = true;
        }
      }
    }
    return updated;
  }
}
