library primania;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Primania API.
class Primania extends Crossnumber<PrimaniaPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|1 :2 :3 :4 |5 |6 :7 :8 |',
    '+::+::+::+::+::+::+::+::+',
    '|9 :  |10:  :  :  |  |  |',
    '+::+--+::+--+::+--+::+--+',
    '|11:12:  |13|  |14:  :15|',
    '+--+::+--+::+--+::+--+::+',
    '|16|  |17:  :18:  |19:  |',
    '+::+::+::+::+::+::+::+::+',
    '|20:  :  |  |21:  :  :  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  Primania() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = PrimaniaPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var valueDesc = entrySpec.name[0] == 'A'
            ? r'$prime #result & $prime $reverse #result'
            : null;
        var entry = PrimaniaEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          valueDesc: valueDesc,
          solve: solvePrimaniaClue,
        );
        puzzle.addEntry(entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += '${e.msg}\n';
      }
    }

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    // For alpha entry names we pass the names to clue expression parsing
    // Until we create a clue, then entries are returned as clues (legacy)
    var entryNames = puzzle.clues.keys.toList();

    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, List<String>? addDesc}) {
      try {
        var clue = PrimaniaClue(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solvePrimaniaClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'D1', valueDesc: r'$firstfactor 10109');
    clueWrapper(name: 'D2', valueDesc: r'$secondfactor 10109');
    clueWrapper(name: 'D3', valueDesc: r'$firstfactor 14687');
    clueWrapper(name: 'D4', valueDesc: r'$secondfactor 14687');
    clueWrapper(name: 'D5', valueDesc: r'$firstfactor 15479');
    clueWrapper(name: 'D6', valueDesc: r'$secondfactor 15479');
    clueWrapper(name: 'D7', valueDesc: r'$firstfactor 22681');
    clueWrapper(name: 'D8', valueDesc: r'$secondfactor 22681');
    clueWrapper(name: 'D9', valueDesc: r'$firstfactor 24067');
    clueWrapper(name: 'D10', valueDesc: r'$secondfactor 24067');
    clueWrapper(name: 'D11', valueDesc: r'$firstfactor 25043');
    clueWrapper(name: 'D12', valueDesc: r'$secondfactor 25043');
    clueWrapper(name: 'D13', valueDesc: r'$firstfactor 30167');
    clueWrapper(name: 'D14', valueDesc: r'$secondfactor 30167');
    clueWrapper(name: 'D15', valueDesc: r'$firstfactor 38179');
    clueWrapper(name: 'D16', valueDesc: r'$secondfactor 38179');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    // Get Entry expressions from Clue expressions
    // Only needed when Clue expressions refer to Entries
    for (var clue in puzzle.clues.values) {
      for (var exp in clue.expressions) {
        for (var entryName in clue.entryNameReferences) {
          // Rearrange expression for new subject
          var expText = exp.rearrangeExpressionText(entryName, clue.name);
          if (expText != null) {
            puzzle.entries[entryName]!
                .addExpression(expText, entryNames: entryNames);
          }
        }
      }
    }

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(PrimaniaVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  void mapCallback() {
    var mapping = puzzle.entries.values.where((e) => e.clue != null).map((e) {
      var c = e.clue!;
      return 'Entry ${e.name} =  ${c.value!} (Clue ${c.name})';
    }).join('\n');
    print('Solution Mapping\n$mapping');
    print(puzzle.toSolution());
  }

  @override
  void solve([bool iteration = true]) {
    super.solve(false);

    // Filter entry values using Down values
    filterEntryValues();

    super.solve(false);

    var clueEntries = findClueEntries();

    // Match clues to entries
    // Map clues to entries, updates entry values and digits
    var count = puzzle.mapOrderedCluesToEntries(clueEntries, mapCallback);
    print('Solution count: $count');
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solvePrimaniaClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as PrimaniaPuzzle;
    var clue = v as PrimaniaClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        updated = puzzle.solveExpressionEvaluator(
            clue, clue.exp, possibleValue, possibleVariables!, validClue);
      } else {
        var first = true;
        String? exceptionMessage;
        for (var exp in clue.expressions) {
          var possibleValueExp = <int>{};
          try {
            // Previous evaluation may have cleared variables
            if (possibleVariables!.isEmpty) return updated;
            updated = puzzle.solveExpressionEvaluator(
              clue,
              exp,
              first ? possibleValue : possibleValueExp,
              possibleVariables,
              validClue,
            );
            // Combine values
            if (first) {
              first = false;
              // Got first values above
            } else {
              // Keep intersection of values
              var remove = possibleValue
                  .where((value) => !possibleValueExp.contains(value))
                  .toList();
              possibleValue.removeAll(remove);
            }
          } on SolveException catch (e) {
            // Keep processing other expressions
            exceptionMessage = e.msg;
          }
        }
        if (first) {
          // All expressions threw exception
          throw SolveException(exceptionMessage);
        }
      }
    } else {
      // Values may have been set by other Clue
      if (clue.values != null) {
        var values =
            clue.values!.where((value) => validClue(clue, value, [], []));
        possibleValue.addAll(values);
      }
    }
    return updated;
  }

  @override
  bool updateClues(
      PrimaniaPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(thisPuzzle, clue, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue value order
      // var clue = thisPuzzle.clues[clueName]!;
      // var newMin = clue.values!.reduce(min);
      // if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      // var newMax = clue.values!.reduce(max);
      // if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // // Clues are defined in ascending order of value
      // for (var otherClue in thisPuzzle.clues.values) {
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
    }
    return updated;
  }

  void filterEntryValues() {
    // Get down values
    var downValues = puzzle.clues.values.map((c) => c.value!).toList()..sort();
    var downValuesTwoDigits =
        downValues.where((element) => element < 100).toSet();
    var downValuesThreeDigits =
        downValues.where((element) => element >= 100).toSet();

    // Filter entry values
    print("FILTER-----------------------------");
    for (var entry in puzzle.entries.values.where((entry) => entry.isDown)) {
      var possibleValues =
          entry.length == 2 ? downValuesTwoDigits : downValuesThreeDigits;
      var updated = entry.updatePossible(possibleValues);
      if (entry.finalise()) updated = true;

      if (Crossnumber.traceSolve && updated) {
        print("filter${puzzle.name}: ${entry.toString()}");
      }
    }
  }

  Map<PrimaniaClue, List<PrimaniaEntry>> findClueEntries() {
    // There are only 2 positions that can take 23 & 41 and 2 positions that can
    // take 523 & 587.
    var clueEntries = <PrimaniaClue, List<PrimaniaEntry>>{};
    for (var clue in puzzle.clues.values) {
      var entries = findPossibleEntriesForClue(clue);
      clueEntries[clue] = entries;
    }
    for (var clue1 in puzzle.clues.values) {
      var entries1 = clueEntries[clue1]!;
      if (entries1.length == 2) {
        for (var clue2
            in puzzle.clues.values.where((clue2) => clue2 != clue1)) {
          var entries2 = clueEntries[clue2]!;
          if (entries2.length == 2 &&
              entries1[0] == entries2[0] &&
              entries1[1] == entries2[1]) {
            for (var otherClue in puzzle.clues.values) {
              if (otherClue != clue1 && otherClue != clue2) {
                clueEntries[otherClue]!.remove(entries1[0]);
                clueEntries[otherClue]!.remove(entries1[1]);
              }
            }
          }
        }
      }
    }
    for (var clue in puzzle.clues.values) {
      var entries = clueEntries[clue]!;
      print(
          'Clue ${clue.name}, entries, ${puzzle.entries.values.where((e) => e.isDown).map((e) => entries.contains(e) ? e.name : '').join(',')}');
    }
    return clueEntries;

    // The missing 2-digit across entries must be reversible and the only remaining
    // candidates are 13 & 31 and 17 & 71.
    // None of the 3-digit downs has a 3 as its middle digit making 13 an entry
    // in the top half of the grid and 31 an entry in the bottom.
  }

  List<PrimaniaEntry> findPossibleEntriesForClue(PrimaniaClue clue) {
    var result = <PrimaniaEntry>[];
    for (var entry in puzzle.entries.values) {
      var value = clue.value!;
      var ok = true;
      if (entry.isDown && entry.length == clue.length) {
        for (var d = entry.length! - 1; d >= 0; d--) {
          var digit = value % 10;
          if (!entry.digits[d].contains(digit)) {
            ok = false;
            break;
          }
          value ~/= 10;
        }
        if (ok) result.add(entry);
      }
    }
    return result;
  }
}
