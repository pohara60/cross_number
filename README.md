# Cross Number Puzzle Solver

## Introduction

Cross Number puzzles have these features:

-   It is a grid, similar to a crossword grid, with numbered clues across and down
-   The clues specify conditions for the Value
-   The Values are distinct
-   Grid entries cannot start with 0

Many puzzles use Variables in the clues, with these features:

-   The variables have names
-   They have distinct values from a set of possible values

See [Design](Design.md) for a full description of puzzles and the solution algorithm.

There are different types of puzzle, each has a subdirectory with its specific implementation.


## Puzle Types

The Notes column in the table below refer to the type of clue solver logic, which has progressed over time:
- Manual solver, e.g. [solveA15](lib/primecuts/primecuts.dart).
- Variable solver with callback for expression, e.g. [solveA2 calls solveVariableExpression](lib/sequences/sequences.dart)
- Expression solver with generic expression logic, e.g. [solveVariableExpressionEvaluator](lib/sequences/sequences.dart)
- Expression solver with generic expression logic including generated values, e.g. [solveExpressionEvaluator](lib/dicenets2/dicenets2.dart)
 

| Puzzle | Type | Notes |
|--------|------|-------|
| [CarteBlanche](lib/carteblanche.dart) | Custom | Custom |
| [DiceNets](lib/dicenets/README.md) | Simple | Manual Solvers |
| [DiceNets2](lib/dicenets2/README.md) | Simple | Expression Solvers |
| [Distancing](lib/distancing/README.md) | Simple | Manual Solvers |
| [EvenOdder](lib/evenodder/README.md) | Variable | Expression Solvers |
| [Frequency](lib/frequency/README.md) | Simple | Manual Solvers, post-processing |
| [Instruction](lib/instruction/README.md) | Custom | Manual Solvers, post-processing |
| [Letters](lib/letters/README.md) | Variable | Variable Solvers |
| [No21](lib/no21/README.md) | Variable | Expression Solvers for Clues, post-processing |
| [PrimeCuts](lib/primecuts/README.md) | Variable | Manual Solvers, 2 values per clue |
| [Sequences](lib/sequences/README.md) | Variable | Expression Solvers |


## Specific Puzzle Implementation

The implementation of a specific puzzle includes these steps:

-   Create a folder for the puzzle
-   Create a main class for the puzzle, this must be added to the command line in bin/crossnumber.dart
    -   Initialize the puzzle, defining the clues and references between them
    -   Either:
         - Use generic expression solver - this will often need a clue value validation function, or 
         - Define solve functions for each clue, implementing the clue logic
-   Extend the Clue class to define puzzle-specific Clue and Entry classes
    -   Define the puzzle clue, may restict its possible values
    -   If the puzzle has variables, extend the VariableClue class
    -   If the puzzle has the generic expression solver, extend the ExpressionClue class
    -   puzzle entry is the clue with EntryMixin
-   Extend the Puzzle class
    -   Specify the puzzle Clue and Entry classes
    -   If the puzzle has variables, or using the generic expression solver, extend the VariablePuzzle class

It is recommended to use the generic expression solver for simple puzzles, with or without variables. Less common puzzles require custom logic, e.g. 
- Variables take two values for Across and Down clues
- Clue numbers also have an expression
- Clue value has decimals
- Clue value is fraction with numerator and denominator
