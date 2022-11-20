class ClueSpec {
  final int number;
  final bool isAcross;
  late final String name;
  late int length;

  ClueSpec(this.number, this.isAcross) {
    if (isAcross) {
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

class Cell {
  int? number;
  ClueSpec? across;
  int? acrossDigit;
  ClueSpec? down;
  int? downDigit;
  Cell({this.number, this.across, this.acrossDigit, this.down, this.downDigit});
  String toString() {
    return number != null ? number.toString() : ' ';
  }
}

class Grid {
  final List<String> grid;
  List<List<Cell?>> cells = [];
  List<ClueSpec> clues = [];

  Grid(this.grid) {
    extractClues();
  }

  extractClues() {
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
          assert(isDigit(array[c]) || array[c] == ' ',
              'Invalid cell character ${array[c]}');
          var cStart = c;
          var number = 0;
          while (isDigit(array[c]) || array[c] == ' ') {
            if (isDigit(array[c])) {
              number = number * 10 + int.parse(array[c]);
            }
            c++;
          }

          ClueSpec? across;
          int? acrossDigit;
          ClueSpec? down;
          int? downDigit;
          if (array[cPrev] == ':') {
            // Continuing Across clue
            var cell = cells[row][col - 1]!;
            across = cell.across;
            acrossDigit = cell.acrossDigit! + 1;
            across!.length++;
          } else if (array[c] == ':') {
            if (number != 0) {
              // New Across clue
              across = ClueSpec(number, true);
              acrossDigit = 0;
              clues.add(across);
            }
          }
          if (prevArray[cStart] == ':') {
            // Continuing Down clue
            var cell = cells[row - 1][col]!;
            down = cell.down;
            downDigit = cell.downDigit! + 1;
            down!.length++;
          } else if (nextArray[cStart] == ':') {
            if (number != 0) {
              // New Down clue
              down = ClueSpec(number, false);
              downDigit = 0;
              clues.add(down);
            }
          }
          cells[row][col] = Cell(
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
            'clue1': cell.across!.name,
            'digit1': cell.acrossDigit! + 1,
            'clue2': cell.down!.name,
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
    return 'Specification: cells=$cells\nclues=$clues\nidentities=[$identities]';
  }

  String solutionToString(Map<String, int> clueValues) {
    var border = getBorder();
    var text = border + '\n';
    var rowSeparator = '';
    for (var row in this.cells) {
      var prevRowSeparator = rowSeparator;
      if (rowSeparator != '') text += rowSeparator + '\n';
      rowSeparator = '+';
      var lastRowSeparatorChar = rowSeparator;
      var separator = '|';
      for (var cell in row) {
        text += separator;
        if (cell!.across != null) {
          var valueStr =
              clueValues[cell.across!.name]!.toString()[cell.acrossDigit!];
          text += '$valueStr';
        } else if (cell.down != null) {
          var valueStr =
              clueValues[cell.down!.name]!.toString()[cell.downDigit!];
          text += '$valueStr';
        } else {
          text += ' ';
        }
        if (cell.across == null) {
          separator = '|';
        } else if (cell.acrossDigit! == cell.across!.length - 1) {
          separator = '|';
        } else {
          separator = ' ';
        }
        var rowSeparatorChar = ' ';
        var nextRowSeparatorChar = ' ';
        if (cell.down == null) {
          rowSeparatorChar = '-';
        } else if (cell.downDigit! == cell.down!.length - 1) {
          rowSeparatorChar = '-';
          nextRowSeparatorChar = '+';
        }
        if (separator == '|') {
          nextRowSeparatorChar = '+';
        }
        if (rowSeparator != '+') {
          if (lastRowSeparatorChar == '-' || nextRowSeparatorChar == '-') {
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
    var text = '+' + '-+' * cells[0].length;
    return text;
  }
}

bool isDigit(String ch) {
  return '0123456789'.contains(ch);
}

void main(List<String> args) {
  var grid = [
    '+--+--+--+--+',
    '|1 :2 :3 |4 |',
    '+--:::::::::+',
    '|5 :  |6 :  |',
    '+:::--+--:::+',
    '|7 :8 |9 :  |',
    '+:::::::::--+',
    '|  |10:  :  |',
    '+--+--+--+--+',
  ];

  var spec = Grid(grid);
  spec.extractClues();
  print(spec);
}
