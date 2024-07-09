# OpposingDigitSum Puzzle Solver

## Puzzle

Add Opposing Digit Sum by Zag

Before entry each answer is increased by the digit sum of the symmetrically opposite entry; answer and entry being the same length. For example, the 1ac answer has the digit sum of the 11ac entry added to it to form the 1ac entry. References within clues are to the entries, not the answers. No entry starts with zero and all entries are distinct.

```+--+--+--+--+--+--+
|1 :  |2 |3 :4 :  |
+::+--+::+::+::+--+
|5 :6 :  :  |  |7 |
+::+::+--+--+::+::+
|  |  |8 :9 :  :  |
+--+::+::+::+--+::+
|10:  :  |  |11:  |
+--+--+--+--+--+--+


Across
1	DP EA11 = #square
3	#square
5	#palindrome
8	$reverse EA5
10	#prime
11	#square
Down
1	#prime
2	#triangular
3	DS ED4
4	#triangular
6	#triangular
7	$multiple ED1
8	DP ED6
9	#triangular
```

## Solution

```Puzzle Summary
Clue A1, $DP EA11 = #square, values={36}
Clue A3, #square, values={256}
Clue A5, #palindrome, values={4224}
Clue A8, $reverse EA5, values={5424}
Clue A10, #prime, values={653}
Clue A11, #square, values={81}
Clue D1, #prime, values={421}
Clue D2, #triangular, values={45}
Clue D3, $DS ED4, values={15}
Clue D4, #triangular, values={741}
Clue D6, #triangular, values={231}
Clue D7, $multiple ED1, values={884}
Clue D8, $DP ED6, values={48}
Clue D9, #triangular, values={36}
Entry A1, A1 + $DS EA11, values={49}
Entry D1, D1 + $DS ED7, values={442}
Entry D2, D2 + $DS ED9, values={54}
Entry A3, A3 + $DS EA10, values={273}
Entry D3, D3 + $DS ED8, values={25}
Entry D4, D4 + $DS ED6, values={753}
Entry A5, A5 + $DS EA8, values={4245}
Entry D6, D6 + $DS ED4, values={246}
Entry D7, D7 + $DS ED1, values={894}
Entry A8, A8 + $DS EA5, values={5439}
Entry D8, D8 + $DS ED3, values={55}
Entry D9, D9 + $DS ED2, values={45}
Entry A10, A10 + $DS EA3, values={665}
Entry A11, A11 + $DS EA1, values={94}
+--+--+--+--+--+--+
| 4  9| 5| 2  7  3|
+   --+  +      --+
| 4  2  4  5| 5| 8|
+      --+--+  +  +
| 2| 4| 5  4  3  9|
+--+  +      --+  +
| 6  6  5| 5| 9  4|
+--+--+--+--+--+--+
```

## Lessons Learned

Add OpposingDigitSum puzzle
solveLinkedClues()
- Find groups of clues/entries that refer to each other; in this puzzle this includes all symmetric pairs of clues and entries, plus a few expression references
- Solve these clues recursively:
  - Get possible values for references - may have been determined by earlier clue
  - For each combination:
    - Compute clue value(s)
    - For each value, solve next clue in group
    - If no more, then save possible values of solved clues and references
solveClue()
- Finalise all update clues, not just the input parameter
Resolve clue/entry references in variables and expressions before solve
- Change references from name to pointer
- Pass variables instead of names
Lots of refactoring and regression changes

## Manual Solution Explanation

Numbers in italics refer to the entered quantity, unadjusted answers are in normal case. 

1ac derives from a digit product that is also a square. Possible 1ac,_11ac_,_1ac_,11ac are:
16,_28_,_26_,20; 16,_44_,_24_,38; 16,_82_,_26_,74; 25,_55_,_35_,47; 36,_49_,_49_,36 (duplicate 49); 36,_66_,_48_,54; 36,_94_,_49_,81; 49,_77_,_63_,68; 64,_88_,_80_,80; 81,_99_,_99_,81 (duplicate 99). This confirms 1ac is 36/49 & 11ac is 81/94.
7dn must be twice 1dn so if 1dn=4pq then 7dn=800 +20*p+2*q and 7dn=804+21*p+3*q. 4+p+3*q ends in 4 allows p,q/1dn,7dn,7dn,1dn of:
1,3,413,826,834,398; 2,6,426,852,864,408; 3,9,439,878,894,418; 4,2,442,884,894,421; 5,5,455,910,924,440; 6,8,468,936,954,450; 7,1,471,942,954,453; 8,4,484,968,984,463; 9,7,497,994,1014 (out of range). The 1dn primes are 421 or 463 for 1dn of 442 or 484.
If 5ac starts 8 and 8ac ends 8 then possible solutions are calculated as follows. The 8ac digit sum lies between 10 (1108) and 35 (9998). If the 8ac digit sum is 10 and the 5ac palindrome is 8118 then 5ac=8128, 8ac=8218, 8ac=8237 not ending 8. In addition to ending 8 the 8ac digit sum must match its assumed digit sum at the start of the calculation. There is no solution for any 5ac palindrome of the form 8pp8 confirming 1dn=442, 7dn=894.
We can repeat the procedure with 5ac a palindrome of the form 4pp4 and the 8ac digit sum in the range 11 to 36. In this case there are 2 solutions:
5ac=4224, 8ac digit sum=21, 5ac=4245, 8ac=5424, 8ac=5439, consistent digit sum.
5ac=4664, 8ac digit sum=32, 5ac=4696, 8ac=6964, 8ac=6989, consistent digit sum.
2dn,9dn are either p4,4q or p9,9q for some p&q. The only pairings which have underlying triangulars are 54,45 with underlying 45,36 or 79,94 with underlying 66,78 however in the latter case 94 would be a duplicate so this confirms 5ac=4245, 8ac=5439.
3dn,8dn are of the form p5,5q. 8dn is even since 6dn starts 2. 4dn is at most 993 with digit sum 21 and 8dn is at most 59 with digit sum 14 so 3dn is at most 35. If 8dn=59, 2dn=35 but then 8dn=51 an ineligible odd number. 3dn is either 15 or 25. If 3dn=15,
3dn/8dn can be 15/50 for 3dn=10 but 8dn=44 which with factor 11 cannot be a digit product. Other 3dn=15 candidates have different answer and entry lengths.
With 3dn=25, 3dn/8dn can be 25/55 or 25/57. With 3dn/8dn=25/55 for 3dn=15, 8dn=48 which allows 6dn=238, 246, 264 or 283 with digit sums 12 or 13. Possible 4dn with digit sum 15 (3dn - digit sum 8dn=25-5-5) are 393,483,573 …. 933 and triangular 4dn can be
1492532479546245578248594391036551194
23
achieved with 573-12=561 or 753-12=741. 6dn=246 or 264 for 6dn=231 or 249 with only 231 triangular. If 3dn/8dn=25/57, 3dn=13, 8dn=50 which allows 6dn=255 with digit sum 12. Possible 4dn are 913,823 …193 but no 4dn is triangular confirming 3dn/8dn=25/55 etc.
If S is the underlying 3ac square then 3ac=25p or 27p, 10ac=q65, S=25p or 27p-q-6-5. The only solution is S=256 requiring 3ac=27p, p=q-3. 10ac=q65-2-7-p=99*q+59 which is only a prime for q=6, p=3 completing the solution.
