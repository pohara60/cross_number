import "dart:math" as math;
import 'dart:math';

import 'clue.dart';
import 'expression.dart';
import 'puzzle.dart';
import 'set.dart';
import 'undo.dart';

mixin PriorityVariable {
  /// Computed - Count of combinations of variable values
  int priority = 0;
  int get count => priority;
}

/// Solve function
typedef SolveFunction = bool Function(
  Puzzle puzzle,
  Variable variable,
  Set<int> possibleValue, {
  Set<int>? possibleValue2,
  Map<Variable, Set<int>>? possibleVariables,
  Map<Variable, Set<int>>? possibleVariables2,
  Set<Variable>? updatedVariables,
});

enum VariableType {
  C('Clue'),
  E('Entry'),
  G('Cell'),
  V('Variable');

  final String name;
  const VariableType(this.name);
  int compareTo(VariableType other) => index.compareTo(other.index);
  @override
  String toString() => name;
}

/// A variable, with restricted values, commonly used in [Clue] for a [Puzzle]
class Variable with PriorityVariable {
  final VariableType variableType;

  /// Name
  final String name;

  SolveFunction? solve;

  /// List of variables that need to be examined when this clue is updated
  final referrers = <Variable>[];

  /// Current possible values, initialized in subclass
  Set<int>? _values;
  int? _min;
  int? _max;

  /// Forced value (when testing porrible solutions)
  int? _tryValue;

  /// Answer - preset to detect errors in puzzles with known answers
  int? _answer;
  set answer(int answer) {
    _answer = answer;
  }

  Variable(this.name, {this.variableType = VariableType.V, this.solve});
//    _values = {1, 2, 3, 4, 5, 6, 7, 8, 9};

  set tryValue(int? value) {
    _tryValue = value;
  }

  // ignore: unnecessary_getters_setters
  int? get tryValue => _tryValue;

  Set<int>? get values => _tryValue != null ? {_tryValue!} : _values;
  set values(Set<int>? values) {
    // print("!$name=${values == null ? 'null' : values.toShortString()}");
    UndoStack.push(this);
    valuesNoUndo = values;
  }

  set valuesNoUndo(Set<int>? values) {
    // print("!$name=${values == null ? 'null' : values.toShortString()}");
    _values = values;
    if (values == null || values.isEmpty) {
      min = max = null;
    } else {
      min = values.reduce(math.min);
      max = values.reduce(math.max);
    }
  }

  set value(int? value) {
    if (value != null) {
      UndoStack.push(this);
      values = {value};
    }
  }

  int? get value =>
      values != null && values!.length == 1 ? values!.first : null;

  bool get isSet => values != null && values!.length == 1;

  // ignore: unnecessary_getters_setters
  int? get min => _min;
  set min(int? min) => _min = min;
  // ignore: unnecessary_getters_setters
  int? get max => _max; // Remove hack ?? 10000; // Ugh!
  set max(int? max) => _max = max;

  @override
  String toString() {
    var text = '$name=';
    text += values == null ? '{unknown}' : values!.toShortString();
    return text;
  }

  compareTo(Variable other) {
    return name.compareTo(other.name);
  }

  int priorityCompareTo(Variable other) {
    var cmp = -priority.compareTo(other.priority);
    if (cmp == 0) {
      // Attempt consistent order - name
      cmp = -compareTo(other);
    }
    // if (cmp == 0) {
    //   // Attempt consistent order - hashcode
    //   cmp = hashCode.compareTo(other.hashCode);
    // }
    return cmp;
  }

  void checkAnswer(Set<int> values) {
    if (_answer == null) return;
    if (values.contains(_answer)) return;
    throw SolveError(
        'Variable $name answer $_answer not in values ${values.toShortString()}');
  }

  bool updatePossible(Set<int> possibleValues) {
    if (values == null) {
      values = Set.from(possibleValues);
      return true;
    }
    checkAnswer(possibleValues);
    // print("!$name=${possibleValues.toShortString()}");
    var updated = values!.any((element) => !possibleValues.contains(element));
    values!.removeWhere((element) => !possibleValues.contains(element));
    // if (this.values.length == 1) {
    //   this._value = this.values.first;
    // }
    return updated;
  }

  addReferrer(Variable variable) {
    if (!referrers.contains(variable)) referrers.add(variable);
  }

  // References
  final _variableRefs = VariableRefList();
  VariableRefList get variableRefs => _variableRefs;
  List<VariableRef> get references => _variableRefs.references;
  List<String> get variableNameReferences => _variableRefs.variableNames;
  List<String> get clueNameReferences => _variableRefs.clueNames;
  List<String> get entryNameReferences => _variableRefs.entryNames;
  List<String> get variableClueNameReferences =>
      _variableRefs.variableClueNames;
  Iterable<Variable> get variableReferences => _variableRefs.variables;
  Iterable<Variable> get clueReferences => _variableRefs.clues;
  Iterable<Variable> get entryReferences => _variableRefs.entries;
  Iterable<Variable> get variableClueReferences => _variableRefs.variableClues;

  addVariableReference(String variable) {
    _variableRefs.addVariableReference(variable);
  }

  addClueReference(String clueName) {
    _variableRefs.addClueReference(clueName);
  }

  removeClueReference(String name) {
    _variableRefs.removeClueReference(name);
  }

  void sortVariables() {
    _variableRefs.sort();
  }

  bool removeValue(int value) {
    // print("!$name=${possibleValues.toShortString()}");
    var updated = _values!.remove(value);
    checkAnswer(_values!);
    return updated;
  }
}

class VariableRef {
  final String name;
  VariableType type;
  Variable? variable;
  bool get isVariable => type == VariableType.V;
  bool get isClue => type == VariableType.C;
  bool get isEntry => type == VariableType.E;

  VariableRef(this.name, [this.type = VariableType.V]);
}

class VariableRefList {
  final _references = <VariableRef>[];
  List<VariableRef> get references => _references;
  List<String> get names => _references.map((r) => r.name).toList();
  List<String> get variableNames =>
      _references.where((r) => r.isVariable).map((r) => r.name).toList();
  List<String> get clueNames =>
      _references.where((r) => r.isClue).map((r) => r.name).toList();
  List<String> get entryNames =>
      _references.where((r) => r.isEntry).map((r) => r.name).toList();
  List<String> get variableClueNames => _references
      .where((r) => r.isVariable || r.isClue || r.isEntry)
      .map((r) => r.name)
      .toList();
  Iterable<Variable> get variables =>
      _references.where((r) => r.isVariable).map((r) => r.variable!);
  Iterable<Variable> get clues =>
      _references.where((r) => r.isClue).map((r) => r.variable!);
  Iterable<Variable> get entries =>
      _references.where((r) => r.isEntry).map((r) => r.variable!);
  Iterable<Variable> get variableClues => _references
      .where((r) => r.isVariable || r.isClue || r.isEntry)
      .map((r) => r.variable!);

  addReference(String name, VariableType type) {
    if (_references.indexWhere((r) => name == r.name) == -1) {
      _references.add(VariableRef(name, type));
    }
  }

  addVariableReference(String name) {
    addReference(name, VariableType.V);
  }

  addClueReference(String name) {
    // Clue references that start with E are entry references
    if (name[0] == 'E') {
      addEntryReference(name);
    } else {
      addReference(name, VariableType.C);
    }
  }

  addEntryReference(String name) {
    addReference(name, VariableType.E);
  }

  removeClueReference(String name) {
    _references.removeWhere((r) => r.name == name && r.isClue);
  }

  fixReference(String clueName) {
    for (var ref in _references) {
      if (ref.type == VariableType.C && ref.name == clueName) {
        ref.type = VariableType.V;
      }
    }
  }

  @override
  toString() => names.toString();

  void sort() {
    _references.sort((r1, r2) => r1.type.compareTo(r2.type) == -1 ||
            r1.type.compareTo(r2.type) == 0 && r1.name.compareTo(r2.name) == -1
        ? -1
        : 1);
  }
}

/// A collection of [Variable]s, with a set of values
class VariableList<VariableKind extends Variable> {
  final VariableType type;
  final Map<String, VariableKind> _variables = {};

  Map<String, VariableKind> get variables => _variables;
  VariableKind? operator [](String name) => _variables[name]; // get
  void operator []=(String name, VariableKind variable) =>
      _variables[name] = variable; // get
  bool get hasVariables => variables.isNotEmpty;
  Iterable<VariableKind> get values => _variables.values;

  late final List<int>? restrictedValues;
  late bool distinct;
  Set<int> get knownValues => variables.entries
      .where((entry) => entry.value.isSet)
      .map<int>((e) => e.value.value!)
      .toSet();
  // = List<int>.generate(9, (i) => i + 1);

  // Subclass constructor initializes remaining values
  VariableList(this.type, [this.restrictedValues])
      : distinct = restrictedValues != null;

  void add(VariableKind variable) {
    _variables[variable.name] = variable;
  }

  Set<Variable> updateVariables(String variableName, Set<int> possibleValues) {
    // Already known?
    var variable = variables[variableName]!;
    if (variable.isSet) {
      // Nothing to do
      assert(possibleValues.contains(variable.value!));
      return {};
    }
    // Get unknown variables before update this variable, in case of side effects
    // (EvenOdderVariable can set linked variable)
    var updatedVariables = <Variable>{};
    var unknownVariableEntries =
        variables.entries.where((entry) => !entry.value.isSet).toList();
    var updated = variable.updatePossible(possibleValues);
    if (updated) {
      updatedVariables.add(variable);
      // Only check for distinct variables when have remainingValues
      if (variable.isSet && distinct) {
        List<String> knownLetters = [variableName];
        int index = 0;
        while (index < knownLetters.length) {
          String letterKey = knownLetters[index];
          int letterValue = variables[letterKey]!.values!.first;
          // Remove the known variable from all other variable possible values
          // restrictedValues!.remove(letterValue);
          for (var entry in unknownVariableEntries) {
            if (!knownLetters.contains(entry.key)) {
              var entryVariable = entry.value;
              if (entryVariable.values != null) {
                if (entryVariable.removeValue(letterValue)) {
                  updatedVariables.add(entry.value);
                }
                if (entryVariable.isSet) knownLetters.add(entry.key);
              }
            }
          }
          index++;
        }
      }
      for (var updatedVariable in updatedVariables) {
        if (updatedVariable.values != null &&
            updatedVariable.values!.isNotEmpty) {
          updatedVariable.min = updatedVariable.values!.reduce(min);
          updatedVariable.max = updatedVariable.values!.reduce(max);
        }
      }
    }
    return updatedVariables;
  }

  @override
  String toString() {
    if (variables.isEmpty) return '';

    var text = 'Variables:\n';
    for (var variableName in variables.keys.toList()..sort()) {
      text += '${variables[variableName]}\n';
    }
    if (restrictedValues != null && restrictedValues!.isNotEmpty) {
      var remainingValues =
          List.from(Set<int>.from(restrictedValues!)..removeAll(knownValues));
      text += 'RemainingValues: ${remainingValues.toString()}\n';
    }
    return text;
  }

  String toSummary() {
    return this.toString();
  }
}

class ExpressionVariable extends Variable with Expression {
  final String valueDesc;

  ExpressionVariable(
    String name,
    this.valueDesc, {
    int min = 1,
    int? max,
    String variablePrefix = '',
    SolveFunction? solve,
  }) : super(name, solve: solve) {
    initExpression(valueDesc, variablePrefix, name, _variableRefs);
    this.min = min;
    this.max = max;
  }

  bool fixReference(clueName) {
    var updated = false;
    for (var exp in expressions) {
      var name = exp.fixReference(clueName);
      if (name != '' && name != clueName) {
        if (variableNameReferences.contains(clueName)) {
          variableNameReferences.remove(clueName);
          variableNameReferences.add(name);
        }
        updated = true;
      }
    }
    if (updated) {
      _variableRefs.fixReference(clueName);
    }
    return updated;
  }

  Set<int>? getValuesFromMinMax() {
    if (_max == null || _min == null || _max! - _min! > 1000) return null;
    return Set.from(List.generate(_max! - _min! + 1, (index) => _min! + index));
  }

  @override
  String toString() {
    var text = super.toString();
    if (valueDesc != '') {
      text += ',$valueDesc';
    }
    if (!isSet) {
      text += ',min=$_min';
      text += ',max=$_max';
    }
    return text;
  }
}
