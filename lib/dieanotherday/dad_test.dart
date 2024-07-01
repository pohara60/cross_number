// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:powers/powers.dart';

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
    if (object is Cell) {
      set = object.digits;
    } else if (object is Clue)
      set = object.values;
    else if (object is Variable)
      set = object.values;
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
      if (object is Cell) {
        object.digits = set;
      } else if (object is Clue)
        object._values = set;
      else if (object is Variable)
        object._values = set;
      else
        throw Exception();
    }
  }
}

class SolveException implements Exception {
  final String msg;
  SolveException(this.msg);
}

// Possible dice faces in order Top, Front, Right
final diceFaces = [
  [1, 2, 3],
  [1, 3, 5],
  [1, 5, 4],
  [1, 4, 2],
  [2, 1, 4],
  [2, 4, 6],
  [2, 6, 3],
  [2, 3, 1],
  [3, 1, 2],
  [3, 2, 6],
  [3, 6, 5],
  [3, 5, 1],
  [4, 1, 5],
  [4, 5, 6],
  [4, 6, 2],
  [4, 2, 1],
  [5, 1, 3],
  [5, 3, 6],
  [5, 6, 4],
  [5, 4, 1],
  [6, 2, 4],
  [6, 4, 5],
  [6, 5, 3],
  [6, 3, 2],
];

class Cell {
  final String face;
  final int row, col;
  String get name => '$face$row$col';
  final clues = <Clue>[];
  var digits = <int>{};
  int get digit => digits.length == 1 ? digits.first : 0;
  late final List<Cell> _faces;

  Cell(
    this.face,
    this.row,
    this.col,
  ) {
    digits.addAll([1, 2, 3, 4, 5, 6]);
  }

  String get position => '$row$col';

  set faces(List<Cell> faces) {
    _faces = faces;
  }

  Set<int> getNewDigits(Set<int> digits, Set<int> validDigits) {
    Function eq = const SetEquality().equals;
    if (digits.length == validDigits.length && eq(digits, validDigits)) {
      return digits;
    }
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

  bool isOppositeFaces(Set<int> digits) {
    return digits.length == 1 ||
        digits.length == 2 && (digits.first + digits.last) == 7;
  }

  void removeOppositeDigits(int digit, Set<int> validDigits) {
    var d1 = digit;
    var d2 = 7 - d1;
    validDigits.remove(d1);
    validDigits.remove(d2);
  }

  Set<Clue> updateFaces() {
    // Worth doing if one face, or two opposite faces
    if (!isOppositeFaces(digits)) return {};
    // Can eliminate the opposite faces from other cells
    var validDigits = {1, 2, 3, 4, 5, 6};
    removeOppositeDigits(digits.first, validDigits);
    var updatedClues = <Clue>{};
    var unknownCells = <Cell>{};
    for (var otherCell in _faces.where((element) => element != this)) {
      var newDigits = getNewDigits(otherCell.digits, validDigits);
      if (isOppositeFaces(newDigits)) {
        updatedClues.addAll(otherCell.updateNewDigits(newDigits, false));
        removeOppositeDigits(otherCell.digits.first, validDigits);
      } else {
        unknownCells.add(otherCell);
      }
    }
    for (var otherCell in unknownCells) {
      updatedClues.addAll(otherCell.updateDigits(validDigits, false));
    }
    return updatedClues;
  }

  @override
  String toString() => '$name=$digits';
  String toDigit() => digits.length == 1 ? digits.first.toString() : '?';

  void setDigit(int digit) {
    // Optimised for backtracking, in puzzle order
    if (digits.length == 1 && digits.first == digit) return;

    UndoStack.push(this);
    digits = {digit};
    if (this == _faces[2]) return;

    // Update following faces
    var oppositeDigit = 0;
    var nextOppositeDigit = 0;
    for (var otherCell in _faces.slice(this == _faces[0] ? 1 : 2)) {
      var otherDigits = otherCell.digits;
      if (otherDigits.contains(digit) || otherDigits.contains(7 - digit)) {
        UndoStack.push(otherCell);
        var newDigits = <int>{};
        for (var otherDigit in otherDigits) {
          if (digit != otherDigit &&
              7 - digit != otherDigit &&
              (oppositeDigit == 0 ||
                  oppositeDigit != otherDigit &&
                      7 - oppositeDigit != otherDigit)) {
            newDigits.add(otherDigit);
            if (newDigits.length == 1) {
              nextOppositeDigit = otherDigit;
            } else if (newDigits.length > 2 ||
                otherDigit != 7 - nextOppositeDigit) nextOppositeDigit = 0;
          }
        }
        otherCell.digits = newDigits;
        oppositeDigit = nextOppositeDigit;
      }
    }
  }
}

class Grid {
  final String face;
  final rows = <List<Cell>>[];
  final int dimension;
  Grid(
    this.face,
    this.dimension,
  ) {
    rows.addAll(List.generate(dimension,
        (row) => List.generate(dimension, (col) => Cell(face[0], row, col))));
  }
  @override
  String toString() =>
      '$face\n${rows.map((row) => row.fold('', (str, cell) => str + cell.toDigit())).join('\n')}';
  int get sumdigits => rows.fold(
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
  set value(int value) {
    values = {value};
  }

  set values(Set<int> values) {
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

  final int length = 4;
  //late final Set<int> digits;
  final cells = <Cell>[];

  Clue(this.face, this.name, Grid grid) {
    if (isAcross) {
      col = 0;
      if (name[1] == '1') {
        row = 0;
      } else {
        row = int.parse(name[1]) - 4;
      }
    } else {
      row = 0;
      col = int.parse(name[1]) - 1;
    }
    var r = row;
    var c = col;
    for (var i = 0; i < length; i++) {
      // digits.add(Set.from([1, 2, 3, 4, 5, 6]));
      var cell = grid.rows[r][c];
      cells.add(cell);
      cell.clues.add(this);
      if (isAcross) {
        c++;
      } else {
        r++;
      }
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

  @override
  String toString() => '$face$name';

  int getValueFromDigits() {
    var value = 0;
    for (var i = 0; i < length; i++) {
      var digit = cells[i].digit;
      if (digit == 0) return 0;
      value = value * 10 + digit;
    }
    return value;
  }
}

class Variable {
  final String name;
  var _values = <int>{};

  Variable(this.name, this._values);
  Set<int> get values => _values;
  int get value => values.length == 1 ? values.first : 0;
  set value(int value) {
    values = {value};
  }

  set values(Set<int> values) {
    UndoStack.push(this);
    _values = Set.from(values);
  }

  @override
  String toString() => '$name=$_values';
}

class Puzzle {
  final String name;
  final Grid grid;
  final List<String> variableNames;
  Puzzle(
    this.name,
    this.grid,
    this.variableNames,
  );
  final clues = <String, Clue>{};

  @override
  String toString() => 'Puzzle $grid';
}

final puzzles = <String, Puzzle>{};
const puzzleNames = ['Top', 'Front', 'Right'];
final variables = <String, Variable>{};
var puzzleDigitCount = <String, List<int>>{};
var allClues = <String, Clue>{};

void main() {
  // variables['W'] = Variable('W', {1, 2, 3, 4, 5});
  variables['W'] = Variable('W', {1, 2, 3, 4, 5});
  variables['X'] = Variable('X', {6});
  variables['Y'] = Variable('Y', {1, 3, 4});
  variables['Z'] = Variable('Z', {3, 5});
  variables['A'] = Variable('A', {34, 37, 38, 66, 68, 73});
  final clueFaces = <String, List<Clue>>{};
  final cellFaces = <String, List<Cell>>{};
  for (var name in puzzleNames) {
    final grid = Grid(name, 4);
    var puzzle = puzzles[name] = Puzzle(
      name,
      grid,
      name == 'Top'
          ? ['W', 'X']
          : name == 'Front'
              ? ['Y']
              : ['Z'],
    );
    for (var clueName in ['A1', 'A5', 'A6', 'A7', 'D1', 'D2', 'D3', 'D4']) {
      var clue = puzzle.clues[clueName] = Clue(name[0], clueName, grid);
      allClues[clue.face + clue.name] = clue;
      if (!clueFaces.containsKey(clueName)) clueFaces[clueName] = [];
      clueFaces[clueName]!.add(clue);
    }
    var downDigit = 0;
    for (var acrossName in ['A1', 'A5', 'A6', 'A7']) {
      var acrossClue = puzzle.clues[acrossName]!;
      var acrossDigit = 0;
      for (var downName in ['D1', 'D2', 'D3', 'D4']) {
        acrossClue.addIdentity(acrossDigit, puzzle.clues[downName]!, downDigit);
        acrossDigit++;
      }
      downDigit++;
      for (var cell in acrossClue.cells) {
        if (!cellFaces.containsKey(cell.position)) {
          cellFaces[cell.position] = [];
        }
        cellFaces[cell.position]!.add(cell);
        cell.faces = cellFaces[cell.position]!;
      }
    }
    puzzleDigitCount[name] = List.filled(6, 0);
  }

  // UndoStack.begin();
  puzzles['Top']!.clues['A7']!.value = 1444;
  // UndoStack.begin();
  puzzles['Front']!.clues['A7']!.value = 4225;
  // UndoStack.begin();
  puzzles['Front']!.clues['D4']!.value = 3125;
  // UndoStack.begin();
  puzzles['Right']!.clues['A7']!.value = 2116;

  // Backtrack solution of the three grids
  var count = backtrack(puzzles, puzzleNames, 0);
  print('Solution count $count');
}

void printPuzzles(String heading) {
  print(heading);
  for (var variable in variables.values) {
    print('${variable.name}=${variable.values}');
  }
  for (var name in ['Top', 'Front', 'Right']) {
    var puzzle = puzzles[name];
    print(puzzle);
  }
}

Stopwatch? stopwatch;

int backtrack(Map<String, Puzzle> puzzles, List<String> names, int count) {
  stopwatch ??= Stopwatch()..start();
  if (names.isEmpty) {
    var ok = false;
    for (var a = 20; a < 99; a++) {
      UndoStack.begin();
      variables['A']!.value = a;
      ok = checkPuzzle(null, true);
      if (ok) break;
      UndoStack.undo();
      // addProgress('checkPuzzle=$ok');
    }
    if (!ok) return count;
    // Solution
    count++;
    printPuzzles('Solution $count');
    UndoStack.undo();
    return count;
  }
  var name = names[0];
  var puzzle = puzzles[name]!;
  var variableValues = List.filled(6, false);
  count = backtrackPuzzle(puzzles, names.slice(1), count, puzzle,
      puzzle.variableNames, variableValues);
  return count;
}

int backtrackPuzzle(Map<String, Puzzle> puzzles, List<String> names, int count,
    Puzzle puzzle, List<String> variableNames, List<bool> variableValues) {
  if (variableNames.isEmpty) {
    // Set variables, so backtrack over cells
    // Clues first
    if (!checkPuzzle(puzzle, true)) return count;
    addProgress(
        'puzzle ${puzzle.name} variables${puzzle.variableNames.fold('', (v, e) => "$v $e=${variables[e]!.value}")}');
    return backtrackPuzzleVariable(
        puzzles, names, count, puzzle, 0, 0, variableValues);
  }

  // Try variable
  var variableName = variableNames[0];
  var variable = variables[variableName]!;
  var values = variable.values;
  for (var value in values) {
    UndoStack.begin();
    variable.value = value;
    variableValues[value - 1] = true;

    // Disallow value for other variables
    for (var otherVariable
        in variables.values.where((element) => element.name != variableName)) {
      if (otherVariable.values.contains(value)) {
        otherVariable.values = Set.from(otherVariable.values)..remove(value);
      }
    }

    // Continue with cells
    count = backtrackPuzzle(
        puzzles, names, count, puzzle, variableNames.slice(1), variableValues);

    variableValues[value - 1] = false;
    UndoStack.undo();
  }

  return count;
}

int backtrackPuzzleVariable(Map<String, Puzzle> puzzles, List<String> names,
    int count, Puzzle puzzle, int row, int col, List<bool> variableValues) {
  var dimension = puzzle.grid.dimension;
  if (row == dimension) {
    // Check variables
    for (var variableName in puzzle.variableNames) {
      var value = variables[variableName]!.value;
      assert(value != 0);
      var occurrences = puzzleDigitCount[puzzle.name]![value - 1];
      if (occurrences != value) return count;
    }
    // Clues
    if (!checkPuzzle(puzzle, false)) return count;
    return backtrack(puzzles, names, count);
  }

  // Try cell
  // var cell = puzzle.grid.rows[row][col];
  // Reverse order
  var cell = puzzle.grid.rows[dimension - row - 1][dimension - col - 1];
  var digits = cell.digits;
  var digitCount = puzzleDigitCount[puzzle.name]!;
  digitLoop:
  for (var digit in digits) {
    // Check variables
    if (variableValues[digit - 1] && digitCount[digit - 1] >= digit) {
      continue digitLoop;
    }

    // checkProgress('${puzzle.name} $row $col $digit');

    UndoStack.begin();
    digitCount[digit - 1]++;
    //cell.updateNewDigits({digit});
    cell.setDigit(digit);
    pushProgress(digit);

    // Continue with next cell
    var newRow = row;
    var newCol = col + 1;
    if (newCol == dimension) {
      newRow++;
      newCol = 0;
    }
    count = backtrackPuzzleVariable(
        puzzles, names, count, puzzle, newRow, newCol, variableValues);

    digitCount[digit - 1]--;
    popProgress();
    UndoStack.undo();
  }

  return count;
}

bool checkPuzzle(Puzzle? puzzle, bool isPreCheck) {
  var ok = true;
  if (puzzle == null) {
    // Post-check
    if (ok) ok = checkClue(puzzle, 'TA6', "multiple A");
    if (ok) ok = checkClue(puzzle, 'RA5', "A^2 - W");
    if (ok) ok = checkClue(puzzle, 'FD3', "sumdigits * X");
  } else if (puzzle.name == 'Top' && !isPreCheck) {
    if (ok) ok = checkClue(puzzle, 'TA7', "square");
    if (ok) ok = checkClue(puzzle, 'TD1', "power3");
  } else if (puzzle.name == 'Front' && isPreCheck) {
    if (ok) ok = checkClue(puzzle, 'TA1', "square - Y^2");
    if (ok) ok = checkClue(puzzle, 'TD2', "multiple X*Y");
    if (ok) ok = checkClue(puzzle, 'TD3', "multiple X*Y");
  } else if (puzzle.name == 'Front' && !isPreCheck) {
    if (ok) ok = checkClue(puzzle, 'FA7', "square");
    if (ok) ok = checkClue(puzzle, 'FD4', "power3");
  } else if (puzzle.name == 'Right' && isPreCheck) {
    if (ok) ok = checkClue(puzzle, 'FD1', "square + W*Y*Z");
  } else if (puzzle.name == 'Right' && !isPreCheck) {
    if (ok) ok = checkClue(puzzle, 'RA7', "square");
    if (ok) ok = checkClue(puzzle, 'RD2', "multiple (X + Z)");
  }
  return ok;
}

var squares = <int>[];
void getSquares() {
  if (squares.isNotEmpty) return;
  var start = sqrt(1000).toInt();
  var end = sqrt(10000).toInt();
  for (var i = start; i < end + 1; i++) {
    var sq = i * i;
    if (sq > 999 && sq < 10000) {
      var str = sq.toString();
      if (!str.contains(RegExp(r'[0789]'))) squares.add(sq);
    }
  }
}

var power3 = <int>[];
void getPower3() {
  if (power3.isNotEmpty) return;
  var power = 3;
  while (true) {
    var start = 1000.pow(1 / power).toInt();
    var end = 10000.pow(1 / power).toInt();
    if (end < 2) break;
    for (var i = start; i < end + 1; i++) {
      var sq = i.pow(power).toInt();
      if (sq > 999 && sq < 10000) {
        var str = sq.toString();
        if (!str.contains(RegExp(r'[0789]'))) power3.add(sq);
      }
    }
    power++;
  }
}

bool checkClue(Puzzle? puzzle, String clueName, String expression) {
  var ok = true;
  var clue = allClues[clueName]!;
  var value = clue.getValueFromDigits();
  assert(value != 0);
  var w = variables['W']!.value;
  var x = variables['X']!.value;
  var y = variables['Y']!.value;
  var z = variables['Z']!.value;
  var a = variables['A']!.value;
  switch (clueName) {
    case 'TA6':
    case 'RA5':
      // Allow any possible value of A
      // for (var a in variables['A']!.values) {
      if (clueName == 'TA6') {
        //"multiple A"
        ok = value ~/ a * a == value;
        if (ok) break;
      } else {
        //"A^2 - W"
        ok = a * a - w == value;
        if (ok) break;
      }
      // }
      break;
    case 'TA1':
      //"square - Y^2"
      getSquares();
      ok = squares.contains(value + y * y);
      // var root = sqrt(value + y * y);
      // ok = root == root.toInt();
      break;
    case 'TA7':
    case 'FA7':
    case 'RA7':
      //"square"
      getSquares();
      ok = squares.contains(value);
      // var root = sqrt(value);
      // ok = root == root.toInt();
      break;
    case 'TD1':
    case 'FD4':
      //"power3"
      getPower3();
      ok = power3.contains(value);
      // var power = 3;
      // while (true) {
      //   var root = pow(value, 1 / power);
      //   ok = root == root.toInt();
      //   if (ok || root < 2.0) break;
      //   power++;
      // }
      break;
    case 'TD2':
    case 'TD3':
      //"multiple X*Y"
      var xy = x * y;
      var root = value / xy;
      ok = root == root.toInt();
      break;
    case 'FD3':
      //"sumdigits * X"
      var sum = puzzles.values
          .fold(0, (value, puzzle) => value + puzzle.grid.sumdigits);
      ok = sum * x == value;
      break;
    case 'FD1':
      //"square + W*Y*Z"
      getSquares();
      ok = squares.contains(value - w * y * z);
      // var root = sqrt(value - w * y * z);
      // ok = root == root.toInt();
      break;
    case 'RD2':
      //"multiple (X + Z)"
      var xz = x + z;
      var root = value / xz;
      ok = root == root.toInt();
      break;
  }
  return ok;
}

bool trace = true;
bool timed = true;
var progress = '';
var characters = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
pushProgress(int value) {
  if (!trace) return;
  var char = characters[value];
  progress += char;
  if (timed) {
    checkProgress(progress);
  } else {
    stdout.write(char);
  }
}

popProgress() {
  if (!trace) return;
  progress = progress.substring(0, progress.length - 1);
  const ansiCursorLeft = '\x1b[D';
  const ansiEraseCursorToEnd = '\x1b[K';
  if (timed) {
    checkProgress(progress);
  } else {
    stdout.write(ansiCursorLeft);
    stdout.write(ansiEraseCursorToEnd);
  }
}

addProgress(String msg) {
  if (!trace) return;
  if (timed) {
    checkProgress(msg, true);
  } else {
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
