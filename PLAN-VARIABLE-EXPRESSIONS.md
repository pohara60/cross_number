# Plan for Variable Expression Constraints

This document outlines the plan to add support for expression constraints on variables. This will allow for more complex relationships between variables in the puzzle. The implementation will be done in a way that avoids code duplication and ensures that existing functionality and tests remain working after each step.

## Step 1: Update `Variable` Class (DONE)

1.  **Add constraints to `Variable`:** Add a `List<Constraint>` to the `Variable` class to hold expression constraints.
2.  **Update `Variable` constructor:** Update the `Variable` constructor to accept an optional list of constraints.

## Step 2: Create a Generic `solveExpression` Method (DONE)

1.  **Create a common interface:** Create a new abstract class or interface, for example `Expressable`, that will be implemented by both `Clue` and `Variable`. This interface will define the properties and methods needed for expression evaluation:
    *   `possibleValues`: A `Set<int>?` of the possible values.
    *   `expressionTree`: The parsed `Expression` tree.
    *   `variables`: A `List<String>` of the variable names in the expression.
    *   `min`: A getter for the minimum possible value.
    *   `max`: A getter for the maximum possible value.
2.  **Handle `null` `possibleValues`:** Note that for `Clue` objects, `possibleValues` may be `null` initially if the clue is not mapped to an entry and its length is unknown. The `solveExpression` method will need to handle this case and defer evaluation until the `possibleValues` are known.
3.  **Create `solveExpression` method:** Create a new generic method `solveExpression` in the `Solver`. This method will take an `Expressable` object as input and will contain the logic for evaluating the expression and updating the possible values of the object and any referenced variables. This will extract the common logic from the current `Clue.solve` method.

## Step 3: Refactor `Clue` to implement `Expressable` (DONE)

1.  **Implement `Expressable` in `Clue`:** Make the `Clue` class implement the new `Expressable` interface.

## Step 4: Implement `Expressable` in `Variable` (DONE)

1.  **Implement `Expressable` in `Variable`:** Make the `Variable` class implement the new `Expressable` interface.

## Step 5: Update the `Solver`

1.  **Call `solveExpression` for variables:** In the `_solveKnownMapping` method of the `Solver`, add a loop to iterate over the variables and call the `solveExpression` method for each variable.
2.  **Call `solveExpression` for clues:** Update the existing loop for clues to call `solveExpression` directly.

## Step 6: Testing

1.  **Add new tests:** Create a new test file to test the functionality of variable expression constraints. The tests should verify that the solver can correctly solve puzzles with these new constraints.
