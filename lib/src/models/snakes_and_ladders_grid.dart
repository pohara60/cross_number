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
    final col =
        (9 - row) % 2 == 0 ? (square - 1) % 10 : 9 - ((square - 1) % 10);
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

  Map<int, List<int>> getWinningRolls() {
    final winningRollPaths = <int, List<int>>{};
    final snakes = <int, int>{};
    final ladders = <int, int>{};

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final cell = cells[r][c];
        final square = getSquare(r, c);

        if (cell.downEntry != null) {
          final entry = cell.downEntry!;
          if (entry.row == r && entry.col == c) {
            final start = square;
            final end = getSquare(r + entry.length - 1, c);
            snakes[start] = end;
          }
        }

        if (cell.upEntry != null) {
          final entry = cell.upEntry!;
          if (entry.row == r && entry.col == c) {
            final start = square;
            final end = getSquare(r - entry.length + 1, c);
            ladders[start] = end;
          }
        }
      }
    }
    print('Snakes: $snakes');
    print('Ladders: $ladders');

    final winningRolls = <int>[];
    for (var die = 1; die <= 6; die++) {
      var path = <int>[];
      var position = 0;
      final visited = <int>{};
      while (position < 100) {
        position += die;
        if (snakes.containsKey(position)) {
          position = snakes[position]!;
        } else if (ladders.containsKey(position)) {
          position = ladders[position]!;
        }
        path.add(position);
        if (!visited.add(position)) {
          // Cycle detected
          break;
        }
      }
      if (position == 100) {
        winningRolls.add(die);
        winningRollPaths[die] = path;
      }
    }
    return winningRollPaths;
  }
}
