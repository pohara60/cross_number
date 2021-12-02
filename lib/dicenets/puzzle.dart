import 'package:crossnumber/dicenets/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/crossnumber.dart';

class DiceNetsPuzzle extends Puzzle<DiceNetsClue> {
  DiceNetsPuzzle();

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
        print(this.solutionToString());
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
}
