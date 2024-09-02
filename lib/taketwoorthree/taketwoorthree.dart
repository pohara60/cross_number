library taketwoorthree;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the TakeTwoOrThree API.
class TakeTwoOrThree extends Crossnumber<TakeTwoOrThreePuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|a |Ab:c |Bd:  |Ce:f |',
    '+::+::+::+::+--+::+::+',
    '|D :  |  |E :g :  |  |',
    '+--+--+::+::+::+--+--+',
    '|F :  :  |  |G :  :  |',
    '+--+--+::+::+::+--+--+',
    '|h |Hk:  :  |  |Km:n |',
    '+::+::+--+::+::+::+::+',
    '|L :  |M :  |N :  |  |',
    '+--+--+--+--+--+--+--+',
  ];

  TakeTwoOrThree() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = TakeTwoOrThreePuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = TakeTwoOrThreeEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          solve: solveTakeTwoOrThreeClue,
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
        var clue = TakeTwoOrThreeClue(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solveTakeTwoOrThreeClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'I', valueDesc: r'(A - B)^2 + L^2 + (C + L - e)^2 = 1~g');
    clueWrapper(name: 'II', valueDesc: r'B^2 +  M^2 +  N^2 = H~3');
    clueWrapper(name: 'III', valueDesc: r'e^2 +  C^2 +  f^2 =  14~E');
    clueWrapper(name: 'IV', valueDesc: r'C^2 + (F - e)^2 +  m^2 = c~3');
    clueWrapper(name: 'V', valueDesc: r'b^2 +  D^2 +  a^2 = d');
    clueWrapper(
        name: 'VI', valueDesc: r'(L + b - a)^2 + (F - n)^2 + L^2 = F~51');
    clueWrapper(name: 'VII', valueDesc: r'n^2 +  m^2 +  K^2 = 2~k~63');
    clueWrapper(name: 'VIII', valueDesc: r'N^2 +  k^2 +  h^2 = 4~G    ');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    // Get Entry expressions from Clue expressions
    // Only needed when Clue expressions refer to Entries
    for (var clue in puzzle.clues.values) {
      for (var exp in clue.expressions) {
        // Rearrange expression for new subject
        // e.g. (A - B)^2 + L^2 + (C + L - e)^2 = 1~g
        var expText = exp.text;
        var re = RegExp((r'([^=]*)= ([0-9]*)~*([a-zA-Z])~*([0-9]*)$'));
        var match = re.firstMatch(expText);
        if (match != null) {
          var text = match.group(1);
          var prefix = match.group(2);
          var entryName = match.group(3);
          var suffix = match.group(4);
          if (text != null && entryName != null) {
            // Split text into three expressions separated by +
            var depth = 0;
            var term = "";
            var terms = <String>[];
            for (var i = 0; i < text.length; i++) {
              var ch = text[i];
              if (ch == '(') {
                depth++;
                term += ch;
              } else if (ch == ')') {
                depth--;
                term += ch;
              } else if (ch == '+' && depth == 0) {
                terms.add(term.trim());
                term = "";
              } else {
                term += ch;
              }
            }
            if (term != '') terms.add(term.trim());
            assert(terms.length == 3);
            // Remove prefix and suffix
            var entryText =
                '£remove(${terms[0]},${terms[1]},${terms[2]},"$prefix","$suffix")';
            puzzle.entries[entryName]!
                .addExpression(entryText, entryNames: entryNames);
          }
        }
      }
    }

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(TakeTwoOrThreeVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    solveClueNoException(puzzle.entries['F']!);
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
  bool solveTakeTwoOrThreeClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as TakeTwoOrThreePuzzle;
    var clue = v as TakeTwoOrThreeClue;
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
  bool updateClues(TakeTwoOrThreePuzzle thisPuzzle, Clue clue,
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
    return updated;
  }
}
