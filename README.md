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

There are different types of puzzle, each has a subdirectory with its specific implementation.

## Generic Solution

In order to make a general puzzle solver, we do the following:

1. Define a class to encapsulate the state of a clue, including:  
   a. Number of digits
   b. Possible Values  
   c. Common digits with other clues: list of references to clue and digit
   d. Possible values of each digit
   e. Specific solution function
2. Define a class to encapsulate the state of the puzzle, including:  
   a. The clues
3. General solution algorithm:
   a. Maintain a list of clues to update, initialised with all clues
   b. Process list clues in turn, invoke clue solution function, updating the clue and puzzle state
   c. If clue updated add referring cells to list to update
   b. Loop until no more clues to update - puzzle solved
4. Post-processing
   a. If no unique solution has been found, then iterate over the clue possible values checking for solutions

The implementation of a specific puzzle includes these steps:

-   Create a folder for the puzzle
-   Create a main class for the puzzle, this must be added to the command line in bin/crossnumber.dart
-   Extend the Clue class, and initialize the puzzle clue to its possible values
-   Extend the Puzzle class
    -   Specify the puzzle Clue class
    -   If the puzzle has variables then extend the Variable class and define a VariableList

## Generic Puzzle (Future)

A bigger feature is to allow generic specification of a puzzle, with:

1. Meta-data to specify each clue
2. Generic solve function based on meta-data
3. Input/Ouput of puzzle definition

## GUI (Future)

GUI to:

1. Allow specification of puzzle
2. Show steps in solution of puzzle
