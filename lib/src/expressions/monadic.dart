import 'dart:math' as math;

import 'generators.dart';

typedef MonadicFunction = List<int> Function(List<int> values,
    {int? min, int? max});

class MonadicFunctionRegistry {
  final Map<String, MonadicFunction> _functions = {};

  MonadicFunctionRegistry() {
    _registerFunctions();
  }

  void _registerFunctions() {
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
        .toList();
    _functions['square'] =
        (values, {min, max}) => values.map((v) => v * v).toList();
    _functions['cube'] =
        (values, {min, max}) => values.map((v) => v * v * v).toList();
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
}
