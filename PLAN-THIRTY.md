# Plan for Thirty Puzzle and Puzzle-Specific Constraints

This document outlines the plan to implement puzzle-specific constraints and solve the "Thirty" puzzle.

## 1. Generic Puzzle-Specific Constraint Mechanism

A generic mechanism will be created to allow puzzles to define their own specific constraints.

-   **`PuzzleConstraint` Class**: An abstract class `PuzzleConstraint` will be created with a `propagate(PuzzleDefinition puzzle, {bool trace = false})` method. Puzzles can provide a list of `PuzzleConstraint` objects.
-   **`PuzzleDefinition`**: The `PuzzleDefinition` class will be extended to include a list of `PuzzleConstraint`s.
-   **`Solver`**: The solver's `_propagateConstraints` method will be updated to iterate through the puzzle's `PuzzleConstraint`s and call their `propagate` method in each iteration of the main solving loop.

## 2. "Thirty" Puzzle Constraints Implementation

The specific constraints for the "Thirty" puzzle will be implemented in a new `ThirtyConstraint` class that extends `PuzzleConstraint`.

-   **Even Digits**: The `propagate` method will filter the `possibleValues` of all entries in both grids to ensure they only contain numbers with even digits.
-   **Fifteen Pairs of Even Digits**: This is a key constraint. The `propagate` method will:
    1.  For each pair of matching cells in the two grids, determine the set of possible digits for each cell based on the `possibleValues` of the entries passing through it.
    2.  Filter the possible digits for each cell based on the 15 allowed pairs. For example, if a digit in one cell has no valid partner in the other cell, it will be removed.
    3.  Propagate these digit-level changes back to the `possibleValues` of the affected entries.
-   **Equal Digit Sum**: The `propagate` method will:
    1.  Calculate the minimum and maximum possible sum of digits for each grid.
    2.  Enforce the constraint that the possible ranges of the two sums must overlap. This can help prune the search space.
-   **No Jumble**: This constraint is complex and will be deferred for now.

## 3. Implementation Steps

1.  **Create `PuzzleConstraint`**: Create the abstract class `PuzzleConstraint` in a new file `lib/src/models/puzzle_constraint.dart`.
2.  **Update `PuzzleDefinition`**: Add `List<PuzzleConstraint> puzzleConstraints` to the `PuzzleDefinition` class.
3.  **Update `Solver`**: Modify `_propagateConstraints` to call the `propagate` method on the puzzle-specific constraints.
4.  **Implement `ThirtyConstraint`**: Create the `ThirtyConstraint` class in `puzzles/thirty_constraints.dart` and implement the logic for the "Even Digits", "Fifteen Pairs", and "Equal Digit Sum" constraints.
5.  **Update `thirty.dart`**: Update the `thirty` puzzle definition to include an instance of `ThirtyConstraint`.
6.  **Testing**:
    -   Update the existing `test/thirty_test.dart` to test the "Thirty" puzzle.
    -   Add assertions to verify that the puzzle is solved correctly.
    -   Ensure that existing tests continue to pass.