library virus;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Virus API.
class Virus extends Crossnumber<VirusPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 |2 :3 :4 |5 |',
    '+::+--+::+::+::+',
    '|6 :7 :  |8 :  |',
    '+--+::+--+::+--+',
    '|9 :  |10:  :11|',
    '+::+::+::+--+::+',
    '|  |12:  :  |  |',
    '+--+--+--+--+--+',
  ];

  Virus() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = VirusPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        // Add KV expression
        var valueDesc = '\$kv ${entrySpec.name}';
        var entry = VirusEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          valueDesc: valueDesc,
          solve: solveVirusClue,
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
        // Add KV check for entry value
        var expString = '\$kv E$name = $valueDesc';
        var clue = VirusClue(
            name: name!,
            length: length,
            valueDesc: name != 'A2' ? expString : valueDesc,
            addDesc: addDesc,
            solve: solveVirusClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(
        name: 'A2', length: 3, valueDesc: r'$prime $jumble #otherentry');
    clueWrapper(name: 'A6', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'$DS ED7');
    clueWrapper(name: 'A10', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'$multiple ED10');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'$multiple EA9');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'$DS ED10');
    clueWrapper(name: 'D4', length: 3, valueDesc: r'$multiple ED3');
    clueWrapper(name: 'D5', length: 2, valueDesc: r'$DP EA12');
    clueWrapper(name: 'D7', length: 3, valueDesc: r'$multiple K*10+V');
    clueWrapper(name: 'D9', length: 2, valueDesc: r'$squareroot EA6');
    clueWrapper(name: 'D10', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'D11', length: 2, valueDesc: r'$factor ED1');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
      'K', 'V',
    ];
    for (var letter in letters) {
      puzzle.addVariable(VirusVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    super.solve(true);
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
  bool solveVirusClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as VirusPuzzle;
    var clue = v as VirusClue;
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
  bool updateClues(VirusPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
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
}
