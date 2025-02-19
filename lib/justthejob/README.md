# JustTheJob Puzzle Solver

## Puzzle

Listener Crossword No 4855 Just The Job by Hedgehog

The clues are normal algebraic expressions for the grid entries, using letters for the digits 0 to 9, each digit being represented by two letters. After filling the grid, solvers must replace the digits in three columns with letters from their equivalences to reveal what must be highlighted (30 cells) in the other columns. All answers are distinct and there are no leading zeros.

```+--+--+--+--+--+--+--+--+--+
+1 :2 :3 :  |4 :  :5 |6 :7 +
+::+::+::+--+::+--+::+::+::+
+8 :  |  |9 :  |10|11:  |  +
+--+::+::+::+--+::+::+--+::+
+12:  :  :  :13|14:  :  :  +
+--+::+::+::+::+::+--+--+::+
+15:  :  |16:  :  |17:18:  +
+::+--+--+::+::+::+::+::+--+
+19:  :20:  |21:  :  :  :  +
+::+--+::+::+--+::+::+::+--+
+  |22:  |  |23:  |  |24:25+
+::+::+::+--+::+--+::+::+::+
+26:  |27:  :  |28:  :  :  +
+--+--+--+--+--+--+--+--+--+


Across
1	(BR+A)(N-DN+EW)
4	I(NF-A+NT)
6	BE+GIN
8	M+AITAI
9	COOT
11	BA+NG
12	SLEEP+IN+G+RO+UG-H
14	(DIR+T)(C-H)E(A+P)
15	BA(RR+E-D)
16	F(ER+M-E+NT)
17	DI(VE+S)
19	(W+H+I+P)CORD
21	(RESPO+NS+I+B-L)E
22	WO+N
23	PANT
24	BRA-T
26	FUN
27	SPI-T
28	(U+(ND+A)(U-N)(T-E))D
Down
1	HE-AT
2	P(I+N)(PO+I+N)+T+I-N+G
3	(PR+O)(GRE+SS)
4	B+E-T
5	BEAR+H-U-G
6	COCO+NUT
7	(I+N+ST)EAD
9	DRIVER+LESS-VEHI+C-LE
10	(DECA+T)(HLO-N)S
13	I+(N+T+E)NTS
15	IN(CONC+E-RT)
17	C(O-H)EREN+CI+E-S
18	S(E+A)((R+C+H)(L+I+G-H)+T)
20	(FE-N)(D+I+N+G)
22	APA-R-T
23	BE+A+R+D
25	HOTRO+D
```

## Solution

```A1, (BR+A)(N-DN+EW), values={1222}
A4, I(NF-A+NT), values={188}
A6, BE+GIN, values={81}
A8, M+AITAI, values={64}
A9, COOT, values={27}
A11, BA+NG, values={18}
A12, SLEEP+IN+G+RO+UG-H, values={36329}
A14, (DIR+T)(C-H)E(A+P), values={8181}
A15, BA(RR+E-D), values={522}
A16, F(ER+M-E+NT), values={258}
A17, DI(VE+S), values={880}
A19, (W+H+I+P)CORD, values={4275}
A21, (RESPO+NS+I+B-L)E, values={68589}
A22, WO+N, values={25}
A23, PANT, values={98}
A24, BRA-T, values={89}
A26, FUN, values={42}
A27, SPI-T, values={223}
A28, (U+(ND+A)(U-N)(T-E))D, values={8885}
D1, HE-AT, values={16}
D2, P(I+N)(PO+I+N)+T+I-N+G, values={2462}
D3, (PR+O)(GRE+SS), values={2432}
D4, B+E-T, values={17}
D5, BEAR+H-U-G, values={811}
D6, COCO+NUT, values={88}
D7, (I+N+ST)EAD, values={1710}
D9, DIRVER+LESS-VEHI+C-LE, values={22251}
D10, (DECA+T)(HLO-N)S, values={88888}
D13, I+(N+T+E)NTS, values={956}
D15, IN(CONC+E-RT), values={5404}
D17, C(O-H)EREN+CI+E-S, values={8518}
D18, S(E+A)((R+C+H)(L+I+G-H)+T), values={8888}
D20, (FE-N)(D+I+N+G), values={752}
D22, APA-R-T, values={22}
D23, BE+A+R+D, values={93}
D25, HOTRO+D, values={95}
+--+--+--+--+--+--+--+--+--+
| 1  2  2  2| 1  8  8| 8  1|
+         --+   --   +     +
| 6  4| 4| 2  7| 8| 1  8| 7|
+--+  +  +   --+  +   --+  +
| 3  6  3  2  9| 8  1  8  1|
+--            +   --+--   +
| 5  2  2| 2  5  8| 8  8  0|
+   --+--+        +      --+
| 4  2  7  5| 6  8  5  8  9|
+   --      +--+         --+
| 0| 2  5| 1| 9  8| 1| 8  9|
+  +     +--+   --+  +     +
| 4  2| 2  2  3| 8  8  8  5|
+--+--+--+--+--+--+--+--+--+
Variables:
A={2}
B={9}
C={3}
D={5}
E={9}
F={6}
G={0}
H={2}
I={4}
L={8}
M={0}
N={7}
O={3}
P={7}
R={5}
S={8}
T={1}
U={1}
V={4}
W={6}
```

## Lessons Learned

Add JustTheJob puzzle
- Each variable value appears twice
  - VariableList accepts distinctValueLimit
  - updateVariables() applies distinctValueLimit
  - Add getDistinctValueCount() and getDuplicateLimit()
  - VariablePuzzle.initVariablePuzzle allows caller to pass the variable list
  - Add cartesianDuplicateLimit()
  - Puzzle.solveExpressionEvaluator accepts duplicateLimit argument
  - Puzzle.iterateVariables applies duplicateLimit
- Add class JustTheJobTest that solves with variable backtracking
- This solver takes 15 minutes
- Add override Clue.valuesNoUndo to correctly set min/max
