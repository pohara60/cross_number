# Cross Number Solver v2

This project is a complete refactoring of the original Cross Number Solver, designed for clarity, maintainability, and extensibility.

## Running the Solver

To solve a puzzle, run the following command from the project root:

```bash
dart run bin/cross_number_v2.dart
```

Currently, the solver is hard-coded to run the `simple_puzzle` defined in `puzzles/simple_puzzle.dart`. In the future, the CLI will be extended to allow selecting different puzzles.

## Defining a New Puzzle

To define a new puzzle, follow these steps:

1.  **Create a new puzzle definition file** in the `puzzles/` directory. This file will contain the complete definition of your puzzle, including the grid, entries, clues, and variables.

2.  **Instantiate a `PuzzleDefinition` object.** This object will hold all the components of your puzzle.

3.  **Define the grids.** Create a map of `Grid` objects, where the key is the grid ID (e.g., "main").

4.  **Define the entries.** Create a map of `Entry` objects, where the key is the entry ID (e.g., "A1", "D1"). Specify the row, column, length, and orientation for each entry.

5.  **Define the clues.** Create a map of `Clue` objects, where the key is the clue ID. For each clue, provide a list of `Constraint` objects. The most common constraint is `ExpressionConstraint`, which defines the clue's value using a mathematical or logical expression.

6.  **Define the variables.** If your puzzle uses variables, create a map of `Variable` objects, where the key is the variable name. For each variable, provide the set of possible integer values.

7.  **Assemble the `PuzzleDefinition`.** Pass the maps of grids, entries, clues, and variables to the `PuzzleDefinition` constructor.

### Example: `simple_puzzle.dart`

```dart
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/models/variable.dart';

PuzzleDefinition simplePuzzle() {
  return PuzzleDefinition(
    grids: {
      'main': Grid(2, 2),
    },
    entries: {
      'A1': Entry(id: 'A1', row: 0, col: 0, length: 2, orientation: EntryOrientation.across),
      'D1': Entry(id: 'D1', row: 0, col: 0, length: 2, orientation: EntryOrientation.down),
    },
    clues: {
      'A1': Clue('A1', [ExpressionConstraint('A * 2')]),
      'D1': Clue('D1', [ExpressionConstraint('A + 3')]),
    },
    variables: {
      'A': Variable('A', {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}),
    },
  );
}
```