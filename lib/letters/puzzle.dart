import 'package:crossnumber/letters/clue.dart';
import 'package:crossnumber/letters/cartesian.dart';
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
    if (lastSolution != null) {
      return lastSolutionToString();
    }

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

  postProcessing() {
    if (Crossnumber.traceSolve) {
      print("PARTIAL SOLUTION-----------------------------");
      print(toSummary());
      // print(puzzle.toString());
    }

    print("ITERATE SOLUTIONS-----------------------------");
    var count = iterate();
    print('Solution count=$count');
  }

  Map<Clue, int>? solution;
  Map<Clue, int>? lastSolution;
  Map<String, int>? lastLetters;
  List<Clue> order = [];

  int iterate() {
    // Iterate ove possible letter values
    var letterValues = <List<int>>[];
    var letterNames = <String>[];
    for (var letter in this.letters.keys) {
      letterNames.add(letter);
      letterValues.add(this.letters[letter]!.values.toList());
    }
    var count = 0;
    for (var product in cartesian(letterValues)) {
      // for (var product in [
      //   [9, 8, 7, 2, 6, 5, 3, 1, 4]
      // ]) {
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
              var value2 = solution![clue2];
              if (value2 != null) {
                if (value.toString()[d] != value2.toString()[d2]) {
                  // Inconsistent values
                  found = false;
                }
              }
            }
          }
          if (found) {
            solution![clue] = value;
          }
        } else {
          found = false;
        }
        if (!found) break;
      }
      if (found) {
        count++;
        lastSolution = Map.from(solution!);
        lastLetters = <String, int>{};
        for (var letter in this.letters.keys) {
          lastLetters![letter] = this.letters[letter]!._value!;
        }
      }
    }
    return count;
  }

  String lastSolutionToString() {
    var text = "Solution\n";
    if (lastSolution != null) {
      var keys = lastSolution!.keys.toList();
      //keys.sort((c1,c2) => c1.name[0] == c2.name[0] ? int.parse(c1.name.substring(1)).compareTo(int.parse(c2.name.substring(1))) : c1.name[0].compareTo(c2.name[0]));
      for (var clue in keys) {
        text += '${clue.name}=${lastSolution![clue]!}\n';
      }
      text += 'Letters\n';
      for (var letter in lastLetters!.keys) {
        text += '$letter=${lastLetters![letter]!}\n';
      }
    }
    return text;
  }
}
