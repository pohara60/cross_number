# Plan for Refactoring the Solver

This document outlines the plan to refactor the `Solver` to use a single loop over a pre-computed map of `Expressable` objects. This will make the `_solveKnownMapping` method cleaner and more efficient.

## Step 1: Add `expressables` to `PuzzleDefinition`

1.  **Add `expressables` map:** Add a `Map<String, Expressable>` to the `PuzzleDefinition` class.
2.  **Populate `expressables`:** In the `PuzzleDefinition` constructor, populate the `expressables` map with all clues and variables that have expression constraints, using their ID as the key.

## Step 2: Refactor `_solveKnownMapping`

1.  **Use single loop:** In the `_solveKnownMapping` method of the `Solver`, replace the separate loops for clues and variables with a single loop over the `puzzle.expressables.values` list.
2.  **Call `solveExpression`:** In the loop, call the `solveExpression` method for each `Expressable` object.

## Step 3: Testing

1.  **Run all tests:** Run all existing tests to ensure that the refactoring has not introduced any regressions.
