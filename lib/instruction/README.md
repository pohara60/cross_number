# Instruction Puzzle Solver

## Introduction

Instruction puzzles have these features:

-   It is a grid, similar to a crossword grid, with numbered clues across and down
-   The clues specify conditions for the Value based on DigitSum, DigitProduct and MuliplicativeProduct
-   The Values are distinct
-   The puzzle is ambiguous! The ambiguity is resolved by guessing a phrase that is formed from the last digits of the Down clues "Reverse Across Entries"
-   This disambiguates the Down clues, and leads to a puzzle with two solutions
-   Reversing the Across Entries and fixing the resulting entries results in another valid solution

## Lessons Learned

It is important to evaluate clue dependencies in both directions, i.e. if clue A depends on clue B, then clue B values may be restricted by clue A. (Added a general mechanism to support this.)
