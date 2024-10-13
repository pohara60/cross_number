# WorkingBack2 Puzzle Solver

## Puzzle

Working Back II by Oyler

When bars are removed the three 4 -digit numbers in the highlighted cells are of the same type. Solvers must use them to find three distinct positive integers such that when taken pairwise their sum equals those 4 -digit numbers. Those integers a, b and c along with their sum should be written below the grid in ascending order. No entry starts with zero and all entries are distinct.

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
1	A12 - D10
3	$ds A7 = $ds #result
6	$multiple D13
7	D5 - D3
9	#square
10	#Fibonacci
11	D12 - D1
12	#prime
14	A15 - A6
15	#prime
Down
1	$squareroot A1
2	#palindrome
3	$reverse D1
4	$multiple A10
5	$factor D2
8	#palindrome
9	#square
10	$multiple D5
12	#Lucas
13	$reverse D12
```

## Solution

```A1, A12 - D10, values={196}
A3, $ds A7 = $ds #result, values={411}
A6, $multiple D13, values={201}
A7, D5 - D3, values={60}
A9, #square, values={36}
A10, #Fibonacci, values={55}
A11, D12 - D1, values={62}
A12, #prime, values={701}
A14, A15 - A6, values={346}
A15, #prime, values={547}
D1, $squareroot A1, values={14}
D2, #palindrome, values={606}
D3, $reverse D1, values={41}
D4, $multiple A10, values={165}
D5, $factor D2, values={101}
D8, #palindrome, values={363}
D9, #square, values={324}
D10, $multiple D5, values={505}
D12, #Lucas, values={76}
D13, $reverse D12, values={67}
+--+--+--+--+--+--+
| 1  9  6| 4  1  1|
+   --   +        +
| 4| 2  0  1| 6  0|
+--+--    --+     +
| 3| 3  6| 5  5| 1|
+  +   --+   --+--+
| 6  2| 7  0  1| 6|
+     +      --+  +
| 3  4  6| 5  4  7|
+--+--+--+--+--+--+
a=531, b=1485, c=2170, a+b+c=4186
```

## Lessons Learned

Add WorkingBack2 puzzle
- Same approach as WorkingBack puzzle
- No enhancements
