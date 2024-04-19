library undersix;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the UnderSix API.
class UnderSix extends Crossnumber<UnderSixPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|Aa:b :  |B :c :d |',
    '+::+::+--+--+::+::+',
    '|  |  |e |f |  |  |',
    '+::+::+::+::+::+::+',
    '|C :  :  :  :  :  |',
    '+--+--+::+::+--+--+',
    '|Dg:  :  :  :  :h |',
    '+::+--+::+::+--+::+',
    '|E :  :  |F :  :  |',
    '+::+--+::+::+--+::+',
    '|G :  :  :  :  :  |',
    '+--+--+--+--+--+--+',
  ];

  UnderSix() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = UnderSixPuzzle.fromGridString(gridString);
    this.puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    var entryNames = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h'
    ];
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = UnderSixEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveUnderSixClue,
          entryNames: entryNames,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A', length: 3, valueDesc: r'');
    clueWrapper(name: 'B', length: 3, valueDesc: r'');
    clueWrapper(name: 'C', length: 6, valueDesc: r'B( F + a - g )');
    clueWrapper(name: 'D', length: 6, valueDesc: r'ab');
    clueWrapper(name: 'E', length: 3, valueDesc: r'');
    clueWrapper(name: 'F', length: 3, valueDesc: r'');
    clueWrapper(name: 'G', length: 6, valueDesc: r"Ec'");
    clueWrapper(name: 'a', length: 3, valueDesc: r'');
    clueWrapper(name: 'b', length: 3, valueDesc: r'');
    clueWrapper(name: 'c', length: 3, valueDesc: r'');
    clueWrapper(name: 'd', length: 3, valueDesc: r'');
    clueWrapper(name: 'e', length: 5, valueDesc: r'Ac');
    clueWrapper(name: 'f', length: 5, valueDesc: r'F(d - h)');
    clueWrapper(name: 'g', length: 3, valueDesc: r'');
    clueWrapper(name: 'h', length: 3, valueDesc: r'');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.letters[letter] = UnderSixVariable(letter);
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

    super.solve(iteration);
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues))
      return false;
    return true;
  }

  num? underSixCallback(num? left, num? right, num? result, Node node) {
    // top level node is multiplication of two 3 digit numbers, comprising the six
    // digits under six. Result has digits under six.
    if (node.depth == 0) {
      assert(left != null && right != null && node.token.type == TIMES);
      var lStr = left.toString();
      var rStr = right.toString();
      if (lStr.length != 3 || rStr.length != 3) return null;
      if (!lessSix(lStr) || !lessSix(rStr)) return null;
      if (commonChar(lStr, rStr)) return null;
      var resStr = result.toString();
      if (!lessSix(resStr)) return null;
    }
    return result;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveUnderSixClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as UnderSixPuzzle;
    var clue = v as UnderSixClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        updated = puzzle.solveExpressionEvaluator(clue, clue.exp, possibleValue,
            possibleVariables!, validClue, underSixCallback);
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
              underSixCallback,
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
      UnderSixPuzzle puzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(puzzle, clueName, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue value order
      // var clue = puzzle.clues[clueName]!;
      // var newMin = clue.values!.reduce(min);
      // if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      // var newMax = clue.values!.reduce(max);
      // if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // // Clues are defined in ascending order of value
      // for (var otherClue in puzzle.clues.values) {
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
    }
    return updated;
  }

  bool lessSix(String str) {
    for (var i = 0; i < str.length; i++) {
      if (!"012345".contains(str[i])) return false;
    }
    return true;
  }

  bool commonChar(String lStr, String rStr) {
    var allChars = '';
    for (var i = 0; i < lStr.length; i++) {
      if (allChars.contains(lStr[i])) return true;
      allChars += lStr[i];
    }
    for (var i = 0; i < rStr.length; i++) {
      if (allChars.contains(rStr[i])) return true;
      allChars += rStr[i];
    }
    return false;
  }
}
