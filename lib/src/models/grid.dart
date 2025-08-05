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
      ..cells = cells ?? this.cells.map((row) => row.map((cell) => cell.copyWith()).toList()).toList();
  }

  @override
  String toString() {
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
          buffer.write(' : ');
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
          buffer.write(':');
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
            acrossDigit =
                acrossEntry.possibleValues.first.toString()[c - acrossEntry.col];
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
    buffer.writeln('+' + List.generate(cols, (_) => '---').join('+') + '+');
    return buffer.toString();
  }
}