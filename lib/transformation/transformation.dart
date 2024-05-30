library transformation;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Transformation API.
class Transformation extends Crossnumber<TransformationPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|1 :2 :3 :4 :5 |6 |7 :8 |',
    '+--+::+::+::+::+::+::+::+',
    '|9 :  :  :  |10:  :  :  |',
    '+::+::+::+--+::+::+::+::+',
    '|11:  :  |12:  :  :  |  |',
    '+::+--+::+::+::+::+::+::+',
    '|  |13:  :  :  |14:  :  |',
    '+::+::+--+::+::+--+::+::+',
    '|15:  :16|17:  :18:  |  |',
    '+::+::+::+::+::+::+--+::+',
    '|  |19:  :  :  |20:21:  |',
    '+::+::+::+::+--+::+::+::+',
    '|22:  :  :  |23:  :  :  |',
    '+::+::+::+::+::+::+::+--+',
    '|24:  |  |25:  :  :  :  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  Transformation() {
    initCrossnumber();
  }

  void initCrossnumber() {
    var puzzle = TransformationPuzzle.fromGridString(gridString);
    this.puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = TransformationEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveTransformationClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 5, valueDesc: r'T+T+W+y');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'b+b');
    clueWrapper(name: 'A9', length: 4, valueDesc: r'I+N');
    clueWrapper(name: 'A10', length: 4, valueDesc: r'E+S+T+T');
    clueWrapper(name: 'A11', length: 3, valueDesc: r'D-o-o-Y');
    clueWrapper(name: 'A12', length: 4, valueDesc: r'i+J-E-E');
    clueWrapper(name: 'A13', length: 4, valueDesc: r'i+s+s-N');
    clueWrapper(name: 'A14', length: 3, valueDesc: r'd-e-e-P');
    clueWrapper(name: 'A15', length: 3, valueDesc: r'b+U+U+Y');
    clueWrapper(name: 'A17', length: 4, valueDesc: r'B-l-l-s');
    clueWrapper(name: 'A19', length: 4, valueDesc: r'H-E-l');
    clueWrapper(name: 'A20', length: 3, valueDesc: r'S-U');
    clueWrapper(name: 'A22', length: 4, valueDesc: r'U+U+y-E');
    clueWrapper(name: 'A23', length: 4, valueDesc: r'A-G-G');
    clueWrapper(name: 'A24', length: 2, valueDesc: r'b+J');
    clueWrapper(name: 'A25', length: 5, valueDesc: r'D-S-Y');

    clueWrapper(name: 'D2', length: 3, valueDesc: r'U-b');
    clueWrapper(name: 'D3', length: 4, valueDesc: r'R-O');
    clueWrapper(name: 'D4', length: 2, valueDesc: r's+s-T');
    clueWrapper(name: 'D5', length: 6, valueDesc: r'Ns-J');
    clueWrapper(name: 'D6', length: 4, valueDesc: r'E+L');
    clueWrapper(name: 'D7', length: 5, valueDesc: r'YYY');
    clueWrapper(name: 'D8', length: 7, valueDesc: r'BP+o+o');
    clueWrapper(name: 'D9', length: 7, valueDesc: r'Et+E+L');
    clueWrapper(name: 'D12', length: 6, valueDesc: r'bF+F+S');
    clueWrapper(name: 'D13', length: 5, valueDesc: r'JJ+e+ B');
    clueWrapper(name: 'D16', length: 4, valueDesc: r'i+J');
    clueWrapper(name: 'D18', length: 4, valueDesc: r'B+J+J-E');
    clueWrapper(name: 'D21', length: 3, valueDesc: r'P+T-s');
    clueWrapper(name: 'D23', length: 2, valueDesc: r'U-Y');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
      'A',
      'b',
      'B',
      'd',
      'D',
      'e',
      'E',
      'F',
      'G',
      'H',
      'i',
      'I',
      'J',
      'l',
      'L',
      'N',
      'o',
      'O',
      'P',
      'R',
      's',
      'S',
      't',
      'T',
      'U',
      'W',
      'y',
      'Y',
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(TransformationVariable(letter));
    }

    var clueError = '';
    clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    clueError += puzzle.checkEntryClueReferences();
    clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += puzzle.checkPuzzleVariableReferences();
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

  @override
  void endSolve(bool iteration) {
    super.endSolve(iteration);

    // Sorted by numeric value, the clue letters will give a two-part message.
    // The first part explains how to change each digit in the grid and the
    // second part explains how solvers must replace the result of that.
    var sortedVariables = puzzle.variables.keys.toList();
    sortedVariables.sort((a, b) =>
        puzzle.variables[a]!.value!.compareTo(puzzle.variables[b]!.value!));
    print(sortedVariables.join());
    // bY JUsT SPElLING it By HeAd oF WORD
    var gridString = puzzle.toSolution();
    var mapString = '';
    gridString.split('').forEach((ch) {
      var mch = ch;
      switch (ch) {
        case '0':
          mch = 'Z';
        case '1':
          mch = 'O';
        case '2':
          mch = 'T';
        case '3':
          mch = 'T';
        case '4':
          mch = 'F';
        case '5':
          mch = 'F';
        case '6':
          mch = 'S';
        case '7':
          mch = 'S';
        case '8':
          mch = 'E';
        case '9':
          mch = 'N';
      }
      mapString += mch;
    });
    print(mapString);
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
  bool solveTransformationClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as TransformationPuzzle;
    var clue = v as TransformationClue;
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
      TransformationPuzzle puzzle, String clueName, Set<int> possibleValues,
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
}
