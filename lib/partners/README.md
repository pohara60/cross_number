# Partners Puzzle Solver

## Introduction

Partners in Prime by Zag				
				
Symmetrically opposite pairs of answers add to a prime number.				

```
	+--+--+--+--+			
	|1 |2 :3 :  |			
	+::+::+::+--+			
	|4 :  |5 :6 |			
	+::+--+--+::+			
	|7 :8 |9 :  |			
	+--+::+::+::+			
	|10:  :  |  |			
	+--+--+--+--+			
				
	Across		
A2	reverse(A10)	            3	
A4	sum(entered digits) – A7	2	
A5	greater than A9	            2	
A7		    2	
A9		    2	
A10	odd	    3	
	Down		
D1	square	3	
D2	square	2	
D3	square	2	
D6	square	3	
D8	square	2	
D9	square	2	
```

## Lessons Learned

Clues A9 and A10 require inverse expressions to A5 and A2, respectively. The circular reference is resolved by generating possible values from the valid digits.

Sum Entered Digits is a generator that can be evaluated when most of the grid is solved.

The condition "Symmetrically opposite pairs of answers add to a prime number" is implemented as hard coded logis in the (puzzle specific) clue expression validator function.

## Solution Path

```
A2 reverse of generated values for A10
A5 greater than generated values for A9
A10 odd reverse of A2

D clues square
A7 integer values limited by digits
A9 limited by digits
A10 limited by digits and prime constraint
D2 limited by digits
D8 limited by digits
D9 limited by digits
A2 from A10
A7 limited by digits

PARTIAL SOLUTION-----------------------------
Puzzle Summary
A2, $reverse A10, values={142,146}
A4, #sumdigits - A7, values={26}
A5, $greaterthan A9, values={95}
A7, #integer, values={56}
A9, $lessthan A5, values={87}
A10, $odd $reverse A2, values={241,641}
D1, #square, values={625}
D2, #square, values={16}
D3, #square, values={49}
D6, #square, values={576}
D8, #square, values={64}
D9, #square, values={81}
+--+--+--+--+
| 6| 1  4  ?|
+  +      --+
| 2  6| 9  5|
+   --+--+  +
| 5  6| 8  7|
+--+  +     +
| ?  4  1| 6|
+--+--+--+--+
ITERATE SOLUTIONS-----------------------------
+--+--+--+--+
| 6| 1  4  2|
+  +      --+
| 2  6| 9  5|
+   --+--+  +
| 5  6| 8  7|
+--+  +     +
| 2  4  1| 6|
+--+--+--+--+

+--+--+--+--+
| 6| 1  4  6|
+  +      --+
| 2  6| 9  5|
+   --+--+  +
| 5  6| 8  7|
+--+  +     +
| 6  4  1| 6|
+--+--+--+--+
Solution count=2
```