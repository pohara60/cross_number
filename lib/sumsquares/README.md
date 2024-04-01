# SumSquares Puzzle Solver

## Puzzle

A2 + B2 + C2 by Nod

Letters in the clues stand for the first fourteen prime numbers in an order to be determined with the same letter representing the same prime throughout. The clue PQR is evaluated as P2 + Q2 +R2 to give the value of the entry. No entry starts with zero and all entries are distinct. Clues are given in ascending order of their entries , i - xxvii  and must be entered where they fit.

```+--+--+--+--+--+--+--+
|1 :  :2 |3 :4 :5 |6 |
+::+--+::+::+::+::+::+
|7 :  :  :  |8 :  :  |
+::+--+::+::+::+--+::+
|9 :10:  |11:  :12:  |
+::+::+::+--+--+::+--+
|  |  |13:  :14|  |15|
+--+::+--+--+::+::+::+
|16:  :17:18|19:  :  |
+::+--+::+::+::+--+::+
|20:21:  |22:  :  :  |
+::+::+::+::+::+--+::+
|  |23:  :  |24:  :  |
+--+--+--+--+--+--+--+


Clues
i	DIM
ii	AIM
iii	ADN
iv	BIM
v	BDN
vi	DIK
vii	BMN
viii	ABN
ix	BDK
x	DEN
xi	AGI
xii	ADG
xiii	AGM
xiv	BEN
xv	GIN
xvi	ADJ
xvii	GKN
xviii	DIL
xix	ILM
xx	FIN
xxi	AHM
xxii	EHN
xxiii	FLM
xxiv	CIL
xxv	FHN
xxvi	CJL
xxvii	CDH
```

## Solution

```
Puzzle Summary
i, D*D+I*I+M*M, values={38}, entry={38}
ii, A*A+I*I+M*M, values={78}, entry={78}
iii, A*A+D*D+N*N, values={179}, entry={179}
iv, B*B+I*I+M*M, values={198}, entry={198}
v, B*B+D*D+N*N, values={299}, entry={299}
vi, D*D+I*I+K*K, values={302}, entry={302}
vii, B*B+M*M+N*N, values={315}, entry={315}
viii, A*A+B*B+N*N, values={339}, entry={339}
ix, B*B+D*D+K*K, values={467}, entry={467}
x, D*D+E*E+N*N, values={491}, entry={491}
xi, A*A+G*G+I*I, values={582}, entry={582}
xii, A*A+D*D+G*G, values={587}, entry={587}
xiii, A*A+G*G+M*M, values={603}, entry={603}
xiv, B*B+E*E+N*N, values={651}, entry={651}
xv, G*G+I*I+N*N, values={654}, entry={654}
xvi, A*A+D*D+J*J, values={899}, entry={899}
xvii, G*G+K*K+N*N, values={939}, entry={939}
xviii, D*D+I*I+L*L, values={974}, entry={974}
xix, I*I+L*L+M*M, values={990}, entry={990}
xx, F*F+I*I+N*N, values={1494}, entry={1494}
xxi, A*A+H*H+M*M, values={1923}, entry={1923}
xxii, E*E+H*H+N*N, values={2331}, entry={2331}
xxiii, F*F+L*L+M*M, values={2355}, entry={2355}
xxiv, C*C+I*I+L*L, values={2646}, entry={2646}
xxv, F*F+H*H+N*N, values={3339}, entry={3339}
xxvi, C*C+J*J+L*L, values={3483}, entry={3483}
xxvii, C*C+D*D+H*H, values={3539}, entry={3539}
A1, values={302}
D1, values={3339}
D2, values={2355}
A3, values={467}
D3, values={491}
D4, values={654}
D5, values={78}
D6, values={974}
A7, values={3539}
A8, values={587}
A9, values={315}
D10, values={179}
A11, values={1494}
D12, values={990}
A13, values={582}
D14, values={2646}
D15, values={2331}
A16, values={1923}
D16, values={198}
D17, values={299}
D18, values={339}
A19, values={603}
A20, values={939}
D21, values={38}
A22, values={3483}
A23, values={899}
A24, values={651}
+--+--+--+--+--+--+--+
| 3  0  2| 4  6  7| 9|
+   --   +        +  +
| 3  5  3  9| 5  8  7|
+   --      +   --+  +
| 3  1  5| 1  4  9  4|
+        +--+--+   --+
| 9| 7| 5  8  2| 9| 2|
+--+  +--+--   +  +  +
| 1  9  2  3| 6  0  3|
+   --+     +   --+  +
| 9  3  9| 3  4  8  3|
+        +      --   +
| 8| 8  9  9| 6  5  1|
+--+--+--+--+--+--+--+
Variables:
A={7}
B={13}
C={41}
D={3}
E={19}
F={37}
G={23}
H={43}
I={2}
J={29}
K={17}
L={31}
M={5}
N={11}
```

## Lessons Learned

Add SumSquares puzzle
- Allow lowercase roman clue numbers
- Map Clues to Entries support non-Across/Down clues