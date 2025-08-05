/// Generates all possible combinations of variable values from the given domains.
///
/// Given a map of variable names to their possible integer values (domains),
/// this function returns a list of all possible maps from variable names to a
/// single integer value.
///
/// For example, given `{'A': {1, 2}, 'B': {3, 4}}`, this function will return:
/// `[{'A': 1, 'B': 3}, {'A': 1, 'B': 4}, {'A': 2, 'B': 3}, {'A': 2, 'B': 4}]`
List<Map<String, int>> generateCombinations(
    Map<String, Set<int>> variableDomains) {
  final List<Map<String, int>> combinations = [];

  if (variableDomains.isEmpty) {
    return [{}];
  }

  final variableNames = variableDomains.keys.toList();

  void _generate(int index, Map<String, int> currentCombination) {
    if (index == variableNames.length) {
      combinations.add(Map.from(currentCombination));
      return;
    }

    final varName = variableNames[index];
    final domain = variableDomains[varName]!;

    for (final value in domain) {
      currentCombination[varName] = value;
      _generate(index + 1, currentCombination);
    }
  }

  _generate(0, {});
  return combinations;
}
