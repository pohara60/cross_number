# AlmostFermat Puzzle Solver

## Puzzle

Almost Fermat by John Gowland

Whilst there are no solutions to x3 + y3 = z3, there are an infinite number of solutions to x3 + y3 + 1 = z3. For example, 83 + 63 + 1 = 93. In this puzzle x, y and z are confined to 3 -digit numbers, except for one value of x or y and one value of z. Upper case letters denote across entries and lower  case down entries. No entry starts with zero and all entries are distinct.  Clues are numbered for reference only.

+--+--+--+--+--+
|a |b |A :c :  |
+::+::+--+::+--+
|B :  |Cd:  :  |
+::+::+::+--+--+
|  |D :  :e |f |
+--+--+::+::+::+
|E :g :  |F :  |
+--+::+--+::+::+
|G :  :  |  |  |
+--+--+--+--+--+

```
Clues
I	4B
II	2C
III	10F
IV	f-4F
V	f-4F
VI	a
VII	cg
```

## Solution

```
Puzzle Summary
I, 4B | f | D, values={372,426,505}
II, 2C | E | 8A, values={566,823,904}
III, 10F | (b-A)^2/2 | g^2, values={242,720,729}
IV, f-4F | b | G, values={135,138,172}
V, f-4F | f/6 | 2F, values={71,138,144}
VI, a | 4d | 2D, values={791,812,1010}
VII, cg | f | e, values={426,486,577}
a, VI, values={791}
b, IV, values={135}
A, (II/8), values={113}
c, (VII/g), values={18}
B, (I/4), values={93}
C, (II/2), values={283}
d, (VI/4), values={203}
D, I | (VI/2), values={505}
e, VII, values={577}
f, I | (IV+(4F)) | (V+(4F)) | (V*6) | VII, values={426}
E, II, values={823}
g, (VII/c), values={27}
F, (III/10) | ((f-IV)/4) | ((f-V)/4) | (V/2), values={72}
G, IV, values={172}
+--+--+--+--+--+
| 7| 1| 1  1  3|
+  +  +--    --+
| 9  3| 2  8  3|
+     +   --+--+
| 1| 5  0  5| 4|
+--+--+     +  +
| 8  2  3| 7  2|
+--    --+     +
| 1  7  2| 7| 6|
+--+--+--+--+--+
```

## Lessons Learned

Puzzle has three expressions for each clue corresponding to the variables x, y and z which satisfy x^3+y^3+1=z^3. 
- Added multiple expressions per Clue (in addition to existing multiple expressions per Entry).
- The clue solve function evaluates all expressions and checks the condition, the clue value is the union of the expression values
- Entry expressions are computed for all Clue expressions
- Entry expression evaluation cannot set Clue values
- Added Puzzle.distinctClues property, which is false here
- Overrode Puzzle.uniqueSolution to not check for unique clue values 
