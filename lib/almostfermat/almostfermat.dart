library almostfermat;

import '../cartesian.dart';
import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the AlmostFermat API.
class AlmostFermat extends Crossnumber<AlmostFermatPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|a |b |A :c :  |',
    '+::+::+--+::+--+',
    '|B :  |Cd:  :  |',
    '+::+::+::+--+--+',
    '|  |D :  :e |f |',
    '+--+--+::+::+::+',
    '|E :g :  |F :  |',
    '+--+::+--+::+::+',
    '|G :  :  |  |  |',
    '+--+--+--+--+--+',
  ];

  AlmostFermat() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = AlmostFermatPuzzle.grid(gridString);
    this.puzzles.add(puzzle);

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = AlmostFermatEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          solve: solveAlmostFermatClue,
        );
        puzzle.addEntry(entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += e.msg + '\n';
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
        //var clue = AlmostFermatEntry(
        var clue = AlmostFermatClue(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            addDesc: addDesc,
            solve: solveAlmostFermatClue,
            entryNames: entryNames);
        //puzzle.addEntry(clue);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'I', valueDesc: r'4B', addDesc: ['f', 'D']);
    clueWrapper(name: 'II', valueDesc: r'2C', addDesc: ['E', '8A']);
    clueWrapper(name: 'III', valueDesc: r'10F', addDesc: ['(b-A)^2/2', 'g^2']);
    clueWrapper(name: 'IV', valueDesc: r'f-4F', addDesc: ['b', 'G']);
    clueWrapper(name: 'V', valueDesc: r'f-4F', addDesc: ['f/6', '2F']);
    clueWrapper(name: 'VI', valueDesc: r'a', addDesc: ['4d', '2D']);
    clueWrapper(name: 'VII', valueDesc: r'cg', addDesc: ['f', 'e']);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    // Not needed when create entries from grid
    // puzzle.validateEntriesFromGrid();

    puzzle.addDigitIdentityFromGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.letters[letter] = AlmostFermatVariable(letter);
    }

    // Get Entry expressions from Clue expressions
    // Only needed when Clue expressions refer to Entries
    for (var clue in puzzle.clues.values) {
      for (var exp in clue.expressions) {
        for (var entryName in clue.entryReferences) {
          // Rearrange expression for new subject
          var expText = exp.rearrangeExpressionText(entryName, clue.name);
          if (expText != null) {
            puzzle.entries[entryName]!
                .addExpression(expText, entryNames: entryNames);
          }
        }
      }
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  @override
  void solve([bool iteration = true]) {
    super.solve(iteration);
  }

  // Validate possible clue value
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (value < 0) return false;
    if (clue.min != null && value < clue.min!) return false;
    if (clue.max != null && value > clue.max!) return false;
    if (clue.values != null && !clue.values!.contains(value)) return false;
    if (!clue.digitsMatch(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveAlmostFermatClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as AlmostFermatPuzzle;
    var clue = v as AlmostFermatClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        updated = puzzle.solveExpressionEvaluator(
            clue, clue.exp, possibleValue, possibleVariables!, validClue);
      } else {
        var first = true;
        String? exceptionMessage;
        var cluesPossibleValues = <List<int>>[];
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
            if (clue is AlmostFermatEntry) {
              // Entry values must agree
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
            } else {
              // Clue values give x/y/z
              cluesPossibleValues
                  .add(List.from(first ? possibleValue : possibleValueExp));
              first = false;
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
        // Check combinations of clue values
        if (cluesPossibleValues.isNotEmpty) {
          assert(cluesPossibleValues.length == 3);
          possibleValue.clear();
          var count = cartesianCount(cluesPossibleValues);
          if (count > 100000000) {
            for (var cluePossibleValues in cluesPossibleValues)
              possibleValue.addAll(cluePossibleValues);
          } else {
            for (var product in cartesian(cluesPossibleValues, true)) {
              var x = product[0];
              var y = product[1];
              var z = product[2];
              if (x * x * x + y * y * y + 1 == z * z * z) {
                // values must be 3 digits except for one x, y, z across clues
                // OK combination of values
                possibleValue.add(x);
                possibleValue.add(y);
                possibleValue.add(z);
              }
            }
          }
          ;
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
      AlmostFermatPuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry, focusClueName: focusClueName);
    return updated;
  }
}
