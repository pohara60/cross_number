// cspell: disable
import 'package:expressions/expressions.dart';

import "onesumamuse_sum_squares.dart";
// ignore: avoid_relative_lib_imports
import '../lib/src/backtracking_solver.dart';

/*
      A = sum3digitsquares(e,G,L) = sum3digitsquares(b,'G,H+j)
      a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
      d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
      N = sum3digitsquares(7*D/12,G,g) = sum3digitsquares(f-b/2,'G,K)
   In each clue the first three elements are 3-digit numbers that together comprise the nine non-zero digits. The
   fourth element is the sum of the squares of the other three.
   Clues are given in pairs, in each pair one set of 3-digit numbers are the reverses of the other set.
*/

// allArgs
// B, C, g, G, h, J, K, M,
// e, L, b
// 100-999
// D, E
// c, f, j
// 10-99
// F, H

// Order is
var expressableOrder = 'G,e,L,b,H,j,A,C,B,J,M,c,a,h,E,f,F,d,D,g,K,N'.split(',');

Set<int> getValues(BacktrackingSolver solver, Expressable expressable) {
  var id = expressable.id;
  var expressableValues = solver.expressableValues;
  var possibleValues = expressable.possibleValues;
  switch (id) {
    case 'e':
      var G = expressableValues['G']!;
      // A = sum3digitsquares(e,G,L) = sum3digitsquares(b,'G,H+j)
      var arg23 = getOthersForOne(G);
      possibleValues = possibleValues.where((value) => arg23.contains(value)).toSet();
      break;
    case 'L':
      var e = expressableValues['e']!;
      var G = expressableValues['G']!;
      // A = sum3digitsquares(e,G,L) = sum3digitsquares(b,'G,H+j)
      var arg3 = getRemainingForTwo(e, G);
      possibleValues = possibleValues.where((value) => arg3.contains(value)).toSet();
      break;
    case 'b':
      possibleValues = possibleValues.where((value) => value % 2 == 0).toSet();
      // A = sum3digitsquares(e,G,L) = sum3digitsquares(b,'G,H+j)
      var G = expressableValues['G']!;
      var arg3 = getOthersForOne(reverse(G));
      possibleValues = possibleValues.where((value) => arg3.contains(value)).toSet();
      break;
    case 'j':
      // var e = expressableValues['e']!;
      var G = expressableValues['G']!;
      // var L = expressableValues['L']!;
      var b = expressableValues['b']!;
      var H = expressableValues['H']!;
      // A = sum3digitsquares(e,G,L) = sum3digitsquares(b,'G,H+j)
      var arg3 = getRemainingForTwo(b, reverse(G));
      possibleValues = possibleValues.where((value) => arg3.contains(H + value)).toSet();
      break;
    case 'C':
      var G = expressableValues['G']!;
      // a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
      var arg23 = getOthersForOne(G);
      possibleValues = possibleValues.where((value) => arg23.contains(value)).toSet();
      break;
    case 'B':
      var G = expressableValues['G']!;
      var C = expressableValues['C']!;
      // a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
      var arg3 = getRemainingForTwo(G, C);
      possibleValues = possibleValues.where((value) => arg3.contains(value)).toSet();
      break;
    case 'J':
      var G = expressableValues['G']!;
      // a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
      var arg23 = getOthersForOne(reverse(G));
      possibleValues = possibleValues.where((value) => arg23.contains(value)).toSet();
      break;
    case 'M':
      var G = expressableValues['G']!;
      var arg23 = getOthersForOne(G);
      possibleValues = possibleValues.where((value) => arg23.contains(value)).toSet();
      break;
    case 'c':
      var G = expressableValues['G']!;
      var J = expressableValues['J']!;
      var M = expressableValues['M']!;
      var arg3 = getRemainingForTwo(reverse(G), J);
      possibleValues = possibleValues.where((value) => arg3.contains(M - value)).toSet();
      break;
    case 'a':
      break;
    case 'h':
      var G = expressableValues['G']!;
      var M = expressableValues['M']!;
      // d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
      var arg3 = getRemainingForTwo(G, M);
      possibleValues = possibleValues.where((value) => arg3.contains(value)).toSet();
      break;
    case 'E':
      var c = expressableValues['c']!;
      var digit1 = c.toString()[2];
      possibleValues = possibleValues.where((value) => value.toString()[1] == digit1).toSet();
      break;
    case 'f':
      var E = expressableValues['E']!;
      var G = expressableValues['G']!;
      var H = expressableValues['H']!;
      // d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
      var arg23 = getOthersForOne(reverse(G));
      possibleValues = possibleValues.where((value) => arg23.contains(E + H + value)).toSet();
      // N = sum3digitsquares(7*D/12,G,g) = sum3digitsquares(f-b/2,'G,K)
      var b = expressableValues['b']!;
      possibleValues = possibleValues.where((value) => arg23.contains(value - (b / 2).toInt())).toSet();
      break;
    case 'F':
      var E = expressableValues['E']!;
      var f = expressableValues['f']!;
      var H = expressableValues['H']!;
      var G = expressableValues['G']!;
      var L = expressableValues['L']!;
      // d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
      var arg3 = getRemainingForTwo(E + f + H, reverse(G));
      possibleValues = possibleValues.where((value) => arg3.contains(L - value)).toSet();
      break;
    case 'd':
      break;
    // a, e, b
    case 'D':
      possibleValues = possibleValues.where((value) => value % 12 == 0).toSet();
      var G = expressableValues['G']!;
      var arg23 = getOthersForOne(G);
      possibleValues = possibleValues.where((value) => arg23.contains((7 * value / 12).toInt())).toSet();
      break;
    case 'g':
      var G = expressableValues['G']!;
      var D = expressableValues['D']!;
      var arg3 = getRemainingForTwo(G, (7 * D / 12).toInt());
      possibleValues = possibleValues.where((value) => arg3.contains(value)).toSet();
      break;
    case 'K':
      var G = expressableValues['G']!;
      var f = expressableValues['f']!;
      var b = expressableValues['b']!;
      var arg3 = getRemainingForTwo(reverse(G), f - (b / 2).toInt());
      possibleValues = possibleValues.where((value) => arg3.contains(value)).toSet();
      break;
    case 'N':
      break;
    default:
  }
  return possibleValues;
}

class MyExpressionEvaluator extends ExpressionEvaluator {
  const MyExpressionEvaluator();

  @override
  dynamic evalMemberExpression(MemberExpression expression, Map<String, dynamic> context) {
    var object = eval(expression.object, context);
    if (expression.property.name == 'contains') return object.contains;
    throw ArgumentError('Unknown member ${expression.object.toString()}${expression.property.name} in expression');
  }
}

int sumSquares(num a, num b, num c) => (a != a.toInt() || b != b.toInt() || c != c.toInt())
    ? 0
    : (a.toInt() * a.toInt() + b.toInt() * b.toInt() + c.toInt() * c.toInt());

bool isThreeDigits(num x) => x == x.toInt() && x >= 100 && x <= 999;

bool checkValue(BacktrackingSolver solver, Expressable expressable, int value) {
  return true;
}

CheckValue getCheckValue(String expressionString) {
  return (BacktrackingSolver solver, Expressable expressable, int value) {
    var id = expressable.id;
    var expressableValues = solver.expressableValues;
    bool evaluateExpression(String expressionString) {
      var expression = Expression.parse(expressionString);
      final evaluator = const MyExpressionEvaluator();
      expressableValues[id] = value;
      expressableValues['reverse'] = reverse;
      expressableValues['sumSquares'] = sumSquares;
      expressableValues['sumOfSquares'] = sumOfSquares;
      expressableValues['isThreeDigits'] = isThreeDigits;
      var result = evaluator.eval(expression, expressableValues);
      expressableValues.remove('isThreeDigits');
      expressableValues.remove('sumOfSquares');
      expressableValues.remove('sumSquares');
      expressableValues.remove('reverse');
      expressableValues.remove(id);
      return result;
    }

    var result = evaluateExpression(expressionString);
    return result;
  };
}

void main(List<String> args) {
  computeSumOfSquares();
  var any3DigitValue = List.generate(900, (i) => 100 + i).toSet();
  var any2DigitValue = List.generate(90, (i) => 10 + i).toSet();

/*
      A = sum3digitsquares(e,G,L) = sum3digitsquares(b,'G,H+j)
      a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
      d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
      N = sum3digitsquares(7*D/12,G,g) = sum3digitsquares(f-b/2,'G,K)
   In each clue the first three elements are 3-digit numbers that together comprise the nine non-zero digits. The
   fourth element is the sum of the squares of the other three.
   Clues are given in pairs, in each pair one set of 3-digit numbers are the reverses of the other set.
*/
  var expressables = <String, Expressable>{};
  expressables['A'] = Expressable(
      checkValue: getCheckValue('A == sumSquares(e,G,L)'),
      getValues: getValues,
      id: 'A',
      intersections: [
        Intersection(0, 'a', 0),
        Intersection(2, 'b', 0),
        Intersection(4, 'c', 0),
        Intersection(6, 'd', 0)
      ],
      possibleValues: sumOfSquares);
  expressables['B'] = Expressable(
      checkValue: getCheckValue('sumOfSquares.contains(sumSquares(C,B,G))'),
      getValues: getValues,
      id: 'B',
      intersections: [Intersection(0, 'e', 0), Intersection(1, 'b', 1)],
      possibleValues: allArgs);
  expressables['C'] = Expressable(
      getValues: getValues,
      id: 'C',
      intersections: [Intersection(0, 'c', 1), Intersection(2, 'd', 1)],
      possibleValues: allArgs);
  expressables['D'] = Expressable(
      checkValue: getCheckValue('isThreeDigits(7*D/12)'),
      getValues: getValues,
      id: 'D',
      intersections: [Intersection(0, 'a', 2), Intersection(1, 'e', 1), Intersection(2, 'b', 2)],
      possibleValues: any3DigitValue);
  expressables['E'] = Expressable(
      getValues: getValues,
      id: 'E',
      intersections: [Intersection(0, 'f', 0), Intersection(1, 'c', 2)],
      possibleValues: any3DigitValue);
  expressables['F'] = Expressable(
      checkValue: getCheckValue(
          'isThreeDigits(E+f+H) && isThreeDigits(L-F) && sumSquares(G,h,M)==sumSquares(E+f+H,reverse(G),L-F)'),
      getValues: getValues,
      id: 'F',
      intersections: [Intersection(0, 'a', 3), Intersection(1, 'e', 2)],
      possibleValues: any2DigitValue);
  expressables['G'] =
      Expressable(getValues: getValues, id: 'G', intersections: [Intersection(1, 'f', 1)], possibleValues: gArg);
  expressables['H'] = Expressable(
      getValues: getValues,
      id: 'H',
      intersections: [Intersection(0, 'g', 0), Intersection(1, 'd', 3)],
      possibleValues: any2DigitValue);
  expressables['J'] = Expressable(
      getValues: getValues,
      id: 'J',
      intersections: [Intersection(1, 'h', 0), Intersection(2, 'f', 2)],
      possibleValues: allArgs);
  expressables['K'] = Expressable(
      getValues: getValues,
      id: 'K',
      intersections: [Intersection(0, 'j', 0), Intersection(1, 'g', 1), Intersection(2, 'd', 4)],
      possibleValues: allArgs);
  expressables['L'] = Expressable(
      checkValue: getCheckValue('sumOfSquares.contains(sumSquares(e,G,L))'),
      getValues: getValues,
      id: 'L',
      intersections: [Intersection(0, 'a', 5), Intersection(2, 'h', 1)],
      possibleValues: allArgs);
  expressables['M'] = Expressable(
      getValues: getValues,
      id: 'M',
      intersections: [Intersection(1, 'j', 1), Intersection(2, 'g', 1)],
      possibleValues: allArgs);
  expressables['N'] = Expressable(
      checkValue: getCheckValue('N == sumSquares(7*D/12,G,g)'),
      getValues: getValues,
      id: 'N',
      intersections: [
        Intersection(0, 'a', 6),
        Intersection(2, 'h', 2),
        Intersection(4, 'j', 2),
        Intersection(6, 'd', 6)
      ],
      possibleValues: sumOfSquares);
  expressables['a'] = Expressable(
      checkValue: getCheckValue('a == sumSquares(C,B,G)'),
      getValues: getValues,
      id: 'a',
      intersections: [
        Intersection(0, 'A', 0),
        Intersection(2, 'D', 0),
        Intersection(3, 'E', 0),
        Intersection(5, 'L', 0),
        Intersection(6, 'N', 0)
      ],
      possibleValues: sumOfSquares);
  expressables['b'] = Expressable(
      checkValue: getCheckValue('b % 2 == 0'),
      getValues: getValues,
      id: 'b',
      intersections: [Intersection(0, 'A', 2), Intersection(1, 'B', 1)],
      possibleValues: allArgs);
  expressables['c'] = Expressable(
      checkValue: getCheckValue('isThreeDigits(M-c) && sumSquares(C,B,G)==sumSquares(reverse(G),J,M-c)'),
      getValues: getValues,
      id: 'c',
      intersections: [Intersection(0, 'A', 4), Intersection(1, 'C', 0), Intersection(2, 'E', 1)],
      possibleValues: any3DigitValue);
  expressables['d'] = Expressable(
      checkValue: getCheckValue('d == sumSquares(G,h,M)'),
      getValues: getValues,
      id: 'd',
      intersections: [
        Intersection(0, 'A', 6),
        Intersection(1, 'C', 2),
        Intersection(3, 'H', 1),
        Intersection(4, 'K', 2),
        Intersection(6, 'N', 6)
      ],
      possibleValues: sumOfSquares);
  expressables['e'] = Expressable(
      getValues: getValues,
      id: 'e',
      intersections: [Intersection(0, 'B', 0), Intersection(1, 'D', 1), Intersection(2, 'F', 1)],
      possibleValues: allArgs);
  expressables['f'] = Expressable(
      checkValue: getCheckValue('b%2==0 && isThreeDigits(f-b/2) && isThreeDigits(E+f+H)'),
      getValues: getValues,
      id: 'f',
      intersections: [Intersection(0, 'E', 0), Intersection(1, 'G', 1), Intersection(2, 'J', 2)],
      possibleValues: any3DigitValue);
  expressables['g'] = Expressable(
      checkValue: getCheckValue('sumOfSquares.contains(sumSquares(7*D/12,G,g))'),
      getValues: getValues,
      id: 'g',
      intersections: [Intersection(0, 'H', 0), Intersection(1, 'K', 1), Intersection(2, 'M', 2)],
      possibleValues: any3DigitValue);
  expressables['h'] = Expressable(
      checkValue: getCheckValue('sumOfSquares.contains(sumSquares(G,h,M))'),
      getValues: getValues,
      id: 'h',
      intersections: [Intersection(0, 'J', 1), Intersection(1, 'L', 2), Intersection(2, 'N', 2)],
      possibleValues: allArgs);
  expressables['j'] = Expressable(
      checkValue: getCheckValue('isThreeDigits(H+j) && sumSquares(e,G,L)==sumSquares(b,reverse(G),H+j)'),
      getValues: getValues,
      id: 'j',
      intersections: [Intersection(0, 'K', 0), Intersection(1, 'M', 1), Intersection(2, 'N', 4)],
      possibleValues: any3DigitValue);

  // A = sum3digitsquares(e,G,L) = sum3digitsquares(b,'G,H+j)
  // a = sum3digitsquares(C,B,G) = sum3digitsquares('G,J,M-c)
  // d = sum3digitsquares(G,h,M) = sum3digitsquares(E+f+H,'G,L-F)
  // N = sum3digitsquares(7*D/12,G,g) = sum3digitsquares(f-b/2,'G,K)
  // e, G, L, b, H, j => A
  // C, B, J, M, c => a
  // h, E, f, F => d
  // D, g, K => N

  var solver = BacktrackingSolver(expressables: expressables);
  solver.solve(trace: true, expressableOrder: expressableOrder, checkSolution: null);
}

/*
1217781
1938271
6723500
1845689
2839718
2318978
1029089
G,e,L,b,H,j,A,C,B,J,M,c,a,h,E,f,F,d,D,g,K,N'.split(',');
*/
var solutionValues = {
  'G': 456,
  'e': 978,
  'L': 231,
  'b': 132,
  'H': 89,
  'j': 790,
  'A': 1217781,
  'C': 271,
  'B': 938,
  'J': 839,
  'M': 897,
  'c': 725,
  'a': 1161221,
  'h': 312,
  'E': 350,
  'f': 359,
  'F': 18,
  'd': 1109889,
  'D': 672,
  'g': 817,
  'K': 718,
  'N': 1029089,
};

bool checkSolution(BacktrackingSolver solver) {
  var expressableValues = solver.expressableValues;

  bool checkSolutionValue(String id, int value) {
    if (expressableValues.containsKey(id)) {
      if (expressableValues[id] != value) {
        return false;
      }
    }
    return true;
  }

  for (var solutionEntry in solutionValues.entries) {
    if (!checkSolutionValue(solutionEntry.key, solutionEntry.value)) return false;
  }
  return true;
}
