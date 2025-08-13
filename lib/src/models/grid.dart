// ignore_for_file: unused_local_variable, prefer_interpolation_to_compose_strings

import 'cell.dart';
import 'entry.dart';

/// Represents the physical grid of a cross number puzzle.
class Grid {
  /// The number of rows in the grid.
  final int rows;

  /// The number of columns in the grid.
  final int cols;

  /// The cells of the grid.
  late List<List<Cell>> cells;

  /// Creates a new grid with the given number of [rows] and [cols].
  Grid(this.rows, this.cols) {
    cells = List.generate(rows, (_) => List.generate(cols, (_) => Cell()));
  }

  factory Grid.fromString(String gridString) {
    final lines = gridString.split('\n');
    final rows = (lines.length - 1) ~/ 2; // Integer division
    final cols = (lines[0].length - 1) ~/ 3; // Integer division

    final grid = Grid(rows, cols);

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

        // Check for Across entry start
        if (cellContent.isNotEmpty && grid.cells[r][c].acrossEntry == null) {
          final clueId = cellContent + 'A';
          final entryId = 'A' + cellContent;
          int length = 1;
          // Extend length by checking horizontal separators
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
            // Assign this entry to all cells it spans
            for (var k = 0; k < length; k++) {
              grid.cells[r][c + k].acrossEntry = entry;
            }
          }
        }

        // Check for Down entry start
        if (cellContent.isNotEmpty && grid.cells[r][c].downEntry == null) {
          final clueId = cellContent + 'D';
          final entryId = 'D' + cellContent;
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
            // Assign this entry to all cells it spans
            for (var k = 0; k < length; k++) {
              grid.cells[r + k][c].downEntry = entry;
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
      if (entry.orientation == EntryOrientation.across) {
        for (int i = 0; i < entry.length; i++) {
          cells[entry.row][entry.col + i].acrossEntry = entry;
        }
      } else {
        for (int i = 0; i < entry.length; i++) {
          cells[entry.row + i][entry.col].downEntry = entry;
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
    for (var r = 0; r < rows; r++) {
      // Draw top border
      buffer.write('+');
      for (var c = 0; c < cols; c++) {
        var cell = cells[r][c];
        var prevCell = c > 0 ? cells[r][c - 1] : null;
        if (cell.downEntry != null &&
            r > 0 &&
            cells[r - 1][c].downEntry == cell.downEntry) {
          buffer.write(' $separator ');
        } else {
          buffer.write('---');
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
        buffer.write(' $value ');
      }
      buffer.writeln('|');
    }
    // Draw bottom border
    buffer.write('+' + List.generate(cols, (_) => '---').join('+') + '+');
    return buffer.toString();
  }
}
