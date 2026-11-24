import 'package:crossnumber/src/models/entry.dart';

import 'entry_option.dart';

/// A range for a usage count.
class CountRule {
  /// The minimum number of uses.
  final int min;

  /// The maximum number of uses.
  final int max;

  /// Creates a count rule.
  const CountRule(this.min, this.max);

  @override
  String toString() => '$min..$max';
}

/// A clue for a base-aware entry.
sealed class BaseEntryClue {
  const BaseEntryClue();
}

/// No clue is provided for the entry.
class UncluedClue extends BaseEntryClue {
  const UncluedClue();
}

/// The entry has a fixed base-10 value.
class ValueClue extends BaseEntryClue {
  /// The base-10 value.
  final int value;

  const ValueClue(this.value);
}

/// The entry is written in a fixed base.
class BaseClue extends BaseEntryClue {
  /// The base.
  final int base;

  const BaseClue(this.base);
}

/// The entry's digit string is always a square.
class AlwaysSquareClue extends BaseEntryClue {
  const AlwaysSquareClue();
}

/// The middle digit of the entry is a square digit.
class MiddleDigitSquareClue extends BaseEntryClue {
  const MiddleDigitSquareClue();
}

/// The entry's value is not a particular base-10 value.
class NotValueClue extends BaseEntryClue {
  /// The excluded base-10 value.
  final int value;

  const NotValueClue(this.value);
}

/// The entry is not written in a particular base.
class NotBaseClue extends BaseEntryClue {
  /// The excluded base.
  final int base;

  const NotBaseClue(this.base);
}

/// Global rules for a base-aware puzzle.
class BaseGlobalRules {
  /// Bases that must be used exactly the mapped number of times.
  final Map<int, int> exactBaseCounts;

  /// Bases whose usage must lie in the given range.
  final Map<int, CountRule> baseCountRanges;

  /// Square values whose usage must lie in the given range.
  final Map<int, CountRule> valueCountRanges;

  /// The exact number of zero cells in the grid.
  final int zeroCount;

  /// Digits that must appear at least once in the grid.
  final Set<int> requiredDigits;

  /// Whether all entry digit strings must be distinct.
  final bool distinctEntries;

  /// Creates global rules.
  const BaseGlobalRules({
    required this.exactBaseCounts,
    required this.baseCountRanges,
    required this.valueCountRanges,
    required this.zeroCount,
    required this.requiredDigits,
    required this.distinctEntries,
  });
}

/// A definition of a base-aware puzzle.
class BasePuzzleDefinition {
  /// The puzzle name.
  final String name;

  /// The grid in the existing [Grid.fromString] format.
  final String gridString;

  /// Clues keyed by entry id.
  ///
  /// Entries not present in this map are treated as [UncluedClue].
  final Map<String, BaseEntryClue> clues;

  /// The global rules.
  final BaseGlobalRules rules;

  /// Creates a base-aware puzzle definition.
  const BasePuzzleDefinition({
    required this.name,
    required this.gridString,
    required this.clues,
    required this.rules,
  });
}

/// A cell coordinate.
typedef CellCoord = ({int row, int col});

/// A base-aware entry with its geometry and candidate domain.
class BaseEntry {
  /// The entry id, for example `A10` or `D29`.
  final String id;

  /// The entry orientation.
  final EntryOrientation orientation;

  /// The cells covered by the entry.
  final List<CellCoord> cells;

  /// The entry clue.
  final BaseEntryClue clue;

  /// The candidate options for the entry.
  final List<EntryOption> domain;

  /// Creates a base-aware entry.
  const BaseEntry({
    required this.id,
    required this.orientation,
    required this.cells,
    required this.clue,
    required this.domain,
  });

  /// Creates a base-aware entry from an existing geometry-only [Entry].
  factory BaseEntry.fromGeometry(
    Entry entry, {
    required BaseEntryClue clue,
    required List<EntryOption> domain,
  }) {
    final List<CellCoord> cells;
    switch (entry.orientation) {
      case EntryOrientation.across:
        cells = [
          for (var i = 0; i < entry.length; i++) (row: entry.row, col: entry.col + i),
        ];
      case EntryOrientation.down:
        cells = [
          for (var i = 0; i < entry.length; i++) (row: entry.row + i, col: entry.col),
        ];
      case EntryOrientation.up:
        cells = [
          for (var i = 0; i < entry.length; i++) (row: entry.row - i, col: entry.col),
        ];
    }

    return BaseEntry(
      id: entry.id,
      orientation: entry.orientation,
      cells: cells,
      clue: clue,
      domain: domain,
    );
  }
}
