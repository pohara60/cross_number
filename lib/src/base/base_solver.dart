import 'package:crossnumber/src/models/grid.dart';

import 'base_domains.dart';
import 'base_puzzle.dart';
import 'base_solution.dart';
import 'entry_option.dart';

/// Solves puzzles whose entries are written in per-entry number bases.
///
/// The solver is deliberately separate from the decimal [Solver]. It reuses
/// [Grid.fromString] only for entry geometry, then works on
/// [EntryOption] domains.
///
/// The solve has four stages:
/// 1. Build each entry's finite candidate domain from its clue.
/// 2. Enforce arc consistency between entries that share a cell (AC-3).
/// 3. Search with MRV backtracking, applying global rules at every node.
/// 4. Verify and record complete solutions.
///
/// Domains are sets of indices into [BaseEntry.domain]. Copying them per
/// branch keeps backtracking simple: a failed branch is discarded rather than
/// undone in place.
class BaseSolver {
  /// The puzzle definition.
  final BasePuzzleDefinition puzzle;

  late final Grid _geometry;
  late final List<BaseEntry> _entries;

  /// Entry indices covering each cell, with the position in that entry.
  late final Map<CellCoord, List<({int entry, int position})>> _cellEntries;

  /// Cells that belong to at least one entry. Black cells are absent.
  late final List<CellCoord> _allCells;

  /// Crossing graph: `_crossings[i][j]` lists cells shared by entries i and j.
  late final List<Map<int, List<_SharedCell>>> _crossings;

  /// Exact and ranged base-count rules merged into one lookup.
  late final Map<int, CountRule> _baseRules;

  /// Creates a solver for [puzzle].
  BaseSolver(this.puzzle) {
    _build();
  }

  /// Enumerates solutions. Use [maxSolutions] to cap the search.
  ///
  /// AC-3 runs once at the root. Global rules are then applied by
  /// [_propagate] at every search node. Returns an empty result if AC-3 proves
  /// the puzzle inconsistent.
  BaseSolveResult solveAll({int maxSolutions = 1000}) {
    final solutions = <BaseSolution>[];
    final domains = _initialDomains();
    if (!_ac3(domains)) {
      return BaseSolveResult(puzzle: puzzle, solutions: solutions);
    }

    _search(
      domains,
      List<int?>.filled(_entries.length, null),
      <CellCoord, int>{},
      solutions,
      maxSolutions,
    );

    return BaseSolveResult(puzzle: puzzle, solutions: solutions);
  }

  /// Builds geometry, candidate domains and the crossing graph.
  ///
  /// `_crossings` is symmetric: if entries i and j share a cell, both
  /// directions are recorded so propagation can revise either side.
  void _build() {
    _geometry = Grid.fromString(puzzle.gridString.trimRight());

    // Reuse the existing parser for cell/entry geometry, but compute the
    // arithmetic domain ourselves from the entry's clue.
    _entries = [
      for (final entry in _geometry.entries.values)
        () {
          final clue = puzzle.clues[entry.id] ?? const UncluedClue();
          return BaseEntry.fromGeometry(
            entry,
            clue: clue,
            domain: candidatesFor(entry.length, clue),
          );
        }(),
    ];

    // Index every cell by the entries that cover it. This is the basic
    // structure used for intersection checks and for the crossing graph.
    _cellEntries = {};
    for (var i = 0; i < _entries.length; i++) {
      final entry = _entries[i];
      for (var position = 0; position < entry.cells.length; position++) {
        _cellEntries.putIfAbsent(entry.cells[position], () => []).add((entry: i, position: position));
      }
    }

    _allCells = _cellEntries.keys.toList();

    // For each pair of entries sharing a cell, record which cell and which
    // digit position in each entry it corresponds to.
    _crossings = List.generate(
      _entries.length,
      (_) => <int, List<_SharedCell>>{},
    );

    for (final cell in _allCells) {
      final covering = _cellEntries[cell]!;
      for (var a = 0; a < covering.length; a++) {
        for (var b = a + 1; b < covering.length; b++) {
          final i = covering[a].entry;
          final j = covering[b].entry;
          if (i == j) continue;

          _crossings[i].putIfAbsent(j, () => []).add(
                _SharedCell(
                  covering[a].position,
                  covering[b].position,
                  cell,
                ),
              );
          _crossings[j].putIfAbsent(i, () => []).add(
                _SharedCell(
                  covering[b].position,
                  covering[a].position,
                  cell,
                ),
              );
        }
      }
    }

    _baseRules = {
      ...puzzle.rules.baseCountRanges,
      for (final entry in puzzle.rules.exactBaseCounts.entries) entry.key: CountRule(entry.value, entry.value),
    };
  }

  /// Creates the initial domain for every entry as the set of all option
  /// indices. Domains shrink as constraints are applied.
  List<Set<int>> _initialDomains() => [
        for (final entry in _entries)
          Set<int>.from(
            List<int>.generate(entry.domain.length, (index) => index),
          ),
      ];

  /// Maximum allowed uses of a square value.
  int _maxValueCount(int value) => puzzle.rules.valueCountRanges[value]?.max ?? 99;

  /// Maximum allowed uses of a base.
  int _maxBaseCount(int base) => _baseRules[base]?.max ?? 99;

  /// Enforces arc consistency between every pair of crossing entries.
  ///
  /// The queue contains directed arcs `(i, j)`. Revising i against j removes
  /// options from i that have no compatible option in j. When i shrinks, all
  /// entries crossing i must be revised again, except j, which just caused the
  /// change.
  bool _ac3(List<Set<int>> domains) {
    // Start with every directed crossing.
    final queue = <({int from, int to})>[];
    for (var i = 0; i < _entries.length; i++) {
      for (final j in _crossings[i].keys) {
        queue.add((from: i, to: j));
      }
    }

    var head = 0;
    while (head < queue.length) {
      final arc = queue[head++];
      if (!_revise(domains, arc.from, arc.to)) continue;
      if (domains[arc.from].isEmpty) return false;

      // A changed domain can invalidate support in its neighbours.
      for (final neighbour in _crossings[arc.from].keys) {
        if (neighbour != arc.to) {
          queue.add((from: neighbour, to: arc.from));
        }
      }
    }

    return true;
  }

  /// Removes options from entry [i] that cannot match any option of [j] on
  /// the cells they share. Returns true if the domain changed.
  bool _revise(List<Set<int>> domains, int i, int j) {
    final shared = _crossings[i][j]!;
    final remove = <int>[];

    for (final optionIndex in domains[i]) {
      final option = _entries[i].domain[optionIndex];
      var supported = false;

      // An option is supported if at least one option of j agrees on every
      // shared cell.
      for (final otherIndex in domains[j]) {
        final other = _entries[j].domain[otherIndex];
        var matches = true;
        for (final cell in shared) {
          if (option.digits.digits[cell.posI] != other.digits.digits[cell.posJ]) {
            matches = false;
            break;
          }
        }
        if (matches) {
          supported = true;
          break;
        }
      }

      if (!supported) remove.add(optionIndex);
    }

    domains[i].removeAll(remove);
    return remove.isNotEmpty;
  }

  /// Depth-first search with minimum-remaining-values (MRV) branching.
  ///
  /// Each node first runs global propagation. The unassigned entry with the
  /// smallest domain (ties broken by crossing degree) is then branched on.
  /// State is copied for each branch, so a failed branch is simply dropped.
  /// When every entry is assigned, the global rules are checked and the
  /// solution is recorded.
  void _search(
    List<Set<int>> domains,
    List<int?> assigned,
    Map<CellCoord, int> cellDigits,
    List<BaseSolution> solutions,
    int maxSolutions,
  ) {
    if (solutions.length >= maxSolutions) return;
    if (!_propagate(domains, assigned, cellDigits)) return;

    // MRV: pick the most constrained entry.
    int? best;
    var bestCount = 1 << 30;
    var bestDegree = -1;

    for (var i = 0; i < _entries.length; i++) {
      if (assigned[i] != null) continue;
      final count = domains[i].length;
      if (count == 0) return;
      final degree = _crossings[i].length;
      if (count < bestCount || (count == bestCount && degree > bestDegree)) {
        best = i;
        bestCount = count;
        bestDegree = degree;
      }
    }

    if (best == null) {
      if (_finalCheck(assigned, cellDigits)) {
        solutions.add(_buildSolution(assigned, cellDigits));
      }
      return;
    }

    final entry = _entries[best];
    final options = domains[best].toList();

    // Try each remaining option for the chosen entry.
    for (final optionIndex in options) {
      final option = entry.domain[optionIndex];
      if (!_canAssign(assigned, option)) continue;

      // Copy state so this branch can be discarded on failure.
      final newDomains = [
        for (final domain in domains) Set<int>.of(domain),
      ];
      final newAssigned = List<int?>.of(assigned);
      final newCellDigits = Map<CellCoord, int>.of(cellDigits);

      newAssigned[best] = optionIndex;

      // Write the option's digits; a crossing entry may already have set one.
      var conflict = false;
      for (var position = 0; position < entry.cells.length; position++) {
        final cell = entry.cells[position];
        final digit = option.digits.digits[position];
        final existing = newCellDigits[cell];
        if (existing != null && existing != digit) {
          conflict = true;
          break;
        }
        newCellDigits[cell] = digit;
      }
      if (conflict) continue;

      // Forward-check: drop neighbour options that now disagree.
      for (final neighbour in _crossings[best].keys) {
        if (newAssigned[neighbour] != null) continue;

        final shared = _crossings[best][neighbour]!;
        final remove = <int>[];
        for (final otherIndex in newDomains[neighbour]) {
          final other = _entries[neighbour].domain[otherIndex];
          var matches = true;
          for (final cell in shared) {
            if (other.digits.digits[cell.posJ] != option.digits.digits[cell.posI]) {
              matches = false;
              break;
            }
          }
          if (!matches) remove.add(otherIndex);
        }

        if (remove.isNotEmpty) {
          newDomains[neighbour].removeAll(remove);
          if (newDomains[neighbour].isEmpty) {
            conflict = true;
            break;
          }
        }
      }
      if (conflict) continue;

      // The child applies global rules before choosing its own branch.
      _search(
        newDomains,
        newAssigned,
        newCellDigits,
        solutions,
        maxSolutions,
      );
      if (solutions.length >= maxSolutions) return;
    }
  }

  /// Cheap pre-check before copying the full state: reject an option that
  /// would exceed a value/base count or duplicate an already used string.
  bool _canAssign(List<int?> assigned, EntryOption option) {
    var valueCount = 0;
    var baseCount = 0;
    final usedStrings = <String>{};

    for (var i = 0; i < _entries.length; i++) {
      final assignedIndex = assigned[i];
      if (assignedIndex == null) continue;
      final other = _entries[i].domain[assignedIndex];
      if (other.value == option.value) valueCount++;
      if (other.base == option.base) baseCount++;
      usedStrings.add(other.digits.toString());
    }

    if (valueCount >= _maxValueCount(option.value)) return false;
    if (baseCount >= _maxBaseCount(option.base)) return false;
    if (puzzle.rules.distinctEntries && usedStrings.contains(option.digits.toString())) {
      return false;
    }

    return true;
  }

  /// Applies the global rules until no further domain changes occur.
  ///
  /// The rules are:
  /// - remove options that would exceed a value/base limit or reuse a string;
  /// - force a value/base when the remaining candidates are exactly the
  ///   number still needed;
  /// - keep the zero count reachable;
  /// - keep every required digit reachable.
  ///
  /// Returns false as soon as the current state is inconsistent.
  bool _propagate(
    List<Set<int>> domains,
    List<int?> assigned,
    Map<CellCoord, int> cellDigits,
  ) {
    var changed = true;

    while (changed) {
      changed = false;

      // Counts from the assignments made so far.
      final valueCount = <int, int>{};
      final baseCount = <int, int>{};
      final usedStrings = <String>{};

      for (var i = 0; i < _entries.length; i++) {
        final assignedIndex = assigned[i];
        if (assignedIndex == null) continue;
        final option = _entries[i].domain[assignedIndex];
        valueCount[option.value] = (valueCount[option.value] ?? 0) + 1;
        baseCount[option.base] = (baseCount[option.base] ?? 0) + 1;
        usedStrings.add(option.digits.toString());
      }

      // 1. Remove options that are already impossible.
      for (var i = 0; i < _entries.length; i++) {
        if (assigned[i] != null) continue;

        final remove = <int>[];
        for (final optionIndex in domains[i]) {
          final option = _entries[i].domain[optionIndex];

          if (puzzle.rules.distinctEntries && usedStrings.contains(option.digits.toString())) {
            remove.add(optionIndex);
            continue;
          }

          if ((valueCount[option.value] ?? 0) >= _maxValueCount(option.value)) {
            remove.add(optionIndex);
            continue;
          }

          if ((baseCount[option.base] ?? 0) >= _maxBaseCount(option.base)) {
            remove.add(optionIndex);
            continue;
          }
        }

        if (remove.isNotEmpty) {
          domains[i].removeAll(remove);
          if (domains[i].isEmpty) return false;
          changed = true;
        }
      }

      // 2. Value coverage: if only the needed number of entries can supply a
      // value, force those entries to it.
      for (final rule in puzzle.rules.valueCountRanges.entries) {
        final count = valueCount[rule.key] ?? 0;
        final need = rule.value.min - count;
        if (need <= 0) continue;

        final possible = <int>[];
        for (var i = 0; i < _entries.length; i++) {
          if (assigned[i] != null) continue;
          if (_domainHasValue(domains[i], i, rule.key)) {
            possible.add(i);
          }
        }

        if (possible.length < need) return false;

        if (possible.length == need) {
          for (final i in possible) {
            if (_restrictToValue(domains, i, rule.key)) changed = true;
            if (domains[i].isEmpty) return false;
          }
        }
      }

      // 3. Base coverage: same idea for base usage counts.
      for (final rule in _baseRules.entries) {
        final count = baseCount[rule.key] ?? 0;
        final need = rule.value.min - count;
        if (need <= 0) continue;

        final possible = <int>[];
        for (var i = 0; i < _entries.length; i++) {
          if (assigned[i] != null) continue;
          if (_domainHasBase(domains[i], i, rule.key)) {
            possible.add(i);
          }
        }

        if (possible.length < need) return false;

        if (possible.length == need) {
          for (final i in possible) {
            if (_restrictToBase(domains, i, rule.key)) changed = true;
            if (domains[i].isEmpty) return false;
          }
        }
      }

      // 4. Zero count: compute the range of zero cells still possible. A cell
      // is forced zero when every covering entry allows only 0 there.
      var zeroCount = 0;
      for (final digit in cellDigits.values) {
        if (digit == 0) zeroCount++;
      }

      final unsetCells = [
        for (final cell in _allCells)
          if (!cellDigits.containsKey(cell)) cell,
      ];

      var forcedZeros = 0;
      var possibleZeros = 0;

      for (final cell in unsetCells) {
        final possible = _cellPossibleDigits(
          cell,
          domains,
          assigned,
          cellDigits,
        );
        if (possible.isEmpty) return false;
        if (possible.length == 1 && possible.contains(0)) forcedZeros++;
        if (possible.contains(0)) possibleZeros++;
      }

      if (zeroCount + forcedZeros > puzzle.rules.zeroCount || zeroCount + possibleZeros < puzzle.rules.zeroCount) {
        return false;
      }

      // 5. Required digits: each must still be reachable in some unset cell.
      final presentDigits = cellDigits.values.toSet();
      for (final digit in puzzle.rules.requiredDigits) {
        if (presentDigits.contains(digit)) continue;

        var possible = false;
        for (final cell in unsetCells) {
          final digits = _cellPossibleDigits(
            cell,
            domains,
            assigned,
            cellDigits,
          );
          if (digits.contains(digit)) {
            possible = true;
            break;
          }
        }
        if (!possible) return false;
      }
    }

    return true;
  }

  /// Whether [domain] contains any option with [value].
  bool _domainHasValue(Set<int> domain, int entryIndex, int value) {
    for (final optionIndex in domain) {
      if (_entries[entryIndex].domain[optionIndex].value == value) {
        return true;
      }
    }
    return false;
  }

  /// Whether [domain] contains any option with [base].
  bool _domainHasBase(Set<int> domain, int entryIndex, int base) {
    for (final optionIndex in domain) {
      if (_entries[entryIndex].domain[optionIndex].base == base) {
        return true;
      }
    }
    return false;
  }

  /// Narrows [entryIndex] to options with [value]. Returns true if changed.
  bool _restrictToValue(
    List<Set<int>> domains,
    int entryIndex,
    int value,
  ) {
    final before = domains[entryIndex].length;
    domains[entryIndex].removeWhere(
      (optionIndex) => _entries[entryIndex].domain[optionIndex].value != value,
    );
    return domains[entryIndex].length != before;
  }

  /// Narrows [entryIndex] to options with [base]. Returns true if changed.
  bool _restrictToBase(
    List<Set<int>> domains,
    int entryIndex,
    int base,
  ) {
    final before = domains[entryIndex].length;
    domains[entryIndex].removeWhere(
      (optionIndex) => _entries[entryIndex].domain[optionIndex].base != base,
    );
    return domains[entryIndex].length != before;
  }

  /// Returns the digits still possible in [cell].
  ///
  /// For each entry covering the cell, collect the digits allowed at that
  /// position, then intersect the sets. A fixed cell returns its digit.
  /// This is a local bound used for zero-count and digit-presence pruning,
  /// not a full constraint solver.
  Set<int> _cellPossibleDigits(
    CellCoord cell,
    List<Set<int>> domains,
    List<int?> assigned,
    Map<CellCoord, int> cellDigits,
  ) {
    final existing = cellDigits[cell];
    if (existing != null) return {existing};

    final covering = _cellEntries[cell];
    if (covering == null || covering.isEmpty) return {};

    Set<int>? result;

    for (final item in covering) {
      final entryIndex = item.entry;
      final position = item.position;
      final Set<int> digits;

      final assignedIndex = assigned[entryIndex];
      if (assignedIndex != null) {
        digits = {
          _entries[entryIndex].domain[assignedIndex].digits.digits[position],
        };
      } else {
        digits = {};
        for (final optionIndex in domains[entryIndex]) {
          digits.add(
            _entries[entryIndex].domain[optionIndex].digits.digits[position],
          );
        }
      }

      if (result == null) {
        result = digits;
      } else {
        result.retainAll(digits);
      }

      if (result.isEmpty) return result;
    }

    return result ?? {};
  }

  /// Verifies the global rules for a complete assignment.
  ///
  /// Propagation should already have enforced these, but the final check is
  /// cheap and guards against rules that are only checked at the leaves.
  bool _finalCheck(
    List<int?> assigned,
    Map<CellCoord, int> cellDigits,
  ) {
    final valueCount = <int, int>{};
    final baseCount = <int, int>{};
    final usedStrings = <String>{};

    for (var i = 0; i < _entries.length; i++) {
      final assignedIndex = assigned[i];
      if (assignedIndex == null) return false;
      final option = _entries[i].domain[assignedIndex];
      valueCount[option.value] = (valueCount[option.value] ?? 0) + 1;
      baseCount[option.base] = (baseCount[option.base] ?? 0) + 1;

      if (puzzle.rules.distinctEntries && !usedStrings.add(option.digits.toString())) {
        return false;
      }
    }

    for (final rule in _baseRules.entries) {
      final count = baseCount[rule.key] ?? 0;
      if (count < rule.value.min || count > rule.value.max) return false;
    }

    for (final rule in puzzle.rules.valueCountRanges.entries) {
      final count = valueCount[rule.key] ?? 0;
      if (count < rule.value.min || count > rule.value.max) return false;
    }

    var zeroCount = 0;
    for (final digit in cellDigits.values) {
      if (digit == 0) zeroCount++;
    }
    if (zeroCount != puzzle.rules.zeroCount) return false;

    final presentDigits = cellDigits.values.toSet();
    for (final digit in puzzle.rules.requiredDigits) {
      if (!presentDigits.contains(digit)) return false;
    }

    return true;
  }

  /// Materializes a solution from the assignment and the filled cells.
  /// Cells that belong to no entry (black cells) are stored as -1.
  BaseSolution _buildSolution(
    List<int?> assigned,
    Map<CellCoord, int> cellDigits,
  ) {
    final entries = <String, EntryOption>{};
    for (var i = 0; i < _entries.length; i++) {
      entries[_entries[i].id] = _entries[i].domain[assigned[i]!];
    }

    final grid = List.generate(
      _geometry.rows,
      (row) => List.generate(
        _geometry.cols,
        (col) {
          final cell = (row: row, col: col);
          if (!_cellEntries.containsKey(cell)) return -1;
          return cellDigits[cell]!;
        },
      ),
    );

    return BaseSolution(entries: entries, grid: grid);
  }
}

/// A cell shared by two entries, with the digit position in each.
class _SharedCell {
  final int posI;
  final int posJ;
  final CellCoord cell;

  const _SharedCell(this.posI, this.posJ, this.cell);
}
