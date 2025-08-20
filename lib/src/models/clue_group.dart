class ClueGroup {
  final List<String> clues;
  final List<String> variables;

  ClueGroup({required this.clues, required this.variables});

  @override
  String toString() {
    return 'ClueGroup(clues: $clues, variables: $variables)';
  }
}
