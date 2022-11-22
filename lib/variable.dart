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

  bool updatePossible(Set<int> possibleValues) {
    var updated =
        this.values.any((element) => !possibleValues.contains(element));
    this.values.removeWhere((element) => !possibleValues.contains(element));
    // if (this.values.length == 1) {
    //   this._value = this.values.first;
    // }
    return updated;
  }

  bool get isSet => this.values.length == 1;
}

/// A collection of [Variable]s, with a set of values
class VariableList<VariableKind extends Variable> {
  final Map<String, VariableKind> variables = {};
  late final List<int> remainingValues;
  // = List<int>.generate(9, (i) => i + 1);

  // Subclass constructor initializes remaining values
  VariableList(this.remainingValues);

  Set<String> updateVariables(String variableName, Set<int> possibleValues) {
    var updatedVariables = <String>{};
    // Get unknown variables before update this variable, in case of side effects
    // (EvenOdderVariable can set linked variable)
    var unknownVariableEntries =
        variables.entries.where((entry) => !entry.value.isSet).toList();
    var variable = variables[variableName]!;
    var updated = variable.updatePossible(possibleValues);
    if (updated) {
      updatedVariables.add(variableName);
      if (variable.isSet) {
        List<String> knownLetters = [variableName];
        int index = 0;
        while (index < knownLetters.length) {
          String letterKey = knownLetters[index];
          int letterValue = variables[letterKey]!.values.first;
          // Remove the known variable from all other variable possible values
          remainingValues.remove(letterValue);
          for (var entry in unknownVariableEntries) {
            if (!knownLetters.contains(entry.key)) {
              var entryVariable = entry.value;
              if (entryVariable.values.remove(letterValue) ||
                  entryVariable.isSet) {
                updatedVariables.add(entry.key);
                if (entryVariable.isSet) {
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
