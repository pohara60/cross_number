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
  final List<Intersection> intersections;
  final GetValues? getValues;
  final CheckValue? checkValue;

  Set<int> possibleValues;

  Expressable(
      {required this.id,
      this.description = '',
      this.length,
      this.possibleValues = const {},
      this.intersections = const [],
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

  var expressableValues = <String, int>{};

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
    for (var intersection in expressable.intersections) {
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
}
