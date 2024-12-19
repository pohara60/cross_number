# Eraser Puzzle Solver

## Puzzle

5 x 5 by Oyler

Once the grid has been completed, solvers must erase the contents of some cells so that the digits sum to the total given by the letter at the end of the row or bottom of the column. These letters are clued in ascending order after the main clue list. The erased digits must be summed and their total written under the grid. No entry starts with zero and all entries are distinct.

```+--+--+--+--+--+
|1 :  |2 :  :3 |
+::+--+::+--+::+
|4 :5 :  |6 :  |
+::+::+--+::+--+
|  |7 :  :  |8 |
+--+::+--+::+::+
|9 :  |10:  :  |
+::+--+::+--+::+
|11:  :  |12:  |
+--+--+--+--+--+


Across
1	#cube
2	#square
4	#prime
6	#square
7	#triangular
9	#square
10	#cube
11	#cube
12	#cube
Down
1	#triangular
2	#Lucas
3	#square
5	D1 - D8
6	#square
8	#prime
9	#prime
10	#square
```

## Solution

```Erased cells (22=4, 41=2, 40=1, 12=7, 03=4, 43=2, 42=5)
SOLUTION-----------------------------
Puzzle Summary
A1, #cube, values={64}
A2, #square, values={441}
A4, #prime, values={617}
A6, #square, values={36}
A7, #triangular, values={946}
A9, #square, values={49}
A10, #cube, values={216}
A11, #cube, values={125}
A12, #cube, values={27}
D1, #triangular, values={666}
D2, #Lucas, values={47}
D3, #square, values={16}
D5, D1 - D8, values={199}
D6, #square, values={361}
D8, #prime, values={467}
D9, #prime, values={41}
D10, #square, values={25}
+--+--+--+--+--+
| 6  4| 4  4  1|
+   --+   --   +
| 6  1  7| 3  6|
+      --+   --+
| 6| 9  4  6| 4|
+--+   --   +  +
| 4  9| 2  1  6|
+   --+   --+  +
| 1  2  5| 2  7|
+--+--+--+--+--+
Erased cells value 25
```

## Lessons Learned

Add Eraser puzzle
- Iteration callback tries erasing digits
- Add Cell.entryDigit to get digit during iteration