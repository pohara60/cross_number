# EvenOdder Puzzle Solver

## Introduction

The EvenOdder puzzle has these features:

-   It is a grid, similar to a crossword grid, with numbered clues across and down
-   The clues are specified as expressions involving letters
-   The 16 letters are distinct numbers in the range 2 to 33
    -   A letter has different consecutive even and odd values in the Across and Down clues
-   Grid entries are unique and cannot start with 0

## Notes

Just used the automatic solveVariableExpressionEvaluator to solve the puzzle, i.e. no hand-written solution functions for slow clues.

See [link](../sequences/README.md) for more discussion.

## Notes

May need refactoring...

CrossNumber.solveClue(clue)
CrossNumber.updateVariables(variable, values)
VariablePuzzle.updateVariables(variable, possibleValues)
VariableList.updateVariables(variable, possibleValues)

VariablePuzzle.solveVariableExpressionEvaluator
VariableClue.ExpressionEvaluator.evaluate(clue.variableReferences, product)

VariableClue()
ExpressionEvaluator()
