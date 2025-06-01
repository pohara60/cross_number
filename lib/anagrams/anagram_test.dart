import 'package:trotter/trotter.dart';

var a12 = [0, 6, 0, 0, 8, 0];
var a14 = [0, 2, 0, 0, 1, 0];
var d7 = [0, 6, 0, 0, 4, 0];
var d8 = [0, 1, 0, 0, 8, 0];

var a12Anagram = [0, 7, 0, 0, 8, 0];
var a14Anagram = [0, 7, 0, 0, 1, 0];
var d7Anagram = [0, 7, 0, 0, 0, 0];
var d8Anagram = [0, 1, 0, 0, 8, 0];

void main(List<String> args) {
  checkEntries(a12, a14, d7, d8, a12Anagram, a14Anagram, d7Anagram, d8Anagram);
}

List<int> entryToDigits(int entry) {
  // Convert entry to a list of digits
  var entryString = entry.toString().padLeft(6, '0');
  return entryString.split('').map(int.parse).toList();
}

void checkEntries(
    List<int> a12Digits,
    List<int> a14Digits,
    List<int> d7Digits,
    List<int> d8Digits,
    List<int> a12DigitsAnagram,
    List<int> a14DigitsAnagram,
    List<int> d7DigitsAnagram,
    List<int> d8DigitsAnagram) {
  // Try possible values for original values and permutations
  var knownValues = <int>[];
  var a12Amalgams = Amalgams(4, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
  for (final a12Amalgam in a12Amalgams()) {
    for (var a12Digit in [0, 2, 3, 5]) {
      var a12AmalgamDigit = a12Digit == 0
          ? 0
          : a12Digit == 5
              ? 3
              : a12Digit - 1;
      var a12DigitValue = a12Amalgam[a12AmalgamDigit];
      if (a12Digit == 0 && (a12DigitValue == 0 || a12DigitValue > 4)) {
        break; // Skip if leading zero or too big for anagram multiple
      }
      a12Digits[a12Digit] = a12DigitValue;
      if (a12Digit == 5) {
        var a12Value = int.parse(a12Digits.join());
        // Check that known Anagram digits are in new values
        if (!a12Digits.contains(a12DigitsAnagram[1]) ||
            !a12Digits.contains(a12DigitsAnagram[4])) {
          break; // Skip if anagram digits are not present
        }
        knownValues.add(a12Value);
        // Set intersecting digits
        d7Digits[2] = a12Digits[2];
        d8Digits[2] = a12Digits[3];

        for (var a12AnagramValue in getAnagram(a12Digits, a12DigitsAnagram)) {
          if (knownValues.contains(a12AnagramValue)) {
            continue; // Skip known values
          }
          var anagramString = a12AnagramValue.toString();
          var anagramDigits = anagramString.split('').map(int.parse).toList();
          for (var a12AnagramDigit in [0, 2, 3, 5]) {
            var a12AnagramDigitValue = anagramDigits[a12AnagramDigit];
            a12DigitsAnagram[a12AnagramDigit] = a12AnagramDigitValue;
          }
          knownValues.add(a12AnagramValue);
          // Set intersecting digits
          d7DigitsAnagram[2] = a12DigitsAnagram[2];
          d8DigitsAnagram[2] = a12DigitsAnagram[3];

          // Try possible values for a8
          var a14Amalgams = Amalgams(4, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
          for (final a14Amalgam in a14Amalgams()) {
            for (var a14Digit in [0, 2, 3, 5]) {
              var a14AmalgamDigit = a14Digit == 0
                  ? 0
                  : a14Digit == 5
                      ? 3
                      : a14Digit - 1;
              var a14DigitValue = a14Amalgam[a14AmalgamDigit];
              if (a14Digit == 0 && (a14DigitValue == 0 || a14DigitValue > 4)) {
                break; // Skip if leading zero or too big for anagram multiple
              }
              a14Digits[a14Digit] = a14DigitValue;
              if (a14Digit == 5) {
                var a14Value = int.parse(a14Digits.join());
                // Check that known Anagram digits are in new values
                if (!a14Digits.contains(a14DigitsAnagram[1]) ||
                    !a14Digits.contains(a14DigitsAnagram[4])) {
                  break; // Skip if anagram digits are not present
                }
                if (knownValues.contains(a14Value)) {
                  break; // Skip known values
                }
                knownValues.add(a14Value);
                // Set intersecting digits
                d7Digits[3] = a14Digits[2];
                d8Digits[3] = a14Digits[3];
                for (var a14AnagramValue
                    in getAnagram(a14Digits, a14DigitsAnagram)) {
                  if (knownValues.contains(a14AnagramValue)) {
                    continue; // Skip known values
                  }
                  var anagramString = a14AnagramValue.toString();
                  var anagramDigits =
                      anagramString.split('').map(int.parse).toList();
                  for (var a14AnagramDigit in [0, 2, 3, 5]) {
                    var a14AnagramDigitValue = anagramDigits[a14AnagramDigit];
                    a14DigitsAnagram[a14AnagramDigit] = a14AnagramDigitValue;
                  }
                  knownValues.add(a14AnagramValue);
                  // Set intersecting digits
                  d7DigitsAnagram[3] = a14DigitsAnagram[2];
                  d8DigitsAnagram[3] = a14DigitsAnagram[3];

                  // Try possible values for d7
                  var d7Amalgams = Amalgams(2, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
                  for (final d7Amalgam in d7Amalgams()) {
                    for (var d7Digit in [0, 5]) {
                      var d7AmalgamDigit = d7Digit == 0 ? 0 : 1;
                      var d7DigitValue = d7Amalgam[d7AmalgamDigit];
                      if (d7Digit == 0 &&
                          (d7DigitValue == 0 || d7DigitValue > 4)) {
                        break; // Skip if leading zero or too big for anagram multiple
                      }
                      d7Digits[d7Digit] = d7DigitValue;
                      if (d7Digit == 5) {
                        // Check that known Anagram digits are in new values
                        if (!d7Digits.contains(d7DigitsAnagram[1]) ||
                            !d7Digits.contains(d7DigitsAnagram[4])) {
                          break; // Skip if anagram digits are not present
                        }
                        var d7Value = int.parse(d7Digits.join());
                        if (knownValues.contains(d7Value)) {
                          break; // Skip known values
                        }
                        knownValues.add(d7Value);
                        for (var d7AnagramValue in getAnagram(
                            d7Digits, d7DigitsAnagram,
                            isDown: true)) {
                          if (knownValues.contains(d7AnagramValue)) {
                            continue; // Skip known values
                          }
                          var anagramString = d7AnagramValue.toString();
                          var anagramDigits =
                              anagramString.split('').map(int.parse).toList();
                          for (var d7AnagramDigit in [0, 5]) {
                            var d7AnagramDigitValue =
                                anagramDigits[d7AnagramDigit];
                            d7DigitsAnagram[d7AnagramDigit] =
                                d7AnagramDigitValue;
                          }
                          knownValues.add(d7AnagramValue);
                          // Try possible values for d8
                          var d8Amalgams =
                              Amalgams(2, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
                          for (final d8Amalgam in d8Amalgams()) {
                            for (var d8Digit in [0, 5]) {
                              var d8AmalgamDigit = d8Digit == 0 ? 0 : 1;
                              var d8DigitValue = d8Amalgam[d8AmalgamDigit];
                              if (d8Digit == 0 &&
                                  (d8DigitValue == 0 || d8DigitValue > 4)) {
                                break; // Skip if leading zero or too big for anagram multiple
                              }
                              d8Digits[d8Digit] = d8DigitValue;
                              if (d8Digit == 5) {
                                if (!d8Digits.contains(d8DigitsAnagram[1]) ||
                                    !d8Digits.contains(d8DigitsAnagram[4])) {
                                  break; // Skip if anagram digits are not present
                                }
                                var d8Value = int.parse(d8Digits.join());
                                if (knownValues.contains(d8Value)) {
                                  break; // Skip known values
                                }
                                knownValues.add(d8Value);

                                for (var d8AnagramValue in getAnagram(
                                    d8Digits, d8DigitsAnagram,
                                    isDown: true)) {
                                  if (knownValues.contains(d8AnagramValue)) {
                                    continue; // Skip known values
                                  }
                                  var anagramString = d8AnagramValue.toString();
                                  var anagramDigits = anagramString
                                      .split('')
                                      .map(int.parse)
                                      .toList();
                                  for (var d8AnagramDigit in [0, 5]) {
                                    var d8AnagramDigitValue =
                                        anagramDigits[d8AnagramDigit];
                                    d8DigitsAnagram[d8AnagramDigit] =
                                        d8AnagramDigitValue;
                                  }
                                  knownValues.add(d8AnagramValue);

                                  // Found a valid anagram set
                                  print('Values=$knownValues');

                                  knownValues.removeLast();
                                }
                                knownValues.removeLast();
                              }
                            }
                          }
                          knownValues.removeLast();
                        }
                        knownValues.removeLast();
                      }
                    }
                  }
                  knownValues.removeLast();
                }
                knownValues.removeLast();
              }
            }
          }
          knownValues.removeLast();
        }
        knownValues.removeLast();
      }
    }
  }
}

Iterable<int> getAnagram(List<int> digits, List<int> digitsAnagram,
    {bool isDown = false}) sync* {
  // Anagram is a multiple of the original value
  // Try multiples of the original value that are 6 digits long
  // Check if the anagram is a valid permutation of the original value
  // Check that known Anagram digits are in new values
  if (!digits.contains(digitsAnagram[1]) ||
      !digits.contains(digitsAnagram[4])) {
    return; // Skip if anagram digits are not present
  }
  if (isDown &&
      (!digits.contains(digitsAnagram[2]) ||
          !digits.contains(digitsAnagram[3]))) {
    return; // Skip if anagram digits are not present
  }
  for (var multiple in [2, 3, 4, 5, 6, 7, 8, 9]) {
    var value = int.parse(digits.join());
    var anagramValue = value * multiple;
    var anagramString = anagramValue.toString();
    var anagramStringLength = anagramString.length;
    if (anagramStringLength < 6) continue;
    if (anagramStringLength > 6) break;
    var anagramDigits = anagramString.split('').map(int.parse).toList();
    if (anagramDigits[1] == digitsAnagram[1] &&
        anagramDigits[4] == digitsAnagram[4] &&
        (!isDown ||
            (anagramDigits[2] == digitsAnagram[2] &&
                anagramDigits[3] == digitsAnagram[3]))) {
      if (isAnagram(digits, anagramDigits)) {
        yield anagramValue; // Yield valid anagram value
      }
    }
  }
}

bool isAnagram(List<int> digits, List<int> anagramDigits) {
  // Check if the anagramDigits are a valid permutation of the digits
  var digitCount = <int, int>{};
  for (var digit in digits) {
    digitCount[digit] = (digitCount[digit] ?? 0) + 1;
  }
  for (var anagramDigit in anagramDigits) {
    if (!digitCount.containsKey(anagramDigit) ||
        digitCount[anagramDigit]! <= 0) {
      return false; // Not a valid anagram
    }
    digitCount[anagramDigit] = digitCount[anagramDigit]! - 1;
  }
  return true; // Valid anagram
}
