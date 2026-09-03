class ExpressableGroup {
  final List<String> expressables;
  final List<String> variables;

  ExpressableGroup({required this.expressables, required this.variables});

  @override
  String toString() {
    return 'ClueGroup(clues: $expressables, variables: $variables)';
  }
}
