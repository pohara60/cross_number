library knights;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Knights API.
class Knights extends Crossnumber<KnightsPuzzle> {
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

  Knights() {
    puzzle = KnightsPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var entry = KnightsEntry(
            name: name!,
            length: length,
            valueDesc: valueDesc,
            solve: solveKnightsClue);
        puzzle.addEntry(entry);
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
        name: 'A14', length: 2, valueDesc: r'$prime $reverse #Fibonacci');
    clueWrapper(
        name: 'A16', length: 2, valueDesc: r'$prime $reverse #Fibonacci');
    clueWrapper(name: 'A18', length: 3, valueDesc: r'$multiple A21');
    clueWrapper(name: 'A20', length: 4, valueDesc: r'');
    clueWrapper(name: 'A21', length: 2, valueDesc: r'$prime $reverse A14');
    clueWrapper(name: 'D1', length: 3, valueDesc: r'#triangular');
    clueWrapper(name: 'D2', length: 4, valueDesc: r'$multiple D3');
    clueWrapper(name: 'D3', length: 3, valueDesc: r'$multiple D13');
    clueWrapper(name: 'D5', length: 4, valueDesc: r'$multiple A14');
    clueWrapper(name: 'D6', length: 3, valueDesc: r'');
    clueWrapper(name: 'D8', length: 2, valueDesc: r'#Fibonacci');
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
      puzzle.letters[letter] = KnightsVariable(letter);
    }

    var clueError = puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
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
  bool solveKnightsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as KnightsPuzzle;
    var clue = v as KnightsClue;

    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables!, validClue);
    } else {
      // Values may have been set by other Clue
      var values = clue.values;
      if (values == null) {
        values = getValuesFromClueDigits(clue);
      }
      if (values != null) {
        var newValues = values.where((value) => validClue(clue, value, [], []));
        possibleValue.addAll(newValues);
      }
    }
    return updated;
  }
}
