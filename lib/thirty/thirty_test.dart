import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';

import '../clue.dart';
import '../monadic.dart';

class UndoStack {
  static final undoIndex = <int>[];
  static var undoTop = 0;
  static final undoObject = <Object>[];
  static final undoValue = <Set<int>>[];

  static void begin() {
    undoIndex.add(undoTop);
  }

  static void push(Object object) {
    undoObject.add(object);
    Set<int> set = {};
    if (object is Cell)
      set = object.digits;
    else if (object is Clue)
      set = object.values;
    else if (object is int)
      ;
    else
      throw Exception();
    undoValue.add(set);
    undoTop++;
  }

  static void undo() {
    var oldTop = undoIndex.removeLast();
    while (undoTop > oldTop) {
      undoTop--;
      var object = undoObject.removeLast();
      var set = undoValue.removeLast();
      if (object is Cell)
        object.digits = set;
      else if (object is Clue)
        object._values = set;
      else if (object is int)
        knownValues.remove(object);
      else
        throw Exception();
    }
  }
}

class SolveException implements Exception {
  final String msg;
  SolveException(this.msg);
}

var knownValues = <int, Clue?>{};
void addKnownValue(Clue clue, int value) {
  UndoStack.push(value);
  knownValues[value] = clue;
}

var pairs = SplayTreeMap<int, int>();

void initPairs() {
  for (var i = 0; i < 9; i += 2) {
    for (var j = 0; j <= i; j += 2) {
      var pair = j * 10 + i;
      pairs[pair] = -1;
    }
  }
}

int getPairValue(int i, int j) {
  if (i <= j)
    return i * 10 + j;
  else
    return j * 10 + i;
}

(int, int) getValuePair(int value) {
  var p1 = value ~/ 10;
  var p2 = value % 10;
  return (p1, p2);
}

class Cell {
  final String face;
  final int row, col;
  String get name => '$face$row$col';
  final clues = <Clue>[];
  var digits = <int>{};
  int get digit => digits.length == 1 ? digits.first : -1;

  Cell(
    this.face,
    this.row,
    this.col,
  ) {
    digits.addAll([0, 2, 4, 6, 8]);
  }

  String get position => '$row$col';

  set faces(Set<Cell> faces) {}

  Set<int> getNewDigits(Set<int> digits, Set<int> validDigits) {
    Function eq = const SetEquality().equals;
    if (digits.length == validDigits.length && eq(digits, validDigits))
      return digits;
    var newDigits = <int>{};
    for (var digit in digits) {
      if (validDigits.contains(digit)) newDigits.add(digit);
    }
    if (newDigits.length == digits.length) return digits;
    return newDigits;
  }

  Set<Clue> updateDigits(Set<int> validDigits, [bool doUpdateFaces = true]) {
    var newDigits = getNewDigits(digits, validDigits);
    if (newDigits == digits) return {};
    return updateNewDigits(newDigits, doUpdateFaces);
  }

  Set<Clue> updateNewDigits(Set<int> newDigits, [bool doUpdateFaces = true]) {
    if (newDigits == digits) return {};
    if (newDigits.isEmpty) throw SolveException('Cell $name no digits');
    UndoStack.push(this);
    digits = newDigits;
    var updatedClues = <Clue>{...clues};
    if (doUpdateFaces) updatedClues.addAll(updateFaces());
    return updatedClues;
  }

  Set<Clue> updateFaces() {
    var updatedClues = <Clue>{};
    return updatedClues;
  }

  String toString() => '$name=$digits';
  String toDigit() => digits.length == 1 ? digits.first.toString() : '?';

  void setDigit(int digit) {
    // Optimised for backtracking, in puzzle order
    if (digits.length == 1 && digits.first == digit) return;

    UndoStack.push(this);
    digits = {digit};
  }

  List<Clue> knownClues() {
    var known = <Clue>[];
    clueLoop:
    for (var clue in clues) {
      for (var cell in clue.cells) {
        if (cell.digits.length > 1) continue clueLoop;
      }
      known.add(clue);
    }
    return known;
  }
}

class Grid {
  final String face;
  final rows = <List<Cell>>[];
  final int nRows;
  final int nCols;
  Grid(
    this.face,
    this.nRows,
    this.nCols,
  ) {
    rows.addAll(List.generate(nRows,
        (row) => List.generate(nCols, (col) => Cell(face[0], row, col))));
  }
  String toString() =>
      '$face\n' +
      this
          .rows
          .map((row) => row.fold('', (str, cell) => str + cell.toDigit()))
          .join('\n');
  int get sumdigits => this.rows.fold(
      0, (value, row) => row.fold(value, (value, cell) => value + cell.digit));
}

class Clue {
  final String face;
  final String name;
  bool get isAcross => name[0] == 'A';
  bool get isDown => name[0] == 'D';
  late final int row, col;
  var _values = <int>{};
  Set<int> get values => _values;
  int get value => values.length == 1 ? values.first : 0;
  void set value(int value) {
    values = {value};
  }

  void set values(Set<int> values) {
    UndoStack.push(this);
    _values = Set.from(values);
    // Update digits
    var valueDigits = List.generate(length, (i) => <int>{});
    for (var value in _values) {
      for (var i = 1; i <= length; i++) {
        valueDigits[length - i].add(value % 10);
        value = value ~/ 10;
      }
    }

    var updatedClues = <Clue>{};
    for (var i = 0; i < length; i++) {
      var clues = cells[i].updateDigits(valueDigits[i]);
      updatedClues.addAll(clues);
    }
    updatedClues.remove(this);

    for (var otherClue in updatedClues) {
      otherClue.filterValuesByDigits();
    }
  }

  final int length;
  //late final Set<int> digits;
  final cells = <Cell>[];

  Clue(this.face, this.name, this.row, this.col, this.length, Grid grid) {
    var r = row;
    var c = col;
    for (var i = 0; i < length; i++) {
      var cell = grid.rows[r][c];
      if (i == 0) cell.digits.remove(0);
      cells.add(cell);
      cell.clues.add(this);
      if (isAcross)
        c++;
      else
        r++;
    }
  }

  final identityDigit = <int>[];
  final identityOtherClue = <Clue>[];
  final identityOtherDigit = <int>[];
  void addIdentity(int digit, Clue otherClue, int otherDigit,
      [bool symmetric = true]) {
    assert(!identityDigit.contains(digit));
    identityDigit.add(digit);
    identityOtherClue.add(otherClue);
    identityOtherDigit.add(otherDigit);
    if (symmetric) otherClue.addIdentity(otherDigit, this, digit, false);
  }

  void filterValuesByDigits() {
    if (_values.isEmpty) return;
    var newValues = Set<int>.from(_values);
    var allOk = true;
    for (var value in _values) {
      var ok = true;
      for (var i = 0; i < length; i++) {
        var digit = value % 10;
        if (!cells[i].digits.contains(digit)) {
          ok = false;
          allOk = false;
          break;
        }
        value = value ~/ 10;
      }
      if (ok) newValues.add(value);
    }
    if (newValues.isEmpty) throw SolveException('Clue $name no values');
    if (!allOk) values = newValues;
  }

  String toString() => '$face$name';

  int getValueFromDigits() {
    var value = 0;
    for (var i = 0; i < length; i++) {
      var digit = cells[i].digit;
      if (digit == -1) return 0;
      value = value * 10 + digit;
    }
    return value;
  }
}

class Puzzle {
  final String name;
  final Grid grid;
  Puzzle(
    this.name,
    this.grid,
  );
  final clues = <String, Clue>{};

  String toString() => 'Puzzle $grid';
}

final puzzles = <String, Puzzle>{};
const puzzleNames = ['Left', 'Right'];
var allClues = <String, Clue>{};

void main() {
  final clueFaces = <String, List<Clue>>{};
  final cellFaces = <String, Set<Cell>>{};
  for (var name in puzzleNames) {
    final grid = Grid(name, 3, 5);
    var puzzle = puzzles[name] = Puzzle(
      name,
      grid,
    );
    Clue addClue(puzzle, clue) {
      puzzle.clues[clue.name] = clue;
      allClues[clue.face + clue.name] = clue;
      if (!clueFaces.containsKey(clue.name)) clueFaces[clue.name] = [];
      clueFaces[clue.name]!.add(clue);
      for (var cell in clue.cells) {
        if (!cellFaces.containsKey(cell.position)) {
          cellFaces[cell.position] = {};
          cell.faces = cellFaces[cell.position]!;
        }
        cellFaces[cell.position]!.add(cell);
      }
      return clue;
    }

    var a1 = addClue(puzzle, Clue(name[0], 'A1', 0, 0, 3, grid));
    var a3 = addClue(puzzle, Clue(name[0], 'A3', 0, 3, 2, grid));
    var a5 = addClue(puzzle, Clue(name[0], 'A5', 1, 1, 3, grid));
    var a7 = addClue(puzzle, Clue(name[0], 'A7', 2, 0, 2, grid));
    var a8 = addClue(puzzle, Clue(name[0], 'A8', 2, 2, 3, grid));
    var d1 = addClue(puzzle, Clue(name[0], 'D1', 0, 0, 3, grid));
    var d2 = addClue(puzzle, Clue(name[0], 'D2', 0, 1, 3, grid));
    var d3 = addClue(puzzle, Clue(name[0], 'D3', 0, 3, 3, grid));
    var d4 = addClue(puzzle, Clue(name[0], 'D4', 0, 4, 3, grid));
    var d6 = addClue(puzzle, Clue(name[0], 'D6', 1, 2, 2, grid));
    a1.addIdentity(0, d1, 0);
    a1.addIdentity(1, d2, 0);
    a3.addIdentity(0, d3, 0);
    a3.addIdentity(1, d4, 0);
    a5.addIdentity(0, d2, 1);
    a5.addIdentity(1, d6, 0);
    a5.addIdentity(2, d3, 1);
    a7.addIdentity(0, d1, 2);
    a7.addIdentity(1, d2, 2);
    a8.addIdentity(0, d6, 1);
    a8.addIdentity(1, d3, 2);
    a8.addIdentity(2, d4, 2);
  }

  printPuzzles("Init");
  // puzzles['Top']!.clues['A7']!.value = 1444;

  // Known constraints
  for (var name in ['Left', 'Right']) {
    var puzzle = puzzles[name]!;
    puzzle.clues['A3']!.values = {22, 24, 26, 42, 44};
    puzzle.clues['A7']!.values = {20, 24, 26, 40};
    puzzle.clues['A8']!.values = {440, 480, 624, 840, 880};
  }
  // One value of A8 does not end in 0, 624 = 24*26
  puzzles['Left']!.clues['A8']!.values = {624};
  puzzles['Left']!.clues['A3']!.values = {24, 26};
  puzzles['Left']!.clues['A7']!.values = {24, 26};

  // Backtrack solution of the two grids
  initPairs();
  var count = backtrackPuzzleCell(puzzles, 0, 0, 0);
  print('Solution count $count');
}

void printPuzzles(String heading) {
  print(heading);
  for (var name in ['Left', 'Right']) {
    var puzzle = puzzles[name];
    print(puzzle);
  }
}

Stopwatch? stopwatch;

int backtrackPuzzleCell(
    Map<String, Puzzle> puzzles, int count, int row, int col) {
  if (stopwatch == null) {
    stopwatch = Stopwatch()..start();
  }
  var puzzle1 = puzzles['Left']!;
  var nRows = puzzle1.grid.nRows;
  if (row == nRows) {
    if (!checkPuzzle()) return count;
    // Solution
    count++;
    printPuzzles('Solution $count');
    return count;
  }

  // Try cell
  // var cell = Puzzle.fromGridString.rows[row][col];
  // Reverse order
  var pairKeys = pairs.keys;
  for (var pair in pairKeys) {
    if (pairs[pair] != -1) continue;
    // checkProgress('${puzzle.name} $row $col $digit');

    // Try pair in this cell
    var (p1, p2) = getValuePair(pair);
    pushProgress(p1, p2);
    count = backtrackPuzzleCellValues(puzzles, count, row, col, p1, p2);
    if (p1 != p2) {
      count = backtrackPuzzleCellValues(puzzles, count, row, col, p2, p1);
    }
    popProgress();
  }
  return count;
}

int backtrackPuzzleCellValues(
    Map<String, Puzzle> puzzles, int count, int row, int col, int p1, int p2) {
  var puzzle1 = puzzles['Left']!;
  var puzzle2 = puzzles['Right']!;
  var nRows = puzzle1.grid.nRows;
  var nCols = puzzle1.grid.nCols;

  // Reverse order as A7 and A8 are restricted
  var cell1 = puzzle1.grid.rows[nRows - row - 1][nCols - col - 1];
  var cell2 = puzzle2.grid.rows[nRows - row - 1][nCols - col - 1];
  if (cell1.digits.contains(p1) && cell2.digits.contains(p2)) {
    UndoStack.begin();
    cell1.setDigit(p1);
    cell2.setDigit(p2);
    pairs[getPairValue(p1, p2)] = EntryMixin.cellIndex(row, col);

    // Check known clue values
    if (checkKnownValues(cell1) && checkKnownValues(cell2)) {
      // Continue with next cell
      var newRow = row;
      var newCol = col + 1;
      if (newCol == nCols) {
        newRow++;
        newCol = 0;
      }
      count = backtrackPuzzleCell(puzzles, count, newRow, newCol);
    }

    pairs[getPairValue(p1, p2)] = -1;
    UndoStack.undo();
  }
  return count;
}

bool checkKnownValues(Cell cell) {
  var ok = true;
  var clues = cell.knownClues();
  for (var clue in clues) {
    var value = clue.getValueFromDigits();
    if (knownValues[value] != null && knownValues[value] != clue) return false;
    if (knownValues.containsKey(value)) continue;

    // Check for Jumble
    for (var jumbleValue in jumble(value)) {
      var knownClue = knownValues[jumbleValue];
      if (knownClue != null) return false;
    }
    // New known value
    addKnownValue(clue, value);
  }

  return ok;
}

bool checkPuzzle() {
  var ok = true;
  if (ok) ok = checkClue('LA1', "1ac = 1dn+ 3ac, both from the opposite grid");
  if (ok) ok = checkClue('RA1', "1ac = 1dn+ 3ac, both from the opposite grid");
  if (ok) ok = checkClue('LA8', "8ac = 3ac x 7ac, both from the same grid");
  if (ok) ok = checkClue('RA8', "8ac = 3ac x 7ac, both from the same grid");
  if (ok) {
    // Check sum of digits
    var sum1 = puzzles['Left']!.grid.sumdigits;
    var sum2 = puzzles['Right']!.grid.sumdigits;
    ok = sum1 == sum2;
  }
  return ok;
}

bool checkClue(String clueName, String expression) {
  var ok = true;
  int getClueValue(clueName) {
    return allClues[clueName]!.getValueFromDigits();
  }

  var value = getClueValue(clueName);
  assert(value != 0);
  switch (clueName) {
    case 'LA1':
    case 'RA1':
      // 1ac = 1dn+ 3ac, both from the opposite grid
      var valueD1 = getClueValue((clueName[0] == 'L' ? 'R' : 'L') + 'D1');
      var valueA3 = getClueValue((clueName[0] == 'L' ? 'R' : 'L') + 'A3');
      ok = value == (valueD1 + valueA3);
      break;
    case 'LA8':
    case 'RA8':
      // 8ac = 3ac x 7ac, both from the same grid
      var valueA3 = getClueValue(clueName[0] + 'A3');
      var valueA7 = getClueValue(clueName[0] + 'A7');
      ok = value == (valueA3 * valueA7);
      break;
  }
  return ok;
}

bool trace = true;
bool timed = true;
var progress = '';
var characters = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
pushProgress(int p1, int p2) {
  if (!trace) return;
  var char1 = characters[p1];
  progress += char1;
  var char2 = characters[p2];
  progress += char2;
  if (timed)
    checkProgress(progress);
  else
    stdout.write('$char1$char2');
}

popProgress() {
  if (!trace) return;
  progress = progress.substring(0, progress.length - 2);
  const ansiCursorLeft = '\x1b[D';
  const ansiEraseCursorToEnd = '\x1b[K';
  if (timed)
    checkProgress(progress);
  else {
    stdout.write(ansiCursorLeft);
    stdout.write(ansiCursorLeft);
    stdout.write(ansiEraseCursorToEnd);
  }
}

addProgress(String msg) {
  if (!trace) return;
  if (timed)
    checkProgress(msg, true);
  else {
    stdout.write(' ');
    stdout.writeln(msg);
    stdout.write(progress);
  }
}

int totalSeconds = 0;
void checkProgress(String msg, [bool force = false]) {
  var seconds = stopwatch!.elapsed.inSeconds;
  if (seconds >= 20) {
    totalSeconds += seconds;
    print('${totalSeconds.toString().padLeft(5, '0')}: $msg');
    stopwatch!.reset();
  } else if (force) {
    print(msg);
  }
}
