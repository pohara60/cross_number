/*
Primania by Arden

The prime factors of each of the numbers given below must be found. Each value is the product of a 2-digit prime and a 3-digit prime. The factors must be used as the down entries in the diagram. Across entries are prime both forwards and backwards. All entries are distinct.



Clues
*/

// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:math';

import 'package:crossnumber/src/expressions/generators.dart';
import 'package:crossnumber/src/expressions/monadic.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition primania() {
  // ABCD by Nod

  // A, B, C and D are four primes such that D > C > B > A. The normal rules of
  // algebra apply, all entries are distinct and no entry starts with zero.

  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '+1 :2 :3 :4 |5 |6 :7 :8 +',
    '+::+::+::+::+::+::+::+::+',
    '+9 :  |10:  :  :  |  |  +',
    '+::+--+::+--+::+--+::+--+',
    '+11:12:  |13|  |14:  :15+',
    '+--+::+--+::+--+::+--+::+',
    '+16|  |17:  :18:  |19:  +',
    '+::+::+::+::+::+::+::+::+',
    '+20:  :  |  |21:  :  :  +',
    '+--+--+--+--+--+--+--+--+',
  ];

  // Register puzzle specific functions
  final MonadicFunctionRegistry monadicFunctionRegistry =
      MonadicFunctionRegistry();
  monadicFunctionRegistry.registerFunction('firstfactor',
      (values, {int? min, int? max}) => getNthPrimeFactorList(values, 1));
  monadicFunctionRegistry.registerFunction('secondfactor',
      (values, {int? min, int? max}) => getNthPrimeFactorList(values, 2));

  final reversiblePrimes2Digits = getReversiblePrimesNDigits(2);
  final reversiblePrimes3Digits = getReversiblePrimesNDigits(3);
  final reversiblePrimes4Digits = getReversiblePrimesNDigits(4);
  print('reversiblePrimes2Digits = $reversiblePrimes2Digits');
  print('reversiblePrimes3Digits = $reversiblePrimes3Digits');
  print('reversiblePrimes4Digits = $reversiblePrimes4Digits');

  final puzzle = PuzzleDefinition.fromString(
    name: 'Primania',
    mappingIsKnown: false,
    gridString: gridString.join('\n'),
    entries: {
      'A1': Entry(
          id: 'A1',
          constraints: [ExpressionConstraint(r"$isPrime A1 & $isPrime 'A1")]),
      'A6': Entry(
          id: 'A6',
          constraints: [ExpressionConstraint(r"$isPrime A6 & $isPrime 'A6")]),
      'A9': Entry(
          id: 'A9',
          constraints: [ExpressionConstraint(r"$isPrime A9 & $isPrime 'A9")]),
      'A10': Entry(
          id: 'A10',
          constraints: [ExpressionConstraint(r"$isPrime A10 & $isPrime 'A10")]),
      'A11': Entry(
          id: 'A11',
          constraints: [ExpressionConstraint(r"$isPrime A11 & $isPrime 'A11")]),
      'A14': Entry(
          id: 'A14',
          constraints: [ExpressionConstraint(r"$isPrime A14 & $isPrime 'A14")]),
      'A17': Entry(
          id: 'A17',
          constraints: [ExpressionConstraint(r"$isPrime A17 & $isPrime 'A17")]),
      'A19': Entry(
          id: 'A19',
          constraints: [ExpressionConstraint(r"$isPrime A19 & $isPrime 'A19")]),
      'A20': Entry(
          id: 'A20',
          constraints: [ExpressionConstraint(r"$isPrime A20 & $isPrime 'A20")]),
      'A21': Entry(
          id: 'A21',
          constraints: [ExpressionConstraint(r"$isPrime A21 & $isPrime 'A21")]),
    },
    clues: {
      '1D': Clue('1D', [ExpressionConstraint(r"$firstfactor 10109")]),
      '2D': Clue('2D', [ExpressionConstraint(r"$secondfactor 10109")]),
      '3D': Clue('3D', [ExpressionConstraint(r"$firstfactor 14687")]),
      '4D': Clue('4D', [ExpressionConstraint(r"$secondfactor 14687")]),
      '5D': Clue('5D', [ExpressionConstraint(r"$firstfactor 15479")]),
      '6D': Clue('6D', [ExpressionConstraint(r"$secondfactor 15479")]),
      '7D': Clue('7D', [ExpressionConstraint(r"$firstfactor 22681")]),
      '8D': Clue('8D', [ExpressionConstraint(r"$secondfactor 22681")]),
      '9D': Clue('9D', [ExpressionConstraint(r"$firstfactor 24067")]),
      '10D': Clue('10D', [ExpressionConstraint(r"$secondfactor 24067")]),
      '11D': Clue('11D', [ExpressionConstraint(r"$firstfactor 25043")]),
      '12D': Clue('12D', [ExpressionConstraint(r"$secondfactor 25043")]),
      '13D': Clue('13D', [ExpressionConstraint(r"$firstfactor 30167")]),
      '14D': Clue('14D', [ExpressionConstraint(r"$secondfactor 30167")]),
      '15D': Clue('15D', [ExpressionConstraint(r"$firstfactor 38179")]),
      '16D': Clue('16D', [ExpressionConstraint(r"$secondfactor 38179")]),
    },
    variables: {},
  );
  setAnswers(puzzle);
  return puzzle;
}

List<int> getNthPrimeFactorList(List<int> values, int n) {
  return values
      .map((v) => getNthPrimeFactor(v, n))
      .where((v) => v != null)
      .map((v) => v as int)
      .toList();
}

int? getNthPrimeFactor(int value, int n) {
  int remaining = value;
  int index = 0;
  while (remaining > 1) {
    var prime = true;
    for (var factor = 2; factor <= sqrt(remaining); factor++) {
      var divisor = remaining / factor;
      if (divisor.toInt() == divisor) {
        index++;
        if (index == n) return factor;
        remaining = divisor.toInt();
        prime = false;
        break;
      }
    }
    if (prime) break;
  }
  if (remaining != 1) {
    index++;
    if (index == n) return remaining;
  }

  return null;
}

PrimeGenerator? primeGenerator;

List<int> getReversiblePrimesNDigits(int n) {
  primeGenerator ??= GeneratorRegistry().get('prime') as PrimeGenerator;
  var min = pow(10, n - 1).toInt();
  var max = pow(10, n).toInt() - 1;
  var primes = primeGenerator!.getValues(min, max);
  return primes.where((p) {
    var s = p.toString();
    var rs = s.split('').reversed.join('');
    return s != rs && primes.contains(int.parse(rs));
  }).toList();
}

void setAnswers(PuzzleDefinition puzzle) {
  puzzle.clues['1D']!.answer = 11;
  puzzle.clues['1D']!.answer = 11;
  puzzle.clues['2D']!.answer = 919;
  puzzle.clues['3D']!.answer = 19;
  puzzle.clues['4D']!.answer = 773;
  puzzle.clues['5D']!.answer = 23;
  puzzle.clues['6D']!.answer = 673;
  puzzle.clues['7D']!.answer = 37;
  puzzle.clues['8D']!.answer = 613;
  puzzle.clues['9D']!.answer = 41;
  puzzle.clues['10D']!.answer = 587;
  puzzle.clues['11D']!.answer = 79;
  puzzle.clues['12D']!.answer = 317;
  puzzle.clues['13D']!.answer = 97;
  puzzle.clues['14D']!.answer = 311;
  puzzle.clues['15D']!.answer = 73;
  puzzle.clues['16D']!.answer = 523;
}
