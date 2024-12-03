import 'package:collection/collection.dart';

import '../clue.dart';
import '../expression.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class AfterNicholasVariable extends Variable {
  AfterNicholasVariable(super.letter) {
    values = Set.from({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16});
  }
  String get letter => name;
}

class AfterNicholasPuzzle extends VariablePuzzle<AfterNicholasClue,
    AfterNicholasEntry, AfterNicholasVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  AfterNicholasPuzzle({String name = ''}) : super(null, name: name);
  AfterNicholasPuzzle.fromGridString(List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  void getRelatedVariables() {
    // Find ordered sets of solvable variables that refer to each other
    // In this puzzle there are across and down clues that refer to the same set
    // of variables
    var remainingVariables = allVariables.values
        .where((variable) => variable.solve != null)
        .toList();
    while (remainingVariables.isNotEmpty) {
      var variable = remainingVariables.removeAt(0);
      if (variable is Expression) {
        var relatedVariables = [variable];
        remainingVariables.remove(variable);
        var index = 0;
        while (index < relatedVariables.length) {
          var variable = relatedVariables[index++];

          // Add variables that references the same variables as this variable
          var varRefs = Set<Variable>.from(variable.variableReferences);
          Variable? variableSameRefs;
          for (var otherVariable in remainingVariables) {
            var otherVarRefs =
                Set<Variable>.from(otherVariable.variableReferences);
            Function eq = const SetEquality().equals;
            if (eq(otherVarRefs, varRefs)) {
              variableSameRefs = otherVariable;
              break;
            }
          }
          if (variableSameRefs != null) {
            if (!relatedVariables.contains(variableSameRefs)) {
              relatedVariables.add(variableSameRefs);
            }
            remainingVariables.remove(variableSameRefs);
          }
        }
        allRelatedVariables.add(relatedVariables);
      }
    }
    for (var relatedVariables in allRelatedVariables) {
      print(
          'relatedVariables=${relatedVariables.map((e) => '${e is EntryMixin ? 'E' : ''}${e.name}').join(',')}');
    }
  }
}
