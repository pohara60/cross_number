import 'dart:math';

void main(List<String> args) {
  var a7possible = <int>{};
  var d10possible = <int>{};
  for (var a1 = 100; a1 < 1000; a1++) {
    for (var d6 = a1 + 1; d6 < 1000; d6++) {
      if (a1 + d6 > 999) break;
      for (var a11 = d6 + 1; a11 < 1000; a11++) {
        if (a1 + d6 + a11 > 999) break;
        for (var d3 = a11 + 1; d3 < 1000; d3++) {
          if (a1 + d6 + a11 + d3 > 999) break;
          var a7 = a1 + d6 + a11 + d3;
          var root = sqrt(a7).toInt();
          if (root * root == a7) {
            a7possible.add(a7);
            d10possible.add(root);
          }
        }
      }
    }
  }
  print('a7possible= ${a7possible.length}'); // 21
  print('d10possible= ${d10possible.length}'); // 21
  var d10possible2 = <int>{};
  var a9possible = <int>{};
  for (var d10 in d10possible) {
    for (var a9 = d10; a9 < 1000; a9 += d10) {
      if (d10.toString()[0] == a9.toString()[1]) {
        a9possible.add(a9);
        d10possible2.add(d10);
      }
    }
  }
  print('a9possible= ${a9possible.length}'); // 84
  print('d10possible2= ${d10possible2.length}'); // 21
}
