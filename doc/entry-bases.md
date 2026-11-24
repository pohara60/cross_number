# Entry bases: design for base-aware entries

## Purpose and scope

This document designs an opt-in extension to the solver for puzzles whose entries are
written in a per-entry number base and may use digits `0`–`9`, `A`–`G` (values `0`–`16`).

The motivating puzzle is *Base Squares* (Listener 4947), where:

- every entry is a square in the range `4`–`676`;
- the entry is written in one of the bases `2`–`17`;
- the base is not fixed by the grid, only by the clue and the global constraints;
- the grid uses `0`–`16` as digit symbols;
- global rules constrain base usage, square usage, zero count and digit presence.

The design keeps the existing decimal solver unchanged. Base-aware puzzles use a
separate, self-contained model and solver under `lib/src/base/`. The existing
`Solver`, `Expressable`, `Entry`, `Cell`, expression engine, inversion, grouping and
tracing code are not modified.

## Non-goals

- No general expression support for base-aware entries. Base Squares needs only
  value, base, digit and always-square clues.
- No change to the behaviour of any existing puzzle.
- No external CSP/SAT dependency.
- No GUI or generic puzzle-definition format.
- No attempt to make the main solver polymorphic over digit alphabets.

## Why the existing solver is not extended directly

The current model is deliberately decimal:

| Location | Assumption |
| --- | --- |
| `Entry.possibleValues` | `Set<int>` of base-10 values |
| `Cell.possibleDigits` | hard-coded `{1, …, 9}` |
| `Solver` grid propagation | compares `value.toString()[index]` |
| `DigitRangeConstraint` | parses decimal digits |
| `ExpressionConstraint` | evaluates decimal integers |

A base-aware entry is not identified by its value alone. The same value can be
written differently in different bases, and the same digit string has a different
value in each base. A base-aware domain is therefore a set of triples:

```text
(base, base-10 value, digit string)
```

Changing `possibleValues` from `Set<int>` to a base-aware value type would touch the
expression evaluator, inverter, grouping, distinctness, tracing and every existing
puzzle. Adding a `maxDigit` field to `Cell` would also change the default digit
domain for every puzzle. Both changes violate the goal of not over-complicating the
existing solver.

The base-aware path therefore gets its own model, domains and search loop. It reuses
the existing grid parser and geometry, which are independent of arithmetic.

## Design principles

1. **Isolation.** All new arithmetic, domains and search live in `lib/src/base/`.
2. **Reuse geometry, not arithmetic.** `Grid.fromString` discovers entries, cells and
   bars. The base solver maps those entries to its own domains.
3. **Small, explicit model.** A base puzzle is described by entry clues plus a small
   set of global rules, not by arbitrary expressions.
4. **Precompute first.** Every entry has a small finite domain of candidate options.
   The solver only propagates and searches over those options.
5. **Enumerate, then explain.** The solver can return all solutions so the caller can
   report ambiguous always-square entries.
6. **Opt-in entry point.** Existing puzzles continue through `Solver`; base puzzles
   use `BaseSolver` from a separate CLI entry point.

## Proposed module layout

```text
lib/src/base/
  digits.dart          # digit symbols, conversion, DigitString
  entry_option.dart    # EntryOption: base + value + digits
  base_puzzle.dart     # BasePuzzleDefinition, clues, global rules
  base_domains.dart    # candidate generation and always-square test
  base_solver.dart     # AC-3, global propagation, search
  base_solution.dart   # solution grid and ambiguity report

puzzles/base_squares.dart
bin/base_squares.dart
test/base_squares_test.dart
```

No existing file under `lib/src/` needs to change.

## Data model

### Digits

Digits are represented internally as `int` values `0`–`16`. The symbol table is the
same one used by the puzzle:

```dart
const digitSymbols = '0123456789ABCDEFG';

int digitValue(String symbol) => digitSymbols.indexOf(symbol.toUpperCase());

String digitSymbol(int digit) => digitSymbols[digit];

String digitsToString(Iterable<int> digits) =>
    digits.map(digitSymbol).join();
```

A `DigitString` is a small immutable value class so it can be used as a map key and
compared cheaply. The equality helper comes from
`package:collection/collection.dart`:

```dart
class DigitString {
  final List<int> digits;

  DigitString(List<int> digits)
      : digits = List.unmodifiable(digits);

  int get length => digits.length;

  @override
  bool operator ==(Object other) =>
      other is DigitString && listEquals(other.digits, digits);

  @override
  int get hashCode => Object.hashAll(digits);

  @override
  String toString() => digitsToString(digits);
}
```

### Entry options

An option is one possible filling of an entry:

```dart
class EntryOption {
  /// Base in which [digits] are interpreted.
  final int base;

  /// Base-10 value of the digit string in [base].
  final int value;

  /// Digits of [value] in [base], most significant first.
  final DigitString digits;

  const EntryOption(this.base, this.value, this.digits);
}
```

`EntryOption` is the unit of propagation and search. It carries everything needed to
check a clue and to fill the grid.

### Entry clues

A small sealed hierarchy keeps clue handling explicit:

```dart
sealed class BaseEntryClue {
  const BaseEntryClue();
}

class UncluedClue extends BaseEntryClue {
  const UncluedClue();
}

class ValueClue extends BaseEntryClue {
  final int value; // base-10 square
  const ValueClue(this.value);
}

class BaseClue extends BaseEntryClue {
  final int base;
  const BaseClue(this.base);
}

class AlwaysSquareClue extends BaseEntryClue {
  const AlwaysSquareClue();
}

class MiddleDigitSquareClue extends BaseEntryClue {
  const MiddleDigitSquareClue();
}

class NotValueClue extends BaseEntryClue {
  final int value;
  const NotValueClue(this.value);
}

class NotBaseClue extends BaseEntryClue {
  final int base;
  const NotBaseClue(this.base);
}
```

### Global rules

The global rules are data, not code:

```dart
class CountRule {
  final int min;
  final int max;
  const CountRule(this.min, this.max);
}

class BaseGlobalRules {
  /// Bases that must be used exactly the mapped number of times.
  final Map<int, int> exactBaseCounts;

  /// Bases whose usage must lie in the given range.
  final Map<int, CountRule> baseCountRanges;

  /// Square values whose usage must lie in the given range.
  final Map<int, CountRule> valueCountRanges;

  /// Exact number of zero cells in the grid.
  final int zeroCount;

  /// Digits that must appear at least once in the grid.
  final Set<int> requiredDigits;

  /// Whether all entry digit strings must be distinct.
  final bool distinctEntries;

  const BaseGlobalRules({
    required this.exactBaseCounts,
    required this.baseCountRanges,
    required this.valueCountRanges,
    required this.zeroCount,
    required this.requiredDigits,
    required this.distinctEntries,
  });
}
```

### Puzzle definition

```dart
class BasePuzzleDefinition {
  final String name;
  final String gridString;
  final Map<String, BaseEntryClue> clues;
  final BaseGlobalRules rules;

  const BasePuzzleDefinition({
    required this.name,
    required this.gridString,
    required this.clues,
    required this.rules,
  });
}
```

The `gridString` uses the existing `Grid.fromString` format. Numbers mark entry
starts, and `:` / `::` mark open cell boundaries. Black cells are cells that belong to
no across or down entry; they need no special marker in the base model.

### Base entry

```dart
typedef CellCoord = ({int row, int col});

class BaseEntry {
  final String id;
  final EntryOrientation orientation;
  final List<CellCoord> cells;
  final BaseEntryClue clue;
  final List<EntryOption> domain;

  const BaseEntry({
    required this.id,
    required this.orientation,
    required this.cells,
    required this.clue,
    required this.domain,
  });

  factory BaseEntry.fromGeometry(
    Entry entry, {
    required BaseEntryClue clue,
    required List<EntryOption> domain,
  }) {
    final cells = entry.orientation == EntryOrientation.across
        ? [
            for (var i = 0; i < entry.length; i++)
              (row: entry.row, col: entry.col + i),
          ]
        : [
            for (var i = 0; i < entry.length; i++)
              (row: entry.row + i, col: entry.col),
          ];

    return BaseEntry(
      id: entry.id,
      orientation: entry.orientation,
      cells: cells,
      clue: clue,
      domain: domain,
    );
  }
}
```

## Candidate generation

Candidate generation is the only place that knows about squares, bases and digit
strings. It is deterministic and runs once per entry.

```dart
const squares = <int>[
  4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225,
  256, 289, 324, 361, 400, 441, 484, 529, 576, 625, 676,
];

List<EntryOption> candidatesFor(
  int length,
  BaseEntryClue clue,
) {
  final options = <EntryOption>[];

  for (var base = 2; base <= 17; base++) {
    for (final value in squares) {
      final digits = digitsOf(value, base, length);
      if (digits == null) continue; // wrong length or leading zero

      if (!clueAccepts(clue, base, value, digits)) continue;
      options.add(EntryOption(base, value, digits));
    }
  }

  return options;
}
```

`digitsOf` returns exactly `length` digits, or `null` if the value does not fit:

```dart
DigitString? digitsOf(int value, int base, int length) {
  final digits = <int>[];
  var remaining = value;

  for (var i = 0; i < length; i++) {
    digits.add(remaining % base);
    remaining ~/= base;
  }

  if (remaining != 0) return null;

  final mostSignificantFirst = digits.reversed.toList();
  if (mostSignificantFirst.first == 0) return null;
  return DigitString(mostSignificantFirst);
}

int valueOf(DigitString digits, int base) {
  var value = 0;
  for (final digit in digits.digits) {
    value = value * base + digit;
  }
  return value;
}
```

Clue filtering:

```dart
bool clueAccepts(
  BaseEntryClue clue,
  int base,
  int value,
  DigitString digits,
) {
  return switch (clue) {
    UncluedClue() => true,
    ValueClue(value: final fixedValue) => fixedValue == value,
    BaseClue(base: final fixedBase) => fixedBase == base,
    AlwaysSquareClue() => isAlwaysSquare(digits),
    MiddleDigitSquareClue() =>
      const {0, 1, 4, 9}.contains(digits.digits[digits.length ~/ 2]),
    NotValueClue(value: final excludedValue) => excludedValue != value,
    NotBaseClue(base: final excludedBase) => excludedBase != base,
  };
}
```

### Always-square test

A digit string is always-square if, in every base where its digits are valid, the
value is a square:

```dart
final _alwaysSquareCache = <DigitString, bool>{};

bool isAlwaysSquare(DigitString digits) {
  return _alwaysSquareCache.putIfAbsent(digits, () {
    final maxDigit = digits.digits.reduce(max);

    for (var base = max(2, maxDigit + 1); base <= 17; base++) {
      if (!isSquare(valueOf(digits, base))) return false;
    }

    return true;
  });
}

bool isSquare(int value) {
  if (value < 0) return false;
  final root = sqrt(value).round();
  return root * root == value;
}
```

The entry range `4`–`676` is applied by candidate generation, not by
`isAlwaysSquare`. This matters for the puzzle's own examples: `900` and `10404`
are squares in every base even when their value exceeds `676`.

The cache is small because it is keyed by the digit strings actually produced by the
25 squares in the 16 bases. No combinatorial enumeration of all digit strings is
needed at solve time.

## Solver

The public surface is deliberately small:

```dart
class BaseSolver {
  final BasePuzzleDefinition puzzle;

  BaseSolver(this.puzzle);

  /// Enumerates solutions. Use [maxSolutions] to cap the search.
  BaseSolveResult solveAll({int maxSolutions = 1000}) { … }
}
```

`BaseSolveResult` owns the solutions and the ambiguity report shown below.

### Geometry

The base solver reuses `Grid.fromString` only for entry geometry:

```dart
final geometry = Grid.fromString(puzzle.gridString);
final entries = <BaseEntry>[];

for (final entry in geometry.entries.values) {
  final clue = puzzle.clues[entry.id] ?? const UncluedClue();
  entries.add(
    BaseEntry.fromGeometry(
      entry,
      clue: clue,
      domain: candidatesFor(entry.length, clue),
    ),
  );
}
```

`BaseEntry` stores the entry id, orientation, cells and precomputed domain. It does not
use `Entry.possibleValues`.

### Domains and cell intersections

Each entry has a `Set<int>` of option indices, or a bitset if preferred. Because
domains are small (at most a few hundred options), a `Set<int>` is sufficient and
easier to debug. A `BigInt` bitset is a drop-in optimisation if needed.

For every cell, the solver records the entries that cover it:

```dart
final cellEntries = <CellCoord, List<(int entry, int position)>>{};
```

### AC-3

The solver enforces arc consistency between every pair of entries that share a cell:

- For an option of entry A, there must be at least one option of entry B with the
  same digit at the shared cell.
- Remove unsupported options from A; if A changes, revisit entries that share a cell
  with A.

This is the same algorithm used by the prototype and is independent of the main
solver.

### Global propagation

After each assignment, propagate the global rules:

1. **Used strings.** Remove options whose digit string is already used, if
   `distinctEntries` is true.
2. **Base counts.** Remove options whose base is already at its maximum. If a base is
   still below its minimum and only one unassigned entry can supply it, force that
   entry to the base.
3. **Value counts.** The same logic for square values.
4. **Zero count.** Count zeros in cells that are already fixed. For unset cells,
   compute the intersection of possible digits across covering entries:
   - if the intersection is `{0}`, the cell is forced zero;
   - if `0` is not in the intersection, the cell cannot be zero.
   Prune when `16` is outside `[forcedZeros, possibleZeros]`.
5. **Required digits.** For each required digit not yet present, check that some unset
   cell can still take it. Prune if none can.

These rules are small and local. They are not part of the main `Solver`.

### Search

Search is standard MRV backtracking:

1. Choose the unassigned entry with the smallest remaining domain.
2. Try each option in turn.
3. Set its digits in the grid; check already-set cells.
4. Filter crossing entries' domains.
5. Propagate global rules.
6. Recurse.
7. Undo and continue.

At a leaf, verify all global rules and record the solution.

The prototype finds all nine Base Squares solutions in under a second, so no external
solver is needed.

## Solution and ambiguity report

```dart
class BaseSolution {
  /// Entry id to chosen option.
  final Map<String, EntryOption> entries;

  /// 9x9 grid of digit values; -1 for black cells.
  final List<List<int>> grid;
}

class BaseSolveResult {
  final BasePuzzleDefinition puzzle;
  final List<BaseSolution> solutions;

  /// Always-square entries with more than one base-10 value across solutions.
  Map<String, Set<int>> ambiguousAlwaysSquareValues() {
    final result = <String, Set<int>>{};

    final alwaysSquareIds = puzzle.clues.entries
        .where((entry) => entry.value is AlwaysSquareClue)
        .map((entry) => entry.key);

    for (final id in alwaysSquareIds) {
      final values = solutions
          .map((solution) => solution.entries[id]!.value)
          .toSet();
      if (values.length > 1) result[id] = values;
    }

    return result;
  }
}
```

For Base Squares the report is:

```text
D29 -> {64, 100, 144, 225, 256}
```

because the entry always reads `121`, and

```text
121_b = b² + 2b + 1 = (b + 1)²
```

so the value depends only on the base.

## Base Squares definition

The clue mapping is intentionally direct:

| Entry | Clue |
| --- | --- |
| `A10` | `BaseClue(5)` |
| `A12` | `ValueClue(25)` |
| `A13` | `AlwaysSquareClue()` |
| `A14` | `ValueClue(64)` |
| `A15` | `ValueClue(576)` |
| `A17` | `AlwaysSquareClue()` |
| `A25` | `AlwaysSquareClue()` |
| `A26` | `ValueClue(49)` |
| `A27` | `AlwaysSquareClue()` |
| `A30` | `ValueClue(9)` |
| `A31` | `NotBaseClue(10)` |
| `D17` | `MiddleDigitSquareClue()` |
| `D19` | `AlwaysSquareClue()` |
| `D24` | `NotValueClue(484)` |
| `D29` | `AlwaysSquareClue()` |
| `D30` | `AlwaysSquareClue()` |
| `D34` | `ValueClue(256)` |
| all others | `UncluedClue()` |

Global rules:

```dart
BaseGlobalRules baseSquaresRules() => BaseGlobalRules(
  exactBaseCounts: const {2: 3, 3: 3, 4: 3, 5: 3, 6: 3, 7: 3, 8: 3},
  baseCountRanges: {
    for (var base = 9; base <= 17; base++)
      base: const CountRule(1, 3),
  },
  valueCountRanges: {
    for (final value in squares) value: const CountRule(1, 2),
  },
  zeroCount: 16,
  requiredDigits: const {
    1, 2, 3, 4, 5, 6, 7, 8,
    9, 10, 11, 12, 13, 14, 15, 16,
  },
  distinctEntries: true,
);
```

## CLI integration

Keep the existing CLI untouched. Add a separate entry point:

```dart
// bin/base_squares.dart
import 'package:crossnumber/src/base/base_solver.dart';
import '../puzzles/base_squares.dart';

void main() {
  final puzzle = baseSquares();
  final result = BaseSolver(puzzle).solveAll();

  for (final solution in result.solutions) {
    print(result.render(solution));
    print('');
  }

  print('Ambiguous always-square values:');
  print(result.ambiguousAlwaysSquareValues());
}
```

If a single CLI is preferred later, add a `basePuzzleMap` branch to
`bin/cross_number_v2.dart`. That is a small routing change and does not touch
`Solver`.

### Running the solver

Follow the project runtime constraints: cap the old-generation heap and apply a
timeout. Run only one solver instance at a time.

```bash
timeout 60s dart --old_gen_heap_size=2048 run bin/base_squares.dart
```

## Testing

1. **Unit tests**
   - `digitsOf` for leading zeros, wrong lengths and base boundaries.
   - `isAlwaysSquare` for `121`, `10000`, `10404`, `900` and a negative case.
   - Candidate generation for a fixed value and a fixed base.
2. **Base Squares integration test**
   - Solve all solutions.
   - Assert that every entry satisfies its clue.
   - Assert base counts: bases `2`–`8` exactly three times, bases `9`–`17` between
     one and three times.
   - Assert every square value is used once or twice.
   - Assert exactly 16 zero cells.
   - Assert every digit `1`–`16` appears.
   - Assert all entry digit strings are distinct.
   - Assert `ambiguousAlwaysSquareValues()` is
     `{'D29': {64, 100, 144, 225, 256}}`.
3. **Regression**
   - Existing tests must pass unchanged.
   - `dart analyze` must be clean.

## Implementation phases

1. Add `digits.dart`, `entry_option.dart` and their unit tests.
2. Add `BasePuzzleDefinition`, clues and global rules.
3. Add candidate generation and `isAlwaysSquare`.
4. Add AC-3, global propagation and search.
5. Add `puzzles/base_squares.dart` and the integration test.
6. Add `bin/base_squares.dart` and a readable grid renderer.
7. Run the full test suite and `dart analyze`.

## Risks and open questions

- **Always-square interpretation.** The design treats a string as always-square if
  every syntactically valid base yields a square, regardless of the `4`–`676` entry
  range. This is the interpretation that makes `900` and `10404` always-square. The
  range filter is applied separately by candidate generation.
- **Multiple solutions.** Base Squares has more than one valid filling. The solver
  should enumerate all solutions and report ambiguity per always-square entry, rather
  than assume a unique grid.
- **Performance.** The prototype is fast enough with AC-3 and global propagation. If
  a future base puzzle has much larger domains, the option sets can be switched to
  `BigInt` bitsets without changing the public model.
- **Future expression support.** If a later puzzle needs expressions over base-aware
  entries, add a conversion layer that exposes the base-10 value to the expression
  evaluator. Do not make the expression engine base-aware.

## Acceptance criteria

- Base Squares is defined entirely through `BasePuzzleDefinition`.
- No existing solver or model file is modified.
- The base solver returns a valid grid and the D29 ambiguity set.
- Existing puzzles and tests are unaffected.
- The design remains understandable without reading the main solver.
