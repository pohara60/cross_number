# Combinations Puzzle Solver

## Puzzle

Combinations by Nod

The letters A to J represent the numbers 1 to 10 in random order and are used in normal algebraic expressions for N and k. Clues give N, k and entry length. Entries are any of three types. i. NCk : the number of ways of choosing k objects from a set of N objects. ii. Sum of the next k primes greater than N iii. Product of the next k primes greater than N

```+--+--+--+--+--+--+--+--+
|1 :2 :3 |4 :  :5 :6 :7 |
+::+::+::+::+--+::+::+::+
|8 :  |9 :  :10|11:  :  |
+::+::+::+::+::+::+::+::+
|12:  :  |  |13:  :  |  |
+--+::+--+::+::+::+--+::+
|14:  :15:  |16:  :17:  |
+::+--+::+::+::+--+::+--+
|  |18:  :  |  |19:  :20|
+::+::+::+::+::+::+::+::+
|21:  :  |22:  :  |23:  |
+::+::+::+--+::+::+::+::+
|24:  :  :  :  |25:  :  |
+--+--+--+--+--+--+--+--+


Across
1	GJ(B+I)-JJ
4	BFJ
8	A+E
9	BB+C
11	AF-E
12	J(AI-C)
13	DE
14	IJ
16	I(D-C)
18	JJ
19	AH
21	BB+J
22	D+F
23	D-H
24	F(GJ-A)
25	EG
Down
1	EF(B+F+G)
2	BF
3	EF
4	FG(B+I)-I
5	F(B+F+G)
6	I(I+I)
7	DD
10	AAGG+B+B
14	BG
15	ABJ-E
17	F(BGH-I)
18	B(F+G)
19	I+J
20	DHJ
```

## Solution

```Puzzle Summary
A1, GJ(B+I)-JJ | E, values={946}
A4, BFJ | G - J, values={95477}
A8, A+E | F - G, values={20}
A9, BB+C | GJ, values={666}
A11, AF-E | AD, values={703}
A12, J(AI-C) | H, values={487}
A13, DE | F - I, values={437}
A14, IJ | H - C, values={1763}
A16, I(D-C) | D - G, values={4757}
A18, JJ | C + C, values={899}
A19, AH | I - C, values={792}
A21, BB+J | H(B + G), values={820}
A22, D+F | F + G, values={171}
A23, D-H | J - H, values={77}
A24, F(GJ-A) | C + F - D, values={97343}
A25, E^G | I - A, values={556}
D1, EF(B+F+G) | C+C, values={924}
D2, BF | E, values={4087}
D3, EF | F-I, values={667}
D4, FG(B+I)-I | D-G, values={960391}
D5, F(B+F+G) | D+I, values={4737}
D6, I(I+I) | E+H, values={707}
D7, DD | G-J, values={7387}
D10, AAGG+B+B | B-A, values={644773}
D14, BG | GH, values={1889}
D15, ABJ-E | H-C, values={6903}
D17, F(BGH-I) | F-J, values={5975}
D18, B(F+G) | D-E, values={827}
D19, I+J | B+H, values={715}
D20, DHJ | J-H, values={276}
+--+--+--+--+--+--+--+--+
| 9  4  6| 9  5  4  7  7|
+        +   --         +
| 2  0| 6  6  6| 7  0  3|
+     +        +        +
| 4  8  7| 0| 4  3  7| 8|
+--+   --+  +      --+  +
| 1  7  6  3| 4  7  5  7|
+   --+     +   --+   --+
| 8| 8  9  9| 7| 7  9  2|
+  +        +  +        +
| 8  2  0| 1  7  1| 7  7|
+        +--+     +     +
| 9  7  3  4  3| 5  5  6|
+--+--+--+--+--+--+--+--+
Variables:
A={4}
B={6}
C={1}
D={9}
E={2}
F={10}
G={7}
H={3}
I={8}
J={5}
```

## Lessons Learned

Add Combinations puzzle
- Requires custom clue solver to evaluate two clue expressions in parallel
- Refactored expression evaluator slightly
- Added function to generate primes over a value
