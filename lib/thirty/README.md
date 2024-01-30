# Thirty Puzzle Solver

## Puzzle

Thirty by Czecker

Every digit is even and there are fifteen pairs of even digits, from {0,0}, {0,2} up to {8,8}.  For this purpose, {p,q} is the same as {q,p}.  Each of the fifteen pairs fills one of the matching cells of the two grids, one in each grid.  All entries are distinct, and none starts with zero.

```
+--+--+--+--+--+
|1 :2 :  |3 :4 |
+::+::+--+::+::+
|  |5 :6 :  |  |
+::+::+::+::+::+
|7 :  |8 :  :  |
+--+--+--+--+--+

1ac = 1dn+ 3ac, both from the opposite grid
8ac = 3ac x 7ac, both from the same grid
The sum of the digits in the first grid equals the sum of the digits in the second grid.
No entry is a jumble of another entry.
```

## Solution

```
Solution 1
Puzzle Left
86624
06800
26624
Puzzle Right
82644
24480
20880
```

## Lessons Learned

