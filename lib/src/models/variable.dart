/// Represents a variable in a cross number puzzle.
///
/// A variable is a named quantity that can take on a range of possible integer values.
/// Variables are often used in clues that are defined by mathematical expressions.
class Variable {
  /// The name of the variable.
  final String name;

  /// The set of possible integer values for this variable.
  /// This set is narrowed down by the solver as constraints are applied.
  Set<int> possibleValues;

  /// Creates a new variable with the given [name] and [possibleValues].
  Variable(this.name, this.possibleValues);

  Variable copyWith({
    String? name,
    Set<int>? possibleValues,
  }) {
    return Variable(
      name ?? this.name,
      possibleValues ?? this.possibleValues,
    );
  }
}
