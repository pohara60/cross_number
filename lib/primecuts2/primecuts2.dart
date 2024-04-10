/// An API for solving Prime Cuts puzzles.
library primecuts;

import 'package:powers/powers.dart';

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

    puzzle.addDigitIdentityFromGrid();

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
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
    return true;
  }

  // Validate possible entry value
  bool validEntry(VariableClue entry, int value,
      List<String> variableReferences, List<int> variableValues) {
    // Validate against known values
    if (entry.values != null && !entry.values!.contains(value)) return false;
    // Validate against digits
    return entry.digitsMatch(value);
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
    var possibleEntryValue = possibleValue2!;
    var possibleEntryVariables = possibleVariables2!;

    // Solve Clue
    var updated = puzzle.solveExpressionEvaluator(
        clue, clue.exp, possibleValue, possibleVariables!, validClue);

    // Solve Entry
    // If expression, then evaluate it
    if (entry.valueDesc != '') {
      try {
        if (puzzle.solveExpressionEvaluator(
            entry,
            entry.exp,
            possibleEntryValue,
            possibleEntryVariables,
            validEntry)) updated = true;
      } on SolveException {
        // Could not solve expression
        if (entry.values != null) {
          possibleEntryValue.clear();
          possibleEntryValue
              .addAll(entry.values!.where((v) => entry.digitsMatch(v)));
          possibleEntryVariables.clear();
        }
      }
    } else if (entry.values != null) {
      possibleEntryValue
          .addAll(entry.values!.where((v) => entry.digitsMatch(v)));
    }

    // TODO A2 = multiple EA2, so clue and entry are not independent
    // TODO ED11 = G+W = 126, but others left - variable doe not have referrers?
    // Find Clue value without possible primes that match entry value
    var newClueValues = <int>{};
    var newEntryValues = <int>{};
    var primeValues = <int>{};
    for (var clueValue in possibleValue) {
      var clueValueOK = false;
      for (var primeValue in puzzle.primes[clue.prime]!.values!) {
        for (var value in ValueIterable(clueValue, primeValue)) {
          if (possibleEntryValue.isNotEmpty) {
            if (possibleEntryValue.contains(value)) {
              clueValueOK = true;
              newEntryValues.add(value!);
              primeValues.add(primeValue);
            }
          } else {
            clueValueOK = true;
            newEntryValues.add(value!);
            primeValues.add(primeValue);
          }
        }
      }
      if (clueValueOK) newClueValues.add(clueValue);
    }

    if (newClueValues.length != possibleValue.length) {
      possibleValue.clear();
      possibleValue.addAll(newClueValues);
      // TODO The variable values are not updated for the lost values
    }
    if (newEntryValues.length != possibleEntryValue.length) {
      possibleEntryValue.clear();
      possibleEntryValue.addAll(newEntryValues);
    }
    if (updateVariables(puzzle, clue.prime, primeValues, updatedVariables!))
      updated = true;

    return updated;
  }

  // Override solveClue to manage preValues
  @override
  bool solveClue(Clue inputClue) {
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
        updateVariables(puzzle, variableName,
            possibleEntryVariables[variableName]!, updatedVariables);
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

  @override
  void solve([bool iteration = true]) {
    //solveClue(puzzle.clues["D16"]!);

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
