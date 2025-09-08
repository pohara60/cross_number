import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/utils/set.dart';

class ThirtyConstraint extends PuzzleConstraint {
  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) {
    var updated = false;

    var (evenConsistent, evenUpdated) = propagateEvenDigits(puzzle, trace);
    if (!evenConsistent) return (false, updated);
    if (evenUpdated) updated = true;

    var (sumConsistent, sumUpdated) = propagateEqualDigitSum(puzzle, trace);
    if (!sumConsistent) return (false, updated);
    if (sumUpdated) updated = true;

    return (true, updated);
  }

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) {
    return enforceFifteenPairs(puzzle, trace);
  }

  (bool, bool) propagateEvenDigits(PuzzleDefinition puzzle, bool trace) {
    var updated = false;
    final evenDigits = [0, 2, 4, 6, 8];
    final evenDigitString = evenDigits.join('');
    bool isEven(int n) {
      return n.toString().split('').every((d) => evenDigitString.contains(d));
    }

    for (var entry in puzzle.entries.values) {
      final originalCount = entry.possibleValues.length;
      entry.possibleValues.retainWhere((v) => isEven(v));
      if (entry.possibleValues.isEmpty && originalCount > 0) {
        return (false, updated);
      }
      if (entry.possibleValues.length < originalCount) {
        updated = true;
        if (trace) {
          print(
              'ThirtyConstraint: Entry ${entry.id} even digits: $originalCount -> ${entry.possibleValues.length} ${entry.possibleValues.toShortString()}');
        }
      }
    }
    return (true, updated);
  }

  (bool, bool) enforceFifteenPairs(PuzzleDefinition puzzle, bool trace) {
    var updated = false;
    const fifteenPairs = {
      '0,0',
      '0,2',
      '0,4',
      '0,6',
      '0,8',
      '2,2',
      '2,4',
      '2,6',
      '2,8',
      '4,4',
      '4,6',
      '4,8',
      '6,6',
      '6,8',
      '8,8',
    };
    String toPair(int d1, int d2) {
      return d1 <= d2 ? '$d1,$d2' : '$d2,$d1';
    }

    final lGrid = puzzle.grids['L']!;
    final knownPairs = <String>{};
    final unknownCells = <(int, int)>[];
    final allPossiblePairs = <(int, int), Set<String>>{};

    // Identify known and unknown pairs, and all possible pairs for each cell
    for (var r = 0; r < lGrid.rows; r++) {
      for (var c = 0; c < lGrid.cols; c++) {
        final lDigits = _getPossibleDigits(puzzle, 'L', r, c);
        final rDigits = _getPossibleDigits(puzzle, 'R', r, c);
        if (lDigits.isEmpty || rDigits.isEmpty) continue;

        final possiblePairs = <String>{};
        for (var d1 in lDigits) {
          for (var d2 in rDigits) {
            if (fifteenPairs.contains(toPair(d1, d2))) {
              possiblePairs.add(toPair(d1, d2));
            }
          }
        }
        allPossiblePairs[(r, c)] = possiblePairs;

        if (possiblePairs.length == 1) {
          knownPairs.add(possiblePairs.first);
        } else {
          unknownCells.add((r, c));
        }
      }
    }

    if (knownPairs.isNotEmpty) {
      // Restrict unknown pairs
      for (var cellCoords in unknownCells) {
        final r = cellCoords.$1;
        final c = cellCoords.$2;
        final possiblePairs = allPossiblePairs[cellCoords]!;
        final originalCount = possiblePairs.length;
        possiblePairs.removeAll(knownPairs);

        if (possiblePairs.length < originalCount) {
          updated = true;
          // Propagate this back to the digits
          final lDigits = _getPossibleDigits(puzzle, 'L', r, c);
          final rDigits = _getPossibleDigits(puzzle, 'R', r, c);

          final newLDigits = <int>{};
          for (var d1 in lDigits) {
            if (rDigits.any((d2) => possiblePairs.contains(toPair(d1, d2)))) {
              newLDigits.add(d1);
            }
          }
          if (newLDigits.length < lDigits.length) {
            var (consistent, entryUpdated) = _updateEntries(
                puzzle, 'L', r, c, lDigits.difference(newLDigits));
            if (!consistent) return (false, updated);
            if (entryUpdated) updated = true;
          }

          final newRDigits = <int>{};
          for (var d2 in rDigits) {
            if (lDigits.any((d1) => possiblePairs.contains(toPair(d1, d2)))) {
              newRDigits.add(d2);
            }
          }
          if (newRDigits.length < rDigits.length) {
            var (consistent, entryUpdated) = _updateEntries(
                puzzle, 'R', r, c, rDigits.difference(newRDigits));
            if (!consistent) return (false, updated);
            if (entryUpdated) updated = true;
          }
        }
      }
    }

    return (true, updated);
  }

  (bool, bool) propagateEqualDigitSum(PuzzleDefinition puzzle, bool trace) {
    final (minSumL, maxSumL) = _getDigitSumRange(puzzle, 'L');
    final (minSumR, maxSumR) = _getDigitSumRange(puzzle, 'R');

    if (maxSumL < minSumR || maxSumR < minSumL) {
      if (trace) {
        print('ThirtyConstraint: Inconsistent digit sums');
      }
      return (false, false);
    }
    return (true, false);
  }

  Set<int> _getPossibleDigits(
      PuzzleDefinition puzzle, String gridName, int r, int c) {
    final grid = puzzle.grids[gridName]!;
    final cell = grid.cells[r][c];
    Set<int>? acrossDigits;
    if (cell.acrossEntry != null) {
      final entry = cell.acrossEntry!;
      final digitIndex = c - entry.col;
      acrossDigits = entry.possibleValues
          .map((v) => int.parse(v.toString()[digitIndex]))
          .toSet();
    }
    Set<int>? downDigits;
    if (cell.downEntry != null) {
      final entry = cell.downEntry!;
      final digitIndex = r - entry.row;
      downDigits = entry.possibleValues
          .map((v) => int.parse(v.toString()[digitIndex]))
          .toSet();
    }

    if (acrossDigits != null && downDigits != null) {
      return acrossDigits.intersection(downDigits);
    } else if (acrossDigits != null) {
      return acrossDigits;
    } else if (downDigits != null) {
      return downDigits;
    } else {
      // This cell is not part of any entry, so it has no digits.
      // However, in the Thirty puzzle, all cells are part of entries.
      return {};
    }
  }

  (bool, bool) _updateEntries(PuzzleDefinition puzzle, String gridName, int r,
      int c, Set<int> removedDigits) {
    var updated = false;
    final grid = puzzle.grids[gridName]!;
    final cell = grid.cells[r][c];
    final acrossEntry = cell.acrossEntry;
    if (acrossEntry != null) {
      final digitIndex = c - acrossEntry.col;
      final originalCount = acrossEntry.possibleValues.length;
      acrossEntry.possibleValues = acrossEntry.possibleValues
          .where((v) =>
              !removedDigits.contains(int.parse(v.toString()[digitIndex])))
          .toSet();
      if (acrossEntry.possibleValues.isEmpty && originalCount > 0) {
        return (false, updated);
      }
      if (acrossEntry.possibleValues.length < originalCount) {
        updated = true;
      }
    }
    final downEntry = cell.downEntry;
    if (downEntry != null) {
      final digitIndex = r - downEntry.row;
      final originalCount = downEntry.possibleValues.length;
      downEntry.possibleValues = downEntry.possibleValues
          .where((v) =>
              !removedDigits.contains(int.parse(v.toString()[digitIndex])))
          .toSet();
      if (downEntry.possibleValues.isEmpty && originalCount > 0) {
        return (false, updated);
      }
      if (downEntry.possibleValues.length < originalCount) {
        updated = true;
      }
    }
    return (true, updated);
  }

  (int, int) _getDigitSumRange(PuzzleDefinition puzzle, String gridName) {
    int minSum = 0;
    int maxSum = 0;
    final grid = puzzle.grids[gridName]!;
    for (var r = 0; r < grid.rows; r++) {
      for (var c = 0; c < grid.cols; c++) {
        final digits = _getPossibleDigits(puzzle, gridName, r, c);
        if (digits.isNotEmpty) {
          minSum += digits.reduce((a, b) => a < b ? a : b);
          maxSum += digits.reduce((a, b) => a > b ? a : b);
        }
      }
    }
    return (minSum, maxSum);
  }
}
