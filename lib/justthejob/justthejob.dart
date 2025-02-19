library justthejob;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the JustTheJob API.
class JustTheJob extends Crossnumber<JustTheJobPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+--+',
    '|1 :2 :3 :  |4 :  :5 |6 :7 |',
    '+::+::+::+--+::+--+::+::+::+',
    '|8 :  |  |9 :  |10|11:  |  |',
    '+--+::+::+::+--+::+::+--+::+',
    '|12:  :  :  :13|14:  :  :  |',
    '+--+::+::+::+::+::+--+--+::+',
    '|15:  :  |16:  :  |17:18:  |',
    '+::+--+--+::+::+::+::+::+--+',
    '|19:  :20:  |21:  :  :  :  |',
    '+::+--+::+::+--+::+::+::+--+',
    '|  |22:  |  |23:  |  |24:25|',
    '+::+::+::+--+::+--+::+::+::+',
    '|26:  |27:  :  |28:  :  :  |',
    '+--+--+--+--+--+--+--+--+--+',
  ];

  JustTheJob() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = JustTheJobPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = JustTheJobEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveJustTheJobClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 4, valueDesc: r'(BR+A)(N-DN+EW)');
    clueWrapper(name: 'A4', length: 3, valueDesc: r'I(NF-A+NT)');
    clueWrapper(name: 'A6', length: 2, valueDesc: r'BE+GIN');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'M+AITAI');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'COOT');
    clueWrapper(name: 'A11', length: 2, valueDesc: r'BA+NG');
    clueWrapper(name: 'A12', length: 5, valueDesc: r'SLEEP+IN+G+RO+UG-H');
    clueWrapper(name: 'A14', length: 4, valueDesc: r'(DIR+T)(C-H)E(A+P)');
    clueWrapper(name: 'A15', length: 3, valueDesc: r'BA(RR+E-D)');
    clueWrapper(name: 'A16', length: 3, valueDesc: r'F(ER+M-E+NT)');
    clueWrapper(name: 'A17', length: 3, valueDesc: r'DI(VE+S)');
    clueWrapper(name: 'A19', length: 4, valueDesc: r'(W+H+I+P)CORD');
    clueWrapper(name: 'A21', length: 5, valueDesc: r'(RESPO+NS+I+B-L)E');
    clueWrapper(name: 'A22', length: 2, valueDesc: r'WO+N');
    clueWrapper(name: 'A23', length: 2, valueDesc: r'PANT');
    clueWrapper(name: 'A24', length: 2, valueDesc: r'BRA-T');
    clueWrapper(name: 'A26', length: 2, valueDesc: r'FUN');
    clueWrapper(name: 'A27', length: 3, valueDesc: r'SPI-T');
    clueWrapper(name: 'A28', length: 4, valueDesc: r'(U+(ND+A)(U-N)(T-E))D');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'HE-AT');
    clueWrapper(name: 'D2', length: 4, valueDesc: r'P(I+N)(PO+I+N)+T+I-N+G');
    clueWrapper(name: 'D3', length: 4, valueDesc: r'(PR+O)(GRE+SS)');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'B+E-T');
    clueWrapper(name: 'D5', length: 3, valueDesc: r'BEAR+H-U-G');
    clueWrapper(name: 'D6', length: 2, valueDesc: r'COCO+NUT');
    clueWrapper(name: 'D7', length: 4, valueDesc: r'(I+N+ST)EAD');
    clueWrapper(name: 'D9', length: 5, valueDesc: r'DIRVER+LESS-VEHI+C-LE');
    clueWrapper(name: 'D10', length: 5, valueDesc: r'(DECA+T)(HLO-N)S');
    clueWrapper(name: 'D13', length: 3, valueDesc: r'I+(N+T+E)NTS');
    clueWrapper(name: 'D15', length: 4, valueDesc: r'IN(CONC+E-RT)');
    clueWrapper(name: 'D17', length: 4, valueDesc: r'C(O-H)EREN+CI+E-S');
    clueWrapper(
        name: 'D18', length: 4, valueDesc: r'S(E+A)((R+C+H)(L+I+G-H)+T)');
    clueWrapper(name: 'D20', length: 3, valueDesc: r'(FE-N)(D+I+N+G)');
    clueWrapper(name: 'D22', length: 2, valueDesc: r'APA-R-T');
    clueWrapper(name: 'D23', length: 2, valueDesc: r'BE+A+R+D');
    clueWrapper(name: 'D25', length: 2, valueDesc: r'HOTRO+D');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'L',
      'M',
      'N',
      'O',
      'P',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
    ];
    for (var letter in letters) {
      puzzle.addVariable(JustTheJobVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
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
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveJustTheJobClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as JustTheJobPuzzle;
    var clue = v as JustTheJobClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      if (clue.expressions.length == 1) {
        // Get count of known values
        var duplicateLimit = puzzle.variablesList.getDuplicateLimit();

        updated = puzzle.solveExpressionEvaluator(
          clue,
          clue.exp,
          possibleValue,
          possibleVariables!,
          validClue,
          null, // callback
          1000000, // maxCount
          duplicateLimit, // distinctValueCount
        );
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
      } else {
        // Get values from digits
        var values = clue.getValuesFromDigits();
        if (values != null) {
          possibleValue.addAll(values);
        } else {
          // No further action
          throw SolveException();
        }
      }
    }
    return updated;
  }

  @override
  bool updateClues(JustTheJobPuzzle thisPuzzle, Clue clue,
      Set<int> possibleValues, Set<Variable> updatedVariables,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(
        thisPuzzle, clue, possibleValues, updatedVariables,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue value order
      // var newMin = clue.values!.reduce(min);
      // if (clue.min == null || clue.min! < newMin) clue.min = newMin;
      // var newMax = clue.values!.reduce(max);
      // if (clue.max == null || clue.max! > newMax) clue.max = newMax;
      // // Clues are defined in ascending order of value
      // for (var otherClue in thisPuzzle.clues.values) {
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
      // }
    }
    return updated;
  }
}
