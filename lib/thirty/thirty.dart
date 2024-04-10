library thirty;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../monadic.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Thirty API.
class Thirty extends Crossnumber<ThirtyPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :  |3 :4 |',
    '+::+::+--+::+::+',
    '|  |5 :6 :  |  |',
    '+::+::+::+::+::+',
    '|7 :  |8 :  :  |',
    '+--+--+--+--+--+',
  ];

  Thirty() {
    initCrossnumber();
    addPairConstraint();
  }

  void initCrossnumber() {
    for (var i = 0; i < 2; i++) {
      var puzzle = ThirtyPuzzle.fromGridString(this, gridString,
          name: i == 0 ? 'Left' : 'Right');
      this.puzzles.add(puzzle);

      // Get entries from grid
      var entryErrors = '';
      for (var entrySpec in puzzle.getEntriesFromGrid()) {
        try {
          var entry = ThirtyEntry(
            name: entrySpec.name,
            length: entrySpec.length,
            solve: solveThirtyClue,
            puzzleName: puzzle.name[0],
          );
          puzzle.addEntry(entry);
        } on ExpressionInvalid catch (e) {
          entryErrors += e.msg + '\n';
        }
      }

      if (entryErrors != '') {
        throw PuzzleException(entryErrors);
      }

      // Needed even when create entries from grid
      puzzle.validateEntriesFromGrid();

      puzzle.addDigitIdentityFromGrid();
    }

    super.initCrossnumber();
    initPairs();
  }

  var iterating = false;
  @override
  void solve([bool iteration = true]) {
    for (var i in [0, 1]) {
      puzzles[i].clues['A3']!.values = {22, 24, 26, 42, 44};
      puzzles[i].clues['D6']!.values = {
        24,
        26,
        28,
        44,
        46,
        48,
        64,
        66,
        68,
        84,
        86,
        88
      };
      puzzles[i].clues['A7']!.values = {20, 24, 26, 40};
      puzzles[i].clues['A8']!.values = {440, 480, 624, 840, 880};
    }
    // One value of A8 does not end in 0, 624 = 24*26
    puzzles[0].clues['A8']!.values = {624};
    puzzles[0].clues['A3']!.values = {24, 26};
    puzzles[0].clues['A7']!.values = {24, 26};
    // Solution
    puzzles[0].clues['A1']!.values = {866};
    puzzles[0].clues['A3']!.values = {24};
    puzzles[0].clues['A5']!.values = {680};
    puzzles[0].clues['A7']!.values = {26};
    puzzles[0].clues['A8']!.values = {624};
    puzzles[0].clues['D1']!.values = {802};
    // puzzles[0].clues['D2']!.values = {666};
    puzzles[0].clues['D3']!.values = {202};
    // puzzles[0].clues['D4']!.values = {404};
    // puzzles[0].clues['D6']!.values = {86};
    for (var clue in puzzles[0].clues.values) {
      clue.finalise();
    }

    super.solve(iteration);
  }

  var knownValues = <int, ThirtyClue?>{};

  @override
  void initPairs() {
    for (var i = 0; i < 9; i += 2) {
      for (var j = 0; j <= i; j += 2) {
        var pair = j * 10 + i;
        pairs[pair] = -1;
      }
    }
  }

  @override
  int getPairValue(int i, int j) {
    if (i <= j)
      return i * 10 + j;
    else
      return j * 10 + i;
  }

  void getKnownValues() {
    knownValues = <int, ThirtyClue?>{};
    initPairs();
    var p1 = puzzles[0];
    var p2 = puzzles[1];
    for (var clue in p1.clues.values) {
      var otherClue = p2.clues[clue.name]!;
      if (clue.isSet) {
        knownValues[clue.values!.first] = clue;
      }
      if (otherClue.isSet) {
        knownValues[otherClue.values!.first] = otherClue;
      }
      for (var d = 0; d < clue.length!; d++) {
        var digits = clueDigits(clue, d);
        if (digits.length == 1) {
          var otherDigits = clueDigits(otherClue, d);
          if (otherDigits.length == 1) {
            var pair = getPairValue(digits.first, otherDigits.first);
            if (!(pairs[pair] == -1 ||
                pairs[pair] == clue.entryMixin!.cellDigitIndex(d))) {
              throw SolveException('Pair violation');
            }
            pairs[pair] = clue.entryMixin!.cellDigitIndex(d);
          }
        }
      }
    }
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;

    // Other clue
    if (knownValues[value] != null && knownValues[value] != clue) {
      return false;
    }

    // Jumble
    for (var jumbleValue in jumble(value)) {
      var knownClue = knownValues[jumbleValue];
      if (knownClue != null && knownClue != clue) {
        return false;
      }
    }

    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveThirtyClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as ThirtyPuzzle;
    var clue = v as ThirtyClue;
    var updated = false;

    var otherPuzzle = puzzle == puzzles[0] ? puzzles[1] : puzzles[0];
    getKnownValues();

    // Values may have been set by other Clue
    if (clue.name == 'A1') {
      // 1ac = 1dn + 3ac, both from the opposite grid
      var d1 = otherPuzzle.clues['D1']!;
      var a3 = otherPuzzle.clues['A3']!;
      var d1values = d1.values ?? d1.getValuesFromDigits()!;
      var a3values = a3.values ?? a3.getValuesFromDigits()!;
      var d1possible = <int>{};
      var a3possible = <int>{};
      for (var d1value in d1values) {
        if (knownValues[d1value] != null && knownValues[d1value] != d1)
          continue;
        for (var a3value in a3values) {
          if (d1value == a3value ||
              knownValues[a3value] != null && knownValues[a3value] != a3)
            continue;
          var value = d1value + a3value;
          if (validClue(clue, value, [], [])) {
            possibleValue.add(value);
            d1possible.add(d1value);
            a3possible.add(a3value);
          }
        }
      }
      if (d1possible.isEmpty || a3possible.isEmpty) {
        throw SolveException('No possible values!');
      }
      updateClues(otherPuzzle, d1.name, d1possible);
      updateClues(otherPuzzle, a3.name, a3possible);
    } else if (clue.name == 'A8') {
      // 8ac = 3ac x 7ac, both from the same grid
      var a3 = puzzle.clues['A3']!;
      var a7 = puzzle.clues['A7']!;
      var a3values = a3.values ?? a3.getValuesFromDigits()!;
      var a7values = a7.values ?? a7.getValuesFromDigits()!;
      var a3possible = <int>{};
      var a7possible = <int>{};
      for (var a3value in a3values) {
        if (knownValues[a3value] != null && knownValues[a3value] != a3)
          continue;
        for (var a7value in a7values) {
          if (a3value == a7value ||
              knownValues[a7value] != null && knownValues[a7value] != a7)
            continue;
          var value = a3value * a7value;
          if (validClue(clue, value, [], [])) {
            possibleValue.add(value);
            a3possible.add(a3value);
            a7possible.add(a7value);
          }
        }
      }
      if (a3possible.isEmpty || a7possible.isEmpty) {
        throw SolveException('No possible values!');
      }
      updateClues(puzzle, a3.name, a3possible);
      updateClues(puzzle, a7.name, a7possible);
    } else {
      var values = clue.values;
      if (values == null) {
        values = getValuesFromDigits(clue);
      }
      if (values != null) {
        possibleValue
            .addAll(values.where((value) => validClue(clue, value, [], [])));
      }
    }
    return updated;
  }

  @override
  bool updateClues(
      ThirtyPuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry, focusClueName: focusClueName);
    if (updated) {
      /*
      Every digit is even and there are fifteen pairs of even digits, from {0,0}, {0,2} up to {8,8}. For this purpose, {p,q} is the same as {q,p}. Each of the fifteen pairs fills one of the matching cells of the two grids, one in each grid. All entries are distinct, and none starts with zero.
      The sum of the digits in the first grid equals the sum of the digits in the second grid.
      No entry is a jumble of another entry.
      */
      var clue = puzzle.clues[clueName]!;
      if (possibleValues.length == 1) {
        var value = possibleValues.first;
        if (knownValues.containsKey(value)) {
          throw SolveException('Known value violation');
        }
        // knownValues[value] = clue;
      }
      // Digits
      updatePairs(puzzle, clue);

      // Maintain clue value order
      // var clue = puzzle.clues[clueName]!;
      // var newMin = clue.values!.reduce(min);
      // if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      // var newMax = clue.values!.reduce(max);
      // if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // // Clues are defined in ascending order of value
      // for (var otherClue in puzzle.clues.values) {
      //   if (romanToDecimal(otherClue.name) > romanToDecimal(clue.name)) {
      //     if ((otherClue.min == null || otherClue.min! <= clue.min!)) {
      //       otherClue.min = clue.min! + 1;
      //     }
      //   }
      //   if (romanToDecimal(otherClue.name) < romanToDecimal(clue.name)) {
      //     if ((otherClue.max == null || otherClue.max! >= clue.max!)) {
      //       otherClue.max = clue.max! - 1;
      //     }
      //   }
      // }
    }
    return updated;
  }

  var unfinishedPuzzles = <ThirtyPuzzle>[];
  @override
  void endSolve(bool iteration) {
    iterating = true;
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
    if (unfinishedPuzzles.isNotEmpty) {
      unfinishedPuzzles = puzzles;
      unfinishedPuzzles.first.postProcessing(iteration);
    }
  }

  @override
  int callback(Puzzle puzzle) {
    // Puzzle has found a valid solution, check futher puzzles
    var index = unfinishedPuzzles.indexOf(puzzle);
    if (index + 1 == unfinishedPuzzles.length) {
      // Check sum of digits
      var sum0 = puzzles[0].sumdigits();
      var sum1 = puzzles[1].sumdigits();
      if (sum0 != sum1) return 0;
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
}
