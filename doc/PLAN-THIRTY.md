# Plan for Thirty Puzzle and Puzzle-Specific Constraints

This document outlines the plan to implement puzzle-specific constraints and solve the "Thirty" puzzle.

## 1. Generic Puzzle-Specific Constraint Mechanism

A generic mechanism will be created to allow puzzles to define their own specific constraints.

-   **`PuzzleConstraint` Class**: An abstract class `PuzzleConstraint` will be created with two methods:
    -   `propagate(PuzzleDefinition puzzle, {bool trace = false})` for general constraints.
    -   `enforceDistinct(PuzzleDefinition puzzle, {bool trace = false})` for constraints related to value uniqueness.
-   **`PuzzleDefinition`**: The `PuzzleDefinition` class will be extended to include a list of `PuzzleConstraint`s.
-   **`Solver`**: The solver will be updated to call the new constraint methods:
    -   `_propagateConstraints` will call the `propagate` method on the puzzle-specific constraints.
    -   `_enforceDistinctValues` will call the `enforceDistinct` method on the puzzle-specific constraints.

## 2. "Thirty" Puzzle Constraints Implementation

The specific constraints for the "Thirty" puzzle will be implemented in a new `ThirtyConstraint` class that extends `PuzzleConstraint`.

-   **`propagate` method**:
    -   **Even Digits**: This method will filter the `possibleValues` of all entries in both grids to ensure they only contain numbers with even digits.
    -   **Equal Digit Sum**: This method will calculate the min/max possible digit sum for each grid and enforce that the ranges overlap.
-   **`enforceDistinct` method**:
    -   **Fifteen Pairs of Even Digits**: This method will contain the logic for the fifteen pairs constraint. It will be called during the distinct value enforcement phase of the solver, allowing it to leverage the most up-to-date `possibleValues` of the entries.
-   **No Jumble**: This constraint is complex and will be deferred for now.

## 3. Implementation Steps

1.  **Update `PuzzleConstraint`**: Modify the abstract class `PuzzleConstraint` in `lib/src/models/puzzle_constraint.dart` to include the `enforceDistinct` method.
2.  **Update `Solver`**: Modify `_enforceDistinctValues` to call the `enforceDistinct` method on the puzzle-specific constraints.
3.  **Implement `ThirtyConstraint`**: Create the `ThirtyConstraint` class in `puzzles/thirty_constraints.dart` and implement the logic for the "Even Digits", "Equal Digit Sum", and "Fifteen Pairs" constraints in the appropriate methods.
4.  **Update `thirty.dart`**: Update the `thirty` puzzle definition to include an instance of `ThirtyConstraint`.
5.  **Testing**:
    -   Update the existing `test/thirty_test.dart` to test the "Thirty" puzzle.
    -   Add assertions to verify that the puzzle is solved correctly.
    -   Ensure that existing tests continue to pass.
