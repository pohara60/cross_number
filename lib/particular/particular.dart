/// An API for solving Letters puzzles.
library particular;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../particular/clue.dart';
import '../particular/puzzle.dart';
import '../puzzle.dart';
import '../variable.dart';

/// Provide access to the Prime Cuts API.
class Particular extends Crossnumber<ParticularPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+--+',
    '|1 |2 |3 |4 :5 :6 |7 :8 :  |',
    '+::+::+::+--+::+::+::+::+--|',
    '|9 :  :  :10:  :  :  :  :11|',
    '+::+::+::+::+--+::+::+::+::|',
    '|12:  :  |13:  |  |  |14:  |',
    '+--+::+--+::+--+::+::+--+::|',
    '|15|  |16:  :17:  :  |18:  |',
    '+::+--+::+::+::+--+::+::+--|',
    '|19:20:  |  |  |21|22:  :23|',
    '+--+::+::+--+::+::+::+--+::|',
    '|24:  |25:26:  :  :  |27|  |',
    '+::+--+::+::+--+::+--+::+--|',
    '|28:29|  |  |30:  |31:  :32|',
    '+::+::+::+::+--+::+::+::+::|',
    '|33:  :  :  :34:  :  :  :  |',
    '+--+::+::+::+::+--+::+::+::|',
    '|35:  :  |36:  :  |  |  |  |',
    '+--+--+--+--+--+--+--+--+--+',
  ];

  Particular() {
    puzzle = ParticularPuzzle.grid(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, SolveFunction? solve}) {
      try {
        var entry = ParticularEntry(
            name: name!, length: length, valueDesc: valueDesc, solve: solve);
        puzzle.addEntry(entry);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(
        name: 'A4',
        length: 3,
        valueDesc: r"PI - CK",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A7', length: 3, valueDesc: r"BOW/S", solve: solveParticularClue);
    clueWrapper(
        name: 'A9',
        length: 9,
        valueDesc: r"FISSION",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A12',
        length: 3,
        valueDesc: r"NO + W",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A13', length: 2, valueDesc: r"SH", solve: solveParticularClue);
    clueWrapper(
        name: 'A14',
        length: 2,
        valueDesc: r"I - F",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A16',
        length: 5,
        valueDesc: r"CHIPS",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A18',
        length: 2,
        valueDesc: r"HI + P",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A19', length: 3, valueDesc: r"IN", solve: solveParticularClue);
    clueWrapper(
        name: 'A22', length: 3, valueDesc: r"IS", solve: solveParticularClue);
    clueWrapper(
        name: 'A24',
        length: 2,
        valueDesc: r"I + F",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A25',
        length: 5,
        valueDesc: r"PUNCH",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A28',
        length: 2,
        valueDesc: r"HOO - P",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A30',
        length: 2,
        valueDesc: r"SH + Y",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A31',
        length: 3,
        valueDesc: r"H + OBO",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A33',
        length: 9,
        valueDesc: r"COUSINS",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A35',
        length: 3,
        valueDesc: r"COW/S",
        solve: solveParticularClue);
    clueWrapper(
        name: 'A36',
        length: 3,
        valueDesc: r"I + VY",
        solve: solveParticularClue);

    clueWrapper(
        name: 'D1',
        length: 3,
        valueDesc: r"IO + N",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D2', length: 4, valueDesc: r"FISH", solve: solveParticularClue);
    clueWrapper(
        name: 'D3', length: 3, valueDesc: r"CHOP", solve: solveParticularClue);
    clueWrapper(
        name: 'D5',
        length: 2,
        valueDesc: r"WH + O",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D6', length: 4, valueDesc: r"COY", solve: solveParticularClue);
    clueWrapper(
        name: 'D7', length: 6, valueDesc: r"SWOP", solve: solveParticularClue);
    clueWrapper(
        name: 'D8',
        length: 3,
        valueDesc: r"K + IP",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D10',
        length: 4,
        valueDesc: r"BOOK - SHOP",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D11', length: 3, valueDesc: r"OFF", solve: solveParticularClue);
    clueWrapper(
        name: 'D15', length: 2, valueDesc: r"I", solve: solveParticularClue);
    clueWrapper(
        name: 'D16',
        length: 6,
        valueDesc: r"SCUFF",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D17',
        length: 3,
        valueDesc: r"BU - FF",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D18', length: 2, valueDesc: r"OOH", solve: solveParticularClue);
    clueWrapper(
        name: 'D20', length: 2, valueDesc: r"OF", solve: solveParticularClue);
    clueWrapper(
        name: 'D21',
        length: 4,
        valueDesc: r"PUN - CH",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D23',
        length: 2,
        valueDesc: r"OF + F",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D24', length: 3, valueDesc: r"HUN", solve: solveParticularClue);
    clueWrapper(
        name: 'D26', length: 4, valueDesc: r"INK", solve: solveParticularClue);
    clueWrapper(
        name: 'D27', length: 4, valueDesc: r"HOOK", solve: solveParticularClue);
    clueWrapper(
        name: 'D29', length: 3, valueDesc: r"HOCK", solve: solveParticularClue);
    clueWrapper(
        name: 'D31',
        length: 3,
        valueDesc: r"HOO + PS",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D32',
        length: 3,
        valueDesc: r"HO + OK",
        solve: solveParticularClue);
    clueWrapper(
        name: 'D34',
        length: 2,
        valueDesc: r"O + N",
        solve: solveParticularClue);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.addDigitIdentityFromGrid();

    // Add letter references from descriptions
    var letters = [
      'B',
      'C',
      'F',
      'H',
      'I',
      'K',
      'N',
      'O',
      'P',
      'S',
      'U',
      'V',
      'W',
      'Y',
    ];
    for (var letter in letters) {
      puzzle.letters[letter] = ParticularVariable(letter);
    }

    var clueError = '';
    //clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    // clueError += puzzle.checkEntryClueReferences();
    // clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as prceeding may update them
    clueError += puzzle.checkVariableReferences();
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
  bool solveParticularClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as ParticularPuzzle;
    var clue = v as ParticularClue;
    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables!, validClue);
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
  void solve([bool iteration = true]) {
    super.solve(false);

    // Published solution!
    // A9 = FISSION
    // A16 = CHIPS
    puzzle.updateVariables('B', {5});
    puzzle.updateVariables('C', {6});
    puzzle.updateVariables('F', {9});
    puzzle.updateVariables('H', {1});
    puzzle.updateVariables('I', {53});
    puzzle.updateVariables('K', {19});
    puzzle.updateVariables('N', {7});
    puzzle.updateVariables('O', {8});
    puzzle.updateVariables('P', {15});
    puzzle.updateVariables('S', {16});
    puzzle.updateVariables('U', {92});
    puzzle.updateVariables('V', {23});
    puzzle.updateVariables('W', {74});
    puzzle.updateVariables('Y', {39});

    super.solve(false);
  }
}
