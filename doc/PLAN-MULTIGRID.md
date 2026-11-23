# Plan for Multi-Grid Support

This document outlines the plan to enhance the Cross Number Solver to fully support puzzles with multiple grids.

## 1. Goals

-   Enable the solver to handle puzzles with two or more grids.
-   Establish a clear and consistent naming convention for entries and clues in multi-grid puzzles.
-   Ensure backward compatibility with existing single-grid puzzles.
-   Variables will be shared across all grids.

## 2. Naming Conventions

-   **Multi-Grid Puzzles**: In puzzles with more than one grid, all entries and clues must be referenced in expressions using a grid prefix, e.g., `L.A1`, `R.D2`. The entry and clue maps in `PuzzleDefinition` will also use these prefixed names as keys.
-   **Single-Grid Puzzles**: For puzzles with a single grid, the grid prefix is optional. If the grid is named "main", references like `A1` will be resolved to the "main" grid. This ensures backward compatibility.

## 3. `PuzzleDefinition` Changes

The `PuzzleDefinition` class will be updated to be the central point for handling multi-grid logic.

-   **`PuzzleDefinition.fromString`**: This factory will be updated to support multiple grids with identical structures.
    -   It will accept an optional `List<String> gridNames` parameter.
    -   If `gridNames` is provided, a `Grid` object will be created for each name in the list, based on the same `gridString`.
    -   If `gridNames` is not provided or is empty, the factory will create a single grid named "main" to maintain backward compatibility.
    -   When using multiple grids, entry and clue names in the provided maps must be prefixed with the corresponding grid name (e.g., `L.A1`, `R.A1`).
-   **`getExpressable(String name)`**: This method will be updated to handle prefixed names.
    -   If `name` contains a `.`, it will be parsed as `gridName.expressableId`. The method will then look for an entry or clue with that ID in the specified grid.
    -   If `name` does not contain a `.`, it will be treated as a variable name. If not found as a variable, and the puzzle is a single-grid puzzle with a "main" grid, it will be treated as a clue or entry from the "main" grid.
-   **Entry/Clue Initialization**: The `PuzzleDefinition` constructor will be updated to correctly link clues and entries in a multi-grid setup. It will need to handle the prefixed names.

## 4. Parser and Evaluator

-   The expression parser already supports the `grid.entry` syntax, which is a good foundation.
-   The `Evaluator` will rely on the enhanced `PuzzleDefinition.getExpressable` to resolve references. No major changes are expected in the evaluator itself, as long as the `PuzzleDefinition` provides the correct `Expressable` objects.

## 5. Solver Logic

-   The core solver logic in `Solver` is largely grid-agnostic and should not require significant changes. The key is to ensure that the `Expressable`s are correctly defined and resolved by `PuzzleDefinition`.
-   The grouping logic (`TransitiveExpressableGrouper` and `findClueGroups`) operates on `Expressable`s and their references. As long as the references are correctly extracted (which they are, as `grid.entry` is parsed as a variable), the grouping should work as expected.

## 6. Implementation Steps

1.  **Update `PuzzleDefinition`**:
    -   Modify `getExpressable` to handle prefixed names.
    -   Update the constructor to correctly initialize multi-grid puzzles.
    -   Add documentation to `fromString` to clarify its single-grid limitation.
2.  **Update `thirty.dart`**:
    -   Modify the puzzle definition in `puzzles/thirty.dart` to conform to the new naming conventions. This will serve as the primary test case.
3.  **Testing**:
    -   Create a new test file, `test/multigrid_test.dart`, to specifically test the multi-grid functionality.
    -   Test the `thirty.dart` puzzle to ensure it solves correctly.
    -   Run existing single-grid puzzle tests to ensure no regressions.
