import 'dart:math';

import 'generators.dart';

typedef MonadicFunction = List<int> Function(List<int> values);

class MonadicFunctionRegistry {
  final Map<String, MonadicFunction> _functions = {};

  MonadicFunctionRegistry() {
    _registerFunctions();
  }

  void _registerFunctions() {
    _functions['squareroot'] = (values) => values
        .where((v) => v >= 0 && sqrt(v) == sqrt(v).floor())
        .map((v) => sqrt(v).toInt())
        .toList();
    _functions['isOdd'] = (values) => values.where((v) => v.isOdd).toList();
    _functions['isEven'] = (values) => values.where((v) => v.isEven).toList();
    _functions['isAscendingDigits'] =
        (values) => values.where((v) => _isAscendingDigits(v)).toList();
    _functions['isDescendingDigits'] =
        (values) => values.where((v) => _isDescendingDigits(v)).toList();
    _functions['isUniqueDigits'] =
        (values) => values.where((v) => _isUniqueDigits(v)).toList();
    _functions['isPrime'] =
        (values) => values.where((v) => _isPrime(v)).toList();
    _functions['isFibonacci'] =
        (values) => values.where((v) => _isFibonacci(v)).toList();
    _functions['isTriangular'] =
        (values) => values.where((v) => _isTriangular(v)).toList();
    _functions['isSquare'] =
        (values) => values.where((v) => _isSquare(v)).toList();
    _functions['isCube'] = (values) => values.where((v) => _isCube(v)).toList();
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
}
