# Plan Checklist

- [x] Phase 1: Core Model and Project Setup
- [x] Phase 2: Expression Engine and Constraint System
- [x] Phase 3: The Core Solver
- [x] Phase 4: Advanced Solver Features
- [x] Phase 5: Puzzle Migration and CLI
- [x] Phase 6: Finalization

# Implementation and Testing Plan

**Project Status: All implementation phases are complete. The project is now in the finalization and documentation stage.**

This document outlines the development and testing plan for the Cross Number Solver v2 project. The project is divided into distinct phases, each with specific implementation goals and corresponding testing strategies.

---

### Phase 1: Core Model and Project Setup

**Objective:** Establish the project structure and define the core data model classes. This phase focuses on creating the foundational building blocks of the application.

**Implementation Steps:**
1.  Initialize a new Dart project with `dart create`.
2.  Create placeholder files for the core model classes in the `lib/src/models/` directory:
    *   `grid.dart`: Represents the physical puzzle grid.
    *   `entry.dart`: Represents a single across/down entry in the grid.
    *   `variable.dart`: Represents a named variable with a domain of possible values.
    *   `clue.dart`: Represents the logical component of a clue.
    *   `constraint.dart`: Base class for constraints.
    *   `expression_constraint.dart`: A specific constraint for mathematical/logical expressions.
    *   `puzzle_definition.dart`: The top-level container for a puzzle's components.
3.  Define the properties for each model class (e.g., `Entry` has a length and orientation).

**Testing Strategy:**
*   For each model class, write unit tests to verify that constructors work as expected and that properties are correctly stored and retrieved.
*   Ensure the project structure is clean and follows Dart conventions.

---

### Phase 2: Expression Engine and Constraint System

**Objective:** Develop the logic for parsing and evaluating the expressions that define many of the puzzle constraints.

**Implementation Steps:**
1.  Implement the `ExpressionConstraint` class.
2.  Build the expression parser. This can be adapted from the previous version but should be cleaner and more modular.
3.  Implement the expression evaluator, which will take a parsed expression and a set of variable values to produce a result.
4.  Support basic arithmetic, operators, parentheses, and variable substitution.

**Testing Strategy:**
*   Write extensive unit tests for the expression engine:
    *   Test simple expressions (`2+2`, `A*B`).
    *   Test operator precedence and parentheses (`(A+B)*C`).
    *   Test with various variable values.
    *   Test edge cases and invalid expressions to ensure robust error handling.

---

### Phase 3: The Core Solver

**Objective:** Implement the main solver engine that uses the models and constraints to find a solution.

**Implementation Steps:**
1.  Create the `Solver` class in `lib/src/solver.dart`.
2.  Implement the primary solving loop, which iteratively applies constraints to narrow down the possible values for clues and variables.
3.  Implement the constraint propagation logic. When a clue's value set is reduced, this change must be propagated to any other clues, entries, or variables that depend on it.

**Testing Strategy:**
*   Create simple, hand-crafted `PuzzleDefinition` objects for testing.
*   Write unit tests for the `Solver` that:
    *   Verify it can solve a basic puzzle with a known solution.
    *   Test that constraint propagation correctly filters possibilities.
    *   Ensure the solver terminates correctly when a solution is found or when no solution is possible.

---

### Phase 4: Advanced Solver Features

**Objective:** Enhance the solver to handle the more complex puzzle mechanics identified in the requirements.

**Implementation Steps:**
1.  Implement the backtracking algorithm for puzzles where the clue-to-entry mapping is unknown.
2.  Extend the expression engine and solver to handle references to entries in multiple grids (e.g., `GridA.A1 + GridB.D1`).
3.  Refine the `Variable` and `Clue` interaction within the solver.

**Testing Strategy:**
*   Create specific integration tests for these advanced features.
*   Test the backtracking algorithm with a puzzle where the mapping is ambiguous.
*   Test the multi-grid support with a puzzle that has inter-grid dependencies.

---

### Phase 5: Puzzle Migration and CLI

**Objective:** Validate the new architecture by migrating existing puzzles and providing a user interface to run them.

**Implementation Steps:**
1.  Create a `puzzles/` directory to hold puzzle definitions.
2.  Migrate a simple puzzle from the old project by creating its `PuzzleDefinition` in the new format.
3.  Build the command-line interface (CLI) in `bin/cross_number_v2.dart`. The CLI should allow a user to select a puzzle, run the solver, and print the solution grid.
4.  Migrate a few more complex puzzles to ensure the architecture is flexible enough to handle them.

**Testing Strategy:**
*   Create end-to-end tests for each migrated puzzle. These tests will run the CLI and verify that the output matches the known correct solution.
*   This serves as the final validation that the new system is working correctly.

---

### Phase 6: Finalization

**Objective:** Polish the project for release.

**Implementation Steps:**
1.  Conduct a full code review.
2.  Add comprehensive doc comments to all public APIs.
3.  Create a `README.md` with instructions on how to use the CLI and define new puzzles.
4.  Ensure all tests are passing.

**Testing Strategy:**
*   Run the full test suite one final time.
*   Manually run the CLI for all migrated puzzles to check for any formatting or usability issues.