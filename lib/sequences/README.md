# Sequences Puzzle Solver

## Introduction

The Sequences puzzle has these features:

-   It is a grid, similar to a crossword grid, with numbered clues across and down
-   The clues are specified as expressions involving letters
-   The letters are distinct numbers from the set of numbers < 200 that are powers of primes
-   Grid entries cannot start with 0
-   This puzzle is based on three sequences of at least seven numbers in which a rule is applied to each number to produce the next number. The rule is the same for all sequences but each sequence uses a different parameter. All numbers in the three sequences have 2 to 5 digits and they have no numbers in common. The grid entries are all the distinct numbers in the sequences, but with numbers longer than 3 digits (apart from 2ac and 31ac) split into two entries. For example, 19683 would appear as entries of 19 and 683 or of 196 and 83. The first number in a sequence is never split. The grid entries are all different, none starting with 0, and no entry is used in more than one of the sequences.
-   Each clue consists of one or two algebraic expressions for the value to be entered, with the number of digits given in brackets. The letters in clues stand for 22 of the 61 numbers less than 200 that can be expressed as a power (0 or higher) of a prime number. Sorted by numeric value, the clue letters will give a suggestion regarding the digits of each number in a sequence, to help in discovering the rule.
-   One of the sequences starts with 14dn. Solvers must highlight the starting entry for each of the other two sequences and write below the grid, in ascending order, the last number in each sequence.

## Notes

The first solution to the puzzle used hand-written solution functions using solveVariableExpression, and two optimised functions for solveD25 and solveD26. These two latter functions were manually invoked before using the normal solution loop.

We then developed the automatic clue expression evalator, and changed to use solveVariableExpressionEvaluator, which is an order of magnitude slower than hand-written solveVariableExpression!

So we then changed to using a PriorityQueue for the clue solution loop, examining clues in ascending order of the number of combinations of clue variable values. This increased the number of loop iterations, but reduced the execution time.

Examining the elasped time for clue solution lead to reinstating the hand-written solution functions for solveD26 and solveA18, which reduced the execution time to less than a second.

## Guidance for Variable Puzzles

Start with the automatic solveVariableExpressionEvaluator, which should solve the puzzle, albeit slowly. To improve the execution time hand-write solution functions for the slowest clues.
