library decisions;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../monadic.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Decisions API.
class Decisions extends Crossnumber<DecisionsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 :  |3 :4 |5 |',
    '+::+::+--+::+::+::+',
    '|6 :  :7 :  |8 :  |',
    '+::+--+::+::+::+::+',
    '|9 :10:  |11:  :  |',
    '+--+::+--+--+::+--+',
    '|12:  :13|14:  :15|',
    '+::+::+::+::+--+::+',
    '|16:  |17:  :18:  |',
    '+::+::+::+--+::+::+',
    '|  |19:  |20:  :  |',
    '+--+--+--+--+--+--+',
  ];

  Decisions() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = DecisionsPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Select the appropriate branch in the test below
    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = DecisionsEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveDecisionsClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A3', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A6', length: 4, valueDesc: r'#Fibonacci');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'#Catalan');
    clueWrapper(name: 'A9', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A11', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'A14', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A16', length: 2, valueDesc: r'#cube');
    clueWrapper(name: 'A17', length: 4, valueDesc: r'#cube');
    clueWrapper(name: 'A19', length: 2, valueDesc: r'#perfect');
    clueWrapper(name: 'A20', length: 3, valueDesc: r'#palindrome');
    clueWrapper(name: 'D1', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D2', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'D3', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D4', length: 4, valueDesc: r'#perfect');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D7', length: 2, valueDesc: r'#cube');
    clueWrapper(name: 'D10', length: 4, valueDesc: r'#Lucas');
    clueWrapper(name: 'D12', length: 3, valueDesc: r'#Lucas');
    clueWrapper(name: 'D13', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'D14', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'D15', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D18', length: 2, valueDesc: r'#square');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addVariable(DecisionsVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  void setAnswer(String clueName, int value) {
    puzzle.clues[clueName]!.answer = value;
  }

  void initAnswer() {
    // Initialize the answers for the puzzle
    setAnswer('A1', 484);
    setAnswer('A3', 38);
    setAnswer('A6', 6765);
    setAnswer('A8', 24);
    setAnswer('A9', 754);
    setAnswer('A11', 211);
    setAnswer('A12', 276);
    setAnswer('A14', 982);
    setAnswer('A16', 27);
    setAnswer('A17', 5733);
    setAnswer('A19', 82);
    setAnswer('A20', 161);
    setAnswer('D1', 467);
    setAnswer('D2', 87);
    setAnswer('D3', 352);
    setAnswer('D4', 8218);
    setAnswer('D5', 441);
    setAnswer('D7', 64);
    setAnswer('D10', 5778);
    setAnswer('D12', 223);
    setAnswer('D13', 652);
    setAnswer('D14', 97);
    setAnswer('D15', 231);
    setAnswer('D18', 36);
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    //initAnswer();
    super.solve(iteration);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    // Valid if value or reverse value is valid
    if (super.validClue(clue, value, variableReferences, variableValues)) {
      return true;
    }
    var reversedValue = reverse(value);
    if (super
        .validClue(clue, reversedValue, variableReferences, variableValues)) {
      return true;
    }
    return false;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveDecisionsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as DecisionsPuzzle;
    var clue = v as DecisionsClue;
    var updated = false;
    updated = puzzle.solveExpressionEvaluator(
        clue, clue.exp, possibleValue, possibleVariables!, validClue);

    // In each row and column, one answer is entered normally whilst the other
    // is entered in reverse.
    var newPossibleValue = <int>[];
    for (var value in possibleValue) {
      // Add reverse of value to possibleValue
      var reversedValue = reverse(value);
      if (reversedValue >= clue.min! &&
          reversedValue <= clue.max! &&
          reversedValue != value) {
        newPossibleValue.add(reversedValue);
        updated = true;
      }
    }
    clue.possibleValue = Set.from(possibleValue);
    clue.reversedValue = Set.from(newPossibleValue);
    possibleValue.addAll(newPossibleValue);
    return updated;
  }
}
