import 'package:test/test.dart';
import 'package:crossnumber/cartesian.dart';

void main() {
  group('Cartesian tests', () {
    test('1st test', () {
      var inputs = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8]
      ];
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
    test('2nd test', () {
      var inputs = [
        [1, 2, 3],
        [1, 2, 3],
        [1, 2, 3],
      ];
      var limits = {1: 2, 2: 2, 3: 2, 4: 2};
      var outputs = <List<int>>[];
      for (var first in inputs[0]) {
        for (var second in inputs[1]) {
          for (var third in inputs[2]) {
            if (third != first || third != second) {
              outputs.add([first, second, third]);
            }
          }
        }
      }
      expect(cartesianDuplicateLimit(inputs, limits), equals(outputs));
    });
  });
}
