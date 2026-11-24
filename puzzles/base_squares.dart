import 'package:crossnumber/src/base/base_domains.dart';
import 'package:crossnumber/src/base/base_puzzle.dart';

/// Base Squares by Gruber (Listener 4947).
///
/// Every entry is a square in the range 4 to 676, written in one of the 16 number bases 2 to 17. Each of the 25 squares
/// is used either once or twice. The bases 2 to 8 are used exactly three times each and every other base is used one to
/// three times. There are 16 zeros in the grid and each of the other 16 digits 1, 2, ..., 9, A, B, ..., G appears at
/// least once. The numbers in clues are in base ten. All grid entries are different and none starts with zero.
///
/// Some digit strings, eg 900 and 10404, always represent a square in any number base where they occur. All the entries
/// that are "always squares" are noted in the clues. The grid must be filled so that one of the "always square" entries
/// has multiple possible values within the constraints of the puzzle. Solvers must highlight this entry and list its
/// possible values (in base ten) below the grid.
///
/// The base is part of the solution, not the clue.

BasePuzzleDefinition baseSquares() {
  final gridString = [
    '+--+--+--+--+--+--+--+--+--+',
    '| 1: 2: 3: 4: 5: 6| 7| 8:  |',
    '+::+::+::+::+::+::+::+::+--+',
    '|  | 9:  |  |  |  |10:  :11|',
    '+--+::+::+::+::+::+::+--+::+',
    '|12:  |13:  :  :  :  |14:  |',
    '+::+--+--+::+--+::+::+--+::+',
    '|15:  :16|  |17:  :  :  :  |',
    '+::+--+::+--+::+::+--+--+::+',
    '|  |  |18:19|  |20:21|  |  |',
    '+::+--+--+::+::+--+::+--+::+',
    '|22:  :23:  :  |24|25:  :  |',
    '+::+--+::+::+--+::+--+--+::+',
    '|26:  |27:  :28:  :29|30:  |',
    '+::+--+::+::+::+::+::+::+--+',
    '|31:32:  |  |  |  |33:  |34|',
    '+--+::+::+::+::+::+::+::+::+',
    '|35:  |  |36:  :  :  :  :  |',
    '+--+--+--+--+--+--+--+--+--+',
  ].join('\n');

  return BasePuzzleDefinition(
    name: 'Base Squares',
    gridString: gridString,
    clues: const {
      'A10': BaseClue(5),
      'A12': ValueClue(25),
      'A13': AlwaysSquareClue(),
      'A14': ValueClue(64),
      'A15': ValueClue(576),
      'A17': AlwaysSquareClue(),
      'A25': AlwaysSquareClue(),
      'A26': ValueClue(49),
      'A27': AlwaysSquareClue(),
      'A30': ValueClue(9),
      'A31': NotBaseClue(10),
      'D17': MiddleDigitSquareClue(),
      'D19': AlwaysSquareClue(),
      'D24': NotValueClue(484),
      'D29': AlwaysSquareClue(),
      'D30': AlwaysSquareClue(),
      'D34': ValueClue(256),
    },
    rules: baseSquaresRules(),
  );
}

/// The global rules for Base Squares.
BaseGlobalRules baseSquaresRules() => BaseGlobalRules(
      exactBaseCounts: const {2: 3, 3: 3, 4: 3, 5: 3, 6: 3, 7: 3, 8: 3},
      baseCountRanges: {
        for (var base = 9; base <= 17; base++) base: const CountRule(1, 3),
      },
      valueCountRanges: {
        for (final value in squares) value: const CountRule(1, 2),
      },
      zeroCount: 16,
      requiredDigits: const {
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
      },
      distinctEntries: true,
    );
