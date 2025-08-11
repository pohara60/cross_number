import 'dart:math';

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
    _functions['isAscendingDigits'] = (values) =>
        values.where((v) => _isAscendingDigits(v)).toList();
    _functions['isDescendingDigits'] = (values) =>
        values.where((v) => _isDescendingDigits(v)).toList();
    _functions['isUniqueDigits'] =
        (values) => values.where((v) => _isUniqueDigits(v)).toList();
    _functions['isPrime'] = (values) => values.where((v) => _isPrime(v)).toList();
    _functions['isSquare'] =
        (values) => values.where((v) => _isSquare(v)).toList();
    _functions['isCube'] = (values) => values.where((v) => _isCube(v)).toList();
    _functions['isFibonacci'] =
        (values) => values.where((v) => _isFibonacci(v)).toList();
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

  bool _isPrime(int n) {
    if (n <= 1) return false;
    for (var i = 2; i * i <= n; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  bool _isSquare(int n) {
    if (n < 0) return false;
    final sqrtn = sqrt(n).toInt();
    return sqrtn * sqrtn == n;
  }

  bool _isCube(int n) {
    if (n < 0) return false;
    final cbrtn = pow(n, 1 / 3).round();
    return cbrtn * cbrtn * cbrtn == n;
  }

  bool _isFibonacci(int n) {
    if (n < 0) return false;
    if (n == 0 || n == 1) return true;
    int a = 0;
    int b = 1;
    while (b < n) {
      final temp = a + b;
      a = b;
      b = temp;
    }
    return b == n;
  }
}
