/// An API for solving Prime Cuts puzzles.
library root66;

import 'dart:math';

import '../puzzle.dart';
import '../crossnumber.dart';
import '../clue.dart';
import '../root66/clue.dart';
import '../root66/puzzle.dart';
import '../variable.dart';

/// Provide access to the Prime Cuts API.
class Root66 extends Crossnumber<Root66Puzzle> {
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

  Root66() {
    puzzle = Root66Puzzle.fromGridString(gridString);
    initCrossnumber();
    initBCEFG();
  }

  late Root66Entry a2;
  late Root66Entry a7;
  late Root66Entry a8;
  late Root66Entry a9;
  late Root66Entry a11;
  late Root66Entry a12;
  late Root66Entry a13;
  late Root66Entry a16;
  late Root66Entry a18;
  late Root66Entry a19;
  late Root66Entry a20;
  late Root66Entry a21;
  late Root66Entry d1;
  late Root66Entry d2;
  late Root66Entry d3;
  late Root66Entry d4;
  late Root66Entry d5;
  late Root66Entry d6;
  late Root66Entry d8;
  late Root66Entry d10;
  late Root66Entry d14;
  late Root66Entry d15;
  late Root66Entry d16;
  late Root66Entry d17;

  void initCrossnumber() {
    a2 = Root66Entry(
        name: 'A2',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '-D+U*R^(A+T)+I+O*N^S',
        solve: solveBCEFG);
    puzzle.addEntry(a2);
    a7 = Root66Entry(
        name: 'A7',
        length: 8,
        type: Root66ClueType.BCEFG,
        valueDesc: '',
        solve: solveBCEFG);
    puzzle.addEntry(a7);
    a8 = Root66Entry(
        name: 'A8',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'R+O(TU+N)DA',
        solve: solveBCEFG);
    puzzle.addEntry(a8);
    a9 = Root66Entry(
        name: 'A9',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(S+I+T^A+RO-U-N)D',
        solve: solveBCEFG);
    puzzle.addEntry(a9);
    a11 = Root66Entry(
        name: 'A11',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'U((N+I)^T-(A+R)D)S',
        solve: solveBCEFG);
    puzzle.addEntry(a11);
    a12 = Root66Entry(
        name: 'A12',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(A+S)T(R^O-√(ID))',
        solve: solveBCEFG);
    puzzle.addEntry(a12);
    a13 = Root66Entry(
        name: 'A13',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'S*U^T+(O+R+I)A+N',
        solve: solveBCEFG);
    puzzle.addEntry(a13);
    a16 = Root66Entry(
        name: 'A16',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(DI-NO)(S+T)A+R',
        solve: solveBCEFG);
    puzzle.addEntry(a16);
    a18 = Root66Entry(
        name: 'A18',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(T/R)*I^N*(ODU+S)',
        solve: solveBCEFG);
    puzzle.addEntry(a18);
    a19 = Root66Entry(
        name: 'A19',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(T*U^N*(D+R)+A)S',
        solve: solveBCEFG);
    puzzle.addEntry(a19);
    a20 = Root66Entry(
        name: 'A20',
        length: 8,
        type: Root66ClueType.BCEFG,
        valueDesc: '',
        solve: solveBCEFG);
    puzzle.addEntry(a20);
    a21 = Root66Entry(
        name: 'A21',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '-(√I)N+TRADO+S',
        solve: solveBCEFG);
    puzzle.addEntry(a21);

    d1 = Root66Entry(
        name: 'D1',
        length: 8,
        type: Root66ClueType.BCEFG,
        valueDesc: '',
        solve: solveBCEFG);
    puzzle.addEntry(d1);
    d2 = Root66Entry(
        name: 'D2',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '-D+U(R+A)(T^I+O*N^S)',
        solve: solveBCEFG);
    puzzle.addEntry(d2);
    d3 = Root66Entry(
        name: 'D3',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'DI(N^O*S+A+U)R',
        solve: solveBCEFG);
    puzzle.addEntry(d3);
    d4 = Root66Entry(
        name: 'D4',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(AROU+N)D',
        solve: solveBCEFG);
    puzzle.addEntry(d4);
    d5 = Root66Entry(
        name: 'D5',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'A(U+D)+(I+T+O)*R^S',
        solve: solveBCEFG);
    puzzle.addEntry(d5);
    d6 = Root66Entry(
        name: 'D6',
        length: 8,
        type: Root66ClueType.BCEFG,
        valueDesc: '',
        solve: solveBCEFG);
    puzzle.addEntry(d6);
    d8 = Root66Entry(
        name: 'D8',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'S-A+U^T*(O+I-R)',
        solve: solveBCEFG);
    puzzle.addEntry(d8);
    d10 = Root66Entry(
        name: 'D10',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(S(U+D-A)-T)IO+N',
        solve: solveBCEFG);
    puzzle.addEntry(d10);
    d14 = Root66Entry(
        name: 'D14',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'R-(A+I+N+O-U^T)S',
        solve: solveBCEFG);
    puzzle.addEntry(d14);
    d15 = Root66Entry(
        name: 'D15',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '((N+U)^T+RI+S+O+D)A',
        solve: solveBCEFG);
    puzzle.addEntry(d15);
    d16 = Root66Entry(
        name: 'D16',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'R(O(√D-A+UST)-I+N)',
        solve: solveBCEFG);
    puzzle.addEntry(d16);
    d17 = Root66Entry(
        name: 'D17',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'A(S^T+OU+N)+D',
        solve: solveBCEFG);
    puzzle.addEntry(d17);

    puzzle.linkEntriesToGrid();

    // Add letter references from descriptions
    var letters = ['A', 'D', 'I', 'N', 'O', 'R', 'S', 'T', 'U'];
    for (var letter in letters) {
      puzzle.addVariable(Root66Variable(letter));
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
    for (var clue in puzzle.clues.values) {
      if ((clue as Root66Entry).type == Root66ClueType.BCEFG) {
        clue.digits[1].remove(1);
        clue.digits[3].remove(1);
        clue.digits[4].removeAll([5, 6, 7, 8, 9]);
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
    var clue = variableClue as Root66Entry;
    var valid = false;
    if (clue.type == Root66ClueType.BCEFG) {
      valid = validBCEFG.containsKey(value);
    } else if (clue.type == Root66ClueType.BCEF) {
      valid = validBCEF.containsKey(value);
    } else if (clue.type == Root66ClueType.G) {
      valid = validG.containsKey(value);
    } else {
      valid = validBCEForG.containsKey(value);
    }
    // if (variables.contains("T") && variables.contains("R")) {
    //   var indexT = variables.indexOf('T');
    //   var indexR = variables.indexOf('R');
    //   var valueT = values[indexT];
    //   var valueR = values[indexR];
    //   if (valueT % valueR != 0) {
    //     valid = false;
    //   }
    // }
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
    var puzzle = p as Root66Puzzle;
    var clue = v as Root66Entry;
    var candidateValues = <int>{};
    // Normal clues have expression
    if (clue.type != Root66ClueType.BCEFG) {
      // Evaluate expression to get possible values, filtering by valid BCEFG values
      var maxCount = 100000000;
      puzzle.solveVariableExpressionEvaluator(
        clue,
        clue.exp,
        possibleValue,
        possibleVariables!,
        validValue,
        maxCount,
      );
      // Get possible values
      for (var preValue in possibleValue) {
        var valuesG = <int>{};
        var valuesBCEF = <int>{};
        if (clue.type == Root66ClueType.BCEF ||
            clue.type == Root66ClueType.UNKNOWN) {
          if (validBCEF.containsKey(preValue)) {
            valuesG.add(validBCEF[preValue]!['g']!);
          }
        }
        if (clue.type == Root66ClueType.G ||
            clue.type == Root66ClueType.UNKNOWN) {
          if (validG.containsKey(preValue)) {
            valuesBCEF.addAll(validG[preValue]!.map((e) => e['bcef']!));
          }
        }
        candidateValues.addAll(valuesG);
        candidateValues.addAll(valuesBCEF);
        // if (Crossnumber.traceSolve) {
        //   print('${clue.name} value=$preValue, G=$valuesG, BCEF=$valuesBCEF');
        // }
      }
    } else {
      // Possible values are all BCEFG
      candidateValues = setBCEFG;
    }
    // Check digits match
    for (var candidateValue in candidateValues) {
      if (clue.digitsMatch(candidateValue)) {
        possibleValue2!.add(candidateValue);
      }
    }
    return false;
  }

  // Override solveClue to manage preValues
  bool solveClue(Variable inputClue) {
    var clue = inputClue as Root66Entry;
    var puzzle = puzzleForVariable[clue]!;
    // If clue solved already then skip it
    if (clue.values != null && clue.values!.length == 1) return false;

    var updated = false;
    if (clue.initialise()) updated = true;

    if (clue.solve != null) {
      var possiblePreValue = <int>{};
      var possibleValue = <int>{};
      var possibleVariables = <String, Set<int>>{};
      var updatedVariables = <String>{};
      for (var variableName in clue.variableReferences) {
        possibleVariables[variableName] = <int>{};
      }
      if (clue.solve!(puzzle, clue, possiblePreValue,
          possibleValue2: possibleValue,
          possibleVariables: possibleVariables)) updated = true;
      // Some Solve functions do not update PreValues
      if (possiblePreValue.isNotEmpty && clue.updatePreValues(possiblePreValue))
        updated = true;
      // If no Values returned then Solve function could not solve
      if (possibleValue.isEmpty) {
        print(
            'Solve Error: clue ${clue.name} (${clue.valueDesc}) no solution!');
        throw SolveException();
      }
      if (puzzle.updateValues(clue, possibleValue)) {
        updated = true;
        if (clue.preValues != null) {
          // Replace min/max from preValues!
          clue.min = clue.preValues!.reduce(min);
          clue.max = clue.preValues!.reduce(max);
        }
      }
      if (clue.finalise()) updated = true;
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
}
