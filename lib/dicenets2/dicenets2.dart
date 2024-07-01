import '../expression.dart';
import '../crossnumber.dart';
import '../dicenets2/clue.dart';
import '../dicenets2/puzzle.dart';

import '../clue.dart';
import '../puzzle.dart';
import '../variable.dart';

class DiceNets2 extends Crossnumber<DiceNetsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|1 :2 :3 :  |4 :5 :6 :7 |',
    '+::+::+::+--+--+::+::+::+',
    '|  |  |8 :9 :  :  |  |  |',
    '+::+::+--+::+--+::+::+--+',
    '|10:  :11|12:13:  |14:15|',
    '+::+::+::+::+::+::+::+::+',
    '|16:  :  |  |17:  :  :  |',
    '+--+::+::+::+::+::+--+::+',
    '|18:  :  :  :  |19:20|  |',
    '+::+::+--+::+::+--+::+::+',
    '|  |21:22|23:  :24:  :  |',
    '+::+--+::+::+::+::+::+--+',
    '|25:26:  :  |  |27:  :28|',
    '+::+::+::+::+::+::+::+::+',
    '|29:  |30:  :  |31:  :  |',
    '+--+::+::+--+::+--+::+::+',
    '|32|  |33:  :  :34|  |  |',
    '+::+::+::+--+--+::+::+::+',
    '|35:  :  :  |36:  :  :  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  DiceNets2() {
    puzzle = DiceNetsPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, SolveFunction? solve}) {
      try {
        var clue = DiceNetsEntry(
            name: name!, length: length, valueDesc: valueDesc, solve: solve);
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(
        name: 'A1', length: 4, valueDesc: '#Prime', solve: solveDiceNets);
    clueWrapper(
        name: 'A4', length: 4, valueDesc: '#Power3', solve: solveDiceNets);
    clueWrapper(
        name: 'A8',
        length: 4,
        valueDesc: '#Triangular - A18',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A10',
        length: 3,
        valueDesc: r'$Multiple D34',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A12',
        length: 3,
        valueDesc: r'$Even #Square',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A14', length: 2, valueDesc: '#Triangular', solve: solveDiceNets);
    clueWrapper(
        name: 'A16',
        length: 3,
        valueDesc: '#Triangular - A31',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A17',
        length: 4,
        valueDesc: r'$Multiple D7',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A18', length: 5, valueDesc: '#Triangular', solve: solveDiceNets);
    clueWrapper(
        name: 'A19',
        length: 2,
        valueDesc: '#Triangular - A29',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A21', length: 2, valueDesc: '#Power3', solve: solveDiceNets);
    clueWrapper(
        name: 'A23',
        length: 5,
        valueDesc: r'$Multiple D32',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A25', length: 4, valueDesc: '#Prime', solve: solveDiceNets);
    clueWrapper(
        name: 'A27',
        length: 3,
        valueDesc: '#Square - A16',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A29',
        length: 2,
        valueDesc: r'$Multiple #Power3',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A30',
        length: 3,
        valueDesc: '#Square + D24',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A31',
        length: 3,
        valueDesc: '#Square - A16',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A33',
        length: 4,
        valueDesc: r'$Multiple A30',
        solve: solveDiceNets);
    clueWrapper(
        name: 'A35', length: 4, valueDesc: '#Triangular', solve: solveDiceNets);
    clueWrapper(
        name: 'A36', length: 4, valueDesc: r'$Jumble D1', solve: solveDiceNets);

    clueWrapper(
        name: 'D1', length: 4, valueDesc: '#Square', solve: solveDiceNets);
    clueWrapper(
        name: 'D2', length: 6, valueDesc: '#Square', solve: solveDiceNets);
    clueWrapper(
        name: 'D3',
        length: 2,
        valueDesc: r'#product3primes',
        solve: solveDiceNets);
    clueWrapper(
        name: 'D5',
        length: 5,
        valueDesc: r'#product3primes',
        solve: solveDiceNets);
    clueWrapper(
        name: 'D6', length: 4, valueDesc: 'D7 + D18', solve: solveDiceNets);
    clueWrapper(
        name: 'D7', length: 2, valueDesc: '#Power3', solve: solveDiceNets);
    clueWrapper(
        name: 'D9', length: 7, valueDesc: '#Triangular', solve: solveDiceNets);
    clueWrapper(
        name: 'D11', length: 3, valueDesc: '2 * #Square', solve: solveDiceNets);
    clueWrapper(
        name: 'D13', length: 7, valueDesc: '#Square', solve: solveDiceNets);
    clueWrapper(
        name: 'D15', length: 4, valueDesc: '#Square', solve: solveDiceNets);
    clueWrapper(
        name: 'D18', length: 4, valueDesc: '#Power3', solve: solveDiceNets);
    clueWrapper(
        name: 'D20', length: 6, valueDesc: '#Square', solve: solveDiceNets);
    clueWrapper(
        name: 'D22',
        length: 5,
        valueDesc: r'$Multiple $Square D32',
        solve: solveDiceNets);
    clueWrapper(
        name: 'D24',
        length: 3,
        valueDesc: '#sumConsecutiveSquares',
        solve: solveDiceNets);
    clueWrapper(
        name: 'D26',
        length: 4,
        valueDesc: '#Triangular / 2',
        solve: solveDiceNets);
    clueWrapper(
        name: 'D28', length: 4, valueDesc: '#Square', solve: solveDiceNets);
    clueWrapper(
        name: 'D32', length: 2, valueDesc: 'A19 - D7', solve: solveDiceNets);
    clueWrapper(
        name: 'D34', length: 2, valueDesc: '#Prime', solve: solveDiceNets);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.linkEntriesToGrid();

    puzzle.finalize();

    super.initCrossnumber();
  }

  // Validate possible clue value
  bool validDiceDigits(VariableClue clue, int value,
      List<String> variableReferences, List<int> variableValues) {
    if (value.toString().contains(RegExp(r'[7890]'))) return false;
    if (!clue.digitsMatch(value)) return false;
    return true;
  }

  // Clue colver invokes generic expression evaluator with validator
  bool solveDiceNets(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as DiceNetsPuzzle;
    var clue = v as DiceNetsClue;

    puzzle.solveExpressionEvaluator(
        clue, clue.exp, possibleValue, possibleVariables!, validDiceDigits);
    return false;
  }
}
