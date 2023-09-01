import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/partners/puzzle.dart';

import '../clue.dart';
import '../expression.dart';
import '../generators.dart';
import '../puzzle.dart';
import 'clue.dart';

class Partners extends Crossnumber<PartnersPuzzle> {
  var gridString = [
    '+--+--+--+--+',
    '|1 |2 :3 :  |',
    '+::+::+::+--+',
    '|4 :  |5 :6 |',
    '+::+--+--+::+',
    '|7 :8 |9 :  |',
    '+--+::+::+::+',
    '|10:  :  |  |',
    '+--+--+--+--+',
  ];

  Partners() {
    puzzle = PartnersPuzzle.grid(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var clueErrors = '';
    void clueWrapper(
        {String? name,
        required String symmetricName,
        int? length,
        String? valueDesc,
        Function? solve}) {
      try {
        var entry = PartnersEntry(
            name: name,
            length: length,
            valueDesc: valueDesc,
            solve: solve,
            symmetricName: symmetricName);
        puzzle.addEntry(entry);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(
        name: 'A2',
        symmetricName: 'A10',
        length: 3,
        valueDesc: r"$reverse A10",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'A4',
        symmetricName: 'A9',
        length: 2,
        valueDesc: r"#sumdigits - A7",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'A5',
        symmetricName: 'A7',
        length: 2,
        valueDesc: r"$greaterthan A9",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'A7',
        symmetricName: 'A5',
        length: 2,
        valueDesc: "#integer",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'A9',
        symmetricName: 'A4',
        length: 2,
        valueDesc: r"$lessthan A5",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'A10',
        symmetricName: 'A2',
        length: 3,
        valueDesc: r"$odd $reverse A2",
        solve: solvePartnersClue);

    clueWrapper(
        name: 'D1',
        symmetricName: 'D6',
        length: 3,
        valueDesc: r"#square",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'D2',
        symmetricName: 'D9',
        length: 2,
        valueDesc: r"#square",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'D3',
        symmetricName: 'D8',
        length: 2,
        valueDesc: r"#square",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'D6',
        symmetricName: 'D1',
        length: 3,
        valueDesc: r"#square",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'D8',
        symmetricName: 'D3',
        length: 2,
        valueDesc: r"#square",
        solve: solvePartnersClue);
    clueWrapper(
        name: 'D9',
        symmetricName: 'D2',
        length: 2,
        valueDesc: r"#square",
        solve: solvePartnersClue);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }
    for (var clue in puzzle.clues.values) {
      var otherClue = puzzle.clues[clue.symmetricName]!;
      otherClue.addReferrer(clue);
    }

    puzzle.addDigitIdentityFromGrid();

    var clueError = puzzle.checkClueReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  // Validate possible clue value
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!clue.digitsMatch(value)) return false;

    var otherName = (clue as PartnersClue).symmetricName;
    var index = variableReferences.indexOf(otherName);
    if (index > -1) {
      // Have definite other clue value
      var otherValue = variableValues[index];
      return isPrime(value + otherValue);
    }

    // Check all other clue values
    var otherClue = puzzle.clues[otherName]!;
    if (otherClue.values != null) {
      var result =
          otherClue.values!.any((otherValue) => isPrime(value + otherValue));
      return result;
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solvePartnersClue(PartnersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables) {
    var updated = false;
    if (clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, possibleValue, possibleVariables, validClue);
    }
    return updated;
  }
}
