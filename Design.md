# Design

## Introduction

Cross Number puzzles have these features:

-   It is a grid, similar to a crossword grid, with numbered clues across and down
-   The clues specify conditions for the Value
-   The Values are distinct
-   Grid entries cannot start with 0
-   Grid entries are normally the clue value, but in some puzzles the values are transformed into the entries

Many puzzles use Variables in the clues, with these features:

-   The variables have names
-   They have distinct values from a set of possible values
-   The possible values may be specified by rule

Types of clue:

- A "type" of number:
  - Even or Odd
  - Prime
  - Square, Cube or Power
  - Triangular, Square Pyramidal
  - Lucasian
  - Palindrome
  - Happy
  - Lucky
  - Fibonacci
  - Ascending or Descending or Consecutive digits
  - Multiple of a Value
  - Product of N distinct Primes
  - Sum of 2 consecutive Squares
  - Half of a Value
  - Multiple of a variable or other clue value
  - Reverse or Jumble of other clue value
  - Value plus or minus other clue value
  - Digit product or sum is other clue value
  - Multiplicative persistence
  - Sum of all digits in puzzle
  - Multiple conditions
- Expression involving variables and/or other clue values

Unusual puzzles:
- Clue numbers also have an expression
- Clue value has decimals
- Clue value is fraction with numerator and denominator
- Variables take two values for Across and Down clues


## Generic Solution

In order to make a general puzzle solver, we do the following:

1. Define a class to encapsulate the state of a clue, including:  
   a. Number of digits
   b. Possible Values  
   c. Common digits with other clues: list of references to clue and digit
   d. Possible values of each digit
   e. Specific solution function to generate clue values
2. Define a class to encapsulate the state of the puzzle, including:  
   a. The clues
3. General solution algorithm:
   a. Maintain a list of clues to update, initialised with all clues
   b. Process list clues in turn, invoke clue solution function, updating the clue and puzzle state
   c. If clue updated add referring cells to list to update
   b. Loop until no more clues to update - puzzle solved
4. Post-processing
   a. If no unique solution has been found, then iterate over the clue possible values checking for solutions
   b. There may be custom post-processing logic

## Clue Expressions

The expression syntax currently includes these tokens:
- Number is sequence of digits
- Binary Operators + - * / ^
- Unary Operators - √ !
- Parentheses ()
- Equality =
- Variables are single letters
- Sequences of nunbers, variables and parentheses have implicit multiplication

Enhancements - implemented:
- Value generating functions #primes, #squares etc
- Monadic functions $dp, $ds
- Clue values as variables in expressions.

## Clue Solution

Process
1. Update digit possibles from overlapping clues
2. Get clue values
3. Update clue values, see below
4. Update digit possibles from values
5. Update variable possible values

### Get Clue Values Expression - implemented

1. Get variable (and clue) values, get cartesian product count, if too high then exit
   a. If clue values not (yet) available, may be able to generate from possible digits, to resolve mutual dependencies between clues
2. For each combination of variables
   a. Evaluate expression
   b. If value not right length skip
   c. Validate value - digits check or custom function
   d. If valid save clue value and variable values

### Enhancement Notes - implemented

Generating functions return multiple values, so expression evaluator is a generator.
- Logical functions do not return invalid values.
- Many puzzles do not have generators, just simple expressions, so optimise this.

When stop calling generator? 
- When expression is too high? Normally assume generator produces increasing values, so can abort generation. Need to cope with decreasing sub-expressions like minus/divide.
- Have limits applied to every sub-expression, to filter values in desired range. 
  - Need to increase limits for decreasing operators.
  - Difficult if both sides of operator are generators. 
  - Possible if only one generator and have limits for other sub-expression.

Need to add other clues as variables in expressions.
- Clues are variables
- Expression parsing should add clue variable reference, and clue cross-reference

## Unspecified Clue Numbers  implemented

The No21 puzzle has these unusual characteristics:
- The clue numbers are not specified
- The clues are presented in increasing order of value
- Some grid cells have two digits, the clue length specifies number of cells (not digits)

Enhancements:
- Seperate Grid Entry and Clue, with mapping between them
- Grid Entry is a subtype of Clue with EntryMixin for digits and digitIdentities
- Custom solve() procedure must solve Clues, then attempt to map to Entries

## Generic Puzzle (Future)

A bigger feature is to allow generic specification of a puzzle, with:

1. Meta-data to specify each clue
2. Generic solve function based on meta-data
3. Input/Ouput of puzzle definition

## GUI (Future)

GUI to:

1. Allow specification of puzzle
2. Show steps in solution of puzzle

  bool mapCluesToEntries(Function callback) {
    return mapNextClueToEntry(_clues.values.toList(), 0, callback);
  }

  bool mapNextClueToEntry(List<ClueKind> clues, int index, Function callback) {
    if (index == clues.length) {
      callback();
      return true;
    }

    var clue = clues[index];
    if (clue.entry != null)
      return mapNextClueToEntry(clues, index + 1, callback);

    var anyMapping = false;
    for (var entry in _entries.values.where((e) =>
        e.isAcross == clue.isAcross &&
        e.length == clue.length &&
        (e as EntryMixin).clue == null)) {
      // Set mapping
      mapClueToEntry(clue, entry);

      // Update entry digits from other entries
      var savedDigits = clue.saveDigits();
      clue.initialise();

      // Check values against permissible digits
      var oldValues = clue.values;
      if (clue.values != null && clue.values!.isNotEmpty) {
        var okValues = <int>{};
        for (var value in clue.values!) {
          if (clue.digitsMatch(value)) {
            okValues.add(value);
          }
        }
        if (okValues.isEmpty) {
          // Cannot map to entry
          clue.entry = null;
          (entry as EntryMixin).clue = null;
          continue;
        }

        // Update values and digits, saving old data
        clue.values = okValues;
        if (clue.finalise()) {
          ;
        }
      }
      // Try to map remaining clues
      if (mapNextClueToEntry(clues, index + 1, callback)) anyMapping = true;

      // Undo mapping
      clue.values = oldValues;
      clue.restoreDigits(savedDigits);
      clue.entry = null;
      (entry as EntryMixin).clue = null;
    }

    return anyMapping;
  }
