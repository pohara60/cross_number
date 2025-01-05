# Absurd Puzzle Solver

## Puzzle

Absurd by Nod

Letters in the clues stand for 11 distinct prime numbers  below 100. The clue a, b, c, d gives the entry ( a + √b) x (c - √d). Entries are distinct and do not start with zero.

```+--+--+--+--+--+
|1 :2 |3 :4 :5 |
+::+::+--+::+::+
|6 :  :7 :  |  |
+::+--+::+::+--+
|  |8 :  :  |9 |
+--+::+::+--+::+
|10|11:  :12:  |
+::+::+--+::+::+
|13:  :  |14:  |
+--+--+--+--+--+


Across
1	(H+√ D)*( H-√ D)
3	(D+√ I)*( D-√ I)
6	(F+√ F)*( F-√ F)
8	(J+√ K)*( J-√ K)
11	(K+√ J)*( K-√ J)
13	(J+√ D)*( J-√ D)
14	(H+√ H)*( H-√ H)
Down
1	(B+√ B)*( B-√ B)
2	(A+√ E)*( A-√ E)
4	(B+√ K)*( B-√ K)
5	(A+√ I)*( A-√ I)
7	(D+√ G)*( D-√ G)
8	(J+√ J)*( J-√ J)
9	(D+√ F)*( D-√ F)
10	(H+√ C)*( H-√ C)
12	(A+√ F)*( A-√ F)
```

## Solution

```A1, (H*H - D), values={32}
A3, (D*D - I), values={236}
A6, (F*F - F), values={4422}
A8, (J*J - K), values={800}
A11, (K*K - J), values={1652}
A13, (J*J - D), values={824}
A14, (H*H - H), values={42}
D1, (B*B - B), values={342}
D2, (A*A - E), values={24}
D4, (B*B - K), values={320}
D5, (A*A - I), values={68}
D7, (D*D - G), values={206}
D8, (J*J - J), values={812}
D9, (D*D - F), values={222}
D10, (H*H - C), values={18}
D12, (A*A - F), values={54}
+--+--+--+--+--+
| 3  2| 2  3  6|
+     +--      +
| 4  4  2  2| 8|
+   --+     +--+
| 2| 8  0  0| 2|
+--+      --+  +
| 1| 1  6  5  2|
+  +   --+     +
| 8  2  4| 4  2|
+--+--+--+--+--+
Variables:
A={11}
B={19}
C={31}
D={17}
E={97}
F={67}
G={83}
H={7}
I={53}
J={29}
K={41}
```

## Lessons Learned

Add Absurd Puzzle
