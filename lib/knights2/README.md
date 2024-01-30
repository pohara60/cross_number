# Knights2 Puzzle Solver

## Puzzle

Knights Still on the Move by Chalicea

Six knights labelled 1 to 6 each start on a perimeter #square and make five knight�s moves, marking  the start point and  wherever they land with their own number. No move ever lands on an occupied #square and so the six knights between them fill the entire grid. Not all entries are clued but all are distinct.

```
+--+--+--+--+--+--+
|1 :2 |3 |4 :5 :6 |
+::+::+::+--+::+::+
|  |7 :  |8 :  :  |
+::+::+::+::+::+::+
|9 :  :  |10:  |  |
+--+::+--+--+::+--+
|11:  :12:13|14:15|
+::+--+::+::+--+::+
|16:17|  |18:19:  |
+::+::+::+--+::+::+
|20:  :  :  |21:  |
+--+--+--+--+--+--+

Across
1	#prime
4	
7	$multiple A14
8	
9	#triangular
10	$divisor A18
11	$multiple D8
14	$prime $reverse #fibonacci
16	$prime $reverse #fibonacci
18	$multiple A21
20	
21	$prime $reverse A14
Down
1	#triangular
2	$multiple D3
3	$multiple D13
5	$multiple A14
6	
8	#fibonacci
11	#prime
12	
13	#square
15	#prime
17	#square
19	#prime
```

## Solution

```
Puzzle Summary
A1, #prime, values={23}
A4, , values={542}
A7, $multiple A14, values={62}
A8, , values={315}
A9, #triangular, values={325}
A10, $divisor A18, values={42}
A11, $multiple D8, values={6562}
A14, $prime $reverse #fibonacci, values={31}
A16, $prime $reverse #fibonacci, values={43}
A18, $multiple A21, values={546}
A20, , values={1646}
A21, $prime $reverse A14, values={13}
D1, #triangular, values={253}
D2, $multiple D3, values={3625}
D3, $multiple D13, values={125}
D5, $multiple A14, values={4123}
D6, , values={254}
D8, #fibonacci, values={34}
D11, #prime, values={641}
D12, , values={614}
D13, #square, values={25}
D15, #prime, values={163}
D17, #square, values={36}
D19, #prime, values={41}
+--+--+--+--+--+--+
| 2  3| 1| 5  4  2|
+     +  +--      +
| 5| 6  2| 3  1  5|
+  +     +        +
| 3  2  5| 4  2| 4|
+--+   --+--+  +--+
| 6  5  6  2| 3  1|
+   --+     +--+  +
| 4  3| 1| 5  4  6|
+     +  +--+     +
| 1  6  4  6| 1  3|
+--+--+--+--+--+--+
```

## Lessons Learned

Entry digits are 1..6.
