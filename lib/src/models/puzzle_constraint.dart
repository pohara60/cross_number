import 'package:crossnumber/src/models/puzzle_definition.dart';

abstract class PuzzleConstraint {
  bool propagate(PuzzleDefinition puzzle, {bool trace = false});
}
