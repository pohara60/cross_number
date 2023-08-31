import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/root66_2/clue.dart';
import 'package:crossnumber/variable.dart';

class Root66_2Variable extends Variable {
  Root66_2Variable(letter) : super(letter) {
    this.values = Set.from({1, 2, 3, 4, 5, 6, 7, 8, 9});
  }
  String get letter => this.name;
}

class Root66_2Puzzle
    extends VariablePuzzle<Root66_2Clue, Root66_2Entry, Root66_2Variable> {
  // Puzzle has Prime variables that are restricted to two digit primes
  Root66_2Puzzle() : super(List.from({1, 2, 3, 4, 5, 6, 7, 8, 9}));
  Root66_2Puzzle.grid(List<String> gridString)
      : super.grid(List.from({1, 2, 3, 4, 5, 6, 7, 8, 9}), gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingValues => variableList.remainingValues;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  @override
  postProcessing([bool iteration = true]) {
    if (iteration) {
      print("ITERATE SOLUTIONS-----------------------------");
      // Find ambiguous clues
      for (var entry in this.entries.values) {
        if (entry.type == Root66_2EntryType.BCEFG &&
            entry.values != null &&
            entry.values!.length > 1) {
          var values = entry.values!;
          var valuestoRemove = <int>{};
          print('Ambiguous entry ${entry.name}=${values}');
          for (var value in values) {
            if (duplicateDigit(value)) {
              valuestoRemove.add(value);
            }
          }
          values.removeAll(valuestoRemove);
          if (values.length > 1) {
            print('Still ambiguous entry ${entry.name}=${values}');
          } else {
            print('Disambiguated entry ${entry.name}=${values.first}');
          }
        }
      }
      print('Solution');
    }
  }
}

bool duplicateDigit(int value) {
  var valueStr = value.toString();
  for (var i = 0; i < valueStr.length - 1; i++) {
    if (valueStr.substring(i + 1).contains(valueStr[i])) return true;
  }
  return false;
}
