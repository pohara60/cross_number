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
    register('triangular', TriangularGenerator());
    register('fibonacci', FibonacciGenerator());
    register('square', SquareGenerator());
    register('cube', CubeGenerator());
  }

  void register(String name, Generator generator) {
    _generators[name] = generator;
  }

  Generator? get(String name) {
    return _generators[name];
  }
}
