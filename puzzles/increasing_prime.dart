// ignore_for_file: unused_import

import 'package:collection/collection.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';
import 'package:crossnumber/src/utils/set.dart';

PuzzleDefinition increasingPrimes() {
// Ten Increasing Clues by Nod

// Each answer may be expressed as p1 x p2 x p3 where the pi are distinct primes
// and come from the set {3, 5, 11, 17, 23}. The answers to the clues are in
// ascending order. Upper case letters denote across entries and lower case down
// entries. The usual rules o f algebra apply, entries are distinct and there are
// no zeros in the grid.

  var gridString = [
    '+--+--+--+--+--+',
    '|A :a :b |B :c |',
    '+--+::+::+--+::+',
    '|C :  |D :d :  |',
    '+--+::+--+::+::+',
    '|e |E :f :  :  |',
    '+::+--+::+--+::+',
    '|F :g :  :h |  |',
    '+::+::+--+::+--+',
    '|G :  :j |H :  |',
    '+::+--+::+::+--+',
    '|J :  |K :  :  |',
    '+--+--+--+--+--+',
  ];

  var puzzle = PuzzleDefinition.fromString(
    name: 'IncreasingPrimes',
    mappingIsKnown: true, // No mapping of Clues to Entries needed
    gridString: gridString.join('\n'),
    clues: {
      'I': Clue('I', [ExpressionConstraint(r'j*( f - C )')]),
      'II': Clue('II', [ExpressionConstraint(r'C + e - g - h')]),
      'III': Clue('III', [ExpressionConstraint(r'G - 2*b')]),
      'IV': Clue('IV', [ExpressionConstraint(r'G - J + K')]),
      'V': Clue('V', [ExpressionConstraint(r'D - H - j')]),
      'VI': Clue('VI', [ExpressionConstraint(r'A + B - K')]),
      'VII': Clue('VII', [ExpressionConstraint(r'd + e - K')]),
      'VIII': Clue('VIII', [ExpressionConstraint(r'F - a - H')]),
      'IX': Clue('IX', [ExpressionConstraint(r'b + E - G')]),
      'X': Clue('X', [ExpressionConstraint(r'C + c + h')]),
    },
    variables: {},
  );
  setAnswers(puzzle);

  // Initialise the clues
  initialiseClues(puzzle, traceSolve: true);

  return puzzle;
}

List<int> primes = [3, 5, 11, 17, 23];
List<int> getPrimes() {
  return primes;
}

List<int> product3Primes = [];
Map<int, List<int>> product3PrimesList = {};
List<int> getProduct3Primes() {
  if (product3Primes.isEmpty) {
    for (var f1 in getPrimes()) {
      for (var f2 in getPrimes().where((f2) => f2 > f1)) {
        for (var f3 in getPrimes().where((f3) => f3 > f2)) {
          var product = f1 * f2 * f3;
          product3Primes.add(product);
          product3PrimesList[product] = [f1, f2, f3];
        }
      }
    }
    product3Primes.sort();
  }
  return product3Primes;
}

bool check3Primes(int product) {
  if (!getProduct3Primes().contains(product)) return false;
  return true;
}

void initialiseClues(PuzzleDefinition puzzle, {traceSolve = false}) {
  // Initialise clue values
  var numClues = puzzle.clues.length;
  var products = getProduct3Primes();
  for (var clue in puzzle.clues.values) {
    var clueIndex = romanToDecimal(clue.id);
    clue.possibleValues = Set.from(products.whereIndexed((index, element) =>
        index >= clueIndex - 1 &&
        index <= clueIndex + products.length - numClues - 1));
    if (traceSolve) {
      print(
          'solve: ${clue.runtimeType} ${clue.id} values=${clue.possibleValues!.toShortString()}');
    }
  }
}

int romanToDecimal(String str) {
  int value(String r) {
    if (r == 'I' || r == 'i') return 1;
    if (r == 'V' || r == 'v') return 5;
    if (r == 'X' || r == 'x') return 10;
    if (r == 'L' || r == 'l') return 50;
    if (r == 'C' || r == 'c') return 100;
    if (r == 'D' || r == 'd') return 500;
    if (r == 'M' || r == 'm') return 1000;
    return -1;
  }

  int res = 0;
  for (int i = 0; i < str.length; i++) {
    int s1 = value(str[i]);
    if (i + 1 < str.length) {
      int s2 = value(str[i + 1]);
      if (s1 >= s2) {
        res = res + s1;
      } else {
        res = res + s2 - s1;
        i++;
      }
    } else {
      res = res + s1;
    }
  }
  return res;
}

void setAnswers(PuzzleDefinition puzzle) {
  // puzzle.clues['1A']!.answer = 113;
  puzzle.clues['I']!.answer = 165;
  puzzle.clues['II']!.answer = 255;
  puzzle.clues['III']!.answer = 345;
  puzzle.clues['IV']!.answer = 561;
  puzzle.clues['V']!.answer = 759;
  puzzle.clues['VI']!.answer = 935;
  puzzle.clues['VII']!.answer = 1173;
  puzzle.clues['VIII']!.answer = 1265;
  puzzle.clues['IX']!.answer = 1955;
  puzzle.clues['X']!.answer = 4301;
  puzzle.entries['A']!.answer = 984;
  puzzle.entries['a']!.answer = 812;
  puzzle.entries['b']!.answer = 48;
  puzzle.entries['B']!.answer = 83;
  puzzle.entries['c']!.answer = 3287;
  puzzle.entries['C']!.answer = 21;
  puzzle.entries['D']!.answer = 862;
  puzzle.entries['d']!.answer = 64;
  puzzle.entries['e']!.answer = 1241;
  puzzle.entries['E']!.answer = 2348;
  puzzle.entries['f']!.answer = 36;
  puzzle.entries['F']!.answer = 2169;
  puzzle.entries['g']!.answer = 14;
  puzzle.entries['h']!.answer = 993;
  puzzle.entries['G']!.answer = 441;
  puzzle.entries['j']!.answer = 11;
  puzzle.entries['H']!.answer = 92;
  puzzle.entries['J']!.answer = 12;
  puzzle.entries['K']!.answer = 132;
}
