// ignore_for_file: camel_case_types

import '../puzzle.dart';
import '../root66_2/clue.dart';
import '../variable.dart';

class Root66_2Variable extends Variable {
  Root66_2Variable(super.letter) {
    values = Set.from({1, 2, 3, 4, 5, 6, 7, 8, 9});
  }
  String get letter => name;
}

class Root66_2Puzzle
    extends VariablePuzzle<Root66_2Clue, Root66_2Entry, Root66_2Variable> {
  // Puzzle has Prime variables that are restricted to two digit primes
  Root66_2Puzzle() : super(List.from({1, 2, 3, 4, 5, 6, 7, 8, 9}));
  Root66_2Puzzle.fromGridString(List<String> gridString)
      : super.fromGridString(
            List.from({1, 2, 3, 4, 5, 6, 7, 8, 9}), gridString);

  Map<String, Variable> get letters => variableList.variables;
  @override
  List<int> get remainingValues => variableList.restrictedValues!;
  Set<Variable> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  @override
  postProcessing(
      {bool iteration = true,
      int Function(Puzzle)? callback,
      Function? partialCallback}) {
    if (iteration) {
      print("ITERATE SOLUTIONS-----------------------------");
      // Find ambiguous clues
      for (var entry in entries.values) {
        if (entry.root66type == Root66_2EntryType.BCEFG &&
            entry.values != null &&
            entry.values!.length > 1) {
          var values = entry.values!;
          var valuestoRemove = <int>{};
          print('Ambiguous entry ${entry.name}=$values');
          for (var value in values) {
            if (duplicateDigit(value)) {
              valuestoRemove.add(value);
            }
          }
          values.removeAll(valuestoRemove);
          if (values.length > 1) {
            print('Still ambiguous entry ${entry.name}=$values');
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
