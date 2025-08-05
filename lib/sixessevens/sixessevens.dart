library sixessevens;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the SixesSevens API.
class SixesSevens extends Crossnumber<SixesSevensPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 :3 |4 :5 :6 |',
    '+--+::+::+::+::+::+',
    '|7 :  |8 :  |  |  |',
    '+::+--+--+--+--+::+',
    '|  |9 |10:11|12:  |',
    '+::+::+::+::+::+--+',
    '|13:  :  |14:  :  |',
    '+--+--+--+--+--+--+',
  ];

  SixesSevens() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = SixesSevensPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var clueName = entrySpec.name;
        var entry = SixesSevensEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          valueDesc: '\$jumbledigits6and7 $clueName',
          solve: solveSixesSevensClue,
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
        var clue = SixesSevensClue(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solveSixesSevensClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'$multiple ED3');
    clueWrapper(name: 'A4', length: 3, valueDesc: r'$multiple ED5');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'ED2 + #prime');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'$prime $factor ED7');
    clueWrapper(name: 'A10', length: 2, valueDesc: r'#square - ED5');
    clueWrapper(name: 'A12', length: 2, valueDesc: r'$divisor ED6');
    clueWrapper(name: 'A13', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'A14', length: 3, valueDesc: r'EA14 - #triangular');
    clueWrapper(name: 'D2', length: 2, valueDesc: r'$squareroot EA1');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'$divisor EA4');
    clueWrapper(name: 'D5', length: 2, valueDesc: r'#odd');
    clueWrapper(name: 'D6', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D7', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D9', length: 2, valueDesc: r'$divisor EA13');
    clueWrapper(name: 'D10', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'D11', length: 2, valueDesc: r'$multiple ED5');
    clueWrapper(name: 'D12', length: 2, valueDesc: r'EA14/ED11');

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
            var name = entryName[0] == 'E' ? entryName.substring(1) : entryName;
            puzzle.entries[name]!
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
      puzzle.addVariable(SixesSevensVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    super.solve(iteration);
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
  bool solveSixesSevensClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as SixesSevensPuzzle;
    var clue = v as SixesSevensClue;
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
}
