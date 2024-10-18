# AfterNicholas Puzzle Solver

## Puzzle

After Nicholas by Czecker

Nicholas Parsons chaired the panel game Just a Minute on BBC Radio for over fifty years.  After he died, the ten people in this puzzle each chaired an episode of Series 86, before Sue Perkins was chosen as the new permanent chair. Each letter used in the puzzle represents a different number from 1 to 16  and the ^ symbol denotes to the power of .  All entries are distinct, and none starts with zero.

```+--+--+--+--+--+
|1 :2 :3 |4 :5 |
+::+::+::+::+::+
|6 :  |7 :  :  |
+--+::+--+--+::+
|8 :  |  |9 :  |
+::+--+--+::+--+
|10:11:12|13:14|
+::+::+::+::+::+
|15:  |16:  :  |
+--+--+--+--+--+


Across
1	PA + UL
4	S^(U/E)
6	-N + IS - H
7	( J + EN )( N - Y )
8	G ( Y - L/E + S )
9	L - U + CY
10	S^(T/E) + P + ( H - E )N
13	-J + U + L + I - A + N
15	TO + M
16	JO
Down
1	PA - UL
2	( S + U ) ^E
3	N + ( I - S )H
4	J + EN - NY
5	( G + Y )L + E^S
8	LU( C - Y )
9	S(( T/E )P - H ) - EN
11	J + ( U + ( L - I )/A )N
12	TO/M
14	J + O
```

## Solution

```A1, PA + UL, values={113}
A4, S^(U/E), values={27}
A6, -N + IS - H, values={74}
A7, ( J + EN )( N - Y ), values={532}
A8, G ( Y - L/E + S ), values={24}
A9, L - U + CY, values={20}
A10, S^(T/E) + P + ( H - E )N, values={862}
A13, -J + U + L + I - A + N, values={32}
A15, TO + M, values={88}
A16, JO, values={112}
D1, PA - UL, values={17}
D2, ( S + U ) ^E, values={144}
D3, N + ( I - S )H, values={35}
D4, J + EN - NY, values={23}
D5, ( G + Y )L + E^S, values={720}
D8, LU( C - Y ), values={288}
D9, S(( T/E )P - H ) - EN, values={231}
D11, J + ( U + ( L - I )/A )N, values={68}
D12, TO/M, values={21}
D14, J + O, values={22}
+--+--+--+--+--+
| 1  1  3| 2  7|
+        +     +
| 7  4| 5  3  2|
+--+  +--+--+  +
| 2  4|  | 2  0|
+   --+--+   --+
| 8  6  2| 3  2|
+        +     +
| 8  8| 1  1  2|
+--+--+--+--+--+
Variables:
A={5}
C={7}
E={2}
G={12}
H={10}
I={11}
J={8}
L={16}
M={4}
N={15}
O={14}
P={13}
S={9}
T={6}
U={3}
Y={1}
```

## Lessons Learned

Add AfterNicholas puzzle
- Pairs of clues refer to the same variables
- Override Puzzle.getRelatedVariables to use this