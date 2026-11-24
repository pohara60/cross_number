import 'dart:math';

import 'base_puzzle.dart';
import 'digits.dart';
import 'entry_option.dart';

/// The squares in the range 4-676.
const List<int> squares = [
  4,
  9,
  16,
  25,
  36,
  49,
  64,
  81,
  100,
  121,
  144,
  169,
  196,
  225,
  256,
  289,
  324,
  361,
  400,
  441,
  484,
  529,
  576,
  625,
  676,
];

final Map<DigitString, bool> _alwaysSquareCache = {};

/// Returns the candidate options for an entry of [length] with [clue].
List<EntryOption> candidatesFor(int length, BaseEntryClue clue) {
  final options = <EntryOption>[];

  for (var base = 2; base <= 17; base++) {
    for (final value in squares) {
      final digits = digitsOf(value, base, length);
      if (digits == null) continue;
      if (!clueAccepts(clue, base, value, digits)) continue;
      options.add(EntryOption(base, value, digits));
    }
  }

  return options;
}

/// Returns whether [clue] accepts an option.
bool clueAccepts(
  BaseEntryClue clue,
  int base,
  int value,
  DigitString digits,
) {
  return switch (clue) {
    UncluedClue() => true,
    ValueClue(value: final fixedValue) => fixedValue == value,
    BaseClue(base: final fixedBase) => fixedBase == base,
    AlwaysSquareClue() => isAlwaysSquare(digits),
    MiddleDigitSquareClue() => const {0, 1, 4, 9}.contains(digits.digits[digits.length ~/ 2]),
    NotValueClue(value: final excludedValue) => excludedValue != value,
    NotBaseClue(base: final excludedBase) => excludedBase != base,
  };
}

/// Returns whether [digits] is a square in every base where the digits are
/// valid.
///
/// The entry range 4-676 is applied separately by candidate generation. The
/// always-square property itself is independent of that range: for example,
/// `900` is a square in every base, even when its value exceeds 676.
bool isAlwaysSquare(DigitString digits) {
  return _alwaysSquareCache.putIfAbsent(digits, () {
    final maxDigit = digits.digits.reduce(max);

    for (var base = max(2, maxDigit + 1); base <= 17; base++) {
      if (!_isSquare(valueOf(digits, base))) return false;
    }

    return true;
  });
}

bool _isSquare(int value) {
  if (value < 0) return false;
  final root = sqrt(value).round();
  return root * root == value;
}
