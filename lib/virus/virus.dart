library virus;

import 'dart:math';

import 'package:crossnumber/set.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../generators.dart';
import '../monadic.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Virus API.
class Virus extends Crossnumber<VirusPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 |2 :3 :4 |5 |',
    '+::+--+::+::+::+',
    '|6 :7 :  |8 :  |',
    '+--+::+--+::+--+',
    '|9 :  |10:  :11|',
    '+::+::+::+--+::+',
    '|  |12:  :  |  |',
    '+--+--+--+--+--+',
  ];

  Virus() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = VirusPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        // Add KV expression
        var valueDesc = '£kv(${entrySpec.name},X)';
        var entry = VirusEntry(
          name: entrySpec.name,
          length: entrySpec.length,
          valueDesc: valueDesc,
          solve: solveVirusClue,
        );
        puzzle.addEntry(entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += '${e.msg}\n';
      }
    }

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    // For alpha entry names we pass the names to clue expression parsing
    // Until we create a clue, then entries are returned as clues (legacy)
    var entryNames = puzzle.clues.keys.toList();

    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, List<String>? addDesc}) {
      try {
        // Add KV check for entry value
        var expString = '£inversekv(E$name,X) = $valueDesc';
        var clue = VirusClue(
            name: name!,
            length: length,
            valueDesc: name != 'xA2' ? expString : valueDesc,
            addDesc: addDesc,
            solve: solveVirusClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(
        name: 'A2', length: 3, valueDesc: r'$prime $jumble #otherentry');
    clueWrapper(name: 'A6', length: 3, valueDesc: r'$triangular #result');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'$DS ED7');
    clueWrapper(name: 'A10', length: 3, valueDesc: r'#square');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'$multiple ED10');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'$multiple EA9');
    clueWrapper(name: 'D3', length: 2, valueDesc: r'$DS EA10');
    clueWrapper(name: 'D4', length: 3, valueDesc: r'$multiple ED3');
    clueWrapper(name: 'D5', length: 2, valueDesc: r'$DP EA12');
    clueWrapper(name: 'D7', length: 3, valueDesc: r'$multiple X');
    clueWrapper(name: 'D9', length: 2, valueDesc: r'$squareroot EA6');
    clueWrapper(name: 'D10', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'D11', length: 2, valueDesc: r'$divisor ED1');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
      'X',
    ];
    for (var letter in letters) {
      puzzle.addVariable(VirusVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  void initSolve() {
    var xValues = initXValues();
    // A6 is 3 digit triangular
    var a6Values = getThreeDigitTriangles();
    var goodA6 = <int>{};
    var goodEA6 = <int>{};
    var goodX = <int>{};
    var goodD9 = <int>{};
    var goodD7 = <int>{};
    var goodED7 = <int>{};
    var goodA9 = <int>{};
    var goodEA9 = <int>{};
    for (var a6Value in a6Values) {
      for (var xValue in xValues) {
        // EA6 is KV(A6)
        var ea6Value = kvFunc([a6Value, xValue]);
        // D9 is sqrt EA6
        var value = sqrt(ea6Value);
        if (value != value.roundToDouble()) continue;
        var d9Value = value.toInt();
        var ed9Value = kvFunc([d9Value, xValue]);

        // ED7[0] is EA6[1] so EA6[1] is not 0
        var ea6Digit2 = ea6Value ~/ 10 % 10;
        if (ea6Digit2 == 0) continue;

        // D7 is multiple KV
        var d7Value = (100 ~/ xValue + 1) * xValue;
        while (d7Value < 1000) {
          // ED7 is KV(D7)
          var ed7Value = kvFunc([d7Value, xValue]);
          // ED7[0] is EA6[1]
          var ed7Digit1 = ed7Value ~/ 100;
          if (ed7Digit1 == ea6Digit2) {
            // A9 is DS(ED7)
            var a9Value = digitSum(ed7Value);
            // EA9 is KV(A9)
            var ea9Value = kvFunc([a9Value, xValue]);
            // EA9[1] is ED7[1]
            var ed7Digit2 = ed7Value ~/ 10 % 10;
            var ea9Digit2 = ea9Value % 10;
            if (ea9Digit2 == ed7Digit2) {
              // EA9[0] is ED9[0]
              var ed9Digit1 = ed9Value ~/ 10;
              var ea9Digit1 = ea9Value ~/ 10;
              if (ea9Digit1 == ed9Digit1) {
                goodA6.add(a6Value);
                goodEA6.add(ea6Value);
                goodX.add(xValue);
                goodD9.add(d9Value);
                goodD7.add(d7Value);
                goodED7.add(ed7Value);
                goodA9.add(a9Value);
                goodEA9.add(ea9Value);
              }
            }
          }
          d7Value += xValue;
        }
      }
    }
    print('A6=${goodA6.toShortString()}');
    print('EA6=${goodEA6.toShortString()}');
    print('X=${goodX.toShortString()}');
    print('D9=${goodD9.toShortString()}');
    print('D7=${goodD7.toShortString()}');
    print('ED7=${goodED7.toShortString()}');
    print('A9=${goodA9.toShortString()}');
    print('EA9=${goodEA9.toShortString()}');

    puzzle.clues['A6']!.values = goodA6;
    puzzle.entries['A6']!.values = goodEA6;
    puzzle.variables['X']!.values = goodX;
    puzzle.clues['D9']!.values = goodD9;
    puzzle.clues['D7']!.values = goodD7;
    puzzle.entries['D7']!.values = goodED7;
    puzzle.clues['A9']!.values = goodA9;
    puzzle.entries['A9']!.values = goodEA9;
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    print('MANUAL UPDATES-----------------------------');
    initSolve();

    puzzle.clues['A6']!.answer = 496;
    puzzle.entries['A6']!.answer = 196;
    puzzle.variables['X']!.answer = 41;
    puzzle.clues['D9']!.answer = 14;
    puzzle.clues['D11']!.answer = 17;

    solveClueNoException(puzzle.clues["A6"]!);
    solveClueNoException(puzzle.entries["A6"]!);
    solveClueNoException(puzzle.clues["D9"]!);
    solveClueNoException(puzzle.entries["D9"]!);
    solveClueNoException(puzzle.clues["D7"]!);
    solveClueNoException(puzzle.entries["D7"]!);
    solveClueNoException(puzzle.clues["A9"]!);
    solveClueNoException(puzzle.entries["A9"]!);
    super.solve(true);
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
  bool solveVirusClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as VirusPuzzle;
    var clue = v as VirusClue;
    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      updated = puzzle.solveExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables!, validClue, null);
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
  bool updateClues(VirusPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(thisPuzzle, clue, possibleValues,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue value order
      // var clue = thisPuzzle.clues[clueName]!;
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
    }
    return updated;
  }
}
