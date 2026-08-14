typedef PolyadicFunction = List<int> Function(List<dynamic> args, {int? min, int? max});

enum PolyadicMaxOp {
  same,
  double,
  limit,
  square,
  cube,
}

class PolyadicFunctionRegistry {
  static final PolyadicFunctionRegistry _instance = PolyadicFunctionRegistry._privateConstructor();

  factory PolyadicFunctionRegistry() {
    return _instance;
  }

  static final Map<String, PolyadicFunction> _functions = {};
  static final Map<String, PolyadicMaxOp> _maxOp = {};

  void registerFunction(String name, PolyadicFunction function, [PolyadicMaxOp? maxOp]) {
    _functions[name] = function;
    if (maxOp != null) {
      _maxOp[name] = maxOp;
    }
  }

  PolyadicFunctionRegistry._privateConstructor() {
    _functions['gcd'] = gcd;
  }

  PolyadicFunction? get(String name) {
    return _functions[name];
  }

  PolyadicMaxOp? getMaxOp(String name) {
    return _maxOp[name];
  }
}

List<int> gcd(List<dynamic> values, {int? min, int? max}) {
  assert(values.length == 2);
  var a = values[0] as List<int>;
  var b = values[1] as List<int>;
  final Set<int> results = {};

  for (final int x in a) {
    for (final int y in b) {
      final int g = x.gcd(y);

      // Optional min/max bounds filter
      if (min != null && g < min) continue;
      if (max != null && g > max) continue;

      results.add(g);
    }
  }

  return results.toList()..sort();
}
