import '../clue.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class OpposingDigitSumVariable extends Variable {
  OpposingDigitSumVariable(super.letter) {
    values = <int>{};
  }
  String get letter => name;
}

class OpposingDigitSumPuzzle extends VariablePuzzle<OpposingDigitSumClue,
    OpposingDigitSumEntry, OpposingDigitSumVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  OpposingDigitSumPuzzle({String name = ''}) : super(null, name: name);
  OpposingDigitSumPuzzle.fromGridString(List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name) {
    distinctClues = false;
  }

  OpposingDigitSumEntry getOppositeEntry(OpposingDigitSumEntry entry) {
    var row = entry.row!;
    var col = entry.col!;
    var oppositeRow =
        grid!.numRows - (entry.isAcross ? row + 1 : row + entry.length!);
    var oppositeCol =
        grid!.numCols - (entry.isDown ? col + 1 : col + entry.length!);
    var oppositeEntry = grid!.rows[oppositeRow][oppositeCol].entries
        .firstWhere((e) => e.isAcross == entry.isAcross);
    return oppositeEntry as OpposingDigitSumEntry;
  }

  @override
  List<Variable>? relatedVariablesForVariable(Variable variable) {
    for (var relatedVariables in allRelatedVariables) {
      if (relatedVariables.contains(variable)) {
        return relatedVariables;
      }
    }
    return null;
  }

  @override
  void getRelatedVariables() {
    // Find ordered sets of solvable variables that refer to each other
    var remainingVariables = allVariables.values
        .where((variable) => variable.solve != null)
        .toList();
    while (remainingVariables.isNotEmpty) {
      var variable = remainingVariables.removeAt(0);
      var relatedVariables = [variable];
      remainingVariables.remove(variable);
      var index = 0;
      while (index < relatedVariables.length) {
        var variable = relatedVariables[index++];

        // Add variables this variable references
        for (var variableRef in variable.variableClueReferences) {
          if (!relatedVariables.contains(variableRef)) {
            relatedVariables.add(variableRef);
            remainingVariables.remove(variableRef);
          }
        }
        // Add variables that reference this variable
        var variablesToRemove = <Variable>[];
        for (var otherVariable in remainingVariables) {
          if (otherVariable.variableClueReferences.contains(variable)) {
            relatedVariables.add(otherVariable);
            variablesToRemove.add(otherVariable);
          }
        }
        remainingVariables.removeWhere((v) => variablesToRemove.contains(v));
      }
      allRelatedVariables.add(relatedVariables);
    }
    for (var relatedVariables in allRelatedVariables) {
      print(
          'relatedVariables=${relatedVariables.map((e) => '${e is EntryMixin ? 'E' : ''}${e.name}').join(',')}');
    }
  }
}
