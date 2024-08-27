# TakeTwoOrThree Puzzle Solver

## Puzzle

The Listener Crossword No 4830 Take Two or Three by Oyler

This puzzle is a 50th anniversary tribute to Listener Crossword 2309, Take Two or Three by Adam. In that puzzle, solvers had to find triples of integers in which the sum of any two as well as the sum of all three was a square number. This one is based on sets of three distinct positive integers where the sum of any two or all three is a triangular number.
Any triangular number has the form n(n+1)/2, where n (a positive integer) is its "triangular root". If the roots of the triangular numbers given by adding any two members of a thematic triple are p, q and r (all different), and the triangular sum of all three is s, then it can be shown that (2p+1)^2+(2q+1)^2+(2r+1)^2 = 16s+3. Each clue is such an equation, with the square terms given in ascending order and the sum clued as an alphanumeric string, for example, if X is 125 then the expression 3~X~I means 31251. Using the triangular numbers corresponding to the three square terms in each clue, solvers must derive the thematic triple that gives those triangular sums. The numbers that appear more than once in these final triples must be added together and their sum, which has a thematic property, written below the grid. Clues are numbered for reference only. Capital letters are used for across entries and lower-case letters for down ones. No two entries are the same and none starts with zero.

```+--+--+--+--+--+--+--+
|a |Ab:c |Bd:  |Ce:f |
+::+::+::+::+--+::+::+
|D :  |  |E :g :  |  |
+--+--+::+::+::+--+--+
|F :  :  |  |G :  :  |
+--+--+::+::+::+--+--+
|h |Hk:  :  |  |Km:n |
+::+::+--+::+::+::+::+
|L :  |M :  |N :  |  |
+--+--+--+--+--+--+--+

Clues
I	    (A - B)^2 + L^2 + (C + L - e)^2 = 1~g
II	    B^2 +  M^2 +  N^2 = H~3
III	    e^2 +  C^2 +  f^2 =  14~E
IV	    C^2 + (F - e)^2 +  m^2 = c~3
V	    b^2 +  D^2 +  a^2 = d
VI	    (L + b - a)^2 + (F - n)^2 + L^2 = F~51
VII	    n^2 +  m^2 +  K^2 = 2~k~63
VIII	N^2 +  k^2 +  h^2 = 4~G


```

## Solution

```Puzzle Summary
Clue I, (A - B)^2 + L^2 + (C + L - e)^2 = 1~g, values={15843}
Clue II, B^2 +  M^2 +  N^2 = H~3, values={3043}
Clue III, e^2 +  C^2 +  f^2 =  14~E, values={14451}
Clue IV, C^2 + (F - e)^2 +  m^2 = c~3, values={20403}
Clue V, b^2 +  D^2 +  a^2 = d, values={24643}
Clue VI, (L + b - a)^2 + (F - n)^2 + L^2 = F~51, values={14451}
Clue VII, n^2 +  m^2 +  K^2 = 2~k~63, values={23763}
Clue VIII, N^2 +  k^2 +  h^2 = 4~G    , values={4803}
Entry a, values={99}
Entry A, values={82}
Entry b, values={81}
Entry c, £remove(C^2,(F - e)^2,m^2,"","3"), values={2040}
Entry B, values={27}
Entry d, £remove(b^2,D^2,a^2,"",""), values={24643}
Entry C, values={67}
Entry e, values={61}
Entry f, values={79}
Entry D, values={91}
Entry E, values={451}
Entry g, £remove((A - B)^2,L^2,(C + L - e)^2,"1",""), values={5843}
Entry F, £remove((L + b - a)^2,(F - n)^2,L^2,"","51"), values={144}
Entry G, values={803}
Entry h, values={47}
Entry H, £remove(B^2,M^2,N^2,"","3"), values={304}
Entry k, £remove(n^2,m^2,K^2,"2","63"), values={37}
Entry K, values={97}
Entry m, values={95}
Entry n, values={73}
Entry L, values={77}
Entry M, values={33}
Entry N, values={35}
+--+--+--+--+--+--+--+
| 9| 8  2| 2  7| 6  7|
+  +     +   --+     +
| 9  1| 0| 4  5  1| 9|
+--+--+  +      --+--+
| 1  4  4| 6| 8  0  3|
+-- --   +  +   -- --+
| 4| 3  0  4| 4| 9  7|
+  +   --+  +  +     +
| 7  7| 3  3| 3  5| 3|
+--+--+--+--+--+--+--+

    Clues			                        p	q	r	s	    Tp	Tq	 Tr
I	(A - B)^2 + L^2 + (C + L - e)^2 = 1~g	27	38	41	15843	378	741	 861
II	B^2 +  M^2 +  N^2 = H~3			        13	16	17	3043	91	136	 153
III	e^2 +  C^2 +  f^2 =  14~E			    30	33	39	14451	465	561	 780
IV	C^2 + (F - e)^2 +  m^2 = c~3			33	41	47	20403	561	861	 1128
V	b^2 +  D^2 +  a^2 = d			        40	45	49	24643	820	1035 1225
VI	(L + b - a)^2 + (F - n)^2 + L^2 = F~51	29	35	18	14451	435	630	 171
VII	n^2 +  m^2 +  K^2 = 2~k~63			    36	47	48	23763	666	1128 1176
VIII	N^2 +  k^2 +  h^2 = 4~G			    17	18	23	4803	153	171	 276
                                        
Sum Duplicates = 911 = 528 + 2346

```

## Lessons Learned

Add TakeTwoOrThree Puzzle:
- Define a Polyadic function removePrefixSuffix:
  - Checks the three terms and the sum numerically
  - Checks for required prefix and/or suffix, removes them
- Add Strings with Concatenation operator ~ to Expressions
- Puzzle.getVariables should not exclude input variables, as this breaks self-references
- Variable max getter should not return 1000 when null
