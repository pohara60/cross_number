# TriangularPairs Puzzle Solver

## Puzzle

Symmetric #triangular Pairs by Oyler

Three-digit entries paired with their symmetric counterparts may be concatenated to form a six-digit triangular number. Solvers must determine which entry comes first. All 2-digit entries are the nine valid remaining triangular numbers two of which, 7ac and 11ac, are entered reversed. There are no zeros in the grid and entries are distinct.

```+--+--+--+--+--+--+
|1 :2 |3 |4 :  :5 |
+::+::+::+::+--+::+
|  |6 :  :  |7 :  |
+--+::+--+::+--+::+
|8 |  |9 :  |10|  |
+::+--+::+--+::+--+
|11:  |12:13:  |14|
+::+--+::+::+::+::+
|15:  :  |  |16:  |
+--+--+--+--+--+--+


Across
1	#triangular
4	
6	#triangular
7	$reverse #triangular
9	#triangular
11	$reverse #triangular
12	#cube
15	#square
16	#triangular
Down
1	#triangular
2	
3	#triangular
4	
5	#palindrome
8	$reverse A12
9	#square
10	
13	#triangular
14	#triangular
```

## Solution

```Puzzle Summary
A1, #triangular, values={28}
A4, , values={941}
A6, #triangular, values={153}
A7, $reverse #triangular, values={87}
A9, #triangular, values={55}
A11, $reverse #triangular, values={12,19}
A12, #cube, values={216}
A15, #square, values={289}
A16, #triangular, values={66}
D1, #triangular, values={21}
D2, , values={815}
D3, #triangular, values={45}
D4, , values={935}
D5, #palindrome, values={171}
D8, $reverse A12, values={612}
D9, #square, values={529}
D10, , values={266}
D13, #triangular, values={15}
D14, #triangular, values={36}
+--+--+--+--+--+--+
| 2  8| 4| 9  4  1|
+     +  +   --   +
| 1| 1  5  3| 8  7|
+--+   --+  +--   +
| 6| 5| 5  5| 2| 1|
+  +--+   --+  +--+
| 1  ?| 2  1  6| 3|
+   --+        +  +
| 2  8  9| 5| 6  6|
+--+--+--+--+--+--+
```

## Lessons Learned

Add TriangularPairs puzzle:
- 3 digit entries are combined in pairs to make 6 digit triangular numbers
- 2 digit entries are distinct 2 digit triangular numbers, but two of them are reversed so cannot rely on normal distinct value logic