# Prime Puzzle Solver

## Puzzle

ABCD by Nod

A, B, C and D are four primes such that D > C > B > A. The normal rules of algebra apply, all entries are distinct and no entry starts with zero.

```
+--+--+--+--+--+--+
|1 :2 :  :3 |4 :5 |
+::+::+--+::+::+::+
|6 :  |7 :  :  :  |
+::+--+::+--+--+::+
|  |8 :  :9 |10:  |
+--+::+::+::+::+--+
|11:  |12:  :  |13|
+::+--+--+::+--+::+
|14:15:16:  |17:  |
+::+::+::+--+::+::+
|18:  |19:  :  :  |
+--+--+--+--+--+--+

Across
1 AC+CD 4
4 A+A+A 2
6 A 2
7 B+AD 4
8 AB-D 3
10 A+A 2
11 C 2
12 BC+D 3
14 AD-BC 4
17 A+C-B 2
18 B 2
19 AD-AB 4
Down
1 B+AC 3
2 B+B+B 2
3 A+C 2
4 A+B+C 2
5 D-A 3
7 AB+C 3
8 A+B-C 2
9 AC-D 3
10 B+B 2
11 A+C+D 3
13 AB+AC 3
15 C+C+C 2
16 B+C 2
17 B+C-A 2
```

## Manual Solution Path

```
- The clues that involve one letter, along with the A<B<C<D relation, and common entry digits, give the values of A, B and C. 
- Then A1 gives the value of D
```

## Solution

```
Puzzle Summary
A1, AC+CD, values={4554}
A4, A+A+A, values={51}
A6, A, values={17}
A7, B+AD, values={3096}
A8, AB-D, values={142}
A10, A+A, values={34}
A11, C, values={23}
A12, BC+D, values={618}
A14, AD-BC, values={2640}
A17, A+C-B, values={21}
A18, B, values={19}
A19, AD-AB, values={2754}
D1, B+AC, values={410}
D2, B+B+B, values={57}
D3, A+C, values={40}
D4, A+B+C, values={59}
D5, D-A, values={164}
D7, AB+C, values={346}
D8, A+B-C, values={13}
D9, AC-D, values={210}
D10, B+B, values={38}
D11, A+C+D, values={221}
D13, AB+AC, values={714}
D15, C+C+C, values={69}
D16, B+C, values={42}
D17, B+C-A, values={25}
+--+--+--+--+--+--+
| 4  5  5  4| 5  1|
+      --   +     +
| 1  7| 3  0  9  6|
+   --+   --+--+  +
| 0| 1  4  2| 3  4|
+--+        +   --+
| 2  3| 6  1  8| 7|
+   --+--+   --+  +
| 2  6  4  0| 2  1|
+         --+     +
| 1  9| 2  7  5  4|
+--+--+--+--+--+--+
Variables:
A={17}
B={19}
C={23}
D={181}
```

## Lessons Learned


