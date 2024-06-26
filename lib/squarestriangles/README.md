# SquaresTriangles Puzzle Solver

## Puzzle

Squares and Triangles by Hedgehog

Across entries are square numbers and down entries are triangular numbers. In the across clues, the clues give any properties of the square root of the answer. Triangular numbers can be written as n(n+1)/2 and the down clues give any properties of n and (n+1). All instances of square, prime and triangular numbers are given. (There are no cases in the down answers where both n and (n+1) have a property). The square roots, ns and (n+1)s are all distinct except that the three pairs 1ac and 14dn, 4dn and 6ac, 5dn and 9dn each share a value. In the grid solvers should highlight seven cells in a straight line in an appropriate direction. All entries are distinct and no entry starts with zero.

```+--+--+--+--+--+--+--+
|1 :  :2 :  |3 :4 :5 |
+::+--+::+--+::+::+::+
|6 :  :  |7 :  :  |  |
+::+--+::+::+::+--+::+
|8 :9 :  :  |10:  :  |
+::+::+::+::+::+--+--+
|  |11:  :  :  :  |12|
+--+::+--+::+--+--+::+
|13:  |14|15:16:  :  |
+::+--+::+::+::+--+::+
|17:  :  :  |  |18:  |
+::+--+::+--+::+--+::+
|19:  :  :  |20:  :  |
+--+--+--+--+--+--+--+


Across
1	
3	#prime
6	
7	#square
8	
10	
11	
13	#square
15	#prime
17	
18	#prime
19	#prime
20	#prime
Down
1	#prime
2	
3	
4	#prime
5	#triangular
7	#prime
9	#prime
12	#prime
13	#prime
14	
16	#prime
```

## Solution

```Puzzle Summary
Clue A1, , values={32}
Clue A3, #prime, values={13}
Clue A6, , values={12}
Clue A7, #square, values={16}
Clue A8, , values={54}
Clue A10, , values={30}
Clue A11, , values={213}
Clue A13, #square, values={4}
Clue A15, #prime, values={61}
Clue A17, , values={75}
Clue A18, #prime, values={5}
Clue A19, #prime, values={59}
Clue A20, #prime, values={19}
Clue D1, #prime, values={47}
Clue D2, , values={70}
Clue D3, , values={57}
Clue D4, #prime, values={11}
Clue D5, #triangular, values={45}
Clue D7, #prime, values={229}
Clue D9, #prime, values={43}
Clue D12, #prime, values={101}
Clue D13, #prime, values={17}
Clue D14, , values={33}
Clue D16, #prime, values={37}
Entry A1, #square, values={1024}
Entry D1, #triangular, values={1128}
Entry D2, #triangular, values={2415}
Entry A3, #square, values={169}
Entry D3, #triangular, values={1596}
Entry D4, #triangular, values={66}
Entry D5, #triangular, values={990}
Entry A6, #square, values={144}
Entry A7, #square, values={256}
Entry D7, #triangular, values={26335}
Entry A8, #square, values={2916}
Entry D9, #triangular, values={946}
Entry A10, #square, values={900}
Entry A11, #square, values={45369}
Entry D12, #triangular, values={5151}
Entry A13, #square, values={16}
Entry D13, #triangular, values={153}
Entry D14, #triangular, values={528}
Entry A15, #square, values={3721}
Entry D16, #triangular, values={703}
Entry A17, #square, values={5625}
Entry A18, #square, values={25}
Entry A19, #square, values={3481}
Entry A20, #square, values={361}
+--+--+--+--+--+--+--+
| 1  0  2  4| 1  6  9|
+   --    --+        +
| 1  4  4| 2  5  6| 9|
+   --   +      --+  +
| 2  9  1  6| 9  0  0|
+           +   -- --+
| 8| 4  5  3  6  9| 5|
+--+   --+   --+--+  +
| 1  6| 5| 3  7  2  1|
+   --+  +      --   +
| 5  6  2  5| 0| 2  5|
+   --    --+  +--   +
| 3  4  8  1| 3  6  1|
+--+--+--+--+--+--+--+
```

## Lessons Learned

Add the Squares Triangles puzzle. 
- The Clues and Entries have different values, but are mapped: Clue values are the square roots of Across Entries, or n/n+1 of triangular number n for Down Entries.
- The Clue min/max values have to be specially computed
- The Clue values are distinct, except for 3 specified pairs of clues where there are duplicate values. The Down clues need special treatment because of the pair of values n/n+1.
- Because the Down Clue values are ambiuous (n or n+1?), the inital puzzle solution is not unique. Iteration examines the possibel solutions, the puzzle checkSolution() function resolves the ambiguity.
