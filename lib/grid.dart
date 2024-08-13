import 'package:collection/collection.dart';

import 'clue.dart';
import 'puzzle.dart';
import 'undo.dart';
import 'variable.dart';

typedef Tetromino = List<List<String>>;

class Cell extends Variable {
  final String face;
  final int row, col;
  final entries = <EntryMixin>[];
  final entryDigits = <int>[];

  var _digits = <int>{};
  int get digit => _digits.length == 1 ? _digits.first : 0;
  Set<int> get digits => _digits;
  set digits(Set<int> digits) {
    UndoStack.push(this);
    digitsNoUndo = digits;
  }

  int get entryDigit {
    // Look at entries for digit, used during iteration
    var digit = 0;
    for (var i = 0; i < entries.length; i++) {
      var digits = entries[i].digits[entryDigits[i]];
      if (digits.length > 1) {
        return 0;
      }
      if (digit == 0) {
        digit = digits.first;
      } else if (digit != digits.first) {
        return 0;
      }
    }
    return digit;
  }

  set digitsNoUndo(Set<int> digits) {
    if (IterableEquality().equals(_digits, digits)) return;
    _digits = digits;
  }

  Cell(
    this.row,
    this.col, [
    this.face = '',
  ]) : super('$face$row$col', variableType: VariableType.G);

  String get position => '$row$col';
  @override
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

typedef CellConstructor = Cell Function(int row, int col, String face);

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

  Grid.fromGridSpec(this.puzzle, [this.face = '', CellConstructor? constructor])
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
    if (digit == 0) {
      entry.row = cell.row;
      entry.col = cell.col;
    }
    if (digit == entry.length! - 1) {
      // Completed entry cells
      entry.hasGrid = true;
    }
  }

  @override
  String toString() =>
      '${face == '' ? '' : '$face\n'}${rows.map((row) => row.fold('', (str, cell) => str + cell.toDigit())).join('\n')}';
  int get sumdigits => rows.fold(
      0, (value, row) => row.fold(value, (value, cell) => value + cell.digit));

  List<Cell> getRowCol(int? row, int? col) {
    if (row != null) {
      return rows[row];
    }
    if (col != null) {
      return rows.expand((row) => [row[col]]).toList();
    }
    return [];
  }

  Map<int, int> getDigitCount() {
    var digitCount = <int, int>{};
    for (var row in rows) {
      for (var cell in row) {
        var digits = cell.digits;
        if (digits.length == 1) {
          var digit = digits.first;
          if (!digitCount.containsKey(digit)) digitCount[digit] = 0;
          digitCount[digit] = digitCount[digit]! + 1;
        }
      }
    }
    return digitCount;
  }

  var cellTetromino = <Cell, Tetromino?>{};

  var tetrominoes = [
    [
      ['1', '1', '1', '1'],
    ],
    [
      ['2', '2'],
      ['2', '2'],
    ],
    [
      ['3', '3', '3'],
      [' ', '3', ' '],
    ],
    [
      ['4', '4', '4'],
      ['4', ' ', ' '],
    ],
    [
      ['5', '5', '5'],
      [' ', ' ', '5'],
    ],
    [
      ['6', '6', ' '],
      [' ', '6', '6'],
    ],
    [
      [' ', '7', '7'],
      ['7', '7', ' '],
    ],
  ];

  Iterable<int> fitTetrominoesToGrid() sync* {
    var doneTetrominoe = <Tetromino>[];
    var count = 0;
    yield* fitTetrominoes(doneTetrominoe, count, 0, []);
  }

  int iterationCount = 0;
  Iterable<int> fitTetrominoes(List<Tetromino> doneTetrominoe, int count,
      int holes, List<int> rotationList) sync* {
    iterationCount++;
    // Try to fit (rotated) tetrominoe at next empty character
    var (row, col) = firstSpaceInGrid();
    if (row == -1) return;
    for (var t1 in tetrominoes) {
      if (doneTetrominoe.contains(t1)) continue;
      var rotationCount = 0;
      for (var t2 in rotations(t1)) {
        rotationCount++;
        // Find first character in tetrominoe
        var (_, offset) = firstNonSpaceInTetromino(t2);
        assert(offset >= 0);
        // Does tetrominoe fit?
        if (fitTetromino(row, col, t2, offset)) {
          if (!fitTetromino(row, col, t2, offset, copy: true)) {
            assert(false);
          } else {
            doneTetrominoe.add(t1);
            rotationList.add(rotationCount);
            if (doneTetrominoe.length < tetrominoes.length) {
              yield* fitTetrominoes(doneTetrominoe, count, holes, rotationList);
            } else {
              // print('iterationCount=$iterationCount');
              // print(doneTetrominoe.map((t) => getIndex(t)));
              // print(rotationList);
              // print(tetrominoString());
              // print('------');
              count++;
              yield count;
            }
          }
          fitTetromino(row, col, t2, offset, remove: true);
          doneTetrominoe.removeLast();
          rotationList.removeLast();
        }
      }
    }
    // There are two holes
    if (holes < 2) {
      holes++;
      cellTetromino[rows[row][col]] = null;
      yield* fitTetrominoes(doneTetrominoe, count, holes, rotationList);
      cellTetromino.remove(rows[row][col]);
    }
    return;
  }

  String tetrominoString() {
    var text = rows
        .map((row) => row
            .map((c) =>
                cellTetromino[c] == null ? ' ' : getIndex(cellTetromino[c]!))
            .join(''))
        .join('\n');
    return text;
  }

  bool fitTetromino(int row, int col, Tetromino t, int offset,
      {bool copy = false, bool remove = false}) {
    var width = t.first.length;
    var depth = t.length;
    // transpose
    for (var r = 0; r < depth; r++) {
      for (var c = 0; c < width; c++) {
        if (t[r][c] != ' ') {
          var gcol = col + c - offset;
          var grow = row + r;
          if (remove) {
            cellTetromino.remove(rows[grow][gcol]);
            continue;
          }
          if (gcol < 0 ||
              gcol >= numCols ||
              grow < 0 ||
              grow >= numRows ||
              cellTetromino[rows[grow][gcol]] != null) {
            return false;
          }
          if (copy) {
            cellTetromino[rows[grow][gcol]] = t;
          }
        }
      }
    }
    return true;
  }

  (int, int) firstSpaceInGrid() {
    for (var r = 0; r < numRows; r++) {
      for (var c = 0; c < numCols; c++) {
        if (!cellTetromino.containsKey(rows[r][c])) return (r, c);
      }
    }
    return (-1, -1);
  }

  (int, int) firstNonSpaceInTetromino(Tetromino t) {
    for (var r = 0; r < t.length; r++) {
      for (var c = 0; c < t[r].length; c++) {
        if (t[r][c] != ' ') return (r, c);
      }
    }
    return (-1, -1);
  }

  void printTetrominoes() {
    for (var t1 in tetrominoes) {
      for (var t2 in rotations(t1)) {
        for (var l in t2) {
          print(l.join(''));
        }
        print('----');
      }
    }
  }

  Iterable<Tetromino> rotations(Tetromino t) sync* {
    yield t;
    var last = t;
    var prev = t;
    for (var i = 0; i < 3; i++) {
      var result = <List<String>>[];
      var width = last.first.length;
      var depth = last.length;
      // transpose
      for (var r = 0; r < width; r++) {
        var row = <String>[];
        for (var c = 0; c < depth; c++) {
          row.add(last[depth - c - 1][r]);
        }
        result.add(row);
      }
      if (!equal(result, last) && !equal(result, prev)) {
        yield result;
      }
      prev = last;
      last = result;
    }
  }

  /// 333 .3 .3. 3.
  /// .3. 33 333 33
  /// ... .3 ... 3.

  bool equal(Tetromino t1, Tetromino t2) {
    if (t1.length != t2.length) return false;
    if (t1.first.length != t2.first.length) return false;
    for (var r = 0; r < t1.length; r++) {
      for (var c = 0; c < t1.first.length; c++) {
        if (t1[r][c] != t2[r][c]) return false;
      }
    }
    return true;
  }

  getIndex(Tetromino tetrominoe) {
    return tetrominoe.first.fold(
        ' ',
        (previousValue, element) =>
            previousValue != ' ' ? previousValue : element);
  }
}
