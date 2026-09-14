# IF Expression

## Goal

Add a conditional operator with the form:

```text
value-expression IF condition-expression
```

The condition is evaluated as an existence test. For every compatible evaluation in which the condition produces a result, return the value expression's result. If the condition produces no result, return no result. The condition's numeric value is not returned.

Examples:

```text
10 IF 1 = 1        # produces 10
10 IF 1 = 2        # produces no result
A IF A > 3         # produces A for values of A greater than 3
```

The operator should work with constants, variables, grid references, generators, grouped expressions, and nested expressions.

## Proposed syntax and AST

1. Add `TokenType.IF` to `expression.dart`.
2. In the scanner in `parser.dart`, recognize the identifier lexeme `IF` as the keyword token `TokenType.IF`. Keep ordinary identifiers unchanged. This makes uppercase `IF` the supported spelling and reserves that identifier for the operator.
3. Add a dedicated `IfExpression` AST node rather than encoding the operation as a generic `BinaryExpression`. It should contain:
   - `value`, the expression returned when the condition succeeds;
   - `condition`, the expression whose result existence controls the value.
4. Add `visitIfExpression` to `ExpressionVisitor` and implement `IfExpression.accept`.
5. Update `VariableExtractorVisitor`, `VariableVisitor`, and the expressable visitor used by `inverter.dart` to visit both children. These visitors are part of the AST's compile-time surface and must continue to discover variables and referenced entries on either side of `IF`.
6. Give `IfExpression.toString()` an unambiguous representation such as `($value IF $condition)`.

## Parsing and precedence

Treat `IF` as a low-precedence, right-associative operator. The parser should be structured approximately as:

```text
_expression -> _if
_if         -> _logicalAnd (IF _if)?
```

This gives the following behavior:

```text
A + 1 IF B > 2       == (A + 1) IF (B > 2)
A IF B IF C           == A IF (B IF C)
(A IF B) + 1          requires parentheses around the conditional
```

The exact associativity should be covered by parser tests. Parentheses should continue to call `_expression`, allowing a conditional anywhere a primary/grouped expression is accepted.

The keyword must be scanned before parsing; merely checking an identifier's lexeme in the precedence parser would make token handling inconsistent with the rest of the grammar and would make error reporting less clear.

## Evaluation behaviour

Implement `visitIfExpression` in `evaluator.dart` using the existing `List<EvaluationResult>` contract:

1. Evaluate the condition with a range broad enough to determine whether it has any results. The condition's result values are only a truth/existence signal.
2. If the condition has no results, return an empty list immediately.
3. Evaluate the value expression using the caller's `min` and `max` bounds.
4. Combine condition and value results only when their `variableValues` maps are consistent. Preserve the value expression's numeric value and merge compatible variable assignments from both expressions.
5. Return no result when all combinations conflict. Do not return the condition's numeric value.

The implementation should preserve the evaluator's existing distinction between:

- an expression that has no possible values, represented by an empty result list; and
- an evaluator state that cannot currently be evaluated, represented by `EvaluatorNotPossibleException`.

Unless the existing evaluator establishes a different convention during implementation, propagate `EvaluatorNotPossibleException` from the condition and value expressions rather than converting it to a false condition. This avoids silently discarding constraints that are temporarily unavailable.

The condition should be evaluated before the value expression so a false condition can short-circuit the value expression. This is especially important for generators and expressions that may be expensive or may throw an evaluation error. If the condition has multiple results, each condition assignment must be checked against each value assignment; this allows a variable in the condition to constrain the value expression.

`evaluateExpression` and `evaluateExpressionNoVariables` should require no special post-processing because `IfExpression` will return ordinary `EvaluationResult` objects and the existing integer/range filtering will apply to the value side.

## Inversion and solver integration

A conditional expression is not algebraically invertible in the same way as `+`, `-`, `*`, or `/`. Update `ExpressionInverter` deliberately:

- Traverse both `value` and `condition` when looking for a target entry.
- Do not attempt to rearrange an `IfExpression` unless a clear rule is defined.
- Prefer throwing `InvertException` with an explicit unsupported-`IF` message when inversion reaches the conditional node. This prevents the solver from pretending that the condition can be rearranged safely.

The solver should otherwise receive the filtered value results normally. Verify that variable extraction includes variables from the condition; otherwise the evaluator could fail to enumerate condition variables before evaluation.

## Tests

### Scanner and parser

Add focused tests in `test/parser_test.dart` and/or `test/expression_test.dart` for:

- `10 IF 1 = 1` producing an `IfExpression` with a value subtree and condition subtree;
- scanning uppercase `IF` as `TokenType.IF`;
- precedence in `A + 1 IF B > 2`;
- right associativity in `A IF B IF C`;
- parentheses in `(A IF B) + 1`;
- rejecting a malformed expression such as `A IF` with `ParseException`;
- deciding and documenting whether lowercase `if` remains an ordinary identifier or is rejected as an unsupported spelling.

### Evaluator

Add focused tests in `test/evaluator_test.dart` for:

- a true constant condition returning the value expression;
- a false constant condition returning an empty list;
- a condition whose result is nonzero but irrelevant as a numeric value, proving the value side is returned;
- a variable condition, for example `A IF A > 2`, checking both values and `variableValues`;
- condition/value variables with compatible assignments, such as `A IF B > A`;
- conflicting assignments producing no result;
- a false condition preventing evaluation of the value side, if a suitable error-producing or unavailable expression can be tested without weakening normal error handling;
- grouped and nested `IF` expressions;
- both `evaluateExpression` and `evaluateExpressionNoVariables` paths where practical.

Add visitor/inverter coverage if those components have existing tests. At minimum, run the full Dart test suite after implementation because adding a visitor method affects every `ExpressionVisitor` implementation at compile time.

## Implementation order

1. Add the token, AST node, visitor method, and variable/reference traversal support.
2. Add scanner recognition and parser precedence/associativity.
3. Add evaluator short-circuiting and compatible-variable-result merging.
4. Update inversion behaviour explicitly for unsupported conditional inversion.
5. Add parser and evaluator tests, then run formatting, analysis, and the full test suite.

## Approved decisions

All the below decisions are approved:
- Confirm that “true” means “the condition has at least one evaluation result,” matching the existing logical-operator convention, rather than requiring a particular numeric value such as `1`.
- Confirm that `IF` is uppercase-only and reserved, or specify case-insensitive keyword handling.
- Confirm right associativity for chained conditionals. The proposed grammar uses `A IF (B IF C)`.
- Confirm that a condition may contain variables not present in the value expression and that those assignments should be retained in the final `variableValues` map.
- Confirm the desired behaviour when the condition or value cannot currently be evaluated and throws `EvaluatorNotPossibleException`.
