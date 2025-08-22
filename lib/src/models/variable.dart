import '../utils/set.dart';
import 'constraint.dart';
import 'expressable.dart';

/// Represents a variable in a cross number puzzle.
///
/// A variable is a named quantity that can take on a range of possible integer values.
/// Variables are often used in clues that are defined by mathematical expressions.
class Variable extends Expressable {
  /// The name of the variable.
  final String name;

  @override
  String get id => name;

  @override
  Set<int> get possibleValues => super.possibleValues!;

  /// The list of constraints that apply to this variable.
  @override
  final List<Constraint> constraints;

  /// Creates a new variable with the given [name] and [possibleValues].
  Variable(this.name, Set<int>? possibleValues, {this.constraints = const []}) {
    super.possibleValues = possibleValues;
  }

  Variable copyWith({
    String? name,
    Set<int>? possibleValues,
    List<Constraint>? constraints,
  }) {
    return Variable(
      name ?? this.name,
      possibleValues ?? possibleValues,
      constraints: constraints ?? this.constraints,
    );
  }

  @override
  String toString() {
    return '$name: ${possibleValues.length} ${possibleValues.toShortString()}';
  }
}
