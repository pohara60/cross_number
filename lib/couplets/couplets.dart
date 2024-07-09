library couplets;

import 'package:crossnumber/monadic.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Couplets API.
class Couplets extends Crossnumber<CoupletsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|1 :2 :  :3 |4 |5 :6 :7 |',
    '+::+::+--+::+::+--+::+::+',
    '|8 :  :  |9 :  |10:  :  |',
    '+::+::+--+--+::+::+::+::+',
    '|  |11:12:  :  :  |  |  |',
    '+--+--+::+--+::+::+--+::+',
    '|13:14:  :  |  |  |15:  |',
    '+--+::+::+--+--+::+::+--+',
    '|16:  |  |17|18:  :  :  |',
    '+::+--+::+::+--+::+--+--+',
    '|  |19|20:  :  :  :21|22|',
    '+::+::+::+::+--+--+::+::+',
    '|23:  :  |24:25|26:  :  |',
    '+::+::+--+::+::+--+::+::+',
    '|27:  :  |  |28:  :  :  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  Couplets() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = CoupletsPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = CoupletsEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          solve: solveCoupletsClue,
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
        var clue = CoupletsClue(
            name: name!,
            length: length,
            isDouble: true,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solveCoupletsClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(
        name: 'I', valueDesc: r'A1+D17 = $notpalindrome #result', length: 4);
    clueWrapper(name: 'II', valueDesc: r'A5+D22 = #square', length: 3);
    clueWrapper(
        name: 'III',
        valueDesc: r'A8+$reverse A8 = $multiple (A15+$reverse A15)',
        length: 3);
    // puzzle.clues['III']!.addExpression(
    //     r'D2+$reverse D2 = $multiple (D25+$reverse D25)',
    //     entryNames: entryNames);
    clueWrapper(name: 'IV', valueDesc: r'A9+D15 = #triangular', length: 2);
    clueWrapper(
        name: 'V',
        valueDesc: r'A10+$reverse A10 = 2*(A23+$reverse A23)/3',
        length: 3);
    // puzzle.clues['V']!.addExpression(r'D19+$reverse D19 = 2*(D6+$reverse D6)/3',
    //     entryNames: entryNames);
    clueWrapper(
        name: 'VI',
        valueDesc: r'A11+$reverse A11 = $cube (A16+$reverse A16)',
        length: 5);
    clueWrapper(name: 'VII', valueDesc: r'A13+D16 = #fibonacci', length: 4);
    clueWrapper(name: 'VIII', valueDesc: r'A15+D25 = #square', length: 2);
    clueWrapper(name: 'IX', valueDesc: r'A16+D3 = #fibonacci', length: 2);
    clueWrapper(
        name: 'X',
        valueDesc:
            r'$ds (A18+$reverse A18) = $ds (A26+$reverse A26) = $ds #result',
        length: 4);
    clueWrapper(name: 'XI', valueDesc: r'A20+D10 = #triangular', length: 5);
    clueWrapper(
        name: 'XII',
        valueDesc: r'A23+$reverse A23 = 3*(A10+$reverse A10)/2',
        length: 3);
    // puzzle.clues['XII']!.addExpression(
    //     r'D6+$reverse D6 = 3*(D19+$reverse D19)/2',
    //     entryNames: entryNames);
    clueWrapper(
        name: 'XIII', valueDesc: r'A24+D14 = 2 * #triangular', length: 2);
    clueWrapper(name: 'XIV', valueDesc: r'A26+D21', length: 3);
    clueWrapper(name: 'XV', valueDesc: r'A27+D1 = #Sum2square', length: 3);
    clueWrapper(name: 'XVI', valueDesc: r'A28+D4 = #triangular', length: 4);

    addReverseClues('A1', 'D17', entryNames);
    addReverseClues('A5', 'D22', entryNames);
    addReverseClues('A8', 'D2', entryNames);
    addReverseClues('A9', 'D15', entryNames);
    addReverseClues('A10', 'D19', entryNames);
    addReverseClues('A11', 'D12', entryNames);
    addReverseClues('A13', 'D16', entryNames);
    addReverseClues('A15', 'D25', entryNames);
    addReverseClues('A16', 'D3', entryNames);
    addReverseClues('A18', 'D7', entryNames);
    addReverseClues('A20', 'D10', entryNames);
    addReverseClues('A23', 'D6', entryNames);
    addReverseClues('A24', 'D14', entryNames);
    addReverseClues('A26', 'D21', entryNames);
    addReverseClues('A27', 'D1', entryNames);
    addReverseClues('A28', 'D4', entryNames);

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
      puzzle.addAnyVariable(CoupletsVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  void solve([bool iteration = true]) {
    //  VI: A11+D12 = $cube (A16+D3) = 166375	so each is at least 66376
    puzzle.entries['A11']!.values = {69179, 78188, 87197};
    puzzle.entries['D12']!.values = {97196, 88187, 79178};

    super.solve(false);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }

    // Each clue has at least one pair of variables that must be the reverse of each other
    var acrossIndex = 0;
    for (var acrossClueName in variableReferences) {
      var acrossClue = puzzle.entries[acrossClueName];
      if (acrossClue != null && acrossClue.isAcross) {
        var downClueName = reverseClues[acrossClueName];
        if (downClueName != null) {
          var downIndex = variableReferences.indexOf(downClueName);
          if (downIndex != -1) {
            var acrossValue = variableValues[acrossIndex];
            var downValue = variableValues[downIndex];
            if (acrossValue != reverse(downValue)) return false;
          }
        }
      }
      acrossIndex++;
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveCoupletsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as CoupletsPuzzle;
    var clue = v as CoupletsClue;
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

  @override
  bool updateClues(
      CoupletsPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    var updated = super.updateClues(thisPuzzle, clue, possibleValues,
        isFocus: isFocus, isEntry: isEntry, focusClue: focusClue);
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

  var reverseClues = <String, String>{};
  void addReverseClues(String across, String down, List<String> entryNames) {
    assert(puzzle.entries[across]!.isAcross);
    assert(puzzle.entries[down]!.isDown);
    reverseClues[across] = down;

    // Set entry expressions
    puzzle.entries[across]!
        .addExpression(r'$reverse ' + down, entryNames: entryNames);
    puzzle.entries[down]!
        .addExpression(r'$reverse ' + across, entryNames: entryNames);
  }
}
