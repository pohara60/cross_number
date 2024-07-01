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

  @override
  void initCrossnumber() {
    var puzzle = FactorsPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

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
        clueErrors += '${e.msg}\n';
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
        var entries = factorsCell.entries;
        if (entries.isNotEmpty) {
          factorsCell.exp.clueRefs.add(entries[0].name);
          factorsCell.addClueReference(entries[0].name);
          factorsCell.exp.clueRefs.add(entries[1].name);
          factorsCell.addClueReference(entries[1].name);
          factorsCell.addReferrer(entries[0]);
          factorsCell.addReferrer(entries[1]);
          entries[0].addReferrer(factorsCell);
          entries[1].addReferrer(factorsCell);
        }
        c++;
      }
      r++;
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  void solve([bool iteration = false]) {
    // puzzle.clues['A1']!.answer = 864;
    // puzzle.variables['A']!.answer = 2;
    // puzzle.variables['B']!.answer = 3;
    // puzzle.variables['C']!.answer = 5;
    // puzzle.variables['D']!.answer = 7;
    // puzzle.variables['E']!.answer = 11;
    // puzzle.variables['F']!.answer = 29;
    // puzzle.variables['G']!.answer = 19;
    // puzzle.clues['A4']!.answer = 21;
    // puzzle.clues['A6']!.answer = 18;
    // puzzle.clues['A7']!.answer = 280;
    // puzzle.clues['A8']!.answer = 24;
    // puzzle.clues['A9']!.answer = 45;
    // puzzle.clues['A10']!.answer = 638;
    // puzzle.clues['A13']!.answer = 76;
    // puzzle.clues['A15']!.answer = 40;
    // puzzle.clues['A16']!.answer = 750;
    // puzzle.clues['D1']!.answer = 81;
    // puzzle.clues['D2']!.answer = 684;
    // puzzle.clues['D3']!.answer = 42;
    // puzzle.clues['D4']!.answer = 28;
    // puzzle.clues['D5']!.answer = 105;
    // puzzle.clues['D8']!.answer = 264;
    // puzzle.clues['D9']!.answer = 475;
    // puzzle.clues['D11']!.answer = 30;
    // puzzle.clues['D12']!.answer = 87;
    // puzzle.clues['D14']!.answer = 60;

    super.solve(iteration);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }

    // Any two entries that meet are sure to share at least one prime factor.
    var entryMixin = clue as EntryMixin;
    for (var cell in entryMixin.cells) {
      for (var otherEntry in cell.entries) {
        if (otherEntry != entryMixin) {
          var ok = false;
          if (otherEntry.values == null) {
            ok = true;
          } else {
            for (var otherValue in otherEntry.values!) {
              var gcf = getGCF(value, otherValue);
              // Check the cell values include the gcf
              if (cell.values != null && !cell.values!.contains(gcf)) continue;
              // Check entries have a common factor
              if (gcf != 1) {
                ok = true;
                break;
              }
            }
          }
          if (!ok) {
            return false;
          }
        }
      }
    }
    return true;
  }

  // Clue solver
  bool solveFactorsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    //var puzzle = p as FactorsPuzzle;
    var clue = v as FactorsClue;
    var updated = false;
    // Values may have been set by other Clue
    clue.values ??= clue.getValuesFromDigits();
    if (clue.values != null) {
      var values =
          clue.values!.where((value) => validClue(clue, value, [], []));
      possibleValue.addAll(values);
    }
    return updated;
  }

  @override
  bool updateClues(
      FactorsPuzzle thisPuzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    var updated = super.updateClues(thisPuzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    return updated;
  }

  bool solveCell(Puzzle<Clue, Clue> p, Variable v, Set<int> possibleValue,
      {Set<int>? possibleValue2,
      Map<Variable, Set<int>>? possibleVariables,
      Map<Variable, Set<int>>? possibleVariables2,
      Set<Variable>? updatedVariables}) {
    var puzzle = p as FactorsPuzzle;
    var cell = v as FactorsCell;
    // The number in each cell is the greatest common factor of the two
    // entries that cross at that cell in the first grid.
    // The prime factorisation of each number in the second grid is shown.
    var updated = false;
    if (cell.expressions.isNotEmpty) {
      updated = puzzle.solveVariable(cell, cell.exp, possibleValue,
          possibleVariables!, validCell, 2000000);
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
      Set<int> possibleValues, Set<Variable> updatedVariables) {
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
    } else if (list1[i1] < list2[i2]) {
      i1++;
    } else // (list1[i1] > list2[i2])
    {
      i2++;
    }
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
