library dieanotherday;

import 'package:collection/collection.dart';
import 'package:crossnumber/set.dart';

import '../cartesian.dart';
import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the DieAnotherDay API.
class DieAnotherDay extends Crossnumber<DieAnotherDayPuzzle> {
  late DieAnotherDayPuzzle puzzleTop;
  late DieAnotherDayPuzzle puzzleFront;
  late DieAnotherDayPuzzle puzzleRight;
  late List<DieAnotherDayVariable> allVariables;

  var gridStringTop = [
    '+--+--+--+--+',
    '|1 :2 :3 :4 |',
    '+::+::+::+::+',
    '|5 :  :  :  |',
    '+::+::+::+::+',
    '|6 :  :  :  |',
    '+::+::+::+::+',
    '|7 :  :  :  |',
    '+--+--+--+--+',
  ];
  var gridStringFront = [
    '+--+--+--+--+',
    '|1 :2 :3 :4 |',
    '+::+::+::+::+',
    '|5 :  :  :  |',
    '+::+::+::+::+',
    '|6 :  :  :  |',
    '+::+::+::+::+',
    '|7 :  :  :  |',
    '+--+--+--+--+',
  ];
  var gridStringRight = [
    '+--+--+--+--+',
    '|1 :2 :3 :4 |',
    '+::+::+::+::+',
    '|5 :  :  :  |',
    '+::+::+::+::+',
    '|6 :  :  :  |',
    '+::+::+::+::+',
    '|7 :  :  :  |',
    '+--+--+--+--+',
  ];

  DieAnotherDay() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    // Create variables once

    var letters = [
      ('A', 21, 99, []),
      ('W', 1, 6, []),
      ('X', 1, 6, [1, 2, 3, 4]),
      ('Y', 1, 6, []),
      ('Z', 1, 6, []),
    ];
    allVariables = <DieAnotherDayVariable>[];
    var vA = DieAnotherDayVariable(letters[0]);
    var vW = DieAnotherDayVariable(letters[1]);
    var vX = DieAnotherDayVariable(letters[2]);
    var vY = DieAnotherDayVariable(letters[3]);
    var vZ = DieAnotherDayVariable(letters[4]);
    allVariables.addAll([vA, vW, vX, vY, vZ]);
    puzzleTop = DieAnotherDayPuzzle.grid(this, gridStringTop,
        name: 'Top', check: [vW, vX]);
    puzzleFront = DieAnotherDayPuzzle.grid(this, gridStringFront,
        name: 'Front', check: [vY]);
    puzzleRight = DieAnotherDayPuzzle.grid(this, gridStringRight,
        name: 'Right', check: [vZ]);

    EntryMixin.maxDigit = 6;
    for (var puzzle in [puzzleTop, puzzleFront, puzzleRight]) {
      this.puzzles.add(puzzle);

      var clueErrors = '';
      void clueWrapper({String? name, int? length, String? valueDesc}) {
        try {
          var clue = DieAnotherDayEntry(
              name: name!,
              length: length,
              valueDesc: valueDesc,
              solve: solveDieAnotherDayClue);
          puzzle.addEntry(clue);
          return;
        } on ExpressionError catch (e) {
          clueErrors += e.msg + '\n';
          return;
        }
      }

      if (puzzle == puzzleTop) {
        clueWrapper(name: 'A1', length: 4, valueDesc: r'#square - Y^2');
        clueWrapper(name: 'A5', length: 4, valueDesc: r'');
        clueWrapper(name: 'A6', length: 4, valueDesc: r'$multiple A');
        clueWrapper(name: 'A7', length: 4, valueDesc: r'#square');
        clueWrapper(name: 'D1', length: 4, valueDesc: r'#power3');
        clueWrapper(name: 'D2', length: 4, valueDesc: r'$multiple X*Y');
        clueWrapper(name: 'D3', length: 4, valueDesc: r'$multiple X*Y');
        clueWrapper(name: 'D4', length: 4, valueDesc: r'');
      }
      if (puzzle == puzzleFront) {
        clueWrapper(name: 'A1', length: 4, valueDesc: r'');
        clueWrapper(name: 'A5', length: 4, valueDesc: r'');
        clueWrapper(name: 'A6', length: 4, valueDesc: r'');
        clueWrapper(name: 'A7', length: 4, valueDesc: r'#square');
        clueWrapper(name: 'D1', length: 4, valueDesc: r'#square + W*Y*Z');
        clueWrapper(name: 'D2', length: 4, valueDesc: r'');
        clueWrapper(name: 'D3', length: 4, valueDesc: r'#sumdigits * X');
        clueWrapper(name: 'D4', length: 4, valueDesc: r'#power3');
      }
      if (puzzle == puzzleRight) {
        clueWrapper(name: 'A1', length: 4, valueDesc: r'');
        clueWrapper(name: 'A5', length: 4, valueDesc: r'A^2 - W');
        clueWrapper(name: 'A6', length: 4, valueDesc: r'');
        clueWrapper(name: 'A7', length: 4, valueDesc: r'#square');
        clueWrapper(name: 'D1', length: 4, valueDesc: r'');
        clueWrapper(name: 'D2', length: 4, valueDesc: r'$multiple (X + Z)');
        clueWrapper(name: 'D3', length: 4, valueDesc: r'');
        clueWrapper(name: 'D4', length: 4, valueDesc: r'');
      }

      if (clueErrors != '') {
        throw PuzzleException(clueErrors);
      }

      // Needed even when create entries from grid
      puzzle.validateEntriesFromGrid();

      puzzle.addDigitIdentityFromGrid();

      // Add variables to puzzle
      for (var variable in allVariables) {
        puzzle.letters[variable.name] = variable;
      }

      var clueError = '';
      // clueError = puzzle.checkClueEntryReferences();
      clueError = puzzle.checkClueClueReferences();
      // clueError += puzzle.checkEntryClueReferences();
      // clueError += puzzle.checkEntryEntryReferences();
      // Check variabes last, as prceeding may update them
      clueError += puzzle.checkVariableReferences();
      if (clueError != '') throw PuzzleException(clueError);
    }

    // Puzzle clues refer to each other because of dice faces
    var clueNames = puzzleTop.clues.keys;
    for (var i = 0; i < 3; i++) {
      var p1 = puzzles[i];
      for (var j = 0; j < 3; j++) {
        if (i == j) continue;
        var p2 = puzzles[j];
        for (var clueName1 in clueNames)
          for (var clueName2 in clueNames)
            if (clueName1 == clueName2 || clueName1[0] != clueName2[0]) {
              p1.clues[clueName1]!.addReferrer(p2.clues[clueName2]!);
            }
      }
    }

    super.initCrossnumber();
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

  bool facesMatchOtherPuzzles(
      DieAnotherDayPuzzle puzzle, String clueName, int digit, int face) {
    var faceTop = <int>[];
    var faceFront = <int>[];
    var faceRight = <int>[];
    if (puzzle == puzzleTop) {
      faceTop = [face];
      faceFront = puzzleFront.clues[clueName]!.clueDigits(digit);
      faceRight = puzzleRight.clues[clueName]!.clueDigits(digit);
    }
    if (puzzle == puzzleFront) {
      faceTop = puzzleTop.clues[clueName]!.clueDigits(digit);
      faceFront = [face];
      faceRight = puzzleRight.clues[clueName]!.clueDigits(digit);
    }
    if (puzzle == puzzleRight) {
      faceTop = puzzleTop.clues[clueName]!.clueDigits(digit);
      faceFront = puzzleFront.clues[clueName]!.clueDigits(digit);
      faceRight = [face];
    }
    // Check for unknown values
    if (faceTop.isEmpty || faceFront.isEmpty || faceRight.isEmpty) return true;
    // Check products
    try {
      for (var product in cartesian([faceTop, faceFront, faceRight])) {
        if (diceFaces.any((element) => ListEquality().equals(element, product)))
          return true;
      }
    } catch (e) {
      print('Exception $e');
    }
    return false;
  }

  var puzzleDigitCount = <int, int>{};
  bool facesMatch(DieAnotherDayPuzzle puzzle, Clue clue, int value,
      [List<String>? variableReferences, List<int>? variableValues]) {
    var entry = clue.entry!;
    var digitCount = <int, int>{};
    for (var d = entry.length! - 1; d >= 0; d--) {
      var digit = value % 10;
      if (!facesMatchOtherPuzzles(puzzle, clue.name, d, digit)) return false;
      // If the entry digit is not fixed, then include the digit in the count
      if (entry.digits[d].length != 1) {
        if (!digitCount.containsKey(digit))
          digitCount[digit] = 1;
        else
          digitCount[digit] = digitCount[digit]! + 1;
      }
      value = value ~/ 10;
    }
    // Check puzzle restriction
    for (var variable in puzzle.checkVariables) {
      var values = variable.values!;
      if (variableReferences != null) {
        var index = variableReferences.indexOf(variable.name);
        if (index != -1) values = {variableValues![index]};
      }
      for (var value in values) {
        if (puzzleDigitCount[value]! + (digitCount[value] ?? 0) <= value) {
          return true;
        }
      }
    }
    return false;
  }

  void getPuzzleDigitCount(DieAnotherDayPuzzle puzzle) {
    var digitCount = <int, int>{};
    for (var i in [1, 2, 3, 4, 5, 6]) digitCount[i] = 0;
    for (var clueName in ['D1', 'D2', 'D3', 'D4']) {
      var clue = puzzle.clues[clueName]!;
      var entry = clue.entry!;
      for (var d = 0; d < entry.length!; d++) {
        if (entry.digits[d].length == 1) {
          var digit = entry.digits[d].first;
          digitCount[digit] = digitCount[digit]! + 1;
        }
      }
    }
    puzzleDigitCount = digitCount;
  }

  void getPuzzleDigitCountFromClues(DieAnotherDayPuzzle puzzle) {
    var digitCount = <int, int>{};
    for (var i in [1, 2, 3, 4, 5, 6]) digitCount[i] = 0;
    for (var clueName in ['D1', 'D2', 'D3', 'D4']) {
      var clue = puzzle.clues[clueName]!;
      for (var d = 0; d < clue.length!; d++) {
        var digits = clue.clueDigits(d);
        if (digits.length == 1) {
          var digit = digits.first;
          digitCount[digit] = digitCount[digit]! + 1;
        }
      }
    }
    puzzleDigitCount = digitCount;
  }

  /*
  Solution 1	
  W	1
  X	6
  Y	4
  Z	5
  A	66
  Puzzle Top	
  A1	6545
  A5	5644
  A6	6666
  A7	1444
  Puzzle Front	
  A1	4413
  A5	6511
  A6	4522
  A7	4225
  Puzzle Right	
  A1	5156
  A5	4355
  A6	5344
  A7	2116
  */

  @override
  void solve([bool iteration = true]) {
    // Front D3 starts with 1
    puzzleFront.clues['D3']!.digits[0] = {1};

    // puzzleTop.clues['A1']!.value = 6545;
    // puzzleTop.clues['A5']!.value = 5644;
    // puzzleTop.clues['A6']!.value = 6666;
    // puzzleTop.clues['A7']!.value = 1444;

    // puzzleFront.clues['A1']!.value = 4413;
    // puzzleFront.clues['A5']!.value = 6511;
    // puzzleFront.clues['A6']!.value = 4522;
    // puzzleFront.clues['A7']!.value = 4225;

    // puzzleRight.clues['A1']!.value = 5156;
    // puzzleRight.clues['A5']!.value = 4355;
    // puzzleRight.clues['A6']!.value = 5344;
    // puzzleRight.clues['A7']!.value = 2116;

    super.solve(iteration);
  }

  @override
  bool solveClue(Clue clue) {
    var updated = super.solveClue(clue);

    var puzzle = puzzleForVariable[clue]!;

    // Check puzzle restriction
    var allUpdatedVariables = <String>{};
    getPuzzleDigitCount(puzzle);
    var ok = checkPuzzleVariables(puzzle, allUpdatedVariables);
    if (!ok) {
      throw SolveException();
    }
    if (allUpdatedVariables.isNotEmpty && Crossnumber.traceSolve) {
      print('DieAnotherDay variable count updates');
      for (var variableName in allUpdatedVariables) {
        print(
            '$variableName=${puzzle.variables[variableName]!.values!.toShortString()}');
      }
    }

    return updated;
  }

  bool checkPuzzleVariables(
      DieAnotherDayPuzzle puzzle, Set<String> allUpdatedVariables,
      [bool updateVars = true, bool equality = false]) {
    var knownVariableValues = <int>{};
    for (var variable in allVariables) {
      var possibleValues = <int>{};
      var updatedVariables = <String>{};
      var updated = false;
      var isPuzzleVariable = puzzle.checkVariables.contains(variable);
      for (var value in variable.values!) {
        if (!knownVariableValues.contains(value) &&
            (!isPuzzleVariable ||
                !equality && puzzleDigitCount[value]! < value ||
                puzzleDigitCount[value]! == value)) {
          possibleValues.add(value);
        } else
          updated = true;
      }
      if (possibleValues.isEmpty) {
        return false;
      }
      if (possibleValues.length == 1) {
        var value = possibleValues.first;
        if (knownVariableValues.contains(value)) {
          return false;
        }
        knownVariableValues.add(value);
      }
      if (updateVars && updated) {
        updateVariables(
            puzzle, variable.name, possibleValues, updatedVariables);
        allUpdatedVariables.addAll(updatedVariables);
      }
    }
    return true;
  }

  // Validate possible clue value
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (value < 0) return false;
    if (clue.min != null && value < clue.min!) return false;
    if (clue.max != null && value > clue.max!) return false;
    if (clue.values != null && !clue.values!.contains(value)) return false;
    if (!clue.digitsMatch(value)) return false;

    // Check digits against other puzzles
    var puzzle = puzzleForVariable[clue]!;
    return facesMatch(puzzle, clue, value, variableReferences, variableValues);
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveDieAnotherDayClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as DieAnotherDayPuzzle;
    var clue = v as DieAnotherDayClue;
    var updated = false;
    getPuzzleDigitCount(puzzle);
    if (clue.valueDesc != null && clue.valueDesc != '') {
      try {
        updated = puzzle.solveExpressionEvaluator(
            clue, clue.exp, possibleValue, possibleVariables!, validClue);
      } on SolveException catch (_) {}
    }
    if (possibleValue.isEmpty) {
      if (clue.values != null) {
        // Values may have been set by other Clue
        var values =
            clue.values!.where((value) => validClue(clue, value, [], []));
        possibleValue.addAll(values);
      } else {
        // Get values from digits
        var values = clue.getValuesFromDigits();
        if (values != null) {
          possibleValue.addAll(values);
        } else {
          // No further action
          throw SolveException();
        }
      }
    }

    return updated;
  }

  @override
  bool updateClues(
      DieAnotherDayPuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false}) {
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    return updated;
  }

  var unfinishedPuzzles = <DieAnotherDayPuzzle>[];
  @override
  void endSolve(bool iteration) {
    // Unique solution?
    for (var puzzle in puzzles) {
      if (!puzzle.uniqueSolution()) {
        unfinishedPuzzles.add(puzzle);
        if (Crossnumber.traceSolve) {
          print("PARTIAL SOLUTION-----------------------------");
          print(puzzle.toSummary());
          // print(puzzle.toString());
        }
      } else {
        print("SOLUTION-----------------------------");
        print(puzzle.toSummary());
      }
    }
    // puzzleTop.clues['A1']!.value = 6545;
    // puzzleTop.clues['A5']!.value = 5644;
    // puzzleTop.clues['A6']!.value = 6666;
    // puzzleTop.clues['A7']!.value = 1444;

    // puzzleFront.clues['A1']!.value = 4413;
    // puzzleFront.clues['A5']!.value = 6511;
    // puzzleFront.clues['A6']!.value = 4522;
    // puzzleFront.clues['A7']!.value = 4225;

    // puzzleRight.clues['A1']!.value = 5156;
    // puzzleRight.clues['A5']!.value = 4355;
    // puzzleRight.clues['A6']!.value = 5344;
    // puzzleRight.clues['A7']!.value = 2116;
    if (unfinishedPuzzles.isNotEmpty) {
      unfinishedPuzzles = [puzzleFront, puzzleRight, puzzleTop];
      unfinishedPuzzles.first.postProcessing(iteration);
    }
  }

  int callback(DieAnotherDayPuzzle puzzle) {
    // Puzzle has found a valid solution, check futher puzzles
    var index = unfinishedPuzzles.indexOf(puzzle);
    if (index + 1 == unfinishedPuzzles.length) {
      // Finished!
      print("SOLUTION-----------------------------");
      for (var puzzle in puzzles) {
        if (puzzle.uniqueSolution()) {
          print(puzzle.toSummary());
        }
      }
      return 1;
    }

    return unfinishedPuzzles[index + 1].iterate(callback);
  }

  bool checkSolution(Puzzle puzzle) {
    var ok = true;
    ok = ok && allVariables[0].value == 66;
    ok = ok && allVariables[1].value == 1;
    ok = ok && allVariables[2].value == 6;
    ok = ok && allVariables[3].value == 4;
    ok = ok && allVariables[4].value == 5;
    if (!ok) return ok;
    if (puzzle == puzzleTop) {
      ok = ok && puzzleTop.clues['A1']!.value == 6545;
      ok = ok && puzzleTop.clues['A5']!.value == 5644;
      ok = ok && puzzleTop.clues['A6']!.value == 6666;
      ok = ok && puzzleTop.clues['A7']!.value == 1444;
    } else if (puzzle == puzzleFront) {
      ok = ok && puzzleFront.clues['A1']!.value == 4413;
      ok = ok && puzzleFront.clues['A5']!.value == 6511;
      ok = ok && puzzleFront.clues['A6']!.value == 4522;
      ok = ok && puzzleFront.clues['A7']!.value == 4225;
    } else if (puzzle == puzzleRight) {
      ok = ok && puzzleRight.clues['A1']!.value == 5156;
      ok = ok && puzzleRight.clues['A5']!.value == 4355;
      ok = ok && puzzleRight.clues['A6']!.value == 5344;
      ok = ok && puzzleRight.clues['A7']!.value == 2116;
    }
    return ok;
  }
}
