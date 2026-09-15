# Self-Reference in Expressions

## Goal

Allow one reusable expression constraint to refer to the expressable whose value the expression computes.

For example:

```text
@ IF $isOdd $digitproduct @
```

When this constraint is attached to expressable `A`, it should be parsed as the equivalent of:

```text
A IF $isOdd $digitproduct A
```

The same constraint can therefore be attached to `A`, `B`, or an entry/clue on another grid without editing the expression text.

## Proposed syntax

Use `@` as the self-reference placeholder.

Reasons for choosing `@`:

- It cannot collide with an existing identifier or variable name.
- It is visually recognizable as a reference to the current owner.
- It is distinct from `$` monadic functions, `#` generators, and `£` polyadic functions.
- It avoids reserving a normal identifier such as `SELF`, which could break existing puzzles that use that name as a variable.

`@` represents the current `Expressable.id`, not the current value as a special evaluator variable. The parsed tree should contain the actual reference, so variable extraction, dependency grouping, inversion, and evaluation continue to use the existing mechanisms.

The placeholder is valid only when the parser is given an owner ID. Parsing an expression containing `@` without an owner context should fail with a clear `ParseException` rather than leaving an unresolved node in the tree.

## Parsing API and resolution

Pass the owner ID into the parser at the point where `Expressable.addExpression` parses an `ExpressionConstraint`:

```dart
final parser = Parser(constraint.expression, currentExpressableId: id);
```

The exact parameter name may be adjusted to match local style, but the context must be explicit and optional for existing standalone parser users.

Add a token for `@`, for example `TokenType.SELF_REFERENCE`. In `_primary`, consume that token and resolve it immediately to an ordinary expression node:

- For an ID without `.`, create `VariableExpression(currentExpressableId)`.
- For a grid-qualified ID such as `left.A1`, create the same reference shape used when parsing `left.A1` normally, namely `GridReferenceExpression('left', 'A1')`.

Do not add a permanent `SelfReferenceExpression` node unless resolution must be deferred. Immediate resolution keeps the resulting tree indistinguishable from a hand-written expression containing the actual owner ID.

The parser should reject `@` when `currentExpressableId` is absent. It should also reject an empty or malformed owner ID rather than generating an invalid expression tree. The owner ID should be validated using the same reference rules already used by `PuzzleDefinition` for single-grid and multi-grid names.

The scanner should treat `@` as a token wherever it appears as an expression primary. Existing identifiers, including lowercase `self` or uppercase `SELF`, remain unchanged because `@` is the only new spelling.

## Context propagation and cached trees

`Expressable.addExpression` already has access to `id`; this is the controlling integration point. Update it to pass the ID into the parser before variable extraction.

Review `ExpressionConstraint.expressionTree` and `variables` caching carefully. A constraint containing `@` is context-dependent, so the same `ExpressionConstraint` instance must not retain a tree parsed for one owner and reuse it for another owner. Choose one of these approaches:

1. Parse and cache context-free constraints as today, but parse self-referencing constraints per owner; or
2. Store the owner ID with the cached tree and reparse when it changes; or
3. Stop caching the parsed tree on the constraint and let each owning expressable retain its own parsed tree and variable list.

The preferred approach is to make the cache owner-aware while preserving the current public fields for compatibility. At minimum, add a regression test that attaches one self-referencing constraint instance to two expressables and verifies that the trees contain different resolved references.

Statement-derived constraints are safe when each statement reference creates a new `ExpressionConstraint`, but they still must be parsed through the owning expressable's context.

## AST and evaluator impact

No new evaluator behaviour is required. After parsing, `@` should already be a normal `VariableExpression` or `GridReferenceExpression`, so the existing evaluator will:

- include the owner in the expression's variable list;
- enumerate its possible values when it is not pinned;
- preserve the self value through `IF` result bindings; and
- apply the existing `evaluate` filtering that requires an expression involving the expressable to agree with that expressable's value.

The current IF expression should consequently work as follows:

```text
@ IF $isOdd $digitproduct @
```

The condition evaluates against the same owner value represented by the value expression. When the condition has no result, the expression produces no result; when it has a result, the returned numeric value is the owner's value.

Do not implement `@` as a magic evaluator variable or special-case it in `Evaluator.visitVariableExpression`. That would bypass the normal variable extraction and could make dependency grouping and pinning inconsistent.

## Multi-grid behaviour

For a single-grid owner such as `A`, resolve `@` to `VariableExpression('A')`, matching existing unqualified references.

For a multi-grid owner such as `left.A1`, resolve `@` to `GridReferenceExpression('left', 'A1')`. The resolved variable/reference list must contain the exact lookup key expected by `PuzzleDefinition.getExpressable`.

Add tests for both forms. Also verify that self-reference does not bypass the existing multi-grid validation rules.

## Related implementation surfaces

1. `lib/src/expressions/expression.dart`
   - Add the self-reference token type.
   - No new AST node is preferred if resolution happens during parsing.
2. `lib/src/expressions/parser.dart`
   - Accept the optional owner context.
   - Scan `@`.
   - Resolve it in `_primary` into the appropriate existing reference node.
   - Add parse errors for missing context and malformed owner IDs.
3. `lib/src/models/expressable.dart`
   - Pass `id` into `Parser` from `addExpression`.
   - Make parsed-expression caching owner-aware if a constraint can be reused.
4. `lib/src/models/expression_constraint.dart`
   - Adjust cache metadata or ownership behaviour if needed by the chosen caching approach.
5. `lib/src/models/puzzle_definition.dart`
   - No direct parser call is expected, but verify that expression parsing and dependency validation still see the resolved owner ID.
6. `lib/src/expressions/variable_visitor.dart`
   - No special self-reference logic should be needed after resolution; verify the resolved reference is collected.
7. `lib/src/expressions/inverter.dart`
   - No special self-reference logic should be needed after resolution. Existing inversion behaviour should see the resolved target reference.
8. `lib/src/expressions/evaluator.dart`
   - No special self-reference logic should be needed. Add only a regression test around the existing IF path if required.

## Tests

### Parser tests

Add focused tests for:

- `Parser('@', currentExpressableId: 'A')` producing `VariableExpression('A')`;
- `Parser('@', currentExpressableId: 'left.A1')` producing `GridReferenceExpression('left', 'A1')`;
- `@ IF 1 = 1` resolving both occurrences to the same owner reference;
- parsing `@` without context throwing `ParseException` with an actionable message;
- retaining existing behaviour for identifiers named `SELF` or `self`;
- rejecting malformed or empty owner IDs;
- confirming that `@` still works inside grouping, monadic, polyadic, and nested IF expressions.

### Expressable integration tests

Add tests that:

- attach `ExpressionConstraint('@ IF $isOdd $digitproduct @')` to an expressable and verify its parsed tree and variable list contain the expressable's actual ID;
- evaluate the expression and confirm that only values satisfying the condition remain;
- reuse the same constraint instance for two expressables and confirm each resolves `@` to its own ID;
- verify an owner ID on a multi-grid entry resolves and evaluates through the normal grid-reference path;
- confirm a self-reference participates in the existing inversion/dependency checks rather than being treated as an unknown variable.

Run the existing parser, evaluator, solver, and puzzle tests because contextual parsing changes when expression trees are created and because self-reference intentionally creates a dependency on the expression's owner.

## Implementation order

1. Add `@` scanning and parser context/resolution, with parser tests.
2. Pass the owning `Expressable.id` through `addExpression`.
3. Make expression-tree caching safe for reused constraints.
4. Add single-grid and multi-grid integration tests.
5. Run formatting, static analysis, and the full test suite.

## Review decisions

The following choices are proposed for review - all approved.

- Placeholder syntax: `@`.
- Resolution timing: replace `@` while parsing, so no self-reference node reaches evaluation.
- Resolution target: the current `Expressable.id`.
- Single-grid target: `VariableExpression`.
- Grid-qualified target: `GridReferenceExpression`.
- Missing parser context: parse error.
- Existing names `SELF` and `self`: remain ordinary identifiers.
- Reused constraint instances: parsed trees must be owner-aware and must never retain the first owner's substitution.
