/// An API for solving Prime Cuts puzzles.
library root66;

import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/root66/clue.dart';
import 'package:crossnumber/root66/puzzle.dart';

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
    puzzle = Root66Puzzle.grid(gridString);
    initCrossnumber();
    initBCEFG();
  }

  late Root66Clue a2;
  late Root66Clue a7;
  late Root66Clue a8;
  late Root66Clue a9;
  late Root66Clue a11;
  late Root66Clue a12;
  late Root66Clue a13;
  late Root66Clue a16;
  late Root66Clue a18;
  late Root66Clue a19;
  late Root66Clue a20;
  late Root66Clue a21;
  late Root66Clue d1;
  late Root66Clue d2;
  late Root66Clue d3;
  late Root66Clue d4;
  late Root66Clue d5;
  late Root66Clue d6;
  late Root66Clue d8;
  late Root66Clue d10;
  late Root66Clue d14;
  late Root66Clue d15;
  late Root66Clue d16;
  late Root66Clue d17;

  void initCrossnumber() {
    puzzle.clues = {};
    a2 = Root66Clue(
        name: 'A2',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '-D+U*R^(A+T)+I+O*N^S',
        solve: solveBCEFG);
    puzzle.addClue(a2);
    a7 = Root66Clue(
        name: 'A7',
        length: 8,
        type: Root66ClueType.BCEFG,
        valueDesc: '',
        solve: solveBCEFG);
    puzzle.addClue(a7);
    a8 = Root66Clue(
        name: 'A8',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'R+O(TU+N)DA',
        solve: solveBCEFG);
    puzzle.addClue(a8);
    a9 = Root66Clue(
        name: 'A9',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(S+I+T^A+RO-U-N)D',
        solve: solveBCEFG);
    puzzle.addClue(a9);
    a11 = Root66Clue(
        name: 'A11',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'U((N+I)^T-(A+R)D)S',
        solve: solveBCEFG);
    puzzle.addClue(a11);
    a12 = Root66Clue(
        name: 'A12',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(A+S)T(R^O-√(ID))',
        solve: solveBCEFG);
    puzzle.addClue(a12);
    a13 = Root66Clue(
        name: 'A13',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'S*U^T+(O+R+I)A+N',
        solve: solveBCEFG);
    puzzle.addClue(a13);
    a16 = Root66Clue(
        name: 'A16',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(DI-NO)(S+T)A+R',
        solve: solveBCEFG);
    puzzle.addClue(a16);
    a18 = Root66Clue(
        name: 'A18',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(T/R)*I^N*(ODU+S)',
        solve: solveBCEFG);
    puzzle.addClue(a18);
    a19 = Root66Clue(
        name: 'A19',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(T*U^N*(D+R)+A)S',
        solve: solveBCEFG);
    puzzle.addClue(a19);
    a20 = Root66Clue(
        name: 'A20',
        length: 8,
        type: Root66ClueType.BCEFG,
        valueDesc: '',
        solve: solveBCEFG);
    puzzle.addClue(a20);
    a21 = Root66Clue(
        name: 'A21',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '-(√I)N+TRADO+S',
        solve: solveBCEFG);
    puzzle.addClue(a21);

    d1 = Root66Clue(
        name: 'D1',
        length: 8,
        type: Root66ClueType.BCEFG,
        valueDesc: '',
        solve: solveBCEFG);
    puzzle.addClue(d1);
    d2 = Root66Clue(
        name: 'D2',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '-D+U(R+A)(T^I+O*N^S)',
        solve: solveBCEFG);
    puzzle.addClue(d2);
    d3 = Root66Clue(
        name: 'D3',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'DI(N^O*S+A+U)R',
        solve: solveBCEFG);
    puzzle.addClue(d3);
    d4 = Root66Clue(
        name: 'D4',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(AROU+N)D',
        solve: solveBCEFG);
    puzzle.addClue(d4);
    d5 = Root66Clue(
        name: 'D5',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'A(U+D)+(I+T+O)*R^S',
        solve: solveBCEFG);
    puzzle.addClue(d5);
    d6 = Root66Clue(
        name: 'D6',
        length: 8,
        type: Root66ClueType.BCEFG,
        valueDesc: '',
        solve: solveBCEFG);
    puzzle.addClue(d6);
    d8 = Root66Clue(
        name: 'D8',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'S-A+U^T*(O+I-R)',
        solve: solveBCEFG);
    puzzle.addClue(d8);
    d10 = Root66Clue(
        name: 'D10',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '(S(U+D-A)-T)IO+N',
        solve: solveBCEFG);
    puzzle.addClue(d10);
    d14 = Root66Clue(
        name: 'D14',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'R-(A+I+N+O-U^T)S',
        solve: solveBCEFG);
    puzzle.addClue(d14);
    d15 = Root66Clue(
        name: 'D15',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: '((N+U)^T+RI+S+O+D)A',
        solve: solveBCEFG);
    puzzle.addClue(d15);
    d16 = Root66Clue(
        name: 'D16',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'R(O(√D-A+UST)-I+N)',
        solve: solveBCEFG);
    puzzle.addClue(d16);
    d17 = Root66Clue(
        name: 'D17',
        length: 4,
        type: Root66ClueType.UNKNOWN,
        valueDesc: 'A(S^T+OU+N)+D',
        solve: solveBCEFG);
    puzzle.addClue(d17);

    puzzle.addDigitIdentityFromGrid();

    // Add letter references from descriptions
    var letters = ['A', 'D', 'I', 'N', 'O', 'R', 'S', 'T', 'U'];
    for (var letter in letters) {
      puzzle.letters[letter] = Root66Variable(letter);
      for (var clue in puzzle.clues.values) {
        if (clue.valueDesc!.contains(letter)) {
          clue.addLetterReference(letter);
        }
      }
    }

    if (Crossnumber.traceInit) {
      print(puzzle.toString());
    }
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
      if (clue.type == Root66ClueType.BCEFG) {
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
    var clue = variableClue as Root66Clue;
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
    VariableClue variableClue,
    Set<int> possiblePreValue,
    Set<int> possibleValue,
    Map<String, Set<int>> possibleVariables,
  ) {
    var clue = variableClue as Root66Clue;
    var candidateValues = <int>{};
    // Normal clues have expression
    if (clue.type != Root66ClueType.BCEFG) {
      // Evaluate expression to get possible values, filtering by valid BCEFG values
      puzzle.solveVariableExpressionEvaluator(
          clue, possiblePreValue, possibleVariables, validValue);
      // Get possible values
      for (var preValue in possiblePreValue) {
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
        possibleValue.add(candidateValue);
      }
    }
    return false;
  }

  // Override solveClue to manage preValues
  bool solveClue(Clue inputClue) {
    var clue = inputClue as Root66Clue;
    // If clue solved already then skip it
    if (clue.values != null && clue.values!.length == 1) return false;

    var updated = false;
    if (clue.initialise()) updated = true;

    if (clue.solve != null) {
      var possiblePreValue = <int>{};
      var possibleValue = <int>{};
      var possibleVariables = <String, Set<int>>{};
      for (var variable in clue.variableReferences) {
        possibleVariables[variable] = <int>{};
      }
      if (clue.solve!(clue, possiblePreValue, possibleValue, possibleVariables))
        updated = true;
      // Some Solve functions do not update PreValues
      if (possiblePreValue.isNotEmpty && clue.updatePreValues(possiblePreValue))
        updated = true;
      // If no Values returned then Solve function could not solve
      if (possibleValue.isEmpty) {
        print(
            'Solve Error: clue ${clue.name} (${clue.valueDesc}) no solution!');
        throw SolveException();
      }
      if (puzzle.updateValues(clue, possibleValue)) updated = true;
      if (clue.finalise()) updated = true;
      for (var variable in clue.variableReferences) {
        if (updateVariables(variable, possibleVariables[variable]!))
          updated = true;
      }
    }

    if (Crossnumber.traceSolve && updated) {
      print("solve: ${clue.toString()}");
      var variableList = puzzle.variableList;
      for (var variable in clue.variableReferences) {
        print(
            '$variable=${variableList.variables[variable]!.values.toString()}');
      }
    }
    return updated;
  }
}
