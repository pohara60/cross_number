import 'clue.dart';
import 'gridspec.dart';
import 'puzzle.dart';

class Cell {
  final String face;
  final int row, col;
  String get name => '$face$row$col';
  final entries = <Entry>[];
  var digits = <int>{};
  int get digit => digits.length == 1 ? digits.first : 0;

  Cell(
    this.row,
    this.col, [
    this.face = '',
  ]) {
    digits.addAll([1, 2, 3, 4, 5, 6]);
  }

  String get position => '$row$col';
  String toString() => '$name=$digits';
  String toDigit() => digits.length == 1 ? digits.first.toString() : '?';

  void setDigit(int digit) {
    if (digits.length == 1 && digits.first == digit) return;

    // UndoStack.push(this);
    digits = {digit};
  }
}

class Grid {
  final Puzzle puzzle;
  final String face;
  final rows = <List<Cell>>[];
  final int numRows;
  final int numCols;
  Grid(
    this.puzzle,
    this.numRows,
    this.numCols, [
    this.face = '',
  ]) {
    rows.addAll(List.generate(numRows,
        (row) => List.generate(numCols, (col) => Cell(row, col, face))));
  }

  Grid.fromGridSpec(
    this.puzzle,
    GridSpec gridSpec, [
    String this.face = '',
  ])  : numRows = gridSpec.grid.length,
        numCols = gridSpec.grid[0].length {
    rows.addAll(List.generate(numRows,
        (row) => List.generate(numCols, (col) => Cell(row, col, face))));
    var r = 0;
    for (var row in rows) {
      var c = 0;
      for (var cell in row) {
        var cellSpec = gridSpec.cells[r][c];
        if (cellSpec == null) continue;
        if (cellSpec.across != null) {
          cell.entries.add(puzzle.allEntries[cellSpec.across!.label] as Entry);
        }
        if (cellSpec.down != null) {
          cell.entries.add(puzzle.allEntries[cellSpec.down!.label] as Entry);
        }
      }
    }
  }

  String toString() =>
      '${face == '' ? '' : face + '\n'}' +
      this
          .rows
          .map((row) => row.fold('', (str, cell) => str + cell.toDigit()))
          .join('\n');
  int get sumdigits => this.rows.fold(
      0, (value, row) => row.fold(value, (value, cell) => value + cell.digit));
}
