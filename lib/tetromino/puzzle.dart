import 'package:basics/basics.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../generators.dart';
import '../grid.dart';
import '../puzzle.dart';
import '../undo.dart';
import '../variable.dart';
import 'clue.dart';

// Numbers < 200 that are a power of a prime number

class TetrominoVariable extends Variable {
  static var primes = generatePrimes(1, 99).toList();

  TetrominoVariable(super.letter) {
    values = Set.from(primes);
  }
  String get letter => name;
}

class TetrominoPuzzle
    extends VariablePuzzle<TetrominoClue, TetrominoEntry, TetrominoVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  TetrominoPuzzle({String name = ''}) : super(null, name: name);
  TetrominoPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  bool checkSolution() {
    // if (!super.checkSolution()) return false;

    // Check digit counts
    var digitCount = getDigitCount();

    /// These seven tetrominoes have been used to tile the 6x5 rectangular grid
    /// leaving two holes. Each tetromino contains the same digit in each of its
    /// 4 cells and the two holes each contain a zero.
    /// So, only 8 digits used
    if (digitCount.length != 8) {
      return false;
    }

    var clueEntries = findClueEntries();
    if (clueEntries.values.any((element) => element.isEmpty)) {
      return false;
    }

    /// Iterate over tetrominoe tilings
    var ok = false;
    for (var _ in grid!.fitTetrominoesToGrid()) {
      // Map clues to entries checking tetrominoes
      var count = mapOrderedCluesToEntries(clueEntries, mapCallback);
      if (count > 0) ok = true;
    }
    return ok;
  }

  @override
  String solutionToString() {
    // Already printed by call back below
    return '';
  }

  void mapCallback() {
    var clueValues = clues.values.map((c) {
      var e = c.entry!;
      return 'Clue ${c.name} =  ${c.value!} (Entry ${e.name})';
    }).join('\n');
    var entryValues = entries.values.where((e) => e.clue != null).map((e) {
      var c = e.clue!;
      return 'Entry ${e.name} =  ${c.value!} (Clue ${c.name})';
    }).join('\n');
    var varValues =
        variables.values.map((v) => '${v.name}=${v.value}').join('\n');
    print('Clues\n$clueValues\nEntries\n$entryValues\nVariables\n$varValues');
    print('Tetromino Tiling:\n${grid!.tetrominoString()}');
    print(toSolution());
  }

  Map<TetrominoClue, List<TetrominoEntry>> findClueEntries() {
    var clueEntries = <TetrominoClue, List<TetrominoEntry>>{};
    for (var clue in clues.values) {
      var entries = findPossibleEntriesForClue(clue);
      clueEntries[clue] = entries;
    }
    // for (var clue in clues.values) {
    // var entries = clueEntries[clue]!;
    // print(
    //     'Clue ${clue.name}, entries, ${this.entries.values.map((e) => entries.contains(e) ? e.name : '').join(',')}');
    // }
    return clueEntries;
  }

  List<TetrominoEntry> findPossibleEntriesForClue(TetrominoClue clue) {
    var result = <TetrominoEntry>[];
    for (var entry in entries.values) {
      var value = solution[clue]!.value!;
      var ok = true;
      if (entry.isAcross == clue.isAcross && entry.length == clue.length) {
        for (var d = entry.length! - 1; d >= 0; d--) {
          var digit = value % 10;
          if (!entry.digits[d].contains(digit)) {
            ok = false;
            break;
          }
          value ~/= 10;
        }
        if (ok) result.add(entry);
      }
    }
    return result;
  }

  Map<int, int> getDigitCount() {
    var digitCount = <int, int>{};
    for (var clue in clues.values) {
      if (solution.containsKey(clue)) {
        var value = solution[clue]!.value;
        if (value != null) {
          while (value! > 0) {
            var digit = value % 10;
            if (!digitCount.containsKey(digit)) digitCount[digit] = 0;
            digitCount[digit] = digitCount[digit]! + 1;
            value = value ~/ 10;
          }
        }
      }
    }
    return digitCount;
  }

  int mapOrderedCluesToEntries(
      Map<TetrominoClue, List<TetrominoEntry>> clueEntries, Function callback) {
    var orderedClues = clueEntries.keys.toList();
    orderedClues.sort((clue1, clue2) =>
        clueEntries[clue1]!.length.compareTo(clueEntries[clue2]!.length));
    var count = 0;
    for (var mapped
        in mapOrderedDigitClueToEntry(clueEntries, orderedClues, 0)) {
      if (mapped) {
        callback();
        count++;
      }
    }
    return count;
  }

  Iterable<bool> mapOrderedDigitClueToEntry(
      Map<TetrominoClue, List<TetrominoEntry>> clueEntries,
      List<TetrominoClue> orderedClues,
      int index) sync* {
    var clue = orderedClues[index];
    for (var entry in clueEntries[clue]!) {
      TetrominoClue? mappedClue = (entry as EntryMixin).clue as TetrominoClue?;
      if (mappedClue != null) continue;

      // Set mapping
      mapClueToEntry(clue, entry);

      // Save values and entry digits
      UndoStack.begin();

      // Set clue from variable iteration solution
      clue.value = solution[clue]!.value;

      // Update entry from clue
      if (updateEntry(clue)) {
        // Try to map remaining clues
        if (index == orderedClues.length - 1) {
          if (checkMapSolution()) {
            yield true;
          }
        } else {
          yield* mapOrderedDigitClueToEntry(
              clueEntries, orderedClues, index + 1);
        }
      } else if (mappedClue != null) {
        if (Crossnumber.traceSolve) {
          print(
              'Clue ${mappedClue.name} mapping to Entry ${entry.name} is invalid');
        }
      }

      // Undo mapping
      UndoStack.undo();
      clue.entry = null;
      (entry as EntryMixin).clue = null;
    }
    if (Crossnumber.traceSolve) {
      // var mapping =
      //     "${entries.where((e) => (e as EntryMixin).clue != null).map((e) {
      //   var c = (e as EntryMixin).clue!;
      //   return '${e.name}=${c.name}${c.values})';
      // }).join(',')}";
      // print('Mapping failed for entry ${entry.name}');
      // print(mapping);
      // print(toSolution());
    }
    return;
  }

  @override
  bool updateEntry(TetrominoClue clue) {
    var updated = super.updateEntry(clue);
    // Check tiling
    var entry = clue.entry! as EntryMixin;
    var value = clue.value!;
    for (var cell in entry.cells.reversed) {
      var tetromino = grid!.cellTetromino[cell];
      var digit = value % 10;
      if (tetromino == null) {
        if (digit != 0) {
          return false;
        }
      } else {
        var cells = grid!.cellTetromino.whereValue((t) => t == tetromino);
        var ok =
            cells.keys.every((cell) => cell.digit == 0 || cell.digit == digit);
        if (!ok) {
          return false;
        }
      }
      value = value ~/ 10;
    }
    return updated;
  }

  bool checkMapSolution() {
    // Check tiling
    var firstCellForTile = <Tetromino, Cell>{};
    for (var row in grid!.rows) {
      for (var cell in row) {
        var tetromino = grid!.cellTetromino[cell];
        if (tetromino == null) {
          // Cell digit is zero
          if (cell.digit != 0) {
            return false;
          }
        } else {
          if (!firstCellForTile.containsKey(tetromino)) {
            firstCellForTile[tetromino] = cell;
          } else {
            if (cell.digit != firstCellForTile[tetromino]!.digit) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }
}
