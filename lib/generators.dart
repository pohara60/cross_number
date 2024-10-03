// ignore_for_file: constant_identifier_names

import 'dart:collection';
import 'dart:math';

import 'package:powers/powers.dart';

import 'merge.dart';
import 'monadic.dart';

typedef GeneratorFunc = Iterable<int> Function(num min, num max);

class Generator {
  String name;
  GeneratorFunc func;
  Generator(this.name, this.func);
}

void initializeGenerators(Map<String, Generator> generators) {
  generators['integer'] = Generator('integer', generateIntegers);
  generators['ascending'] = Generator('ascending', generateAscending);
  generators['descending'] = Generator('descending', generateDescending);
  generators['different'] = Generator('different', generateDifferent);
  generators['result'] = Generator('result', generateIntegers);
  generators['palindrome'] = Generator('palindrome', generatePalindromes);
  generators['harshad'] = Generator('harshad', generateHarshads);
  generators['lucas'] = Generator('lucas', generateLucas);
  generators['odd'] = Generator('odd', generateOddIntegers);
  generators['even'] = Generator('even', generateEvenIntegers);
  generators['prime'] = Generator('prime', generatePrimes);
  generators['triangular'] = Generator('triangular', generateTriangles);
  generators['pyramidal'] = Generator('pyramidal', generateSquarePyramidals);
  generators['fibonacci'] = Generator('fibonacci', generateFibonacci);
  generators['square'] = Generator('square', generateSquares);
  generators['cube'] = Generator('cube', generateCubes);
  generators['power'] = Generator('power', generatePowers);
  generators['power3'] = Generator('power3', generatePowers3);
  generators['powerof2'] = Generator('powerof2', generatePowersOf2);
  generators['product2primes'] =
      Generator('product2primes', generateProduct2Primes);
  generators['product3primes'] =
      Generator('product3primes', generateProduct3Primes);
  generators['product4primes'] =
      Generator('product4primes', generateProduct4Primes);
  generators['sumconsecutivesquares'] =
      Generator('sumconsecutivesquares', generateSumConsecutiveSquares);
  generators['sum2fibonacci'] =
      Generator('sum2fibonacci', generateSum2Fibonacci);
  generators['sum2square'] = Generator('sum2square', generateSum2Square);
}

Iterable<int> generateIntegers(num min, num max) sync* {
  for (var integer = min.toInt(); integer <= max.toInt(); integer++) {
    yield integer;
  }
}

Iterable<int> generateAscending(num min, num max) sync* {
  for (var integer = min.toInt(); integer <= max.toInt(); integer++) {
    var integerStr = integer.toString();
    if (integerStr
            .split('')
            .reduce((value, char) => char.compareTo(value) > 0 ? char : '?') !=
        '?') yield integer;
  }
}

Iterable<int> generateDescending(num min, num max) sync* {
  for (var integer = min.toInt(); integer <= max.toInt(); integer++) {
    var integerStr = integer.toString();
    if (integerStr
            .split('')
            .reduce((value, char) => char.compareTo(value) < 0 ? char : '!') !=
        '!') yield integer;
  }
}

Iterable<int> generateDifferent(num min, num max) sync* {
  for (var integer = min.toInt(); integer <= max.toInt(); integer++) {
    var integerStr = integer.toString();
    var digits = integerStr.split('');
    if (digits.length == Set.from(digits).length) yield integer;
  }
}

const powers10 = <int>[
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
Iterable<int> getPalindromes(int digits,
    [bool allowLeadingZero = false]) sync* {
  for (var digit = 0; digit < 10; digit++) {
    if (digits == 1) {
      yield digit;
    } else if (allowLeadingZero || digit != 0) {
      var head = digit * powers10[digits - 1];
      var tail = digit;
      if (digits == 2) {
        yield head + tail;
      } else {
        for (var middle in getPalindromes(digits - 2, true)) {
          yield head + middle * 10 + tail;
        }
      }
    }
  }
}

Iterable<int> generatePalindromes(num min, num max) sync* {
  var minDigits = min.toInt().toString().length;
  var maxDigits = max.toInt().toString().length;
  for (var digits = minDigits; digits <= maxDigits; digits++) {
    for (var palindrome in getPalindromes(digits)) {
      if (palindrome < min) continue;
      if (palindrome > max) break;
      yield palindrome;
    }
  }
}

Iterable<int> generateHarshads(num min, num max) sync* {
  for (var integer = min.toInt(); integer <= max.toInt(); integer++) {
    if (integer % digitSum(integer) == 0) yield integer;
  }
}

Iterable<int> generateOddIntegers(num min, num max) sync* {
  for (var integer = min.toInt(); integer <= max.toInt(); integer++) {
    if (integer % 2 == 1) yield integer;
  }
}

Iterable<int> generateEvenIntegers(num min, num max) sync* {
  for (var integer = min.toInt(); integer <= max.toInt(); integer++) {
    if (integer % 2 == 0) yield integer;
  }
}

const INITIAL_CHUNK_SIZE = 100;
const CHUNK_SIZE_MULTIPLIER = 10;
var chunkSize = INITIAL_CHUNK_SIZE;
List<int> primes = [2, 3, 5, 7];
Iterable<int> generatePrimesWithOne(num max) sync* {
  yield 1;
  yield* generatePrimes(2, max);
}

Iterable<int> generateNDigitPrimes(int n) sync* {
  num min = 10.pow(n - 1);
  num max = 10.pow(n) - 1;
  yield* generatePrimes(min, max);
}

Iterable<int> generatePrimes(num min, num max) sync* {
  var limit = max.toInt();
  var index = 0;
  while (index <= limit) {
    while (index < primes.length) {
      var element = primes[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    var next = primes.last + chunkSize;
    chunkSize *= CHUNK_SIZE_MULTIPLIER;
    extendPrimesUpto(next);
  }
}

Iterable<int> generatePrimesOver(num min) sync* {
  var index = 0;
  while (true) {
    while (index < primes.length) {
      var element = primes[index++];
      if (element < min) continue;
      yield element;
    }
    var next = primes.last + chunkSize;
    chunkSize *= CHUNK_SIZE_MULTIPLIER;
    extendPrimesUpto(next);
  }
}

bool isPrime(dynamic value) {
  extendPrimesUpto(value as int);
  var result = primes.contains(value);
  return result;
}

bool isCyclicPrime(dynamic value) {
  var valueStr = value.toString();
  for (var i = 0; i < valueStr.length; i++) {
    var cycleStr = valueStr.substring(i);
    if (i > 0) cycleStr += valueStr.substring(0, i);
    if (cycleStr[0] != '0') {
      var cycle = int.parse(cycleStr);
      extendPrimesUpto(cycle);
      if (primes.contains(cycle)) {
        return true;
      }
    }
  }
  return false;
}

Iterable<int> isAdjacentPrime(dynamic value) sync* {
  extendPrimesUpto((value as int) * 2);
  var index = primes.indexOf(value);
  if (index > 0) {
    yield primes[index - 1];
    if (index < primes.length - 1) yield primes[index + 1];
  }
}

void extendPrimesUpto(int limit) {
  var lo = primes.last ~/ 2;
  var hi = limit ~/ 2 - lo;
  if (hi <= 0) return;

  List<int> sieve = List.generate(hi, (i) => 2 * (lo + i) + 3);
  for (var i = 0; i < hi; i++) {
    if (sieve[i] != 0) {
      for (var p in primes) {
        if (sieve[i] % p == 0) {
          sieve[i] = 0;
        }
      }
    }
    if (sieve[i] != 0) {
      for (var j = i + 1; j < hi; j++) {
        if (sieve[j] % sieve[i] == 0) {
          sieve[j] = 0;
        }
      }
    }
  }
  primes.addAll(sieve.where((element) => element != 0 && element <= limit));
}

List<int> triangles = [1, 3, 6];
List<int> getTrianglesInRange(num min, num max) =>
    generateTriangles(min, max).toList();
Iterable<int> generateTriangles(num min, num max) sync* {
  int last = triangles.last;
  int length = triangles.length;
  var index = 0;
  while (true) {
    while (index < length) {
      var element = triangles[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    length++;
    last += length;
    triangles.add(last);
  }
}

bool isTriangular(dynamic value) {
  if ((value as int) > triangles.last) {
    // ignore: unused_local_variable
    for (var triangle in generateTriangles(value, value)) {}
  }
  var result = triangles.contains(value);
  return result;
}

var pyramidals = <int>[1, 5];
Iterable<int> generateSquarePyramidals(num min, num max) sync* {
  int last = pyramidals.last;
  int length = pyramidals.length;
  var index = 0;
  while (true) {
    while (index < length) {
      var element = pyramidals[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    length++;
    last += length * length;
    pyramidals.add(last);
  }
}

List<int> fibonacci = [1, 2, 3, 5];
Iterable<int> generateFibonacci(num min, num max) sync* {
  int last = fibonacci.last;
  int length = fibonacci.length;
  int previous = fibonacci[length - 2];
  var index = 0;
  while (true) {
    while (index < length) {
      var element = fibonacci[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    length++;
    var next = previous + last;
    previous = last;
    last = next;
    fibonacci.add(last);
  }
}

var squares = <int>[1, 4, 9];
List<int> getSquaresInRange(num min, num max) =>
    generateSquares(min, max).toList();
Iterable<int> generateSquares(num min, num max) sync* {
  int length = squares.length;
  var index = 0;
  while (true) {
    while (index < length) {
      var element = squares[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    length++;
    squares.add(length * length);
  }
}

var cubes = <int>[1, 8];
List<int> getCubesInRange(num min, num max) => generateCubes(min, max).toList();
Iterable<int> generateCubes(num min, num max) sync* {
  int length = cubes.length;
  var index = 0;
  while (true) {
    while (index < length) {
      var element = cubes[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    length++;
    cubes.add(length * length * length);
  }
}

Iterable<int> generatePowers3(num min, num max) sync* {
  yield* generatePowers(min, max, 3);
}

var powers = <int>[1, 2, 4, 8, 9];
Iterable<int> generatePowers(num min, num max, [int minPower = 2]) sync* {
  var index = 0;
  int length = powers.length;
  if (powers.last >= max.toInt()) {
    // All powers pre-computed
    while (index < length) {
      var element = powers[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    return;
  }
  // Generate from beginning
  int previous = 0;
  for (var element in merge(generatePowerAll(minPower))) {
    // Skip duplicates
    if (element == previous) continue;
    previous = element;

    // Add to list if not already there
    if (index <= length) {
      length++;
      powers.add(element);
    }
    index++;

    // yield elements in range
    if (element < min) continue;
    if (element > max) return;
    yield element;
  }
}

Iterable<Iterable<int>> generatePowerAll([int minPower = 2]) sync* {
  int next = minPower;
  while (true) {
    yield generatePowerN(next++);
  }
}

Iterable<int> generatePowerN(int power) sync* {
  int next = 2;
  while (true) {
    yield pow(next++, power).toInt();
  }
}

Iterable<int> generatePowersOf2(num min, num max) sync* {
  yield* generatePowerOfN(2);
}

Iterable<int> generatePowerOfN(int n) sync* {
  int next = 1;
  while (true) {
    yield pow(n, next++).toInt();
  }
}

var product2primes = <int>[6];
Iterable<int> generateProduct2Primes(num min, num max) sync* {
  yield* generateProduct(
      min, max, generatePrimes, generatePrimes, sum2fibonnaci);
}

var product3primes = <int>[30];
Iterable<int> generateProduct3Primes(num min, num max) sync* {
  yield* generateProduct(
      min, max, generateProduct2Primes, generatePrimes, product3primes);
}

var product4primes = <int>[210];
Iterable<int> generateProduct4Primes(num min, num max) sync* {
  yield* generateProduct(
      min, max, generateProduct3Primes, generatePrimes, product4primes);
}

Iterable<int> generateProduct(num min, num max, GeneratorFunc gen1,
    GeneratorFunc gen2, List<int> products) sync* {
  var index = 0;
  int length = products.length;
  if (products.last >= max.toInt()) {
    // All products pre-computed
    while (index < length) {
      var element = products[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    return;
  }
  // Generate from beginning

  var productIndex = 0;
  var nextProduct = <ListQueue<int>>[];
  var previous = -1;
  for (var p1 in gen1(3, max / 2)) {
    var index = 0;
    // Add products of p1 to next values
    var max2 = max / p1;
    if (max2 >= p1) max2 = p1 - 1;
    for (var p2 in gen2(2, max2)) {
      // Check for non-distinct primes
      if (p1 % p2 != 0) {
        while (index >= nextProduct.length) {
          nextProduct.add(ListQueue());
        }
        nextProduct[index].add(p1 * p2);
      }

      index++;
    }
    // Yield values lower than product of 2*p1+2, in order
    while (true) {
      var lowest = 2 * p1 + 2;
      var foundIndex = -1;
      var found = false;
      for (var index = 0; index < nextProduct.length; index++) {
        if (nextProduct[index].isNotEmpty &&
            nextProduct[index].first < lowest) {
          lowest = nextProduct[index].first;
          foundIndex = index;
          found = true;
        }
      }
      if (!found) break;

      nextProduct[foundIndex].removeFirst();
      // Skip duplicates (occurs when more than 2 primes)
      if (lowest == previous) continue;
      previous = lowest;

      productIndex++;
      if (productIndex > products.length) {
        products.add(lowest);
      }
      if (lowest < min) continue;
      if (lowest > max) return;
      yield lowest;
    }
  }
}

var sum2fibonnaci = <int>[2, 3, 4];
Iterable<int> generateSum2Fibonacci(num min, num max) sync* {
  yield* generateSum(
      min, max, generateFibonacci, generateFibonacci, sum2fibonnaci);
}

var sum2square = <int>[5, 10, 13];
Iterable<int> generateSum2Square(num min, num max) sync* {
  yield* generateSum(min, max, generateSquares, generateSquares, sum2square);
}

Iterable<int> generateSum(num min, num max, GeneratorFunc gen1,
    GeneratorFunc gen2, List<int> sums) sync* {
  var index = 0;
  int length = sums.length;
  if (sums.last >= max.toInt()) {
    // All products pre-computed
    while (index < length) {
      var element = sums[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    return;
  }
  // Generate from beginning

  var sumIndex = 0;
  var nextSum = <ListQueue<int>>[];
  var previous = -1;
  Iterable<int> gen(int limit) sync* {
    while (true) {
      var lowest = limit;
      var foundIndex = -1;
      var found = false;
      for (var index = 0; index < nextSum.length; index++) {
        if (nextSum[index].isNotEmpty && nextSum[index].first < lowest) {
          lowest = nextSum[index].first;
          foundIndex = index;
          found = true;
        }
      }
      if (!found) break;

      nextSum[foundIndex].removeFirst();
      // Skip duplicates (occurs when more than 2 primes)
      if (lowest == previous) continue;
      previous = lowest;

      sumIndex++;
      if (sumIndex > sums.length) {
        sums.add(lowest);
      }
      if (lowest < min) continue;
      if (lowest > max) return;
      yield lowest;
    }
  }

  for (var p1 in gen1(1, max - 1)) {
    var index = 0;
    // Add sums of p1 to next values
    var max2 = max - p1;
    if (max2 > p1) max2 = p1;
    for (var p2 in gen2(1, max2)) {
      // Check for non-distinct primes
      while (index >= nextSum.length) {
        nextSum.add(ListQueue());
      }
      nextSum[index].add(p1 + p2);
      index++;
    }
    // Yield values lower than p1+2, in order

    yield* gen(p1 + 2);
  }
  yield* gen(max.toInt() + 1);
}

var sumConsecutiveSquares = <int>[5];
Iterable<int> generateSumConsecutiveSquares(num min, num max) sync* {
  int length = sumConsecutiveSquares.length;
  var index = 0;
  var previousSquare = 1;
  while (true) {
    while (index < length) {
      var element = sumConsecutiveSquares[index++];
      previousSquare = element - previousSquare;
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    length++;
    sumConsecutiveSquares.add(previousSquare + (length + 1) * (length + 1));
  }
}

const List<int> twoDigitPrimes = [
  11,
  13,
  17,
  19,
  23,
  29,
  31,
  37,
  41,
  43,
  47,
  53,
  59,
  61,
  67,
  71,
  73,
  79,
  83,
  89,
  97
];

Map<int, Set<int>> getSumTwoPrimes() {
  var primes = <int, Set<int>>{};
  for (var p1 in twoDigitPrimes) {
    for (var p2 in twoDigitPrimes) {
      var sum = p1 + p2;
      if (!primes.containsKey(sum)) {
        primes[sum] = <int>{};
      }
      primes[sum]!.add(p1);
      primes[sum]!.add(p2);
    }
  }
  return primes;
}

List<int> getTwoDigitNumbers() => getNDigitNumbers(2);
List<int> getThreeDigitNumbers() => getNDigitNumbers(3);
List<int> getFourDigitNumbers() => getNDigitNumbers(4);
List<int> getNDigitNumbers(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return generateIntegers(lo, hi).toList();
}

List<int> getTwoDigitTriangles() => getNDigitTriangles(2);
List<int> getThreeDigitTriangles() => getNDigitTriangles(3);
List<int> getFourDigitTriangles() => getNDigitTriangles(4);
List<int> getFiveDigitTriangles() => getNDigitTriangles(5);
List<int> getSevenDigitTriangles() => getNDigitTriangles(7);
List<int> getNDigitTriangles(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return generateTriangles(lo, hi).toList();
}

List<int> getTwoDigitPyramidal() => getNDigitPyramidal(2);
List<int> getThreeDigitPyramidal() => getNDigitPyramidal(3);
List<int> getFourDigitPyramidal() => getNDigitPyramidal(4);
List<int> getFiveDigitPyramidal() => getNDigitPyramidal(5);
List<int> getSevenDigitPyramidal() => getNDigitPyramidal(7);
List<int> getNDigitPyramidal(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return generateSquarePyramidals(lo, hi).toList();
}

List<int> getTwoDigitSquares() => getNDigitSquares(2);
List<int> getThreeDigitSquares() => getNDigitSquares(3);
List<int> getFourDigitSquares() => getNDigitSquares(4);
List<int> getSixDigitSquares() => getNDigitSquares(6);
List<int> getSevenDigitSquares() => getNDigitSquares(7);
List<int> getNDigitSquares(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return generateSquares(lo, hi).toList();
}

List<int> getTwoDigitCubes() => getNDigitCubes(2);
List<int> getNDigitCubes(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return generateCubes(lo, hi).toList();
}

List<int> getTwoDigitPrimes() => getNDigitPrimes(2);
List<int> getThreeDigitPrimes() => getNDigitPrimes(3);
List<int> getFourDigitPrimes() => getNDigitPrimes(4);
List<int> getNDigitPrimes(n) {
  var lo = 10.pow(n - 1) as int;
  var limit = (10.pow(n) as int) - 1;
  return generatePrimes(lo, limit).toList();
}

List<int> getTwoDigitFibonacci() => getNDigitFibonacci(2);
List<int> getThreeDigitFibonacci() => getNDigitFibonacci(3);
List<int> getFourDigitFibonacci() => getNDigitFibonacci(4);
List<int> getNDigitFibonacci(n) {
  var lo = 10.pow(n - 1) as int;
  var limit = (10.pow(n) as int) - 1;
  return generateFibonacci(lo, limit).toList();
}

List<int> getTwoDigitMultipleThreePrimes() => getNDigitMultipleThreePrimes(2);
List<int> getFiveDigitMultipleThreePrimes() => getNDigitMultipleThreePrimes(5);
List<int> getNDigitMultipleThreePrimes(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = 10.pow(n) as int;
  var cubeRoot = hi.root(3).toInt();
  var products = <int>{};
  for (var p1 in generatePrimesWithOne(cubeRoot)) {
    var hiP1 = hi / p1;
    var maxP2 = sqrt(hiP1).toInt();
    for (var p2 in generatePrimes(p1 + 1, maxP2)) {
      var maxP3 = hiP1 ~/ p2;
      var product2 = p1 * p2;
      for (var p3 in generatePrimes(p2 + 1, maxP3)) {
        var product = product2 * p3;
        if (product < lo) continue;
        products.add(product);
      }
    }
  }
  return products.toList()..sort();
}

List<int> getTwoDigitPowers() => getNDigitPowers(2);
List<int> getFourDigitPowers() => getNDigitPowers(4);
List<int> getNDigitPowers(n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return getPowersInRange(lo, hi);
}

// Not yet converted to generator
List<int> getPowersInRange(int lo, int hi, [int? n, int? minPower]) {
  var powers = <int>{};
  var any = true;
  for (var power = minPower ?? 3; any; power++) {
    any = false;
    for (var x = n ?? 2;; x++) {
      var value = x.pow(power) as int;
      if (value > hi) break;
      any = true;
      if (value >= lo) powers.add(value);
      if (n != null) break;
    }
  }
  var result = powers.toList();
  result.sort();
  return result;
}

List<int> getTwoDigitLucas() => getNDigitLucas(2);
List<int> getNDigitLucas(int n) {
  var lo = 10.pow(n - 1) as int;
  var hi = (10.pow(n) as int) - 1;
  return generateLucas(lo, hi).toList();
}

List<int> getLucasInRange(int lo, int hi) {
  var lucas = <int>[2, 1];
  while (true) {
    var value = lucas[lucas.length - 2] + lucas[lucas.length - 1];
    if (value > hi) break;
    lucas.add(value);
  }
  var result = lucas.where((element) => element >= lo).toList();
  return result;
}

List<int> lucas = [
  1,
  2,
  3,
  4
]; // Actually should start 2, 1, but we want in increasing order
Iterable<int> generateLucas(num min, num max) sync* {
  int last = lucas.last;
  int length = lucas.length;
  int previous = lucas[length - 2];
  var index = 0;
  while (true) {
    while (index < length) {
      var element = lucas[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
    length++;
    var next = previous + last;
    previous = last;
    last = next;
    lucas.add(last);
  }
}

List<int> getTwoDigitPalindromes() {
  var palindromes = <int>[];
  for (var d1 = 1; d1 < 10; d1++) {
    var value = d1 * 10 + d1;
    palindromes.add(value);
  }
  return palindromes;
}

List<int> getThreeDigitPalindromes() {
  var palindromes = <int>[];
  for (var d1 = 1; d1 < 10; d1++) {
    for (var d2 = 0; d2 < 10; d2++) {
      var value = d1 * 100 + d2 * 10 + d1;
      palindromes.add(value);
    }
  }
  return palindromes;
}

List<int> getFourDigitPalindromes() {
  var palindromes = <int>[];
  for (var d1 = 1; d1 < 10; d1++) {
    for (var d2 = 0; d2 < 10; d2++) {
      var value = d1 * 1000 + d2 * 100 + d2 * 10 + d1;
      palindromes.add(value);
    }
  }
  return palindromes;
}

List<int> getFiveDigitPalindromes() {
  var palindromes = <int>[];
  for (var d1 = 1; d1 < 10; d1++) {
    for (var d2 = 0; d2 < 10; d2++) {
      for (var d3 = 0; d3 < 10; d3++) {
        var value = d1 * 10000 + d2 * 1000 + d3 * 100 + d2 * 10 + d1;
        palindromes.add(value);
      }
    }
  }
  return palindromes;
}

Map<int, Map<String, int>> getThreeDigitPrimeMultiples() {
  var multiples = <int, Map<String, int>>{};
  outer:
  for (var p1 in twoDigitPrimes) {
    var finished = true;
    for (var p2 in twoDigitPrimes.where((element) => element > p1)) {
      var multiple = p1 * p2;
      if (multiple >= 1000) {
        if (finished) break outer;
        break;
      }
      finished = false;
      if (multiple >= 100) {
        multiples[multiple] = {'p1': p1, 'p2': p2};
      }
    }
  }
  return multiples;
}
