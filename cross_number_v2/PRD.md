# Product Requirements Document: Cross Number Solver v2

## 1. Introduction

This document outlines the requirements for a new, refactored version of the Cross Number Solver project. The current implementation has grown organically over time, leading to architectural challenges that make it difficult to maintain and extend. This project will create a new, robust, and scalable foundation for the solver, addressing the limitations of the original version.

## 2. Goals

*   To create a clear, maintainable, and extensible architecture for the cross number solver.
*   To unify the puzzle-solving logic into a single, consistent engine.
*   To improve the developer experience by simplifying the process of adding new puzzles.
*   To lay the groundwork for future features, such as a graphical user interface (GUI) and a generic puzzle definition format.

## 3. Non-Goals

*   A full-featured graphical user interface (GUI). While the new architecture should facilitate the future development of a GUI, the initial scope of this project is limited to a command-line interface (CLI).
*   Support for every single puzzle from the original version. The initial focus will be on migrating a representative subset of puzzles to the new architecture.
*   A public-facing API for third-party integrations.

## 3.1. Status

**Current Status:** In Progress

*   The core solver engine and puzzle definition components have been implemented.
*   The CLI is functional for running puzzles with known mappings.
*   The solver now supports expression inversion, allowing it to solve a wider range of puzzles.
*   The project is currently in the finalization phase, which includes code cleanup, documentation, and comprehensive testing.

## 4. Functional Requirements

### 4.1. Core Solver Engine

*   The system shall have a single, unified solver engine capable of solving all supported puzzle types.
*   The solver must be able to handle puzzles with complex logical and mathematical constraints.
*   The solver must support puzzles with variables that are shared across multiple clues.
*   The solver must be able to use backtracking to solve puzzles where the initial constraints are not sufficient to find a unique solution.

### 4.2. Puzzle Definition

*   The system shall use a clear, composable structure for defining puzzles, based on the following components:
    *   **Grid:** Represents the puzzle grid. Can be defined from a string representation.
    *   **Entry:** Represents a single entry in the grid. Entries can now have their own constraints.
    *   **Clue:** Represents the logic of a single clue.
    *   **Variable:** Represents a variable in the puzzle.
    *   **Constraint:** A new concept to define the rules and relationships between clues, entries, and variables.
*   The system must support puzzles with multiple grids and relationships between them.
*   The system must be able to handle puzzles where the mapping between clues and entries is not known initially and must be determined by the solver.

### 4.3. Expression Language

*   The system shall support a simple expression language for defining clue constraints.
*   The expression language shall support:
    *   Basic arithmetic operations: `+`, `-`, `*`, `/`, `^` (exponent).
    *   Variables, identified by name (e.g., `A`, `B`, `MyVariable`).
    *   References to grid entries, using the format `gridId.entryId` (e.g., `main.A1`).
    *   Generators for sequences of numbers, using the format `#generatorName` (e.g., `#prime`, `#fibonacci`).
    *   Monadic functions, using the format `$functionName` (e.g., `$squareroot`, `$isOdd`).
*   Intermediate calculations are performed using the `num` type, and the final results are converted to `int`.

### 4.4. Expression Inversion

*   The solver can now automatically invert expressions. 
*   When a clue's expression involves entries, the solver will automatically derive expressions for those entries.
*   For example, if a clue `1A` is defined as `B1 + C1`, the solver will automatically derive `B1` as `1A - C1` and `C1` as `A1 - B1`.
*   If more than one clue references an entry, then the entry will have multiple expressions.
*   This allows the solver to handle a wider range of puzzles where direct evaluation of clues is not possible.

### 4.5. Monadic Functions

The system shall provide a set of monadic functions that can be used in expressions to test properties of numbers. The following functions shall be supported:

*   `squareroot`: Returns the integer square root of a number, if it is a perfect square.
*   `isOdd`: Returns the number if it is odd.
*   `isEven`: Returns the number if it is even.
*   `isAscendingDigits`: Returns the number if its digits are in ascending order.
*   `isDescendingDigits`: Returns the number if its digits are in descending order.
*   `isUniqueDigits`: Returns the number if its digits are all unique.
*   `isPrime`: Returns the number if it is prime.
*   `isFibonacci`: Returns the number if it is a Fibonacci number.
*   `isTriangular`: Returns the number if it is a triangular number.
*   `isSquare`: Returns the number if it is a perfect square.
*   `isCube`: Returns the number if it is a perfect cube.

### 4.6. Generators

The system shall provide a set of generators that can be used in expressions to produce sequences of numbers. The following generators shall be supported:

*   `prime`: Generates prime numbers.
*   `triangular`: Generates triangular numbers.
*   `fibonacci`: Generates Fibonacci numbers.
*   `square`: Generates square numbers.
*   `cube`: Generates cube numbers.

### 4.7. Command-Line Interface (CLI)

*   The project shall provide a CLI for solving puzzles.
*   The CLI shall allow users to select a puzzle to solve and view the solution.

## 5. Non-Functional Requirements

### 5.1. Maintainability

*   The codebase shall be well-documented, with clear and consistent naming conventions.
*   The architecture shall be modular and decoupled, making it easy to modify and extend individual components without affecting the rest of the system.

### 5.2. Performance

*   The solver should be performant enough to solve typical puzzles in a reasonable amount of time.
*   The architecture should allow for performance optimizations to be made in the future.

### 5.3. Testability

*   The new architecture must be highly testable, with clear separation of concerns that allows for unit testing of individual components.
*   The project shall have a comprehensive suite of automated tests to ensure the correctness of the solver.

## 6. Architecture

The new architecture will be based on a decoupled, component-based design. The core components will be:

*   **`PuzzleDefinition`**: A container for all the elements of a puzzle.
*   **`Solver`**: The engine that solves the puzzle.
*   **`Expressable`**: An abstract class representing any puzzle element that can have a value derived from an expression. `Clue`, `Variable`, and `Entry` are all `Expressable`.
*   **Components**: `Grid`, `Entry`, `Clue`, `Variable`, and `Constraint` classes that can be composed to define a puzzle.

This architecture will provide a solid foundation for the future development of the Cross Number Solver.