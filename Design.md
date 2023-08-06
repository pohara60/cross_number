# Design

## Introduction

Cross Number puzzles have these features:

-   It is a grid, similar to a crossword grid, with numbered clues across and down
-   The clues specify conditions for the Value
-   The Values are distinct
-   Grid entries cannot start with 0
-   Grid entries are normally the clue value, but in some puzzles the values are transformed into the entries

Many puzzles use Variables in the clues, with these features:

-   The variables have names
-   They have distinct values from a set of possible values
-   The possible values may be specified by rule

Types of clue:

- A "type" of number:
  - Even or Odd
  - Prime
  - Square, Cube or Power
  - Triangular, Square Pyramidal
  - Lucasian
  - Palindrome
  - Happy
  - Lucky
  - Fibonacci
  - Ascending or Descending or Consecutive digits
  - Multiple of a Value
  - Product of N distinct Primes
  - Sum of 2 consecutive Squares
  - Half of a Value
  - Multiple of a variable or other clue value
  - Reverse or Jumble of other clue value
  - Value plus or minus other clue value
  - Digit product or sum is other clue value
  - Multiplicative persistence
  - Sum of all digits in puzzle
  - Multiple conditions
- Expression involving variables and/or other clue values

Unusual puzzles:
- Clue numbers also have an expression
- Clue value has decimals
- Clue value is fraction with numberatro and denominator
- Variables take two values for Across and Down clues


## Generic Solution

In order to make a general puzzle solver, we do the following:

1. Define a class to encapsulate the state of a clue, including:  
   a. Number of digits
   b. Possible Values  
   c. Common digits with other clues: list of references to clue and digit
   d. Possible values of each digit
   e. Specific solution function to generate clue values
2. Define a class to encapsulate the state of the puzzle, including:  
   a. The clues
3. General solution algorithm:
   a. Maintain a list of clues to update, initialised with all clues
   b. Process list clues in turn, invoke clue solution function, updating the clue and puzzle state
   c. If clue updated add referring cells to list to update
   b. Loop until no more clues to update - puzzle solved
4. Post-processing
   a. If no unique solution has been found, then iterate over the clue possible values checking for solutions

## Clue Expressions

The expression syntax currently includes these tokens:
- Number is sequence of digits
- Binary Operators + - * / ^
- Unary Operators - √ !
- Parentheses ()
- Equality =
- Variables are single letters
- Sequences of nunbers, variables and parentheses have implicit multiplication

Enhancements:
- Value generating functions #primes, #squares etc
- Monadic functions $dp, $ds

## Clue Solution

Process
1. Update digit possibles from overlapping clues
2. Get clue values
3. Update clue values
4. Update digit possibles from values
5. Update variable possible values

### Get Clue Values Expression

1. Get variable values, get cartesian product count, if too high then exit
2. For each combination of variables
   a. Evaluate expression
   b. If value not right length skip
   c. Validate value - digits check or custom function
   d. If valid save value and variable values

### Enhancements

Generating functions return multiple values, so expression evaluator is a generator.

Logical functions do not return invalid values.

When stop calling generator? When expression is too high? Need limits applied to every sub-expression, to filter values in desired range

## Specific Puzzle

The implementation of a specific puzzle includes these steps:

-   Create a folder for the puzzle
-   Create a main class for the puzzle, this must be added to the command line in bin/crossnumber.dart
    -   Initialize the puzzle, creating the clues and references between them
    -   Define solve functions for each clue, implementing the clue logic
-   Extend the Clue class, and initialize the puzzle clue to its possible values
-   Extend the Puzzle class
    -   Specify the puzzle Clue class
    -   If the puzzle has variables then extend the Variable class and define a VariableList

