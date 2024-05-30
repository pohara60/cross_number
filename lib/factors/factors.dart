library factors;

import 'dart:math';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../monadic.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'grid.dart';
import 'puzzle.dart';

/// Provide access to the Factors API.
class Factors extends Crossnumber<FactorsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :3 |4 :5 |',
    '+::+::+::+::+::+',
    '|6 :  |7 :  :  |',
    '+--+::+--+--+::+',
    '|8 :  |  |9 :  |',
    '+::+--+--+::+--+',
    '|10:11:12|13:14|',
    '+::+::+::+::+::+',
    '|15:  |16:  :  |',
    '+--+--+--+--+--+',
  ];

  Factors() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = FactorsPuzzle.fromGridString(gridString);
    this.puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = FactorsEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveFactorsClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'');
    clueWrapper(name: 'A4', length: 2, valueDesc: r'');
    clueWrapper(name: 'A6', length: 2, valueDesc: r'');
    clueWrapper(name: 'A7', length: 3, valueDesc: r'');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'');
    clueWrapper(name: 'A10', length: 3, valueDesc: r'');
    clueWrapper(name: 'A13', length: 2, valueDesc: r'');
    clueWrapper(name: 'A15', length: 2, valueDesc: r'');
    clueWrapper(name: 'A16', length: 3, valueDesc: r'');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'');
    clueWrapper(name: 'D8', length: 3, valueDesc: r'');
    clueWrapper(name: 'D9', length: 3, valueDesc: r'');
    clueWrapper(name: 'D11', length: 2, valueDesc: r'');
    clueWrapper(name: 'D12', length: 2, valueDesc: r'');
    clueWrapper(name: 'D14', length: 2, valueDesc: r'');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid(
        (int row, int col, String face) => FactorsCell(row, col, face));
    // Add cells to puzzle variables
    puzzle.addCellVariables();

    var letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(FactorsVariable(letter));
    }
    var cellExpresssions = [
      ['BBB', 'AABB', 'AB', 'D', 'BD'],
      ['BB', 'ABB', 'AD', 'AAD', 'CD'],
      ['AAAB', 'AAB', '', 'C', 'BC'],
      ['AE', 'A', 'F', 'G', 'AA'],
      ['AAA', 'AC', 'B', 'CC', 'ABC'],
    ];
    // Cells have expressions with variable references
    int r = 0;
    for (var row in puzzle.grid!.rows) {
      int c = 0;
      for (var cell in row) {
        var factorsCell = cell as FactorsCell;
        factorsCell.setExp(cellExpresssions[r][c], solveCell);
        // Cells also depend on the intersecting entries
        if (factorsCell.entries.isNotEmpty) {
          factorsCell.exp.clueRefs.add(factorsCell.entries[0].name);
          factorsCell.addClueReference(factorsCell.entries[0].name);
          factorsCell.exp.clueRefs.add(factorsCell.entries[1].name);
          factorsCell.addClueReference(factorsCell.entries[1].name);
        }
        c++;
      }
      r++;
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkPuzzleVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  @override
  void solve([bool iteration = false]) {
    super.solve(iteration);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;

    // TODO Any two entries that meet are sure to share at least one prime factor.
    return true;
  }

  // Clue solver
  bool solveFactorsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    //var puzzle = p as FactorsPuzzle;
    var clue = v as FactorsClue;
    var updated = false;
    // Values may have been set by other Clue
    if (clue.values == null) {
      clue.values = clue.getValuesFromDigits();
    }
    if (clue.values != null) {
      var values =
          clue.values!.where((value) => validClue(clue, value, [], []));
      possibleValue.addAll(values);
    }
    return updated;
  }

  @override
  bool updateClues(
      FactorsPuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    return updated;
  }

  bool solveCell(Puzzle<Clue, Clue> p, Variable v, Set<int> possibleValue,
      {Set<int>? possibleValue2,
      Map<String, Set<int>>? possibleVariables,
      Map<String, Set<int>>? possibleVariables2,
      Set<String>? updatedVariables}) {
    var puzzle = p as FactorsPuzzle;
    var cell = v as FactorsCell;
    // The number in each cell is the greatest common factor of the two
    // entries that cross at that cell in the first grid.
    // The prime factorisation of each number in the second grid is shown.
    var updated = false;
    if (cell.expressions.isNotEmpty) {
      updated = puzzle.solveVariable(
          cell, cell.exp, possibleValue, possibleVariables!, validCell);
    }
    return updated;
  }

  bool validCell(Variable v, int value, List<String> variableReferences,
      List<int> variableValues) {
    // The number in each cell is the greatest common factor of the two
    // entries that cross at that cell in the first grid.
    // These are the last two variable references
    // var cell = v as FactorsCell;
    var gcf = getGCF(variableValues[variableValues.length - 1],
        variableValues[variableValues.length - 2]);
    // checkGCFs(value, cell.entries[0].values, cell.entries[1].values);
    return gcf == value;
  }

  @override
  bool updateVariables(FactorsPuzzle puzzle, String variableName,
      Set<int> possibleValues, Set<String> updatedVariables) {
    if (puzzle.variables.containsKey(variableName)) {
      return super.updateVariables(
          puzzle, variableName, possibleValues, updatedVariables);
    }
    // Cell
    var cell = puzzle.allVariables[(VariableType.G, variableName)]!;
    return cell.updatePossible(possibleValues);
  }
}

var cacheGCFs = <(int, int), int>{};
var cacheFactors = <List<int>>[];

void initGCFs() {
  cacheFactors.add([]);
  // Hard coded maximum entry of 999
  for (var i = 1; i < 1000; i++) {
    var list1 = List<int>.from(factors(i));
    cacheFactors.add(list1);
    for (var j = 1; j < i; j++) {
      var list2 = cacheFactors[j];
      var common = intersection(list1, list2);

      cacheGCFs[(i, j)] = common.isEmpty
          ? 1
          : common.reduce((value, element) => value * element);
    }
    cacheGCFs[(i, i)] = i;
  }
}

int getGCF(int v1, int v2) {
  if (cacheFactors.isEmpty) initGCFs();
  var c1 = v1 >= v2 ? v1 : v2;
  var c2 = v1 >= v2 ? v2 : v1;
  return cacheGCFs[(c1, c2)]!;
}

List<int> intersection(List<int> list1, List<int> list2) {
  var i1 = 0;
  var i2 = 0;
  var result = <int>[];
  while (i1 < list1.length && i2 < list2.length) {
    if (list1[i1] == list2[i2]) {
      result.add(list1[i1]);
      i1++;
      i2++;
    } else if (list1[i1] < list2[i2])
      i1++;
    else // (list1[i1] > list2[i2])
      i2++;
  }
  return result;
}

bool checkGCFs(int value, Set<int>? s1, Set<int>? s2) {
  if (s1 == null || s2 == null) return true;
  var m1 = s1.reduce(max);
  var m2 = s2.reduce(max);
  if (value > m1 || value > m2) return false;
  if (cacheFactors.isEmpty) initGCFs();
  for (var v1 in s1.where((element) => element >= value)) {
    for (var v2 in s2.where((element) => element >= value)) {
      if (getGCF(v1, v2) == value) {
        return true;
      }
    }
  }
  return false;
}

bool checkFactors(int value, Set<int>? s1) {
  if (cacheFactors.isEmpty) initGCFs();
  if (s1 == null) return true;
  for (var v1 in s1) {
    var c1 = v1 >= value ? v1 : value;
    var c2 = v1 >= value ? value : v1;
    var gcf = cacheGCFs[(c1, c2)];
    if (gcf == 1 || gcf == value) return false;
  }
  return true;
}
