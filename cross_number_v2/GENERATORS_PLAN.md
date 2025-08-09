# Generators Feature Development Plan (Revised)

This document outlines the plan for implementing generator functions in the expression engine, including support for complex expressions that combine generators with other operators and variables.

## 1. Update the Expression Parser

*   Modify the parser to recognize generator syntax (e.g., `#prime`) as a value-producing token, similar to a variable or a number.
*   The parser will create a `GeneratorExpression` node in the expression tree that holds the name of the generator.

## 2. Create a Generator Registry

*   Design a registry to hold the different generator functions.
*   This will allow for easy extension with new generators in the future.
*   The registry will map generator names (e.g., "prime") to their corresponding implementation.

## 3. Implement the Generator Functions

*   Create the initial set of generator functions:
    *   `#prime`
    *   `#triangular`
    *   `#fibonacci`
    *   `#square`
*   These functions will be context-independent and will produce a sequence of numbers. The filtering of these values will be handled by the evaluator.

## 4. Update the Expression Evaluator (Major Change)

*   The `Evaluator` will be updated to handle expressions that mix generators with other operators and variables.
*   When the evaluator encounters a `GeneratorExpression` node, it will look up the generator function in the registry and get the list of generated values.
*   The evaluator will be modified to perform arithmetic operations on lists of values. For example, in the expression `#triangular + D2`, the evaluator will compute the Cartesian product of the two lists of values, applying the addition operator to each pair.

## 5. Update the `ExpressionConstraint`

*   The `ExpressionConstraint` will use the updated evaluator to get the final set of possible values for the entire expression.
*   This set of values will then be used to constrain the possible values of the clue.

## 6. Testing

*   Create unit tests for the updated parser to ensure it correctly identifies generators.
*   Create unit tests for each generator function to verify they produce the correct sequences.
*   Create integration tests for the evaluator with complex expressions, such as:
    *   `#prime + 1`
    *   `#square * A1`
    *   `#fibonacci - #triangular`