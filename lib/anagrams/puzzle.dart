import 'dart:math';

import 'package:crossnumber/generators.dart';
import 'package:trotter/trotter.dart';

import '../expression.dart';
import '../polyadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class AnagramsVariable extends Variable {
  AnagramsVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class AnagramsPuzzle
    extends VariablePuzzle<AnagramsClue, AnagramsEntry, AnagramsVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  AnagramsPuzzle({String name = ''}) : super(null, name: name);
  AnagramsPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  void initVariablePuzzle(List<int>? possibleValues,
      {bool variableListInitialized = false}) {
    final puzzlePolyadics = [
      Polyadic('primefactors', primefactorsFunc, Iterable<int>,
          order: NodeOrder.UNKNOWN),
    ];
    Scanner.addPolyadics(puzzlePolyadics);
    super.initVariablePuzzle(possibleValues);
  }

  @override
  postProcessing(
      {bool iteration = true,
      int Function(Puzzle)? callback,
      Function? partialCallback}) {
    // Add some manual solutions
    // clues['A1']!.value = 3375;
    // clues['D3']!.value = 7776;
    // clues['A10']!.values = {4173, 4876, 6572};
    // clues['A19']!.value = 8624;
    // clues['D16']!.values = {1612, 5642};

    traceFindSolutions = false;
    super.postProcessing(
        iteration: iteration,
        callback: callback,
        partialCallback: anagramsCallback);
  }

  int anagramsCallback(Puzzle puzzle) {
    // Check if the puzzle anagrams can work
    // Two digit clues would be reversed, so any clue that intersects with them
    // will have a changed digit at the intersection, check for other intersections
    var knownEntries = clues.values
        .where((element) => element.value != null)
        .map((e) => e.entry! as AnagramsEntry)
        .toList();
    var knownValues = knownEntries.map((e) => e.value).toList();
    for (var entry in knownEntries) {
      for (var cell in entry.cells) {
        for (var otherEntry
            in cell.entries.where((element) => element.value != null)) {
          if (otherEntry == entry) continue; // Skip self
          if (otherEntry.length == 2) {
            var otherCellIndex = otherEntry.cells.indexWhere((c) => c != cell);
            var otherDigit = otherEntry.value.toString()[otherCellIndex];
            var entryDigits = entry.value.toString().split('');
            // if entryDigits does not contain the otherDigit, then this is not
            // a possible anagram
            if (!entryDigits.contains(otherDigit)) {
              // This is not a possible anagram
              return 0;
            }
            entryDigits.remove(otherDigit);
            // Now check other intersection entries have a digit in remaining digits
            for (var otherEntry in entry.cells
                .expand((c) => c.entries)
                .where((element) => element.value != null)) {
              if (otherEntry == entry) continue; // Skip self
              if (otherEntry.length == 2) continue; // Skip two digit entries
              // Check if the other entry has a digit in the remaining digits
              var otherDigits = otherEntry.value.toString().split('');
              if (otherDigits.any((d) => entryDigits.contains(d))) {
                // This is a possible anagram
              } else {
                // This is not a possible anagram
                return 0;
              }
            }
          }
        }
      }
    }
    var newEntries = <AnagramsEntry>[];
    var newValues = <int>[];
    return checkEntryPermutations(
        knownEntries, knownValues, 0, newEntries, newValues);
  }

  var sixDigitEntries = <String, List<int>>{};
  var sixDigitEntryAnagrams = <String, List<int>>{};

  int checkEntryPermutations(
      List<AnagramsEntry> knownEntries,
      List<int?> knownValues,
      int index,
      List<AnagramsEntry> newEntries,
      List<int> newValues) {
    var count = 0;
    if (index >= knownEntries.length) {
      // Check the 6-digit entries
      count += checkSixDigitEntries(knownValues, newValues);
      return count;
    }
    var entry = knownEntries[index];
    // Try anagrams of the entry value
    var valueDigits = entry.value.toString().split('');
    // Generate all permutations of the value digits
    var previousPermValues = <int>[];
    for (var perm in getPermutations(valueDigits)) {
      var permValue = int.parse(perm.join());
      var validAnagram = true;
      if (perm[0] == '0' ||
          knownValues.contains(permValue) ||
          newValues.contains(permValue) ||
          previousPermValues.contains(permValue)) {
        validAnagram = false; // Not a valid anagram
        continue; // Skip known values
      }
      // Check if the permValue is a valid anagram
      var digitIndex = 0;
      for (var cell in entry.cells) {
        var permDigit = perm[digitIndex]; // Get the digit for this cell
        for (var otherEntry in cell.entries) {
          if (otherEntry == entry) continue; // Skip self
          // If already has a new value, check intersection is the same
          var newIndex = newEntries.indexOf(otherEntry as AnagramsEntry);
          if (newIndex != -1) {
            assert(otherEntry.value != null);
            var cellEntryIndex = cell.entries.indexOf(otherEntry);
            var otherEntryDigit = cell.entryDigits[cellEntryIndex];
            // Check if the other entry has the same digit in the perm value
            if (newValues[newIndex].toString()[otherEntryDigit] !=
                perm[digitIndex]) {
              validAnagram = false; // Not a valid anagram
              break;
            }
          } else if (otherEntry.length == 2) {
            assert(otherEntry.value != null);
            var otherCellIndex = otherEntry.cells.indexWhere((c) => c != cell);
            var otherDigit = otherEntry.value.toString()[otherCellIndex];
            if (otherDigit != permDigit) {
              // If the other entry is a two digit entry, check if the digit
              // in the perm value matches the other digit
              validAnagram = false; // Not a valid anagram
              break;
            }
          } else if (otherEntry.length == 6) {
            assert(otherEntry.value == null);
            var otherCellIndex = otherEntry.cells.indexWhere((c) => c == cell);
            // Save digits for six digit entries
            if (!sixDigitEntries.containsKey(otherEntry.name)) {
              sixDigitEntries[otherEntry.name] = List.filled(6, 0);
              sixDigitEntryAnagrams[otherEntry.name] = List.filled(6, 0);
            }
            sixDigitEntries[otherEntry.name]![otherCellIndex] =
                int.parse(valueDigits[digitIndex]);
            sixDigitEntryAnagrams[otherEntry.name]![otherCellIndex] =
                int.parse(permDigit);
          } else {
            assert(otherEntry.value != null);
            // Check if the other entry has a digit in the perm value
            var otherDigits = otherEntry.value.toString().split('');
            if (!otherDigits.contains(permDigit)) {
              validAnagram = false; // Not a valid anagram
              break;
            }
          }
        }
        if (!validAnagram) break; // Break out of the cell loop
        digitIndex++;
      }
      previousPermValues.add(permValue);
      if (validAnagram) {
        newEntries.add(entry);
        newValues.add(permValue);
        count += checkEntryPermutations(
            knownEntries, knownValues, index + 1, newEntries, newValues);
        newEntries.removeLast();
        newValues.removeLast();
      }
    }
    return count;
  }

  Iterable<List<String>> getPermutations(List<String> items) sync* {
    if (items.isEmpty) {
      yield [];
    } else {
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        var remaining = List<String>.from(items)..removeAt(i);
        for (var perm in getPermutations(remaining)) {
          yield [item, ...perm];
        }
      }
    }
  }

  Iterable<int> primefactorsFunc(List<dynamic> args) sync* {
    assert(args.length == 3);
    int numPrimes = args[0];
    var primeDiff = args[1];
    var clueLength = args[2];
    // Generate values that are the product of numPrimes primes
    // where the difference between the largest and smallest prime is primeDiff.
    // The primes may be duplicated.
    // The values are clueLength digits long.

    var loValue = pow(10, clueLength - 1) as int;
    var hiValue = (pow(10, clueLength) as int) - 1;
    // The value is at least firstPrime^numPrimes, so firstPrime>= lo^(1/numPrimes)
    // The value is at most (firstPrime+primeDiff)^numPrimes, so firstPrime<= hi^(1/numPrimes)-primeDiff
    var minPrime = (pow(loValue, 1 / numPrimes) as double).ceil() - primeDiff;
    var maxPrime = (pow(hiValue, 1 / numPrimes) as double).floor() + primeDiff;

    for (var firstPrime in generatePrimes(minPrime, maxPrime)) {
      var lastPrime = (firstPrime + primeDiff) as int;
      if (numPrimes == 2) {
        // Special case for numPrimes == 2
        var value = firstPrime * lastPrime;
        if (value.toString().length == clueLength) {
          yield value;
        }
        continue;
      }

      if (primeDiff == 0) {
        // Special case for primeDiff == 0, i.e. all primes are the same
        var value = pow(firstPrime, numPrimes) as int;
        if (value.toString().length == clueLength) {
          yield value;
        }
        continue;
      }

      var possiblePrimes =
          generatePrimes(firstPrime, firstPrime + primeDiff).toList();
      // Try the permutations of numPrimes-2 primes from possiblePrimes[0:-1] with
      // firstPrime and lastPrime
      var primes = [firstPrime, lastPrime];
      var amalgams = Amalgams(numPrimes - 2, possiblePrimes);
      for (final amalgam in amalgams()) {
        primes.addAll(amalgam);
        var value = primes.reduce((a, b) => a * b);
        if (value.toString().length == clueLength) {
          yield value;
        }
        primes.removeRange(2, primes.length); // Reset for next permutation
      }
    }
  }

  int checkSixDigitEntries(List<int?> knownValues, List<int> newValues) {
    return checkEntries(
        sixDigitEntries['A12']!,
        sixDigitEntries['A14']!,
        sixDigitEntries['D7']!,
        sixDigitEntries['D8']!,
        sixDigitEntryAnagrams['A12']!,
        sixDigitEntryAnagrams['A14']!,
        sixDigitEntryAnagrams['D7']!,
        sixDigitEntryAnagrams['D8']!,
        knownValues,
        newValues);
  }

  int checkEntries(
      List<int> a12Digits,
      List<int> a14Digits,
      List<int> d7Digits,
      List<int> d8Digits,
      List<int> a12DigitsAnagram,
      List<int> a14DigitsAnagram,
      List<int> d7DigitsAnagram,
      List<int> d8DigitsAnagram,
      List<int?> knownEntryValues,
      List<int> newEntryValues) {
    var count = 0;
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
                if (a14Digit == 0 &&
                    (a14DigitValue == 0 || a14DigitValue > 4)) {
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
                    var d7Amalgams =
                        Amalgams(2, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
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
                                    var anagramString =
                                        d8AnagramValue.toString();
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
                                    count++;
                                    print('Anagrams Solution');
                                    print('Entry Values=$knownEntryValues');
                                    print(
                                        'Anagram  Entry Values=$newEntryValues');
                                    print(
                                        'Six Digit Values/Anagrams=$knownValues');
                                    print(toSummary());

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
    return count;
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
}
