# TwentyFive Puzzle Solver

## Puzzle

Twentyfive by Czecker

There are 25 different pairs (x, y) with x an even digit and y an odd digit.  Each of the 25 pairs fills one of the matching cells of the two grids, one in each grid.  The five digits in one 1dn may or may not include any or all of the digits in the other 1dn.  In 5ac, it may be relevant that abcba is a jumble of bacab. All entries are distinct, and none starts with zero.

```+--+--+--+--+--+
|1 :2 :  :3 :4 |
+::+::+--+::+::+
|5 :  :6 :  :  |
+::+--+::+::+--+
|7 :8 :  |9 :10|
+::+::+::+::+::+
|  |11:  :  |  |
+::+::+::+::+::+
|12:  |13:  :  |
+--+--+--+--+--+


Across
1	$Multiple LA12
5	$Jumble #palindrome
7	#Triangular
9	$Power #prime
11	$Multiple RA9
12	#Square
13	#Cube
Down
1	#different
2	#Sum2Fibonacci
3	$Multiple RD10
4	$divisor LA5
6	$Multiple  9
8	#Square
10	#Square
```

## Solution

```
SOLUTION-----------------------------
Left Puzzle Summary
A1, $Multiple A12, values={42039}
A5, $Jumble #palindrome, values={91179}
A7, #Triangular, values={136}
A9, $Power #prime, values={25}
A11, $Multiple A9, values={608}
A12, #Square, values={81}
A13, #Cube, values={216}
D1, #different, values={49138}
D2, #Sum2Fibonacci, values={21}
D3, $Multiple D10, values={37281}
D4, $divisor A5, values={99}
D6, $Multiple 9, values={1602}
D8, #Square, values={361}
D10, #Square, values={576}
+--+--+--+--+--+
| 4  2  0  3  9|
+      --      +
| 9  1  1  7  9|
+   --+      --+
| 1  3  6| 2  5|
+        +     +
| 3| 6  0  8| 7|
+  +        +  +
| 8  1| 2  1  6|
+--+--+--+--+--+
SOLUTION-----------------------------
Right Puzzle Summary
A1, $Multiple A12, values={59544}
A5, $Jumble #palindrome, values={80840}
A7, #Triangular, values={465}
A9, $Power #prime, values={32}
A11, $Multiple A9, values={775}
A12, #Square, values={36}
A13, #Cube, values={729}
D1, #different, values={58403}
D2, #Sum2Fibonacci, values={90}
D3, $Multiple D10, values={44352}
D4, $divisor A5, values={40}
D6, $Multiple 9, values={8577}
D8, #Square, values={676}
D10, #Square, values={289}
+--+--+--+--+--+
| 5  9  5  4  4|
+      --      +
| 8  0  8  4  0|
+   --+      --+
| 4  6  5| 3  2|
+        +     +
| 0| 7  7  5| 8|
+  +        +  +
| 3  6| 7  2  9|
+--+--+--+--+--+
```

## Lessons Learned

Add TwentyFive puzzle with two grids
Implement mechanism for puzzle clue to refer to clues in another puzzle
Update other puzzles for API change
Improve divisors function, including allowing min/max for function
Add different digits and sum fibonnacci generators
Fix bug in palindrome generation
Implement improved Pairs logic