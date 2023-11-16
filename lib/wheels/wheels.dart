import '../crossnumber.dart';
import '../wheels/puzzle.dart';

import '../clue.dart';
import '../expression.dart';
import '../puzzle.dart';
import 'clue.dart';

class Wheels extends Crossnumber<WheelsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :  :2 |  |3 :4 |',
    '+::+--+::+--+--+::+',
    '|  |  |5 :  |  |  |',
    '+--+--+::+--+--+::+',
    '|  |6 :  |  |7 :  |',
    '+--+::+--+--+::+--+',
    '|8 :  |  |9 :  |  |',
    '+::+--+--+::+--+--+',
    '|  |  |10:  |  |11|',
    '+::+--+--+::+--+::+',
    '|12:  |  |13:  :  |',
    '+--+--+--+--+--+--+',
  ];

  Wheels() {
    puzzle = WheelsPuzzle.grid(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, Function? solve}) {
      try {
        var entry = WheelsEntry(
          name: name,
          length: length,
          valueDesc: valueDesc,
          solve: solve,
        );
        puzzle.addEntry(entry);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    var variableErrors = '';
    void variableWrapper(String name,
        {int min = 1, int? max, String valueDesc = '', Function? solve}) {
      try {
        var variable = WheelsVariable(
          name,
          min: min,
          max: max,
          valueDesc: valueDesc,
          solve: solve,
        );
        puzzle.addVariable(variable);
        return;
      } on ExpressionError catch (e) {
        variableErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(
        name: 'A1',
        length: 3,
        valueDesc: r"$square D1",
        solve: solveWheelsClue);
    clueWrapper(name: 'A3', length: 2, valueDesc: r"B", solve: solveWheelsClue);
    clueWrapper(name: 'A5', length: 2, valueDesc: r"T", solve: solveWheelsClue);
    clueWrapper(name: 'A6', length: 2, valueDesc: r"F", solve: solveWheelsClue);
    clueWrapper(
        name: 'A7', length: 2, valueDesc: r"$square b", solve: solveWheelsClue);
    clueWrapper(name: 'A8', length: 2, valueDesc: r"f", solve: solveWheelsClue);
    clueWrapper(
        name: 'A9', length: 2, valueDesc: r"$cube C", solve: solveWheelsClue);
    clueWrapper(
        name: 'A10', length: 2, valueDesc: r"e", solve: solveWheelsClue);
    clueWrapper(
        name: 'A12',
        length: 2,
        valueDesc: r"$factor A3",
        solve: solveWheelsClue);
    clueWrapper(
        name: 'A13',
        length: 3,
        valueDesc: r"$square D11",
        solve: solveWheelsClue);

    clueWrapper(name: 'D1', length: 2, valueDesc: r"A", solve: solveWheelsClue);
    clueWrapper(
        name: 'D2', length: 3, valueDesc: r"20 * Y", solve: solveWheelsClue);
    clueWrapper(
        name: 'D4',
        length: 3,
        valueDesc: r"$square A3",
        solve: solveWheelsClue);
    clueWrapper(
        name: 'D6',
        length: 2,
        valueDesc: r"$lessthan A3",
        solve: solveWheelsClue);
    clueWrapper(name: 'D7', length: 2, valueDesc: r"c", solve: solveWheelsClue);
    clueWrapper(
        name: 'D8',
        length: 3,
        valueDesc: r"$square A8",
        solve: solveWheelsClue);
    clueWrapper(
        name: 'D9', length: 3, valueDesc: r"$cube d", solve: solveWheelsClue);
    clueWrapper(
        name: 'D11', length: 2, valueDesc: r"D", solve: solveWheelsClue);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    variableWrapper("B",
        min: 1,
        max: 60,
        valueDesc: r"$lte (60-A+b)",
        solve: solveWheelsVariable);
    variableWrapper("T",
        min: 1,
        max: 240,
        valueDesc: "A+B+C+D = b+c+d+e",
        solve: solveWheelsVariable);
    variableWrapper("F",
        min: 1, max: 99, valueDesc: "", solve: solveWheelsVariable);
    variableWrapper("b",
        min: 1, max: 60, valueDesc: r"$lte (A)", solve: solveWheelsVariable);
    variableWrapper("f",
        min: 1, max: 99, valueDesc: r"$lt F", solve: solveWheelsVariable);
    variableWrapper("C",
        min: 1,
        max: 60,
        valueDesc: r"$lte (60-A+b-B+c)",
        solve: solveWheelsVariable);
    variableWrapper("e",
        min: 1,
        max: 60,
        valueDesc: "A+B+C+D-b-c-d",
        solve: solveWheelsVariable);
    variableWrapper("A",
        min: 1, max: 60, valueDesc: "", solve: solveWheelsVariable);
    variableWrapper("Y",
        min: 17, max: 50, valueDesc: "", solve: solveWheelsVariable);
    variableWrapper("c",
        min: 1,
        max: 60,
        valueDesc: r"$lte (A-b+B)",
        solve: solveWheelsVariable);
    variableWrapper("d",
        min: 1,
        max: 60,
        valueDesc: r"$lte (A-b+B-c+C)",
        solve: solveWheelsVariable);
    variableWrapper("D",
        min: 1,
        max: 60,
        valueDesc: r"$lte (60-A+b-B+c-C+d)",
        solve: solveWheelsVariable);

    if (variableErrors != '') {
      throw PuzzleException(variableErrors);
    }

    puzzle.addDigitIdentityFromGrid();

    var clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    var variableError = puzzle.checkVariableVariableReferences();
    if (variableError != '') throw PuzzleException(variableError);

    super.initCrossnumber();
  }

  // Validate possible clue value
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!clue.digitsMatch(value)) return false;
    // Check prior value (maybe set by another clue)
    if (clue.values != null && !clue.values!.contains(value)) return false;
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveWheelsClue(WheelsClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables) {
    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables, validClue);
    }
    return updated;
  }

  // Variable solver invokes generic expression evaluator
  bool solveWheelsVariable(WheelsVariable variable, Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables) {
    var updated = false;
    if (variable.valueDesc != '') {
      updated = puzzle.solveExpressionVariable(variable, variable.exp,
          possibleValue, possibleVariables, validVariable);
    } else {
      if (variable.values != null) possibleValue.addAll(variable.values!);
    }
    return updated;
  }
}
