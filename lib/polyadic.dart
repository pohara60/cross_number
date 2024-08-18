import 'expression.dart';
import 'gcf.dart';

typedef PolyadicFunc = dynamic Function(List<int> args);
typedef PolyadicFuncRange = dynamic Function(
    List<int> args, num? min, num? max);

class Polyadic {
  String name;
  PolyadicFunc? func;
  PolyadicFuncRange? funcRange;
  Type type;
  NodeOrder order;
  Polyadic(this.name, this.func, this.type,
      {this.funcRange, this.order = NodeOrder.ASCENDING});
}

void initializePolyadics(Map<String, Polyadic> monadics) {
  monadics['gcf'] = Polyadic('gcf', gcf, int);
  monadics['gcd'] = Polyadic('gcd', gcd, int);
}

int gcf(List<int> values) {
  assert(values.length == 2);

  return getGCF(values[0], values[1]);
}

int gcd(List<int> values) {
  assert(values.length == 2);
  var a = values[0];
  var b = values[1];
  // while (a != b) {
  //   if (a > b) {
  //     a = a - b;
  //   } else {
  //     b = b - a;
  //   }
  // }
  while (b != 0) {
    var t = b;
    b = a % b;
    a = t;
  }
  return a;
}
