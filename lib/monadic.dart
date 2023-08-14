import 'dart:math';

typedef MonadicFunc = dynamic Function(int arg);

class Monadic {
  String name;
  MonadicFunc func;
  Type type;
  Monadic(this.name, this.func, this.type);
}

void initializeMonadics(Map<String, Monadic> monadics) {
  monadics['DS'] = Monadic('DS', digitSum, int);
  monadics['DP'] = Monadic('DP', digitProduct, int);
  monadics['MP'] = Monadic('MP', multiplicativePersistence, int);
  monadics['square'] = Monadic('square', square, int);
  monadics['cube'] = Monadic('cube', cube, int);
  monadics['even'] = Monadic('even', isEven, bool);
  monadics['multiple'] = Monadic('multiple', multiple, Iterable<int>);
  monadics['jumble'] = Monadic('jumble', jumble, Iterable<int>);
}

int digitSum(int value) {
  var digits = value.toString().split('').map((e) => int.parse(e));
  var result =
      digits.fold<int>(0, (previousValue, element) => previousValue + element);
  return result;
}

int digitProduct(int value) {
  var digits = value.toString().split('').map((e) => int.parse(e));
  var result =
      digits.fold<int>(1, (previousValue, element) => previousValue * element);
  return result;
}

int multiplicativePersistence(int value) {
  var next = value;
  var result = 0;
  while (next > 9) {
    next = digitProduct(next);
    result++;
  }
  return result;
}

int square(int value) {
  var result = value * value;
  return result;
}

int cube(int value) {
  var result = value * value * value;
  return result;
}

bool isEven(int value) {
  var result = value % 2 == 0;
  return result;
}

Iterable<int> multiple(int value) sync* {
  int last = value;
  while (true) {
    last += value;
    yield last;
  }
}

Iterable<int> jumble(int value) sync* {
  var strValue = value.toString();
  yield* jumbleStr(0, strValue);
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
Iterable<int> jumbleStr(int leftValue, String strValue) sync* {
  for (var d = 0; d < strValue.length; d++) {
    var chr = strValue[d];
    var chrVal = int.parse(chr);
    if (strValue.length == 1) {
      yield leftValue + chrVal;
      return;
    }

    assert(strValue.length <= tens.length);
    chrVal *= tens[strValue.length - 1];
    var rest = strValue.substring(0, d) + strValue.substring(d + 1);
    yield* jumbleStr(leftValue + chrVal, rest);
  }
}
