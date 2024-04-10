class EntrySpec {
  final int number;
  final String label;
  final bool isAcross;
  late final String name;
  late int length;

  /// row/col for start of entry
  final int row;
  final int col;

  EntrySpec(this.number, this.label, this.isAcross, this.row, this.col) {
    if (label != '') {
      this.name = label;
    } else if (isAcross) {
      this.name = 'A${this.number}';
    } else {
      this.name = 'D${this.number}';
    }
    this.length = 1;
  }

  String toString() {
    return '$name($length)';
  }
}

class CellSpec {
  int? number;
  EntrySpec? across;
  int? acrossDigit;
  EntrySpec? down;
  int? downDigit;
  CellSpec(
      {this.number, this.across, this.acrossDigit, this.down, this.downDigit});
  String toString() {
    return number != null ? number.toString() : ' ';
  }
}

class GridSpec {
  final List<String> grid;
  List<List<CellSpec?>> cells = [];
  List<EntrySpec> entries = [];

  GridSpec(this.grid) {
    extractEntries();
  }

  extractEntries() {
    var rows = 0;
    var cols = 0;
    var row = 0;
    var col = 0;

    for (var r = 0; r < grid.length; r++) {
      var str = grid[r];
      var array = str.split('');
      if (r == 0) {
        // count + to get columns
        cols = array.where((element) => element == '+').length - 1;
      } else if (r % 2 == 0) {
        rows++;
      }
    }
    cells = List.generate(rows, (row) => List.generate(cols, (col) => null));

    row = 0;

    for (var r = 1; r < grid.length - 1; r++) {
      var prevArray = grid[r - 1].split('');
      var array = grid[r].split('');
      var nextArray = grid[r + 1].split('');
      if (r % 2 == 1) {
        // clue row
        col = 0;
        var c = 0;
        var cPrev = c;
        while (col < cols) {
          // Skip divider
          while (array[c] == ':' || array[c] == '|') {
            cPrev = c;
            c++;
          }

          // Process cell
          assert(isDigit(array[c]) || isAlpha(array[c]) || array[c] == ' ',
              'Invalid cell character ${array[c]}');
          var cStart = c;
          var number = 0;
          var acrossLabel = '';
          var downLabel = '';
          while (isDigit(array[c]) || isAlpha(array[c]) || array[c] == ' ') {
            if (isDigit(array[c])) {
              number = number * 10 + int.parse(array[c]);
            } else if (isUpperAlpha(array[c])) {
              acrossLabel = array[c];
            } else if (isLowerAlpha(array[c])) {
              downLabel = array[c];
            }
            c++;
          }

          EntrySpec? across;
          int? acrossDigit;
          EntrySpec? down;
          int? downDigit;
          if (array[cPrev] == ':') {
            // Continuing Across clue
            var cell = cells[row][col - 1]!;
            across = cell.across;
            acrossDigit = cell.acrossDigit! + 1;
            across!.length++;
          } else if (array[c] == ':') {
            if (number != 0 || acrossLabel != '') {
              // New Across clue
              across = EntrySpec(number, acrossLabel, true, row, col);
              acrossDigit = 0;
              entries.add(across);
            }
          }
          if (prevArray[cStart] == ':') {
            // Continuing Down clue
            var cell = cells[row - 1][col]!;
            down = cell.down;
            downDigit = cell.downDigit! + 1;
            down!.length++;
          } else if (nextArray[cStart] == ':') {
            if (number != 0 || downLabel != '') {
              // New Down clue
              down = EntrySpec(number, downLabel, false, row, col);
              downDigit = 0;
              entries.add(down);
            }
          }
          cells[row][col] = CellSpec(
              number: number,
              across: across,
              acrossDigit: acrossDigit,
              down: down,
              downDigit: downDigit);
          col++;
        }
        row++;
      }
    }
  }

  List<Map<String, dynamic>> getIdentities() {
    List<Map<String, dynamic>> identities = [];
    for (var row in this.cells) {
      for (var cell in row) {
        if (cell!.across != null && cell.down != null) {
          identities.add({
            'entry1': cell.across!.name,
            'digit1': cell.acrossDigit! + 1,
            'entry2': cell.down!.name,
            'digit2': cell.downDigit! + 1,
          });
        }
      }
    }
    return identities;
  }

  String toString() {
    var identities = '';
    for (var row in this.cells) {
      for (var cell in row) {
        if (cell!.across != null && cell.down != null) {
          identities +=
              '${cell.across!.name}[${cell.acrossDigit! + 1}]=${cell.down!.name}[${cell.downDigit! + 1}],';
        }
      }
    }
    return 'Specification: cells=$cells\nentries=$entries\nidentities=[$identities]';
  }

  String solutionToString(Map<String, List<String>> entryValues) {
    var border = getBorder();
    var text = border + '\n';
    var rowSeparator = '';
    for (var row in this.cells) {
      if (rowSeparator != '') text += rowSeparator + '\n';
      rowSeparator = '+';
      var lastRowSeparatorChar = rowSeparator;
      var separator = '|';
      for (var cell in row) {
        text += separator;
        if (cell!.across != null && entryValues[cell.across!.name] != null) {
          var value = entryValues[cell.across!.name]![cell.acrossDigit!];
          text += value.padLeft(2);
        } else if (cell.down != null && entryValues[cell.down!.name] != null) {
          var value = entryValues[cell.down!.name]![cell.downDigit!];
          text += value.padLeft(2);
        } else {
          text += '  ';
        }
        if (cell.across == null) {
          separator = '|';
        } else if (cell.acrossDigit! == cell.across!.length - 1) {
          separator = '|';
        } else {
          separator = ' ';
        }
        var rowSeparatorChar = '  ';
        var nextRowSeparatorChar = ' ';
        if (cell.down == null) {
          rowSeparatorChar = '--';
        } else if (cell.downDigit! == cell.down!.length - 1) {
          rowSeparatorChar = '--';
          nextRowSeparatorChar = '+';
        }
        if (separator == '|') {
          nextRowSeparatorChar = '+';
        }
        if (rowSeparator != '+') {
          if (lastRowSeparatorChar == '--' || nextRowSeparatorChar == '--') {
            rowSeparatorChar = '+';
          }
        }
        rowSeparator += rowSeparatorChar;
        rowSeparator += nextRowSeparatorChar;
        lastRowSeparatorChar = nextRowSeparatorChar;
      }
      text += '|\n';
    }
    text += border + '\n';
    return text;
  }

  String getBorder() {
    var text = '+' + '--+' * cells[0].length;
    return text;
  }
}

bool isDigit(String ch) {
  return '0123456789'.contains(ch);
}

bool isAlpha(String ch) {
  return isUpperAlpha(ch) || isLowerAlpha(ch);
}

bool isLowerAlpha(String ch) {
  return 'abcdefghijklmnopqrstuvwxyz'.contains(ch);
}

bool isUpperAlpha(String ch) {
  return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(ch);
}
