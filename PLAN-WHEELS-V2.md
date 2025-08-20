# Plan for Wheels Puzzle Features (v2)

This document outlines the plan to add new features to support the "wheels" puzzle. This includes new monadic functions and an equality operator in the expression language.

## Step 1: Implement New Monadic Functions

1.  **Update `MonadicFunctionRegistry`:** In `lib/src/expressions/monadic.dart`, add the new functions `$lte` (less than or equal to) and `$lt` (less than) to the `_functions` map.
2.  **Implement the functions:** Implement the logic for the new functions. `$lte` will return all numbers less than or equal to the argument, and `$lt` will return all numbers less than the argument.

## Step 2: Implement Equality Operator

1.  **Update `TokenType`:** In `lib/src/expressions/expression.dart`, add a new `EQUAL` token to the `TokenType` enum.
2.  **Update `Parser`:** In `lib/src/expressions/parser.dart`, update the `_scanToken` method to recognize the `=` character and create an `EQUAL` token.
3.  **Update `Parser` grammar:** Update the expression grammar in the `Parser` to handle the new `EQUAL` operator with the correct precedence. This will involve adding a new `_equality` method to the parser.
4.  **Update `Evaluator`:** In `lib/src/expressions/evaluator.dart`, update the `visitBinaryExpression` method to handle the new `EQUAL` operator. The logic will evaluate the left and right operands and return the values that are common to both.

## Step 3: Testing

1.  **Create a new test file:** Create a new test file `wheels_test.dart` to test the new functionality.
2.  **Add tests for monadic functions:** Add tests to verify that the new `$lte` and `$lt` functions work correctly.
3.  **Add tests for equality operator:** Add tests to verify that the new `=` operator works correctly with the expected precedence.
