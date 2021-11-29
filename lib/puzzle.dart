import 'package:crossnumber/clue.dart';

class Puzzle {
  final Map<String, Clue> clues = {};

  Puzzle();

  void addClue(Clue clue) {
    clues[clue.name] = clue;
  }

  // clue1[digit1-1] = clue2[digit2-1]
  void addDigitIdentity(Clue clue1, int digit1, Clue clue2, int digit2) {
    clue1.digitIdentities[digit1 - 1] =
        DigitIdentity(clue: clue2, digit: digit2 - 1);
    clue2.digitIdentities[digit2 - 1] =
        DigitIdentity(clue: clue1, digit: digit1 - 1);
    clue2.addReferrer(clue1);
    clue1.addReferrer(clue2);
  }

  /// clue1 refers to clue2
  void addReference(Clue clue1, Clue clue2, [bool symmetric = false]) {
    clue2.addReferrer(clue1);
    if (symmetric) {
      clue1.addReferrer(clue2);
    }
  }

  String toString() {
    var text = 'Puzzle\n';
    for (var clue in clues.values) {
      text += clue.toString() + '\n';
    }
    return text;
  }

  String toSummary() {
    var text = 'Puzzle Summary\n';
    for (var clue in clues.values) {
      text += clue.toSummary() + '\n';
    }
    return text;
  }

  List<int> knownValues = [];

  bool updateValues(Clue clue, Set<int> possibleValue) {
    possibleValue.removeAll(knownValues);
    var updated = clue.updateValues(possibleValue);
    if (possibleValue.length == 1) {
      knownValues.addAll(possibleValue);
    }
    return updated;
  }

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
    var keys = solution.keys.toList();
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
      var value = solution[clue]!.value;
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
