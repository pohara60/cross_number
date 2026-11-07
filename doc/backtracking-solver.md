# Backtracking solver review

## Purpose and scope

This document reviews three approaches to solving the *One Sum Amuse, No?* puzzle, cross-checks the
conclusions against the *Snakes and Ladders* puzzle, and recommends how the generalised approach can be made
reusable. It then surveys the other puzzles in `puzzles/` to identify additional puzzle types and logic, and
sets out a workflow for specifying and solving a new puzzle quickly.

The three One Sum approaches are:

- `puzzles/onesumamuse.dart` – the main project solver with expression constraints and a puzzle-specific
  `sum3digitsquares` function.
- `puzzles/onesumamuse_test.dart` – a manual, fully explicit nested-loop solution.
- `puzzles/onesumamuse_test_new.dart` – a generalised attempt using the standalone `BacktrackingSolver` in
  `lib/src/backtracking_solver.dart`.

A second pair of files, `puzzles/snakes_and_ladders.dart` and `puzzles/snakes_and_ladders_test.dart`, is
used as a cross-check. It shows what the existing framework can already do, where a manual search duplicates
or disables framework features, and which parts of the framework a reusable solver should build on.

The recommendation is that the third One Sum approach is the best foundation for a generic search engine,
but that it should consume the existing `PuzzleDefinition`/`Expressable`/`Grid` model and the existing
constraint, generator and expression infrastructure rather than duplicating them.

## The One Sum puzzle and the key reasoning

The puzzle has four sum clues. Each clue contains two triples of three-digit numbers, and the two triples in a
clue are reverses of each other:

```text
A = sum3digitsquares(e,G,L)        = sum3digitsquares(b,'G,H+j)
a = sum3digitsquares(C,B,G)        = sum3digitsquares('G,J,M-c)
d = sum3digitsquares(G,h,M)        = sum3digitsquares(E+f+H,'G,L-F)
N = sum3digitsquares(7*D/12,G,g)   = sum3digitsquares(f-b/2,'G,K)
```

The shared precomputation in `onesumamuse_sum_squares.dart` finds all triples of three-digit numbers that
use the nine non-zero digits exactly once and whose sum of squares is a seven-digit number with the same
value when the three numbers are reversed. It produces 30 triples and 15 sums: each sum belongs to exactly
one triple and its reverse.

That table is the key to the puzzle. Given two members of a triple, the third can be looked up with
`getRemainingForTwo`; given one member, the possible partners can be looked up with `getOthersForOne`.

## Approach 1: main solver and expression constraints

### How it works

`puzzles/onesumamuse.dart` defines the puzzle with `PuzzleDefinition.fromString`, registers the polyadic
function `sum3digitsquares`, and gives the four sum entries (`A`, `a`, `d`, `N`) two expressions each. It
then restricts the possible values of the argument entries with `allArgs` and the sum entries with
`sumOfSquares`.

### Strengths

- It reuses the main project solver, expression parser, grid model and domain model.
- The four sum entries are described declaratively, with both halves of each clue written as expressions.
- The puzzle-specific function is registered through the existing function-registry mechanism rather than
  being hard-coded into the solver.
- The precomputed triple table is a sound, reusable source of candidate values.

### Weaknesses

- The clue constraints I–VIII are commented out and `OneSumAmuseConstraint` is a no-op. The model therefore
  relies entirely on the four entries that have expressions.
- Most entries have no expression and no clue. In the main solver, such entries skip grid propagation
  (`Entry.skipGridPropagation`), so their intersections are not enforced.
- The reverse-pair rule is not explicit. Equal sums plus the structure of the precomputed table happen to
  imply the reverse relation, but the model does not state it.
- The run produced 18 backtracking solutions in about 15 seconds of backtracking (about 18 seconds total).
  The displayed grids are internally inconsistent at some intersections, so these are not all valid
  puzzle solutions.
- The approach gives no useful indication of which constraint is missing.

### Conclusion

This is a good long-term direction, but as written it is not a correct reference solution. It demonstrates
the declarative style that the third approach should move towards, not a behaviour to copy.

## Approach 2: manual nested loops

### How it works

`puzzles/onesumamuse_test.dart` enumerates the first triple, constructs the reversed set, derives the
matching second triple, and then repeats the process for the remaining clues. It maintains an `argValues`
map and mutated sets of reversed arguments, adding and removing values as it backtracks.

### Strengths

- It mirrors the intended mathematical reasoning directly.
- It explicitly enforces the reverse-pair relation by matching the reversed set.
- It uses the triple lookup to derive the third argument instead of brute-forcing it.
- It is independent of the main solver, so it is useful as a cross-check.

### Weaknesses

- The search is roughly ten nested loops deep.
- State restoration is fragile: there are duplicate cleanup calls, repeated `add`/`remove` balancing, and
  several mutations whose scope is easy to get wrong.
- Almost nothing is reusable; the control flow is specific to this puzzle.
- It is slow. It did not complete within 120 seconds in this environment.
- There is no separation between domains, constraints and search strategy.

### Conclusion

The manual approach is valuable as a statement of the intended reasoning, not as an implementation
strategy. The ideas worth keeping are the reverse-set matching and the “derive the third value” lookup;
those should become reusable constraints.

## Approach 3: generalised backtracking solver

### How it works

`puzzles/onesumamuse_test_new.dart` uses `BacktrackingSolver` from `lib/src/backtracking_solver.dart`. Each
letter is an `Expressable` with a domain. A `getValues` switch narrows the domain of a variable from the
values already assigned, and a `checkValue` expression performs the final consistency check. The solver
tries values depth-first, enforces all-different through `expressableValues.containsValue`, and checks grid
intersections through `Expressable.intersections`.

### Strengths

- It finds the unique solution quickly: about 1.8 seconds in this environment.
- The solution matches the intended answer.
- It separates the generic search engine from the puzzle definition, which is the right direction.
- String expressions make many of the final checks readable.
- It reuses the triple lookup for pruning.
- It handles grid intersections, at least for the across side, which the manual approach does not do
  explicitly.

### Weaknesses and correctness gaps

#### 1. The evaluation order is baked in

`expressableOrder` and every `expressableValues['X']!` access assume that the prerequisites of a variable
have already been assigned. Changing the order, or using a least-remaining-values heuristic, would throw.
The solver cannot choose a better order because the dependency information is hidden inside `getValues`.

#### 2. `getValues` is a puzzle-specific switch

The switch mixes several unrelated concerns:

- domain filtering,
- triple lookup,
- reverse-pair logic,
- grid intersections,
- puzzle-specific heuristics such as the `E`/`c` digit rule.

It also duplicates constraints that are already written in `checkValue`. For example, `b` is restricted to
even values in both `getValues` and `checkValue`. This makes the puzzle harder to read and impossible to
reuse without copying the whole switch.

#### 3. Expressions are parsed on every check

`getCheckValue` calls `Expression.parse(expressionString)` inside the callback. It then adds built-ins to
`expressableValues` and removes them again on every evaluation. This is expensive and fragile:

- parse each expression once when the puzzle is constructed;
- evaluate with an immutable overlay map rather than mutating solver state;
- register functions in a proper registry instead of using ad-hoc names;
- handle null and non-boolean results explicitly;
- avoid a second expression language when the project already has a parser, evaluator and inverter.

#### 4. Grid intersections are asymmetric

`updateExpressablesFromGrid` only populates intersections for across entries. Down entries never receive
their own intersections. If a down entry is assigned after its across partner, the intersection is only
checked against the down entry’s old domain, not its final value.

The manual `Intersection(1, 'f', 1)` on `G` and the `E`/`c` digit filter are workarounds for this. They
should be removed once intersections are handled symmetrically.

#### 5. `N` is missing its second-half check

`N` is checked as:

```dart
N == sumSquares(toInt(7*D/12), G, g)
```

but there is no check that:

```dart
N == sumSquares(f - b/2, reverse(G), K)
```

`K` is only restricted to complete a valid triple containing `f-b/2` and `reverse(G)`. The current table
happens to make this work, but the constraint is not explicit. The manual approach checks it correctly.
This should be added, or the two halves should be modelled as an explicit reverse-pair constraint.

#### 6. The reverse-pair rule is implicit

For `A`, `a` and `d`, equal sums plus the structure of the table effectively give the reverse relation, but
the model never states that the two triples are reverses. A reusable solver should not depend on the
accidental uniqueness of triples for a given sum.

#### 7. All-different is hard-coded

`if (expressableValues.containsValue(value)) continue;` enforces that every expressable has a different
value. That is true for this puzzle, but it is not a general cross-number rule. Distinctness should be a
configurable constraint or a set of groups.

#### 8. Puzzle-specific heuristics live in shared code

`gArg` in `onesumamuse_sum_squares.dart` selects values that appear in at least four sums. That is an
optimisation for this puzzle, not a property of triples in general. It belongs in the puzzle module, or the
underlying rule (“G appears in four clues”) should be expressed as a constraint.

#### 9. Solution checking is disabled

`checkSolution` is defined but `solver.solve(..., checkSolution: null)` ignores it. Use it, or remove it.
A reusable solver should return solutions and counts rather than only printing.

#### 10. Smaller issues

- `checkValue` in `onesumamuse_test_new.dart` is dead code.
- `Expressable.length` is unused.
- Digit access through `value.toString()[index]` can throw when a value has the wrong length.
- `MyExpressionEvaluator` supports only `.contains` and depends on returning a tear-off.
- There are no node, check or prune statistics.
- `BacktrackingSolver` defines an `EntryOrientation` enum that it never uses.

## Comparison

| Aspect | Approach 1 | Approach 2 | Approach 3 |
|---|---|---|---|
| Model | Main solver and expressions | Manual nested loops | Generic backtracking plus string checks |
| Constraints | Partly declarative, partly missing | Hard-coded in loops | Split between `getValues` and `checkValue` |
| Reverse pairing | Implicit via equal sums | Explicit | Partly implicit |
| Grid intersections | Skipped for unconstrained entries | Implicit in the loops | Only the across side, plus workarounds |
| Distinctness | Main solver policy | Manual | Global `containsValue` |
| Observed result | 18 solutions, some inconsistent, about 18 s total | Did not finish in 120 s | 1 correct solution, about 1.8 s |
| Reusability | Good infrastructure, incomplete model | Very low | Medium; needs refactoring |

## Cross-check: Snakes and Ladders

The second puzzle is a useful contrast because it uses the same framework in a different style, and because
a manual reference implementation also exists. It has ten 10-digit across entries, several down and up
entries, generator-based clues, a path-uniqueness constraint, and a derived “number of even digits”
constraint.

### Main solver: `puzzles/snakes_and_ladders.dart`

**How it works.** The puzzle is a `PuzzleDefinition` of `Entry` and `Clue` objects. Most clues are
`ExpressionConstraint`s using the existing expression language: `#cube`, `#square`, `$cuberoot A41`,
`$double #square`, `#productfiveprimes`, `$primepower #twodigitprime`, `$ishighestacross #cube`,
`$islowestacross #cube`, and `$multiple #numberevendigits`. `SnakesAndLaddersGrid` supplies board
coordinates and computes the winning rolls. `SnakesAndLaddersConstraint` checks path uniqueness and the
D94 multiple in `checkSolution`.

**Observed result.** One solution, matching the published answer. Initial propagation took about 566 ms and
backtracking about 2372 ms.

**Strengths.**

- The clues are declarative. There is no per-variable `getValues` switch.
- It reuses the expression parser, evaluator and inverter, the generator registry, the monadic functions,
  the grid/cell intersection model, `EntryOrientation.up`, and `DistinctConstraint`.
- The 10-digit entries need no special domain code; the expression language and generators supply their
  values.
- The solver's solution matches the published answers recorded in `setAnswers`. Because the answer check runs
  during propagation, this is a useful fail-fast assertion while developing the puzzle.

**Weaknesses.**

- `SnakesAndLaddersConstraint` implements only `checkSolution`. `initialise`, `propagate`,
  `enforceDistinct` and `onBacktrackingStart` are no-ops. Path uniqueness and the D94 check are leaf-only,
  so the solver spends most of its time backtracking instead of propagating.
- The path is hard-coded in `checkSolution` (`a1Str[4]`, `a41Str[5]`, ...) and is also computed by
  `SnakesAndLaddersGrid.getWinningRolls()`. The CLI calls `getWinningRolls()` only to print it; the
  constraint does not use the result. There are effectively two copies of the same rule.
- `getWinningRolls()` prints `Snakes` and `Ladders` from model code.
- `setAnswers` is deliberately a debugging aid, not a constraint. `Expressable.answer` is checked whenever
  `possibleValues` is narrowed, so the setter throws as soon as propagation removes the known answer. That is
  exactly where to set a breakpoint when a puzzle starts going wrong. The check is switched off during
  backtracking, however, so it guards initial propagation and solving, not the backtracking search. Keep
  `setAnswers` for that purpose, but also assert the final answer in a test so the failure is caught
  automatically. Note that the solver sets `Expressable.checkAnswer = false` before backtracking and does
  not restore it (`solver.dart:319-320`), so a later puzzle in the same process will not check its answers.
- The `U38` entry and clue are commented out. The manual script still computes `u38`, but its expression
  (`a40Str[2] + a41Str[2] + a60Str[6]`) does not match the commented entry's column: a row-6/col-2 up entry
  would use `a60Str[2]`, while a row-6/col-6 up entry would use `a40Str[6]` and `a41Str[6]`. The omission is
  undocumented and untested.
- `checkSolution` uses `puzzle.clues['X']!.solution!`. A general puzzle constraint should not assume every
  clue is solved when only the entries are guaranteed to be solved.
- `checkSolution` recomputes the even-digit count from the ten across strings, while the D94 clue uses
  `#numberevendigits`. They agree here because every cell belongs to exactly one across entry, but they are
  two implementations of the same rule.

### Manual search: `puzzles/snakes_and_ladders_test.dart`

**How it works.** It builds candidate values with custom helper functions, then enters nested loops for
`D61`, `A41`, `A40`, `U15`, `D68`, `U45`, `A60`, `A61`, `A80`, `A81`, `A100`, `A21`, `A20` and `A1`. Each
loop checks hand-picked digit positions against previously chosen entries and calls `updatePath` to maintain
the set of digits used by the winning path. At the deepest level it computes `U38`, `D94` and `D42`, checks
path uniqueness and D94, and prints the assignment.

**Observed result.** One solution in about 0.39 s, matching the main solver.

**Strengths.**

- It is fast for this puzzle because the search order and domain restrictions are highly tuned.
- The path and digit relationships are explicit in one place.
- It is a useful independent check of the published answer.

**Weaknesses.**

- `updatePath` immediately returns `(true, [])`. `pathDigits`, `duplicatePathDigit` and
  `getNewPathDigits` are dead code, so all incremental path pruning is disabled. Uniqueness is checked only
  at the leaf. The code looks as if it prunes, but it does not.
- The helper functions duplicate generators already in `GeneratorRegistry`: `cube10Digits`,
  `cubeSquare10Digits`, `productFivePrimes4Digits`, `twoDigitPrimeToPrimePower10Digits`, `squareSquare`,
  and so on.
- `(a41.toDouble().pow(1 / 3)).round()` is a floating-point cube root. The framework has an exact integer
  `cuberoot`.
- Cell positions are hand-coded (`[41, 42, ...]`, `a40Str[2]`, `a60Str[6]`). These duplicate
  `Grid`/`Cell` metadata and are easy to get wrong. The `u38` expression is an example.
- `getPatternForValueDigit` builds a regular-expression character class from the digits that appear at a
  position. It is an ad-hoc projection of a table column; a `TableConstraint` or a `Cell` digit domain is
  clearer and safer.
- The final distinctness check is only “A1 is highest across” and “A20 is lowest across”. It does not check
  that all clue answers are distinct, although the puzzle statement requires it. The main solver's
  `DistinctConstraint` does.
- Several cross-checks are commented out (`a81Str[6] != d94Str[1]`, `a100Str[6] != d94Str[0]`,
  `a21Str[1] != d42Str[2]`, `a20Str[1] != d42Str[3]`), and `D42`, `D94`, `U38` are computed only at the
  leaf. These are delayed rather than impossible constraints.
- `a100Str[6] == '0'` is an opaque leading-zero check on `D94`, not on `A100`.
- `countEvenDigits` sums the digits of the ten across entries, while `#numberevendigits` counts grid cells.
  They agree here only because every cell belongs to exactly one across entry; in a general grid the manual
  count would miss or double-count cells.

### What the cross-check shows

| Aspect | Snakes main solver | Snakes manual search |
|---|---|---|
| Model | `PuzzleDefinition` plus expressions | Nested loops |
| Domains | Generators and expressions | Custom generator copies |
| Geometry | `Grid`/`Cell`, but the constraint hard-codes indices | Hand-coded indices |
| Propagation | Initial expression propagation; path/D94 at leaf | `updatePath` disabled; final check at leaf |
| Distinctness | `DistinctConstraint` default | Only A1/A20 ordering |
| Observed result | 1 solution, about 2.4 s backtracking | 1 solution, about 0.39 s |
| Correctness confidence | High for declared clues; U38 omitted | Lower; distinctness and U38 incomplete |

The manual search is faster here, but it is not a better design. It is a tuned enumeration that disables or
omits several checks. The main solver is slower because its puzzle-specific constraint does not propagate,
not because the framework is inadequate.

## Lessons from Snakes and Ladders

1. **The One Sum failure was under-modelling, not a missing solver.** Snakes and Ladders uses the same
   `Solver` and solves a much larger puzzle correctly. The One Sum model omitted clues I–VIII and left many
   entries unconstrained, so the solver had no reason to reject inconsistent grids. The first fix should
   always be to complete the model.

2. **Leaf-only constraints cause backtracking.** `SnakesAndLaddersConstraint` checks path uniqueness and D94
   only in `checkSolution`; the solver spends about 2.4 s backtracking after about 0.57 s of propagation. If
   those checks pruned as soon as their source entries were assigned, the search would shrink. This is the
   same lesson as the missing `N` check in One Sum, but at the constraint-lifecycle level.

3. **A manual search can be fast and still be incomplete.** The Snakes manual search is faster than the main
   solver, but it disables its own path pruning, omits full distinctness, and has an unverified `U38`.
   Speed is not evidence of correctness. Performance rankings are also problem-specific: the One Sum manual
   search did not finish in 120 s, while the Snakes manual search beats the main solver. Design decisions
   should not be based on one benchmark.

4. **Duplicated domain generation and geometry drift.** The manual test reimplements generators and cell
   indices. The `U38` expression is a concrete example: it does not match a contiguous column for the
   commented entry. Use the registry and the grid model.

5. **Disabled and commented-out constraints are silent correctness risks.** `updatePath` is dead code;
   `U38` and several digit checks are commented out; One Sum's clues I–VIII are commented out. A solver
   finding one solution does not prove these omissions are harmless. Add a constraint inventory and tests
   that toggle each omitted clue.

6. **Debug answers are fail-fast assertions, not constraints.** `setAnswers` sets `Expressable.answer`. The
   `possibleValues` setter calls `_checkAnswer`, which throws when a narrowing update excludes the known
   answer (`lib/src/models/expressable.dart:90-95`). Break there when propagation starts eliminating the right
   answer. Two caveats: the check is disabled during backtracking (`solver.dart:319-320` and `1075`) and is
   not restored afterwards, so it cannot catch a bad leaf search and later puzzles in the same process lose
   the assertion; and a value that is never narrowed proves little. Use `setAnswers` for interactive
   diagnosis and keep a test assertion as the permanent regression guard.

7. **Puzzle-specific orchestration belongs in the puzzle lifecycle.** The CLI special-cases
   `snakes_and_ladders` to call `getWinningRolls()`, and the grid prints from model code. A reusable puzzle
   should expose a `preSolve` or `initialise` hook so every front-end gets the same setup and tests can call
   it directly.

## Additional puzzle types in the catalogue

The One Sum and Snakes comparison covers only the clue-to-entry style. The rest of `puzzles/` shows that the
framework is also used as a small constraint language. The main categories are:

| Type | Examples | What the puzzle adds | Framework support and strain |
|---|---|---|---|
| Variable-and-expression | `abcd`, `after_nicholas`, `relationship`, `wheels`, `mathematical_inspiration`, `simple_puzzle`, `puzzle2`, `puzzle3`, `threes` | Entries are expressions over a few `Variable`s; `clues` is often empty. | `Variable`, `ExpressionConstraint` and `DistinctConstraint` work well. Entries with no clue need `forcePropagation` if their grid intersections matter. Domains are often hand-built. |
| Generator and function classification | `all_square`, `twosquares`, `primania`, `threes`, `asp`, `triples`, `snakes_and_ladders`, `sum_squares`, `splits` | A clue is one expression such as `#cube`, `$derange 1A`, `$firstfactor 10109` or `£pandigital(A,M,K)`. | The registries make these concise. They are global mutable singletons; safe for the current one-puzzle-per-run CLI, but tests that build several puzzles in one process see registration order. |
| Known clue-to-entry mapping | Most puzzles | Domains are derived from entry length; clues and entries are separate. | Length, leading-zero and digit constraints are automatic. When an explicit `entries:` map is supplied, `updateEntry` does not copy the grid-derived `clueId` (`puzzle_definition.dart:622-632`), so the clue link must be re-established. |
| Unknown clue-to-entry mapping | `allsquare`, `primania`, `sum_squares`, `splits` | Clues must be assigned to entries that fit. | `mappingIsKnown: false`, `MappingStrategy`, `mappingFunction` and `OrderingConstraint` support it. The mechanisms are split across flags, pre-solve code and `onBacktrackingStart`; see below. |
| Multi-grid | `thirty` (`L`, `R`), `die_another_day` (`T`, `F`, `R`) | Several grids share variables or have cell-by-cell relations. | `gridNames`, prefixed IDs, `Grid.getDigits` and `DigitRangeConstraint` help. Custom constraints loop over grids manually; there is no cross-grid region or coordinate abstraction. |
| Region and geometry | `containing_pi`, `yet_another_sudoku`, `thirty`, `die_another_day` | Rules apply to quadrants, Sudoku boxes, a clockwise ring, or triples of cells. | `Region`, `Grid.quadrants`, `Grid.regions`, `Cell` and `SudokuConstraint` exist. `SudokuConstraint.initialise` also removes and synthesizes entries and cell links, so lifecycle order matters. |
| Ordering and series | `borderseries`, `increasing_prime`, `sum_squares`, `splits`, `allsquare` | Clues are in ascending order, form an arithmetic sequence, or are ordered by clue label. | `OrderingConstraint` supports sorted clues, but only `sum_squares` and `splits` enable it. `increasing_prime` hard-codes the order in a pre-solve; the unfinished `borderseries` has a partial sequence check in `propagate`. |
| Statement and logic | `elementary_number_theory` | Entries list statements `A`–`O`; `addNotStatements` turns the complement into negated constraints. | `Statement`, `addNotStatements` and statement priority are supported. The custom puzzle constraint is an untouched template stub, and there is no report of which statements were expanded. |
| Mutual or derived relations | `couples_differences`, `asp`, `wheels`, `die_another_day`, `mathematical_inspiration` | Entries constrain each other, variables count grid digits, or a final grid sequence encodes a message. | Expressions can refer to other entries. Mutual relations are usually encoded as polyadic functions or checked only at the leaf; hard-coded answers appear in `checkSolution`. |

The names are easy to confuse: `all_square.dart` is *All Change* (a known-mapping derangement puzzle with
`$derange` entries), while `allsquare.dart` is *All Square* (an unknown-mapping puzzle whose clue answers
are squared to give entries). They exercise different parts of the framework.

### Generated puzzle scaffolding

Most puzzle files start from `templates2/abcd.dart.jinja`. The template emits:

- an `entries:` block and a `clues:` block, because the Excel definition does not say which side is needed;
- an optional `OrderingConstraint` line;
- a `...Constraint` skeleton whose methods all return “consistent, unchanged, true”;
- a commented-out `setAnswers` body and commented helper functions.

The author comments out the unused block and fills in only the parts the puzzle uses. This explains three
recurring shapes in the catalogue: empty `clues`, unused commented blocks and no-op constraint classes. They
are scaffolding, not evidence that a rule is missing. The coverage diagnostic should distinguish untouched
template scaffolding from a stub that was meant to be implemented, and the unused block should be deleted
before the puzzle is called finished.

### What these puzzles add to the review

1. **Empty `clues` is legitimate and common.** Several puzzles treat the entries themselves as the clues and
   leave `clues: {}`. `abcd`, `after_nicholas`, `wheels` and `relationship` all work this way, and the
   template emits the empty block by default. A coverage report must distinguish “intentionally unclued”
   from “forgotten clue”, not flag every empty map.

2. **Puzzle logic has two intended homes.** Per-entry and per-clue logic is implemented as a
   puzzle-specific monadic or polyadic function (`$derange`, `$split`, `$firstfactor`, `£pandigital`,
   `£aspCheck`); rules that need global state, cross-entry coordination or search-time pruning live in a
   `PuzzleConstraint`. That split is intentional and fits the framework. The consequence is that the named
   functions need their own unit tests: when a solve fails, the function and the model are both suspects.
   Promote a function to a constraint when it can prune; keep it as a function when it only classifies or
   transforms a value.

3. **The function and generator registries are process-wide, which is safe for the current one-puzzle-per-run
   CLI.** `MonadicFunctionRegistry`, `PolyadicFunctionRegistry` and `GeneratorRegistry` are singletons.
   Functions registered by one puzzle remain available to the next, but no cross-puzzle interaction occurs in
   normal use because the program solves only one puzzle per run. `splits` registers `$split` after
   constructing the puzzle (`splits.dart:78,85-119`), and `yet_another_sudoku` registers
   `SumDiagonalGenerator` after `PuzzleDefinition.fromString` (`yet_another_sudoku.dart:117,148-150`); this
   works only because evaluation is lazy. The practical costs are order-dependent tests when several puzzles
   are constructed in one process, and the inability to give the same name two different meanings in that
   process. Per-puzzle registries are a robustness improvement, not a prerequisite for solving.

4. **Ordering and mapping are several mechanisms, not one concept.** A puzzle author has to choose between
   `OrderingConstraint`, `mappingIsKnown`, `mappingFunction`, `onBacktrackingStart` and a manual pre-solve
   such as `initialiseClues` in `increasing_prime.dart:91-103`. Missing the right one produces a plausible
   but underconstrained model. This is the main specification risk after under-modelling.

5. **Some lifecycle hooks mutate the model.** `SudokuConstraint.initialise` removes entries and creates new
   ones, `ContainingPiConstraint.initialise` installs π triples, `SplitsConstraint.initialise` fills
   unclued clue domains, and `increasing_prime` pre-solves clue domains. Diagnostics, coverage and tests
   must run after `initialise`, and `initialise` should be idempotent.

6. **A no-op `PuzzleConstraint` is usually generator scaffolding.** `templates2/abcd.dart.jinja` emits a
   `...Constraint` skeleton with `initialise`, `propagate`, `enforceDistinct` and `onBacktrackingStart`
   returning constants, plus a `checkSolution` that returns `true`. `all_square`, `asp`,
   `elementary_number_theory`, `summingsquares` and `triples` still carry that stub. An unchanged stub is
   harmless scaffolding; a stub that was meant to implement a rule is a bug. The diagnostic should compare
   the class with the template, and the unused class should be removed once the puzzle is finished.

7. **Commented-out blocks are often generated scaffolding, not missing clues.** Because the template emits
   both `entries:` and `clues:`, one block is normally commented out. That is different from a clue removed
   from a model. Real examples of the latter are `triples`' three `XII` clues (`triples.dart:194-196`) and
   Snakes' `U38`; `relationship` also leaves two unclued entries with empty constraints. These need explicit
   coverage tests, while an unused generated block does not.
   `summingsquares` is a concrete under-modelling example, but the cause is the empty `constraints: []` on
   `A3` and `A7`: with no clue and no expression they have `skipGridPropagation == true`, so their grid
   intersections are not enforced. The commented `clues` map is template scaffolding and is not itself the
   defect.

8. **Leaf-only validation is widespread in the custom constraints that do implement a rule.**
   `mathematical_inspiration` pins the full grid sequence, `couples_differences` checks the digit sum,
   `relationship` checks clue-set cubes, and `splits` checks the unclued multiples. None of these prune
   during search. This is a performance and completeness issue, not necessarily a wrong model, because the
   leaf check usually does run. `borderseries` is different again: it is an unfinished puzzle, so its
   always-true `checkSolution`, partial `propagate` and monotonic-only manual test are work in progress,
   not an example of a design choice.

### Observed catalogue run

To check the survey against actual behaviour, each of the 26 registered puzzles was run once through the CLI
with a 20-second limit:

```sh
timeout 20s dart run bin/cross_number_v2.dart -p <puzzle>
```

The limit is a screening threshold, not a correctness test. The results split into three groups.

| Outcome | Puzzles | Notes |
|---|---|---|
| Completed without backtracking | `abcd`, `after_nicholas`, `all_square`, `asp`, `simple_puzzle`, `twosquares`, `wheels` | `abcd` alone took about 11.5 s of propagation. “No backtracking” does not mean fast. |
| Completed by backtracking | `containing_pi` (1), `increasing_prime` (1), `mathematical_inspiration` (1), `puzzle2` (8), `puzzle3` (1), `relationship` (1), `threes` (7480), `yet_another_sudoku` (1) | `allsquare` also finds its single mapping solution, in about 19.7 s of mapping backtracking, so it completes just outside the limit. |
| Timed out at 20 s | `borderseries`, `couples_differences`, `die_another_day`, `elementary_number_theory`, `primania`, `splits`, `sum_squares`, `summingsquares`, `thirty`, `triples` | Timeout is not proof of a wrong model; several have checked-in logs that do reach solutions, and `borderseries` is unfinished. |

No run that completed reported zero solutions. In this catalogue the visible failure modes are timeouts and
extra solutions, not a solver that exhausts the search and reports nothing. That is one reason the
definition-versus-algorithm distinction below matters: a timeout is often reported as “finds no solution”.

The CLI prints “backtracking disabled” when value backtracking is off, even though mapping backtracking still
runs. `allsquare` reports that message in the 20-second run and then finds its mapping solution when given
longer. The message must not be read as “no search”.

Three cautions follow from the run:

1. **The timeouts mostly coincide with the modelling patterns above.** They include every unknown-mapping
   puzzle except `allsquare` (`primania`, `splits`, `sum_squares`), both multi-grid puzzles (`thirty`,
   `die_another_day`), the puzzles whose custom rule is leaf-only or still a template stub
   (`couples_differences`, `elementary_number_theory`, `summingsquares`, `triples`), the unfinished
   `borderseries`, and `thirty`'s heavy hand-written propagation. That is consistent with the review, but it
   does not say which of the two causes — incomplete model or weak search — applies in each case.

2. **Checked-in evidence shows some timeouts are only slow.** `test/thirty_output.txt` records 2 solutions and
   78.8 s of backtracking; `test/primania_output.txt` records 6 mapping solutions; `test/sum_squares_output.txt`
   records 1 solution. Their tests are disabled rather than fixed: `test/thirty_test.dart`,
   `test/primania_test.dart`, `test/sum_squares_test.dart` and `test/die_another_day_test.dart` all set
   `disabled = true`. A 20-second timeout is therefore evidence about the algorithm, not about the definition.

3. **Solution counts need interpretation.** `puzzle2` returns 8 solutions because it is a test puzzle.
   `threes` returns 7480 algebraic solutions because the thematic sequence rule and message extraction are
   not modelled; that is expected at the algebraic stage, not a missing clue. `primania` returns 6 mapping
   solutions, and its disabled test notes that also requiring reversed partners would reduce the count to 2
   while the test expects 6. A count alone cannot distinguish “correctly many” from “under-modelled”.

The run also shows why propagation and search must be measured separately. `abcd` never backtracks but spends
about 11.5 s propagating, while `allsquare` spends almost all of its time in mapping backtracking. Optimising
the wrong phase would not help either puzzle.

### Diagnosing “the framework finds no solution”

Use the following decision order before writing a manual solver:

| Symptom | Likely cause | First diagnostic |
|---|---|---|
| Propagation empties a domain immediately | Incomplete or inconsistent definition: wrong clue expression, too narrow domain, wrong digit constraint, wrong mapping | Trace the last constraint that removed the final value; check the puzzle statement against the entry domain and `setAnswers`. |
| Propagation finishes with many unknowns and backtracking finds nothing | Under-modelling or an over-strong implicit constraint: missing clue, missing reverse/distinct rule, or default all-different applied to values that may repeat | Run the coverage report; disable `DistinctConstraint` flags one at a time; compare with a manual reference. |
| Backtracking runs for a long time but eventually finds a solution | Weak propagation, expensive mapping, or poor variable order | Measure propagation versus backtracking time and node count; add a `propagate`/`enforceDistinct` hook for the expensive rule; use MRV/degree ordering. |
| More than one solution | A constraint is missing, disabled, or only checked at the leaf | Compare the returned grids; look for removed clues, leaf-only checks and constraints left as template stubs. One Sum is the canonical example. |
| A solution is returned but it violates the statement | `checkSolution` is incomplete or disabled, or the custom constraint never validates the rule | Enable solution checking and add a deliberately invalid assignment test. The Snakes leaf-only path constraint is an example; the unfinished `borderseries` is a work-in-progress rather than a validated model. |
| Parsing or construction fails before solving | Generator or monadic function not registered yet, unknown name, or multi-grid ID mismatch | Register all puzzle functions before `PuzzleDefinition.fromString`, or make resolution lazy and per-puzzle; validate grid prefixes. |
| A pre-solve hook throws | The hook assumes another value is already solved | Guard with `isSolved`; `allsquare.onBacktrackingStart` uses `clue10.solution!` and `clue12.solution!` and can fail if propagation has not solved them. |

The distinction that matters is:

- **Incomplete definition:** the model admits grids that the puzzle statement forbids, or rejects grids it
  allows. The symptom is extra solutions, wrong solutions, or an immediate empty domain.
- **Imperfect algorithm:** the model is correct but the search is slow or exhausts memory. The symptom is
  long backtracking with a correct model, or a timeout with no contradiction.

A manual solver is good evidence for the first case and poor evidence for the second. Snakes and Ladders
shows both: the main model is correct but its path constraint is leaf-only, while the manual search is fast
because it is tuned and incomplete.

## What to reuse from the existing framework

The project already contains most of the generic machinery that the third approach was beginning to build.
A reusable backtracking solver should be a search strategy or a thin adapter over these components, not a
parallel model.

| Concern | Existing component | How the reusable solver should use it |
|---|---|---|
| Problem model | `PuzzleDefinition`, `Expressable`, `Entry`, `Clue`, `Variable` | Accept a `PuzzleDefinition` (or an adapter) instead of a second `Problem`/`Variable` model. |
| Domains | `Expressable.possibleValues`, `Entry.initPossibleValues`, `Clue.min/max` | Reuse the same domain objects; do not recompute length bounds. |
| Grid geometry | `Grid`, `Cell`, `Entry.intersects`, `Grid.populate`, `acrossIndex`/`downIndex`/`upIndex` | Derive intersections and digit positions from cells; delete hand-indexed strings and `updateExpressablesFromGrid`. |
| Intersection propagation | `Cell.possibleDigits`, `Cell.removeDigits`, `Grid.getPossibleDigits`, `Grid.isEntryValueCompatibleSolvedEntries` | Use for across, down and up in both directions. |
| Expressions | `ExpressionConstraint`, `ExpressionInverter`, `MonadicFunctionRegistry` | Parse once and reuse the project expression language; do not build a second parser/evaluator. |
| Generators | `GeneratorRegistry`, `CachedGenerator`, `SquareGenerator`, `CubeGenerator`, `ProductFivePrimesGenerator`, `TwoDigitPrimeToPrimePowerGenerator` | Use `#square`, `#cube`, `#productfiveprimes`, `#twodigitprimetoprimepower`, and the other registered generators. |
| Derived quantities | `SumDigitsGenerator`, `NumberEvenDigitsDigitsGenerator`, `#sumdigits`, `#numberevendigits` | Use for clues such as D42 and D94. |
| Ordering | `OrderingConstraint`, `ishighestacross`, `islowestacross` | Use instead of manual `A1 > ...` and `A20 < ...` comparisons. |
| Distinctness | `DistinctConstraint` (`allClues`, `allEntries`, `allVariables`) | Use explicit groups; do not hard-code `containsValue`. |
| Constraint lifecycle | `Constraint`, `PuzzleConstraint` (`initialise`, `propagate`, `enforceDistinct`, `checkSolution`, `onBacktrackingStart`) | Implement propagation and distinctness, not only final validation. |
| Search | The algorithms in `Solver` (`_propagateConstraints`, `_backtrackExpressables`, `_saveState`/`_restoreState`) and `SolverTracer` | Reuse or mirror; MRV ordering, propagation and state restore already exist. |
| Mapping | `MappingStrategy`, `_solveUnknownMapping` | Reuse for puzzles where the clue-to-entry mapping is unknown. |
| Puzzle lifecycle | `PuzzleDefinition` constructor, `registerPuzzleFunctions` | Move `getWinningRolls()` and other pre-solve setup here. |
| Debug answers | `Expressable.answer`, `_checkAnswer` | Use as a deliberate fail-fast breakpoint during development; keep a test assertion as the permanent guard. |

`SnakesAndLaddersGrid` is a good example of extending `Grid` with board-specific coordinate helpers
(`getCoordinates`, `getSquare`, `getWinningRolls`) while keeping `Cell` and `Entry` as the intersection
model. The mistake is not the subclass; it is letting the subclass print and letting the CLI own its
initialisation.

**Do not duplicate** any of the following in the standalone solver:

- a second `Expressable`, `EntryOrientation`, `Problem` or `Variable` model;
- a second expression parser, evaluator or function registry;
- generator implementations or digit-extraction helpers;
- clue/entry mapping or grid-intersection code.

**Framework gaps to close.**

- `PuzzleConstraint` has no declared scope. Add `Set<String> get scope` so the solver can re-evaluate only
  affected constraints.
- `DistinctConstraint` is a single global switch. Add named groups for puzzles that need different
  distinctness rules in different regions or clue sets.
- `PuzzleConstraint` propagation is optional in practice. Make it clear that a constraint that only
  implements `checkSolution` is a leaf constraint and should be used only when propagation is impossible.
- `Entry.skipGridPropagation` is a useful warning: an entry with no clue and no expression will not
  propagate. Surface that as a diagnostic or a coverage report.
- The function, polyadic and generator registries are global singletons. This is safe for the current
  one-puzzle-per-run CLI, but registration order is observable in tests that construct several puzzles
  (`splits.dart:78`, `yet_another_sudoku.dart:148-150`).
- Ordering and clue-to-entry mapping are spread across `OrderingConstraint`, `mappingIsKnown`,
  `mappingFunction`, `onBacktrackingStart` and manual pre-solve code. Unify them.
- `initialise` may mutate the entry map and grid links, as `SudokuConstraint` does. Define and enforce a
  single pre-solve order, and make the hooks idempotent.
- There is no completeness report. A puzzle can carry empty clues, template-stub constraints and removed
  rules and still return a solution. Add a diagnostic that separates generated scaffolding from a real
  modelling gap.
- The standalone `BacktrackingSolver` currently has its own `Expressable` and `EntryOrientation`. Replace
  them with adapters over the model classes, or retire the standalone model entirely.

## Recommended improvements

### 1. Extract a generic constraint model

Keep the search engine generic and make the puzzle file declarative:

```dart
class Variable {
  final String id;
  final Set<int> domain;
}

abstract class Constraint {
  Set<String> get scope;
  bool isSatisfied(Map<String, int> assignment);
  Set<int> support(String id, Map<String, int> assignment);
}

class Problem {
  final Map<String, Variable> variables;
  final List<Constraint> constraints;
  final List<Set<String>> distinctGroups;
}
```

The puzzle file should then contain variable declarations, domains, constraints and a call to
`solver.solve(problem)`. The solver should not know about `G`, `e` or `sum3digitsquares`.

### 2. Replace the `getValues` switch with table constraints

The precomputed triples are already a relation. Expose them generically:

```dart
TableConstraint(['e', 'G', 'L', 'A'], validRows)
TableConstraint(['b', 'G', 'H', 'j', 'A'], validRows)
```

Projecting a table column gives the behaviour of `getOthersForOne` and `getRemainingForTwo`, but without a
puzzle-specific helper. Add:

- `ReversePairConstraint` for the paired clues;
- `LengthConstraint` and `DigitConstraint` for entry shapes;
- `DistinctConstraint` for all-different groups;
- `ExpressionConstraint` for the remaining arithmetic, using the project evaluator.

### 3. Remove the baked-in evaluation order

Each constraint should declare its scope. The solver can then:

- choose the next variable by minimum remaining values or degree;
- check every constraint whose scope intersects the assigned variable;
- return the full domain, or defer, when a dependency is unassigned.

`getValues` should never use `expressableValues['X']!`. Missing dependencies should be represented
explicitly, not discovered through a runtime exception.

### 4. Parse expressions once and evaluate immutably

- Parse each check expression when the `ExpressionConstraint` is created.
- Store the parsed tree and its variable list.
- Evaluate against an overlay:

  ```dart
  final context = {...assignments, ...builtins};
  ```

- Do not add and remove built-ins from the solver’s live map on every call.
- Reuse the project’s parser, evaluator and inverter, or at least register functions in one place.

### 5. Make grid intersections symmetric

- Populate intersections for every entry, across and down, or compute them from `Grid`/`Cell` objects.
- Check an intersection whenever either endpoint is assigned.
- Support the `up` orientation as well.
- Remove the manual `Intersection` and the `E`/`c` digit workaround.
- Add length and leading-zero validation.
- Make `updateExpressablesFromGrid` return a parsed problem or throw a diagnostic error instead of
  printing and continuing.

### 6. Make distinctness configurable

Replace the solver-wide `containsValue` check with explicit groups:

```dart
DistinctConstraint(['A', 'a', 'b', 'c', ...])
```

Other puzzles can then allow repeated values across unrelated entries, or apply distinctness only within a
clue group.

### 7. Move puzzle-specific data out of shared modules

Keep the reusable table and relation code separate from:

- the triple cache,
- `allArgs` and `sumOfSquares`,
- `gArg`,
- the `E`/`c` and `G`/`f` heuristics.

These belong in the puzzle module. The shared module should provide generic operations such as “all valid
triples”, “project a table”, “reverse a number” and “compose constraints”.

### 8. Validate and report

- Pass `checkSolution` to the solver, or check every constraint when a complete assignment is reached.
- Return the solutions or a solution count; make printing optional.
- Report nodes visited, constraint checks and prunes.
- Add tests for the known solution, the missing `N` check, intersection consistency and deliberately
  invalid assignments.

### 9. Use `PuzzleDefinition` as the reusable problem model

The `Problem`/`Variable` sketch in the target API section is a useful conceptual model, but this repository
already has those concepts in `PuzzleDefinition`, `Expressable`, `Entry`, `Clue` and `Variable`. The
reusable solver should accept a `PuzzleDefinition` or a lightweight adapter over it. If an internal flat
representation is needed for speed, generate it from `PuzzleDefinition`; do not expose a second puzzle API.

### 10. Give every constraint a scope and a propagation hook

Add `Set<String> get scope` and `(bool consistent, bool updated) propagate(...)` to the generic constraint
interface. The scope lets the solver choose the next variable by degree or minimum remaining values and
re-check only affected constraints. The propagation hook lets constraints such as path uniqueness,
distinctness and derived-entry relations prune before the leaf. This mirrors the existing
`PuzzleConstraint.propagate` lifecycle.

### 11. Use grid and cell metadata for all geometry

Replace `updateExpressablesFromGrid`, `value.toString()[index]` and hand-written cell lists with
`Grid`/`Cell` data:

- `Cell.acrossEntry`, `downEntry` and `upEntry` plus their indices;
- `Entry.intersects` and `Grid.populate`;
- `Cell.possibleDigits` and `Cell.removeDigits`;
- `Grid.getPossibleDigits` and `Grid.isEntryValueCompatibleSolvedEntries`.

This handles up entries and both intersection directions automatically and removes the need for manual
`Intersection` objects and digit workarounds.

### 12. Reuse generators, monadic functions and inversion

The Snakes and Ladders manual test reimplements `cube10Digits`, `cubeSquare10Digits`,
`productFivePrimes4Digits`, `twoDigitPrimeToPrimePower10Digits` and `squareSquare`. All of these have
counterparts in `GeneratorRegistry`. Likewise, use `MonadicFunctionRegistry` and the exact integer
`cuberoot` rather than floating-point roots. The framework's `ExpressionConstraint` already parses once and
supports inversion, so the standalone solver should not parse expressions on every check.

### 13. Make the puzzle lifecycle explicit

Move puzzle-specific pre-solve work out of the CLI and into the puzzle or constraint lifecycle. For Snakes
and Ladders, `SnakesAndLaddersConstraint.initialise` should compute and store the snakes, ladders, winning
rolls and winning path; `checkSolution` should consume that data instead of hard-coding it. Remove printing
from `SnakesAndLaddersGrid.getWinningRolls()`.

### 14. Audit constraint coverage and remove dead code

Add a diagnostic or test that lists every entry and clue with its active constraints. Flag:

- entries with no clue and no expression (`skipGridPropagation`);
- entries or clues removed from the model, such as `U38`, as opposed to an unused generated block;
- a `PuzzleConstraint` that is still the template stub when the puzzle needs propagation;
- code paths that are disabled, such as `updatePath` returning immediately;
- cross-checks that are commented out in a manual script.

A solver finding one solution is not evidence that an omitted constraint is redundant.

### 15. Keep `setAnswers` as a fail-fast debug aid

`setAnswers` is a useful development tool. When a puzzle has a published answer, set it on the variable,
entry or clue, then break on `Expressable._checkAnswer`. The first propagation step that removes the known
answer stops the solver at the mistake, before the search degenerates.

Do not treat it as a constraint, and do not rely on it as the only regression test. The answer check is
disabled during backtracking, so it does not validate the search. Also restore
`Expressable.checkAnswer = true` after `solve`: the solver turns it off and leaves it off, so a later puzzle
in the same process silently loses the assertion. Add a separate test that asserts the solver's final
answer; keep `setAnswers` for interactive debugging and update it when the published answer changes.

### 16. Add a coverage and completeness diagnostic

Before solving, report:

- entries with no clue, no expression and `skipGridPropagation`;
- clues with no constraints and no `possibleValues`;
- `PuzzleConstraint` implementations that are unchanged from the template stub;
- `checkSolution` implementations that always return `true` on a constraint that is meant to validate a rule;
- `OrderingConstraint` declared but not enabled, or required by the statement but absent;
- `mappingIsKnown: false` when clues and entries are both non-empty;
- removed clues or cross-checks, as distinct from unused generated blocks;
- registered function and generator names that the puzzle does not use.

This turns “the framework finds no solution” into a short list of modelling decisions to check. It also
catches the reverse problem: a puzzle that solves but is under-modelled.

### 17. Unify ordering and mapping

Replace the separate `OrderingConstraint`, `mappingIsKnown`, `mappingFunction`, `onBacktrackingStart` and
manual pre-solve paths with one explicit description:

```dart
class ClueMapping {
  final bool isKnown;
  final int Function(int clueValue)? transform;
  final List<String>? orderedClueIds;   // ascending answers
  final Map<String, List<String>>? allowedEntries;
}
```

The solver can then apply the same constraint in propagation and mapping search. Pre-solve code should be a
last resort, not the place where ordering is secretly encoded.

### 18. Make puzzle function registration local and ordered

The registries are global singletons. The current CLI solves one puzzle per process, so this causes no
cross-puzzle bug in normal use. It does make tests order-dependent when they build several puzzles in one
process. Lower priority than the modelling work: give each `PuzzleDefinition` its own function and generator
registry, or namespace registrations by puzzle name. Register puzzle functions before parsing expressions, or
resolve names lazily through the puzzle's registry.

### 19. Make the lifecycle explicit and idempotent

Add a single pre-solve phase:

```dart
void preSolve(PuzzleDefinition puzzle) {
  // derive domains, synthesize entries, compute paths, register generators
}
```

Run it once before propagation, before coverage diagnostics and before mapping backtracking. Require
`initialise`, `preSolve` and `onBacktrackingStart` to be idempotent and safe when values are unsolved. The
current mix of work in constructors, `initialise` and `onBacktrackingStart` is the main source of hidden
state.

### 20. Report why propagation failed

When a domain becomes empty, record the constraint and expressable that caused it, the value removed and the
current assignment. A single line such as:

```text
ContainingPiConstraint.propagate emptied D8: removed 487 (answer 487), region pi
```

is worth more than a stack trace or a full backtracking run. This is the natural companion to the
`setAnswers` breakpoint.

### 21. Measure propagation and search separately

Return at least:

- propagation time and backtracking time;
- nodes visited, constraint checks and domain values removed;
- number of solutions and whether the search was complete;
- the first empty-domain event.

A puzzle that spends most of its time in propagation needs caching or cheaper region checks. A puzzle that
spends most of its time backtracking needs more propagation or a better variable order. A puzzle that returns
several solutions needs a missing constraint, not a faster engine.

## A workflow for specifying and solving puzzles quickly

The following sequence uses the existing model and keeps the feedback loop short.

1. **Write the puzzle as data first.** Use the `gridString`, `entries`, `clues`, `variables`,
   `statements` and `digitConstraint` fields. Do not write a custom constraint until the declarative model
   is complete.

2. **Choose one relation style per clue.**
   - If the clue value equals an expression over entries or variables, attach the expression to the entry
     or clue.
   - If the clue is a classification (`#square`, `#prime`, `$derange`), use a generator or monadic function.
   - If several values are related (`£pandigital`, `£aspCheck`), use a polyadic function or a table.
   - If the clue must be mapped to an entry, use `mappingIsKnown: false` and an explicit ordering/mapping
     declaration.

3. **Declare domains precisely.** Set entry length, `digitConstraint` and leading-zero rules. Build variable
   domains from the stated set (`1..16`, `1..60`, the first fourteen primes, squares `4..2500`) rather than
   from a guessed range. Use generators for number-theoretic domains and cache them.

4. **Declare distinctness and ordering explicitly.** The default `DistinctConstraint()` applies all-different
   to every clue, entry and variable. Use `DistinctConstraint(allClues: false)` or the appropriate flags
   when the statement does not require that. Enable `OrderingConstraint(allClues: true)` whenever the
   statement says “in ascending order”, instead of relying on a pre-solve.

5. **Implement constraints in lifecycle order.**
   - `initialise`: derive domains and synthesize entries; do not solve.
   - `propagate`: local pruning from currently known values; return `(false, ...)` on contradiction and
     `(true, true)` when a domain changed.
   - `enforceDistinct`: all-different and paired/group rules.
   - `checkSolution`: final validation only, and never the only implementation.
   - `onBacktrackingStart`: mapping-specific setup, guarded by `isSolved`.

6. **Add known answers immediately.** Fill `setAnswers` with the published values, run the puzzle and break
   in `Expressable._checkAnswer`. This catches a wrong clue or over-narrow domain at the first bad update.

7. **Run the coverage diagnostic.** Fix every warning before optimizing. In particular, an entry that is
   unclued by design should be marked as such; an entry that is unclued by accident should get a clue.

8. **Run propagation to a fixed point, then search.** If propagation empties a domain, stop and inspect the
   culprit. If it leaves many unknowns, add propagation or reduce the mapping space before adding
   backtracking.

9. **Profile and compare.** Record propagation time, backtracking time and node count. If a manual search is
   faster, compare the constraints it enforces. A faster search that enforces fewer rules is not evidence
   that the model is wrong, and a slower search that enforces more rules may still be the better reference.

10. **Keep two permanent tests.** One asserts the published answer. One disables a key constraint and asserts
    that extra solutions appear, proving the constraint is doing work.

## Target API sketch

The sketch below is deliberately model-agnostic. In this repository, `Problem` should be a
`PuzzleDefinition` (or a thin adapter), and `Variable` should be an `Expressable`, `Entry` or `Clue`. A
scoped constraint can then wrap the existing `Constraint`/`PuzzleConstraint` hierarchy.

```dart
abstract class ScopedConstraint {
  Set<String> get scope;
  (bool consistent, bool updated) propagate(Domains domains);
  bool isSatisfied(Map<String, int> assignment);
}
```

```dart
final problem = Problem(
  variables: {
    'A': Variable('A', sumOfSquares),
    'e': Variable('e', allArgs),
    'G': Variable('G', allArgs),
    // ...
  },
  constraints: [
    TableConstraint(['e', 'G', 'L', 'A'], sumTriples),
    TableConstraint(['b', 'G', 'H', 'j', 'A'], sumTriples),
    ReversePairConstraint(['e', 'G', 'L'], ['b', 'G', 'H+j']),
    ReversePairConstraint(['C', 'B', 'G'], ['G', 'J', 'M-c']),
    // ...
    DistinctConstraint(allEntries),
  ],
);
```

The exact representation of derived values such as `H+j` and `M-c` depends on whether the table stores
base variables only or precomputed derived columns. Either way, the constraint should state the relation
directly rather than hiding it in an ID switch.

A companion diagnostic type makes the specification review actionable:

```dart
class PuzzleDiagnostics {
  final List<String> uncluedEntries;      // intentional or forgotten?
  final List<String> emptyClues;
  final List<String> noOpConstraints;
  final List<String> leafOnlyConstraints;
  final List<String> unusedFunctions;
  bool get isComplete => ...;
}

PuzzleDiagnostics diagnose(PuzzleDefinition puzzle);
```

When the model is a `PuzzleDefinition`, the adapter should seed variable domains from
`Expressable.possibleValues`, translate `ExpressionConstraint` trees, and expose `Grid`/`Cell` intersections
as constraints. The Snakes and Ladders path constraint, the One Sum reverse-pair constraint and the
all-different constraint can then coexist in one solver without puzzle-specific switches.

## Migration plan

### Generic engine

1. Add `scope` and `propagate` to the generic constraint interface, and adapt existing `PuzzleConstraint`
   implementations.
2. Make the engine accept a `PuzzleDefinition` (or an adapter) instead of a parallel `Problem` model.
3. Replace `updateExpressablesFromGrid` with `Grid`/`Cell` geometry.
4. Reuse `ExpressionConstraint` parsing and inversion; remove per-check parsing.
5. Add table, reverse-pair and scoped-distinctness constraints.
6. Return solutions and statistics from `solve`, and enable solution checking.

### One Sum Amuse

1. Keep the current solver and domains; add a regression test that pins the known solution.
2. Move the triple table and lookup helpers into the puzzle module, or expose them as generic table
   operations.
3. Add the missing `N == sumSquares(f-b/2, reverse(G), K)` check first. This is a small, local correctness
   fix.
4. Replace the `getValues` switch with constraint scopes and table projections, starting with the
   independent triple constraints.
5. Add explicit `ReversePairConstraint` objects for `A`, `a`, `d` and `N`.
6. Replace the global all-different rule with `DistinctConstraint`.
7. Populate intersections for all entries and remove the manual `Intersection` and `E`/`c` workaround.
8. Parse the check expressions once and remove the inject/uninject code.
9. Return solutions and statistics from `solve`, and enable solution checking.

### Snakes and Ladders

1. Keep `setAnswers` in `puzzles/snakes_and_ladders.dart` as the debug assertion, and add a test that asserts
   the published values. Verify that initial propagation still contains every known answer; the check only
   runs before backtracking.
2. Move `getWinningRolls()` into `SnakesAndLaddersConstraint.initialise`, store the path, and use it in
   `checkSolution`. Remove the CLI special case and the `print` calls.
3. Implement `propagate` for path uniqueness and the D94 multiple, and `enforceDistinct` for the clue
   answers. Use `Grid`/`Cell` rather than hard-coded indices.
4. Verify `U38`: restore the entry and clue with model-derived coordinates, or delete the dead computation
   and document why it is not part of the puzzle. Add a test that toggles it.
5. Replace the manual test's generator helpers with `GeneratorRegistry` and its digit lists with
   `Grid`/`Cell`.
6. Re-enable or delete `updatePath`; do not leave disabled pruning in place.
7. Make the manual test and the main solver agree on every entry, including distinctness and path digits.

## Priority order

If only a few changes are made, make them in this order:

1. **Complete the model before tuning the engine.** Add the missing clues, reverse-pair relations,
   distinctness and ordering. One Sum is the cautionary example; Snakes is the proof that the existing
   engine can solve a large correctly modelled puzzle.
2. **Add a coverage diagnostic.** It is the fastest way to find the next missing rule, and it prevents a
   successful solve from being mistaken for a complete model.
3. **Give constraints scope and propagation.** Convert leaf-only checks such as Snakes' path constraint and
   One Sum's `N` relation into pruning constraints. Keep `checkSolution` for validation.
4. **Reuse the existing model.** Do not build a second `Expressable`, parser, generator set or grid model.
   Build the search engine over `PuzzleDefinition`.
5. **Unify ordering and mapping.** Make the clue-order and clue-to-entry assignment part of the model, not a
   mixture of pre-solve code and hooks.
6. **Keep `setAnswers` and add statistics.** Use the answer check as a breakpoint, then measure propagation
   and backtracking separately so the next change is aimed at the real bottleneck.
7. **Pin the answer in tests and prove each constraint does work.** A known answer plus a constraint-disabled
   test is the minimum regression suite for a puzzle.

## Test plan

### One Sum Amuse

- The known solution is found exactly once.
- A solution with `K` inconsistent with `N` is rejected.
- A solution with a mismatched grid intersection is rejected, including intersections where a down entry
  is assigned after the across entry.
- Reordering the variables, or using minimum-remaining-values ordering, still finds the same solution.
- Disabling the reverse-pair constraint admits extra solutions, demonstrating that the constraint is
  actually doing work.
- The shared table and lookup helpers work without the puzzle-specific `gArg` heuristic.

### Snakes and Ladders

- The main solver finds exactly one solution, and every entry matches the published answer.
- The manual search and the main solver agree on every entry.
- The winning path is computed from the grid and equals
  `[5, 10, 46, 51, 56, 40, 85, 90, 95, 100]`.
- Path digits are unique; a deliberately duplicated path digit is rejected.
- D94 is a multiple of the number of even digits; an invalid D94 is rejected.
- All clue answers are distinct; an assignment with a duplicate clue answer is rejected.
- Restoring the omitted `U38` entry and clue either leaves the solution unchanged or changes the count in a
  documented way. The test must not simply ignore it.
- `getCoordinates`/`getSquare` round-trip for all 100 squares.
- Up-entry intersections are checked in both directions.
- The manual generator helpers, if retained, agree with the `GeneratorRegistry` outputs.

### Generic engine

- A solution with a mismatched grid intersection is rejected, including intersections where a down or up
  entry is assigned after its across partner.
- Reordering variables, or using degree or minimum-remaining-values ordering, still finds the same
  solution.
- Disabling a constraint admits extra solutions, demonstrating that the constraint is doing work.
- A constraint that only implements `checkSolution` is reported as leaf-only in the coverage diagnostic.
- The solver returns statistics and does not print unless printing is requested.

### Specification and diagnostics

- Setting a known answer and narrowing a domain past it throws at the first bad update, and the error names
  the expressable and value.
- The answer check is disabled during backtracking; a deliberately wrong leaf search is not reported by
  `setAnswers`, so the regression test must still assert the final answer.
- The coverage diagnostic flags an entry with no clue and no expression, a clue with no constraints and no
  domain, a `PuzzleConstraint` that was meant to implement a rule but is still the template stub, and a
  `checkSolution` that always returns `true`.
- The diagnostic distinguishes intentionally unclued entries (as in `abcd` and `relationship`) from
  forgotten ones, for example through an explicit `unclued: true` marker.
- An unknown-mapping puzzle with `OrderingConstraint(allClues: true)` admits extra mappings when the
  ordering is disabled, proving the ordering constraint is active.
- `initialise` is idempotent: running the pre-solve phase twice does not change the domains or entries.
- If per-puzzle registries are implemented, the same function name in two puzzles resolves independently.
  Until then, document that tests constructing several puzzles share global registrations and run in order.
- Multi-grid puzzles (`thirty`, `die_another_day`) validate every cross-grid pair and every cell relation
  in both directions.
- When `borderseries` is completed, it rejects a sequence with unequal gaps; the current `propagate` only
  enforces monotonicity and `checkSolution` always returns true.
- `triples` rejects a solution that violates the three commented-out `XII` clues, once they are restored.
