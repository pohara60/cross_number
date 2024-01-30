# Columns Puzzle Solver

## Puzzle

It�s All About Columns by MatriX

No entry starts with zero and all entries are distinct. The completed grid has the property that the column entries and any unchecked digits in a column are somehow connected. Can you find the connection?

```
+--+--+--+--+--+
|1 :  :2 |3 :4 |
+::+--+::+::+::+
|5 :6 |7 :  :  |
+::+::+--+::+::+
|8 :  :9 |10:  |
+::+::+::+--+::+
|11:  |12:  :  |
+--+--+--+--+--+

Across
1	$palindrome $lessthan A12
3	#triangular - A1
5	#Harshad
7	$ascending #result % $ds #result = 0
8	$descending $multiple A10
10	$reverse $dp A5
11	$adjacentprime A10
12	A8 - #triangular
Down
1	#product4primes
2	$divisor A5
3	#triangular - D6
4	#product4primes
6	$multiple A3
9	$divisor D2
```

## Solution

```
+--+--+--+--+--+
| 4  2  4| 1  1|
+   --   +     +
| 8  4| 2  3  4|
+     +--+     +
| 6  2  1| 2  3|
+        +--+  +
| 2  9| 4  5  0|
+--+--+--+--+--+
```

## Lessons Learned

