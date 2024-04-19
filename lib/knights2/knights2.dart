library knights2;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Knights2 API.
class Knights2 extends Crossnumber<Knights2Puzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 |3 |4 :5 :6 |',
    '+::+::+::+--+::+::+',
    '|  |7 :  |8 :  :  |',
    '+::+::+::+::+::+::+',
    '|9 :  :  |10:  |  |',
    '+--+::+--+--+::+--+',
    '|11:  :12:13|14:15|',
    '+::+--+::+::+--+::+',
    '|16:17|  |18:19:  |',
    '+::+::+::+--+::+::+',
    '|20:  :  :  |21:  |',
    '+--+--+--+--+--+--+',
  ];

  Knights2() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = Knights2Puzzle.fromGridString(gridString);
    this.puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = Knights2Entry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveKnights2Clue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A4', length: 3, valueDesc: r'');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'$multiple A14');
    clueWrapper(name: 'A8', length: 3, valueDesc: r'');
    clueWrapper(name: 'A9', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'A10', length: 2, valueDesc: r'$divisor A18');
    clueWrapper(name: 'A11', length: 4, valueDesc: r'$multiple D8');
    clueWrapper(
        name: 'A14', length: 2, valueDesc: r'$prime $reverse #fibonacci');
    clueWrapper(
        name: 'A16', length: 2, valueDesc: r'$prime $reverse #fibonacci');
    clueWrapper(name: 'A18', length: 3, valueDesc: r'$multiple A21');
    clueWrapper(name: 'A20', length: 4, valueDesc: r'');
    clueWrapper(name: 'A21', length: 2, valueDesc: r'$prime $reverse A14');
    clueWrapper(name: 'D1', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D2', length: 4, valueDesc: r'$multiple D3');
    clueWrapper(name: 'D3', length: 3, valueDesc: r'$multiple D13');
    clueWrapper(name: 'D5', length: 4, valueDesc: r'$multiple A14');
    clueWrapper(name: 'D6', length: 3, valueDesc: r'');
    clueWrapper(name: 'D8', length: 2, valueDesc: r'#fibonacci');
    clueWrapper(name: 'D11', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D12', length: 3, valueDesc: r'');
    clueWrapper(name: 'D13', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'D15', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D17', length: 2, valueDesc: r'#square');
    clueWrapper(name: 'D19', length: 2, valueDesc: r'#prime');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.letters[letter] = Knights2Variable(letter);
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
    // Initialise clue values
    // var numClues = puzzle.clues.length;
    // var products = getProduct3Primes();
    // for (var clue in puzzle.clues.values) {
    //   var clueIndex = romanToDecimal(clue.name);
    //   clue.values = Set.from(products.whereIndexed((index, element) =>
    //       index >= clueIndex - 1 &&
    //       index <= clueIndex + products.length - numClues - 1));
    //   clue.min = clue.values!.first;
    //   clue.max = clue.values!.last;
    //   if (Crossnumber.traceSolve) {
    //     print(
    //         'solve: ${clue.runtimeType} ${clue.name} values=${clue.values!.toShortString()}');
    //   }

    super.solve(false);

    // Manual Knights move solution
    puzzle.clues['A1']!.values = {23};
    puzzle.clues['A4']!.values = {542};
    puzzle.clues['A8']!.values = {315};
    puzzle.clues['A10']!.values = {42};
    puzzle.clues['A11']!.values = {6562};
    puzzle.clues['A20']!.values = {1646};
    puzzle.clues['D1']!.values = {253};
    puzzle.clues['D2']!.values = {3625};
    puzzle.clues['D5']!.values = {4123};
    puzzle.clues['D6']!.values = {254};
    puzzle.clues['D8']!.values = {34};
    puzzle.clues['D11']!.values = {641};
    puzzle.clues['D12']!.values = {614};

    super.solve(false);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveKnights2Clue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as Knights2Puzzle;
    var clue = v as Knights2Clue;
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
      Knights2Puzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry, focusClueName: focusClueName);
    return updated;
  }
}
