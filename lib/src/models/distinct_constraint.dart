import 'constraint.dart';

class DistinctConstraint extends Constraint {
  final bool allClues;
  final bool allEntries;
  final bool allVariables;

  DistinctConstraint({
    this.allClues = true,
    this.allEntries = true,
    this.allVariables = true,
  });
}
