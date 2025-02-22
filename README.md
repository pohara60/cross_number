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

The puzzles are presented in the order they were developed. Some have been re-developed with later versions of the solver, these have the suffix _2_.

The Notes column in the table below refer to the type of clue solver logic, which has progressed over time:
- Manual solver, e.g. [solveA15](lib/primecuts/primecuts.dart).
- Variable solver with callback for expression, e.g. [solveA2 calls solveVariableExpression](lib/sequences/sequences.dart)
- Expression solver with generic expression logic, e.g. [solveVariableExpressionEvaluator](lib/sequences/sequences.dart)
- Expression solver with generic expression logic including generated values, e.g. [solveExpressionEvaluator](lib/dicenets2/dicenets2.dart)
 
The Clues, Entries and Variables columns refer to whether and how these entities are processed:
- Entries may be Manual, Variable or Expression solvers, as defined above
- Clues refers to Clues separate to Entries, in which case Entries are mapped to Clues, or updated by CLues, or referenced by CLues
- Variables, if present, may simply be limited or may have Expression solvers

| Puzzle | Type | Notes | Clues | Entries | Variables |
|--------|------|-------|-------|---------|-----------|
| [DiceNets](lib/dicenets/README.md) | Simple | Manual Solvers | | Manual | |
| [PrimeCuts](lib/primecuts/README.md) | Variable | Manual Solvers, 2 values per clue | | Manual | Manual |
| [Letters](lib/letters/README.md) | Variable | Variable Solvers | | Variable | Limited  |
| [Distancing](lib/distancing/README.md) | Simple | Manual Solvers | | Manual | |
| [Frequency](lib/frequency/README.md) | Simple | Manual Solvers, post-processing | | Manual | |
| [Sequences](lib/sequences/README.md) | Variable | Expression Solvers | | Expression | Limited |
| [CarteBlanche](lib/carteblanche.dart) | Custom | Custom | | | |
| [EvenOdder](lib/evenodder/README.md) | Variable | Expression Solvers | | Expression | Limited with 2 values |
| [Instruction](lib/instruction/README.md) | Custom | Manual Solvers, post-processing | | Manual | |
| [Root66](lib/root66/README.md) | Variable | Expression Solvers, 2 values per clue | | Expression | Limited |
| [DiceNets2](lib/dicenets2/README.md) | Simple | Expression Solvers | | Expression | |
| [No21](lib/no21/README.md) | Variable | Expression Solvers for Clues, post-processing | Expression | Mapped to Clues | Limited |
| [Root66_2](lib/root66_2/README.md) | Variable | Expression Solvers, 2 values per clue | Expression | Updated by Clue | Limited |
| [Partners](lib/partners/README.md) | Simple | Expression Solvers | | Expression | |
| [Wheels](lib/wheels/README.md) | Variable | Expression Solvers, including Variables | | Expression | Expression |
| [Prime](lib/prime/README.md) | Simple | Expression Solvers | | Expression | |
| [Chessboard](lib/chessboard/README.md) | Simple | Expression Solvers | | Expression | |
| [Particular](lib/particular/README.md) | Variable | Expression Solvers | | Expression | Limited |
| [Pandigitals](lib/pandigitals/README.md) | Variable | Custom Solve, cf [AlmostFermat](lib/almostfermat/README.md) | Multiple Expressions, Constrained | Expressions, Referenced by Clues | Variable Group |
| [ABCD](lib/abcd/README.md) | Variable | Expression Solvers | | Expression | Ordered |
| [Columns](lib/columns/README.md) | Simple | Expression Solvers | | Expression | |
| [Knights](lib/knights/README.md) | Simple | Expression Solvers | | Expression | |
| [TwoPrimes](lib/twoprimes/README.md) | Variable | Expression Solvers | | Expression | 2 Primes per Variable |
| [IncreasingFibonnaci](lib/increasingfibonnaci/README.md) | Simple | Expression Solvers | Expression, Constrained | Referenced by Clues |  |
| [IncreasingPrime](lib/increasingprime/README.md) | Simple | Expression Solvers | Expression, Constrained | Referenced by Clues |  |
| [DieAnotherDay](lib/dieanotherday/README.md) | Simple | 3 Grids, Expression Solvers | | Expression, Constrained triples |  |
| [Thirty](lib/thirty/README.md) | Simple | 2 Grids, Manual Solvers | | Expression, Constrained pairs |  |
| [CubeSandwich](lib/cubesandwich/README.md) | Simple | Expression Solvers | | Expression |  |
| [PowerPlay](lib/powerplay/README.md) | Simple | Expression Solvers | | Expression |  |
| [AlmostFermat](lib/almostfermat/README.md) | Simple | Expression Solvers, cf [Pandigitals](lib/pandigitals/README.md) | Multiple Expressions, Constrained | Referenced by Clues |  |
| [Knights2](lib/knights2/README.md) | Simple | Expression Solvers | | Expression | |
| [TwentyFive](lib/TwentyFive/README.md) | Simple | Pair Puzzles (L+R), Expression Solvers | | Expression, Constrained pairs | |
| [Couplets](lib/couplets/README.md) | Simple | Expression Solvers | Expression, Constrained | Referenced by Clues |  |
| [UnderSix](lib/UnderSix/README.md) | Simple | Expression Solvers | | Expression | |
| [SumSquares](lib/SumSquares/README.md) | Variable | Expression Solvers | Expression, Constrained | Referenced by Clues | Primes |
| [Combinations](lib/Combinations/README.md) | Variable | Two Expression Solvers for Clues | Expression | Mapped to Clues | Limited |
| [TriangularPairs](lib/TriangularPairs/README.md) | Simple | Expression Solvers | | Expression, Constrained pairs | |
| [PrimeKnight](lib/PrimeKnight/README.md) | Simple | Expression Solvers  | | Expression, Constrained by Knights Tour | |
| [Factors](lib/Factors/README.md) | Variable | Expression Solvers for Cells | | Constrained | Primes |
| [Transformation](lib/Transformation/README.md) | Variable | Expression Solvers, post-processing | | Expression | Limited Cubes |
| [SquaresTriangles](lib/SquaresTriangles/README.md) | Simple | Expression Solvers | | Expression, Constrained | |
| [OpposingDigitSum](lib/OpposingDigitSum/README.md) | Simple | Related Clue Expression Solvers | Expression | Referenced by Clues | |
| [Eraser](lib/Eraser/README.md) | Simple | Expression Solvers | | Expression | |
| [Primania](lib/Primania/README.md) | Simple | Expression Solvers | Expression | Mapped to Clues | |
| [ABCDE](lib/ABCDE/README.md) | Variable | Expression Solvers | | Expression | |
| [Tetromino](lib/Tetromino/README.md) | Variable | Expression Solvers | Expression | Mapped to Clues using Tetrominoes | |
| [FourSeasons](lib/FourSeasons/README.md) | Simple | Expression Solvers | | Expression | |
| [Virus](lib/Virus/README.md) | Simple | Related Clue Expression Solvers | Expression | Clue Expression | |
| [TakeTwoOrThree](lib/TakeTwoOrThree/README.md) | Simple | Expression Solvers | Expression | Function Expression | |
| [Different](lib/Different/README.md) | One Variable | | Entry Differences | Mapped to Clues | |
| [SevenRules](lib/SevenRules/README.md) | Simple | Expression Solvers | | Expression | |
| [CyclingPrimes](lib/CyclingPrimes/README.md) | Simple | Expression Solvers | Expression | Mapped to Clues | |
| [NumeriItaliano](lib/NumeriItaliano/README.md) | Variable | Expression Solvers | | Expression | Limited |
| [WorkingBack](lib/WorkingBack/README.md) | Simple | Expression Solvers | | Expression | |
| [TwoByTwo](lib/TwoByTwo/README.md) | Simple | Expression Solvers | | Expression, Constrained | |
| [WorkingBack2](lib/WorkingBack2/README.md) | Simple | Expression Solvers | | Expression | |
| [MagicArray](lib/MagicArray/README.md) | Simple | Expression Solvers | | Expression, Constrained | |
| [AfterNicholas](lib/AfterNicholas/README.md) | Variable | Expression Solvers | | Expression | Limited |
| [Excuses](lib/Excuses/README.md) | Variable | Recursive Expression Solvers | Multiple Expressions | Mapped to Clues | Limited |


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
    -   puzzle entry is the clue class with EntryMixin
-   Extend the Variable class if there are variables, or ExpressionVariable for expression solving
-   Extend the Puzzle class
    -   Specify the puzzle Clue and Entry classes
    -   If the puzzle has variables, or using the generic expression solver, extend the VariablePuzzle class
    -   Perhaps override solve() or postprocessing() methods for additional logic

It is recommended to use the generic expression solver for simple puzzles, with or without variables. Less common puzzles require custom logic, e.g. 
- Variables take two values for Across and Down clues
- Clue numbers also have an expression
- Clue value has decimals
- Clue value is fraction with numerator and denominator

The skeleton code for a puzzle can be generated from an Excel definition using https://github.com/pohara60/crossnumber_generator.
