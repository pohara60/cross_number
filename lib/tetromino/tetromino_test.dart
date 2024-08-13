import 'package:basics/basics.dart';

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

var grid = [
  ['0', '0', '0', '0', '0', '0', '0', '0'],
  ['0', ' ', ' ', ' ', ' ', ' ', ' ', '0'],
  ['0', ' ', ' ', ' ', ' ', ' ', ' ', '0'],
  ['0', ' ', ' ', ' ', ' ', ' ', ' ', '0'],
  ['0', ' ', ' ', ' ', ' ', ' ', ' ', '0'],
  ['0', ' ', ' ', ' ', ' ', ' ', ' ', '0'],
  ['0', '0', '0', '0', '0', '0', '0', '0'],
];

void main(List<String> args) {
  // printTetrominoes();
  var doneTetrominoe = <List<List<String>>>[];
  var count = 0;
  count = fitTetrominoes(grid, doneTetrominoe, count, 0);
  print('Solution count: $count');
}

int fitTetrominoes(List<List<String>> grid,
    List<List<List<String>>> doneTetrominoe, int count, int holes) {
  // Try to fit (rotated) tetrominoe at next empty character
  var (row, col) = firstSpaceInGrid(grid);
  if (row == -1) return count;
  for (var t1 in tetrominoes) {
    if (doneTetrominoe.contains(t1)) continue;
    for (var t2 in rotations(t1)) {
      // Find first character in tetrominoe
      var (_, offset) = firstNonSpaceInGrid(t2);
      assert(offset >= 0);
      // Does tetrominoe fit?
      if (fitTetrominoe(grid, row, col, t2, offset)) {
        var newGrid = copyGrid(grid);
        if (!fitTetrominoe(newGrid, row, col, t2, offset, copy: true)) {
          assert(false);
        } else {
          doneTetrominoe.add(t1);
          if (doneTetrominoe.length < tetrominoes.length) {
            count = fitTetrominoes(newGrid, doneTetrominoe, count, holes);
          } else {
            // Holes may not have been filled
            for (var r = 0; r < newGrid.length; r++) {
              for (var c = 0; c < newGrid.first.length; c++) {
                if (newGrid[r][c] == ' ') {
                  newGrid[r][c] = '0';
                }
              }
            }
            for (var l in newGrid) {
              print(l.join(''));
            }
            print('----');
            count++;
          }
        }
        doneTetrominoe.removeLast();
      }
    }
  }
  // There are two holes
  if (holes < 2) {
    var newGrid = copyGrid(grid);
    newGrid[row][col] = '0';
    holes++;
    count = fitTetrominoes(newGrid, doneTetrominoe, count, holes);
  }
  return count;
}

bool fitTetrominoe(
    List<List<String>> grid, int row, int col, List<List<String>> t, int offset,
    {bool copy = false}) {
  var width = t.first.length;
  var depth = t.length;
  // transpose
  for (var r = 0; r < depth; r++) {
    for (var c = 0; c < width; c++) {
      if (t[r][c] != ' ') {
        var gcol = col + c - offset;
        var grow = row + r;
        if (gcol < 0 || gcol >= grid.first.length || grid[grow][gcol] != ' ') {
          return false;
        }
        if (copy) {
          grid[grow][gcol] = t[r][c];
        }
      }
    }
  }
  return true;
}

List<List<String>> copyGrid(List<List<String>> grid) {
  return List.generate(
      grid.length,
      (index) => List.generate(
          grid[index].length, (index2) => grid[index][index2].slice()));
}

(int, int) firstSpaceInGrid(List<List<String>> grid) {
  for (var r = 0; r < grid.length; r++) {
    for (var c = 0; c < grid[r].length; c++) {
      if (grid[r][c] == ' ') return (r, c);
    }
  }
  return (-1, -1);
}

(int, int) firstNonSpaceInGrid(List<List<String>> grid) {
  for (var r = 0; r < grid.length; r++) {
    for (var c = 0; c < grid[r].length; c++) {
      if (grid[r][c] != ' ') return (r, c);
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

Iterable<List<List<String>>> rotations(List<List<String>> t) sync* {
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

bool equal(List<List<String>> t1, List<List<String>> t2) {
  if (t1.length != t2.length) return false;
  if (t1.first.length != t2.first.length) return false;
  for (var r = 0; r < t1.length; r++) {
    for (var c = 0; c < t1.first.length; c++) {
      if (t1[r][c] != t2[r][c]) return false;
    }
  }
  return true;
}
