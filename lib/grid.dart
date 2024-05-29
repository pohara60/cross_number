import 'package:collection/collection.dart';

import 'clue.dart';
import 'puzzle.dart';
import 'undo.dart';
import 'variable.dart';

class Cell extends Variable {
  final String face;
  final int row, col;
  final entries = <EntryMixin>[];
  final entryDigits = <int>[];

  var _digits = <int>{};
  int get digit => _digits.length == 1 ? _digits.first : 0;
  Set<int> get digits => _digits;
  void set digits(Set<int> digits) {
    UndoStack.push(this);
    digitsNoUndo = digits;
  }

  void set digitsNoUndo(Set<int> digits) {
    if (IterableEquality().equals(_digits, digits)) return;
    _digits = digits;
  }

  Cell(
    this.row,
    this.col, [
    this.face = '',
  ]) : super('$face$row$col');

  String get position => '$row$col';
  String toString() => '$name=$_digits';
  String toDigit() => _digits.length == 1 ? _digits.first.toString() : '?';

  void setDigit(int digit) {
    if (_digits.length == 1 && _digits.first == digit) return;

    UndoStack.push(this);
    _digits = {digit};

    for (var entry in entries) {
      entry.updateValuesFromDigits();
    }
  }

  static const powers = [1, 10, 100, 1000, 10000, 10000];

  void updateDigitsFromEntry(EntryMixin entry) {
    var index = entries.indexWhere((element) => element == entry);
    assert(index >= 0);
    var digit = entryDigits[index];
    var divisor = powers[entry.length! - digit - 1];
    digits = entry.values!.map((value) {
      var result = value;
      if (divisor != 1) result = result ~/ divisor;
      if (digit > 0) result = result % 10;
      return result;
    }).toSet();
  }
}

typedef Cell CellConstructor(int row, int col, String face);

class Grid {
  final Puzzle puzzle;
  final String face;
  final rows = <List<Cell>>[];
  final int numRows;
  final int numCols;
  final entryCells = <String, List<Cell>>{};
  Grid(
    this.puzzle,
    this.numRows,
    this.numCols, [
    this.face = '',
    CellConstructor? constructor,
  ]) {
    rows.addAll(List.generate(
        numRows,
        (row) => List.generate(
            numCols,
            (col) => constructor != null
                ? constructor(row, col, face)
                : Cell(row, col, face))));
  }

  Grid.fromGridSpec(this.puzzle,
      [String this.face = '', CellConstructor? constructor])
      : numRows = puzzle.gridSpec!.cells.length,
        numCols = puzzle.gridSpec!.cells[0].length {
    rows.addAll(List.generate(
        numRows,
        (row) => List.generate(
            numCols,
            (col) => constructor != null
                ? constructor(row, col, face)
                : Cell(row, col, face))));
    var r = 0;
    for (var row in rows) {
      var c = 0;
      for (var cell in row) {
        var cellSpec = puzzle.gridSpec!.cells[r][c];
        if (cellSpec == null) continue;
        if (cellSpec.across != null) {
          var name = cellSpec.across!.name;
          var digit = cellSpec.acrossDigit!;
          cellEntry(cell, name, digit);
        }
        if (cellSpec.down != null) {
          var name = cellSpec.down!.name;
          var digit = cellSpec.downDigit!;
          cellEntry(cell, name, digit);
        }
        c++;
      }
      r++;
    }
  }

  void cellEntry(Cell cell, String name, int digit) {
    var entry = puzzle.allEntries[name] as EntryMixin;
    cell.entries.add(entry);
    cell.entryDigits.add(digit);
    if (!entryCells.containsKey(name)) entryCells[name] = <Cell>[];
    entryCells[name]!.add(cell);

    // Initialise digits
    var digits = entry.digits[digit];
    if (cell.digits.isEmpty) {
      // First entry for cell
      cell.digits = digits;
    } else {
      // Second entry for cell
      var removeDigits = <int>[];
      for (var digit in cell.digits) {
        if (!digits.contains(digit)) removeDigits.add(digit);
      }
      cell.digits.removeAll(removeDigits);
    }
    entry.cells.add(cell);
    if (digit == entry.length! - 1) {
      // Completed entry cells
      entry.hasGrid = true;
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
