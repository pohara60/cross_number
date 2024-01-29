import 'dart:math';

void main(List<String> args) {
  testI('I');
  testII('II');
  testIII('III');
  testIV('IV');
  testV('V');
  testVI('VI');
  testVII('VII');
}

/*
*/
void testI(String name) {
  var count = 0;
  for (var B = 10; B < 100; B++) {
    for (var f = 100; f < 1000; f++) {
      for (var D = 100; D < 1000; D++) {
        var x = 4 * B;
        var y = f;
        var z = D;
        if (x * x * x + y * y * y + 1 == z * z * z) {
          count++;
          print('$name: B=$B, f=$f, D=$D, x=$x, y=$y, z=$z');
        }
      }
    }
  }
  print(count);
}

void testII(String name) {
  // II	2C	E	8A
  var count = 0;
  for (var C = 100; C < 1000; C++) {
    for (var E = 100; E < 1000; E++) {
      for (var A = 100; A < 1000; A++) {
        var x = 2 * C;
        var y = E;
        var z = 8 * A;
        if (x * x * x + y * y * y + 1 == z * z * z) {
          count++;
          print('$name: C=$C, E=$E, A=$A, x=$x, y=$y, z=$z');
        }
      }
    }
  }
  print(count);
}

void testIII(String name) {
  var count = 0;
  // 10F, (b-A)^2/2, g^2
  for (var F = 10; F < 100; F++) {
    for (var b = 100; b < 1000; b++) {
      for (var A = 113; A < 114; A++) {
        // for (var A = 100; A < 1000; A++) {
        for (var g = 10; g < 100; g++) {
          var x = 10 * F;
          var y2 = pow((b - A), 2);
          if (y2 % 2 != 0) continue;
          var y = y2 ~/ 2;
          var z = pow(g, 2);
          if (pow(x, 3) + pow(y, 3) + 1 == pow(z, 3)) {
            count++;
            print('$name: F=$F, b=$b, A=$A, g=$g, x=$x, y=$y, z=$z');
          }
        }
      }
    }
  }
  print(count);
}

void testIV(String name) {
  var count = 0;
  // IV	f-4F	b	G
  var b = 135;
  var f = 426;
  var F = 72;
  // for (var f = 100; f < 1000; f++) {
  // for (var F = 10; F < 100; F++) {
  // for (var b = 100; b < 1000; b++) {
  for (var G = 100; G < 1000; G++) {
    var x = f - 4 * F;
    if (x < 1) continue;
    var y = b;
    var z = G;
    if (pow(x, 3) + pow(y, 3) + 1 == pow(z, 3)) {
      count++;
      print('$name: f=$f, F=$F, b=$b, G=$G, x=$x, y=$y, z=$z');
    }
  }
  //     }
  //   }
  // }
  print(count);
}

void testV(String name) {
  var count = 0;
  // V	f-4F	f/6	2F
  for (var f = 100; f < 1000; f++) {
    for (var F = 10; F < 100; F++) {
      var x = f - 4 * F;
      if (x < 1) continue;
      var y2 = f;
      if (y2 % 6 != 0) continue;
      var y = y2 ~/ 6;
      var z = 2 * F;
      if (pow(x, 3) + pow(y, 3) + 1 == pow(z, 3)) {
        count++;
        print('$name: f=$f, F=$F, x=$x, y=$y, z=$z');
      }
    }
  }
  print(count);
}

void testVI(String name) {
  // VI	a	4d	2D
  var count = 0;
  for (var a = 100; a < 1000; a++) {
    for (var d = 100; d < 1000; d++) {
      for (var D = 100; D < 1000; D++) {
        var x = a;
        var y = 4 * d;
        var z = 2 * D;
        if (x * x * x + y * y * y + 1 == z * z * z) {
          count++;
          print('$name: a=$a, d=$d, D=$D, x=$x, y=$y, z=$z');
        }
      }
    }
  }
  print(count);
}

void testVII(String name) {
  var count = 0;
  // VII	cg	f	e
  for (var c = 10; c < 100; c++) {
    for (var g = 10; g < 100; g++) {
      for (var f = 100; f < 1000; f++) {
        for (var e = 100; e < 1000; e++) {
          var x = c * g;
          var y = f;
          var z = e;
          if (pow(x, 3) + pow(y, 3) + 1 == pow(z, 3)) {
            count++;
            print('$name: c=$c, g=$g, f=$f, e=$e, x=$x, y=$y, z=$z');
          }
        }
      }
    }
  }
  print(count);
}
