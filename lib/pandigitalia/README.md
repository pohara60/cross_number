# Pandigitalia Puzzle Solver

## Puzzle

Pandigitalia by Zag

This puzzle consists of six 2-digit, six 3-digit and six 4-digit entries. These can be divided into six pandigital sets each with a 2-, 3- and 4-digit entry between them containing the digits 1-9. Furthermore, the 18 digits of the six 3-digit entries contain two each of the digits 1-9. The 2-digit member of a set intersects the 4-digit entry symmetrically opposite the 4-digit member of its own pandigital set. For example, 3dn intersects 2ac so 14ac and 3dn belong to the same pandigital set. Entries are distinct.

```+--+--+--+--+--+--+
|1 :  |2 :  :  :3 |
+::+--+::+--+--+::+
|  |4 :  :  |5 |  |
+::+::+::+--+::+--+
|6 :  |7 :  :  |8 |
+::+::+--+--+::+::+
|  |9 :  :10|11:  |
+--+::+--+::+::+::+
|12|  |13:  :  |  |
+::+--+--+::+--+::+
|14:  :  :  |15:  |
+--+--+--+--+--+--+


Across
1	#prime
2	#prime
4	#square
6	
7	#triangular
9	#triangular
11	$multiple A6
13	#prime
14	#prime
15	#prime
Down
1	#prime
2	#square
3	A1- #square
4	#prime
5	#prime
8	#prime
10	#square
12	A15- #square
```

## Solution

```A1, #prime, values={83}
A2, #prime, values={6143}
A4, #square, values={729}
A6, , values={26}
A7, #triangular, values={561}
A9, #triangular, values={378}
A11, $multiple A6, values={52}
A13, #prime, values={349}
A14, #prime, values={8971}
A15, #prime, values={67}
D1, #prime, values={8521}
D2, #square, values={625}
D3, A1 - #square, values={34}
D4, #prime, values={7639}
D5, #prime, values={4159}
D8, #prime, values={4297}
D10, #square, values={841}
D12, A15 - #square, values={58}
+--+--+--+--+--+--+
| 8  3| 6  1  4  3|
+   --+   -- --   +
| 5| 7  2  9| 4| 4|
+  +      --+  +--+
| 2  6| 5  6  1| 4|
+     +--+--   +  +
| 1| 3  7  8| 5  2|
+--+   --   +     +
| 5| 9| 3  4  9| 9|
+  +--+--    --+  +
| 8  9  7  1| 6  7|
+--+--+--+--+--+--+
```

## Lessons Learned

Add Pandigitalia puzzle
- some refactoring
- puzzle.checkSolution checks for valid sets
- puzzle.validClue checks for repeated digits in 2/4-digit clues in set
- puzzle.validClue checks for more than 2 repeated digits in all 3-digit clues
- solution relies on (slow) findSolutions() backtracking

