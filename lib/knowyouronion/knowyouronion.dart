library knowyouronion;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the KnowYourOnion API.
class KnowYourOnion extends Crossnumber<KnowYourOnionPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|A :a :b |B :c :  |d |',
    '+--+::+::+--+::+--+::+',
    '|Ce:  :  |D :  :f |  |',
    '+::+::+::+--+::+::+::+',
    '|  |E :  :g |F :  :  |',
    '+::+--+--+::+--+::+--+',
    '|G :h :  |  |H :  :k |',
    '+--+::+--+::+--+--+::+',
    '|Km:  :n |M :p :q |  |',
    '+::+::+::+--+::+::+::+',
    '|  |N :  :  |P :  :  |',
    '+::+--+::+--+::+::+--+',
    '|  |Q :  :  |R :  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  KnowYourOnion() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = KnowYourOnionPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var expStr =
            'BmQMmaqhfpNcFdpE'.contains(entrySpec.name) ? '#prime' : null;

        var entry = KnowYourOnionEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          valueDesc: expStr,
          solve: solveKnowYourOnionClue,
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
        var clue = KnowYourOnionClue(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solveKnowYourOnionClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(
        name: 'I',
        valueDesc: r'$xyzxy A',
        addDesc: ['£productTwoThreeDigitPrimes(B,m)']);
    clueWrapper(
        name: 'II',
        valueDesc: r'$xyzxy C',
        addDesc: ['£productTwoThreeDigitPrimes(e\',Q)']);
    clueWrapper(
        name: 'III',
        valueDesc: r'$xyzxy G',
        addDesc: ['£productTwoThreeDigitPrimes(M,m)']);
    clueWrapper(
        name: 'IV',
        valueDesc: r'$xyzxy H',
        addDesc: ['£productTwoThreeDigitPrimes(a,q)']);
    clueWrapper(
        name: 'V',
        valueDesc: r'$xyzxy K',
        addDesc: ['£productTwoThreeDigitPrimes(h,h)']);
    clueWrapper(
        name: 'VI',
        valueDesc: r'$xyzxy P',
        addDesc: ['£productTwoThreeDigitPrimes(f,p)']);
    clueWrapper(
        name: 'VII',
        valueDesc: r'$xyzxy R',
        addDesc: ['£productTwoThreeDigitPrimes((D-n\'),N)']);
    clueWrapper(
        name: 'VIII',
        valueDesc: r'$xyzxy b',
        addDesc: ['£productTwoThreeDigitPrimes(c,F)']);
    clueWrapper(
        name: 'IX',
        valueDesc: r'$xyzxy g',
        addDesc: ['£productTwoThreeDigitPrimes(d,p)']);
    clueWrapper(
        name: 'X',
        valueDesc: r'$xyzxy k',
        addDesc: ['£productTwoThreeDigitPrimes(E,E)']);

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
      puzzle.addVariable(KnowYourOnionVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    puzzle.entries['k']!.answer = 929;
    puzzle.entries['f']!.answer = 251;
    puzzle.entries['H']!.answer = 519;
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
  bool solveKnowYourOnionClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as KnowYourOnionPuzzle;
    var clue = v as KnowYourOnionClue;
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
  bool updateClues(KnowYourOnionPuzzle thisPuzzle, Clue clue,
      Set<int> possibleValues, Set<Variable> updatedVariables,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(
        thisPuzzle, clue, possibleValues, updatedVariables,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue value order
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
      // }
    }
    return updated;
  }
}
