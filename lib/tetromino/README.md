# Tetromino Puzzle Solver

## Puzzle

Tetromino Tiling by Nod   

There are seven one-sided tetrominoes that may be translated and rotated but not reflected. These seven tetrominoes have been used to tile the 6x5 rectangular grid leaving two holes. Each tetromino contains the same digit in each of its 4 cells and the two holes each contain a zero. Clues are given in ascending order of their answers and are only numbered for convenience. Bars show where entries go but tetrominoes may cross them. Letters in the clues represent distinct prime numbers less than 100. No entry starts with zero, all entries are distinct and normal rules of algebra apply.  

```+--+--+--+--+--+--+
|1 :2 :3 |4 :5 :6 |
+::+::+::+::+::+::+
|  |7 :  :  |  |  |
+::+--+::+--+::+--+
|8 :9 :  |10:  :11|
+--+::+--+::+--+::+
|12|  |13:  :14|  |
+::+::+::+::+::+::+
|15:  :  |16:  :  |
+--+--+--+--+--+--+


Across
A1	EF
A2	JK+(G-I)/D
A3	A(G-I+J)
A4	A(C-I)-B
A5	D(B+C+E+J)
A6	GJ+I
A7	FHJL
A8	A+GL+K
Down
D9	FH
D10	A+K
D11	AH
D12	D^FF^D
D13	A(D+H)
D14	C+FH
D15	BDF
D16	D^H–AH
D17	KL–E/E
D18	DI+EJ
D19	(A–J)^H–BL
D20	BI+CF
```

## Solution

```Clues
Clue A1 =  118 (Entry A4)
Clue A2 =  227 (Entry A16)
Clue A3 =  407 (Entry A13)
Clue A4 =  487 (Entry A10)
Clue A5 =  522 (Entry A15)
Clue A6 =  554 (Entry A8)
Clue A7 =  910 (Entry A7)
Clue A8 =  991 (Entry A1)
Clue D9 =  10 (Entry D4)
Clue D10 =  42 (Entry D13)
Clue D11 =  55 (Entry D12)
Clue D12 =  72 (Entry D14)
Clue D13 =  88 (Entry D6)
Clue D14 =  99 (Entry D2)
Clue D15 =  114 (Entry D3)
Clue D16 =  188 (Entry D5)
Clue D17 =  402 (Entry D10)
Clue D18 =  542 (Entry D9)
Clue D19 =  777 (Entry D11)
Clue D20 =  995 (Entry D1)
Entries
Entry A1 =  991 (Clue A8)
Entry D1 =  995 (Clue D20)
Entry D2 =  99 (Clue D14)
Entry D3 =  114 (Clue D15)
Entry A4 =  118 (Clue A1)
Entry D4 =  10 (Clue D9)
Entry D5 =  188 (Clue D16)
Entry D6 =  88 (Clue D13)
Entry A7 =  910 (Clue A7)
Entry A8 =  554 (Clue A6)
Entry D9 =  542 (Clue D18)
Entry A10 =  487 (Clue A4)
Entry D10 =  402 (Clue D17)
Entry D11 =  777 (Clue D19)
Entry D12 =  55 (Clue D11)
Entry A13 =  407 (Clue A3)
Entry D13 =  42 (Clue D10)
Entry D14 =  72 (Clue D12)
Entry A15 =  522 (Clue A5)
Entry A16 =  227 (Clue A2)
Variables
A=11
B=19
C=89
D=3
E=59
F=2
G=73
H=5
I=43
J=7
K=31
L=13
Tetromino Tiling:
224446
224 66
557763
577 33
511113
+--+--+--+--+--+--+
| 9  9  1| 1  1  8|
+        +        +
| 9| 9  1  0| 8| 8|
+  +--+   --+  +--+
| 5  5  4| 4  8  7|
+--+   --+   --+  +
| 5| 4| 4  0  7| 7|
+  +  +        +  +
| 5  2  2| 2  2  7|
+--+--+--+--+--+--+
```

## Lessons Learned

Add Tetromino Puzzle
- Add Tetromino tiling logic to Grid
- Puzzle.iterateVariables() was missing call checkSolution()
- TetrominoPuzzle.checkSolution() backtracks over tetromino 
  tiling and mapping of clues to entries 