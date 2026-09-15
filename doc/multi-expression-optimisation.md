# Multi-expression evaluation optimisation

## Status

Design proposal for review. This document describes a future implementation; it does not change the current evaluator or puzzle model.

## Motivation

An expressable can have more than one expression tree. `Evaluator.evaluate` currently evaluates every tree independently and intersects the result lists afterward. If the first expression leaves only a small number of compatible variable assignments, the later expressions still enumerate the full Cartesian product of each variable's current `possibleValues`.

For example, a first constraint may restrict `(A, B)` to a small correlated set of pairs. A second constraint involving `A` and `B` should evaluate only those pairs, rather than rebuilding all combinations of `A` and `B` and discovering the same restriction again.

The same opportunity exists for the value of the expressable itself when a constraint self-references it. This includes both `@` and an explicit reference to the owning expressable ID. A later self-referencing expression can use the values already produced by earlier expressions as its candidate self values.

Separately, statements currently become expression constraints in the order of the space-separated statement IDs on an entry. A statement priority lets puzzle authors put more restrictive constraints first, improving the value of the evaluation optimisation and making ordering intentional.

## Goals

- Preserve the current set of valid final values and variable assignments.
- Reuse compatible results from earlier expressions during the same `evaluate` call.
- Preserve correlations between variables; do not reduce combinations to independent variable domains.
- Use earlier expressable values for later expressions that reference the expressable itself.
- Keep the existing `previousResults` behavior used by the solver for `#result` and prior expressable values.
- Order statement-derived constraints by priority with deterministic tie behavior.
- Keep the optimisation local to one evaluation call and avoid mutating puzzle state.

## Non-goals

- Changing the meaning of expression intersection or logical operators.
- Replacing solver-level propagation or backtracking with a new solving algorithm.
- Persisting evaluated combinations between solver passes.
- Automatically estimating expression selectivity or reordering arbitrary expression constraints.

## Proposed evaluator model

### Evaluation context

Introduce an internal evaluation context for one `Evaluator.evaluate` call. The context contains:

- `Set<int>? selfValues`: candidate values for the owning expressable when a self-reference is evaluated.
- `List<Map<String, int>>? combinations`: compatible assignments produced by all expressions evaluated so far.
- The existing evaluator-level pinned variables, unchanged.

The public `evaluate` signature can remain source-compatible. The existing `previousResults` parameter continues to mean prior known values supplied by the solver, and should not be silently repurposed as same-call combinations. If the implementation exposes a new parameter on `evaluate`, it should be named explicitly, such as `previousCombinations`, and remain optional.

At the start of `evaluate`, there are no same-call combinations. `previousResults` may still initialize the existing `knownResults` state for `#result`; it is also an optional value-domain seed for self-reference only when the expression has no earlier same-call result.

### Detecting self-reference

Use the already collected variable list for each expression. An expression self-references the owning expressable when its variables contain `expressable.id`. This covers:

- `@`, which the parser converts to the current expressable ID.
- An explicit reference to the same ID.

This detection should happen per expression, not once for the whole expressable. A self-value restriction must only be passed to expressions that actually need it.

### Evaluating the first expression

Evaluate the first expression using the current puzzle domains and existing pinned variables. If it self-references, pass the existing `previousResults` value set as the initial self-value domain when one is available. Retain the current final self-reference filter as a correctness guard until the new path is proven by tests.

The returned `EvaluationFinalResult` values become the initial combination set. Each combination is the complete variable assignment carried by that result, plus the result value associated with the owning expressable. Internally, keep the owning value separate from the variable map or use a dedicated record so that an expressable ID which is also a variable cannot be confused with an unrelated binding.

### Evaluating subsequent expressions

Before evaluating expression `i`, derive its candidate context from the combinations accumulated through expressions `0..i-1`:

1. Project each prior combination onto variables named by expression `i`.
2. Keep the result value from each prior combination if expression `i` self-references.
3. Deduplicate identical projected assignments and self values.
4. Evaluate the expression only against those candidate assignments and self values.
5. Intersect the new results with the prior combinations using the existing shared-variable consistency rule.

The evaluator should accept candidate assignments as seeds for recursive evaluation. For a seed assignment, pin its variables and enumerate only variables absent from that seed using their current puzzle domains. This is important when two expressions mention different variables: an earlier expression must constrain shared variables without accidentally eliminating variables that it did not mention.

If the candidate combination list is empty, return an empty result immediately. If no prior result contains a variable needed by the next expression, fall back to the normal puzzle domain for that variable; this preserves behavior for expressions with disjoint variable sets.

The optimisation must not pass only per-variable sets when a combination list is available. For example, prior pairs `{A: 1, B: 2}` and `{A: 2, B: 1}` must not become `A in {1,2}` and `B in {1,2}`, because that would introduce the invalid pairs `(1,1)` and `(2,2)`.

### Result intersection

`resultsIntersection` currently groups by value and checks shared variable bindings. The optimised path should use the same semantic rule, but should avoid rebuilding combinations that were already rejected. A suitable internal operation is:

- For every current combination, match new results whose owning value is equal and whose shared variable bindings agree.
- Merge the maps for matching results.
- Retain all compatible merged assignments, including distinct assignments with the same value.

This should be implemented as a reusable internal helper or a carefully tested replacement for the current intersection implementation. It must not collapse results merely because their integer value is equal.

### Interaction with `previousResults`

The current solver passes `expressable.possibleValues` as `previousResults`. The design keeps these meanings separate:

- `previousResults` remains the solver's prior value set and the source for hard-coded `#result` through `knownResults`.
- Same-call combinations are generated from completed expression results.
- For a self-referencing expression, the first expression may use `previousResults` as a value-domain restriction; subsequent expressions use the owning values in same-call combinations.

If `previousResults` is null, self-reference remains evaluable from the normal expressable domain only when that domain is available through the existing puzzle lookup. If it is not available, the evaluator should preserve current failure/empty-result behavior rather than assume an unbounded self domain.

## Proposed statement priority

Add a priority field to `Statement`:

```dart
class Statement {
  final String id;
  final String expression;
  final int priority;

  Statement(this.id, this.expression, {this.priority = 0});
}
```

`copyWith` must preserve and allow overriding `priority`, and `toString` should include it only if that is consistent with existing debugging output. A default of `0` preserves source compatibility and gives existing statements equal priority.

When `PuzzleDefinition` converts entry statement IDs into `ExpressionConstraint`s:

1. Resolve IDs and report unknown IDs exactly as today.
2. Ignore statements with empty expressions exactly as today.
3. Sort resolved statements by descending priority.
4. Preserve the original statement-list order for equal priorities using a stable sort or an explicit original-index tie breaker.
5. Append the resulting expression constraints to the entry's existing constraints as today, unless review decides that statement constraints should also be globally reordered.

The proposed ordering is descending priority: a larger number means “evaluate earlier.” Existing statements all use the default priority and therefore retain their relative order. `ExpressionConstraint.fromStatement` can remain unchanged because priority is needed for ordering, not evaluation, unless retaining provenance becomes desirable for diagnostics.

### Scope of ordering

Only statement-derived constraints should be reordered. Constraints supplied directly on an entry or clue retain their existing order. This minimizes behavioral change and avoids assigning a priority policy to `ExpressionConstraint`, which currently has no such field.

If a puzzle author needs a direct constraint to run before a statement, the implementation can later add a broader constraint-ordering model; that is outside this proposal.

## Correctness invariants

The implementation is correct only if all of these remain true:

- Every optimised result is producible by the current evaluator.
- Every current result remains producible unless it conflicts with a candidate restriction that was already established by an earlier expression in this same call.
- Shared variables have one value across a merged result.
- Duplicate value/assignment pairs do not affect the final result set.
- A self-reference is filtered by the owning expressable's value, whether written as `@` or explicitly.
- Constants and generator results are not incorrectly restricted by variable candidate assignments.
- Existing pinned variables continue to take precedence over candidate seeds.
- `#result` continues to use sorted `knownResults` and is unaffected by same-call combinations.

The safest rollout is to keep a reference implementation or a debug-only comparison mode that evaluates both paths and asserts equivalent result sets for representative puzzles.

## API and implementation sketch

Likely internal changes:

- Add an optional candidate context to `evaluateExpression` or introduce a private `_evaluateExpressionWithContext` method.
- Extend `_internalEvaluate` to accept seed assignments and an optional self-value domain.
- Add a small immutable internal result/combination type if carrying the owning value separately is clearer than overloading `EvaluationResult.variableValues`.
- Reuse `tooManyCombinations` after candidate filtering; the limit must apply to the actual seeded search, not the unfiltered puzzle Cartesian product.
- Keep public `evaluateExpression` behavior unchanged when no context is supplied.

The implementation should avoid mutating `_pinnedVariables` or any `Expressable.possibleValues`. Recursive branches can continue using `copyWith`, with candidate assignments merged into the copied evaluator's pins after checking for conflicts.

## Tests

Add focused tests before or alongside implementation:

- Two expressions sharing two variables where the first expression produces correlated pairs; verify the second expression never admits cross-paired values and final assignments are unchanged.
- A later expression with a strict self-reference using `@`.
- A later expression with an explicit self-reference by expressable ID.
- A first expression with no self-reference followed by a self-referencing expression, verifying the latter uses earlier values rather than the broad prior domain.
- Expressions with disjoint variables, verifying no valid result disappears.
- Existing pinned variables combined with candidate assignments.
- Empty intermediate results and `EvaluatorNotPossibleException` behavior.
- Duplicate values with distinct variable assignments.
- `#result` with and without `previousResults`.
- Statement priorities: higher priority first, equal-priority statements retain declaration order, default priority preserves existing puzzles, and `copyWith` retains/overrides priority.
- A puzzle-definition test confirming only statement-derived constraints are reordered.

For the optimisation, compare the optimised output with a deliberately unoptimised reference evaluator on randomized small domains. Compare sets of `(value, variableValues)` rather than only value sets.

## Performance measurement

Instrument or benchmark at least:

- Number of variable assignments enumerated per expression.
- Number of expression-tree evaluations.
- Number of candidate combinations before and after each expression.
- Wall-clock time for puzzles with restrictive early statements.

The optimisation is most useful when an early expression materially reduces correlated assignments. For expressions with disjoint variables or broad results, candidate setup has a cost and may provide little benefit. A small threshold can therefore be considered later, but correctness should not depend on a heuristic.

## Open decisions for review

1. Should a new public `previousCombinations` argument be exposed, or should candidate combinations remain entirely private to `evaluate`? I do not see a need to expose it.
2. Should `previousResults` restrict the first self-reference, or should it remain exclusively the `#result` input and only same-call results constrain self-reference? Can safely restrict the first self-reference.
3. Is descending integer priority the desired convention, and is `0` the right backward-compatible default? OK
4. Should statement-derived constraints be sorted only among themselves, as proposed, or should all expression constraints receive an ordering abstraction? Statement only for now - in practise a puzzle either uses statements or uses direct constraints.
5. Should the internal owning-value field be a new type, or can the existing `EvaluationFinalResult` representation safely carry it without ambiguity? I think we can use the existing type, this is more homogeneous. 
6. Should the evaluator retain a reference-path comparison behind an assertion or test-only helper during rollout? There are a few in the test suite that can verify correct answers to a puzzle, but it would be reassuring to have a comparison during rollout.
