import 'dart:math';

abstract class Generator {
  List<int> getValues(int min, int max);
}

abstract class CachedGenerator extends Generator {
  final List<int> _values = [];
  void _extend(int max);

  @override
  List<int> getValues(int min, int max) {
    _extend(max);
    return _values.where((p) => p >= min && p <= max).toList();
  }

  bool contains(int n) {
    _extend(n);
    return _values.contains(n);
  }
}

class PrimeGenerator extends CachedGenerator {
  PrimeGenerator() {
    _values.addAll([2, 3]);
  }

  @override
  void _extend(int max) {
    var maxCached = _values.last;
    if (max > maxCached) {
      for (var i = maxCached + 2; i <= max; i = i + 2) {
        if (_isPrime(i)) {
          _values.add(i);
        }
      }
    }
  }

  bool _isPrime(int n) {
    if (n <= 1) return false;
    var root = sqrt(n).toInt();
    for (var i in _values) {
      if (i > root) break;
      if (n % i == 0) return false;
    }
    return true;
  }
}

class TwoDigitPrimeGenerator extends CachedGenerator {
  TwoDigitPrimeGenerator() {
    _values.addAll([11, 13]);
  }

  @override
  void _extend(int max) {
    var max2digits = max >= 100 ? 99 : max;
    var maxCached = _values.last;
    if (max2digits > maxCached) {
      var primeGenerator = GeneratorRegistry().get('prime') as PrimeGenerator;
      final primes = primeGenerator.getValues(maxCached + 1, max2digits);
      _values.addAll(primes);
    }
  }
}

class TwoDigitPrimeToPrimePowerGenerator extends CachedGenerator {
  TwoDigitPrimeToPrimePowerGenerator() {
    _values.addAll([121]);
  }

  @override
  void _extend(int max) {
    var twoDigitPrimeGenerator =
        GeneratorRegistry().get('twodigitprime') as TwoDigitPrimeGenerator;
    var primeGenerator = GeneratorRegistry().get('prime') as PrimeGenerator;

    var twoDigitPrimes = twoDigitPrimeGenerator.getValues(10, 99);
    var min2digitPrime = twoDigitPrimes.first;
    var max2digitPrime = twoDigitPrimes.last;

    var min = _values.last + 1;
    var maxPower = log(max) ~/ log(min2digitPrime);
    var minPower = log(min) ~/ log(max2digitPrime);
    var primePowers = primeGenerator.getValues(minPower, maxPower);
    var newValues = <int>[];
    for (var prime in twoDigitPrimes) {
      for (var power in primePowers) {
        var value = pow(prime, power).toInt();
        if (value > max) break;
        if (value < min) continue;
        newValues.add(value);
      }
    }
    newValues.sort();
    _values.addAll(newValues);
  }
}

class ProductFivePrimesGenerator extends CachedGenerator {
  ProductFivePrimesGenerator() {
    _values.addAll([2310]);
  }

  @override
  void _extend(int max) {
    if (max <= _values.last) return;
    var maxPrime = max ~/ 2 ~/ 3 ~/ 5 ~/ 7;
    if (maxPrime < 11) {
      return;
    }
    var primeGenerator = GeneratorRegistry().get('prime') as PrimeGenerator;
    final primes = primeGenerator.getValues(2, maxPrime);
    var newValues = <int>[];
    for (var p1 in primes) {
      if (p1 > maxPrime) break;
      var maxP2 = max ~/ p1 ~/ p1 ~/ p1 ~/ p1;
      for (var p2 in primes) {
        if (p2 <= p1) continue;
        if (p2 > maxP2) break;
        var prod12 = p1 * p2;
        var maxP3 = max ~/ prod12 ~/ p2 ~/ p2;
        for (var p3 in primes) {
          if (p3 <= p2) continue;
          if (p3 > maxP3) break;
          var prod123 = prod12 * p3;
          var maxP4 = max ~/ prod123 ~/ p3;
          for (var p4 in primes) {
            if (p4 <= p3) continue;
            if (p4 > maxP4) break;
            var prod1234 = prod123 * p4;
            var maxP5 = max ~/ prod1234;
            for (var p5 in primes) {
              if (p5 <= p4) continue;
              if (p5 > maxP5) break;
              var prod12345 = prod1234 * p5;
              if (prod12345 <= _values.last) continue;
              if (prod12345 > max) break;
              // print('Adding product of $p1*$p2*$p3*$p4*$p5: $prod12345');
              newValues.add(prod12345);
            }
          }
        }
      }
    }
    newValues.sort();
    _values.addAll(newValues);
  }
}

class TriangularGenerator extends CachedGenerator {
  int _i = 1; // The current index for triangular numbers

  @override
  void _extend(int max) {
    var maxCached = _values.isEmpty ? 0 : _values.last;
    if (max > maxCached) {
      var triangular = maxCached + _i;
      while (triangular <= max) {
        if (triangular > maxCached) {
          _values.add(triangular);
          maxCached = triangular;
        }
        _i++;
        triangular = maxCached + _i;
      }
    }
  }
}

class FibonacciGenerator extends CachedGenerator {
  int _a = 0;
  int _b = 1;

  @override
  void _extend(int max) {
    var maxCached = _values.isEmpty ? 0 : _values.last;
    if (max > maxCached) {
      while (_b <= max) {
        if (_b > maxCached) _values.add(_b);
        var next = _a + _b;
        _a = _b;
        _b = next;
      }
    }
  }
}

class SquareGenerator extends CachedGenerator {
  int _i = 1;

  @override
  void _extend(int max) {
    var maxCached = _values.isEmpty ? 0 : _values.last;
    if (max > maxCached) {
      var square = _i * _i;
      while (square <= max) {
        if (square > maxCached) _values.add(square);
        _i++;
        square = _i * _i;
      }
    }
  }
}

class CubeGenerator extends CachedGenerator {
  int _i = 1;

  @override
  void _extend(int max) {
    var maxCached = _values.isEmpty ? 0 : _values.last;
    if (max > maxCached) {
      var cube = _i * _i * _i;
      while (cube <= max) {
        if (cube > maxCached) _values.add(cube);
        _i++;
        cube = _i * _i * _i;
      }
    }
  }
}

class HarshadGenerator extends CachedGenerator {
  @override
  void _extend(int max) {
    var maxCached = _values.isEmpty ? 0 : _values.last;
    if (max > maxCached) {
      var harshad = maxCached + 1;
      while (harshad <= max) {
        var sumDigits = harshad
            .toString()
            .split('')
            .map(int.parse)
            .reduce((value, element) => value + element);
        if (harshad % sumDigits == 0) {
          if (harshad > maxCached) {
            _values.add(harshad);
            maxCached = harshad;
          }
        }
        harshad++;
      }
    }
  }
}

class PalindromeGenerator extends CachedGenerator {
  @override
  void _extend(int max) {
    var maxCached = _values.isEmpty ? 0 : _values.last;
    var minDigits =
        maxCached == 0 ? 1 : maxCached.toInt().toString().length + 1;
    var maxDigits = max.toInt().toString().length;
    for (var digits = minDigits; digits <= maxDigits; digits++) {
      for (var palindrome in getPalindromes(digits)) {
        _values.add(palindrome);
      }
    }
  }

  static const powers10 = <int>[
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
}

/// A registry for generator functions.
///
/// This class holds a map of generator names to their corresponding
/// functions. It also provides a method to get a generator by its name.
class GeneratorRegistry {
  static final GeneratorRegistry _instance =
      GeneratorRegistry._privateConstructor();

  factory GeneratorRegistry() {
    return _instance;
  }

  static final Map<String, Generator> _generators = {};

  GeneratorRegistry._privateConstructor() {
    register('prime', PrimeGenerator());
    register('twodigitprime', TwoDigitPrimeGenerator());
    register('twodigitprimetoprimepower', TwoDigitPrimeToPrimePowerGenerator());
    register('triangular', TriangularGenerator());
    register('fibonacci', FibonacciGenerator());
    register('square', SquareGenerator());
    register('cube', CubeGenerator());
    register('harshad', HarshadGenerator());
    register('palindrome', PalindromeGenerator());
    register('productfiveprimes', ProductFivePrimesGenerator());
  }

  void register(String name, Generator generator) {
    _generators[name] = generator;
  }

  Generator? get(String name) {
    return _generators[name];
  }
}
