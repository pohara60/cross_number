import 'package:crossnumber/cartesian.dart';
import 'package:crossnumber/letters/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/set.dart';
import 'package:crossnumber/variable.dart';

class LetterVariable extends Variable {
  LetterVariable(letter) : super(letter) {
    this.values = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  }
  String get letter => this.name;
}

class LettersPuzzle extends VariablePuzzle<LettersClue, LetterVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  LettersPuzzle() : super(List.from([1, 2, 3, 4, 5, 6, 7, 8, 9]));

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  String toString() {
    var text = super.toString();
    text += 'Letters:\n';
    for (var entry in letters.entries) {
      text += '${entry.key}=${entry.value}\n';
    }
    text += 'RemainingDigits: ${remainingDigits.toShortString()}\n';
    return text;
  }

  int iterate() {
    // Iterate ove possible letter values
    var letterValues = <List<int>>[];
    var letterNames = <String>[];
    for (var letter in this.letters.keys) {
      letterNames.add(letter);
      letterValues.add(this.letters[letter]!.values.toList());
    }
    var count = 0;
    //for (var product in [      [8, 3, 5, 1, 7, 4, 9, 2, 6]    ]) {
    for (var product in cartesian(letterValues)) {
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
          found = clueValuesMatch(clue, value);
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
