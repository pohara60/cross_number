# Plan for Implementing Entry Expressions

This plan outlines the steps to implement the ability to derive and use expressions for puzzle entries from clue expressions. This will enable solving puzzles where clue values are known, but the expressions involve other entries.

## Step 1: Update Models for Multiple Expressions

1.  **Update `Expressable` class:**
    *   Modify the `Expressable` class in `lib/src/models/expressable.dart` to handle multiple expression trees.
    *   Each expression tree will have its own set of associated variables.
    *   The `setExpression` method will be updated to add a new expression tree and its variables.

2.  **Update `Entry` model:**
    *   The `Entry` class already extends `Expressable`, so it will inherit the ability to have multiple expressions.
    *   No further changes are needed to the `Entry` model itself in this step.

3.  **Update `Clue` and `Variable` models:**
    *   Update the `Clue` and `Variable` classes to use the new multiple expression tree structure of `Expressable`.

4.  **Update `Evaluator`:**
    *   Modify the `Evaluator` in `lib/src/expressions/evaluator.dart` to handle the list of expression trees in `Expressable`.
    *   The `evaluate` method will now iterate over all expression trees, evaluate each one, and return the intersection of the results.

## Step 2: Expression Inversion

1.  **Create `ExpressionInverter` class:**
    *   Create a new file `lib/src/expressions/inverter.dart`.
    *   This class will be responsible for inverting clue expressions to derive entry expressions.

2.  **Implement inversion logic:**
    *   The `ExpressionInverter` will have a method that takes a clue's `expressionTree` and a target `Entry` as input.
    *   It will traverse the expression tree and generate a new expression tree for the `Entry`.
    *   This will involve handling different types of expression nodes (e.g., binary operators, constants, variables).
    *   For example, if the clue expression is `A1 + D1 = 10`, and we are inverting for `A1`, the resulting entry expression would be `10 - D1`.

## Step 3: Integrate Expression Inversion into Puzzle Definition

1.  **Update `PuzzleDefinition`:**
    *   In the `PuzzleDefinition` constructor, after initializing the clues, iterate through the clues.
    *   For each clue with an `ExpressionConstraint`, use the `ExpressionInverter` to generate expressions for each entry in the clue's expression.
    *   Add the newly generated expressions to the respective entries using the `setExpression` method.

## Step 4: Testing

1.  **Unit tests for `ExpressionInverter`:**
    *   Create a new test file `test/inverter_test.dart`.
    *   Add unit tests to verify the expression inversion logic for various types of expressions.

2.  **Update existing tests:**
    *   Update existing tests for the solver, models, and evaluator to reflect the changes.

3.  **`increasing_primes` puzzle test:**
    *   Create a new test for the `increasing_primes` puzzle.
    *   This test will define the puzzle with clue expressions involving entries.
    *   It will then run the solver and verify that the puzzle is solved correctly using the new entry expression logic.

## Step 5: Refactor and Cleanup

1.  **Review and refactor:**
    *   Review the new code for clarity, efficiency, and adherence to the project's coding style.
    *   Refactor as needed.

2.  **Update documentation:**
    *   Update the `README.md` and other relevant documentation to explain the new feature.
