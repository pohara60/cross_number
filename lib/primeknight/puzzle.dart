import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class PrimeKnightVariable extends Variable {
  PrimeKnightVariable(letter) : super(letter) {
    this.values = Set.from([]);
  }
  String get letter => this.name;
}

class PrimeKnightPuzzle extends VariablePuzzle<PrimeKnightClue,
    PrimeKnightEntry, PrimeKnightVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  PrimeKnightPuzzle({String name = ''}) : super(null, name: name);
  PrimeKnightPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString(null, gridString, name: name);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  List<List<(int, int)>> knightTours() {
    // Count knight tours starting in top-left and ending in bottom-right
    // visiting each cell once
    // Create board from grid of cells
    var board = List<List<int>>.from(
        gridSpec!.cells.map((r) => List<int>.from(r.map((c) => 0))));
    var tours = <List<(int, int)>>[];
    var count = visitNextCell(board, 0, 0, 0, 0, tours, <(int, int)>[]);
    // print('$count knight tours');
    return tours;
  }

  static const knightsMoves = [
    (-2, -1),
    (-2, 1),
    (-1, -2),
    (-1, 2),
    (1, -2),
    (1, 2),
    (2, -1),
    (2, 1),
  ];
  visitNextCell(List<List<int>> board, int i, int j, int depth, int count,
      List<List<(int, int)>> tours, List<(int, int)> tour) {
    if (i < 0 || i >= board.length) return count;
    if (j < 0 || j >= board[i].length) return count;
    if (board[i][j] != 0) return count;
    // Valid cell
    depth++;
    board[i][j] = depth;
    tour.add((i, j));
    if (depth < board.length * board[i].length) {
      // Next cells
      for (var (ii, jj) in knightsMoves) {
        count = visitNextCell(board, i + ii, j + jj, depth, count, tours, tour);
      }
    } else {
      // Finished board - must be last cell
      if (i == board.length - 1 && j == board[i].length - 1) {
        count = count + 1;
        tours.add(List.from(tour));
      }
    }
    // Undo this cell
    board[i][j] = 0;
    tour.removeLast();
    return count;
  }
}
