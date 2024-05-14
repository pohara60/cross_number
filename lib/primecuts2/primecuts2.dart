/// An API for solving Prime Cuts puzzles.
library primecuts;

import 'package:powers/powers.dart';

import '../cartesian.dart';
import '../crossnumber.dart';
import '../clue.dart';
import '../expression.dart';
import '../generators.dart';
import '../puzzle.dart';
import '../set.dart';

import '../variable.dart';
import './clue.dart';
import './puzzle.dart';

/// Provide access to the Prime Cuts API.
class PrimeCuts2 extends Crossnumber<PrimeCuts2Puzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 |2 :3 :4 |5 :6 |',
    '+::+--+::+::+--+::+',
    '|7 :8 :  |9 :10|  |',
    '+--+::+--+::+::+::+',
    '|11:  |12:  |13:  |',
    '+::+::+::+--+::+--+',
    '|  |14:  |15:  :16|',
    '+::+--+::+::+--+::+',
    '|17:  |18:  :  |  |',
    '+--+--+--+--+--+--+',
  ];

  PrimeCuts2() {
    puzzle = PrimeCuts2Puzzle.fromGridString(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {required String name,
        required String prime,
        required int length,
        required String valueDesc,
        required SolveFunction? solve}) {
      try {
        var clueLength = length + 2; // Allow for removal of prime
        var clue = PrimeCutsClue(
            name: name,
            prime: prime,
            length: clueLength,
            valueDesc: valueDesc,
            solve: solve);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    var entryErrors = '';
    void entryWrapper(
        {required String name,
        required String prime,
        required int length,
        required String valueDesc}) {
      try {
        var entry = PrimeCutsEntry(
            name: name, prime: prime, length: length, valueDesc: valueDesc);
        puzzle.addEntry(entry);
        puzzle.mapClueToEntry(puzzle.clues[name]!, entry);
        return;
      } on ExpressionError catch (e) {
        entryErrors += e.msg + '\n';
        return;
      }
    }

    var variableErrors = '';
    void variableWrapper(String name,
        {String valueDesc = '', SolveFunction? solve}) {
      try {
        var variable = PrimeCutsVariable(
          name,
          valueDesc,
          solve: solve,
        );
        puzzle.addVariable(variable);
        return;
      } on ExpressionError catch (e) {
        variableErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(
        name: "A2",
        prime: "B",
        length: 3,
        valueDesc: r"$multiple EA2",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A5",
        prime: "C",
        length: 2,
        valueDesc: r"#square",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A7",
        prime: "D",
        length: 3,
        valueDesc: r"$multiple D",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A9",
        prime: "F",
        length: 2,
        valueDesc: r"$multiple R",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A11",
        prime: "G",
        length: 2,
        valueDesc: r"#ascending",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A12",
        prime: "H",
        length: 2,
        valueDesc: r"#triangular ",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A13",
        prime: "J",
        length: 2,
        valueDesc: r"#prime",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A14",
        prime: "K",
        length: 2,
        valueDesc: r"#triangular ",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A15",
        prime: "L",
        length: 3,
        valueDesc: r"D^3",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A17",
        prime: "M",
        length: 2,
        valueDesc: r"#square",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "A18",
        prime: "N",
        length: 3,
        valueDesc: r"$multiple H",
        solve: solvePrimeCutsClue);

    clueWrapper(
        name: "D1",
        prime: "P",
        length: 2,
        valueDesc: r"$multiple P",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "D3",
        prime: "Q",
        length: 2,
        valueDesc: r"#square ",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "D4",
        prime: "R",
        length: 3,
        valueDesc: r"$multiple B",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "D6",
        prime: "S",
        length: 3,
        valueDesc: r"#palindrome",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "D8",
        prime: "T",
        length: 3,
        valueDesc: r"#descending",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "D10",
        prime: "V",
        length: 3,
        valueDesc: r"$ascending #result % $ds #result = 0",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "D11",
        prime: "W",
        length: 3,
        valueDesc: r"#ascending",
        solve: solvePrimeCutsClue);
    // TODO This is slow
    clueWrapper(
        name: "D12",
        prime: "X",
        length: 3,
        valueDesc: r"$ds A18 = $ds #result",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "D15",
        prime: "Y",
        length: 2,
        valueDesc: r"#square",
        solve: solvePrimeCutsClue);
    clueWrapper(
        name: "D16",
        prime: "Z",
        length: 2,
        valueDesc: r"$multiple Z",
        solve: solvePrimeCutsClue);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }
    entryWrapper(name: "A2", prime: "B", length: 3, valueDesc: r"");
    entryWrapper(name: "A5", prime: "C", length: 2, valueDesc: r"");
    entryWrapper(name: "A7", prime: "D", length: 3, valueDesc: r"$multiple D");
    entryWrapper(
        name: "A9",
        prime: "F",
        length: 2,
        valueDesc: r"$notpalindrome $reverse #otherentry");
    entryWrapper(
        name: "A11", prime: "G", length: 2, valueDesc: r"$divisor ED11");
    entryWrapper(name: "A12", prime: "H", length: 2, valueDesc: r"#triangular");
    entryWrapper(name: "A13", prime: "J", length: 2, valueDesc: r"");
    entryWrapper(name: "A14", prime: "K", length: 2, valueDesc: r"");
    entryWrapper(name: "A15", prime: "L", length: 3, valueDesc: r"S^2");
    entryWrapper(
        name: "A17", prime: "M", length: 2, valueDesc: r"$reverse ED3");
    entryWrapper(name: "A18", prime: "N", length: 3, valueDesc: r"$multiple W");

    entryWrapper(name: "D1", prime: "P", length: 2, valueDesc: r"");
    entryWrapper(name: "D3", prime: "Q", length: 2, valueDesc: r"");
    entryWrapper(name: "D4", prime: "R", length: 3, valueDesc: r"");
    entryWrapper(name: "D6", prime: "S", length: 3, valueDesc: r"K * T");
    entryWrapper(name: "D8", prime: "T", length: 3, valueDesc: r"");
    entryWrapper(name: "D10", prime: "V", length: 3, valueDesc: r"");
    entryWrapper(name: "D11", prime: "W", length: 3, valueDesc: r"G + W");
    entryWrapper(
        name: "D12", prime: "X", length: 3, valueDesc: r"$jumble EA18");
    entryWrapper(name: "D15", prime: "Y", length: 2, valueDesc: r"");
    entryWrapper(
        name: "D16", prime: "Z", length: 2, valueDesc: r"#square - ED1");

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    puzzle.linkEntriesToGrid();

    var letters = [
      ('B', ''),
      ('C', ''),
      ('D', ''),
      ('F', ''),
      ('G', ''),
      ('H', ''),
      ('J', ''),
      ('K', ''),
      ('L', ''),
      ('M', r'$reverse C'),
      ('N', r'#ascending'),
      ('P', r'#triangular - Z'),
      ('Q', ''),
      ('R', ''),
      ('S', ''),
      ('T', ''),
      ('V', ''),
      ('W', ''),
      ('X', ''),
      ('Y', r'$reverse Q'),
      ('Z', ''),
    ];
    for (var letter in letters) {
      variableWrapper(letter.$1,
          valueDesc: letter.$2, solve: solvePrimeCutsVariable);
    }
    if (variableErrors != '') throw PuzzleException(variableErrors);

    variableErrors += puzzle.checkVariableVariableReferences();
    variableErrors += puzzle.checkClueClueReferences();
    variableErrors += puzzle.checkEntryClueReferences();
    variableErrors = puzzle.checkVariableReferences();
    if (variableErrors != '') throw PuzzleException(variableErrors);

    // A9 depends on all other 2 digit entries
    var a9 = puzzle.clues["A9"]!;
    for (var other in puzzle.clues.values
        .where((element) => element != a9 && element.length == a9.length)) {
      puzzle.addClueReference(a9, other, false);
    }

    super.initCrossnumber();
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (value < 0) return false;
    if (clue.min != null && value < clue.min!) return false;
    if (clue.max != null && value > clue.max!) return false;
    if (clue.values != null && !clue.values!.contains(value)) return false;
    // if (!clue.digitsMatch(value)) return false;
    return true;
  }

  // Validate possible entry value
  bool validEntry(VariableClue entry, int value,
      List<String> variableReferences, List<int> variableValues) {
    // if (!super.validClue(entry, value, variableReferences, variableValues))
    //   return false;
    if (value < 0) return false;
    if (entry.min != null && value < entry.min!) return false;
    if (entry.max != null && value > entry.max!) return false;
    if (entry.values != null && !entry.values!.contains(value)) return false;
    if (!entry.digitsMatch(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solvePrimeCutsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as PrimeCuts2Puzzle;
    var clue = v as PrimeCutsClue;
    var entry = clue.entry as PrimeCutsEntry;
    var updated = false;

    var possibleEntryValue = possibleValue2!;
    var possibleEntryVariables = possibleVariables2!;

    var variableNames = <String>[];
    var variableValues = <List<int>>[];
    var count = puzzle.getVariables(clue, clue.expressions, possibleValue,
        possibleVariables!, variableNames, variableValues, 1000000);
    if (count == 0) return false;

    var entryVariableNames = <String>[];
    var entryVariableValues = <List<int>>[];
    var entryVariableMapsToClueVariable = <int>[];
    var clueRefersToEntryIndex = variableNames.indexOf('E' + entry.name);
    if (entry.valueDesc != '') {
      var count2 = puzzle.getVariables(
          entry,
          entry.expressions,
          possibleValue,
          possibleEntryVariables,
          entryVariableNames,
          entryVariableValues,
          1000000);
      if (count2 == 0) return false;

      // Find variables in common for clue and entry
      for (var variable in entryVariableNames) {
        entryVariableMapsToClueVariable.add(variableNames.indexOf(variable));
      }
    }

    // Solve Clue
    var primeValues = <int>{};
    for (var product
        in variableValues.isEmpty ? [<int>[]] : cartesian(variableValues)) {
      try {
        for (var clueValue in clue.exp.generate(
            clue.min, clue.max, variableNames, product, clue.values)) {
          if (!validClue(clue, clueValue, variableNames, product)) continue;

          if (entry.valueDesc == '') {
            if (entry.values == null) {
              entry.values = entry.getValuesFromDigits();
              assert(entry.values != null);
            }
            for (var entryValue
                in entry.values!.where((v) => entry.digitsMatch(v))) {
              if (clueRefersToEntryIndex != -1) {
                if (product[clueRefersToEntryIndex] != entryValue) {
                  continue;
                }
              }
              // Find a prime to get from Clue to Entry value
              checkPrimes(
                  puzzle,
                  clue,
                  clueValue,
                  entryValue,
                  possibleValue,
                  possibleEntryValue,
                  primeValues,
                  variableNames,
                  possibleVariables,
                  product);
            }

            continue;
          }

          // Solve Entry
          for (var product2 in entryVariableValues.isEmpty
              ? [<int>[]]
              : cartesian(entryVariableValues)) {
            try {
              // Skip when entry variable that maps to clue variable has different value
              var skip = false;
              for (var index2 = 0;
                  index2 < entryVariableNames.length;
                  index2++) {
                var index = entryVariableMapsToClueVariable[index2];
                if (index != -1 && product[index] != product2[index2]) {
                  skip = true;
                  break;
                }
              }
              if (skip) continue;

              for (var entryValue in entry.exp.generate(entry.min, entry.max,
                  entryVariableNames, product2, entry.values)) {
                if (clueRefersToEntryIndex != -1) {
                  if (variableValues[clueRefersToEntryIndex] != entryValue) {
                    continue;
                  }
                }

                if (!validEntry(
                    entry, entryValue, entryVariableNames, product2)) continue;

                // Find a prime to get from Clue to Entry value
                checkPrimes(
                    puzzle,
                    clue,
                    clueValue,
                    entryValue,
                    possibleValue,
                    possibleEntryValue,
                    primeValues,
                    variableNames,
                    possibleVariables,
                    product,
                    entryVariableNames,
                    possibleEntryVariables,
                    product2);
              }
            } on ExpressionInvalid {}
          }
        }
      } on ExpressionInvalid {}
    }

    if (updateVariables(puzzle, clue.prime, primeValues, updatedVariables!))
      updated = true;

    return updated;
  }

  void checkPrimes(
    PrimeCuts2Puzzle puzzle,
    PrimeCutsClue clue,
    int clueValue,
    int entryValue,
    Set<int> possibleValue,
    Set<int> possibleEntryValue,
    Set<int> primeValues,
    List<String> variableNames,
    Map<String, Set<int>> possibleVariables,
    List<int> product, [
    List<String>? entryVariableNames,
    Map<String, Set<int>>? possibleEntryVariables,
    List<int>? product2,
  ]) {
    for (var primeValue in puzzle.primes[clue.prime]!.values!) {
      for (var value in ValueIterable(clueValue, primeValue)) {
        if (entryValue == value) {
          possibleValue.add(clueValue);
          possibleEntryValue.add(entryValue);
          primeValues.add(primeValue);
          var index = 0;
          for (var variable in variableNames) {
            possibleVariables[variable]!.add(product[index++]);
          }
          index = 0;
          if (entryVariableNames != null) {
            for (var variable in entryVariableNames) {
              possibleEntryVariables![variable]!.add(product2![index++]);
            }
          }
        }
      }
    }
  }

  // Override solveClue to manage preValues
  @override
  bool solveClue(Variable inputClue) {
    if (inputClue is Clue) {
      return solveActualClue(inputClue);
    }
    if (inputClue is ExpressionVariable) {
      return solveVariable(inputClue);
    }
    return false;
  }

  bool solveActualClue(Clue inputClue) {
    var clue = inputClue as PrimeCutsClue;
    var puzzle = puzzleForVariable[clue]!;
    var entry = clue.entry as PrimeCutsEntry;

    // If entry solved already then skip it
    if (entry.isSet) return false;

    var updated = false;
    if (clue.initialise()) updated = true;

    if (clue.solve != null) {
      var possibleClueValue = <int>{};
      var possibleEntryValue = <int>{};
      var possibleVariables = <String, Set<int>>{};
      var possibleEntryVariables = <String, Set<int>>{};
      var updatedVariables = <String>{};
      for (var variableName in clue.variableClueReferences) {
        possibleVariables[variableName] = <int>{};
      }
      for (var variableName in entry.variableClueReferences) {
        possibleEntryVariables[variableName] = <int>{};
      }
      if (clue.solve!(puzzle, clue, possibleClueValue,
          possibleValue2: possibleEntryValue,
          possibleVariables: possibleVariables,
          possibleVariables2: possibleEntryVariables,
          updatedVariables: updatedVariables)) updated = true;
      // Some Solve functions do not update Clue Values
      if (possibleClueValue.isNotEmpty && clue.updateValues(possibleClueValue))
        updated = true;
      // If no Entry Values returned then Solve function could not solve
      if (possibleEntryValue.isEmpty) {
        throw SolveException(
            'Solve Error: clue ${clue.name} (${clue.valueDesc}) no solution!');
      }
      if (puzzle.updateValues(entry, possibleEntryValue)) updated = true;
      if (entry.finalise()) updated = true;
      for (var variableName in clue.variableReferences) {
        updateVariables(puzzle, variableName, possibleVariables[variableName]!,
            updatedVariables);
      }
      for (var variableName in entry.variableReferences) {
        if (possibleEntryVariables[variableName] != null) {
          updateVariables(puzzle, variableName,
              possibleEntryVariables[variableName]!, updatedVariables);
        }
      }

      if (Crossnumber.traceSolve && updated) {
        print("solve: ${clue.toString()}");
        var variableList = puzzle.variableList;
        for (var variableName in updatedVariables) {
          print(
              '$variableName=${variableList.variables[variableName]!.values!.toShortString()}');
        }
      }
    }
    return updated;
  }

  // Variable solver invokes generic expression evaluator
  bool solvePrimeCutsVariable(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as VariablePuzzle;
    var variable = v as ExpressionVariable;
    var updated = false;
    if (variable.valueDesc != '') {
      updated = puzzle.solveExpressionVariable(
          v, v.exp, possibleValue, possibleVariables!, validVariable);
    } else {
      if (variable.values != null) possibleValue.addAll(variable.values!);
    }
    return updated;
  }

  bool updatePrimes(String prime, Set<int> possibleValues) =>
      updateVariables(puzzle, prime, possibleValues, <String>{});

  /// Find **multiple** of prime, that are also a multiple when the digits of prime are removed.
  ///
  /// [digits] is the length of the preValue.
  Set<int> multiple(int prime, {int digits = 4, bool requireMultiple = true}) {
    var matches = <int>{};
    int preValue = prime;
    String preValueStr = preValue.toString();
    while (preValueStr.length <= digits) {
      if (preValueStr.length == digits) {
        for (var match in ValueIterable(preValue, prime)) {
          if (!requireMultiple || match! % prime == 0) {
            matches.add(match!);
          }
        }
      }
      preValue += prime;
      preValueStr = preValue.toString();
    }
    return matches;
  }

  void setAnswers() {
    puzzle.variables['B']!.answer = 97;
    puzzle.variables['C']!.answer = 31;
    puzzle.variables['D']!.answer = 29;
    puzzle.variables['F']!.answer = 53;
    puzzle.variables['G']!.answer = 47;
    puzzle.variables['H']!.answer = 83;
    puzzle.variables['J']!.answer = 89;
    puzzle.variables['K']!.answer = 11;
    puzzle.variables['L']!.answer = 43;
    puzzle.variables['M']!.answer = 13;
    puzzle.variables['N']!.answer = 23;
    puzzle.variables['P']!.answer = 59;
    puzzle.variables['Q']!.answer = 73;
    puzzle.variables['R']!.answer = 71;
    puzzle.variables['S']!.answer = 17;
    puzzle.variables['T']!.answer = 61;
    puzzle.variables['V']!.answer = 67;
    puzzle.variables['W']!.answer = 79;
    puzzle.variables['X']!.answer = 41;
    puzzle.variables['Y']!.answer = 37;
    puzzle.variables['Z']!.answer = 19;

    puzzle.entries['A2']!.answer = 592;
    puzzle.entries['A5']!.answer = 36;
    puzzle.entries['A7']!.answer = 696;
    puzzle.entries['A9']!.answer = 62;
    puzzle.entries['A11']!.answer = 18;
    puzzle.entries['A12']!.answer = 10;
    puzzle.entries['A13']!.answer = 41;
    puzzle.entries['A14']!.answer = 76;
    puzzle.entries['A15']!.answer = 289;
    puzzle.entries['A17']!.answer = 69;
    puzzle.entries['A18']!.answer = 316;
    puzzle.entries['D1']!.answer = 26;
    puzzle.entries['D3']!.answer = 96;
    puzzle.entries['D4']!.answer = 260;
    puzzle.entries['D6']!.answer = 671;
    puzzle.entries['D8']!.answer = 987;
    puzzle.entries['D10']!.answer = 248;
    puzzle.entries['D11']!.answer = 126;
    puzzle.entries['D12']!.answer = 163;
    puzzle.entries['D15']!.answer = 21;
    puzzle.entries['D16']!.answer = 95;
  }

  @override
  void solve([bool iteration = true]) {
    // setAnswers();

    if (Crossnumber.traceSolve) {
      print("MANUAL UPDATES-----------------------------");
    }
    // Force solve in same order as previous version to compare output
    try {
      solveVariable(puzzle.variables["M"]! as ExpressionVariable);
    } on SolveException {}

    try {
      solveVariable(puzzle.variables["N"]! as ExpressionVariable);
    } on SolveException {}

    try {
      solveVariable(puzzle.variables["P"]! as ExpressionVariable);
    } on SolveException {}

    try {
      solveVariable(puzzle.variables["Y"]! as ExpressionVariable);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D16"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A14"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D12"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A11"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A14"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D3"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A5"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A7"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A12"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A2"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D3"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D12"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A14"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A12"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A13"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D10"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A13"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D10"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D8"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A14"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D12"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D8"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A11"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D8"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A7"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D3"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D8"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["D15"]!);
    } on SolveException {}
    try {
      solveClue(puzzle.clues["A17"]!);
    } on SolveException {}

    super.solve(iteration);
  }
}

Map<int, Set<int>> getSumTwoPrimes() {
  var primes = <int, Set<int>>{};
  for (var p1 in twoDigitPrimes) {
    for (var p2 in twoDigitPrimes) {
      var sum = p1 + p2;
      if (!primes.containsKey(sum)) {
        primes[sum] = <int>{};
      }
      primes[sum]!.add(p1);
      primes[sum]!.add(p2);
    }
  }
  return primes;
}

Map<int, Map<String, int>> getTriangleSumTwoPrimes() {
  var triangles = getTrianglesInRange(20, 198);
  var triangleSums = <int, Map<String, int>>{};
  for (var p1 in twoDigitPrimes) {
    for (var p2 in twoDigitPrimes.where((element) => element > p1)) {
      var sum = p1 + p2;
      if (triangles.contains(sum)) {
        triangleSums[sum] = {'p1': p1, 'p2': p2};
      }
    }
  }
  return triangleSums;
}

Map<int, List<int>> getPrimesInTriangleSumTwoPrimes() {
  var triangles = getTrianglesInRange(20, 198);
  var primes = <int, List<int>>{};
  for (var p1 in twoDigitPrimes) {
    var p2s = <int>[];
    for (var p2 in twoDigitPrimes) {
      var sum = p1 + p2;
      if (p1 != p2 && triangles.contains(sum)) {
        p2s.add(p2);
      }
    }
    if (p2s.isNotEmpty) {
      primes[p1] = p2s;
    }
  }
  return primes;
}

List<int> getTwoDigitSquaresLessA1(int? d1) {
  var squares = <int>[];
  int minA1 = d1 != null ? d1 : 10;
  int maxA1 = d1 != null ? d1 : 99;
  for (var d1 = 1; d1 <= 200.sqrt().floor(); d1++) {
    var preValue = d1 * d1;
    if (preValue - minA1 > 9 && preValue - maxA1 < 100) {
      squares.add(preValue);
    }
  }

  return squares;
}

Map<int, Map<String, int>> getThreeDigitPrimeMultiples() {
  var multiples = <int, Map<String, int>>{};
  outer:
  for (var p1 in twoDigitPrimes) {
    var finished = true;
    for (var p2 in twoDigitPrimes.where((element) => element > p1)) {
      var multiple = p1 * p2;
      if (multiple >= 1000) {
        if (finished) break outer;
        break;
      }
      finished = false;
      if (multiple >= 100) {
        multiples[multiple] = {'p1': p1, 'p2': p2};
      }
    }
  }
  return multiples;
}

class ValueIterable extends Iterable<int?> {
  final int preValue;
  final int prime;
  ValueIterable(this.preValue, this.prime);
  Iterator<int?> get iterator => ValueIterator(preValue, prime);
}

class ValueIterator implements Iterator<int?> {
  String preValueStr;
  String primeStr;
  int? _current;
  int index = 0;

  ValueIterator(preValue, prime)
      : preValueStr = preValue.toString(),
        primeStr = prime.toString(),
        index = 0;

  // `moveNext`method must return boolean preValue to state if next preValue is available

  bool moveNext() {
    while (index < preValueStr.length - 1 &&
            preValueStr.substring(index, index + 2) != primeStr ||
        index == 0 && preValueStr[index + 2] == '0') {
      index++;
    }
    if (index == preValueStr.length - 1) {
      _current = null;
      return false;
    } else {
      _current = int.parse(
          preValueStr.substring(0, index) + preValueStr.substring(index + 2));
      index += 1;
      return true;
    }
  }

  // `current` getter method returns the current preValue of the iteration when `moveNext` is called
  int? get current => _current;
}
