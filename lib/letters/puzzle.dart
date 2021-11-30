import 'package:crossnumber/letters/clue.dart';
import 'package:crossnumber/puzzle.dart';
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

  // postProcessing() {
  //   if (Crossnumber.traceSolve) {
  //     print("PARTIAL SOLUTION-----------------------------");
  //     print(toSummary());
  //     // print(puzzle.toString());
  //   }

  //   print("ITERATE SOLUTIONS-----------------------------");
  //   var count = iterate();
  //   print('Solution count=$count');
  // }

  Map<Clue, Answer> solution = {};
  Map<Clue, int>? lastSolution;
  List<Clue> order = [];

  int iterate() {
    for (var clue in this.clues.values) {
      var values = clue.values!.toList();
      values.sort();
      solution[clue] = Answer(values);
      if (!order.contains(clue)) {
        // Add clue and its dependents
        order.add(clue);
        for (var d = 0; d < clue.length; d++) {
          if (clue.digitIdentities[d] != null) {
            var clue2 = clue.digitIdentities[d]!.clue;
            if (!order.contains(clue2)) {
              // Add clue and its dependents
              order.add(clue2);
            }
          }
        }
      }
    }
    //var keys = solution.keys.toList();
    var count = 0;
    count = findSolutions(order, 0, count);
    return count;
  }

  int findSolutions(List<Clue> keys, int next, int count) {
    while (next < keys.length && solution[keys[next]]!.value != null) {
      next++;
    }
    if (next == keys.length) {
      if (checkSolution()) {
        //print(this.solutionToString());
        lastSolution = {};
        for (var clue in solution.keys) {
          lastSolution![clue] = solution[clue]!.value!;
        }
        count++;
      }
    } else {
      var clue = keys[next];
      // Try each of the possible values for this clue
      value:
      for (var value in solution[clue]!.possible) {
        // Check that this value is consistent with other clues
        for (var d = 0; d < clue.length; d++) {
          if (clue.digitIdentities[d] != null) {
            var clue2 = clue.digitIdentities[d]!.clue;
            var d2 = clue.digitIdentities[d]!.digit;
            var value2 = solution[clue2]!.value;
            if (value2 != null) {
              if (value.toString()[d] != value2.toString()[d2]) {
                // Inconsistent values
                continue value;
              }
            }
          }
        }
        // Consistent, try this value
        solution[clue]!.value = value;
        //count = findSolutions(keys, next + 1, count, depth);
        count = findSolutions(keys, next + 1, count);
        solution[clue]!.value = null;
      }
    }
    //return count;
    return count;
  }

  bool checkSolution() {
    var ok = true;
    var possibleValue = <int>{};
    for (var clue in solution.keys) {
      var value = solution[clue]!.value;
      clue.tryValue = value;
    }
    for (var clue in solution.keys) {
      var value = solution[clue]!.value;
      clue.solve!(clue, possibleValue);
      if (possibleValue.isEmpty || !possibleValue.contains(value)) {
        // Failed
        ok = false;
        break;
      }
    }
    for (var clue in solution.keys) {
      clue.tryValue = null;
    }

    return ok;
  }

  String solutionToString() {
    var text = "Solution\n";
    var keys = solution.keys.toList();
    //keys.sort((c1,c2) => c1.name[0] == c2.name[0] ? int.parse(c1.name.substring(1)).compareTo(int.parse(c2.name.substring(1))) : c1.name[0].compareTo(c2.name[0]));
    for (var clue in keys) {
      text +=
          '${clue.name}=${solution[clue]!.value ?? solution[clue]!.possible}\n';
    }
    return text;
  }

  String lastSolutionToString() {
    var text = "Solution\n";
    if (lastSolution != null) {
      var keys = lastSolution!.keys.toList();
      //keys.sort((c1,c2) => c1.name[0] == c2.name[0] ? int.parse(c1.name.substring(1)).compareTo(int.parse(c2.name.substring(1))) : c1.name[0].compareTo(c2.name[0]));
      for (var clue in keys) {
        text += '${clue.name}=${lastSolution![clue]!}\n';
      }
    }
    return text;
  }
}

class Answer {
  List<int> possible;
  int? value;
  Answer(this.possible) {
    if (this.possible.length == 1) {
      this.value = this.possible[0];
    }
  }
}
