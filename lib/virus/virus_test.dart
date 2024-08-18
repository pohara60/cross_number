import 'dart:math';

import 'package:crossnumber/generators.dart';
import 'package:crossnumber/monadic.dart';
import 'package:crossnumber/set.dart';

void main(List<String> args) {
  var xValues = initXValues();
  // A6 is 3 digit triangular
  var a6Values = getThreeDigitTriangles();
  var goodA6 = <int>{};
  var goodEA6 = <int>{};
  var goodX = <int>{};
  var goodD9 = <int>{};
  var goodD7 = <int>{};
  var goodED7 = <int>{};
  var goodA9 = <int>{};
  var goodEA9 = <int>{};
  for (var a6Value in a6Values) {
    for (var xValue in xValues) {
      // EA6 is KV(A6)
      var ea6Value = kvFunc([a6Value, xValue]);
      // D9 is sqrt EA6
      var value = sqrt(ea6Value);
      if (value != value.roundToDouble()) continue;
      var d9Value = value.toInt();
      var ed9Value = kvFunc([d9Value, xValue]);

      // ED7[0] is EA6[1] so EA6[1] is not 0
      var ea6Digit2 = ea6Value ~/ 10 % 10;
      if (ea6Digit2 == 0) continue;

      // D7 is multiple KV
      var d7Value = (100 ~/ xValue + 1) * xValue;
      while (d7Value < 1000) {
        // ED7 is KV(D7)
        var ed7Value = kvFunc([d7Value, xValue]);
        // ED7[0] is EA6[1]
        var ed7Digit1 = ed7Value ~/ 100;
        if (ed7Digit1 == ea6Digit2) {
          // A9 is DS(ED7)
          var a9Value = digitSum(ed7Value);
          // EA9 is KV(A9)
          var ea9Value = kvFunc([a9Value, xValue]);
          // EA9[1] is ED7[1]
          var ed7Digit2 = ed7Value ~/ 10 % 10;
          var ea9Digit2 = ea9Value % 10;
          if (ea9Digit2 == ed7Digit2) {
            // EA9[0] is ED9[0]
            var ed9Digit1 = ed9Value ~/ 10;
            var ea9Digit1 = ea9Value ~/ 10;
            if (ea9Digit1 == ed9Digit1) {
              goodA6.add(a6Value);
              goodEA6.add(ea6Value);
              goodX.add(xValue);
              goodD9.add(d9Value);
              goodD7.add(d7Value);
              goodED7.add(ed7Value);
              goodA9.add(a9Value);
              goodEA9.add(ea9Value);
            }
          }
        }
        d7Value += xValue;
      }
    }
  }
  print('A6=${goodA6.toShortString()}');
  print('EA6=${goodEA6.toShortString()}');
  print('X=${goodX.toShortString()}');
  print('D9=${goodD9.toShortString()}');
  print('D7=${goodD7.toShortString()}');
  print('ED7=${goodED7.toShortString()}');
  print('A9=${goodA9.toShortString()}');
  print('EA9=${goodEA9.toShortString()}');
}

Set<int> initXValues() {
  var digits = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  var x = <int>{};
  for (var k in digits) {
    for (var v in digits) {
      if (k != v) x.add(k * 10 + v);
    }
  }
  return x;
}

int kvFunc(List<int> args) {
  assert(args.length == 2);
  int value = args[0];
  int x = args[1];
  var strValue = value.toString();
  var k = x ~/ 10;
  var v = x % 10;
  if (strValue.contains(k.toString()) &&
      v != k &&
      !strValue.contains(v.toString())) {
    var strResult = strValue.replaceAll(RegExp(k.toString()), v.toString());
    return int.parse(strResult);
  }
  return value;
}
