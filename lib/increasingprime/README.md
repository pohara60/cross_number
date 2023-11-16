# IncreasingPrime Puzzle Solver

## Puzzle

Ten Increasing Clues by Nod

Each answer may be expressed as p1 x p2 x p3 where the pi are distinct primes  and come  from the set  {3, 5, 11, 17, 23}. The answers to the clues are in ascending order. Upper case letters denote across entries and lower case down entries. The usual rules o f algebra apply, entries are distinct and there are no zeros in the grid.

+--+--+--+--+--+
|A :a :b |B :c |
+--+::+::+--+::+
|C :  |D :d :  |
+--+::+--+::+::+
|e |E :f :  :  |
+::+--+::+--+::+
|F :g :  :h |  |
+::+::+--+::+--+
|G :  :j |H :  |
+::+--+::+::+--+
|J :  |K :  :  |
+--+--+--+--+--+

```
Clues
I	j( f - C )
II	C + e - g - h
III	G - b - b
IV	G - J + K
V	D - H - j
VI	A + B - K
VII	d + e - K
VIII	F - a - H
IX	b + E - G
X	C + c + h
```

## Solution

```
```

## Lessons Learned

Add IncreasingPrimes puzzle. This does not complete the solution, further work is required.
Expression names with I, V and X are now parsed as (roman numeral) clue names. When validating clue references (checkClueClueReferences) these may be fixed to be variables - so this function must be called for such puzzles.
Support multiple expressions for a clue/entry. Solve Evaluators now accept the expression to solve, and have an optional parameter to specify the maximum number of variable combinations, to allow puzzle specific values. This affects many existing puzzle solve functions.
Generate expressions for entries from clues that refer to them, rearranging the expression to change the subject of the expression.
Solving a Clue/Entry may now update other Entry values with values that were valid for the expression(s).
Evaluation of monadic functions that generate values now include a limiting mechanism (hack!) to prevent runaway evaluation for NodeOrder.UNKNOWN.
Uniqueness of knownClueValues and knownEntryValues are maintained separately.
Puzzle iteration now includes Entries as well as Clues/Variables.
Variables maintain min/max values.
More regression tests added.
Regression output changes.
