import 'package:test/test.dart';
import 'package:crossnumber/cartesian.dart';

void main() {
  group('Cartesian tests', () {
    var inputs = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8]
    ];
    test('1st test', () {
      var outputs = <List<int>>[];
      for (var first in inputs[0]) {
        for (var second in inputs[1]) {
          for (var third in inputs[2]) {
            outputs.add([first, second, third]);
          }
        }
      }
      expect(cartesian(inputs), equals(outputs));
    });
  });
}
