class Statement {
  final String id;
  final String expression;

  Statement(this.id, this.expression);

  @override
  String toString() {
    return 'Statement($id: $expression)';
  }

  Statement copyWith({
    String? id,
    String? expression,
  }) {
    return Statement(
      id ?? this.id,
      expression ?? this.expression,
    );
  }
}
