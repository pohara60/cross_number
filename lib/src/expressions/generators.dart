/// A function that generates a sequence of numbers based on a given range.
typedef Generator = List<int> Function(int min, int max);

/// A registry for generator functions.
///
/// This class holds a map of generator names to their corresponding
/// functions. It also provides a method to get a generator by its name.
class GeneratorRegistry {
  final Map<String, Generator> _generators = {};

  GeneratorRegistry() {
    _register('prime', _generatePrimes);
    _register('triangular', _generateTriangulars);
    _register('fibonacci', _generateFibonacci);
    _register('square', _generateSquares);
  }

  void _register(String name, Generator generator) {
    _generators[name] = generator;
  }

  Generator? get(String name) {
    return _generators[name];
  }
}

List<int> _generatePrimes(int min, int max) {
  final primes = <int>[];
  for (var i = min; i <= max; i++) {
    if (_isPrime(i)) {
      primes.add(i);
    }
  }
  return primes;
}

bool _isPrime(int n) {
  if (n <= 1) return false;
  for (var i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }
  return true;
}

List<int> _generateTriangulars(int min, int max) {
  final triangulars = <int>[];
  var i = 1;
  var triangular = 1;
  while (triangular <= max) {
    if (triangular >= min) {
      triangulars.add(triangular);
    }
    i++;
    triangular = i * (i + 1) ~/ 2;
  }
  return triangulars;
}

List<int> _generateFibonacci(int min, int max) {
  final fibs = <int>[];
  var a = 0;
  var b = 1;
  while (b <= max) {
    if (b >= min) {
      fibs.add(b);
    }
    final next = a + b;
    a = b;
    b = next;
  }
  return fibs;
}

List<int> _generateSquares(int min, int max) {
  final squares = <int>[];
  var i = 1;
  var square = 1;
  while (square <= max) {
    if (square >= min) {
      squares.add(square);
    }
    i++;
    square = i * i;
  }
  return squares;
}
