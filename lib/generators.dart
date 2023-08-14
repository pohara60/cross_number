import 'dart:math';

import 'merge.dart';

typedef GeneratorFunc = Iterable<int> Function(num min, num max);

class Generator {
  String name;
  GeneratorFunc func;
  Generator(this.name, this.func);
}

void initializeGenerators(Map<String, Generator> generators) {
  generators['integer'] = Generator('integer', generateIntegers);
  generators['prime'] = Generator('prime', generatePrimes);
  generators['triangular'] = Generator('triangular', generateTriangles);
  generators['pyramidal'] = Generator('pyramidal', generateSquarePyramidals);
  generators['square'] = Generator('square', generateSquares);
  generators['cube'] = Generator('cube', generateCubes);
  generators['power'] = Generator('power', generatePowers);
  generators['product2primes'] =
      Generator('product2primes', generateProduct2Primes);
  generators['product3primes'] =
      Generator('product3primes', generateProduct3Primes);
  generators['sumConsecutiveSquares'] =
      Generator('sumConsecutiveSquares', generateSumConsecutiveSquares);
}

Iterable<int> generateIntegers(num min, num max) sync* {
  for (var integer = min.toInt(); integer <= max.toInt(); integer++)
    yield integer;
}

const CHUNK_SIZE = 100;

List<int> primes = [2, 3, 5, 7];
Iterable<int> generatePrimes(num min, num max) sync* {
  var limit = max.toInt();
  var next = min.toInt();
  var index = 0;
  while (next <= limit) {
    next += CHUNK_SIZE;
    extendPrimesUpto(next);
    while (index < primes.length) {
      var element = primes[index++];
      if (element < min) continue;
      if (element > max) return;
      yield element;
    }
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

var squares = <int>[1, 4, 9];
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

var powers = <int>[1, 2, 4, 8, 9];
Iterable<int> generatePowers(num min, num max) sync* {
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
  for (var element in merge(generatePowerAll())) {
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

Iterable<Iterable<int>> generatePowerAll() sync* {
  int next = 2;
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

var product2primes = <int>[6];
Iterable<int> generateProduct2Primes(num min, num max) sync* {
  yield* generateProduct(
      min, max, generatePrimes, generatePrimes, product2primes);
}

var product3primes = <int>[30];
Iterable<int> generateProduct3Primes(num min, num max) sync* {
  yield* generateProduct(
      min, max, generateProduct2Primes, generatePrimes, product3primes);
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
  var nextProduct = <List<int>>[];
  var previous = -1;
  for (var p1 in gen1(3, max)) {
    var index = 0;
    // Add products of p1 to next values
    for (var p2 in gen2(2, p1 - 1)) {
      // Check for non-distict primes
      if (p1 % p2 != 0) {
        while (index >= nextProduct.length) nextProduct.add([]);
        nextProduct[index].add(p1 * p2);
      }
      index++;
    }
    // Yield values lower than product of 2*p1, in order
    while (true) {
      var lowest = 2 * p1;
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

      nextProduct[foundIndex].removeAt(0);
      // Skip duplicates (occurs when more than 2 primes)
      if (lowest == previous) continue;
      previous = lowest;

      productIndex++;
      if (productIndex > product2primes.length) {
        products.add(lowest);
      }
      if (lowest < min) continue;
      if (lowest > max) return;
      yield lowest;
    }
  }
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
