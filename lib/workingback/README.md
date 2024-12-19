# WorkingBack Puzzle Solver

## Puzzle

Working Back by Oyler

When bars are removed the three 4-digit numbers in the highlighted cells are of the same type. Solvers must use them to find three distinct positive integers such that when taken pairwise their sum equals those 4-digit numbers. Those integers a, b and c along with their sum should be written below the grid in ascending order. No entry starts with zero and all entries are distinct.

```+--+--+--+--+--+--+
|1 :  :2 |3 :4 :5 |
+::+--+::+::+::+::+
|  |6 :  :  |7 :  |
+--+--+::+--+::+::+
|8 |9 :  |10:  |  |
+::+::+--+::+--+--+
|11:  |12:  :  |13|
+::+::+::+::+--+::+
|14:  :  |15:  :  |
+--+--+--+--+--+--+


Across
1	$divisor A3
3	#palindrome
6	$multiple A10
7	#triangular
9	#triangular
10	#triangular
11	#triangular
12	A7 * D12
14	A12 - D12
15	D4 - D9
Down
1	#fibonacci
2	$multiple A9
3	#triangular
4	$reverse D9
5	D4 - D10
8	#triangular
9	
10	#palindrome
12	
13	#cube
```

## Solution

```A1, $divisor A3, values={121}
A3, #palindrome, values={242}
A6, $multiple A10, values={168}
A7, #triangular, values={10}
A9, #triangular, values={15}
A10, #triangular, values={21}
A11, #triangular, values={91}
A12, A7 * D12, values={600}
A14, A12 - D12, values={540}
A15, D4 - $reverse D4, values={297}
D1, #fibonacci, values={13}
D2, $multiple A9, values={165}
D3, #triangular, values={28}
D4, $reverse D9, values={411}
D5, D4 - D10, values={209}
D8, #triangular, values={595}
D9, , values={114}
D10, #palindrome, values={202}
D12, , values={60}
D13, #cube, values={27}
+--+--+--+--+--+--+
| 1  2  1| 2  4  2|
+   --   +        +
| 3| 1  6  8| 1  0|
+--+--    --+     +
| 5| 1  5| 2  1| 9|
+  +   --+   --+--+
| 9  1| 6  0  0| 2|
+     +      --+  +
| 5  4  0| 2  9  7|
+--+--+--+--+--+--+
a=880, b=801, c=720, a+b+c=2401
```

## Lessons Learned

Add WorkingBack puzzle
- Puzzle.solveRelatedClues copied from Virus puzzle and improved
- Puzzle.toSummary overridden to print enhanced solution summary after iteration