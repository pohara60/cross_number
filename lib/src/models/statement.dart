class Statement {
  final String id;
  final String expression;
  final int priority;

  Statement(this.id, this.expression, {this.priority = 0});

  @override
  String toString() {
    return 'Statement($id: $expression, priority: $priority)';
  }

  Statement copyWith({
    String? id,
    String? expression,
    int? priority,
  }) {
    return Statement(
      id ?? this.id,
      expression ?? this.expression,
      priority: priority ?? this.priority,
    );
  }
}
