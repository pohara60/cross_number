# SevenRules Puzzle Solver

## Puzzle

7 Rules by Zag

All entries have a digit sum that is divisible by 7. No entry starts with zero and there are no duplicate entries.

```+--+--+--+--+--+
|1 :  |2 :3 :  |
+::+--+::+::+--+
|4 :5 :  |  |6 |
+::+::+--+::+::+
|  |  |7 :  :  |
+--+::+::+--+::+
|8 :  :  |9 :  |
+--+--+--+--+--+


Across
1	#prime
2	#palindrome
4	#descending
7	#ascending
8	#palindrome
9	#sumtwootherentry
Down
1	$prime $jumble D6
2	#square
3	
5	D3 + #prime
6	#prime
7	#square
```

## Solution

```A1, #prime, values={43}
A2, #palindrome, values={232}
A4, #descending, values={975}
A7, #ascending, values={124}
A8, #palindrome, values={696}
A9, #sumtwootherentry, values={59}
D1, $prime $jumble D6, values={491}
D2, #square, values={25}
D3, , values={392}
D5, D3 + #prime, values={759}
D6, #prime, values={149}
D7, #square, values={16}
+--+--+--+--+--+
| 4  3| 2  3  2|
+   --+      --+
| 9  7  5| 9| 1|
+      --+  +  +
| 1| 5| 1  2  4|
+--+  +   --+  +
| 6  9  6| 5  9|
+--+--+--+--+--+
```

## Lessons Learned

Add SeverRules puzzle
- Add generator sumtwootherentry
