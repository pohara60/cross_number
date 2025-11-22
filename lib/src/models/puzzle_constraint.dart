import 'package:crossnumber/src/models/puzzle_definition.dart';

abstract class PuzzleConstraint {
  void initialise(PuzzleDefinition puzzle, {bool trace = false});
  (bool consistent, bool updated) propagate(PuzzleDefinition puzzle,
      {bool trace = false});
  (bool consistent, bool updated) enforceDistinct(PuzzleDefinition puzzle,
      {bool trace = false});
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false});
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false});
}
