import '../clue.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';

class ClueExpression with Expression {
  final Clue clue;
  final String expression;
  // References
  final _variableRefs = VariableRefList();
  List<VariableRef> get references => _variableRefs.references;
  List<String> get variableNameReferences => _variableRefs.variableNames;
  List<String> get clueNameReferences => _variableRefs.clueNames;
  List<String> get variableClueNameReferences => _variableRefs.names;
  Iterable<Variable> get variableReferences => _variableRefs.variables;
  Iterable<Variable> get clueReferences => _variableRefs.clues;
  Iterable<Variable> get variableClueReferences => _variableRefs.variableClues;

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
      for (var clueRef in clueExp.references.where((r) => r.isClue)) {
        var clueName = clueRef.name;
        var clue2 = puzzle.clues[clueName];
        if (clue2 == null) {
          clueError +=
              "ClueExpression ${clue1.name} expression '${clueExp.expression}' refers to clue '$clueName' which does not exist\n";
        } else {
          puzzle.addClueReference(clue1, clue2);
          clueRef.variable = clue2;
        }
      }
    }
    return clueError;
  }

  String checkVariableReferences(VariablePuzzle puzzle) {
    var variableError = '';
    for (var clueExp in clues) {
      var clue = clueExp.clue;
      for (var variableRef in clueExp.references.where((r) => r.isVariable)) {
        var variableName = variableRef.name;
        var variable = puzzle.variables[variableName];
        if (variable == null) {
          variableError +=
              "ClueExpression ${clue.name} expression '${clueExp.expression}' refers to variable '$variableName' which does not exist\n";
        } else {
          variableRef.variable = variable;
        }
      }
    }
    return variableError;
  }
}
