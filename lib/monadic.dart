import 'dart:math';

import 'package:powers/powers.dart';

import 'expression.dart';
import 'generators.dart';

typedef MonadicFunc = dynamic Function(dynamic arg);
typedef MonadicFuncRange = dynamic Function(dynamic arg, num? min, num? max);

class Monadic {
  String name;
  MonadicFunc? func;
  MonadicFuncRange? funcRange;
  Type type;
  NodeOrder order;
  Monadic(this.name, this.func, this.type,
      {this.funcRange, this.order = NodeOrder.ASCENDING});
}

void initializeMonadics(Map<String, Monadic> monadics) {
  monadics['ds'] = Monadic('ds', digitSum, int, order: NodeOrder.UNKNOWN);
  monadics['dp'] = Monadic('dp', digitProduct, int, order: NodeOrder.UNKNOWN);
  monadics['mp'] =
      Monadic('mp', multiplicativePersistence, int, order: NodeOrder.UNKNOWN);
  monadics['reverse'] =
      Monadic('reverse', reverse, int, order: NodeOrder.UNKNOWN);
  monadics['sumdigits'] =
      Monadic('sumdigits', sumDigits, int, order: NodeOrder.UNKNOWN);
  monadics['sumdigitsquares'] = Monadic('sumdigitsquares', sumDigitSquares, int,
      order: NodeOrder.UNKNOWN);
  monadics['square'] = Monadic('square', square, int);
  monadics['squareroot'] = Monadic('squareroot', squareroot, int);
  monadics['cube'] = Monadic('cube', cube, int);
  monadics['even'] = Monadic('even', isEven, bool);
  monadics['odd'] = Monadic('odd', isOdd, bool);
  monadics['ascending'] = Monadic('ascending', isAscending, bool);
  monadics['descending'] = Monadic('descending', isDescending, bool);
  monadics['palindrome'] = Monadic('palindrome', isPalindrome, bool);
  monadics['notpalindrome'] = Monadic('notpalindrome', isNotPalindrome, bool);
  monadics['odd'] = Monadic('odd', isOdd, bool);
  monadics['prime'] = Monadic('prime', isPrime, bool);
  monadics['triangular'] = Monadic('triangular', isTriangular, bool);
  monadics['adjacentprime'] =
      Monadic('adjacentprime', isAdjacentPrime, Iterable<int>);
  monadics['multiple'] = Monadic('multiple', multiple, Iterable<int>);
  monadics['greaterthan'] = Monadic('greaterthan', greaterthan, Iterable<int>);
  monadics['greaterthanequal'] =
      Monadic('greaterthanequal', greaterthanequal, Iterable<int>);
  monadics['lessthan'] =
      Monadic('lessthan', lessthan, Iterable<int>, order: NodeOrder.DESCENDING);
  monadics['lessthanequal'] = Monadic(
      'lessthanequal', lessthanequal, Iterable<int>,
      order: NodeOrder.DESCENDING);
  monadics['gt'] = Monadic('gt', greaterthan, Iterable<int>);
  monadics['gte'] = Monadic('gte', greaterthanequal, Iterable<int>);
  monadics['lt'] =
      Monadic('lt', lessthan, Iterable<int>, order: NodeOrder.DESCENDING);
  monadics['lte'] =
      Monadic('lte', lessthanequal, Iterable<int>, order: NodeOrder.DESCENDING);
  monadics['jumble'] =
      Monadic('jumble', jumble, Iterable<int>, order: NodeOrder.UNKNOWN);
  monadics['factor'] = Monadic('factor', factors, Iterable<int>);
  monadics['divisor'] =
      Monadic('divisor', null, Iterable<int>, funcRange: divisors);
  monadics['power'] = Monadic('power', powers, Iterable<int>);
  monadics['whereds'] = Monadic(
      'whereds',
      null,
      funcRange: whereDS,
      Iterable<int>,
      order: NodeOrder.UNKNOWN);
  monadics['wheredp'] = Monadic(
      'wheredp',
      null,
      funcRange: whereDP,
      Iterable<int>,
      order: NodeOrder.UNKNOWN);
}

int digitSum(dynamic value) {
  var digits = (value as int).toString().split('').map((e) => int.parse(e));
  var result =
      digits.fold<int>(0, (previousValue, element) => previousValue + element);
  return result;
}

int digitProduct(dynamic value) {
  var digits = (value as int).toString().split('').map((e) => int.parse(e));
  var result =
      digits.fold<int>(1, (previousValue, element) => previousValue * element);
  return result;
}

int multiplicativePersistence(dynamic value) {
  var next = (value as int);
  var result = 0;
  while (next > 9) {
    next = digitProduct(next);
    result++;
  }
  return result;
}

int reverse(dynamic value) {
  var valueStr = (value as int).toString();
  var reverse = '';
  for (var index = 0; index < valueStr.length; index++) {
    reverse = valueStr[index] + reverse;
  }
  return int.parse(reverse);
  // var result = 0;
  // while (value > 0) {
  //   result = result * 10 + value % 10;
  //   value = value ~/ 10;
  // }
  // return result;
}

int sumDigits(dynamic value) {
  var valueStr = (value as int).toString();
  var sumDigits = 0;
  for (var index = 0; index < valueStr.length; index++) {
    sumDigits += int.parse(valueStr[index]);
  }
  return sumDigits;
}

int sumDigitSquares(dynamic value) {
  var valueStr = (value as int).toString();
  var sumDigitSquares = 0;
  for (var index = 0; index < valueStr.length; index++) {
    var digit = int.parse(valueStr[index]);
    sumDigitSquares += digit * digit;
  }
  return sumDigitSquares;
}

int square(dynamic value) {
  var result = (value as int) * value;
  return result;
}

int squareroot(dynamic value) {
  var result = sqrt((value as int));
  ExpressionEvaluator.checkInteger(result);
  return result.toInt();
}

int cube(dynamic value) {
  var result = (value as int) * value * value;
  return result;
}

bool isEven(dynamic value) {
  var result = (value as int) % 2 == 0;
  return result;
}

bool isOdd(dynamic value) {
  var result = (value as int) % 2 == 1;
  return result;
}

bool ascending(dynamic value) => isAscending(value);
bool isAscending(dynamic value) {
  var valueStr = (value as int).toString();
  var last = 0;
  for (var index = 0; index < valueStr.length; index++) {
    var next = int.parse(valueStr[index]);
    if (next <= last) return false;
    last = next;
  }
  return true;
}

bool descending(dynamic value) => isDescending(value);
bool isDescending(dynamic value) {
  var valueStr = (value as int).toString();
  var last = 10;
  for (var index = 0; index < valueStr.length; index++) {
    var next = int.parse(valueStr[index]);
    if (next >= last) return false;
    last = next;
  }
  return true;
}

bool isNotPalindrome(dynamic value) => !isPalindrome(value);
bool isPalindrome(dynamic value) {
  var valueStr = (value as int).toString();
  for (var index = 0; index < valueStr.length ~/ 2; index++) {
    if (valueStr[index] != valueStr[valueStr.length - index - 1]) return false;
  }
  return true;
}

Iterable<int> multiple(dynamic value) sync* {
  int last = value as int;
  while (true) {
    last += value;
    yield last;
  }
}

Iterable<int> greaterthan(dynamic value) sync* {
  int last = value;
  while (true) {
    last += 1;
    yield last;
  }
}

Iterable<int> greaterthanequal(dynamic value) sync* {
  int last = value;
  while (true) {
    yield last;
    last += 1;
  }
}

Iterable<int> lessthan(dynamic value) sync* {
  int last = value;
  while (true) {
    last -= 1;
    if (last < 1) break;
    yield last;
  }
}

Iterable<int> lessthanequal(dynamic value) sync* {
  int last = value;
  while (true) {
    if (last < 1) break;
    yield last;
    last -= 1;
  }
}

Iterable<int> jumble(dynamic value) sync* {
  var strValue = (value as int).toString();
  yield* _jumbleStr(value, 0, strValue);
}

var tens = [
  1,
  10,
  100,
  1000,
  10000,
  100000,
  1000000,
  10000000,
  100000000,
  1000000000
];
Iterable<int> _jumbleStr(int value, int leftValue, String strValue) sync* {
  for (var d = 0; d < strValue.length; d++) {
    var chr = strValue[d];
    var chrVal = int.parse(chr);
    if (strValue.length == 1) {
      if (value != leftValue + chrVal) yield leftValue + chrVal;
      return;
    }

    assert(strValue.length <= tens.length);
    chrVal *= tens[strValue.length - 1];
    if (leftValue + chrVal != 0) {
      var rest = strValue.substring(0, d) + strValue.substring(d + 1);
      yield* _jumbleStr(value, leftValue + chrVal, rest);
    }
  }
}

Iterable<int> getFactors(dynamic value) => factors(value);
Iterable<int> factors(dynamic value) sync* {
  int remaining = value;
  while (remaining > 1) {
    var prime = true;
    for (var factor = 2; factor <= sqrt(remaining); factor++) {
      var divisor = remaining / factor;
      if (divisor.isValidInteger) {
        yield factor;
        remaining = divisor.toInt();
        prime = false;
        break;
      }
    }
    if (prime) break;
  }
  if (remaining != 1) yield remaining;

  return;
}

// Iterable<int> divisors(dynamic value) sync* {
//   var factor = factors(value).toList();
//   if (factor.length == 1) return; // Prime!

//   var divisors = <int>{};
//   void getCombinations(dynamic partial, List<int> numbers, List<bool> taken,
//       int remaining, Set<int> combinations) {
//     for (var index = 0; index < numbers.length; index++) {
//       if (!taken[index]) {
//         int next = partial * numbers[index];
//         combinations.add(next);
//         if (remaining > 2) {
//           taken[index] = true;
//           getCombinations(next, numbers, taken, remaining - 1, combinations);
//           taken[index] = false;
//         }
//       }
//     }
//   }
//}

Iterable<int> divisors(dynamic value, num? min, num? max) sync* {
  var start = (value as int) % 2 == 0 ? 2 : 3;
  var end = value ~/ start;
  var inc = 1;
  if (min != null && min > start) start = min.toInt();
  if (max != null && max < end) end = max.toInt();
  for (var div = start; div <= end; div += inc) {
    if (value % div == 0) yield div;
  }
  return;
}

Iterable<int> powers(dynamic value) sync* {
  var last = (value as int);
  while (true) {
    last = last * value;
    yield last;
  }
}

Iterable<int> whereDS(dynamic ds, num? min, num? max) sync* {
  var imin = min!;
  var imax = max!;
  for (var value in generateIntegers(imin, imax)) {
    if (digitSum(value) == (ds as int)) yield value;
  }
  return;
}

Iterable<int> whereDP(dynamic dp, num? min, num? max) sync* {
  var imin = min!;
  var imax = max!;
  for (var value in generateIntegers(imin, imax)) {
    if (digitProduct(value) == (dp as int)) yield value;
  }
  return;
}

bool twoDigitPrimeHasReverse(dynamic prime) {
  return primeHasReverse(prime, twoDigitPrimes);
}

bool primeHasReverse(dynamic prime, List<int> primes) {
  var other = reverse(prime);
  return primes.contains(other) && other != prime;
}

bool isJumble(dynamic value, int jumble) {
  var valueStr = (value as int).toString();
  var jumbleStr = jumble.toString();
  for (var index = 0; index < valueStr.length; index++) {
    if (!jumbleStr.contains(valueStr[index])) return false;
    jumbleStr.replaceFirst(RegExp(valueStr[index]), '');
  }
  return true;
}
