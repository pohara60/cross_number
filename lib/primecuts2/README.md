# Prime Cuts Puzzle Solver

## To Do

[ ] puzzle still not solved

## Introduction

Prime Cuts puzzles have these features:

-   It is a grid, similar to a crossword grid, with numbered clues across and down
-   The clues specify conditions for a 4 or 5 digit Value, a 2 digit Prime whose digits are removed from the Value to give the Grid entry, and the 2 or 3 digit Grid entry. For example:
    -   The Value is a multiple of the Prime
    -   The Prime is the reverse of the Prime for another clue
    -   The Grid entry is a multiple of the Prime
-   The Primes are distinct two digit numbers
-   Grid entries cannot start with 0
-   Numbers that are ascending or descending do not have repeated digits

## Second Implementation

This is the second implementation, using newer crossnumber features.

```
+--+--+--+--+--+--+
|1 |2 :3 :4 |5 :6 |
+::+--+::+::+--+::+
|7 :8 :  |9 :  :  |
+--+::+--+::+::+::+
|10:  |11:12|13:  |
+::+::+::+--+::+--+
|  |14:  |15:  :16|
+::+--+::+::+--+::+
|17:  |18:  :  |  |
+--+--+--+--+--+--+
```