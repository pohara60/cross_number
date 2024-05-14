import 'dart:math';

import '../crossnumber.dart';
import '../no21/puzzle.dart';

import '../clue.dart';
import '../expression.dart';
import '../monadic.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';

class No21 extends Crossnumber<No21Puzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :2 |3 :4 |5 :6 :  |',
    '+::+::+::+::+--+::+--+',
    '|7 :  :  |8 :  |9 :  |',
    '+::+--+::+::+--+::+--+',
    '|10:11|12:  |13:  :14|',
    '+--+::+--+::+::+--+::+',
    '|15:  :16:  :  :17:  |',
    '+::+--+::+::+--+::+--+',
    '|18:19:  |20:21|22:23|',
    '+--+::+--+::+::+--+::+',
    '|24:  |25:  |26:27:  |',
    '+--+::+--+::+::+::+::+',
    '|28:  :  |29:  |30:  |',
    '+--+--+--+--+--+--+--+',
  ];

  No21() {
    puzzle = No21Puzzle.fromGridString(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {String? name,
        int? length,
        String? valueDesc,
        SolveFunction? solve,
        int cellsTwoDigits = 1}) {
      try {
        var clue = No21Clue(
            name: name,
            length: length,
            valueDesc: valueDesc,
            solve: solve,
            cellsTwoDigits: cellsTwoDigits);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 2, valueDesc: "B+Y", solve: solveNo21Clue);
    clueWrapper(name: 'A2', length: 2, valueDesc: "IN", solve: solveNo21Clue);
    clueWrapper(name: 'A3', length: 2, valueDesc: "C+K", solve: solveNo21Clue);
    clueWrapper(name: 'A4', length: 2, valueDesc: "DF", solve: solveNo21Clue);
    clueWrapper(name: 'A5', length: 2, valueDesc: "C'", solve: solveNo21Clue);
    clueWrapper(name: 'A6', length: 2, valueDesc: "C+FT", solve: solveNo21Clue);
    clueWrapper(name: 'A7', length: 2, valueDesc: "L'", solve: solveNo21Clue);
    clueWrapper(
        name: 'A8', length: 2, valueDesc: "B^N-N", solve: solveNo21Clue);
    clueWrapper(
        name: 'A9', length: 2, valueDesc: "N(R^N)", solve: solveNo21Clue);
    clueWrapper(
        name: 'A10', length: 2, valueDesc: "A!-(IR)'", solve: solveNo21Clue);
    clueWrapper(name: 'A11', length: 2, valueDesc: "GNT", solve: solveNo21Clue);
    clueWrapper(name: 'A12', length: 3, valueDesc: "IJ", solve: solveNo21Clue);
    clueWrapper(
        name: 'A13', length: 3, valueDesc: "(AEI)'", solve: solveNo21Clue);
    clueWrapper(
        name: 'A14', length: 3, valueDesc: "I'(N^A)'", solve: solveNo21Clue);
    clueWrapper(
        name: 'A15',
        length: 3,
        valueDesc: "((C+K)(N^A))'",
        solve: solveNo21Clue);
    clueWrapper(
        name: 'A16',
        length: 2,
        valueDesc: "A(E^A)",
        solve: solveNo21Clue,
        cellsTwoDigits: 1);
    clueWrapper(
        name: 'A17', length: 3, valueDesc: "(G!+I'K)'", solve: solveNo21Clue);
    clueWrapper(
        name: 'A18', length: 3, valueDesc: "D+(E^F)JR", solve: solveNo21Clue);
    clueWrapper(
        name: 'A19',
        length: 7,
        valueDesc: "(#square * #prime)'",
        solve: solveReversedSquarePrimeClue);

    clueWrapper(name: 'D20', length: 2, valueDesc: "T", solve: solveNo21Clue);
    clueWrapper(name: 'D21', length: 2, valueDesc: "I", solve: solveNo21Clue);
    clueWrapper(name: 'D22', length: 2, valueDesc: "BR", solve: solveNo21Clue);
    clueWrapper(
        name: 'D23', length: 2, valueDesc: "(B+D)(J-D)N", solve: solveNo21Clue);
    clueWrapper(
        name: 'D24', length: 2, valueDesc: "C+I+J+K+L+T", solve: solveNo21Clue);
    clueWrapper(
        name: 'D25', length: 2, valueDesc: "F(C+K)", solve: solveNo21Clue);
    clueWrapper(
        name: 'D26', length: 3, valueDesc: "(JL')'", solve: solveNo21Clue);
    clueWrapper(
        name: 'D27', length: 3, valueDesc: "A(AJ-O)", solve: solveNo21Clue);
    clueWrapper(
        name: 'D28', length: 2, valueDesc: "(CER)'", solve: solveNo21Clue);
    clueWrapper(
        name: 'D29', length: 2, valueDesc: "F^A-DT", solve: solveNo21Clue);
    clueWrapper(
        name: 'D30', length: 3, valueDesc: "D(D^N-G)", solve: solveNo21Clue);
    clueWrapper(
        name: 'D31', length: 3, valueDesc: "AL'NT", solve: solveNo21Clue);
    clueWrapper(
        name: 'D32', length: 3, valueDesc: "(LY-O)RY", solve: solveNo21Clue);
    clueWrapper(
        name: 'D33',
        length: 3,
        valueDesc: "K'(N(D^N)-M!)",
        solve: solveNo21Clue);
    clueWrapper(
        name: 'D34',
        length: 7,
        valueDesc: "(#square * #prime)'",
        solve: solveReversedSquarePrimeClue);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = No21Entry(name: entrySpec.name, length: entrySpec.length);
        puzzle.addEntry(entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += e.msg + '\n';
      }
    }

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    puzzle.linkEntriesToGrid();

    var letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'R',
      'T',
      'Y',
    ];
    for (var letter in letters) {
      puzzle.addVariable(No21Variable(letter));
      // for (var clue in puzzle.clues.values) {
      //   if (clue.valueDesc!.contains(letter)) {
      //     clue.addLetterReference(letter);
      //   }
      // }
    }

    var clueError = '';
    // clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    // clueError += puzzle.checkEntryClueReferences();
    // clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as prceeding may update them
    clueError += puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveNo21Clue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as No21Puzzle;
    var clue = v as No21Clue;

    // Clues are defined in ascending order of value
    for (var otherClue
        in puzzle.clues.values.where((c) => c.isAcross == clue.isAcross)) {
      if (int.parse(otherClue.name.substring(1)) <
          int.parse(clue.name.substring(1))) {
        var otherMin = otherClue.values != null
            ? otherClue.values!.reduce(min)
            : otherClue.min;
        if (otherMin != null && otherMin >= clue.min!) {
          clue.min = otherMin + 1;
        }
      }
      if (int.parse(otherClue.name.substring(1)) >
          int.parse(clue.name.substring(1))) {
        var otherMax = otherClue.values != null
            ? otherClue.values!.reduce(max)
            : otherClue.max;
        if (otherMax != null && otherMax <= clue.max!) {
          clue.max = otherMax - 1;
        }
      }
    }
    var updated = puzzle.solveExpressionEvaluator(
        clue, clue.exp, possibleValue, possibleVariables!, validClue);
    return updated;
  }

  // Clue solver for 7-digit (square*prime)'
  bool solveReversedSquarePrimeClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var clue = v as No21Clue;

    // Do not use evaluator as too many possibilities
    // puzzle.solveExpressionEvaluator(
    //     clue, possibleValue, possibleVariables, validClue);

    // Get value from entry values
    if (clue.entry != null && clue.entry!.values != null) {
      for (var value in clue.entry!.values!) {
        var reversedValue = reverse(value);
        var factors = getFactors(reversedValue).toList();
        if (factors.length == 3 &&
            (factors[0] == factors[1] || factors[1] == factors[2])) {
          // square * prime
          if (clue.digitsMatch(value)) {
            possibleValue.add(value);
          }
        }
      }
    }
    return false;
  }

  void mapCallback() {
    var mapping =
        "${puzzle.entries.values.where((e) => e.clue != null).map((e) {
      var c = e.clue!;
      return '${e.name}=${c.name}${c.values})';
    }).join(',')}";
    print('Mapping $mapping');
    print(puzzle.toSolution());
  }

  void solve([bool iteration = true]) {
    print("SOLVE------------");

    try {
      // Solve clues
      super.solve(false);

      // The two double-digits in A16 cause a lot of ambiguity
      // Attemptimg to solve the puzzle with one double-digit yields
      // an almost complete solution where A16 has no value.
      // Then increasing the double-digits in A16 finds its value
      (puzzle.clues['A16'] as No21Clue).cellsTwoDigits = 2;
      super.solve(false);

      // Only possible mapping for these clues
      puzzle.mapClueToEntryByName('A19', 'A15');
      puzzle.mapClueToEntryByName('D34', 'D4');

      // Map clues to entries, updates entry values and digits
      puzzle.mapCluesToEntries(mapCallback);

      // Partial Solution
      // Ambiguities:
      // A2(26)/A3(29) in A3/A8 constraint on 2
      // A3(29))/A6(59) in A8/A25 no constraint
      // A5(51)/A6(59) in A8/A25 no constraint
      // D21(13)/D25(16) in D11/D13 constraint on 1

      // solve D32 to resolve only possible value and so variable O
      solveClue(puzzle.clues['D32']!);

      // solve A19 and D34 from the entry values
      solveClue(puzzle.clues['A19']!);
      solveClue(puzzle.clues['D34']!);

      // Re-map clues to entries to resolve ambiguity
      puzzle.mapCluesToEntries(mapCallback);

      // Partial Solution
      // Ambiguities:
      // A3(29))/A6(59) in A8/A25 no constraint

      // solve D34 from the entry values
      solveClue(puzzle.clues['D34']!);

      // Re-map clues to entries to resolve ambiguity
      puzzle.mapCluesToEntries(mapCallback);

      print("SOLUTION-----------------------------");
      print(puzzle.toSummary());

      var variableList = puzzle.variableList;
      var valueMapping = <int, String>{};
      for (var variable in variableList.variables.values) {
        var name = variable.name;
        var value =
            variable.values?.length == 1 ? variable.values!.first : null;
        if (value != null) {
          valueMapping[value] = name;
        }
      }

      var entryValues = <String, List<String>>{};
      for (var entry in puzzle.entries.values) {
        var e = entry;
        entryValues[entry.name] = e.digits
            .map((dl) => dl.length == 1
                ? valueMapping[dl.first] ?? '?'
                : dl.length == 0
                    ? ''
                    : '?')
            .toList();
        ;
      }
      print("LETTER GRID-----------------------------");
      print(puzzle.gridSpec!.solutionToString(entryValues));
    } on SolveException catch (e) {
      if (e.msg != null) print(e.msg);
    }
  }
}
