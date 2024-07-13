library opposingdigitsum;

import '../cartesian.dart';
import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the OpposingDigitSum API.
class OpposingDigitSum extends Crossnumber<OpposingDigitSumPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :  |2 |3 :4 :  |',
    '+::+--+::+::+::+--+',
    '|5 :6 :  :  |  |7 |',
    '+::+::+--+--+::+::+',
    '|  |  |8 :9 :  :  |',
    '+--+::+::+::+--+::+',
    '|10:  :  |  |11:  |',
    '+--+--+--+--+--+--+',
  ];

  OpposingDigitSum() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = OpposingDigitSumPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = OpposingDigitSumEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          solve: solveOpposingDigitSumClue,
        );
        puzzle.addEntry(entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += '${e.msg}\n';
      }
    }

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, List<String>? addDesc}) {
      try {
        var clue = OpposingDigitSumClue(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solveOpposingDigitSumClue);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 2, valueDesc: r'$DP EA11 = #square');
    clueWrapper(name: 'A3', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A5', length: 4, valueDesc: r'#palindrome');
    clueWrapper(name: 'A8', length: 4, valueDesc: r'$reverse EA5');
    clueWrapper(name: 'A10', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A11', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'D1', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D2', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'$DS ED4');
    clueWrapper(name: 'D4', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D6', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D7', length: 3, valueDesc: r'$multiple ED1');
    clueWrapper(name: 'D8', length: 2, valueDesc: r'$DP ED6');
    clueWrapper(name: 'D9', length: 2, valueDesc: r'#triangular');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.linkEntriesToGrid();

    // Entry value is Clue value + Digit Sum of symetrically opposite Entry value
    for (var clue in puzzle.clues.values) {
      var entry = puzzle.entries[clue.name]!;
      var oppositeEntry = puzzle.getOppositeEntry(entry);
      var expText = '${clue.name} + \$DS E${oppositeEntry.name}';
      entry.addExpression(expText);

      // Clue cannot be linked to Entry as values are different
      clue.entry == null;
      entry.clue == null;
    }

    // Additional inverse expressions
    // EA11 = $-DP A1
    // A11  = EA11 - $DS EA1
    // puzzle.entries['A11']!.addExpression(r'$whereDP A1');
    // puzzle.clues['A11']!.addExpression(r'EA11 - $DS EA1');

    // Get Entry expressions from Clue expressions
    // Only needed when Clue expressions refer to Entries
    // for (var clue in puzzle.clues.values) {
    //   for (var exp in clue.expressions) {
    //     for (var entryName in clue.entryReferences) {
    //       // Rearrange expression for new subject
    //       var expText = exp.rearrangeExpressionText(entryName, clue.name);
    //       if (expText != null) {
    //         puzzle.entries[entryName]!
    //             .addExpression(expText, entryNames: entryNames);
    //       }
    //     }
    //   }
    // }

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(OpposingDigitSumVariable(letter));
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkPuzzleVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    puzzle.finalize();

    puzzle.getRelatedVariables();

    super.initCrossnumber();
  }

  @override
  void solve([bool iteration = true]) {
    puzzle.clues['D2']!.answer = 45;
    puzzle.clues['D9']!.answer = 36;
    puzzle.entries['A1']!.answer = 49;
    puzzle.entries['D1']!.answer = 442;
    puzzle.entries['D2']!.answer = 54;
    // puzzle.entries['A3']!.answer = 279;
    puzzle.entries['D3']!.answer = 25;
    puzzle.entries['D4']!.answer = 753;
    puzzle.entries['A5']!.answer = 4245;
    puzzle.entries['D6']!.answer = 246;
    puzzle.entries['D7']!.answer = 894;
    puzzle.entries['A8']!.answer = 5439;
    puzzle.entries['D8']!.answer = 55;
    puzzle.entries['D9']!.answer = 45;
    // puzzle.entries['A10']!.answer = 365;
    puzzle.entries['A11']!.answer = 94;
    super.solve(false);
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
  bool solveOpposingDigitSumClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as OpposingDigitSumPuzzle;
    var clue = v as OpposingDigitSumClue;
    var updated = false;

    // Get related variables
    var relatedVariables = puzzle.relatedVariablesForVariable(clue);
    if (relatedVariables == null) {
      throw PuzzleException(
          'Variable ${clue.name} does not have related variables');
    }
    // print(
    //     '${clue.variableType} ${clue.name}, relatedVariables=${relatedVariables.map((e) => e.name)}');

    // solveClue does not know to initialise the relatedVariables
    for (var variableRef in relatedVariables) {
      if (variableRef is Clue && variableRef.initialise()) updated = true;
    }

    var maxCount = 10000000;
    var maxIndex = relatedVariables.length - 1;

    bool solveNextClue(
      List<Variable> relatedVariables,
      int index,
      List<Variable> variables,
      List<int> product,
      List<Variable> solvedVariables,
      List<int> solvedVariableValues,
      int maxCount,
    ) {
      // Function to solve one variable and recurse for others
      var updated = false;
      var variable = relatedVariables[index] as VariableClue;
      // if (index > 0) {
      //   print('solveAllClues: index=$index, variable=${variable.name}');
      // }
      // Just support one expression per clue for now
      var exp = (variable as Expression).exp;
      var variableIndex = variables.indexOf(variable);

      var count = 0;
      var newVariables = <Variable>[];
      var newVariableValues = <List<int>>[];
      var variableNames = <String>[];
      try {
        count = puzzle.getVariables(
          [variable],
          [exp],
          possibleValue,
          possibleVariables!,
          newVariables,
          newVariableValues,
          maxCount,
          variables,
          solvedVariables,
          solvedVariableValues,
        );
      } on SolveException {
        // Exceeded maxCount
        count = 0;
        if (index > 0) rethrow;
      }
      // print(
      //     '${clue.variableType} ${clue.name}, index=$index, variable=${variable.name}, count=$count');

      // No variables, or have variable product count
      if (newVariableValues.isEmpty || count > 0) {
        var nextVariableNames =
            variableNames + newVariables.map((e) => e.name).toList();
        for (var variable in newVariables) {
          if (!possibleVariables!.containsKey(variable)) {
            possibleVariables[variable] = <int>{};
          }
        }
        var nextVariables = variables + newVariables;
        var firstVariableIndex = relatedVariables.indexOf(v);
        solvedVariables.add(variable);
        // With different types of variables, we have to allow duplicates in the product
        for (var newProduct in newVariableValues.isEmpty
            ? [<int>[]]
            : cartesian(newVariableValues, true)) {
          try {
            var knownValue =
                variableIndex != -1 ? product[variableIndex] : null;
            var nextProduct = product + newProduct;
            productLoop:
            for (var value in exp.generate(
                knownValue ?? 1,
                knownValue ?? clue.max,
                nextVariables,
                nextProduct,
                clue.values)) {
              // Check if variable value is constrained by earlier variable evaluation
              if (variableIndex != -1 && product[variableIndex] != value) {
                continue;
              }
              // Check duplicates for variables of the same type
              var types = newVariables.map((e) => e.variableType).toSet();
              for (var type in types) {
                var values = <int>{};
                for (var i = 0; i < nextVariables.length; i++) {
                  if (nextVariables[i].variableType == type) {
                    var value = nextProduct[i];
                    if (values.contains(value)) {
                      continue productLoop;
                    }
                    values.add(value);
                  }
                }
              }

              var valid =
                  validClue(variable, value, nextVariableNames, nextProduct);
              if (!valid) continue;
              solvedVariableValues.add(value);

              // Recurse to next variable?
              if (index < maxIndex) {
                // Add this variable and value to product
                try {
                  updated = solveNextClue(
                      relatedVariables,
                      index + 1,
                      nextVariables,
                      nextProduct,
                      solvedVariables,
                      solvedVariableValues,
                      maxCount ~/ count);
                } on SolveException {
                  // Return values so far
                  var i = 0;
                  for (var variable in nextVariables) {
                    possibleVariables![variable]!.add(nextProduct[i++]);
                  }
                  possibleValue.add(solvedVariableValues[firstVariableIndex]);
                  // Do not try this index again
                  maxIndex = index;
                }
              } else {
                var i = 0;
                for (var variable in nextVariables) {
                  possibleVariables![variable]!.add(nextProduct[i++]);
                }
                possibleValue.add(solvedVariableValues[firstVariableIndex]);
              }
              solvedVariableValues.removeLast();
            }
          } on ExpressionInvalid {
            // Illegal values
          }
        }
        solvedVariables.removeLast();
        return updated;
      } else {
        if (index == 0 && clue == variable) {
          // If count is zero then have possible values, and can check them
          var removePossibleValue = <int>{};
          var variable = relatedVariables[0] as VariableClue;
          for (var value in possibleValue) {
            var valid = validClue(variable, value, [], []);
            if (!valid) removePossibleValue.add(value);
          }
          if (removePossibleValue.isNotEmpty) {
            possibleValue.removeAll(removePossibleValue);
          }
          // Get values for other variables
          // variables.clear;
          // possibleVariables!.clear();
          // for (var variable
          //     in relatedVariables.where((element) => element != clue)) {
          //   if (variable is VariableClue) {
          //     var variableValues =
          //         variable.values ?? variable.getValuesFromDigits();
          //     if (variableValues != null) {
          //       variables.add(variable);
          //       possibleVariables[variable] = variableValues
          //           .where((element) => validClue(variable, element, [], []))
          //           .toSet();
          //     }
          //   }
          // }
        } else {
          possibleValue.clear();
          throw SolveException('Cannot compute ${variable.name}');
        }
        return updated;
      }
    }

    var solveVariables =
        clue == relatedVariables.first ? relatedVariables : [clue];
    maxIndex = solveVariables.length - 1;
    updated = solveNextClue(solveVariables, 0, [], [], [], [], maxCount);

    return updated;
  }

  @override
  bool updateClues(
      OpposingDigitSumPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // This logic does not apply to this puzzle
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    // if (!isFocus && !isEntry) {
    //   return false;
    // }
    var updated = super.updateClues(thisPuzzle, clue, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
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
    }
    return updated;
  }
}
