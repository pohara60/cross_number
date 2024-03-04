# Couplets Puzzle Solver

## Puzzle

The Listener Crossword No 4803 Versed Couplets by Arden

Each clue refers to an across entry and a down entry, which are reverses of one another. The clue answer is the sum of the two numbers (but the number in brackets is the length of the grid entries). There are no leading zeros and all answers and entries are different.

```+--+--+--+--+--+--+--+--+
|1 :2 :  :3 |4 |5 :6 :7 |
+::+::+--+::+::+--+::+::+
|8 :  :  |9 :  |10:  :  |
+::+::+--+--+::+::+::+::+
|  |11:12:  :  :  |  |  |
+--+--+::+--+::+::+--+::+
|13:14:  :  |  |  |15:  |
+--+::+::+--+--+::+::+--+
|16:  |  |17|18:  :  :  |
+::+--+::+::+--+::+--+--+
|  |19|20:  :  :  :21|22|
+::+::+::+::+--+--+::+::+
|23:  :  |24:25|26:  :  |
+::+::+--+::+::+--+::+::+
|27:  :  |  |28:  :  :  |
+--+--+--+--+--+--+--+--+


Clues
I	A1+D17 = $notpalindrome #result
II	A5+D22 = $Square #result
III	A8+D2 = $multiple (A15+D25)
IV	A9+D15 = #triangular
V	A10+D19 = 2*(A23+D6)/3
VI	A11+D12 = $cube (A16+D3)
VII	A13+D16 = #fibonacci
VIII	A15+D25 = #Square
IX	A16+D3 = #fibonacci
X	$ds (A18+D7) = $ds (A26+D21) = $ds #result
XI	A20+D10 = #triangular
XII	A23+D6 = 3*(A10+D19)/2
XIII	A24+D14 = 2 * #triangular
XIV	A26+D21
XV	A27+D1 = #Sum2square
XVI	A28+D4 = #triangular
```

## Solution

```Puzzle Summary
I, A1+D17 = $notpalindrome #result, values={10450}
II, A5+D22 = #square, values={625}
III, A8+$reverse A8 = $multiple (A15+$reverse A15), values={847}
IV, A9+D15 = #triangular, values={66}
V, A10+$reverse A10 = 2*(A23+$reverse A23)/3, values={1010}
VI, A11+$reverse A11 = $cube (A16+$reverse A16), values={166375}
VII, A13+D16 = #fibonacci, values={6765}
VIII, A15+D25 = #square, values={121}
IX, A16+D3 = #fibonacci, values={55}
X, $ds (A18+$reverse A18) = $ds (A26+$reverse A26) = $ds #result, values={1089,1098,1179,1188,1197,1269,1278,1287,1296,1359,1368,1377,1386,1395,1449,1458,1467,1476,1485,1494,4763 more,99000}
XI, A20+D10 = #triangular, values={162735}
XII, A23+$reverse A23 = 3*(A10+$reverse A10)/2, values={1515}
XIII, A24+D14 = 2 * #triangular, values={110}
XIV, A26+D21, values={828}
XV, A27+D1 = #Sum2square, values={1130}
XVI, A28+D4 = #triangular, values={5995}
A1, $reverse D17, values={9131}
D1, $reverse A27, values={961}
D2, $reverse A8, values={176}
D3, $reverse A16, values={14}
D4, $reverse A28, values={3272}
A5, $reverse D22, values={362}
D6, $reverse A23, values={609}
D7, $reverse A18, values={2439}
A8, $reverse D2, values={671}
A9, $reverse D15, values={42}
A10, $reverse D19, values={604}
D10, $reverse A20, values={69339}
A11, $reverse D12, values={69179}
D12, $reverse A11, values={97196}
A13, $reverse D16, values={1974}
D14, $reverse A24, values={91}
A15, $reverse D25, values={29}
D15, $reverse A9, values={24}
A16, $reverse D3, values={41}
D16, $reverse A13, values={4791}
D17, $reverse A1, values={1319}
A18, $reverse D7, values={9342}
D19, $reverse A10, values={406}
A20, $reverse D10, values={93396}
D21, $reverse A26 | (XIV-A26), values={612}
D22, $reverse A5, values={263}
A23, $reverse D6, values={906}
A24, $reverse D14, values={19}
D25, $reverse A15, values={92}
A26, $reverse D21 | (XIV-D21), values={216}
A27, $reverse D1, values={169}
A28, $reverse D4, values={2723}
+--+--+--+--+--+--+--+--+
| 9  1  3  1| 3| 3  6  2|
+      --   +  +--      +
| 6  7  1| 4  2| 6  0  4|
+      --+--+  +        +
| 1| 6  9  1  7  9| 9| 3|
+--+--+   --      +--+  +
| 1  9  7  4| 2| 3| 2  9|
+--       --+--+  +   --+
| 4  1| 1| 1| 9  3  4  2|
+   --+  +  +--    --+--+
| 7| 4| 9  3  3  9  6| 2|
+  +  +      -- --+  +  +
| 9  0  6| 1  9| 2  1  6|
+      --+     +--      +
| 1  6  9| 9| 2  7  2  3|
+--+--+--+--+--+--+--+--+
```

## Lessons Learned

The puzzle has clues that impose conditions on the entries, as opposed to mapping to entries.

Manual intervention was necessary for the clue VI: A11+D12 = $cube (A16+D3), after establishing that (A16+D3) must be 55, then the cube 166375, results in these possibilities for the overlapping clues A11 and D12.
    puzzle.entries['A11']!.values = {69179, 78188, 87197};
    puzzle.entries['D12']!.values = {97196, 88187, 79178};

Changes:
- Add Couplets puzzle
- updateClues always add updated clue to queue - probably breaks IncreasingPrime?
- add generator sum2square
- recode monadic reverse to try to make it faster