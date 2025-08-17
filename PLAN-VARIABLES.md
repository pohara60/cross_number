# Plan for Optimizing Variable Updates in the Solver

This document outlines the plan to refactor the solver to improve performance by updating variables more efficiently.

The current implementation solves clues and then separately propagates the changes to variables. This is slow. The proposed change is to have the `evaluate` function return the possible values of all variables in the expression that yielded a result. This will allow for immediate updates to the variables, making the `propagateConstraints` function more efficient.

To keep the code stable, we will introduce the changes incrementally.

## Step 1: Modify the `Evaluator` to Return Variable Values (DONE)

1.  **Create a new result class:** Create a new class `EvaluationResult` that holds both the calculated value and a map of the variable values that produced it.
2.  **Create `Evaluator.evaluateWithVariables`:** Create a new method `evaluateWithVariables` in `evaluator.dart` that returns a list of `EvaluationResult` objects. This will be a copy of the existing `evaluate` method, but with the new return type.
3.  **Update `Evaluator` private methods:** Update the private methods in the `Evaluator` to work with the new `EvaluationResult` class.
4.  **Note:** The internal values in expression evaluation are num, while the final values are int. So there are two classes, `EvaluationResult` and `EvaluationFinalResult`

## Step 2: Create a New `Clue.solveWithVariables` Method (DONE)

1.  **Create `Clue.solveWithVariables`:** Create a new method `solveWithVariables` in `clue.dart` that uses the new `evaluateWithVariables` method.
2.  **Update variable values:** In `Clue.solveWithVariables`, after evaluating the expression, iterate through the results and collect all possible values for each variable. Update the `possibleValues` of each variable in the puzzle with the new, more restricted set of values.

## Step 3: Refactor the `Solver`

1.  **Call `Clue.solveWithVariables`:** In the `Solver`, call `Clue.solve2` instead of `Clue.solve`.
2.  **Remove redundant code:** Remove the code in `_propagateConstraints` in `solver.dart` that updates variables from clue values.

## Step 4: Cleanup

1.  **Remove `Clue.solve`:** Once the new implementation is stable, remove the old `Clue.solve` method.
2.  **Rename `Clue.solveWithVariables`:** Rename `Clue.solveWithVariables` to `Clue.solve`.
3.  **Remove `Evaluator.evaluate`:** Remove the old `Evaluator.evaluate` method.
4.  **Rename `Evaluator.evaluateWithVariables`:** Rename `Evaluator.evaluateWithVariables` to `Evaluator.evaluate`.

## Step 5: Review and Update Tests

1.  **Review existing tests:** Review the existing tests in `test/` to ensure they are still valid after the changes.
2.  **Update tests:** Update any tests that are broken by the changes.
3.  **Add new tests:** Add new tests to specifically cover the new variable update logic.