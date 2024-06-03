# Inbetweeners Puzzle Solver

## Puzzle

Inbetweeners by Nod

Letters used in clues represent the first ten primes in an order to be determined. The grid entry is more than the first value and less than the second value of the two expressions given in its clue. All digits in the completed grid appear an equal number of times.  Normal rules of algebra apply, there are no leading zeros and entries are distinct  prime numbers .

```+--+--+--+--+--+--+--+
|1 :2 :  :3 |4 :  :5 |
+--+::+--+::+::+--+::+
|6 :  :7 |8 :  :9 :  |
+::+::+::+--+::+::+::+
|10:  :  :11|12:  :  |
+::+--+::+::+--+::+--+
|13:  :  |14:  :  :  |
+--+--+--+--+--+--+--+


Across
1	BN^S ABE
4	EI BDS
6	II DINN
8	ADDNNU DDEOS
10	ND^U AESS
12	OS EE
13	DDRU OU
14	EUU BBN
Down
2	DRRR NNRU
3	AS DRR
4	AE BU
5	DDDRR ANR
6	N^S ADR
7	NUU BDDDD
9	BU NNO
11	B DI
```

## Solution

```Puzzle Summary
A1, BN^S | ABE, values={5669}
A4, EI | BDS, values={223}
A6, I*I | DINN, values={293}
A8, ADDNNU | DDEOS, values={7529}
A10, ND^U | AESS, values={6163}
A12, OS | EE, values={157}
A13, DDRU | OU, values={317}
A14, EUU | BBN, values={1579}
D2, DRRR | NNRU, values={691}
D3, AS | DRR, values={97}
D4, AE | BU, values={251}
D5, DDDRR | ANR, values={397}
D6, N^S | ADR, values={263}
D7, NUU | BDDDD, values={367}
D9, BU | NNO, values={257}
D11, B | DI, values={31}
+--+--+--+--+--+--+--+
| 5  6  6  9| 2  2  3|
+--    --   +   --   +
| 2  9  3| 7  5  2  9|
+        +--+        +
| 6  1  6  3| 1  5  7|
+   --+     +--+   --+
| 3  1  7| 1  5  7  9|
+--+--+--+--+--+--+--+
Variables:
A={19}
B={23}
D={2}
E={13}
I={17}
N={3}
O={29}
R={7}
S={5}
U={11}
```

## Lessons Learned

Inbetweeners Puzzle
- Entry values are between clue expression values
- Implemented with just Entries, but have to avoid checking against existing values/min/max
- Check for solution digit frequency in checkSolution() - getAllDigits() added to puzzle base class