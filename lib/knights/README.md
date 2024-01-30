# Knights Puzzle Solver

## Puzzle

Knights Still on the Move by Chalicea

Six knights labelled 1 to 6 each start on a perimeter square and make five knight�s moves, marking  the start point and  wherever they land with their own number. No move ever lands on an occupied square and so the six knights between them fill the entire grid. Not all entries are clued but all are distinct.

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
14	$prime $reverse #Fibonacci
16	$prime $reverse #Fibonacci
18	$multiple A21
20	
21	$prime $reverse A14
Down
1	#triangular
2	$multiple D3
3	$multiple D13
5	$multiple A14
6	
8	#Fibonacci
11	#prime
12	
13	#square
15	#prime
17	#square
19	#prime
```

## Solution

The puzzle produces a partial solution, with clue values including the illegal digit 0.

The Knight solution is manual.

```
A1	23
A4	542
A7	62
A8	315
A9	325
A10	42
A11	6562
A14	31
A16	43
A18	546
A20	1646
A21	13
D1	253
D2	3625
D3	125
D5	4123
D6	254
D8	34
D11	641
D12	614
D13	25
D15	163
D17	36
D19	41

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

