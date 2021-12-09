import 'package:crossnumber/cartesian.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/grid.dart';
import 'package:crossnumber/variable.dart';
import 'package:powers/src/powers.dart';

class Puzzle<ClueKind extends Clue> {
  late Map<String, ClueKind> clues;
  Grid? grid;

  Puzzle() {}
  Puzzle.grid(List<String> gridString) {
    this.grid = Grid(gridString);
  }

  void addClue(ClueKind clue) {
    clues[clue.name] = clue;
  }

  // clue1[digit1-1] = clue2[digit2-1]
  void addDigitIdentity(
      ClueKind clue1, int digit1, ClueKind clue2, int digit2) {
    clue1.digitIdentities[digit1 - 1] =
        DigitIdentity(clue: clue2, digit: digit2 - 1);
    clue2.digitIdentities[digit2 - 1] =
        DigitIdentity(clue: clue1, digit: digit1 - 1);
    clue2.addReferrer(clue1);
    clue1.addReferrer(clue2);
  }

  void addDigitIdentityFromGrid() {
    assert(this.grid != null);
    for (var identity in this.grid!.getIdentities()) {
      var clue1 = this.clues[identity['clue1']]!;
      var clue2 = this.clues[identity['clue2']]!;
      addDigitIdentity(clue1, identity['digit1'], clue2, identity['digit2']);
    }
  }

  /// clue1 refers to clue2
  void addReference(ClueKind clue1, ClueKind clue2, [bool symmetric = false]) {
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

  bool updateValues(ClueKind clue, Set<int> possibleValue) {
    possibleValue.removeAll(knownValues);
    var updated = clue.updateValues(possibleValue);
    if (possibleValue.length == 1) {
      knownValues.addAll(possibleValue);
    }
    return updated;
  }

  bool uniqueSolution() {
    return !this
        .clues
        .values
        .any((clue) => clue.values == null || clue.values!.length != 1);
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

  Map<Clue, Answer> solution = {};
  List<Clue> order = [];

  int iterate() {
    if (this is VariablePuzzle) {
      var puzzle = this as VariablePuzzle;
      return puzzle.iterateVariables();
    }
    return iterateValues();
  }

  int iterateValues() {
    var unknownClues = <Clue>[];
    for (var clue in this.clues.values) {
      if (clue.values == null) {
        if (!unknownClues.contains(clue)) {
          unknownClues.add(clue);
        }
      } else {
        var values = clue.values!.toList();
        values.sort();
        solution[clue] = Answer(values);
        if (!order.contains(clue)) {
          // Add clue and its dependents
          order.add(clue);
          for (var clue2 in clue.referrers) {
            if (!order.contains(clue2)) {
              if (clue2.values == null) {
                if (!unknownClues.contains(clue2)) {
                  unknownClues.add(clue2);
                }
              } else {
                // Add clue
                order.add(clue2);
              }
            }
          }
        }
      }
    }
    order.addAll(unknownClues);
    var count = 0;
    count = findSolutions(order, 0, count);
    return count;
  }

  int findSolutions(List<Clue> order, int next, int count) {
    while (next < order.length &&
        solution[order[next]] != null &&
        solution[order[next]]!.value != null) {
      next++;
    }
    if (next == order.length) {
      if (checkSolution()) {
        print(solutionToString());
        count++;
      }
    } else {
      var clue = order[next];
      if (clue.values == null) {
        //checkSolution();
        var possibleValue = <int>{};
        var possibleVariables = <String, Set<int>>{};
        if (clue is VariableClue) {
          for (var variable in clue.variableReferences) {
            possibleVariables[variable] = <int>{};
          }
          clue.solve!(clue, possibleValue, possibleVariables);
        } else {
          clue.solve!(clue, possibleValue);
        }
        if (possibleValue.isEmpty) {
          return count;
        }
        solution[clue] = Answer(List.from(possibleValue));
      }
      // Try each of the possible values for this clue
      for (var value in solution[clue]!.possible) {
        // Check that this value is consistent with other clues
        if (!clueValuesMatch(clue, value)) continue;
        // Consistent, try this value
        solution[clue]!.value = value;
        clue.tryValue = value;
        count = findSolutions(order, next + 1, count);
        solution[clue]!.value = null;
        clue.tryValue = null;
      }
    }
    //return count;
    return count;
  }

  bool checkSolution() {
    var ok = true;
    var failedClues = <Clue>[];
    for (var clue in solution.keys) {
      if (solution[clue] != null) {
        var value = solution[clue]!.value;
        var possibleValue = <int>{};
        clue.solve!(clue, possibleValue);
        if (possibleValue.isEmpty || !possibleValue.contains(value)) {
          // Failed
          failedClues.add(clue);
          ok = false;
        }
      }
    }

    //print('Check $ok ${failedClues.map((e) => e.name)} ${solutionToString()}');
    return ok;
  }

  bool clueValuesMatch(Clue clue, int value) {
    var match = true;
    for (var d = 0; d < clue.length && match; d++) {
      if (clue.digitIdentities[d] != null) {
        var clue2 = clue.digitIdentities[d]!.clue;
        var d2 = clue.digitIdentities[d]!.digit;
        if (solution[clue2] != null) {
          var value2 = solution[clue2]!.value;
          if (value2 != null) {
            if (value.toString()[d] != value2.toString()[d2]) {
              // Inconsistent values
              match = false;
            }
          }
        }
      }
    }
    return match;
  }

  String solutionToString() {
    var text = "Solution\n";
    var keys = solution.keys.toList();
    var clueValues = <String, int>{};
    var unique = true;
    for (var clue in keys) {
      text +=
          '${clue.name}=${solution[clue]!.value ?? solution[clue]!.possible}\n';
      if (solution[clue]!.value == null) {
        unique = false;
      } else {
        clueValues[clue.name] = solution[clue]!.value!;
      }
    }
    if (unique && this.grid != null) {
      text += '\n${grid!.solutionToString(clueValues)}';
    }
    return text;
  }
}

class VariablePuzzle<ClueKind extends Clue, VariableKind extends Variable>
    extends Puzzle<ClueKind> {
  late final VariableList variableList;
  VariablePuzzle(List<int> possibleValues) {
    variableList = VariableList<VariableKind>(possibleValues);
  }

  Map<String, Variable> get variables => variableList.variables;
  List<int> get remainingValues => variableList.remainingValues;
  Set<String> updateVariables(String variable, Set<int> possibleValues) =>
      variableList.updateVariables(variable, possibleValues);

  void solveVariableExpression(
      VariableClue clue,
      Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables,
      int expression(List<int> variables)) {
    var variableValues = <List<int>>[];
    for (var variable in clue.variableReferences) {
      variableValues.add(this.variables[variable]!.values.toList());
    }
    for (var product in cartesian(variableValues)) {
      var value = expression(product);
      if (value >= 10.pow(clue.length - 1) && value < 10.pow(clue.length)) {
        possibleValue.add(value);
        var index = 0;
        for (var variable in clue.variableReferences) {
          possibleVariables[variable]!.add(product[index++]);
        }
      }
    }
  }

  int iterateVariables() {
    // Iterate over possible variable values
    var variableValues = <List<int>>[];
    var variableNames = <String>[];
    for (var variable in this.variables.keys) {
      variableNames.add(variable);
      variableValues.add(this.variables[variable]!.values.toList());
    }
    var count = 0;
    //for (var product in [      [8, 3, 5, 1, 7, 4, 9, 2, 6]    ]) {
    for (var product in cartesian(variableValues)) {
      for (var i = 0; i < product.length; i++) {
        this.variables[variableNames[i]]!.tryValue(product[i]);
      }
      // Check all clues
      var found = true;
      solution = {};
      for (var clue in this.clues.values) {
        if (clue is VariableClue) {
          var possibleValue = <int>{};
          Map<String, Set<int>> possibleLetters = {};
          for (var variable in clue.variableReferences) {
            possibleLetters[variable] = <int>{};
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
      }
      if (found) {
        print(solutionToString());
        count++;
      }
    }
    return count;
  }

  String toString() {
    var text = super.toString();
    text += this.variableList.toString();
    return text;
  }

  String toSummary() {
    var text = super.toSummary();
    text += this.variableList.toSummary();
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
  Answer.value(int this.value) : this.possible = [value];
}
