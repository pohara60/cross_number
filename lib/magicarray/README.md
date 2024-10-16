# MagicArray Puzzle Solver

## Puzzle

5 x 5 Magic Array by Oyler

All entries are distinct and there are no zeros entered in the grid. Once completed solvers must deduce the digit in the central cell such that the final grid possesses a magic property. This property is such that if any five cells are chosen, each from a different row and column, then the digits they contain sum to the same number. The deduced digit should be entered in the central cell.

```+--+--+--+--+--+
|1 :2 :  |3 :  |
+::+::+--+::+--+
|  |4 :  :  |5 |
+--+::+--+::+::+
|6 :  |  |7 :  |
+::+::+--+::+--+
|  |8 :  :  |9 |
+--+::+--+::+::+
|10:  |11:  :  |
+--+--+--+--+--+


Across
1	A3 * A3
3	#triangular
4	( A6 - D9 ) * ( A3 + D9 )
6	#triangular
7	#prime
8	#prime
10	D1 = $DP #result
11	#palindrome
Down
1	#square
2	$multiple (D1 * D1)
3	$multiple (A7 * ( A6 - D1 ))
5	#Fibonacci
6	D5 - #cube
9
```

## Solution

```A1, A3 * A3, values={225}
A3, #triangular, values={15}
A4, ( A6 - D9 ) * ( A3 + D9 ), values={584}
A6, #triangular, values={66}
A7, #prime, values={59}
A8, #prime, values={251}
A10, D1 = $DP #result, values={55}
A11, #palindrome, values={848}
D1, #square, values={25}
D2, $multiple (D1 * D1), values={25625}
D3, $multiple (A7 * ( A6 - D1 )), values={14514}
D5, #Fibonacci, values={89}
D6, D5 - #cube, values={62}
D9, , values={58}
+--+--+--+--+--+
| 2  2  5| 1  5|
+      --+   --+
| 5| 5  8  4| 8|
+--+   --   +  +
| 6  6|  | 5  9|
+     +--+   --+
| 2| 2  5  1| 5|
+--+   --   +  +
| 5  5| 8  4  8|
+--+--+--+--+--+

Sum=25, Middle Digit=9
```

## Lessons Learned

Add MagicArray puzzle
- Add trotter package for Permutations
- Monadic $multiple checks for negative input
- puzzle.traceFindAnswer to trace known answers during iteration
