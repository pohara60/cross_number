# Virus Puzzle Solver

## Puzzle

KV Virus by Zag

In the land of Numerica there has been an outbreak of a KV virus. Such viruses include a key digit K and a viral digit V with neither K nor V zero. If the virus detects a number that includes any K it replaces it/them with a V provided there is no V already present. Such possession of a V bestows immunity on the number. 

In this puzzle every answer has been exposed to the virus and if susceptible infected to form the entry. Clue references are to the entries which are distinct, none starting with a zero. Note that while intersecting entries must be consistent, the corresponding uninfected intersecting answers need not be.

```+--+--+--+--+--+
|1 |2 :3 :4 |5 |
+::+--+::+::+::+
|6 :7 :  |8 :  |
+--+::+--+::+--+
|9 :  |10:  :11|
+::+::+::+--+::+
|  |12:  :  |  |
+--+--+--+--+--+


Across
2	$prime $jumble #otherentry
6	#triangular
8	#prime
9	$DS ED7
10	#square
12	$multiple ED10
Down
1	$multiple EA9
3	$DS ED10
4	#multiple ED3
5	$DP EA12
7	$multiple K*V
9	$squareroot EA6
10	#prime
11	$divisor ED1
```

## Solution

```Puzzle Summary
Clue A2, £inversekv(EA2,X) = $prime $jumble #otherentry, values={811}
Clue A6, £inversekv(EA6,X) = $triangular #result, values={496}
Clue A8, £inversekv(EA8,X) = #prime, values={11}
Clue A9, £inversekv(EA9,X) = $DS ED7, values={18}
Clue A10, £inversekv(EA10,X) = #square, values={784}
Clue A12, £inversekv(EA12,X) = $multiple ED10, values={438}
Clue D1, £inversekv(ED1,X) = $multiple EA9, values={54}
Clue D3, £inversekv(ED3,X) = $DS EA10, values={16}
Clue D4, £inversekv(ED4,X) = $multiple ED3, values={448}
Clue D5, £inversekv(ED5,X) = $DP EA12, values={24}
Clue D7, £inversekv(ED7,X) = $multiple X, values={984}
Clue D9, £inversekv(ED9,X) = $squareroot EA6, values={14}
Clue D10, £inversekv(ED10,X) = #prime, values={73}
Clue D11, £inversekv(ED11,X) = $divisor ED1, values={17}
Entry D1, £kv(D1,X), values={51}
Entry A2, £kv(A2,X), values={811}
Entry D3, £kv(D3,X), values={16}
Entry D4, £kv(D4,X), values={118}
Entry D5, £kv(D5,X), values={21}
Entry A6, £kv(A6,X), values={196}
Entry D7, £kv(D7,X), values={981}
Entry A8, £kv(A8,X), values={11}
Entry A9, £kv(A9,X), values={18}
Entry D9, £kv(D9,X), values={14}
Entry A10, £kv(A10,X), values={781}
Entry D10, £kv(D10,X), values={73}
Entry D11, £kv(D11,X), values={17}
Entry A12, £kv(A12,X), values={138}
+--+--+--+--+--+
| 5| 8  1  1| 2|
+  +--      +  +
| 1  9  6| 1  1|
+--+   --+   --+
| 1  8| 7  8  1|
+     +   --+  +
| 4| 1  3  8| 7|
+--+--+--+--+--+
Variables:
X={41}

```

## Lessons Learned

Add Virus puzzle
- The K and V variables are implemented as one variable X = KV
- The inter-relaionships between variable X and clues/entries A6, D9, D7 and A9 are optimised with specific logic
- The solver finds a partial solution - iteration is required to resolve two clues
- Added Polyadic functions which take multiple arguments to expressions
- Requires polyadic functions kv and inversekv
- Added Monadic $triangular
- Puzzle.clueOrVariableValueReferences() is incorrect for puzzles with separate clues and values, and is not needed in any case
- Add solveClueNoException() helper for solving specific clues in puzzle solve()
- Variable.checkAnswer() throws SolveError instead of SolveException

Possible Enhancements
- Use related variable solver from OpposingDigitSum puzzle
