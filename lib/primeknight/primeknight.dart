library primeknight;

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../generators.dart';
import '../monadic.dart';
import '../puzzle.dart';
import '../undo.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the PrimeKnight API.
class PrimeKnight extends Crossnumber<PrimeKnightPuzzle> {
  var gridString = [
    '+--+--+--+--+--+',
    '|1 :2 :  |3 :4 |',
    '+::+::+--+--+::+',
    '|  |5 :6 |7 :  |',
    '+--+::+::+::+--+',
    '|8 :  |9 :  |10|',
    '+::+--+--+::+::+',
    '|11:  |12:  :  |',
    '+--+--+--+--+--+',
  ];

  PrimeKnight() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = PrimeKnightPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Clue definitions define the Entries
    var clueErrors = '';
    void clueWrapper({String? name, int? length, String? valueDesc}) {
      try {
        var clue = PrimeKnightEntry(
          name: name!,
          length: length,
          valueDesc: valueDesc,
          solve: solvePrimeKnightClue,
        );
        puzzle.addEntry(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: 'A1', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'A3', length: 2, valueDesc: r'A7-A9');
    clueWrapper(name: 'A5', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A7', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A8', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A9', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A11', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'A12', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D1', length: 2, valueDesc: r'#triangular');
    clueWrapper(name: 'D2', length: 3, valueDesc: r'#prime');
    clueWrapper(name: 'D4', length: 2, valueDesc: r'#prime');
    clueWrapper(name: 'D6', length: 2, valueDesc: r'A3 = $DP #result');
    clueWrapper(name: 'D7', length: 3, valueDesc: r'$multiple A5');
    clueWrapper(name: 'D8', length: 2, valueDesc: r'A3+A7');
    clueWrapper(name: 'D10', length: 2, valueDesc: r'#prime');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.validateEntriesFromGrid();

    puzzle.linkEntriesToGrid();

    // Link entries to grid cells
    // puzzle.grid = Grid.fromGridSpec(puzzle);

    var letters = [
      // variables
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(PrimeKnightVariable(letter));
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

    // puzzle.clues['A1']!.value = 971;
    // puzzle.clues['A3']!.value = 14;
    // puzzle.clues['A5']!.value = 67;
    // puzzle.clues['A7']!.value = 37;
    // puzzle.clues['A8']!.value = 59;
    // puzzle.clues['A9']!.value = 23;
    // puzzle.clues['A11']!.value = 17;
    // puzzle.clues['A12']!.value = 353;
    // puzzle.clues['D10']!.value = 13;

    super.solve(false);

    // manualSolve();

    // super.solve(false);

    var tours = puzzle.knightTours();
    // var primes = [97, 43, 71, 17, 59, 37, 53, 11, 61, 23];
    Crossnumber.traceSolve = false;
    for (var tour in tours) {
      // var answer = IterableEquality().equals(tour, tourAnswer);
      // var answer = false;
      // if (answer) print('Possible tour $tour, answer=$answer');
      // solveTour(tour, 1, twoDigitPrimes, [], answer ? primes : null);
      solveTour(tour, 1, twoDigitPrimes, [], null);
    }
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
  bool solvePrimeKnightClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var puzzle = p as PrimeKnightPuzzle;
    var clue = v as PrimeKnightClue;
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

  void solveTour(
    List<(int, int)> tour,
    int index,
    List<int> availablePrimes,
    List<int> usedPrimes, [
    List<int>? checkPrimes,
    bool previousDebug = true,
  ]) {
    if (index > tour.length) {
      // End of tour
      // Check entries
      if (checkSolution(usedPrimes)) {
        print('Successful tour $tour, primes $usedPrimes');
        print(puzzle.toSummary());
      }
      return;
    }
    var (prevRow, prevCol) = tour[index - 1];
    var grid = puzzle.grid!;
    var (row, col) = (grid.numRows - 1, grid.numCols - 1);
    if (index < tour.length) (row, col) = tour[index];
    var startCell = grid.rows[prevRow][prevCol];
    var endCell = grid.rows[row][col];
    for (var prime in availablePrimes) {
      var debug = checkPrimes != null &&
          checkPrimes[usedPrimes.length] == prime &&
          previousDebug;
      if (debug) {
        print('Index $index next prime $prime');
      }
      // Try prime in these cells
      var firstDigit = prime ~/ 10;
      var secondDigit = prime % 10;
      if (startCell.digits.contains(firstDigit) &&
          endCell.digits.contains(secondDigit)) {
        // This prime is possible, check sequence
        if (index > 4) {
          var prevPrime = usedPrimes[usedPrimes.length - 1];
          var prevPrevPrime = usedPrimes[usedPrimes.length - 2];
          if (prevPrevPrime < prevPrime && prevPrime < prime) continue;
          if (prevPrevPrime > prevPrime && prevPrime > prime) continue;
        }
        // Prime obeys sequence
        // Used prime
        UndoStack.begin();
        usedPrimes.add(prime);
        try {
          startCell.setDigit(firstDigit);
          endCell.setDigit(secondDigit);
          solveTour(tour, index + 2, List.from(availablePrimes)..remove(prime),
              usedPrimes, checkPrimes, debug);
        } on SolveException {
          // Do nothing
        }
        // Un-use prime
        usedPrimes.removeLast();
        UndoStack.undo();
      }
    }
  }

  bool checkSolution(List<int> usedPrimes) {
    var ok = true;
    for (var clue in puzzle.clues.values) {
      if (clue.solve != null) {
        var values = clue.getValuesFromDigits();
        assert(values != null && values.length == 1);
        var value = values!.first;
        var possibleValue = <int>{};
        var possibleVariables = <Variable, Set<int>>{};
        try {
          for (var variableRef in clue.variableClueReferences) {
            possibleVariables[variableRef] = <int>{};
          }
          clue.solve!(puzzle, clue, possibleValue,
              possibleVariables: possibleVariables);
        } on SolveException {
          // Do nothing
        }
        if (possibleValue.isEmpty || !possibleValue.contains(value)) {
          // Failed
          return false;
        }
      }
    }
    // The sum of the primes collected is a multiple of 8ac
    var sumPrimes = usedPrimes.reduce((value, element) => value + element);
    var valueA8 = puzzle.clues['A8']!.value!;
    if (sumPrimes % valueA8 != 0) return false;
    return ok;
  }

  void manualSolve() {
    // A3 difference of two primes, so Even. (Found by solve)
    // D6 DP = A3 which is Even, and first digit ends a prime and so Odd, so D6
    // is Even and A9 starts even. (Found by solve).

    var a3 = puzzle.clues['A3']!;
    var a7 = puzzle.clues['A7']!;
    var a5 = puzzle.clues['A5']!;
    var a9 = puzzle.clues['A9']!;
    var d4 = puzzle.clues['D4']!;
    var d6 = puzzle.clues['D6']!;
    var d7 = puzzle.clues['D7']!;
    var d8 = puzzle.clues['D8']!;
    var newA3 = <int>{};
    var newA5 = <int>{};
    var newA7 = <int>{};
    var newA9 = <int>{};
    var newD4 = <int>{};
    var newD6 = <int>{};
    var newD7 = <int>{};
    var newD8 = <int>{};
    for (var valueA7 in a7.values!) {
      for (var valueA9 in a9.values!) {
        // A3 = A7-A9
        var valueA3 = valueA7 - valueA9;
        if (valueA3 < 10) continue;
        // D8 = A3+A7
        var valueD8 = valueA3 + valueA7;
        if (valueD8 == valueA9) continue;
        if (valueD8 > 99) continue;
        if (![1, 3, 7, 9].contains(valueD8 % 10)) continue;
        // D4 prime = last digits of A3 and A7
        var valueD4 = (valueA3 % 10) * 10 + valueA7 % 10;
        if (!d4.values!.contains(valueD4)) continue;
        if (valueD4 == valueA3) continue;
        if (valueD4 == valueA7) continue;
        if (valueD4 == valueA9) continue;
        if (valueD4 == valueD8) continue;
        // D6 DP = A3
        for (var valueD6 in d6.values!) {
          if (valueD6 % 10 != valueA9 ~/ 10) continue;
          var dp = digitProduct(valueD6);
          if (dp != valueA3) continue;
          if (valueD6 == valueA3) continue;
          if (valueD6 == valueA7) continue;
          if (valueD6 == valueA9) continue;
          if (valueD6 == valueD4) continue;
          if (valueD6 == valueD8) continue;
          for (var valueA5 in a5.values!) {
            if (valueA5 % 10 != valueD6 ~/ 10) continue;
            if (valueA5 == valueA3) continue;
            if (valueA5 == valueA7) continue;
            if (valueA5 == valueA9) continue;
            if (valueA5 == valueD4) continue;
            if (valueA5 == valueD6) continue;
            if (valueA5 == valueD8) continue;
            for (var valueD7 in d7.values!) {
              if (valueD7 ~/ 100 != valueA7 ~/ 10) continue;
              if (valueD7 ~/ 10 % 10 != valueA9 % 10) continue;
              if (valueD7 % valueA5 != 0) continue;
              print(
                  'A3=$valueA3, A5=$valueA5, A7=$valueA7, A9=$valueA9, D4=$valueD4, D6=$valueD6, D7=$valueD7, D8=$valueD8');
              newA3.add(valueA3);
              newA5.add(valueA5);
              newA7.add(valueA7);
              newA9.add(valueA9);
              newD4.add(valueD4);
              newD6.add(valueD6);
              newD7.add(valueD7);
              newD8.add(valueD8);
            }
          }
        }
      }
    }
    a3.values = newA3;
    a5.values = newA5;
    a7.values = newA7;
    a9.values = newA9;
    d4.values = newD4;
    d6.values = newD6;
    d7.values = newD7;
    d8.values = newD8;
    return;
  }
}
