# Gallivanting Puzzle Solver

## Puzzle

Knights Go Gallivanting Again by Chalicea

Each of the six knights collects a different digit from 1 to 6. Their journey must begin in a perimeter cell and make knight’s moves as in chess to collect six of their digit. No cell can be visited more than once and entries are distinct.

```+--+--+--+--+--+--+
|1 :2 |3 :4 |5 :6 |
+::+::+::+::+::+::+
|7 :  :  |8 :  :  |
+::+::+::+--+::+--+
|  |9 :  |10:  :11|
+::+--+::+::+--+::+
|12:13|14:  |15:  |
+::+::+--+::+::+::+
|  |16:17|18:  :  |
+::+--+::+--+::+::+
|19:  |20:  :  |  |
+--+--+--+--+--+--+


Across
1	
3	#prime
5	#square
7	#prime
8	$multiple D6 
9	$multiple A14 AND $reverse A15
10	#palindrome AND $divisor D1
12	$divisor D1 AND $reverse A19
14	#prime
15	#square
16	A19 + D13 = $reverse A1
18	$digits $return #prime = $digits D10
19	$Fibonacci $divisor D3
20	#ascending
Down
1	$allDigits1to6 $number
2	$firstTwoDigitsSumToThird $number
3	#descending
4	#Catalan = $reverse D6
5	$descending #prime
6	$divisor A8
10	#descending
11	#descending
13	$multiple A12
15	$multiple D17
17	$divisor D1
```

## Solution

```A1, , values={54}
A3, #prime, values={61}
A5, #square, values={64}
A7, #prime, values={613}
A8, $multiple D6 , values={451}
A9, $multiple A14 = $reverse A15, values={52}
A10, #palindrome = $divisor D1, values={636}
A12, $divisor D1 = $reverse A19, values={12}
A14, #prime, values={13}
A15, #square, values={25}
A16, A19 + D13 = $reverse A1, values={45}
A18, $digits $prime #result = $digits D10, values={263}
A19, $fibonacci $divisor D3, values={21}
A20, #ascending, values={345}
D1, $allDigits1to6 #integer, values={564132}
D2, $firstTwoDigitsSumToThird #integer, values={415}
D3, #descending, values={6321}
D4, #Catalan = $reverse D6, values={14}
D5, $descending #prime, values={653}
D6, $divisor A8, values={41}
D10, #descending, values={632}
D11, #descending, values={6532}
D13, $multiple A12, values={24}
D15, $multiple D17, values={265}
D17, $divisor D1, values={53}
+--+--+--+--+--+--+
| 5  4| 6  1| 6  4|
+     +     +     +
| 6  1  3| 4  5  1|
+        +--+   --+
| 4| 5  2| 6  3  6|
+  +--+  +   --+  +
| 1  2| 1  3| 2  5|
+     +--+  +     +
| 3| 4  5| 2  6  3|
+  +--+  +--+     +
| 2  1| 3  4  5| 2|
+--+--+--+--+--+--+
```

## Lessons Learned

Add Galivanting puzzle
- Add generator Catalan, generateAscendingConsecutive
- Add monadic digits, fibonacci
- Puzzle adds monadics allDigits1to6 and firstTwoDigitsSumToThird
- Puzzle.checkSolution() calls checkFrequencyAllDigits() to check each digit appears 6 times

