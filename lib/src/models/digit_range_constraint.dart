import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';

class DigitRangeConstraint extends PuzzleConstraint {
  final int min;
  final int max;

  DigitRangeConstraint({required this.min, required this.max});

  bool isDigitsInRange(String valueString) {
    for (var i = 0; i < valueString.length; i++) {
      var digit = int.parse(valueString[i]);
      if (digit < min || digit > max) {
        return false;
      }
    }
    return true;
  }

  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {
    for (var entry in puzzle.entries.values) {
      if (entry.possibleValues == null) continue;
      entry.possibleValues = entry.possibleValues!
          .where((value) => isDigitsInRange(value.toString()))
          .toSet();
    }
  }

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) {
    // No propagation needed, as initialise has already constrained the values
    return (true, false);
  }

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) {
    return (true, false);
  }

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) {
    for (var entry in puzzle.entries.values) {
      if (entry.solution == null) continue;
      if (!isDigitsInRange(entry.solution.toString())) {
        return false;
      }
    }
    return true;
  }

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {}
}
