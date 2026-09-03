/// The orientation of an entry in the grid.
enum EntryOrientation { across, down, up }

// Expressable:
class Intersection {
  final String otherId;
  final int otherDigit;
  final int thisDigit;

  Intersection(this.thisDigit, this.otherId, this.otherDigit);
}

typedef GetValues = Set<int> Function(BacktrackingSolver solver, Expressable expressable);
typedef CheckValue = bool Function(BacktrackingSolver solver, Expressable expressable, int value);

class Expressable {
  final String id;
  final String description;
  final int? length;
  List<Intersection>? intersections;
  final GetValues? getValues;
  final CheckValue? checkValue;

  Set<int> possibleValues;

  Expressable(
      {required this.id,
      this.description = '',
      this.length,
      this.possibleValues = const {},
      this.intersections,
      this.getValues,
      this.checkValue});

  Set<int> getPossibleValues(BacktrackingSolver backtrackingSolver) {
    var getValues = this.getValues;
    if (getValues != null) {
      return getValues(backtrackingSolver, this);
    }
    return possibleValues;
  }
}

typedef CheckSolution = bool Function(BacktrackingSolver solver);

class BacktrackingSolver {
  final Map<String, Expressable> expressables;

  BacktrackingSolver({required this.expressables});

  var expressableValues = <String, dynamic>{};

  void solve({bool trace = false, List<String> expressableOrder = const [], CheckSolution? checkSolution}) {
    if (expressableOrder.isEmpty) {
      expressableOrder = expressables.keys.toList();
    }

    var solutionCount = solveExpressables(expressableOrder, 0, 0, checkSolution);
    print('solutionCount=$solutionCount');
  }

  int solveExpressables(List<String> expressableOrder, int index, int solutionCount, CheckSolution? checkSolution) {
    if (index >= expressableOrder.length) {
      // Solution?
      bool ok = true;
      if (checkSolution != null) ok = checkSolution(this);
      if (ok) {
        solutionCount++;
        printSolution(solutionCount);
      }
      return solutionCount;
    }

    final id = expressableOrder[index];
    if (expressables[id] == null) {
      throw Exception('Expressable $id not defined');
    }

    final expressable = expressables[id]!;
    for (var value in expressable.getPossibleValues(this)) {
      if (expressableValues.containsValue(value)) continue;
      if (!checkExpressableValue(id, value)) continue;

      expressableValues[id] = value;
      solutionCount = solveExpressables(expressableOrder, index + 1, solutionCount, checkSolution);
      expressableValues.remove(id);
    }
    return solutionCount;
  }

  void printSolution(int solutionCount) {
    print('Solution $solutionCount');
    for (var expressableValue in expressableValues.entries) {
      var id = expressableValue.key;
      var value = expressableValue.value;
      print('$id=$value');
    }
  }

  bool checkExpressableValue(String id, int value) {
    var expressable = expressables[id]!;
    var valueStr = value.toString();

    // Check intersections
    for (var intersection in expressable.intersections ?? []) {
      var otherId = intersection.otherId;
      var otherExpressable = expressables[otherId]!;
      var otherValues = otherExpressable.possibleValues;
      if (expressableValues.containsKey(otherId)) otherValues = {expressableValues[otherId]!};
      var otherOk = false;
      for (var otherValue in otherValues) {
        var otherValueStr = otherValue.toString();
        if (valueStr[intersection.thisDigit] == otherValueStr[intersection.otherDigit]) {
          otherOk = true;
          break;
        }
      }
      if (!otherOk) return false;
    }

    // Specific check function?
    var checkValue = expressable.checkValue;
    if (checkValue != null) {
      if (!checkValue(this, expressable, value)) {
        return false;
      }
    }

    return true;
  }

  bool updateExpressablesFromGrid(String gridString) {
    final lines = gridString.split('\n');
    final rows = (lines.length - 1) ~/ 2; // Integer division
    final cols = (lines[0].length - 1) ~/ 3; // Integer division

    // Data structures to hold parsed information temporarily
    final List<List<String>> cellContents = []; // 2D array of 2-char strings
    final List<List<String>> horizontalSeparators = []; // 2D array of 1-char strings
    final List<List<String>> verticalSeparators = []; // 2D array of 2-char strings

    // Parse lines
    // First line is the header, skip it
    // First column is a vertical separator, skip it
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i];
      if (i % 2 == 1) {
        // Cell row
        final List<String> rowCellContents = [];
        final List<String> rowHorizontalSeparators = [];
        for (var j = 1; j < line.length; j += 3) {
          rowCellContents.add(line.substring(j, j + 2).trim());
          if (j + 2 < line.length) {
            rowHorizontalSeparators.add(line.substring(j + 2, j + 3));
          }
        }
        cellContents.add(rowCellContents);
        horizontalSeparators.add(rowHorizontalSeparators);
      } else {
        // Separator row
        final List<String> rowVerticalSeparators = [];
        for (var j = 1; j < line.length; j += 3) {
          rowVerticalSeparators.add(line.substring(j, j + 2));
        }
        verticalSeparators.add(rowVerticalSeparators);
      }
    }

    final actualRows = cellContents.length;
    final actualCols = cellContents.isNotEmpty ? cellContents[0].length : 0;

    // Helper to get cell content at (r, c)
    String getCellContent(int r, int c) {
      return cellContents[r][c];
    }

    // Helper to get horizontal separator after cell (r, c)
    String? getHorizontalSeparator(int r, int c) {
      if (r < horizontalSeparators.length && c < horizontalSeparators[r].length) {
        return horizontalSeparators[r][c];
      }
      return null;
    }

    // Helper to get vertical separator below cell (r, c)
    String? getVerticalSeparator(int r, int c) {
      if (r < verticalSeparators.length && c < verticalSeparators[r].length) {
        return verticalSeparators[r][c];
      }
      return null;
    }

    // Iterate and create entries
    var acrossEntries = <String>[];
    var downEntries = <String>[];
    var gridAcrossEntries = List.generate(rows, (r) => List.generate(cols, (c) => ''));
    var gridDownEntries = List.generate(rows, (r) => List.generate(cols, (c) => ''));
    for (var r = 0; r < actualRows; r++) {
      for (var c = 0; c < actualCols; c++) {
        final cellContent = getCellContent(r, c);

        String? acrossLetter;
        String? downLetter;
        int? number;

        if (cellContent.isNotEmpty) {
          // Check if the cell content is a number
          final numValue = int.tryParse(cellContent);
          if (numValue != null) {
            number = numValue;
          } else if (cellContent.length == 1) {
            if (cellContent.toUpperCase() == cellContent) {
              acrossLetter = cellContent;
            } else {
              downLetter = cellContent;
            }
          } else if (cellContent.length == 2) {
            // Assume first char is across, second is down
            if (cellContent[0].toUpperCase() == cellContent[0]) {
              acrossLetter = cellContent[0];
              downLetter = cellContent[1];
            } else {
              acrossLetter = cellContent[1];
              downLetter = cellContent[0];
            }
          }
        }

        // Create Across entry if applicable
        if (acrossLetter != null || number != null) {
          final entryId = acrossLetter ?? 'A$cellContent';
          // Extend length by checking horizontal separators
          int length = 1;
          for (var k = c; k < actualCols - 1; k++) {
            final separator = getHorizontalSeparator(r, k);
            if (separator == ':') {
              length++;
            } else {
              break;
            }
          }
          if (length > 1) {
            acrossEntries.add(entryId);
            // final entry = Entry(
            //   id: entryId,
            //   row: r,
            //   col: c,
            //   length: length,
            //   orientation: EntryOrientation.across,
            //   clueId: clueId,
            // );
            // Get intersection with
            for (var k = 0; k < length; k++) {
              gridAcrossEntries[r][c + k] = entryId;
            }
          }
        }

        // Create Down entry if applicable
        if (downLetter != null || number != null) {
          final entryId = downLetter ?? 'D$cellContent';
          int length = 1;
          // Extend length by checking vertical separators
          for (var k = r; k < actualRows - 1; k++) {
            final separator = getVerticalSeparator(k, c);
            if (separator == '::') {
              length++;
            } else {
              break;
            }
          }
          if (length > 1) {
            downEntries.add(entryId);
            // final entry = Entry(
            //   id: entryId,
            //   row: r,
            //   col: c,
            //   length: length,
            //   orientation: EntryOrientation.down,
            //   clueId: clueId,
            // );
            // Assign this entry to all cells it spans
            for (var k = 0; k < length; k++) {
              gridDownEntries[r + k][c] = entryId;
            }
          }
        }
      }
    }
    // Match grid across/down with expressables
    bool checkEntry(String id, List<String> intersectionIds, List<int> intersectionIndexes) {
      var expressable = expressables[id];
      var ok = true;
      if (expressable != null) {
        if (expressable.intersections == null || expressable.intersections!.isEmpty) {
          expressable.intersections = [];
          for (var digit = 0; digit < intersectionIds.length; digit++) {
            if (intersectionIds[digit] != '') {
              var intersection = Intersection(digit, intersectionIds[digit], intersectionIndexes[digit]);
              expressable.intersections!.add(intersection);
            }
          }
        } else {
          for (var intersection in expressable.intersections ?? []) {
            var digit = intersection.thisDigit;
            var otherDigit = intersection.otherDigit;
            var otherId = intersection.otherId;
            if (intersectionIds[digit] != otherId || intersectionIndexes[digit] != otherDigit) {
              print('Entry $id intersection for digit $digit does not match!');
              ok = false;
            }
          }
          var count = intersectionIds.where((i) => i != '').length;
          if (expressable.intersections!.length != count) {
            print('Entry $id intersection count should be $count!');
          }
        }
      }
      return ok;
    }

    var ok = true;
    for (var r = 0; r < rows; r++) {
      var prevAcross = '';
      var intersectionIds = <String>[];
      var intersectionIndexes = <int>[];
      for (var c = 0; c < cols; c++) {
        var currentAcross = gridAcrossEntries[r][c];
        if (currentAcross != prevAcross && prevAcross != '') {
          ok = ok && checkEntry(prevAcross, intersectionIds, intersectionIndexes);
          intersectionIds = <String>[];
          intersectionIndexes = <int>[];
        }
        prevAcross = currentAcross;
        if (currentAcross != '') {
          var currentDown = gridDownEntries[r][c];
          if (currentDown != '') {
            var count = 0;
            for (var prevR = r - 1; prevR >= 0; prevR--) {
              if (currentDown != gridDownEntries[prevR][c]) break;
              count++;
            }
            intersectionIds.add(currentDown);
            intersectionIndexes.add(count);
          } else {
            intersectionIds.add('');
            intersectionIndexes.add(0);
          }
        }
      }
      if (prevAcross != '') {
        ok = ok && checkEntry(prevAcross, intersectionIds, intersectionIndexes);
      }
    }
    return ok;
  }
}
