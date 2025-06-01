// This puzzle consists of six 2-digit, six 3-digit and six 4-digit entries.
// These can be divided into six pandigital sets each with a 2-, 3- and 4-digit
// entry between them containing the digits 1 – 9.
// Furthermore, the 18 digits of the six 3-digit entries contain two each of the
// digits 1 – 9.

import '../variable.dart';
import 'clue.dart';

class PanDigitalSet {
  PandigitaliaEntry clue2digits;
  PandigitaliaEntry? clue3digits;
  PandigitaliaEntry clue4digits;
  PanDigitalSet({
    required this.clue2digits,
    this.clue3digits,
    required this.clue4digits,
  });

  bool updateDigits(Set<Variable> updatedVariables) {
    var updated = false;
    // Get used digits from set clues
    var usedDigits = <int>{};
    for (var clue in [clue2digits, clue3digits, clue4digits]) {
      if (clue != null && clue.isSet) {
        for (var digit in clue.value.toString().split('')) {
          usedDigits.add(int.parse(digit));
        }
      }
    }
    // Clear used digits from unset clues
    if (usedDigits.isNotEmpty) {
      for (var clue in [clue2digits, clue3digits, clue4digits]) {
        if (clue != null && !clue.isSet) {
          var digitsUpdated = false;
          for (var digits in clue.digits) {
            var oldLength = digits.length;
            digits.removeAll(usedDigits);
            if (digits.length != oldLength) {
              digitsUpdated = true;
            }
          }
          if (digitsUpdated) {
            var values = clue.getValuesFromDigits();
            if (values != null) {
              clue.values = values;
              updatedVariables.add(clue);
              updated = true;
            }
          }
        }
      }
    }

    // Remaining logic only applies ahen all 3 clues are known
    if (clue3digits == null) return updated;

    // Count occurrences of digits in the clues
    // If a digit only occurs once in the clues, then it is a set digit
    var digitCount = <int, int>{};
    for (var clue in [clue2digits, clue3digits, clue4digits]) {
      if (clue != null) {
        for (var digits in clue.digits) {
          for (var digit in digits) {
            if (digitCount.containsKey(digit)) {
              digitCount[digit] = digitCount[digit]! + 1;
            } else {
              digitCount[digit] = 1;
            }
          }
        }
      }
      for (var setDigit in digitCount.keys) {
        if (digitCount[setDigit] == 1) {
          // Set digit found
          for (var clue in [clue2digits, clue3digits, clue4digits]) {
            if (clue != null && !clue.isSet) {
              // Is digit in unset clue?
              var digitsUpdated = false;
              for (var digits in clue.digits) {
                if (digits.contains(setDigit)) {
                  digits.remove(setDigit);
                  digitsUpdated = true;
                }
              }
              if (digitsUpdated) {
                var values = clue.getValuesFromDigits();
                if (values != null) {
                  clue.values = values;
                  updatedVariables.add(clue);
                  updated = true;
                }
              }
            }
          }
        }
      }
    }
    return updated;
  }
}
