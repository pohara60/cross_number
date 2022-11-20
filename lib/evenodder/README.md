# EvenOdder Puzzle Solver

## Introduction

The EvenOdder puzzle has these features:

-   It is a grid, similar to a crossword grid, with numbered clues across and down
-   The clues are specified as expressions involving letters
-   The 16 letters are distinct numbers in the range 2 to 33
    -   A letter has different consecutive even and odd values in the Across and Down clues
-   Grid entries are unique and cannot start with 0

## Notes

The first solution to the puzzle used hand-written solution functions using solveVariableExpression, and two optimised functions for solveD25 and solveD26. These two latter functions were manually invoked before using the normal solution loop.

We then developed the automatic clue expression evalator, and changed to use solveVariableExpressionEvaluator, which is an order of magnitude slower than hand-written solveVariableExpression!

So we then changed to using a PriorityQueue for the clue solution loop, examining clues in ascending order of the number of combinations of clue variable values. This increased the number of loop iterations, but reduced the execution time.

Examining the elasped time for clue solution lead to reinstating the hand-written solution functions for solveD26 and solveA18, which reduced the execution time to less than a second.

## Guidance for Variable Puzzles

Start with the automatic solveVariableExpressionEvaluator, which should solve the puzzle, albeit slowly. To improve the execution time hand-write solution functions for the slowest clues.
