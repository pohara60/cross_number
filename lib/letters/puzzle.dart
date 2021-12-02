import 'package:crossnumber/letters/clue.dart';
import 'package:crossnumber/cartesian.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/set.dart';

class Letter {
  final String letter;
  late Set<int> _values;
  int? _value;
  Letter(this.letter) {
    _values = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  }
  tryValue(int value) => _value = value;
  Set<int> get values => _value != null ? {_value!} : _values;
  set values(Set<int> values) => _values = values;
  String toString() {
    return values.toShortString();
  }
}

class LettersPuzzle extends Puzzle<LettersClue> {
  final Map<String, Letter> letters = {};
  final List<int> remainingDigits = List<int>.generate(9, (i) => i + 1);

  LettersPuzzle();

  Set<String> updateLetters(String letter, Set<int> possibleDigits) {
    var updatedLetters = <String>{};
    var possibleLetterValues = this.letters[letter]!.values;
    var updated = updatePossible(possibleLetterValues, possibleDigits);
    if (updated) {
      updatedLetters.add(letter);
      if (possibleLetterValues.length == 1) {
        List<String> knownLetters = [letter];
        int index = 0;
        while (index < knownLetters.length) {
          String letterKey = knownLetters[index];
          int letterValue = this.letters[letterKey]!.values.first;
          // Remove the known letter from all other letter possible values
          remainingDigits.remove(letterValue);
          for (var entry in this.letters.entries) {
            if (entry.key != letterKey) {
              if (entry.value.values.remove(letterValue)) {
                updatedLetters.add(entry.key);
                if (entry.value.values.length == 1) {
                  knownLetters.add(entry.key);
                }
              }
            }
          }
          index++;
        }
      }
    }
    return updatedLetters;
  }

  String toString() {
    var text = 'Puzzle\n';
    for (var clue in clues.values) {
      text += clue.toString() + '\n';
    }
    text += 'Letters:\n';
    for (var entry in letters.entries) {
      text += '${entry.key}=${entry.value}\n';
    }
    text += 'RemainingDigits: ${remainingDigits.toShortString()}\n';
    return text;
  }

  Map<String, int>? lastLetters;

  int iterate() {
    // Iterate ove possible letter values
    var letterValues = <List<int>>[];
    var letterNames = <String>[];
    for (var letter in this.letters.keys) {
      letterNames.add(letter);
      letterValues.add(this.letters[letter]!.values.toList());
    }
    var count = 0;
    // for (var product in cartesian(letterValues)) {
    for (var product in [
      [8, 3, 5, 1, 7, 4, 9, 2, 6]
    ]) {
      for (var i = 0; i < product.length; i++) {
        this.letters[letterNames[i]]!.tryValue(product[i]);
      }
      // Check all clues
      var found = true;
      solution = {};
      for (var clue in this.clues.values) {
        var possibleValue = <int>{};
        Map<String, Set<int>> possibleLetters = {};
        for (var letter in clue.letterReferences) {
          possibleLetters[letter] = <int>{};
        }
        clue.solve!(clue, possibleValue, possibleLetters);
        if (possibleValue.length == 1) {
          // Check that this value is consistent with other clues
          var value = possibleValue.first;
          for (var d = 0; d < clue.length && found; d++) {
            if (clue.digitIdentities[d] != null) {
              var clue2 = clue.digitIdentities[d]!.clue;
              var d2 = clue.digitIdentities[d]!.digit;
              var value2 = solution[clue2];
              if (value2 != null) {
                if (value.toString()[d] != value2.value.toString()[d2]) {
                  // Inconsistent values
                  found = false;
                }
              }
            }
          }
          if (found) {
            solution[clue] = Answer.value(value);
          }
        } else {
          found = false;
        }
        if (!found) break;
      }
      if (found) {
        print(solutionToString());
        count++;
      }
    }
    return count;
  }
}
