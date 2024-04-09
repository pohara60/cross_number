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

```
```

## Lessons Learned

Add PrimeKnight puzzle, with constraints on cells in knights tour.
- Requires mapping of entries to grid cells (TODO)