import 'package:crossnumber/src/models/cell.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';

/// A constraint that enforces the Sudoku rules on the puzzle.
/// Rows, Columns and Boxes must contain distinct digits from 1 to 9.

class SudokuConstraint extends PuzzleConstraint {
  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {
    // Remove entries that do not have constraints from the puzzle's entries
    var entriesToRemove =
        puzzle.entries.entries.where((entry) => entry.value.constraints.isEmpty).map((entry) => entry.key).toList();
    for (var entryId in entriesToRemove) {
      puzzle.entries.remove(entryId);
      puzzle.allExpressables.removeWhere((entry) => entry.id == entryId);
    }
    // Remove grid cell references to the removed entries
    for (var r = 0; r < puzzle.grid.rows; r++) {
      for (var c = 0; c < puzzle.grid.cols; c++) {
        var cell = puzzle.grid.cells[r][c];
        if (cell.acrossEntry != null && entriesToRemove.contains(cell.acrossEntry!.id)) {
          cell.acrossEntry = null;
          cell.acrossIndex = 0;
        }
        if (cell.downEntry != null && entriesToRemove.contains(cell.downEntry!.id)) {
          cell.downEntry = null;
          cell.downIndex = 0;
        }
        if (cell.upEntry != null && entriesToRemove.contains(cell.upEntry!.id)) {
          cell.upEntry = null;
          cell.upIndex = 0;
        }
      }
    }
    // Create entries for empty cells in the grid that are not already part of an entry
    for (var r = 0; r < puzzle.grid.rows; r++) {
      for (var c = 0; c < puzzle.grid.cols; c++) {
        var cell = puzzle.grid.cells[r][c];
        if (cell.acrossEntry == null && cell.downEntry == null && cell.upEntry == null) {
          // Compute longest possible length for across and down entries
          // For clarity, entries should not span boxes
          var acrossLength = 0;
          for (var endCol = c;
              endCol < puzzle.grid.cols && puzzle.grid.cells[r][endCol].acrossEntry == null;
              endCol++) {
            if (puzzle.grid.cells[r][endCol].downEntry != null) break;
            if ((endCol ~/ 3) != (c ~/ 3)) break; // Stop if we cross a box boundary
            acrossLength++;
          }
          var downLength = 0;
          for (var endRow = r; endRow < puzzle.grid.rows && puzzle.grid.cells[endRow][c].downEntry == null; endRow++) {
            if (puzzle.grid.cells[endRow][c].acrossEntry != null) break;
            if ((endRow ~/ 3) != (r ~/ 3)) break; // Stop if we cross a box boundary
            downLength++;
          }
          // Make entry of longest length
          if (acrossLength >= downLength) {
            var entryId = 'R${r}C${c}A';
            var entry = Entry(
                id: entryId,
                row: r,
                col: c,
                length: acrossLength,
                orientation: EntryOrientation.across,
                constraints: []);

            puzzle.entries[entryId] = entry;
            puzzle.allExpressables.add(entry);
            for (var i = 0; i < acrossLength; i++) {
              cell = puzzle.grid.cells[r][c + i];
              cell.acrossEntry = entry;
              cell.acrossIndex = i;
            }
          } else {
            var entryId = 'R${r}C${c}D';
            var entry = Entry(
                id: entryId, row: r, col: c, length: downLength, orientation: EntryOrientation.down, constraints: []);

            puzzle.entries[entryId] = entry;
            puzzle.allExpressables.add(entry);
            for (var i = 0; i < downLength; i++) {
              cell = puzzle.grid.cells[r + i][c];
              cell.downEntry = entry;
              cell.downIndex = i;
            }
          }
        }
      }
    }
  }

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) {
    var changed = false;
    // Enforce grid constraints
    for (var grid in puzzle.grids.values) {
      var localChanged = true;
      while (localChanged) {
        localChanged = false;
        for (var region in grid.regions) {
          final (consistent, updated) = propagateRegion(region, trace: trace);
          if (updated) localChanged = true;
          if (!consistent) {
            if (trace) print('    Inconsistency: Grid constraint for row ${region.id} leads to empty possible values.');
            return (false, localChanged);
          }
        }
        changed = changed || localChanged;
      }
    }
    return (true, changed);
  }

  (bool, bool) propagateRegion(Region region, {bool trace = false}) {
    var updated = false;
    // Get known and unknown cells in the region
    var knownValues = <int>{};
    var knownCells = <Cell>[];
    var unknownCells = <Cell>[];
    for (var cell in region.cells) {
      if (cell.value != null) {
        if (knownValues.contains(cell.value)) return (false, updated);
        knownValues.add(cell.value!);
        knownCells.add(cell);
      } else {
        unknownCells.add(cell);
      }
    }
    if (knownValues.isEmpty) return (true, false); // No known values to propagate

    // Remove known value from possible values of unknown cells in the region
    for (var cell in unknownCells) {
      if (cell.removeDigits(knownValues)) updated = true;
    }

    return (true, updated);
  }

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) {
    // Ensure that entry values do not have repeated digits
    var updated = false;
    for (var entry in puzzle.entries.values) {
      if (entry.possibleValues != null) {
        var valuesToRemove = <int>{};
        for (var value in entry.possibleValues!) {
          var digits = value.toString().split('').toSet();
          if (digits.length != entry.length) {
            valuesToRemove.add(value);
          }
        }
        if (valuesToRemove.isNotEmpty) {
          for (var value in valuesToRemove) {
            if (entry.possibleValues!.remove(value)) {
              // if (trace) print('    Removed $value from ${entry.id} due to repeated digits.');
              updated = true;
            }
          }
        }
      }
    }
    return (true, updated);
  }

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) => true;

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}
