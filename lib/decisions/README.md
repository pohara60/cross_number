# Decisions Puzzle Solver

## Puzzle

Decisions by Oyler

In each row and column, one answer is entered normally whilst the other is entered in reverse. No answer or entry starts with zero and all entries are distinct.

```+--+--+--+--+--+--+
|1 :2 :  |3 :4 |5 |
+::+::+--+::+::+::+
|6 :  :7 :  |8 :  |
+::+--+::+::+::+::+
|9 :10:  |11:  :  |
+--+::+--+--+::+--+
|12:  :13|14:  :15|
+::+::+::+::+--+::+
|16:  |17:  :18:  |
+::+::+::+--+::+::+
|  |19:  |20:  :  |
+--+--+--+--+--+--+


Across
1	#square
3	#prime
6	#Fibonacci
8	#Catalan
9	#prime
11	#prime
12	#triangular
14	#square
16	#cube
17	#cube
19	#perfect
20	#square
Down
1	#prime
2	#triangular
3	#triangular
4	#perfect number
5	#square
7	#cube
10	#Lucas
12	#Lucas
13	#square
14	#prime
15	#triangular
18	#square
```

## Solution

```A1, #square, values={484}
A3, #prime, values={38}
A6, #Fibonacci, values={6765}
A8, #Catalan, values={24}
A9, #prime, values={754}
A11, #prime, values={211}
A12, #triangular, values={276}
A14, #square, values={982}
A16, #cube, values={27}
A17, #cube, values={5733}
A19, #perfect, values={82}
A20, #palindrome, values={161}
D1, #prime, values={467}
D2, #triangular, values={87}
D3, #triangular, values={352}
D4, #perfect, values={8218}
D5, #square, values={441}
D7, #cube, values={64}
D10, #Lucas, values={5778}
D12, #Lucas, values={223}
D13, #square, values={652}
D14, #prime, values={97}
D15, #triangular, values={231}
D18, #square, values={36}
+--+--+--+--+--+--+
| 4  8  4| 3  8| 4|
+      --+     +  +
| 6  7  6  5| 2  4|
+   --+     +     +
| 7  5  4| 2  1  1|
+--+   --+--+   --+
| 2  7  6| 9  8  2|
+        +   --+  +
| 2  7| 5  7  3  3|
+     +   --+     +
| 3| 8  2| 1  6  1|
+--+--+--+--+--+--+
```

## Lessons Learned

Add Decisions puzzle
- Add genenerator perfect
- Clue records possibleValues and reversedValues for checkSolution()
- solveDecisionsClue() saves possibleValues and reversedValues for clue
- Puzzle.checkSolution() checks for one possibleValue and one reversedValue in each row/col
