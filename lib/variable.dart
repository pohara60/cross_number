import 'package:crossnumber/clue.dart';
import 'package:crossnumber/set.dart';

/// A variable, with restricted values, commonly used in [Clue] for a [Puzzle]
class Variable {
  /// Name
  final String name;

  /// Current possible values, initialized in subclass
  late Set<int> _values;

  /// Forced value (when testing porrible solutions)
  int? _value;

  Variable(this.name);
//    _values = {1, 2, 3, 4, 5, 6, 7, 8, 9};

  tryValue(int value) => _value = value;
  Set<int> get values => _value != null ? {_value!} : _values;
  set values(Set<int> values) => _values = values;

  String toString() {
    return values.toShortString();
  }
}

/// A collection of [Variable]s, with a set of values
class VariableList<VariableKind extends Variable> {
  final Map<String, VariableKind> variables = {};
  late final List<int> remainingValues;
  // = List<int>.generate(9, (i) => i + 1);

  // Subclass constructor initializes remaining values
  VariableList(this.remainingValues);

  Set<String> updateVariables(String variable, Set<int> possibleValues) {
    var updatedVariables = <String>{};
    var possibleVariableValues = variables[variable]!.values;
    var updated = updatePossible(possibleVariableValues, possibleValues);
    if (updated) {
      updatedVariables.add(variable);
      if (possibleVariableValues.length == 1) {
        List<String> knownLetters = [variable];
        int index = 0;
        while (index < knownLetters.length) {
          String letterKey = knownLetters[index];
          int letterValue = variables[letterKey]!.values.first;
          // Remove the known variable from all other variable possible values
          remainingValues.remove(letterValue);
          for (var entry in variables.entries) {
            if (entry.key != letterKey) {
              if (entry.value.values.remove(letterValue)) {
                updatedVariables.add(entry.key);
                if (entry.value.values.length == 1) {
                  knownLetters.add(entry.key);
                }
              }
            }
          }
          index++;
        }
      }
    }
    return updatedVariables;
  }

  String toString() {
    var text = 'Variables:\n';
    for (var entry in variables.entries) {
      text += '${entry.key}=${entry.value.values}\n';
    }
    text += 'RemainingValues: ${remainingValues.toString()}\n';
    return text;
  }

  String toSummary() {
    return this.toString();
  }
}
