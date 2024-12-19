# CyclingPrimes Puzzle Solver

## Puzzle

Cycling Primes by Nod

Every grid entry is a cyclic permutation of a prime number. Each permutation leads to a distinct grid entry of the same length but different from the original prime. For example, the prime number 1279 results in the possible entries 2791, 7912 and 9127 whilst the prime number 1307 results in 3071 and 7130 (zero starts are excluded). Sorted into numerical order, the 15 grid entries have been labelled A to O and clues to some of them are given below  and the normal rules of algebra apply. The grid numbering is for reference only and bear no relationship to clue order.

```+--+--+--+--+--+
|1 :  :2 :3 |4 |
+::+--+::+::+::+
|5 :6 |7 :  :  |
+::+::+::+::+::+
|8 :  :  |9 :  |
+--+::+::+--+::+
|10:  |11:12:  |
+::+::+--+::+--+
|  |13:  :  :  |
+--+--+--+--+--+


Clues
C	B + B
D	AA - E
L	A( B + D ) + G
M	N - AB - E
N	BBC
O	CF	BG	CF
```

## Solution

```Mapping
Entry A1{8192} = Clue N{8192}
Entry D1{877} = Clue J{877, 977}
Entry D2{9568} = Clue O{9568}
Entry D3{299} = Clue F{299}
Entry D4{7886} = Clue M{7886}
Entry A5{71} = Clue D{71}
Entry D6{1361} = Clue K{1361, 1363, 1367, 1369}
Entry A7{598} = Clue G{598}
Entry A8{736} = Clue H{736}
Entry A9{98} = Clue E{98}
Entry A10{16} = Clue B{16}
Entry D10{13} = Clue A{13}
Entry A11{836} = Clue I{737, 739, 832, 833, 836, 838, 839, 931, 932, 934, 937, 938}
Entry D12{32} = Clue C{32}
Entry A13{1729} = Clue L{1729}
+--+--+--+--+--+
| 8  1  9  2| 7|
+   --      +  +
| 7  1| 5  9  8|
+     +        +
| 7  3  6| 9  8|
+--+     +--+  +
| 1  6| 8  3  6|
+     +--+   --+
| 3| 1  7  2  9|
+--+--+--+--+--+

```

## Lessons Learned

Add CyclingPrimes puzzle
- Maintain clue value order
- After solve clues, map clues to entries, checkSolution() checks mapped clue order
- Initialise some clues using Clue.getValuesFromLength() because no mapped digits
- Pass clue names to Expression Scanner (similar to Entry names)
- Improve Cossnumber.solveClue() recording of updated variables
- This needed change to updateClues() in all puzzles!
- Also lots of regression output changes
- Add isCyclicPrime()
