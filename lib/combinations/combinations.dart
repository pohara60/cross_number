library combinations;

import 'package:memoized/memoized.dart';
import 'package:crossnumber/cartesian.dart';
import 'package:crossnumber/generators.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Combinations API.
class Combinations extends Crossnumber<CombinationsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|1 :2 :3 |4 :  :5 :6 :7 |',
    '+::+::+::+::+--+::+::+::+',
    '|8 :  |9 :  :10|11:  :  |',
    '+::+::+::+::+::+::+::+::+',
    '|12:  :  |  |13:  :  |  |',
    '+--+::+--+::+::+::+--+::+',
    '|14:  :15:  |16:  :17:  |',
    '+::+--+::+::+::+--+::+--+',
    '|  |18:  :  |  |19:  :20|',
    '+::+::+::+::+::+::+::+::+',
    '|21:  :  |22:  :  |23:  |',
    '+::+::+::+--+::+::+::+::+',
    '|24:  :  :  :  |25:  :  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  Combinations() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = CombinationsPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper(
        {String? name, int? length, String? valueDesc, String? kDesc}) {
      try {
        var clue = CombinationsEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solveCombinationsClue,
        );
        puzzle.addEntry(clue);
        if (kDesc != null && kDesc != '') {
          clue.addExpression(kDesc);
        }
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, kDesc: r'E', valueDesc: r'GJ(B+I)-JJ');
    clueWrapper(name: 'A4', length: 5, kDesc: r'G - J', valueDesc: r'BFJ');
    clueWrapper(name: 'A8', length: 2, kDesc: r'F - G', valueDesc: r'A+E');
    clueWrapper(name: 'A9', length: 3, kDesc: r'GJ', valueDesc: r'BB+C');
    clueWrapper(name: 'A11', length: 3, kDesc: r'AD', valueDesc: r'AF-E');
    clueWrapper(name: 'A12', length: 3, kDesc: r'H', valueDesc: r'J(AI-C)');
    clueWrapper(name: 'A13', length: 3, kDesc: r'F - I', valueDesc: r'DE');
    clueWrapper(name: 'A14', length: 4, kDesc: r'H - C', valueDesc: r'IJ');
    clueWrapper(name: 'A16', length: 4, kDesc: r'D - G', valueDesc: r'I(D-C)');
    clueWrapper(name: 'A18', length: 3, kDesc: r'C + C', valueDesc: r'JJ');
    clueWrapper(name: 'A19', length: 3, kDesc: r'I - C', valueDesc: r'AH');
    clueWrapper(name: 'A21', length: 3, kDesc: r'H(B + G)', valueDesc: r'BB+J');
    clueWrapper(name: 'A22', length: 3, kDesc: r'F + G', valueDesc: r'D+F');
    clueWrapper(name: 'A23', length: 2, kDesc: r'J - H', valueDesc: r'D-H');
    clueWrapper(
        name: 'A24', length: 5, kDesc: r'C + F - D', valueDesc: r'F(GJ-A)');
    clueWrapper(name: 'A25', length: 3, kDesc: r'I - A', valueDesc: r'E^G');
    clueWrapper(name: 'D1', length: 3, kDesc: r'C+C', valueDesc: r'EF(B+F+G)');
    clueWrapper(name: 'D2', length: 4, kDesc: r'E', valueDesc: r'BF');
    clueWrapper(name: 'D3', length: 3, kDesc: r'F-I', valueDesc: r'EF');
    clueWrapper(name: 'D4', length: 6, kDesc: r'D-G', valueDesc: r'FG(B+I)-I');
    clueWrapper(name: 'D5', length: 4, kDesc: r'D+I', valueDesc: r'F(B+F+G)');
    clueWrapper(name: 'D6', length: 3, kDesc: r'E+H', valueDesc: r'I(I+I)');
    clueWrapper(name: 'D7', length: 4, kDesc: r'G-J', valueDesc: r'DD');
    clueWrapper(name: 'D10', length: 6, kDesc: r'B-A', valueDesc: r'AAGG+B+B');
    clueWrapper(name: 'D14', length: 4, kDesc: r'GH', valueDesc: r'BG');
    clueWrapper(name: 'D15', length: 4, kDesc: r'H-C', valueDesc: r'ABJ-E');
    clueWrapper(name: 'D17', length: 4, kDesc: r'F-J', valueDesc: r'F(BGH-I)');
    clueWrapper(name: 'D18', length: 3, kDesc: r'D-E', valueDesc: r'B(F+G)');
    clueWrapper(name: 'D19', length: 3, kDesc: r'B+H', valueDesc: r'I+J');
    clueWrapper(name: 'D20', length: 3, kDesc: r'J-H', valueDesc: r'DHJ');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    var letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(CombinationsVariable(letter));
    }

    puzzle.finalize();

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

    // puzzle.variables['A']!.value = 4;
    // puzzle.variables['B']!.value = 6;
    // puzzle.variables['C']!.value = 1;
    // puzzle.variables['D']!.value = 9;
    // puzzle.variables['E']!.value = 2;
    // puzzle.variables['F']!.value = 10;
    // puzzle.variables['G']!.value = 7;
    // puzzle.variables['H']!.value = 3;
    // puzzle.variables['I']!.value = 8;
    // puzzle.variables['J']!.value = 5;

    super.solve(iteration);
  }

  @override

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveCombinationsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as CombinationsPuzzle;
    var clue = v as CombinationsClue;
    var updated = false;

    // Clue has two expressions N and k
    assert(clue.expressions.length == 2);
    var expN = clue.expressions[0];
    var expK = clue.expressions[1];

    var variables = <Variable>[];
    var variableValues = <List<int>>[];
    var count = puzzle.getVariables([clue], clue.expressions, possibleValue,
        possibleVariables!, variables, variableValues, 1000000);
    if (count == 0) return false;

    var variableNames = variables.map((e) => e.name).toList();
    for (var product
        in variableValues.isEmpty ? [<int>[]] : cartesian(variableValues)) {
      try {
        for (var valueN
            in expN.generate(1, clue.max, variables, product, clue.values)) {
          for (var valueK
              in expK.generate(1, clue.max, variables, product, clue.values)) {
            // Entries are any of three types.
            // i. NCk : the number of ways of choosing k objects from a set of N objects.
            // ii. Sum of the next k primes greater than N
            // iii. Product of the next k primes greater than N
            var anyValid = false;
            var nCk = computeCombinations(valueN, valueK);
            var valid = super.validClue(clue, nCk, variableNames, product);
            if (valid) {
              possibleValue.add(nCk);
              anyValid = true;
            }

            var sumKPrimes = computeSumKPrimes(valueN, valueK);
            valid = super.validClue(clue, sumKPrimes, variableNames, product);
            if (valid) {
              possibleValue.add(sumKPrimes);
              anyValid = true;
            }

            var productKPrimes = computeProductKPrimes(valueN, valueK);
            valid =
                super.validClue(clue, productKPrimes, variableNames, product);
            if (valid) {
              possibleValue.add(productKPrimes);
              anyValid = true;
            }

            if (anyValid) {
              var index = 0;
              for (var variable in variables) {
                possibleVariables[variable]!.add(product[index++]);
              }
              // if (Crossnumber.traceSolve) {
              //   print('${clue.name}=$value, ${clue.variableReferences}=$product');
              // }
            }
          }
        }
      } on ExpressionInvalid {
        // Illegal values
      }
    }
    // if (Crossnumber.traceSolve) {
    //   if (count != 1) {
    //     print(
    //         'Eval ${clue.runtimeType} ${clue.name} cartesianCount=$count, elapsed ${stopwatch.elapsed}');
    //     // print('${clue.exp.toString()}');
    //     // for (var v in clue.variableReferences) {
    //     //   print('$v=${this.variables[v]!.values!.toList()}');
    //     // }
    //   }
    // }

    return updated;
  }

  @override
  bool updateClues(
      CombinationsPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
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

Iterable<int> kPrimesGreaterN(int valueN, int valueK) sync* {
  var count = 0;
  for (var prime in generatePrimesOver(valueN)) {
    if (count >= valueK) break;
    yield prime;
    count++;
  }
}

final sumRange = Memoized2((int begin, int end) {
  int sum = 0;
  for (int i = begin; i <= end; i++) {
    sum += i;
  }
  return sum;
});

final computeSumKPrimes = Memoized2((int valueN, int valueK) {
  var sum = 0;
  for (var prime in kPrimesGreaterN(valueN, valueK)) {
    sum += prime;
  }
  return sum;
});

final computeProductKPrimes = Memoized2((int valueN, int valueK) {
  var product = 1;
  for (var prime in kPrimesGreaterN(valueN, valueK)) {
    product *= prime;
  }
  return product;
});

final computeCombinations = Memoized2((int valueN, int valueK) {
  if (valueK < 1 || valueK > valueN) return 0;
  if (valueK == valueN) return 1;
  if (valueK == 1) return valueN;
  try {
    // nCk = n!/(n-k)!k!
    var k = valueK;
    var n = valueN;
    if (n - k < k) k = n - k;
    var r = 1;
    for (var d = 1; d <= k; d++) {
      r *= n--;
      r ~/= d;
      if (r > 1000000) throw SolveException('Combinations out of range');
    }
    return r;
  } on SolveException {
    return 0;
  }
});

final Memoized1<int, int> getFactorial = Memoized1((int n) {
  if (n > 19) throw SolveException('Factorial out of range');
  if (n <= 1) return n;
  return n * getFactorial(n - 1);
});
