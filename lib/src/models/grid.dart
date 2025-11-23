// ignore_for_file: unused_local_variable, prefer_interpolation_to_compose_strings

import 'cell.dart';
import 'entry.dart';

/// Represents the physical grid of a cross number puzzle.
class Grid {
  /// The grid name
  final String name;

  /// The number of rows in the grid.
  final int rows;

  /// The number of columns in the grid.
  final int cols;

  /// The cells of the grid.
  late List<List<Cell>> cells;

  /// The entries in the grid.
  Map<String, Entry> entries = {};

  /// The cells for the entries in the grid
  Map<String, List<Cell>> entryCells = {};

  /// Creates a new grid with the given number of [rows] and [cols].
  Grid(this.rows, this.cols, {this.name = "main"}) {
    cells = List.generate(rows, (_) => List.generate(cols, (_) => Cell()));
  }

  factory Grid.fromString(String gridString, {String name = "main"}) {
    final lines = gridString.split('\n');
    final rows = (lines.length - 1) ~/ 2; // Integer division
    final cols = (lines[0].length - 1) ~/ 3; // Integer division

    final grid = Grid(rows, cols, name: name);

    // Data structures to hold parsed information temporarily
    final List<List<String>> cellContents = []; // 2D array of 2-char strings
    final List<List<String>> horizontalSeparators =
        []; // 2D array of 1-char strings
    final List<List<String>> verticalSeparators =
        []; // 2D array of 2-char strings

    // Parse lines
    // First line is the header, skip it
    // First column is a vertical separator, skip it
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i];
      if (i % 2 == 1) {
        // Cell row
        final List<String> rowCellContents = [];
        final List<String> rowHorizontalSeparators = [];
        for (var j = 1; j < line.length; j += 3) {
          rowCellContents.add(line.substring(j, j + 2).trim());
          if (j + 2 < line.length) {
            rowHorizontalSeparators.add(line.substring(j + 2, j + 3));
          }
        }
        cellContents.add(rowCellContents);
        horizontalSeparators.add(rowHorizontalSeparators);
      } else {
        // Separator row
        final List<String> rowVerticalSeparators = [];
        for (var j = 1; j < line.length; j += 3) {
          rowVerticalSeparators.add(line.substring(j, j + 2));
        }
        verticalSeparators.add(rowVerticalSeparators);
      }
    }

    final actualRows = cellContents.length;
    final actualCols = cellContents.isNotEmpty ? cellContents[0].length : 0;

    // Helper to get cell content at (r, c)
    String getCellContent(int r, int c) {
      return cellContents[r][c];
    }

    // Helper to get horizontal separator after cell (r, c)
    String? getHorizontalSeparator(int r, int c) {
      if (r < horizontalSeparators.length &&
          c < horizontalSeparators[r].length) {
        return horizontalSeparators[r][c];
      }
      return null;
    }

    // Helper to get vertical separator below cell (r, c)
    String? getVerticalSeparator(int r, int c) {
      if (r < verticalSeparators.length && c < verticalSeparators[r].length) {
        return verticalSeparators[r][c];
      }
      return null;
    }

    // Iterate and create entries
    for (var r = 0; r < actualRows; r++) {
      for (var c = 0; c < actualCols; c++) {
        final cellContent = getCellContent(r, c);

        String? acrossLetter;
        String? downLetter;
        int? number;

        if (cellContent.isNotEmpty) {
          // Check if the cell content is a number
          final numValue = int.tryParse(cellContent);
          if (numValue != null) {
            number = numValue;
          } else if (cellContent.length == 1) {
            if (cellContent.toUpperCase() == cellContent) {
              acrossLetter = cellContent;
            } else {
              downLetter = cellContent;
            }
          } else if (cellContent.length == 2) {
            // Assume first char is across, second is down
            if (cellContent[0].toUpperCase() == cellContent) {
              acrossLetter = cellContent[0];
              downLetter = cellContent[1];
            } else {
              acrossLetter = cellContent[1];
              downLetter = cellContent[0];
            }
          }
        }

        // Create Across entry if applicable
        if (acrossLetter != null ||
            number != null && grid.cells[r][c].acrossEntry == null) {
          assert(grid.cells[r][c].acrossEntry == null);
          final entryId = acrossLetter ?? 'A' + cellContent;
          final clueId = acrossLetter != null ? null : cellContent + 'A';
          // Extend length by checking horizontal separators
          int length = 1;
          for (var k = c; k < actualCols - 1; k++) {
            final separator = getHorizontalSeparator(r, k);
            if (separator == ':') {
              length++;
            } else {
              break;
            }
          }
          if (length > 1) {
            final entry = Entry(
              id: entryId,
              row: r,
              col: c,
              length: length,
              orientation: EntryOrientation.across,
              clueId: clueId,
            );
            grid.entries[entry.id] = entry;
            // Assign this entry to all cells it spans
            for (var k = 0; k < length; k++) {
              final cell = grid.cells[r][c + k];
              cell.acrossEntry = entry;
              grid.entryCells.putIfAbsent(entry.id, () => <Cell>[]).add(cell);
            }
          }
        }

        // Create Down entry if applicable
        if (downLetter != null ||
            number != null && grid.cells[r][c].downEntry == null) {
          assert(grid.cells[r][c].downEntry == null);
          final entryId = downLetter ?? 'D' + cellContent;
          final clueId = downLetter != null ? null : cellContent + 'D';
          int length = 1;
          // Extend length by checking vertical separators
          for (var k = r; k < actualRows - 1; k++) {
            final separator = getVerticalSeparator(k, c);
            if (separator == '::') {
              length++;
            } else {
              break;
            }
          }
          if (length > 1) {
            final entry = Entry(
              id: entryId,
              row: r,
              col: c,
              length: length,
              orientation: EntryOrientation.down,
              clueId: clueId,
            );
            grid.entries[entry.id] = entry;
            // Assign this entry to all cells it spans
            for (var k = 0; k < length; k++) {
              final cell = grid.cells[r + k][c];
              cell.downEntry = entry;
              grid.entryCells.putIfAbsent(entry.id, () => <Cell>[]).add(cell);
            }
          }
        }
      }
    }

    return grid;
  }

  /// Populates the grid with the given entries.
  void populate(Map<String, Entry> entries) {
    for (final entry in entries.values) {
      if (entry.id.contains('.')) {
        var gridName = entry.id.split('.').first;
        if (gridName != name) continue;
      }
      if (entry.orientation == EntryOrientation.across) {
        for (int i = 0; i < entry.length; i++) {
          cells[entry.row][entry.col + i].acrossEntry = entry;
        }
      } else if (entry.orientation == EntryOrientation.down) {
        for (int i = 0; i < entry.length; i++) {
          cells[entry.row + i][entry.col].downEntry = entry;
        }
      } else if (entry.orientation == EntryOrientation.up) {
        for (int i = 0; i < entry.length; i++) {
          cells[entry.row - i][entry.col].upEntry = entry;
        }
      }
    }
  }

  Grid copyWith({
    int? rows,
    int? cols,
    List<List<Cell>>? cells,
  }) {
    return Grid(rows ?? this.rows, cols ?? this.cols)
      ..cells = cells ??
          this
              .cells
              .map((row) => row.map((cell) => cell.copyWith()).toList())
              .toList();
  }

  @override
  String toString() {
    const separator = " "; // Alternative is ":"
    var buffer = StringBuffer();
    if (name != "main") buffer.writeln(name);
    for (var r = 0; r < rows; r++) {
      // Draw top border
      buffer.write('+');
      for (var c = 0; c < cols; c++) {
        var cell = cells[r][c];
        var prevCell = c > 0 ? cells[r][c - 1] : null;
        if (cell.downEntry != null &&
            r > 0 &&
            cells[r - 1][c].downEntry == cell.downEntry) {
          buffer.write(' $separator');
        } else {
          buffer.write('--');
        }
        buffer.write('+');
      }
      buffer.writeln();

      for (var c = 0; c < cols; c++) {
        var cell = cells[r][c];
        var prevCell = c > 0 ? cells[r][c - 1] : null;
        if (cell.acrossEntry != null &&
            prevCell != null &&
            prevCell.acrossEntry == cell.acrossEntry) {
          buffer.write(separator);
        } else {
          buffer.write('|');
        }
        var value = ' ';
        if (cell.acrossEntry != null && cell.downEntry != null) {
          // This cell is an intersection
          var acrossEntry = cell.acrossEntry!;
          var downEntry = cell.downEntry!;
          var acrossDigit = '?';
          var downDigit = '?';
          if (acrossEntry.possibleValues.length == 1) {
            acrossDigit = acrossEntry.possibleValues.first
                .toString()[c - acrossEntry.col];
          }
          if (downEntry.possibleValues.length == 1) {
            downDigit =
                downEntry.possibleValues.first.toString()[r - downEntry.row];
          }
          if (acrossDigit == downDigit) {
            value = acrossDigit;
          } else {
            value = '?';
          }
        } else if (cell.acrossEntry != null) {
          var entry = cell.acrossEntry!;
          if (entry.possibleValues.length == 1) {
            value = entry.possibleValues.first.toString()[c - entry.col];
          } else {
            value = '?';
          }
        } else if (cell.downEntry != null) {
          var entry = cell.downEntry!;
          if (entry.possibleValues.length == 1) {
            value = entry.possibleValues.first.toString()[r - entry.row];
          } else {
            value = '?';
          }
        }
        buffer.write(' $value');
      }
      buffer.writeln('|');
    }
    // Draw bottom border
    buffer.write('+' + List.generate(cols, (_) => '--').join('+') + '+');
    return buffer.toString();
  }

  Iterable<int> getDigits() sync* {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        var cell = cells[r][c];
        var prevCell = c > 0 ? cells[r][c - 1] : null;
        var value = 0;
        if (cell.acrossEntry != null && cell.downEntry != null) {
          // This cell is an intersection
          var acrossEntry = cell.acrossEntry!;
          var downEntry = cell.downEntry!;
          var acrossDigit = 0;
          var downDigit = 0;
          if (acrossEntry.isSolved) {
            acrossDigit = int.parse(
                acrossEntry.solution!.toString()[c - acrossEntry.col]);
            value = acrossDigit;
          }
          if (downEntry.isSolved) {
            downDigit =
                int.parse(downEntry.solution!.toString()[r - downEntry.row]);
            value = downDigit;
          }
        } else if (cell.acrossEntry != null) {
          var entry = cell.acrossEntry!;
          if (entry.isSolved) {
            value = int.parse(entry.solution!.toString()[c - entry.col]);
          } else {
            value = 0;
          }
        } else if (cell.downEntry != null) {
          var entry = cell.downEntry!;
          if (entry.isSolved) {
            value = int.parse(entry.solution!.toString()[r - entry.row]);
          } else {
            value = 0;
          }
        }
        yield value;
      }
    }
  }

  int? getDigitsSum() {
    final digits = getDigits();
    var result =
        digits.fold(0, (total, value) => value == 0 ? 0 : total + value);
    if (result == 0) return null;
    return result;
  }

  // Replace grid entry as used when propagating constraints
  void replaceEntry(Entry puzzleEntry) {
    var id = puzzleEntry.id;
    if (id.contains('.')) id = id.split('.').elementAt(1);
    for (final cell in entryCells[id]!) {
      if (cell.acrossEntry?.id == id) cell.acrossEntry = puzzleEntry;
      if (cell.downEntry?.id == id) cell.downEntry = puzzleEntry;
      if (cell.upEntry?.id == id) cell.upEntry = puzzleEntry;
    }
  }

  Set<int> getPossibleDigits(int r, int c) {
    final cell = cells[r][c];
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

  (int, int) getDigitSumRange() {
    int minSum = 0;
    int maxSum = 0;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final digits = getPossibleDigits(r, c);
        if (digits.isNotEmpty) {
          minSum += digits.reduce((a, b) => a < b ? a : b);
          maxSum += digits.reduce((a, b) => a > b ? a : b);
        }
      }
    }
    return (minSum, maxSum);
  }

  bool isEntryValueCompatibleSolvedEntries(Entry entry, int value) {
    var row = entry.row;
    var col = entry.col;
    for (var index = 0; index < entry.length; index++) {
      var r = row;
      var c = col;
      if (entry.orientation == EntryOrientation.down) {
        r += index;
      } else if (entry.orientation == EntryOrientation.across) {
        c += index;
      } else if (entry.orientation == EntryOrientation.up) {
        r -= index;
      }
      var cell = cells[r][c];
      var digit = int.parse(value.toString()[index]);
      var otherEntry = entry.orientation == EntryOrientation.across
          ? cell.downEntry ?? cell.upEntry
          : cell.acrossEntry;
      if (otherEntry != null) {
        if (otherEntry.isSolved) {
          var otherDigit = 0;
          if (otherEntry.orientation == EntryOrientation.across) {
            otherDigit = int.parse(otherEntry.solution!
                .toString()[c - otherEntry.col]);
          } else if (otherEntry.orientation == EntryOrientation.down) {
            otherDigit = int.parse(otherEntry.solution!
                .toString()[r - otherEntry.row]);
          } else if (otherEntry.orientation == EntryOrientation.up) {
            otherDigit = int.parse(otherEntry.solution!
                .toString()[otherEntry.row - r]);
          }
          if (otherDigit != digit) {
            return false;
          }
        }
      }
    }
    return true;
  }
}
