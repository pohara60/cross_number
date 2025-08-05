import 'package:test/test.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/entry.dart';

void main() {
  group('Grid', () {
    test('should populate the grid correctly', () {
      final entries = {
        'A1': Entry(id: 'A1', row: 0, col: 0, length: 2, orientation: EntryOrientation.across, clueId: '1A'),
        'D1': Entry(id: 'D1', row: 0, col: 0, length: 2, orientation: EntryOrientation.down, clueId: '1D'),
      };
      final grid = Grid(2, 2);
      grid.populate(entries);

      expect(grid.cells[0][0].acrossEntry, equals(entries['A1']));
      expect(grid.cells[0][0].downEntry, equals(entries['D1']));
      expect(grid.cells[0][1].acrossEntry, equals(entries['A1']));
      expect(grid.cells[0][1].downEntry, isNull);
      expect(grid.cells[1][0].acrossEntry, isNull);
      expect(grid.cells[1][0].downEntry, equals(entries['D1']));
    });
  });
}
