import 'base_puzzle.dart';
import 'digits.dart';
import 'entry_option.dart';

/// One complete solution of a base-aware puzzle.
class BaseSolution {
  /// The chosen option for each entry, keyed by entry id.
  final Map<String, EntryOption> entries;

  /// The grid digits. Black cells are `-1`.
  final List<List<int>> grid;

  /// Creates a solution.
  const BaseSolution({required this.entries, required this.grid});
}

/// The result of a base-aware solve.
class BaseSolveResult {
  /// The puzzle definition.
  final BasePuzzleDefinition puzzle;

  /// All solutions found.
  final List<BaseSolution> solutions;

  /// Creates a solve result.
  const BaseSolveResult({required this.puzzle, required this.solutions});

  /// Always-square entries with more than one base-10 value across solutions.
  Map<String, Set<int>> ambiguousAlwaysSquareValues() {
    final result = <String, Set<int>>{};

    final alwaysSquareIds =
        puzzle.clues.entries.where((entry) => entry.value is AlwaysSquareClue).map((entry) => entry.key);

    for (final id in alwaysSquareIds) {
      final values = solutions
          .where((solution) => solution.entries.containsKey(id))
          .map((solution) => solution.entries[id]!.value)
          .toSet();
      if (values.length > 1) {
        result[id] = values;
      }
    }

    return result;
  }

  /// Renders a solution as a digit grid.
  String render(BaseSolution solution) {
    final buffer = StringBuffer();
    for (final row in solution.grid) {
      buffer.writeln(
        row.map((digit) => digit < 0 ? '##' : digitSymbol(digit)).join(' '),
      );
    }
    return buffer.toString();
  }
}
