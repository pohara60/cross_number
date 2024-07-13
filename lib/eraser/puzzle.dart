import 'package:crossnumber/generators.dart';

import '../grid.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

typedef VariableClueDef = ({
  String name,
  int? row,
  int? col,
  String valueDesc,
});
typedef ErasedCell = ({
  int value,
  int row,
  int col,
  Cell cell,
  int? fixedRow,
  int? fixedCol,
});

class EraserVariable extends Variable {
  EraserVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class EraserPuzzle
    extends VariablePuzzle<EraserClue, EraserEntry, EraserVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  EraserPuzzle({String name = ''}) : super(null, name: name);
  EraserPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  var gridRows = <List<Cell>>[];
  var gridCols = <List<Cell>>[];

  var variableClues = <VariableClueDef>[
    (name: 'A', row: null, col: 2, valueDesc: '#perfect'),
    (name: 'B', row: 4, col: null, valueDesc: '#prime'),
    (name: 'C', row: null, col: 3, valueDesc: '2 * #prime'),
    (name: 'D', row: 0, col: null, valueDesc: '#triangular'),
    (name: 'E', row: 1, col: null, valueDesc: '#square'),
    (name: 'F', row: null, col: 0, valueDesc: '#palindrome'),
    // (name: 'Fr', row: 3, col: null, valueDesc: '#palindrome'),
    (name: 'G', row: null, col: 1, valueDesc: '#prime'),
    (name: 'H', row: null, col: 4, valueDesc: '#harshad'),
    (name: 'I', row: 2, col: null, valueDesc: '#square'),
  ];
  var variableValues = <String, List<int>>{};

  int checkVariables() {
    int ok = 0;
    // Get rows and cols
    for (var i = 0; i < grid!.numRows; i++) {
      gridRows.add(grid!.getRowCol(i, null));
    }
    for (var i = 0; i < grid!.numCols; i++) {
      gridCols.add(grid!.getRowCol(null, i));
    }

    // Generate possible variable values
    for (var variableClue in variableClues) {
      getVariableClueValues(variableClue);
    }

    try {
      // Enforce variable order
      enforceVariableValueOrder();

      // In reverse variable order, remove permitted digits to get value
      var erasedCells = <ErasedCell>[];
      ok = backtrackVariableClues(variableClues.length - 1, erasedCells);
    } on SolveError {
      return ok;
    }
    return ok;
  }

  void getVariableClueValues(
      ({int? col, String name, int? row, String valueDesc}) variableClue) {
    var cells = variableClue.row != null
        ? gridRows[variableClue.row!]
        : gridCols[variableClue.col!];
    var maxValue = cells.fold<int>(0, (value, cell) => value + cell.entryDigit);
    var minValue = 1;
    if (variableClue.valueDesc == '#perfect') {
      variableValues[variableClue.name] = [6];
    } else if (variableClue.valueDesc == '#prime') {
      variableValues[variableClue.name] =
          generatePrimes(minValue, maxValue).toList();
    } else if (variableClue.valueDesc == '2 * #prime') {
      variableValues[variableClue.name] =
          generatePrimes(minValue, maxValue ~/ 2).map((p) => 2 * p).toList();
    } else if (variableClue.valueDesc == '#triangular') {
      variableValues[variableClue.name] =
          generateTriangles(minValue, maxValue).toList();
    } else if (variableClue.valueDesc == '#square') {
      variableValues[variableClue.name] =
          generateSquares(minValue, maxValue).toList();
    } else if (variableClue.valueDesc == '#palindrome') {
      variableValues[variableClue.name] =
          generatePalindromes(minValue, maxValue).toList();
    } else if (variableClue.valueDesc == '#harshad') {
      variableValues[variableClue.name] =
          generateHarshads(minValue, maxValue).toList();
    } else {
      throw SolveException();
    }
  }

  void enforceVariableValueOrder() {
    var minValue = 1;
    for (var variableClue in variableClues) {
      var values = variableValues[variableClue.name]!;
      while (values.isNotEmpty && values.first < minValue) {
        values.removeAt(0);
      }
      if (values.isEmpty) throw SolveError();
      minValue = values.first + 1;
    }
    var maxValue = 1000;
    for (var variableClue in variableClues.reversed) {
      var values = variableValues[variableClue.name]!;
      while (values.isNotEmpty && values.last > maxValue) {
        values.removeLast();
      }
      if (values.isEmpty) throw SolveError();
      maxValue = values.last - 1;
    }
  }

  int backtrackVariableClues(int index, List<ErasedCell> erasedCells) {
    var variableClue = variableClues[index];
    var values = variableValues[variableClue.name]!;

    var cells = variableClue.row != null
        ? gridRows[variableClue.row!]
        : gridCols[variableClue.col!];
    var remainingCells = cells
        .where((cell) => !erasedCells.any((erasure) => erasure.cell == cell));
    var maxValue =
        remainingCells.fold<int>(0, (value, cell) => value + cell.entryDigit);

    // Try each possible value
    for (var value in values) {
      if (value > maxValue) continue;
      // Erase cells?
      if (value < maxValue) {
        // Try one cell
        for (var cell in remainingCells) {
          // Cell still permitted?
          var erasedRow =
              erasedCells.any((erasure) => erasure.fixedRow == cell.row);
          var erasedCol =
              erasedCells.any((erasure) => erasure.fixedCol == cell.col);
          if (variableClue.row != null && !erasedCol ||
              variableClue.col != null && !erasedRow) {
            // Can erase cell
            if (value == maxValue - cell.entryDigit) {
              var erasure = (
                cell: cell,
                row: cell.row,
                col: cell.col,
                value: cell.entryDigit,
                fixedRow: variableClue.row,
                fixedCol: variableClue.col,
              );
              erasedCells.add(erasure);
              // print('Erasure ${variableClue.name} $erasure');
              if (index == 0) {
                // Success
                print(
                    'Erased cells ${erasedCells.map((e) => '${e.row}${e.col}=${e.value}')}');
                return erasedCells.fold(0,
                    (previousValue, erasure) => previousValue + erasure.value);
              } else {
                var erased = backtrackVariableClues(index - 1, erasedCells);
                if (erased != 0) {
                  return erased;
                }
              }
              erasedCells.removeLast();
            }
          }
        }
      } else {
        // print('No Erasure ${variableClue.name}');
        if (index == 0) {
          // Success
          print(
              'Erased cells ${erasedCells.map((e) => '${e.row}${e.col}=${e.value}')}');
          return erasedCells.fold(
              0, (previousValue, erasure) => previousValue + erasure.value);
        } else {
          var erased = backtrackVariableClues(index - 1, erasedCells);
          if (erased != 0) {
            return erased;
          }
        }
      }
    }
    return 0;
  }
}
