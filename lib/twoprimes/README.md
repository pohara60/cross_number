# TwoPrimes Puzzle Solver

## Puzzle

PRIMES by Oyler

Each letter represents a pair of prime numbers that sum to 100. Within a clue a letter can take either of its two values. No entry starts with zero and all entries are distinct.

+--+--+--+--+--+--+
|1 :  :2 |3 :4 :  |
+::+--+::+::+::+--+
|  |5 :  :  :  :6 |
+::+::+::+--+--+::+
|7 :  |8 :9 |10:  |
+::+--+--+::+::+::+
|  |11:12:  :  :  |
+::+::+::+::+::+::+
|13:  :  :  |14:  |
+--+--+--+--+--+--+

```
Across
1	I
3	PR
5	MR
7	P
8	P
10	S
11	EE
13	E + R
14	E
Down
1	IM
2	MR
3	MR
4	P - R - S
5	R
6	PS
9	P + S
10	I
11	E
12	P - P
```

## Solution

```
Puzzle Summary
A1, $variablevalue I, values={59}
A3, PR, values={319}
A5, $variablevalue M * $variablevalue R, values={8633}
A7, $variablevalue P, values={29}
A8, $variablevalue P, values={71}
A10, $variablevalue S, values={47}
A11, $variablevalue E * $variablevalue E, values={1411}
A13, $variablevalue E + $variablevalue R, values={172}
A14, $variablevalue E, values={83}
D1, $variablevalue I * $variablevalue M, values={5723}
D2, $variablevalue M * $variablevalue R, values={267}
D3, $variablevalue M * $variablevalue R, values={33}
D4, $variablevalue P - $variablevalue R - $variablevalue S, values={13}
D5, $variablevalue R, values={89}
D6, $variablevalue P * $variablevalue S, values={3763}
D9, $variablevalue P + $variablevalue S, values={118}
D10, $variablevalue I, values={41}
D11, $variablevalue E, values={17}
D12, $variablevalue P - $variablevalue P, values={42}
+--+--+--+--+--+--+
| 5  9| 2| 3  1  9|
+   --+  +      --+
| 7| 8  6  3  3| 3|
+  +      --+--+  +
| 2  9| 7  1| 4  7|
+   --+--+  +     +
| 3| 1  4  1  1| 6|
+--+         --+  +
| 1  7  2| 8| 8  3|
+--+--+--+--+--+--+
Variables:
E={17,83}
I={41,59}
M={3,97}
P={29}
R={11}
S={47}
```

## Lessons Learned

Created function to generate the two values of a variable. This produce one or two complementary values for each variable.