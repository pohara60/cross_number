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

## 4. Functional Requirements

### 4.1. Core Solver Engine

*   The system shall have a single, unified solver engine capable of solving all supported puzzle types.
*   The solver must be able to handle puzzles with complex logical and mathematical constraints.
*   The solver must support puzzles with variables that are shared across multiple clues.

### 4.2. Puzzle Definition

*   The system shall use a clear, composable structure for defining puzzles, based on the following components:
    *   **Grid:** Represents the puzzle grid.
    *   **Entry:** Represents a single entry in the grid.
    *   **Clue:** Represents the logic of a single clue.
    *   **Variable:** Represents a variable in the puzzle.
    *   **Constraint:** A new concept to define the rules and relationships between clues, entries, and variables.
*   The system must support puzzles with multiple grids and relationships between them.
*   The system must be able to handle puzzles where the mapping between clues and entries is not known initially and must be determined by the solver.

### 4.3. Command-Line Interface (CLI)

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
*   **Components**: `Grid`, `Entry`, `Clue`, `Variable`, and `Constraint` classes that can be composed to define a puzzle.

This architecture will provide a solid foundation for the future development of the Cross Number Solver.
