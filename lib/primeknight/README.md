# PrimeKnight Puzzle Solver

## Puzzle

The Prime Knight by Oyler

Starting in the top left corner cell, the Prime Knight goes on a tour of the grid making knight s moves visiting each cell once and finishing in the bottom right corner cell. The sequence of grid digits covered by the tour forms a concatenation of ten distinct 2-digit primes. The immediate neighbours of any such prime are either both higher or both lower than that prime. The sum of the primes collected is a multiple of 8ac. Entries are distinct but may duplicate tour primes. There are no zeros in the grid.

```+--+--+--+--+--+
|1 :2 :  |3 :4 |
+::+::+--+--+::+
|  |5 :6 |7 :  |
+--+::+::+::+--+
|8 :  |9 :  |10|
+::+--+--+::+::+
|11:  |12:  :  |
+--+--+--+--+--+


Across
1	$prime
3	A7-A9
5	$prime
7	$prime
8	$prime
9	$prime
11	$prime
12	$prime
Down
1	#triangular
2	$prime
4	$prime
6	$DP = A3
7	$multiple A5
8	A3+A7
10	$prime
```

## Solution

```Successful tour [(0, 0), (1, 2), (0, 4), (2, 3), (3, 1), (1, 0), (0, 2), (1, 4), (3, 3), (2, 1), (1, 3), (0, 1), (2, 0), (3, 2), (2, 4), (0, 3), (1, 1), (3, 0), (2, 2), (3, 4)], primes [97, 43, 71, 17, 59, 37, 53, 11, 61, 23]
Puzzle Summary
A1, #prime, values={971}
A3, A7-A9, values={14}
A5, #prime, values={67}
A7, #prime, values={37}
A8, #prime, values={59}
A9, #prime, values={23}
A11, #prime, values={17}
A12, #prime, values={353}
D1, #triangular, values={91}
D2, #prime, values={769}
D4, #prime, values={47}
D6, A3 = $DP #result, values={72}
D7, $multiple A5, values={335}
D8, A3+A7, values={51}
D10, #prime, values={13}
+--+--+--+--+--+
| 9  7  1| 1  4|
+      --+--   +
| 1| 6  7| 3  7|
+--+     +   --+
| 5  9| 2  3| 1|
+   --+--+  +  +
| 1  7| 3  5  3|
+--+--+--+--+--+
```

## Lessons Learned

Add PrimeKnight puzzle, with constraints on cells in knights tour.
- Requires mapping of entries to grid cells
    - Rename old Grid as GridSpec
    - Create new Grid with Cells linked to Entries (after Entries created)
    - When have Grid, save Entry digits to Cells
    - NB For backward compatibility, the Grid is optional
    - EntryMixin method updateValuesFromDigits, called by Cell digits update
    - Cell method updateDigitsFromEntry, called by Entry values update
- Add UndoStack for use during backtracking
    - Cell, Clue/Entry/Variable invoke UndoStack for digit and value changes
- Puzzle knightTours computes possible tours
- PrimeKnight backtracks for each tour, finding sequence of tour primes
