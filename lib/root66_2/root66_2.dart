/// An API for solving Prime Cuts puzzles.
library root66;

import '../puzzle.dart';
import '../crossnumber.dart';
import '../clue.dart';
import '../root66_2/clue.dart';
import '../root66_2/puzzle.dart';

import '../expression.dart';
import '../variable.dart';

/// Provide access to the Prime Cuts API.
class Root66_2 extends Crossnumber<Root66_2Puzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|  |1 |2 :3 :4 :5 |6 |  |',
    '+--+::+::+::+::+::+::+--+',
    '|7 :  :  :  :  :  :  :  |',
    '+--+::+::+::+::+::+::+--+',
    '|8 :  :  :  |9 :  :  :10|',
    '+::+::+::+::+::+::+::+::+',
    '|11:  :  :  |12:  :  :  |',
    '+::+::+--+--+--+--+::+::+',
    '|13:  :14:15|16:17:  :  |',
    '+::+::+::+::+::+::+::+::+',
    '|18:  :  :  |19:  :  :  |',
    '+--+::+::+::+::+::+::+--+',
    '|20:  :  :  :  :  :  :  |',
    '+--+::+::+::+::+::+::+--+',
    '|  |  |21:  :  :  |  |  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  Root66_2() {
    puzzle = Root66_2Puzzle.grid(gridString);
    initCrossnumber();
    initBCEFG();
  }

  void initCrossnumber() {
    var entryErrors = '';
    void entryWrapper(
        {String? name,
        int? length,
        Root66_2EntryType type = Root66_2EntryType.UNKNOWN}) {
      try {
        var entry = Root66_2Entry(name: name, length: length, type: type);
        puzzle.addEntry(entry);
        return;
      } on ExpressionError catch (e) {
        entryErrors += e.msg + '\n';
        return;
      }
    }

    var clueErrors = '';
    void clueWrapper(
        {required String name,
        required int length,
        String? valueDesc,
        SolveFunction? solve}) {
      try {
        var clue = Root66_2Clue(
            name: name, length: length, valueDesc: valueDesc, solve: solve);
        puzzle.addClue(clue);
        puzzle.mapClueToEntryByName(name, name);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    entryWrapper(name: 'A2', length: 4);
    entryWrapper(name: 'A7', length: 8, type: Root66_2EntryType.BCEFG);
    entryWrapper(name: 'A8', length: 4);
    entryWrapper(name: 'A9', length: 4);
    entryWrapper(name: 'A11', length: 4);
    entryWrapper(name: 'A12', length: 4);
    entryWrapper(name: 'A13', length: 4);
    entryWrapper(name: 'A16', length: 4);
    entryWrapper(name: 'A18', length: 4);
    entryWrapper(name: 'A19', length: 4);
    entryWrapper(name: 'A20', length: 8, type: Root66_2EntryType.BCEFG);
    entryWrapper(name: 'A21', length: 4);

    entryWrapper(name: 'D1', length: 8, type: Root66_2EntryType.BCEFG);
    entryWrapper(name: 'D2', length: 4);
    entryWrapper(name: 'D3', length: 4);
    entryWrapper(name: 'D4', length: 4);
    entryWrapper(name: 'D5', length: 4);
    entryWrapper(name: 'D6', length: 8, type: Root66_2EntryType.BCEFG);
    entryWrapper(name: 'D8', length: 4);
    entryWrapper(name: 'D10', length: 4);
    entryWrapper(name: 'D14', length: 4);
    entryWrapper(name: 'D15', length: 4);
    entryWrapper(name: 'D16', length: 4);
    entryWrapper(name: 'D17', length: 4);

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    clueWrapper(
        name: 'A2',
        length: 4,
        valueDesc: '-D+U*R^(A+T)+I+O*N^S',
        solve: solveBCEFG);
    clueWrapper(name: 'A7', length: 8, valueDesc: '', solve: solveBCEFG);
    clueWrapper(
        name: 'A8', length: 4, valueDesc: 'R+O(TU+N)DA', solve: solveBCEFG);
    clueWrapper(
        name: 'A9',
        length: 4,
        valueDesc: '(S+I+T^A+RO-U-N)D',
        solve: solveBCEFG);
    clueWrapper(
        name: 'A11',
        length: 4,
        valueDesc: 'U((N+I)^T-(A+R)D)S',
        solve: solveBCEFG);
    clueWrapper(
        name: 'A12',
        length: 4,
        valueDesc: '(A+S)T(R^O-√(ID))',
        solve: solveBCEFG);
    clueWrapper(
        name: 'A13',
        length: 4,
        valueDesc: 'S*U^T+(O+R+I)A+N',
        solve: solveBCEFG);
    clueWrapper(
        name: 'A16',
        length: 4,
        valueDesc: '(DI-NO)(S+T)A+R',
        solve: solveBCEFG);
    clueWrapper(
        name: 'A18',
        length: 4,
        valueDesc: '(T/R)*I^N*(ODU+S)',
        solve: solveBCEFG);
    clueWrapper(
        name: 'A19',
        length: 4,
        valueDesc: '(T*U^N*(D+R)+A)S',
        solve: solveBCEFG);
    clueWrapper(name: 'A20', length: 8, valueDesc: '', solve: solveBCEFG);
    clueWrapper(
        name: 'A21', length: 4, valueDesc: '-(√I)N+TRADO+S', solve: solveBCEFG);

    clueWrapper(name: 'D1', length: 8, valueDesc: '', solve: solveBCEFG);
    clueWrapper(
        name: 'D2',
        length: 4,
        valueDesc: '-D+U(R+A)(T^I+O*N^S)',
        solve: solveBCEFG);
    clueWrapper(
        name: 'D3', length: 4, valueDesc: 'DI(N^O*S+A+U)R', solve: solveBCEFG);
    clueWrapper(
        name: 'D4', length: 4, valueDesc: '(AROU+N)D', solve: solveBCEFG);
    clueWrapper(
        name: 'D5',
        length: 4,
        valueDesc: 'A(U+D)+(I+T+O)*R^S',
        solve: solveBCEFG);
    clueWrapper(name: 'D6', length: 8, valueDesc: '', solve: solveBCEFG);
    clueWrapper(
        name: 'D8', length: 4, valueDesc: 'S-A+U^T*(O+I-R)', solve: solveBCEFG);
    clueWrapper(
        name: 'D10',
        length: 4,
        valueDesc: '(S(U+D-A)-T)IO+N',
        solve: solveBCEFG);
    clueWrapper(
        name: 'D14',
        length: 4,
        valueDesc: 'R-(A+I+N+O-U^T)S',
        solve: solveBCEFG);
    clueWrapper(
        name: 'D15',
        length: 4,
        valueDesc: '((N+U)^T+RI+S+O+D)A',
        solve: solveBCEFG);
    clueWrapper(
        name: 'D16',
        length: 4,
        valueDesc: 'R(O(√D-A+UST)-I+N)',
        solve: solveBCEFG);
    clueWrapper(
        name: 'D17', length: 4, valueDesc: 'A(S^T+OU+N)+D', solve: solveBCEFG);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.addDigitIdentityFromGrid();

    // Add letter references from descriptions
    var letters = ['A', 'D', 'I', 'N', 'O', 'R', 'S', 'T', 'U'];
    for (var letter in letters) {
      puzzle.letters[letter] = Root66_2Variable(letter);
      for (var clue in puzzle.clues.values) {
        if (clue.valueDesc!.contains(letter)) {
          clue.addLetterReference(letter);
        }
      }
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

  final validBCEFG = <int, Map<String, int>>{};
  final validBCEF = <int, Map<String, int>>{};
  final validG = <int, List<Map<String, int>>>{};
  final validBCEForG = <int, Map<String, int>>{};
  final setBCEFG = <int>{};

  void initBCEFG() {
    const DIGITS = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    for (var b in DIGITS) {
      for (var c in DIGITS.where((element) => element != b)) {
        for (var e in DIGITS.where((element) => element != b && element != c)) {
          for (var f in DIGITS.where(
              (element) => element != b && element != c && element != e)) {
            var g = b * e + 66 * c * f;
            // Must be 4 digits
            if (g > 999 && g < 10000) {
              // Digits must be non-zero and no repeats
              var s = g.toString();
              if (!s.contains('0') &&
                  !s.substring(1).contains(s[0]) &&
                  !s.substring(2).contains(s[1]) &&
                  !s.substring(3).contains(s[2])) {
                var bcef = b * 1000 + c * 100 + e * 10 + f;
                var bcefg = bcef * 10000 + g;
                var entry = {
                  'b': b,
                  'c': c,
                  'e': e,
                  'f': f,
                  'g': g,
                  'bcef': bcef,
                  'bcefg': bcefg,
                };
                validBCEFG[bcefg] = entry;
                validBCEF[bcef] = entry;
                if (validG[g] == null) validG[g] = [];
                validG[g]!.add(entry);
                validBCEForG[bcef] = entry;
                validBCEForG[g] = entry;
                setBCEFG.add(bcefg);
              }
            }
          }
        }
      }
    }
    // if (Crossnumber.traceSolve) {
    //   print(
    //       'initBCEFG: validBCEFG=${validBCEFG.length}, validBCEForG=${validBCEForG.length}, validBCEF=${validBCEF.length}, validG=${validG.length}');
    // }
  }

  @override
  void solve([bool iteration = true]) {
    print("SOLVE------------");

    // Square roots limit letters I nd D
    for (var letter in ['D', 'I']) {
      puzzle.letters[letter]!.updatePossible({1, 4, 9});
    }

    // T is a multiple of R, which limits R
    // Puzzle actually allows non-integer division
    // puzzle.letters['R']!.updatePossible({1, 2, 3, 4});

    // G = BE+66*CF, so 17<=CF<=72 and 1234<=G<=4794
    // C, F >= 2
    for (var entry in puzzle.entries.values) {
      if (entry.type == Root66_2EntryType.BCEFG) {
        entry.digits[1].remove(1);
        entry.digits[3].remove(1);
        entry.digits[4].removeAll([5, 6, 7, 8, 9]);
      }
    }
    // Propagate restricted digits
    for (var clue in puzzle.clues.values) {
      clue.initialise();
    }

    // Manual sequencing of solution for debugging
    try {
      solveClue(this.puzzle.clues['D14']!);
      solveClue(this.puzzle.clues['D2']!);
      solveClue(this.puzzle.clues['A2']!);
      solveClue(this.puzzle.clues['A12']!);
      solveClue(this.puzzle.clues['D4']!);
      // solveClue(this.puzzle.clues['A12']!);
      // solveClue(this.puzzle.clues['A12']!);
    } catch (e) {}
    super.solve(iteration);

    // Check entry types, re-solve
    // checkEntryTypes();
    // super.solve(iteration);

    // Find solution BCEFG
    var maxG = 0;
    for (var bcefgEntry in validBCEFG.entries) {
      var value = bcefgEntry.key;
      var bcefg = bcefgEntry.value;
      if (!duplicateDigit(value)) {
        var g = bcefg['g']!;
        // var bcef = bcefg['bcef']!;
        if (g > maxG) {
          maxG = g;
        }
      }
    }
    var minBCEF = 10000;
    var solutionBCEFG = 0;
    for (var bcefg in validG[maxG]!) {
      var bcef = bcefg['bcef']!;
      if (bcef < minBCEF) {
        minBCEF = bcef;
        solutionBCEFG = bcefg['bcefg']!;
      }
    }
    // Get string version of solution value
    var strSolutionBCEFG = solutionBCEFG.toString();
    var strSolution = "";
    for (var i = 0; i < strSolutionBCEFG.length; i++) {
      var value = int.parse(strSolutionBCEFG[i]);
      for (var variable in puzzle.variables.values) {
        if (variable.values!.first == value) {
          strSolution += variable.name;
        }
      }
    }
    print('Root 66 Solution $minBCEF $maxG: $strSolution');
  }

  // Filter values for BCEF or G values
  bool validValue(VariableClue variableClue, int value, List<String> variables,
      List<int> values) {
    var clue = variableClue as Root66_2Clue;
    var entry = clue.entry as Root66_2Entry;
    var valid = false;
    if (entry.type == Root66_2EntryType.BCEFG) {
      valid = validBCEFG.containsKey(value);
    } else if (entry.type == Root66_2EntryType.G) {
      valid = validBCEF.containsKey(value);
    } else if (entry.type == Root66_2EntryType.BCEF) {
      valid = validG.containsKey(value);
    } else {
      valid = validBCEForG.containsKey(value);
    }
    return valid;
  }

  // Puzzle specific clue solver
  bool solveBCEFG(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as Root66_2Puzzle;
    var clue = v as Root66_2Clue;
    var entry = clue.entry as Root66_2Entry;
    var possibleClueValue = possibleValue;
    var possibleEntryValue = possibleValue2!;
    var types = <Root66_2EntryType>{};
    // Normal clues have expression
    if (entry.type != Root66_2EntryType.BCEFG) {
      // Evaluate expression to get possible values, filtering by valid BCEFG values
      var maxCount = 100000000;
      puzzle.solveVariableExpressionEvaluator(
        clue,
        clue.exp,
        possibleClueValue,
        possibleVariables!,
        validValue,
        maxCount,
      );
      // Get possible values
      var entriesG = <int>{};
      var entriesBCEF = <int>{};
      for (var clueValue in possibleClueValue) {
        if (entry.type == Root66_2EntryType.G ||
            entry.type == Root66_2EntryType.UNKNOWN) {
          if (validBCEF.containsKey(clueValue)) {
            entriesG.add(validBCEF[clueValue]!['g']!);
          }
        }
        if (entry.type == Root66_2EntryType.BCEF ||
            entry.type == Root66_2EntryType.UNKNOWN) {
          if (validG.containsKey(clueValue)) {
            entriesBCEF.addAll(validG[clueValue]!.map((e) => e['bcef']!));
          }
        }
      }
      // if (Crossnumber.traceSolve) {
      //   print('${clue.name} value=$preValue, G=$valuesG, BCEF=$valuesBCEF');
      // }
      if (entriesG.isNotEmpty) {
        if (getMatchingEntryValues(entriesG, clue, possibleEntryValue))
          types.add(Root66_2EntryType.G);
      }
      if (entriesBCEF.isNotEmpty) {
        if (getMatchingEntryValues(entriesBCEF, clue, possibleEntryValue))
          types.add(Root66_2EntryType.BCEF);
      }
    } else {
      // Possible values are all BCEFG
      getMatchingEntryValues(setBCEFG, clue, possibleEntryValue);
      types.add(Root66_2EntryType.BCEFG);
    }
    // Set entry type
    if (types.length == 1) setEntryType(entry, types.first);
    return false;
  }

  bool getMatchingEntryValues(Set<int> candidateValues, Root66_2Clue clue,
      Set<int> possibleEntryValue) {
    var update = false;
    for (var candidateValue in candidateValues) {
      if (clue.digitsMatch(candidateValue)) {
        possibleEntryValue.add(candidateValue);
        update = true;
      }
    }
    return update;
  }

  // Override solveClue to manage preValues
  @override
  bool solveClue(Clue inputClue) {
    var clue = inputClue as Root66_2Clue;
    var puzzle = puzzleForVariable[clue]!;
    var entry = clue.entry as Root66_2Entry;

    // If entry solved already then skip it
    if (entry.isSet) return false;

    var updated = false;
    if (clue.initialise()) updated = true;

    if (clue.solve != null) {
      var possibleClueValue = <int>{};
      var possibleEntryValue = <int>{};
      var possibleVariables = <String, Set<int>>{};
      var updatedVariables = <String>{};
      for (var variableName in clue.variableReferences) {
        possibleVariables[variableName] = <int>{};
      }
      if (clue.solve!(puzzle, clue, possibleClueValue,
          possibleValue2: possibleEntryValue,
          possibleVariables: possibleVariables)) updated = true;
      // Some Solve functions do not update Clue Values
      if (possibleClueValue.isNotEmpty && clue.updateValues(possibleClueValue))
        updated = true;
      // If no Entry Values returned then Solve function could not solve
      if (possibleEntryValue.isEmpty) {
        print(
            'Solve Error: clue ${clue.name} (${clue.valueDesc}) no solution!');
        throw SolveException();
      }
      if (puzzle.updateValues(entry, possibleEntryValue)) updated = true;
      if (entry.finalise()) updated = true;
      for (var variableName in clue.variableReferences) {
        updateVariables(puzzle, variableName, possibleVariables[variableName]!,
            updatedVariables);
      }

      if (Crossnumber.traceSolve && updated) {
        print("solve: ${clue.toString()}");
        var variableList = puzzle.variableList;
        for (var variableName in updatedVariables) {
          print(
              '$variableName=${variableList.variables[variableName]!.values.toString()}');
        }
      }
    }
    return updated;
  }

  void setEntryType(Root66_2Entry entry, Root66_2EntryType type) {
    if (entry.type != Root66_2EntryType.UNKNOWN) {
      if (entry.type != type) {
        print('Solve Error: changing type for Entry ${entry.name}!');
        throw SolveException();
      }
      return;
    }
    // Set type
    entry.type = type;
  }

  void checkEntryTypes() {
    // Check type totals - should be 7 G and 13 BCEF
    const TARGET_G = 7;
    const TARGET_BCEF = 13;
    var countG = puzzle.entries.values
        .where((e) => e.type == Root66_2EntryType.G)
        .length;
    var countBCEF = puzzle.entries.values
        .where((e) => e.type == Root66_2EntryType.BCEF)
        .length;
    if (countG < TARGET_G && countBCEF < TARGET_BCEF) return;
    if (countG == TARGET_G && countBCEF == TARGET_BCEF) return;
    if (countG > TARGET_G || countBCEF > TARGET_BCEF) {
      print(
          'Solve Error: invalid Entry types ${countG}/7 and ${countBCEF}/13!');
      throw SolveException();
    }
    // Can fix other entries
    var fix = countG == TARGET_G ? Root66_2EntryType.BCEF : Root66_2EntryType.G;
    puzzle.entries.values
        .where((e) => e.type == Root66_2EntryType.UNKNOWN)
        .forEach((e) {
      e.type = fix;
      if (Crossnumber.traceSolve) {
        print('Set remaining types to $fix');
      }
    });
  }
}
