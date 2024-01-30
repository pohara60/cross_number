# IncreasingFibonnaci Puzzle Solver

## Puzzle

Ten Increasing Clues  by Oyler

Each answer may be expressed as  F1 x F2 x F3 where the Fi are distinct and come from five distinct Fibonacci numbers less than 20 to be determined. The answers to the clues are given in ascending order. Upper case letters denote across entries and lower case down entries. No entry starts with zero  and all entries are distinct. The usual rules of algebra apply.

```
+--+--+--+--+--+
|A :a :b |B :c |
+--+::+::+--+::+
|Cd:  |  |De:  |
+::+--+::+::+--+
|E :  |F :  :  |
+--+--+--+--+--+

Clues
I	e - a
II	a - B
III	B + c
IV	F - e
V	d - E
VI	A/2 - c
VII	e + e
VIII	C + F
IX	A + D
X	B + b + c
```

## Solution

```
Puzzle Summary
I, e - a, values={15}
II, a - B, values={24}
III, B + c, values={39}
IV, F - e, values={40}
V, d - E, values={65}
VI, A/2 - c, values={104}
VII, e + e, values={120}
VIII, C + F, values={195}
IX, A + D, values={312}
X, B + b + c, values={520}
A, values={244}
a, values={45}
b, values={481}
B, values={21}
c, values={18}
C, values={95}
d, values={92}
D, values={68}
e, values={60}
E, values={27}
F, values={100}
+--+--+--+--+--+
| 2  4  4| 2  1|
+--      +--   +
| 9  5| 8| 6  8|
+   --+  +   --+
| 2  ?| 1  0  0|
+--+--+--+--+--+
```

## Lessons Learned

