# NeedleMatch Puzzle Solver

## Puzzle

A Needle Match by Hedgehog

The grid includes the scorecard of an 18 -hole golf match between Hedgehog and Porcupine. Each grid entry represents one hole and amongst its digits contains exactly two of the digits between 3 and 7 inclusive which represents the scores of the two players on each hole with Hedgehog first. (There are no holes -in-one or twos to report). A hole is won by the player with the lower score, irrespective of t he difference in scores; otherwise, the hole is halved. Solvers should determine the winner of the match. All entries are distinct  and there are no leading zeros.

```+--+--+--+--+--+--+--+
|1 :  :2 |3 :  :4 :5 |
+::+--+::+::+--+::+::+
|6 :7 :  |  |8 :  :  |
+--+::+::+::+::+::+::+
|9 |10:  :  :  :  |  |
+::+::+::+::+::+::+--+
|11:  :  |  |12:  :13|
+::+::+--+::+::+--+::+
|14:  :  :  |15:  :  |
+--+--+--+--+--+--+--+


Across
1	#square
3	#triangular
6	#square
8	#odd
10	#cube
11	difference two entries
12	#prime
14	#square
15	factor another entry
Down
1	#square
2	#triangular
3	#cube
4	#prime
5	#triangular
7	#Fibonacci
8	#square
9	#square
13	#prime
```

## Solution

```A1, #square, values={361}
A3, #triangular, values={2415}
A6, #square, values={625}
A8, #odd, values={559}
A10, #cube, values={59319}
A11, #difftwootherentry, values={486}
A12, #prime, values={877}
A14, #square, values={4489}
A15, #factorotherentry, values={483}
D1, #square, values={36}
D2, #triangular, values={1596}
D3, #cube, values={24389}
D4, #prime, values={1597}
D5, #triangular, values={595}
D7, #Fibonacci, values={2584}
D8, #square, values={5184}
D9, #square, values={144}
D13, #prime, values={73}
+--+--+--+--+--+--+--+
| 3  6  1| 2  4  1  5|
+   --   +   --      +
| 6  2  5| 4| 5  5  9|
+--+     +  +        +
| 1| 5  9  3  1  9| 5|
+  +              +--+
| 4  8  6| 8| 8  7  7|
+      --+  +   --+  +
| 4  4  8  9| 4  8  3|
+--+--+--+--+--+--+--+
```

## Lessons Learned

Add NeedleMatch puzzle
- Add Puzzle generators factorOtherEntry, diffTwoOtherEntry
- Add missing Generator.order
