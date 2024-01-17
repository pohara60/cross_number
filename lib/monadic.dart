import 'dart:math';

import 'package:powers/powers.dart';

import 'generators.dart';

typedef MonadicFunc = dynamic Function(int arg);

class Monadic {
  String name;
  MonadicFunc func;
  Type type;
  Monadic(this.name, this.func, this.type);
}

void initializeMonadics(Map<String, Monadic> monadics) {
  monadics['ds'] = Monadic('ds', digitSum, int);
  monadics['dp'] = Monadic('dp', digitProduct, int);
  monadics['mp'] = Monadic('mp', multiplicativePersistence, int);
  monadics['reverse'] = Monadic('reverse', reverse, int);
  monadics['sumdigits'] = Monadic('sumdigits', sumDigits, int);
  monadics['square'] = Monadic('square', square, int);
  monadics['cube'] = Monadic('cube', cube, int);
  monadics['even'] = Monadic('even', isEven, bool);
  monadics['odd'] = Monadic('odd', isOdd, bool);
  monadics['ascending'] = Monadic('ascending', isAscending, bool);
  monadics['descending'] = Monadic('descending', isDescending, bool);
  monadics['palindrome'] = Monadic('palindrome', isPalindrome, bool);
  monadics['notpalindrome'] = Monadic('notpalindrome', isNotPalindrome, bool);
  monadics['odd'] = Monadic('odd', isOdd, bool);
  monadics['prime'] = Monadic('prime', isPrime, bool);
  monadics['adjacentprime'] =
      Monadic('adjacentprime', isAdjacentPrime, Iterable<int>);
  monadics['multiple'] = Monadic('multiple', multiple, Iterable<int>);
  monadics['greaterthan'] = Monadic('greaterthan', greaterthan, Iterable<int>);
  monadics['greaterthanequal'] =
      Monadic('greaterthanequal', greaterthanequal, Iterable<int>);
  monadics['lessthan'] = Monadic('lessthan', lessthan, Iterable<int>);
  monadics['lessthanequal'] =
      Monadic('lessthanequal', lessthanequal, Iterable<int>);
  monadics['gt'] = Monadic('gt', greaterthan, Iterable<int>);
  monadics['gte'] = Monadic('gte', greaterthanequal, Iterable<int>);
  monadics['lt'] = Monadic('lt', lessthan, Iterable<int>);
  monadics['lte'] = Monadic('lte', lessthanequal, Iterable<int>);
  monadics['jumble'] = Monadic('jumble', jumble, Iterable<int>);
  monadics['factor'] = Monadic('factor', factors, Iterable<int>);
  monadics['divisor'] = Monadic('divisor', divisors, Iterable<int>);
}

int digitSum(int value) {
  var digits = value.toString().split('').map((e) => int.parse(e));
  var result =
      digits.fold<int>(0, (previousValue, element) => previousValue + element);
  return result;
}

int digitProduct(int value) {
  var digits = value.toString().split('').map((e) => int.parse(e));
  var result =
      digits.fold<int>(1, (previousValue, element) => previousValue * element);
  return result;
}

int multiplicativePersistence(int value) {
  var next = value;
  var result = 0;
  while (next > 9) {
    next = digitProduct(next);
    result++;
  }
  return result;
}

int reverse(int value) {
  var valueStr = value.toString();
  var reverse = '';
  for (var index = 0; index < valueStr.length; index++) {
    reverse = valueStr[index] + reverse;
  }
  return int.parse(reverse);
}

int sumDigits(int value) {
  var valueStr = value.toString();
  var sumDigits = 0;
  for (var index = 0; index < valueStr.length; index++) {
    sumDigits += int.parse(valueStr[index]);
  }
  return sumDigits;
}

int square(int value) {
  var result = value * value;
  return result;
}

int cube(int value) {
  var result = value * value * value;
  return result;
}

bool isEven(int value) {
  var result = value % 2 == 0;
  return result;
}

bool isOdd(int value) {
  var result = value % 2 == 1;
  return result;
}

bool ascending(int value) => isAscending(value);
bool isAscending(int value) {
  var valueStr = value.toString();
  var last = 0;
  for (var index = 0; index < valueStr.length; index++) {
    var next = int.parse(valueStr[index]);
    if (next <= last) return false;
    last = next;
  }
  return true;
}

bool descending(int value) => isDescending(value);
bool isDescending(int value) {
  var valueStr = value.toString();
  var last = 10;
  for (var index = 0; index < valueStr.length; index++) {
    var next = int.parse(valueStr[index]);
    if (next >= last) return false;
    last = next;
  }
  return true;
}

bool isNotPalindrome(int value) => !isPalindrome(value);
bool isPalindrome(int value) {
  var valueStr = value.toString();
  for (var index = 0; index < valueStr.length ~/ 2; index++) {
    if (valueStr[index] != valueStr[valueStr.length - index - 1]) return false;
  }
  return true;
}

Iterable<int> multiple(int value) sync* {
  int last = value;
  while (true) {
    last += value;
    yield last;
  }
}

Iterable<int> greaterthan(int value) sync* {
  int last = value;
  while (true) {
    last += 1;
    yield last;
  }
}

Iterable<int> greaterthanequal(int value) sync* {
  int last = value;
  while (true) {
    yield last;
    last += 1;
  }
}

Iterable<int> lessthan(int value) sync* {
  int last = value;
  while (true) {
    last -= 1;
    if (last < 1) break;
    yield last;
  }
}

Iterable<int> lessthanequal(int value) sync* {
  int last = value;
  while (true) {
    if (last < 1) break;
    yield last;
    last -= 1;
  }
}

Iterable<int> jumble(int value) sync* {
  var strValue = value.toString();
  yield* jumbleStr(value, 0, strValue);
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
Iterable<int> jumbleStr(int value, int leftValue, String strValue) sync* {
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
      yield* jumbleStr(value, leftValue + chrVal, rest);
    }
  }
}

Iterable<int> getFactors(int value) => factors(value);
Iterable<int> factors(int value) sync* {
  var remaining = value;
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

Iterable<int> divisors(int value) sync* {
  var factor = factors(value).toList();
  if (factor.length == 1) return; // Prime!

  var divisors = <int>{};
  void getCombinations(int partial, List<int> numbers, List<bool> taken,
      int remaining, Set<int> combinations) {
    for (var index = 0; index < numbers.length; index++) {
      if (!taken[index]) {
        int next = partial * numbers[index];
        combinations.add(next);
        if (remaining > 2) {
          taken[index] = true;
          getCombinations(next, numbers, taken, remaining - 1, combinations);
          taken[index] = false;
        }
      }
    }
  }

  var taken = List.filled(factor.length, false);
  getCombinations(1, factor, taken, factor.length, divisors);
  var result = divisors.toList()..sort();
  yield* result;
  return;
}

bool twoDigitPrimeHasReverse(int prime) {
  return primeHasReverse(prime, twoDigitPrimes);
}

bool primeHasReverse(int prime, List<int> primes) {
  var other = reverse(prime);
  return primes.contains(other) && other != prime;
}

bool isJumble(int value, int jumble) {
  var valueStr = value.toString();
  var jumbleStr = jumble.toString();
  for (var index = 0; index < valueStr.length; index++) {
    if (!jumbleStr.contains(valueStr[index])) return false;
    jumbleStr.replaceFirst(RegExp(valueStr[index]), '');
  }
  return true;
}
