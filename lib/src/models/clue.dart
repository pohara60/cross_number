import 'dart:math' as math;

import '../utils/set.dart';
import 'constraint.dart';
import 'entry.dart';
import 'expressable.dart';

/// Represents a single clue in a cross number puzzle.
///
/// A clue has an [id], a set of [constraints] that define its value,
/// and a set of [possibleValues] that the clue can take.
class Clue extends Expressable {
  /// The unique identifier for the clue (e.g., "A1", "B2").
  @override
  final String id;

  /// The entry associated with this clue, if any.
  Entry? entry;

  /// Length of the clue, if known.
  final int? length;

  /// The list of constraints that apply to this clue.
  @override
  final List<Constraint> constraints;

  /// Min and max values for the clue.
  /// Determined by the puzzle entry length, if any.
  /// Restricted by current possibleValues if they are set.
  @override
  int? get min {
    if (possibleValues != null && possibleValues!.isNotEmpty) {
      return possibleValues!.reduce(math.min);
    }
    var length = this.length ?? entry?.length;
    if (length != null) return math.pow(10, length - 1).toInt();
    return null;
  }

  @override
  int? get max {
    if (possibleValues != null && possibleValues!.isNotEmpty) {
      return possibleValues!.reduce(math.max);
    }
    var length = this.length ?? entry?.length;
    if (length != null) return math.pow(10, length).toInt() - 1;
    return null;
  }

  /// Creates a new clue with the given [id] and [constraints].
  Clue(this.id, this.constraints, {this.entry, this.length});

  /// Solves the clue by applying its constraints.
  ///
  /// This method iterates through the constraints of the clue and uses them
  /// to narrow down the set of [possibleValues].
  ///
  /// Returns `true` if the set of possible values was updated, `false` otherwise.
  // bool solve(PuzzleDefinition puzzle, List<String> updatedVariables,
  //     {bool trace = false}) {
  //       return solveExpression(this, updatedVariables,
  //           trace: trace, puzzle: puzzle);
  //     }

  Clue copyWith({
    String? id,
    List<Constraint>? constraints,
    Set<int>? possibleValues,
  }) {
    return Clue(
      id ?? this.id,
      constraints ?? this.constraints,
    )..possibleValues = possibleValues != null
        ? Set<int>.from(possibleValues)
        : possibleValues == null
            ? null
            : Set<int>.from(possibleValues);
  }

  @override
  String toString() {
    var b = StringBuffer();
    b.write('$id: ');
    if (expressionTrees.isNotEmpty) {
      b.write(expressionTrees.map((e) => e.toString()).join(', '));
    }
    b.write(' ${possibleValues?.length} ${possibleValues?.toShortString()}');
    return b.toString();
  }
}
