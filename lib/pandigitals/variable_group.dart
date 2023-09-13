import '../clue.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';

class ClueExpression with Expression {
  final Clue clue;
  final String expression;
  // References
  final _variableRefs = VariableRefList();
  List<String> get variableReferences => _variableRefs.variableNames;
  List<String> get clueReferences => _variableRefs.clueNames;
  List<String> get variableClueReferences => _variableRefs.names;

  ClueExpression(this.clue, this.expression) {
    initExpression(expression, '', clue.name, _variableRefs);
  }

  String toString() {
    var text = '$runtimeType ${clue.name}=$expression';
    return text;
  }
}

class VariableGroup {
  final String name;
  final List<Variable> variables;
  final values = <List<int>>[];
  final clues = <ClueExpression>[];

  VariableGroup(this.name, this.variables);

  String toString() {
    var text = '$runtimeType $name\n';
    for (var clueExp in clues) {
      text += clueExp.toString() + '\n';
    }
    return text.substring(0, text.length - 1);
  }

  String checkClueReferences(Puzzle puzzle) {
    var clueError = '';
    for (var clueExp in clues) {
      var clue1 = clueExp.clue;
      for (var clueName in clueExp.clueReferences) {
        var clue2 = puzzle.clues[clueName];
        if (clue2 == null) {
          clueError +=
              "ClueExpression ${clue1.name} expression '${clueExp.expression}' refers to clue '$clueName' which does not exist\n";
        } else {
          puzzle.addClueReference(clue1, clue2);
        }
      }
    }
    return clueError;
  }

  String checkVariableReferences(VariablePuzzle puzzle) {
    var variableError = '';
    for (var clueExp in clues) {
      var clue = clueExp.clue;
      for (var variableName in clueExp.variableReferences) {
        var variable = puzzle.variables[variableName];
        if (variable == null) {
          variableError +=
              "ClueExpression ${clue.name} expression '${clueExp.expression}' refers to variable '$variableName' which does not exist\n";
        }
      }
    }
    return variableError;
  }
}
