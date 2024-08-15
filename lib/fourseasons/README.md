# FourSeasons Puzzle Solver

## Puzzle

Four Seasons by Czecker

Any two entries that intersect in a cell in the 
NW quadrant of the grid have an HCF of 4. 
NE quadrant of the grid have an HCF of 9. 
SW quadrant of the grid have an HCF of 7. 
SE quadrant of the grid have an HCF of 5.

```+--+--+--+--+--+--+
|1 :2 :3 :4 |5 :6 |
+::+::+::+::+::+::+
|7 :  :  |8 :  :  |
+--+::+::+--+::+::+
|9 :  |10:11:  :  |
+::+--+::+::+--+::+
|12:13:  :  |14:  |
+::+::+--+::+::+--+
|15:  :16|17:  :18|
+::+::+::+::+::+::+
|19:  |20:  :  :  |
+--+--+--+--+--+--+


Across
1	
5	
7	#triangular
8	#palindrome
9	
10	
12	
14	
15	#palindrome
17	
19	
20	
Down
1	
2	
3	
4	
5	
6	
9	
11	
13	
14	#square
16	
18
```

## Solution

```Puzzle Summary
A1, , values={8172}
A5, , values={99}
A7, #triangular, values={820}
A8, #palindrome, values={747}
A9, , values={68}
A10, , values={2556}
A12, , values={4585}
A14, , values={95}
A15, #palindrome, values={959}
A17, , values={305}
A19, , values={63}
A20, , values={1505}
D1, , values={88}
D2, , values={128}
D3, , values={7028}
D4, , values={27}
D5, , values={945}
D6, , values={9765}
D9, , values={6496}
D11, , values={5535}
D13, , values={553}
D14, #square, values={900}
D16, , values={91}
D18, , values={55}
+--+--+--+--+--+--+
| 8  1  7  2| 9  9|
+           +     +
| 8  2  0| 7  4  7|
+--+     +--+     +
| 6  8| 2  5  5  6|
+   --+      --+  +
| 4  5  8  5| 9  5|
+      --+  +   --+
| 9  5  9| 3  0  5|
+        +        +
| 6  3| 1  5  0  5|
+--+--+--+--+--+--+
```

## Lessons Learned

Add FourSeasns puzzle:
- Moved code from Factors puzzle to GCF module
