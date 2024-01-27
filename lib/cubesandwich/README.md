# CubeSandwich Puzzle Solver

## Puzzle

Cube Sandwich

Usual conventions apply, no duplicates or zero starts.

+--+--+--+--+--+
|1 :2 :  :3 :4 |
+::+::+--+::+::+
|5 :  |6 |7 :  |
+::+::+::+::+::+
|8 :  :  :  :  |
+--+--+--+--+--+

```
Across
1	cube
5	see 6dn
7	see 6dn
8	cube
Down
1	triangular
2	square
3	triangular
4	triangular
6	reverse(5ac + 7ac)
```

## Solution

```
Puzzle Summary
A1, #cube, values={21952}
A5, , values={36}
A7, , values={25}
A8, #cube, values={19683}
D1, #triangular, values={231}
D2, #square, values={169}
D3, #triangular, values={528}
D4, #triangular, values={253}
D6, $reverse(A5 + A7), values={16}
+--+--+--+--+--+
| 2  1  9  5  2|
+      --      +
| 3  6| 1| 2  5|
+     +  +     +
| 1  9  6  8  3|
+--+--+--+--+--+
```

## Lessons Learned

