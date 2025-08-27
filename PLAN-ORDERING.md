# Plan for Implementing Ordering Constraint

This document outlines the step-by-step plan to implement the `OrderingConstraint` feature. Each step is designed to be a small, incremental change that leaves the project in a compilable and testable state.

## Step 1: Create the `OrderingConstraint` Model

1.  **Create a new file** `lib/src/models/ordering_constraint.dart`.
2.  **Define the `OrderingConstraint` class** that extends `Constraint`.
3.  The class will have boolean flags, `allClues` and `allVariables`, to easily apply the constraint to all clues or all variables. It will also have an optional `List<String>` of `Expressable` IDs for more specific orderings. The constructor will ensure that either a flag is set or a list is provided.

After this step, the project will compile, but the new constraint will not be used yet.

## Step 2: Add `OrderingConstraint` to `PuzzleDefinition`

1.  **Modify the `PuzzleDefinition` class** in `lib/src/models/puzzle_definition.dart` to accept a list of `OrderingConstraint`s in its constructor.
2.  **Store the `OrderingConstraint`s** in a new field within the `PuzzleDefinition`.

After this step, puzzles can be defined with ordering constraints, but the solver will not yet enforce them.

## Step 3: Update the Solver to Enforce the `OrderingConstraint`

1.  **Modify the `_propagateConstraints` method** in `lib/src/solver.dart`.
2.  **Add logic to iterate** through the `orderingConstraints` of the `PuzzleDefinition`.
3.  For each constraint, iterate through the list of `Expressable`s in order.
4.  For each adjacent pair of `Expressable`s (X, Y) in the list, enforce the `X < Y` constraint by filtering their `possibleValues`:
    *   Update `X.possibleValues` to remove any value `x` for which there is no `y` in `Y.possibleValues` such that `x < y`. This is equivalent to `x < max(Y.possibleValues)`.
    *   Update `Y.possibleValues` to remove any value `y` for which there is no `x` in `X.possibleValues` such that `x < y`. This is equivalent to `y > min(X.possibleValues)`.
5.  Ensure this propagation continues until no more changes occur.

After this step, the solver will be able to enforce the new constraint.

## Step 4: Update the `sum_squares.dart` Puzzle

1.  **Modify the existing file** `puzzles/sum_squares.dart`.
2.  **Add an `OrderingConstraint`** to the puzzle definition to specify that its clues are in ascending order of value.

This will provide a concrete test case for the new feature.

## Step 5: Create a Unit Test for the `OrderingConstraint`

1.  **Create a new file** `test/ordering_constraint_test.dart`.
2.  **Write a unit test** that defines a simple puzzle with an `OrderingConstraint`.
3.  **Run the solver** on the test puzzle.
4.  **Verify that the solver correctly prunes** the `possibleValues` of the constrained `Expressable`s according to the ordering rule.

This will ensure the feature is working as expected and protect against future regressions.
