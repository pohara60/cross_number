import 'dart:math' as math;
import 'dart:math';

import 'generators.dart';

typedef MonadicFunction = List<int> Function(List<int> values,
    {int? min, int? max});

class MonadicFunctionRegistry {
  static final MonadicFunctionRegistry _instance =
      MonadicFunctionRegistry._privateConstructor();

  factory MonadicFunctionRegistry() {
    return _instance;
  }

  static final Map<String, MonadicFunction> _functions = {};

  void registerFunction(String name, MonadicFunction function) {
    _functions[name] = function;
  }

  MonadicFunctionRegistry._privateConstructor() {
    _functions['squareroot'] = (values, {min, max}) => values
        .where((v) => v >= 0 && math.sqrt(v) == math.sqrt(v).floor())
        .map((v) => math.sqrt(v).toInt())
        .toList();
    _functions['isOdd'] =
        (values, {min, max}) => values.where((v) => v.isOdd).toList();
    _functions['isEven'] =
        (values, {min, max}) => values.where((v) => v.isEven).toList();
    _functions['isAscendingDigits'] = (values, {min, max}) =>
        values.where((v) => _isAscendingDigits(v)).toList();
    _functions['isDescendingDigits'] = (values, {min, max}) =>
        values.where((v) => _isDescendingDigits(v)).toList();
    _functions['isUniqueDigits'] = (values, {min, max}) =>
        values.where((v) => _isUniqueDigits(v)).toList();
    _functions['isPrime'] =
        (values, {min, max}) => values.where((v) => _isPrime(v)).toList();
    _functions['isFibonacci'] =
        (values, {min, max}) => values.where((v) => _isFibonacci(v)).toList();
    _functions['isTriangular'] =
        (values, {min, max}) => values.where((v) => _isTriangular(v)).toList();
    _functions['isSquare'] =
        (values, {min, max}) => values.where((v) => _isSquare(v)).toList();
    _functions['isCube'] =
        (values, {min, max}) => values.where((v) => _isCube(v)).toList();
    _functions['lte'] = (values, {min, max}) {
      var upperLimit = values.reduce(math.max);
      if (max != null && max < upperLimit) upperLimit = max;
      var lowerLimit = 1;
      if (min != null && min > lowerLimit) lowerLimit = min;
      // print('lowerLimit= $lowerLimit, upperLimit = $upperLimit');
      if (upperLimit < lowerLimit) return [];
      return List.generate(upperLimit - lowerLimit + 1, (i) => i + lowerLimit);
    };
    _functions['lt'] = (values, {min, max}) {
      var upperLimit = values.reduce(math.max);
      if (max != null && max + 1 < upperLimit) upperLimit = max + 1;
      var lowerLimit = 1;
      if (min != null && min > lowerLimit) lowerLimit = min;
      if (upperLimit <= lowerLimit) return [];
      return List.generate(upperLimit - lowerLimit, (i) => i + lowerLimit);
    };
    _functions['factor'] = (values, {min, max}) => values
        .expand((value) => factors(value, min: min, max: max))
        .toSet()
        .toList()
      ..sort();
    _functions['square'] =
        (values, {min, max}) => values.map((v) => v * v).toList();
    _functions['cube'] =
        (values, {min, max}) => values.map((v) => v * v * v).toList();
    _functions['multiple'] = (values, {min, max}) {
      if (values.isEmpty) return [];
      final base = values.first;
      if (base == 0) return [];
      final results = <int>[];
      final start = (min ?? 1) / base;
      final end = (max ?? 100000) / base;
      for (var i = start.ceil(); i <= end; i++) {
        final multiple = base * i;
        if (multiple >= (min ?? 1) && multiple <= (max ?? 100000)) {
          results.add(multiple);
        }
      }
      return results;
    };
    _functions['power'] = (values, {min, max}) {
      if (values.isEmpty) return [];
      final results = <int>[];
      // Find values in the range that are powers of the given exponent
      // e.g. for exponent 3, find 1, 8, 27, 64, 125, ...
      // Stop when power exceeds max  or 100000 if max not given
      // or when power is less than min or 1 if min not given (so start at 1)

      bool updated = true;
      var exponent = values.first;
      while (updated) {
        var base = 2; // Ignore trivial base 1
        updated = false;
        while (true) {
          var power = pow(base++, exponent).toInt();
          if (power > (max ?? 100000)) break;
          updated = true; // Continue
          if (power < (min ?? 1)) continue;
          results.add(power);
        }
        exponent++;
      }
      return results..sort();
    };
    _functions['digitsum'] = (values, {min, max}) => values
        .map((v) =>
            v.toString().split('').map(int.parse).reduce((a, b) => a + b))
        .toSet()
        .toList()
      ..sort();
    _functions['digitproduct'] = (values, {min, max}) => values
        .map((v) =>
            v.toString().split('').map(int.parse).reduce((a, b) => a * b))
        .toSet()
        .toList()
      ..sort();
    _functions['jumble'] = (values, {min, max}) => values
        .expand((v) => jumble(v).where(
            (v) => (min == null || v >= min) && (max == null || v <= max)))
        .toSet()
        .toList()
      ..sort();
  }

  MonadicFunction? get(String name) {
    return _functions[name];
  }

  bool _isAscendingDigits(int n) {
    final s = n.toString();
    for (var i = 0; i < s.length - 1; i++) {
      if (s[i].compareTo(s[i + 1]) >= 0) {
        return false;
      }
    }
    return true;
  }

  bool _isDescendingDigits(int n) {
    final s = n.toString();
    for (var i = 0; i < s.length - 1; i++) {
      if (s[i].compareTo(s[i + 1]) <= 0) {
        return false;
      }
    }
    return true;
  }

  bool _isUniqueDigits(int n) {
    final s = n.toString();
    final digits = s.split('');
    final uniqueDigits = digits.toSet();
    return digits.length == uniqueDigits.length;
  }

  PrimeGenerator? primeGenerator;
  bool _isPrime(int n) {
    primeGenerator ??= GeneratorRegistry().get('prime') as PrimeGenerator;
    return primeGenerator!.contains(n);
  }

  TriangularGenerator? triangularGenerator;
  bool _isTriangular(int n) {
    triangularGenerator ??=
        GeneratorRegistry().get('triangular') as TriangularGenerator;
    return triangularGenerator!.contains(n);
  }

  FibonacciGenerator? fibonacciGenerator;
  bool _isFibonacci(int n) {
    fibonacciGenerator ??=
        GeneratorRegistry().get('fibonacci') as FibonacciGenerator;
    return fibonacciGenerator!.contains(n);
  }

  SquareGenerator? squareGenerator;
  bool _isSquare(int n) {
    squareGenerator ??= GeneratorRegistry().get('square') as SquareGenerator;
    return squareGenerator!.contains(n);
  }

  CubeGenerator? cubeGenerator;
  bool _isCube(int n) {
    cubeGenerator ??= GeneratorRegistry().get('cube') as CubeGenerator;
    return cubeGenerator!.contains(n);
  }

  List<int> factors(int value, {int? min, int? max}) {
    var start = value % 2 == 0 ? 2 : 3;
    var end = value ~/ start;
    var inc = 1;
    var results = <int>{};
    for (var factor = start; factor <= end; factor += inc) {
      if (min != null && factor < min) continue;
      if (max != null && factor > max) break;
      if (value % factor == 0) results.add(factor);
    }
    return results.toList()..sort();
  }

  Iterable<int> jumble(int value) sync* {
    var strValue = (value).toString();
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
}
