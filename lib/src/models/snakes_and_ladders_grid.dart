import 'cell.dart';
import 'entry.dart';
import 'grid.dart';

class SnakesAndLaddersGrid extends Grid {
  SnakesAndLaddersGrid(int rows, int cols, {String name = "main"})
      : super(rows, cols, name: name);

  /// Converts a square number (1-100) to a (row, col) coordinate.
  /// The grid is 10x10, and the numbering starts from the bottom left.
  (int, int) getCoordinates(int square) {
    if (square < 1 || square > 100) {
      throw ArgumentError('Square number must be between 1 and 100.');
    }
    final row = 9 - ((square - 1) ~/ 10);
    final col = (9 - row) % 2 == 0
        ? (square - 1) % 10
        : 9 - ((square - 1) % 10);
    return (row, col);
  }

  /// Converts a (row, col) coordinate to a square number.
  int getSquare(int row, int col) {
    if (row < 0 || row > 9 || col < 0 || col > 9) {
      throw ArgumentError('Row and column must be between 0 and 9.');
    }
    final square = (9 - row) * 10 + ((9 - row) % 2 == 1 ? 9 - col : col) + 1;
    return square;
  }

  /// Populates the grid with the given entries.
  @override
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

  @override
  String toString() {
    var buffer = StringBuffer();
    if (name != "main") buffer.writeln(name);
    for (var r = 0; r < rows; r++) {
      // Draw top border
      buffer.write('+');
      for (var c = 0; c < cols; c++) {
        buffer.write('---'); // 3 dashes for 3-digit numbers
        buffer.write('+');
      }
      buffer.writeln();

      for (var c = 0; c < cols; c++) {
        buffer.write('|');
        final cell = cells[r][c];
        var value = getSquare(r, c).toString();
        if (cell.acrossEntry != null && cell.acrossEntry!.isSolved) {
          value = cell.acrossEntry!.solution.toString()[c - cell.acrossEntry!.col];
        } else if (cell.downEntry != null && cell.downEntry!.isSolved) {
          value = cell.downEntry!.solution.toString()[r - cell.downEntry!.row];
        } else if (cell.upEntry != null && cell.upEntry!.isSolved) {
          value = cell.upEntry!.solution.toString()[cell.upEntry!.row - r];
        }
        buffer.write('${value.padLeft(3)}');
      }
      buffer.writeln('|');
    }
    // Draw bottom border
    buffer.write('+' + List.generate(cols, (_) => '---').join('+') + '+');
    buffer.writeln();
    return buffer.toString();
  }
}
