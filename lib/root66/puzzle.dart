import '../puzzle.dart';
import '../root66/clue.dart';
import '../variable.dart';

class Root66Variable extends Variable {
  Root66Variable(super.letter) {
    values = Set.from({1, 2, 3, 4, 5, 6, 7, 8, 9});
  }
  String get letter => name;
}

class Root66Puzzle
    extends VariablePuzzle<Root66Clue, Root66Entry, Root66Variable> {
  // Puzzle has Prime variables that are restricted to two digit primes
  Root66Puzzle() : super(List.from({1, 2, 3, 4, 5, 6, 7, 8, 9}));
  Root66Puzzle.fromGridString(List<String> gridString)
      : super.fromGridString(
            List.from({1, 2, 3, 4, 5, 6, 7, 8, 9}), gridString);

  Map<String, Variable> get letters => variableList.variables;
  @override
  List<int> get remainingValues => variableList.restrictedValues!;
  Set<Variable> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  @override
  postProcessing([bool iteration = true, int Function(Puzzle)? callback]) {
    if (iteration) {
      print("ITERATE SOLUTIONS-----------------------------");
      // Find ambiguous clues
      for (var clue in clues.values) {
        if ((clue).root66type == Root66ClueType.BCEFG &&
            clue.values != null &&
            clue.values!.length > 1) {
          var values = clue.values!;
          var valuestoRemove = <int>{};
          print('Ambiguous clue ${clue.name}=$values');
          for (var value in values) {
            if (duplicateDigit(value)) {
              valuestoRemove.add(value);
            }
          }
          values.removeAll(valuestoRemove);
          if (values.length > 1) {
            print('Still ambiguous clue ${clue.name}=$values');
          } else {
            print('Disambiguated clue ${clue.name}=${values.first}');
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
