# Plan for Supporting Dependent Clues

This document outlines the plan to add support for solving puzzles with dependent clues more efficiently. The new strategy will be optional and will not break existing functionality.

## Step 1: Introduce `ClueGroup`

1.  **Create `ClueGroup` class:** Create a new class `ClueGroup` that contains a list of clue IDs and a list of variable names that are shared among these clues.

## Step 2: Implement `PuzzleDefinition.findClueGroups`

1.  **Create `findClueGroups` method:** Create a new method `findClueGroups` in the `PuzzleDefinition` class. This method will:
    *   Analyze the variable dependencies of all clues.
    *   Identify groups of clues that share the same set of variables.
    *   Create `ClueGroup` objects for each identified group.

## Step 3: Implement `solveClueGroup` in `Solver`

1.  **Create `solveClueGroup` method:** Create a new method `solveClueGroup` in the `Solver` class. This method will take a `ClueGroup` and a map of pinned variables as input.
2.  **Implement the recursive logic:** The `solveClueGroup` method will:
    *   Take the first clue in the group and evaluate it with the current pinned variables.
    *   For each valid result (`EvaluationResult`), recursively call `solveClueGroup` with the remaining clues in the group and the updated map of pinned variables from the result.
    *   The base case for the recursion is when there are no more clues in the group to evaluate. At this point, the combination of variable values is valid.
    *   Collect all valid combinations of variable values.
    *   Update the `possibleValues` for the clues and variables in the group based on the collected valid combinations.

## Step 4: Update the `Solver` to Use `solveClueGroup`

1.  **Modify `_solveKnownMapping`:** In the `_solveKnownMapping` method in the `Solver`, call the `findClueGroups` method to get the clue groups.
2.  **Call `solveClueGroup`:** For each `ClueGroup`, call the new `solveClueGroup` method.
3.  **Handle ungrouped clues:** The existing logic for solving individual clues will remain to handle clues that are not part of any group.

## Step 5: Testing

1.  **Create a new test file:** Create a new test file `after_nicholas_test.dart` to test the new functionality with the "after_nicholas" puzzle.
2.  **Add tests:** Add tests to verify that the solver can correctly solve the puzzle using the new `ClueGroup` strategy.
