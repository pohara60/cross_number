# DieAnotherDay Puzzle Solver

## Puzzle

The Listener Crossword No 4790 Die Another Day by IOA

Some while ago, I threw a standard die (ie one where each pair of opposite faces has seven spots in total, pictured) and noted the number of spots on the top face, which I entered in the first cell of the Top grid. I also noted the numbers of spots on the front face and on the right-hand face, which I entered in the corresponding cells of the Front and Right grids. I repeated this exercise with the same die 15 more times in order to fill all the grids.
In the clues W, X, Y and Z are different digits from 1 to 6.
W occurs exactly W time(s) in the Top grid. 
X occurs exactly X time(s) in the Top grid.
Y occurs exactly Y time(s) in the Front grid.
Z occurs exactly Z time(s) in the Right grid.

```

Top,Front,Right
+--+--+--+--+,+--+--+--+--+,+--+--+--+--+
+1 :2 :3 :4 :,+1 :2 :3 :4 :,+1 :2 :3 :4 :
+::+::+::+::+,+::+::+::+::+,+::+::+::+::+
+5 :  :  :  :,+5 :  :  :  :,+5 :  :  :  :
+::+::+::+::+,+::+::+::+::+,+::+::+::+::+
+6 :  :  :  :,+6 :  :  :  :,+6 :  :  :  :
+::+::+::+::+,+::+::+::+::+,+::+::+::+::+
+7 :  :  :  :,+7 :  :  :  :,+7 :  :  :  :
+--+--+--+--+,+--+--+--+--+,+--+--+--+--+

Across
T1,A square - Y^2
T6,A multiple of my age
T7,A square
F7,A square
R5,(The square of my age) - W
R7,A square
Down
T1 Some number raised to a power greater than 2
T2,A multiple of X*Y
T3,A multiple of X*Y
F1,A square + W*Y*Z
F3,(The sum of all the digits in all three grids) * X
F4,Some number raised to a power greater than 2
R2,A multiple of (X + Z)
```

## Three puzzles

```
Top             Front           Right
+--+--+--+--+   +--+--+--+--+   +--+--+--+--+
+1 :2 :3 :4 :   +1 :2 :3 :4 :   +1 :2 :3 :4 :
+::+::+::+::+   +::+::+::+::+   +::+::+::+::+
+5 :  :  :  :   +5 :  :  :  :   +5 :  :  :  :
+::+::+::+::+   +::+::+::+::+   +::+::+::+::+
+6 :  :  :  :   +6 :  :  :  :   +6 :  :  :  :
+::+::+::+::+   +::+::+::+::+   +::+::+::+::+
+7 :  :  :  :   +7 :  :  :  :   +7 :  :  :  :
+--+--+--+--+   +--+--+--+--+   +--+--+--+--+

Top 
Across
1	$square - Y^2
6	#multiple A
7	$square
Down
1	$power3
2	#multiple X*Y
3	#multiple X*Y

Front
Across	
7	$square
		
Down	
1	$square + W*Y*Z
3	$sumdigits * X
4	$power3

Right
Across	
5	A^2 - W
7	$square
		
Down	
2	#multiple (X + Z)
```

## Solution

```
Top Puzzle Summary
A1, #square - Y^2, values={6545}
A5, , values={5644}
A6, $multiple A, values={6666}
A7, #square, values={1444}
D1, #power3, values={6561}
D2, $multiple X*Y, values={5664}
D3, $multiple X*Y, values={4464}
D4, , values={5464}
+--+--+--+--+
| ?  ?  ?  ?|
+           +
| ?  ?  ?  ?|
+           +
| ?  ?  ?  ?|
+           +
| 1  4  4  4|
+--+--+--+--+
Variables:
A={66}
W={1}
X={6}
Y={4}
Z={5}
RemainingValues: [1, 2, 3, 4, 5]
Front Puzzle Summary
A1, , values={4413}
A5, , values={6511}
A6, , values={4522}
A7, #square, values={4225}
D1, #square + W*Y*Z, values={4644}
D2, , values={4552}
D3, #sumdigits * X, values={1122}
D4, #power3, values={3125}
+--+--+--+--+
| ?  ?  1  3|
+           +
| ?  ?  ?  1|
+           +
| ?  ?  ?  2|
+           +
| 4  2  2  5|
+--+--+--+--+
Variables:
A={66}
W={1}
X={6}
Y={4}
Z={5}
RemainingValues: [1, 2, 3, 4, 5, 6]

Right Puzzle Summary
A1, , values={5156}
A5, A^2 - W, values={4355}
A6, , values={5344}
A7, #square, values={2116}
D1, , values={5452}
D2, $multiple (X + Z), values={1331}
D3, , values={5541}
D4, , values={6546}
+--+--+--+--+
| ?  ?  ?  ?|
+           +
| ?  ?  ?  ?|
+           +
| ?  ?  ?  ?|
+           +
| 2  1  1  6|
+--+--+--+--+
Variables:
A={66}
W={1}
X={6}
Y={4}
Z={5}

```

## Lessons Learned

