# ABCDE Puzzle Solver

## Puzzle

ABCDE by Nod

A, B, C, D and E are five primes such that A < B < C < D < E. The normal rules of algebra apply, all entries are distinct and no entry starts with zero.

```+--+--+--+--+--+--+--+
|1 :  :2 :3 |4 |5 :6 |
+::+--+::+::+::+::+::+
|7 :8 :  |9 :  |10:  |
+--+::+::+::+::+::+::+
|11:  :  :  |12:  |  |
+--+::+--+--+::+--+::+
|13:  :14:  |15:16:  |
+::+--+::+--+--+::+--+
|  |17:  |18:19:  :  |
+::+::+::+::+::+::+--+
|20:  |21:  |22:  :23|
+::+::+::+::+::+--+::+
|24:  |  |25:  :  :  |
+--+--+--+--+--+--+--+


Across
1	AB + BD
5	B + C
7	D - C
9	AB - E
10	B + B
11	CD - A
12	A + B
13	A + CD
15	E + E
17	B + C - A
18	BD - C
20	C + C + C
21	A + A + A
22	C + D - A
24	B + B + B
25	BE - D
Down
1	C
2	C + D
3	D + BC
4	BD + CD
5	D + AB
6	B + CD
8	A + D
13	CD - B
14	E + BD
16	BC - A
17	C + E - B
18	A + E - C
19	E - A
23	A + A
```

## Solution

```Puzzle Summary
A1, AB + BD, values={3818}
A5, B + C, values={54}
A7, D - C, values={118}
A9, AB - E, values={60}
A10, B + B, values={46}
A11, CD - A, values={4602}
A12, A + B, values={40}
A13, A + CD, values={4636}
A15, E + E, values={662}
A17, B + C - A, values={37}
A18, BD - C, values={3396}
A20, C + C + C, values={93}
A21, A + A + A, values={51}
A22, C + D - A, values={163}
A24, B + B + B, values={69}
A25, BE - D, values={7464}
D1, C, values={31}
D2, C + D, values={180}
D3, D + BC, values={862}
D4, BD + CD, values={8046}
D5, D + AB, values={540}
D6, B + CD, values={4642}
D8, A + D, values={166}
D13, CD - B, values={4596}
D14, E + BD, values={3758}
D16, BC - A, values={696}
D17, C + E - B, values={339}
D18, A + E - C, values={317}
D19, E - A, values={314}
D23, A + A, values={34}
+--+--+--+--+--+--+--+
| 3  8  1  8| 8| 5  4|
+   --      +  +     +
| 1  1  8| 6  0| 4  6|
+--+     +     +     +
| 4  6  0  2| 4  0| 4|
+--    --+--+   --+  +
| 4  6  3  6| 6  6  2|
+   --+   --+--+   --+
| 5| 3  7| 3  3  9  6|
+  +     +         --+
| 9  3| 5  1| 1  6  3|
+     +     +   --+  +
| 6  9| 8| 7  4  6  4|
+--+--+--+--+--+--+--+
Variables:
A={17}
B={23}
C={31}
D={149}
E={331}
```

## Lessons Learned

Add ABCDE puzzle
- Puzzle solves without variable ordering constraint
- Puzzle solves quicker with constraint