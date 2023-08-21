import 'package:crossnumber/grid.dart';
import 'package:test/test.dart';

void main() {
  group('Grid tests', () {
    var grid = [
      '+--+--+--+--+',
      '|1 :2 :3 |4 |',
      '+--:::::::::+',
      '|5 :  |6 :  |',
      '+:::--+--:::+',
      '|7 :8 |9 :  |',
      '+:::::::::--+',
      '|  |10:  :  |',
      '+--+--+--+--+',
    ];
    test('1st test', () {
      var spec = Grid(grid);
      // spec.extractClues();
      expect(
          spec.entries.toString(),
          equals(
              '[A1(3), D2(2), D3(2), D4(3), A5(2), D5(3), A6(2), A7(2), D8(2), A9(2), D9(2), A10(3)]'));
//identities=[A1[2]=D2[1],A1[3]=D3[1],A5[1]=D5[1],A5[2]=D2[2],A6[1]=D3[2],A6[2]=D4[2],A7[1]=D5[2],A7[2]=D8[1],A9[1]=D9[1],A9[2]=D4[3],A10[1]=D8[2],A10[2]=D9[2],]
    });
  });
}
