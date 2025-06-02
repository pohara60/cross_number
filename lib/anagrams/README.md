# Anagrams Puzzle Solver

## Puzzle

Anagrams

In each clue, the first number is the total number of prime factors of the answer (including repeats), and the second number is the difference between the smallest and largest of those primes. For example, 25 = 5x5 would be clued as 2:0, and 84-2x2x3x7 would be clued as 4:5.

Solvers must submit a grid in which every entry is an anagram of its counterpart in the initial grid, ie it has the same digits in a different order. For each of the unclued six-digit entries, the anagram is a multiple of its original value. The 48 numbers used (24 initial grid entries and 24 anagrams) are all different, and none of them starts with zero.

```+--+--+--+--+--+--+--+--+
|1 :2 :3 :  |4 :5 :  :6 |
+::+::+::+--+--+::+--+::+
|  |  |  |7 |8 |  |9 :  |
+::+--+::+::+::+::+--+::+
|10:  :  :  |11:  :  :  |
+::+--+::+::+::+::+--+::+
|  |12:  :  :  :  :  |  |
+--+--+--+::+::+--+--+--+
|13|14:15:  :  :16:  |17|
+::+--+::+::+::+::+--+::+
|18:  :  :  |19:  :  :  |
+::+--+::+::+::+::+--+::+
|20:  |  |  |  |  |21|  |
+::+--+::+--+--+::+::+::+
|22:  :  :  |23:  :  :  |
+--+--+--+--+--+--+--+--+


Across
1	£primeFactors(16,2)
4	£primeFactors(3,69)
9	£primeFactors(5,1)
10	£primeFactors(3,104)
11	£primeFactors(4,11)
12	
14	
18	£primeFactors(10,0)
19	£primeFactors(7,9)
20	£primeFactors(5,0)
22	£primeFactors(2,1427)
23	£primeFactors(6,4)
Down
1	£primeFactors(4,16)
2	£primeFactors(2,2)
3	£primeFactors(10,1)
5	£primeFactors(11,0)
6	£primeFactors(2,594)
7	
8	
13	£primeFactors(3,1281)
15	£primeFactors(4,8)
16	£primeFactors(4,29)
17	£primeFactors(4,0)
21	£primeFactors(4,0)
```

## Solution

```
Anagrams Callback=1
Puzzle Summary
A1, £primeFactors(6,2,4), values={3375}
A4, £primeFactors(3,69,4), values={5254}
A9, £primeFactors(5,1,2), values={72}
A10, £primeFactors(3,104,4), values={4173}
A11, £primeFactors(4,11,4), values={1430}
A12, , values={unknown}
A14, , values={unknown}
A18, £primeFactors(10,0,4), values={1024}
A19, £primeFactors(7,9,4), values={8624}
A20, £primeFactors(5,0,2), values={32}
A22, £primeFactors(2,1427,4), values={2858}
A23, £primeFactors(6,4,4), values={9261}
D1, £primeFactors(4,16,4), values={3249}
D2, £primeFactors(2,2,2), values={35}
D3, £primeFactors(10,1,4), values={7776}
D5, £primeFactors(11,0,4), values={2048}
D6, £primeFactors(2,594,4), values={4207}
D7, , values={unknown}
D8, , values={unknown}
D13, £primeFactors(3,1281,4), values={5132}
D15, £primeFactors(4,8,4), values={4225}
D16, £primeFactors(4,29,4), values={5642}
D17, £primeFactors(4,0,4), values={2401}
D21, £primeFactors(4,0,2), values={16}
+--+--+--+--+--+--+--+--+
| 3  3  7  5| 5  2  5  4|
+         --+--    --   +
| 2| 5| 7| 1| 1| 0| 7  2|
+  +--+  +  +  +  +--   +
| 4  1  7  3| 1  4  3  0|
+   --      +      --   +
| 9| 1  6  7  9  8  2| 7|
+--+-- --+      --+--+--+
| 5| 1  4  2  8  5  7| 2|
+  +--             --+  +
| 1  0  2  4| 8  6  2  4|
+   --      +      --   +
| 3  2| 2| 1| 3| 4| 1| 0|
+   --+  +--+--+  +  +  +
| 2  8  5  8| 9  2  6  1|
+--+--+--+--+--+--+--+--+
Anagrams
Entry Values=[
3375, 5254, 72, 4173, 1430, 1024, 8624, 32, 2858, 9261, 
3249, 35, 7776, 2048, 4207, 5132, 4225, 5642, 2401, 16]
New Entry Values=[
3573, 5452, 27, 4371, 3014, 1042, 8264, 23, 5828, 9612, 
3942, 53, 7677, 4802, 2740, 3125, 5422, 4256, 1402, 61]
Six Digit Values=[167982, 671928, 142857, 857142, 137241, 411723, 119883, 839181]
+--+--+--+--+--+--+--+--+
| 3  5  7  3| 5  4  5  2|
+         --+--    --   +
| 9| 3| 6| 4| 8| 8| 2  7|
+  +--+  +  +  +  +--   +
| 4  3  7  1| 3  0  1  4|
+   --      +      --   +
| 2| 6  7  1  9  2  8| 0|
+--+-- --+      --+--+--+
| 3| 8  5  7  1  4  2| 1|
+  +--             --+  +
| 1  0  4  2| 8  2  6  4|
+   --      +      --   +
| 2  3| 2| 3| 1| 5| 6| 0|
+   --+  +--+--+  +  +  +
| 5  8  2  8| 9  6  1  2|
+--+--+--+--+--+--+--+--+

Anagrams Callback=2
Puzzle Summary
A1, £primeFactors(6,2,4), values={3375}
A4, £primeFactors(3,69,4), values={6264}
A9, £primeFactors(5,1,2), values={72}
A10, £primeFactors(3,104,4), values={4173}
A11, £primeFactors(4,11,4), values={1430}
A12, , values={unknown}
A14, , values={unknown}
A18, £primeFactors(10,0,4), values={1024}
A19, £primeFactors(7,9,4), values={8624}
A20, £primeFactors(5,0,2), values={32}
A22, £primeFactors(2,1427,4), values={2858}
A23, £primeFactors(6,4,4), values={9261}
D1, £primeFactors(4,16,4), values={3249}
D2, £primeFactors(2,2,2), values={35}
D3, £primeFactors(10,1,4), values={7776}
D5, £primeFactors(11,0,4), values={2048}
D6, £primeFactors(2,594,4), values={4207}
D7, , values={unknown}
D8, , values={unknown}
D13, £primeFactors(3,1281,4), values={5132}
D15, £primeFactors(4,8,4), values={4225}
D16, £primeFactors(4,29,4), values={5642}
D17, £primeFactors(4,0,4), values={2401}
D21, £primeFactors(4,0,2), values={16}
+--+--+--+--+--+--+--+--+
| 3  3  7  5| 6  2  6  4|
+         --+--    --   +
| 2| 5| 7| 1| 1| 0| 7  2|
+  +--+  +  +  +  +--   +
| 4  1  7  3| 1  4  3  0|
+   --      +      --   +
| 9| 1  6  7  9  8  2| 7|
+--+-- --+      --+--+--+
| 5| 1  4  2  8  5  7| 2|
+  +--             --+  +
| 1  0  2  4| 8  6  2  4|
+   --      +      --   +
| 3  2| 2| 1| 3| 4| 1| 0|
+   --+  +--+--+  +  +  +
| 2  8  5  8| 9  2  6  1|
+--+--+--+--+--+--+--+--+
Entry Values=[3375, 6264, 72, 4173, 1430, 1024, 8624, 32, 2858, 9261, 
3249, 35, 7776, 2048, 4207, 5132, 4225, 5642, 2401, 16]
New Entry Values=[3573, 6462, 27, 4371, 3014, 1042, 8264, 23, 5828, 9612, 
3942, 53, 7677, 4802, 2740, 3125, 5422, 4256, 1402, 61]
Six Digit Values=[167982, 671928, 142857, 857142, 137241, 411723, 119883, 839181]
+--+--+--+--+--+--+--+--+
| 3  5  7  3| 6  4  6  2|
+         --+--    --   +
| 9| 3| 6| 4| 8| 8| 2  7|
+  +--+  +  +  +  +--   +
| 4  3  7  1| 3  0  1  4|
+   --      +      --   +
| 2| 6  7  1  9  2  8| 0|
+--+-- --+      --+--+--+
| 3| 8  5  7  1  4  2| 1|
+  +--             --+  +
| 1  0  4  2| 8  2  6  4|
+   --      +      --   +
| 2  3| 2| 3| 1| 5| 6| 0|
+   --+  +--+--+  +  +  +
| 5  8  2  8| 9  6  1  2|
+--+--+--+--+--+--+--+--+

```



## Lessons Learned

Add Listener Anagrams Puzzle
- Add second PostProcessing callback for partial solutions - many rafactoring changes
- Add Polyadic for computing solutions to the prime factors clues
- Add callback to backtrack for the clue anagrams, and for the six digit clues values and anagrams
