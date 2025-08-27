import 'constraint.dart';

class OrderingConstraint extends Constraint {
  final bool allClues;
  final bool allVariables;
  final List<String>? ids;

  OrderingConstraint({
    this.allClues = false,
    this.allVariables = false,
    this.ids,
  }) {
    if (allClues && allVariables) {
      throw ArgumentError('Cannot set both allClues and allVariables to true.');
    }
    if ((allClues || allVariables) && ids != null) {
      throw ArgumentError('Cannot set both a flag and a list of ids.');
    }
    if (!allClues && !allVariables && ids == null) {
      throw ArgumentError('Must set either a flag or a list of ids.');
    }
  }
}
