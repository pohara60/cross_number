import 'package:crossnumber/expression.dart';
import 'package:powers/powers.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/dicenets2/clue.dart';
import 'package:crossnumber/dicenets2/puzzle.dart';

import '../clue.dart';
import '../puzzle.dart';

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
    puzzle = DiceNetsPuzzle.grid(gridString);
    initCrossnumber();
  }

  late final DiceNetsClue? a1;
  late final DiceNetsClue? a4;
  late final DiceNetsClue? a8;
  late final DiceNetsClue? a10;
  late final DiceNetsClue? a12;
  late final DiceNetsClue? a14;
  late final DiceNetsClue? a16;
  late final DiceNetsClue? a17;
  late final DiceNetsClue? a18;
  late final DiceNetsClue? a19;
  late final DiceNetsClue? a21;
  late final DiceNetsClue? a23;
  late final DiceNetsClue? a25;
  late final DiceNetsClue? a27;
  late final DiceNetsClue? a29;
  late final DiceNetsClue? a30;
  late final DiceNetsClue? a31;
  late final DiceNetsClue? a33;
  late final DiceNetsClue? a35;
  late final DiceNetsClue? a36;

  late final DiceNetsClue? d1;
  late final DiceNetsClue? d2;
  late final DiceNetsClue? d3;
  late final DiceNetsClue? d5;
  late final DiceNetsClue? d6;
  late final DiceNetsClue? d7;
  late final DiceNetsClue? d9;
  late final DiceNetsClue? d11;
  late final DiceNetsClue? d13;
  late final DiceNetsClue? d15;
  late final DiceNetsClue? d18;
  late final DiceNetsClue? d20;
  late final DiceNetsClue? d22;
  late final DiceNetsClue? d24;
  late final DiceNetsClue? d26;
  late final DiceNetsClue? d28;
  late final DiceNetsClue? d32;
  late final DiceNetsClue? d34;

  void initCrossnumber() {
    puzzle.clues = {};
    var clueErrors = '';
    DiceNetsClue? clueWrapper(
        {String? name, int? length, String? valueDesc, solve}) {
      try {
        var clue = DiceNetsClue(
            name: name, length: length, valueDesc: valueDesc, solve: solve);
        puzzle.addClue(clue);
        return clue;
      } on ExpressionError catch (e) {
        clueErrors += e.msg + '\n';
        return null;
      }
    }

    a1 = clueWrapper(
        name: 'A1', length: 4, valueDesc: '#Prime', solve: solveDiceNets);
    a4 = clueWrapper(
        name: 'A4', length: 4, valueDesc: '#Power3', solve: solveDiceNets);
    a8 = clueWrapper(
        name: 'A8',
        length: 4,
        valueDesc: '#Triangular - A18',
        solve: solveDiceNets);
    a10 = clueWrapper(
        name: 'A10',
        length: 3,
        valueDesc: r'$Multiple D34',
        solve: solveDiceNets);
    a12 = clueWrapper(
        name: 'A12',
        length: 3,
        valueDesc: r'$Even #Square',
        solve: solveDiceNets);
    a14 = clueWrapper(
        name: 'A14', length: 2, valueDesc: '#Triangular', solve: solveDiceNets);
    a16 = clueWrapper(
        name: 'A16',
        length: 3,
        valueDesc: '#Triangular - A31',
        solve: solveDiceNets);
    a17 = clueWrapper(
        name: 'A17',
        length: 4,
        valueDesc: r'$Multiple D7',
        solve: solveDiceNets);
    a18 = clueWrapper(
        name: 'A18', length: 5, valueDesc: '#Triangular', solve: solveDiceNets);
    a19 = clueWrapper(
        name: 'A19',
        length: 2,
        valueDesc: '#Triangular - A29',
        solve: solveDiceNets);
    a21 = clueWrapper(
        name: 'A21', length: 2, valueDesc: '#Power3', solve: solveDiceNets);
    a23 = clueWrapper(
        name: 'A23',
        length: 5,
        valueDesc: r'$Multiple D32',
        solve: solveDiceNets);
    a25 = clueWrapper(
        name: 'A25', length: 4, valueDesc: '#Prime', solve: solveDiceNets);
    a27 = clueWrapper(
        name: 'A27',
        length: 3,
        valueDesc: '#Square - A16',
        solve: solveDiceNets);
    a29 = clueWrapper(
        name: 'A29',
        length: 2,
        valueDesc: r'$Multiple #Power3',
        solve: solveDiceNets);
    a30 = clueWrapper(
        name: 'A30',
        length: 3,
        valueDesc: '#Square + D24',
        solve: solveDiceNets);
    a31 = clueWrapper(
        name: 'A31',
        length: 3,
        valueDesc: '#Square - A16',
        solve: solveDiceNets);
    a33 = clueWrapper(
        name: 'A33',
        length: 4,
        valueDesc: r'$Multiple A30',
        solve: solveDiceNets);
    a35 = clueWrapper(
        name: 'A35', length: 4, valueDesc: '#Triangular', solve: solveDiceNets);
    a36 = clueWrapper(
        name: 'A36', length: 4, valueDesc: r'$Jumble D1', solve: solveDiceNets);

    d1 = clueWrapper(
        name: 'D1', length: 4, valueDesc: '#Square', solve: solveDiceNets);
    d2 = clueWrapper(
        name: 'D2', length: 6, valueDesc: '#Square', solve: solveDiceNets);
    d3 = clueWrapper(
        name: 'D3',
        length: 2,
        valueDesc: r'#product3primes',
        solve: solveDiceNets);
    d5 = clueWrapper(
        name: 'D5',
        length: 5,
        valueDesc: r'#product3primes',
        solve: solveDiceNets);
    d6 = clueWrapper(
        name: 'D6', length: 4, valueDesc: 'D7 + D18', solve: solveDiceNets);
    d7 = clueWrapper(
        name: 'D7', length: 2, valueDesc: '#Power3', solve: solveDiceNets);
    d9 = clueWrapper(
        name: 'D9', length: 7, valueDesc: '#Triangular', solve: solveDiceNets);
    d11 = clueWrapper(
        name: 'D11', length: 3, valueDesc: '2 * #Square', solve: solveDiceNets);
    d13 = clueWrapper(
        name: 'D13', length: 7, valueDesc: '#Square', solve: solveDiceNets);
    d15 = clueWrapper(
        name: 'D15', length: 4, valueDesc: '#Square', solve: solveDiceNets);
    d18 = clueWrapper(
        name: 'D18', length: 4, valueDesc: '#Power3', solve: solveDiceNets);
    d20 = clueWrapper(
        name: 'D20', length: 6, valueDesc: '#Square', solve: solveDiceNets);
    d22 = clueWrapper(
        name: 'D22',
        length: 5,
        valueDesc: r'$Multiple $Square D32',
        solve: solveDiceNets);
    d24 = clueWrapper(
        name: 'D24',
        length: 3,
        valueDesc: '#sumConsecutiveSquares',
        solve: solveDiceNets);
    d26 = clueWrapper(
        name: 'D26',
        length: 4,
        valueDesc: '#Triangular / 2',
        solve: solveDiceNets);
    d28 = clueWrapper(
        name: 'D28', length: 4, valueDesc: '#Square', solve: solveDiceNets);
    d32 = clueWrapper(
        name: 'D32', length: 2, valueDesc: 'A19 - D7', solve: solveDiceNets);
    d34 = clueWrapper(
        name: 'D34', length: 2, valueDesc: '#Prime', solve: solveDiceNets);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.addDigitIdentityFromGrid();

    var clueError = puzzle.checkClueReferences();
    if (clueError != '') throw PuzzleException(clueError);

    var variableError = puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
  }

  static List<int> filterDice(Iterable<int> values) {
    List<int> dice = [];
    for (var value in values) {
      var ok = true;
      for (var digit in value.toString().split('')) {
        if ("7890".contains(digit)) {
          ok = false;
          break;
        }
      }
      if (ok) dice.add(value);
    }
    return dice;
  }

  static void filterDigits(
      DiceNetsClue clue, List<int> values, Set<int> possibleValue) {
    for (var value in values) {
      if (clue.digitsMatch(value)) {
        possibleValue.add(value);
      }
    }
  }

  static void filterDiceDigits(
      DiceNetsClue clue, List<int> values, Set<int> possibleValue) {
    filterDigits(clue, filterDice(values), possibleValue);
  }

  bool validDiceDigits(VariableClue clue, int value,
      List<String> variableReferences, List<int> variableValues) {
    if (value.toString().contains(RegExp(r'[7890]'))) return false;
    if (!clue.digitsMatch(value)) return false;
    return true;
  }

  bool solveDiceNets(DiceNetsClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables) {
    puzzle.solveExpressionEvaluator(
        clue, possibleValue, possibleVariables, validDiceDigits);
    return false;
  }

  bool solveA1(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA4(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPowers(), possibleValue);
    return false;
  }

  bool solveA8(DiceNetsClue clue, Set<int> possibleValue) {
    findTriangularsLessClue(clue, a18!, possibleValue);
    return false;
  }

  bool solveA10(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d34!, possibleValue);
    return false;
  }

  bool solveA12(DiceNetsClue clue, Set<int> possibleValue) {
    var values = filterDice(getThreeDigitSquares());
    values.removeWhere((value) => value % 2 == 1);
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveA14(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA16(DiceNetsClue clue, Set<int> possibleValue) {
    if (a31!.values != null) {
      findTriangularsLessClue(clue, a31!, possibleValue);
    } else {
      // A16 and A31 are mutually referential, so need a way to get started
      var values = getValuesFromClueDigits(a31!);
      if (values != null) {
        findTriangularsLessValues(clue, values, possibleValue);
      }
    }
    return false;
  }

  bool solveA17(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d7!, possibleValue);
    return false;
  }

  bool solveA18(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFiveDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA19(DiceNetsClue clue, Set<int> possibleValue) {
    findTriangularsLessClue(clue, a29!, possibleValue);
    return false;
  }

  bool solveA21(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitPowers(), possibleValue);
    return false;
  }

  bool solveA23(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, d32!, possibleValue);
    return false;
  }

  bool solveA25(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPrimes(), possibleValue);
    return false;
  }

  bool solveA27(DiceNetsClue clue, Set<int> possibleValue) {
    findSquarePlusOrMinusClue(clue, a16!, possibleValue, false);
    return false;
  }

  bool solveA29(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfPower(clue, possibleValue);
    return false;
  }

  bool solveA30(DiceNetsClue clue, Set<int> possibleValue) {
    findSquarePlusOrMinusClue(clue, d24!, possibleValue, true);
    return false;
  }

  bool solveA31(DiceNetsClue clue, Set<int> possibleValue) {
    if (a16!.values != null) {
      findTriangularsLessClue(clue, a16!, possibleValue);
    } else {
      // A16 and A31 are mutually referential, so need a way to get started
      var values = getValuesFromClueDigits(a16!);
      if (values != null) {
        findTriangularsLessValues(clue, values, possibleValue);
      }
    }
    return false;
  }

  bool solveA33(DiceNetsClue clue, Set<int> possibleValue) {
    findMultiplesOfClue(clue, a30!, possibleValue);
    return false;
  }

  bool solveA35(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitTriangles(), possibleValue);
    return false;
  }

  bool solveA36(DiceNetsClue clue, Set<int> possibleValue) {
    // A36 is Jumble of D1
    if (d1!.values != null) {
      // Construct Jumbles of all values
      for (var value in d1!.values!) {
        var jumbles = <int>{};
        for (var d1 = 0; d1 < 4; d1++) {
          for (var d2 = 0; d2 < 4; d2++) {
            if (d2 != d1) {
              for (var d3 = 0; d3 < 4; d3++) {
                if (d3 != d1 && d3 != d2) {
                  for (var d4 = 0; d4 < 4; d4++) {
                    if (d4 != d3 && d4 != d1 && d4 != d2) {
                      var str = value.toString();
                      var jumble = str[d1] + str[d2] + str[d3] + str[d4];
                      jumbles.add(int.parse(jumble));
                    }
                  }
                }
              }
            }
          }
        }
        var possible = <int>{};
        filterDiceDigits(clue, jumbles.toList(), possible);
        possibleValue.addAll(possible);
      }
    }
    return false;
  }

  static bool solveFourDigitSquares(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    return false;
  }

  bool solveD1(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    // A36 is Jumble of D1, so check for illegal values
    if (possibleValue.length > 0) {
      // Find required and forbidden digits in A36, check for D1 values that have them
      var required = <int>{};
      var forbidden = Set.from(List.generate(6, (index) => index + 1));
      for (var d = 0; d < a36!.length; d++) {
        if (a36!.digits[d].length == 1) {
          required.addAll(a36!.digits[d]);
        }
        forbidden.removeAll(a36!.digits[d]);
      }
      if (required.length > 0 || forbidden.length > 0) {
        var removeValue = <int>{};
        for (var value in possibleValue) {
          var ok = true;
          for (var digit in required) {
            if (!value.toString().contains(digit.toString())) {
              ok = false;
              break;
            }
          }
          for (var digit in forbidden) {
            if (value.toString().contains(digit.toString())) {
              ok = false;
              break;
            }
          }
          // Update D1
          if (!ok) {
            removeValue.add(value);
          }
        }
        possibleValue.removeAll(removeValue);
      }
    }
    return false;
  }

  static bool solveSixDigitSquares(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSixDigitSquares(), possibleValue);
    return false;
  }

  var solveD2 = solveSixDigitSquares;

  bool solveD3(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitMultipleThreePrimes(), possibleValue);
    return false;
  }

  bool solveD5(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFiveDigitMultipleThreePrimes(), possibleValue);
    return false;
  }

  bool solveD6(DiceNetsClue clue, Set<int> possibleValue) {
    findPlusOrMinusClues(clue, d7!, d18!, possibleValue, true);
    return false;
  }

  bool solveD7(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getTwoDigitPowers(), possibleValue);
    return false;
  }

  bool solveD9(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSevenDigitTriangles(), possibleValue);
    return false;
  }

  bool solveD11(DiceNetsClue clue, Set<int> possibleValue) {
    var squares = getTwoDigitSquares().where((value) => value >= 50).toList();
    squares.addAll(getThreeDigitSquares().where((value) => value < 500));
    var values = squares.map((value) => 2 * value).toList();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  static bool solveSevenDigitSquares(
      DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getSevenDigitSquares(), possibleValue);
    return false;
  }

  var solveD13 = solveSevenDigitSquares;

  bool solveD15(DiceNetsClue clue, Set<int> possibleValue) {
    var values = filterDice(getFourDigitSquares());
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD18(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitPowers(), possibleValue);
    return false;
  }

  var solveD20 = solveSixDigitSquares;

  bool solveD22(DiceNetsClue clue, Set<int> possibleValue) {
    if (d32!.values != null) {
      var values = d32!.values!.map((value) => value * value).toList();
      findMultiplesOfValues(clue, values, possibleValue);
    }
    return false;
  }

  bool solveD24(DiceNetsClue clue, Set<int> possibleValue) {
    // Sum of two consecutive squares
    var squares = getSquaresInRange(49, 999);
    int previous = 0;
    var values = <int>[];
    for (var square in squares) {
      if (previous != 0) {
        var sum = previous + square;
        if (sum < 100) continue;
        if (sum > 999) break;
        values.add(sum);
      }
      previous = square;
    }
    filterDiceDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD26(DiceNetsClue clue, Set<int> possibleValue) {
    var triangles = getFourDigitTriangles()
        .where((value) => value >= 2000 && value % 2 == 0)
        .toList();
    triangles.addAll(getFiveDigitTriangles()
        .where((value) => value < 20000 && value % 2 == 0));
    var values = triangles.map((value) => value ~/ 2).toList();
    filterDigits(clue, values, possibleValue);
    return false;
  }

  bool solveD28(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, getFourDigitSquares(), possibleValue);
    return false;
  }

  bool solveD32(DiceNetsClue clue, Set<int> possibleValue) {
    findPlusOrMinusClues(clue, a19!, d7!, possibleValue, false);
    return false;
  }

  bool solveD34(DiceNetsClue clue, Set<int> possibleValue) {
    filterDiceDigits(clue, twoDigitPrimes, possibleValue);
    return false;
  }

  static void findTriangularsLessClue(
      DiceNetsClue output, DiceNetsClue input, Set<int> possibleValue) {
    if (input.values != null) {
      findTriangularsLessValues(output, input.values!, possibleValue);
    }
  }

  static void findTriangularsLessValues(
      DiceNetsClue clue, Set<int> values, Set<int> possibleValue) {
    var result = getTriangularsLessValues(clue, values);
    if (result != null) {
      var possible = <int>{};
      filterDiceDigits(clue, result, possible);
      possibleValue.addAll(possible);
    }
  }

  static void findPlusOrMinusClues(DiceNetsClue output, DiceNetsClue input1,
      DiceNetsClue input2, possibleValue,
      [bool plus = false]) {
    if (input1.values != null && input2.values != null) {
      var lo = 10.pow(output.length - 1) as int;
      var hi = (10.pow(output.length) as int) - 1;
      for (var value1 in input1.values!) {
        var values = <int>[];
        for (var value2 in input2.values!) {
          var difference = plus ? value1 + value2 : value1 - value2;
          if (difference < lo) continue;
          if (difference >= hi) continue;
          values.add(difference);
        }
        var possible = <int>{};
        filterDiceDigits(output, values, possible);
        possibleValue.addAll(possible);
      }
    }
  }

  static void findSquarePlusOrMinusClue(
      DiceNetsClue output, DiceNetsClue input, possibleValue,
      [bool plus = false]) {
    if (input.values != null) {
      var minInput = input.values!
          .reduce((value, element) => element < value ? element : value);
      var maxInput = input.values!
          .reduce((value, element) => element > value ? element : value);
      var lo = 10.pow(output.length - 1) as int;
      var hi = (10.pow(output.length) as int) - 1;
      int minSquare;
      int maxSquare;
      if (plus) {
        minSquare = lo > maxInput ? lo - maxInput : 1;
        maxSquare = hi - minInput;
      } else {
        minSquare = lo + minInput;
        maxSquare = hi + maxInput;
      }
      var squares = getSquaresInRange(minSquare, maxSquare);
      for (var value in input.values!) {
        var values = <int>[];
        for (var square in squares) {
          var difference = plus ? square + value : square - value;
          if (difference < lo) continue;
          if (difference >= hi) continue;
          values.add(difference);
        }
        var possible = <int>{};
        filterDiceDigits(output, values, possible);
        possibleValue.addAll(possible);
      }
    }
  }

  static void findMultiplesOfPower(DiceNetsClue clue, Set<int> possibleValue) {
    var hi = (10.pow(clue.length) as int) - 1;
    var squares = getPowersInRange(1, hi);
    findMultiplesOfValues(clue, squares, possibleValue);
  }

  static void findMultiplesOfClue(
      DiceNetsClue output, DiceNetsClue input, Set<int> possibleValue) {
    if (input.values != null) {
      findMultiplesOfValues(output, input.values!.toList(), possibleValue);
    }
  }

  static void findMultiplesOfValues(
      DiceNetsClue clue, List<int> values, Set<int> possibleValue) {
    var multiples = getMultiplesOfValues(clue, values);
    if (multiples != null) {
      var possible = <int>{};
      filterDiceDigits(clue, multiples, possible);
      possibleValue.addAll(possible);
    }
  }
}
