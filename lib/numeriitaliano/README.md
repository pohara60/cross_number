# NumeriItaliano Puzzle Solver

## Puzzle

Numeri in Italiano by Moog

The letters used represent the numbers 1 to 13 inclusive in an order to be determined with the same letter representing the same number throughout. The √ represents the square root of the letter immediately after it. No entry starts with zero and all entries are distinct.

```+--+--+--+--+--+
|1 :2 |3 :4 :5 |
+--+::+--+::+::+
|6 |7 :  :  |  |
+::+::+--+--+::+
|8 :  :  :9 :  |
+::+--+--+::+::+
|  |10:  :  |  |
+::+::+--+::+--+
|11:  :  |12:  |
+--+--+--+--+--+


Across
1	UNO
3	T^R - √E
7	SE + T + T + E
8	O^TT^O
10	D( I + E )C + I
11	( UN^D + I )CI
12	DO + D + IC - I
Down
2	DUE
4	QU + A + T - T + R - O
5	CINQUE
6	SEI
9	( −N + O )VE
10	DI - (√E)C + I
```

## Solution

```A1, UNO, values={32}
A3, T^R - √E, values={125}
A7, SE + T + T + E, values={121}
A8, (O^T)(T^O), values={16384}
A10, D( I + E )C + I, values={611}
A11, ( U(N^D) + I )CI, values={825}
A12, DO + D + IC - I, values={98}
D2, DUE, values={216}
D4, QU + A + T - T + R - O, values={21}
D5, CINQUE, values={5940}
D6, SEI, values={1188}
D9, ( -N + O )VE, values={819}
D10, DI - (√E)C + I, values={62}
+--+--+--+--+--+
| 3  2| 1  2  5|
+--   +--      +
| 1| 1  2  1| 9|
+  +   -- --+  +
| 1  6  3  8  4|
+   --+--      +
| 8| 6  1  1| 0|
+  +   --   +--+
| 8  2  5| 9  8|
+--+--+--+--+--+
Variables:
A={10}
C={5}
D={6}
E={9}
I={11}
N={1}
O={8}
Q={3}
R={7}
S={12}
T={2}
U={4}
V={13}
```

## Lessons Learned

Add Numeri Italiano puzzle
- Need to use parentheses for exponents, e.g. (O^T)(T^O)
