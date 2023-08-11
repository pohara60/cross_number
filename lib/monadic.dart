typedef MonadicFunc = int Function(int arg);

class Monadic {
  String name;
  MonadicFunc func;
  Monadic(this.name, this.func);
}

void initializeMonadics(Map<String, Monadic> monadics) {
  monadics['DS'] = Monadic('DS', digitSum);
  monadics['DP'] = Monadic('DP', digitProduct);
  monadics['MP'] = Monadic('MP', multiplicativePersistence);
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
