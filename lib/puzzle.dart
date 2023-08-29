import 'package:crossnumber/cartesian.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/expression.dart';
import 'package:crossnumber/grid.dart';
import 'package:crossnumber/variable.dart';

class Puzzle<ClueKind extends Clue, EntryKind extends ClueKind> {
  final _clues = <String, ClueKind>{};
  final _entries = <String, EntryKind>{};
  Map<String, ClueKind> get clues => _clues.isNotEmpty ? _clues : _entries;
  Map<String, EntryKind> get entries => _clues.isNotEmpty ? _entries : {};

  Grid? grid;

  Puzzle() {}
  Puzzle.grid(List<String> gridString) {
    this.grid = Grid(gridString);
  }

  void addClue(ClueKind clue) {
    _clues[clue.name] = clue;
  }

  void addEntry(EntryKind entry) {
    _entries[entry.name] = entry;
  }

  // clue1[digit1-1] = clue2[digit2-1]
  void addDigitIdentity(
      EntryMixin entry1, int digit1, EntryMixin entry2, int digit2) {
    entry1.digitIdentities[digit1 - 1] =
        DigitIdentity(entry: entry2, digit: digit2 - 1);
    entry2.digitIdentities[digit2 - 1] =
        DigitIdentity(entry: entry1, digit: digit1 - 1);
    entry2.addReferrer(entry1);
    entry1.addReferrer(entry2);
  }

  List<EntrySpec> getEntriesFromGrid() {
    assert(this.grid != null);
    return this.grid!.entries;
  }

  void addDigitIdentityFromGrid() {
    assert(this.grid != null);
    for (var identity in this.grid!.getIdentities()) {
      var entry1 = this._entries[identity['entry1']]!;
      var entry2 = this._entries[identity['entry2']]!;
      addDigitIdentity(entry1 as EntryMixin, identity['digit1'],
          entry2 as EntryMixin, identity['digit2']);
    }
  }

  /// clue1 refers to clue2
  void addClueReference(Clue clue1, Clue clue2, [bool symmetric = false]) {
    clue2.addReferrer(clue1);
    if (symmetric) {
      clue1.addReferrer(clue2);
    }
  }

  /// entry1 refers to entry2
  void addEntryReference(Clue entry1, Clue entry2, [bool symmetric = false]) {
    entry2.addReferrer(entry1);
    if (symmetric) {
      entry1.addReferrer(entry2);
    }
  }

  String toString() {
    var text = 'Puzzle\n';
    for (var clue in clues.values) {
      text += clue.toString() + '\n';
    }
    for (var entry in entries.values) {
      text += entry.toString() + '\n';
    }
    return text;
  }

  String toSummary() {
    var text = 'Puzzle Summary\n';
    for (var clue in clues.values) {
      text += clue.toSummary() + '\n';
    }
    if (grid != null) text += toSolution();
    return text;
  }

  String toSolution() {
    var text = '';
    // ignore: unused_local_variable
    var unique = true;
    var anyClue = false;
    var entryValues = <String, List<String>>{};
    for (var clue in clues.values) {
      if (clue.values == null || clue.values!.length > 1)
        unique = false;
      else if (clue.entry != null) {
        var e = clue.entry! as EntryMixin;
        entryValues[clue.entry!.name] = e.digits
            .map((dl) => dl.length == 1
                ? dl.first.toString()
                : dl.length == 0
                    ? ''
                    : '?')
            .toList();
        ;
        anyClue = true;
      }
    }
    if (anyClue) text += '${grid!.solutionToString(entryValues)}';
    return text;
  }

  List<int> knownValues = [];

  bool updateValues(Clue clue, Set<int> possibleValue) {
    possibleValue.removeAll(knownValues);
    var updated = clue.updateValues(possibleValue);
    if (possibleValue.length == 1) {
      knownValues.addAll(possibleValue);
    }
    return updated;
  }

  void fixClue(String clueName, int value) {
    var clue = this.clues[clueName];
    if (clue != null) {
      updateValues(clue, {value});
      clue.finalise();
      if (Crossnumber.traceSolve) {
        print('Fix clue $clueName=$value');
      }
    }
  }

  void resetSolution() {
    knownValues = [];
    for (var clue in this.clues.values) {
      clue.reset();
    }
  }

  bool uniqueSolution() {
    return !this
        .clues
        .values
        .any((clue) => clue.values == null || clue.values!.length != 1);
  }

  postProcessing([bool iteration = true]) {
    if (iteration) {
      print("ITERATE SOLUTIONS-----------------------------");
      var count = iterate();
      print('Solution count=$count');
    }
  }

  Map<Clue, Answer> solution = {};
  List<Clue> order = [];

  int iterate() {
    if (this is VariablePuzzle) {
      var puzzle = this as VariablePuzzle;
      return puzzle.iterateVariables();
    }
    return iterateValues();
  }

  int iterateValues() {
    var unknownClues = <Clue>[];
    var clues = this.clues.values.toList();
    clues.sort((c1, c2) {
      if (c1.values == null) {
        if (c2.values == null) return 0;
        return 1;
      }
      if (c2.values == null) return -1;
      return c1.values!.length.compareTo(c2.values!.length);
    });
    for (var clue in clues) {
      if (clue.values == null) {
        if (!unknownClues.contains(clue)) {
          unknownClues.add(clue);
        }
      } else {
        var values = clue.values!.toList();
        values.sort();
        solution[clue] = Answer(values);
        if (!order.contains(clue)) {
          // Add clue and its dependents
          order.add(clue);
          // for (var clue2 in clue.referrers) {
          //   if (!order.contains(clue2)) {
          //     if (clue2.values == null) {
          //       if (!unknownClues.contains(clue2)) {
          //         unknownClues.add(clue2);
          //       }
          //     } else {
          //       // Add clue
          //       order.add(clue2);
          //     }
          //   }
          // }
        }
      }
    }
    order.addAll(unknownClues);
    var count = 0;
    count = findSolutions(order, 0, count);
    return count;
  }

  int findSolutions(List<Clue> order, int next, int count) {
    while (next < order.length &&
        solution[order[next]] != null &&
        solution[order[next]]!.value != null) {
      // print(
      // 'findSolutions: next=$next, skip ${order[next].name}=${solution[order[next]]!.value} next=${next + 1}');
      next++;
    }
    if (next == order.length) {
      if (checkSolution()) {
        print(solutionToString());
        count++;
        // print('findSolutions: end of clues, solution $count!');
      } else {
        // print('findSolutions: end of clues, no solution');
      }
    } else {
      var clue = order[next];
      if (clue.values == null) {
        //checkSolution();
        var possibleValue = <int>{};
        var possibleVariables = <String, Set<int>>{};
        if (clue is VariableClue) {
          for (var variable in clue.variableReferences) {
            possibleVariables[variable] = <int>{};
          }
          clue.solve!(clue, possibleValue, possibleVariables);
        } else {
          clue.solve!(clue, possibleValue);
        }
        if (possibleValue.isEmpty) {
          // print(
          //     'findSolutions: next=$next, clue=${clue.name}, no values, none found');
          return count;
        }
        // print(
        //     'findSolutions: next=$next, clue=${clue.name}, no values, found ${possibleValue.toShortString()}');
        solution[clue] = Answer(List.from(possibleValue));
      } else {
        // print(
        //     'findSolutions: next=$next, clue=${clue.name}, values ${clue.values!.toShortString()}');
      }
      // Try each of the possible values for this clue
      for (var value in solution[clue]!.possible) {
        // Check that this value is consistent with other clues
        if (!clueValuesMatch(clue, value)) {
          // print(
          //     'findSolutions: next=$next, clue=${clue.name}, value $value does not match');
          continue;
        }
        // Consistent, try this value
        solution[clue]!.value = value;
        clue.tryValue = value;
        //print('findSolutions: next=$next, clue=${clue.name}, try value $value');
        count = findSolutions(order, next + 1, count);
        solution[clue]!.value = null;
        clue.tryValue = null;
      }
    }
    //return count;
    return count;
  }

  bool checkSolution() {
    var ok = true;
    var failedClues = <Clue>[];
    for (var clue in solution.keys) {
      if (solution[clue] != null) {
        var value = solution[clue]!.value;
        var possibleValue = <int>{};
        clue.solve!(clue, possibleValue);
        if (possibleValue.isEmpty || !possibleValue.contains(value)) {
          // Failed
          failedClues.add(clue);
          ok = false;
        }
      }
    }

    //print('Check $ok ${failedClues.map((e) => e.name)} ${solutionToString()}');
    return ok;
  }

  bool clueValuesMatch(Clue clue, int value) {
    var match = true;
    for (var d = 0; d < clue.length && match; d++) {
      if (clue.digitIdentities[d] != null) {
        var clue2 = clue.digitIdentities[d]!.clue;
        var d2 = clue.digitIdentities[d]!.digit;
        if (solution[clue2] != null) {
          var value2 = solution[clue2]!.value;
          if (value2 != null) {
            if (value.toString()[d] != value2.toString()[d2]) {
              // Inconsistent values
              match = false;
            }
          }
        }
      }
    }
    return match;
  }

  String solutionToString() {
    var text = "Solution\n";
    var keys = solution.keys.toList();
    keys.sort((c1, c2) => c1.compareTo(c2));
    var clueValues = <String, List<String>>{};
    var unique = true;
    for (var clue in keys) {
      text +=
          '${clue.name}=${solution[clue]!.value ?? solution[clue]!.possible}\n';
      if (solution[clue]!.value == null) {
        unique = false;
      } else {
        clueValues[clue.name] = solution[clue]!.value!.toString().split('');
      }
    }
    if (unique && this.grid != null) {
      text += '\n${grid!.solutionToString(clueValues)}';
    }
    return text;
  }

  void mapCluesToEntries(Function callback) {
    var entryClues = <String, Set<Clue>>{};
    var entryDigits = <String, List<Set<int>>>{};
    var entryValues = <String, Set<int>>{};
    var clueEntries = <String, Set<Clue>>{};

    print("POTENTIAL SOLUTIONS-----------------------------");
    // ignore: unused_local_variable
    for (var mapped in mapNextClueToEntry(_entries.values.toList(), 0)) {
      // var mapping =
      //     "${entries.values.where((e) => (e as EntryMixin).clue != null).map((e) {
      //   var c = (e as EntryMixin).clue!;
      //   return '${e.name}=${c.name}${c.values})';
      // }).join(',')}";
      // print('Mapping $mapping');

      print(toSolution());

      for (var entry in entries.values) {
        var e = entry as EntryMixin;
        var clue = e.clue;
        if (clue != null) {
          entryClues[e.name] = (entryClues[e.name] ?? {})..add(clue);
          clueEntries[clue.name] = (clueEntries[clue.name] ?? {})..add(entry);
          if (clue.values != null) {
            entryValues[e.name] = (entryValues[e.name] ?? {})
              ..addAll(clue.values!);
          }
          // make sure digits are updated
          clue.initialise();
        }
        // Get entry digits
        var digits = entryDigits[e.name];
        if (digits == null) {
          entryDigits[e.name] = digits = List.generate(e.length, (index) => {});
        }
        for (var d = 0; d < e.length; d++) {
          digits[d].addAll(e.digits[d]);
        }
      }
    }
    // print(entryClues.entries
    //     .map((e) => '${e.key}:${e.value.map((c) => c.name).toList()}')
    //     .toList()
    //   ..sort());
    // print(clueEntries.entries
    //     .map((e) => '${e.key}:${e.value.map((c) => c.name).toList()}')
    //     .toList()
    //   ..sort());

    // Compute entry values and set digits
    for (var entry in entries.values) {
      var e = entry as EntryMixin;
      // Map clue?
      if (entryClues[e.name] != null && entryClues[e.name]!.length == 1) {
        var clue = entryClues[e.name]!.first;
        mapClueToEntry(clue as ClueKind, entry);
      }
      if (entryValues[e.name] != null) {
        entry.values = entryValues[e.name];
      }
      // Get entry digits
      var digits = entryDigits[e.name];
      var product = 1;
      if (digits != null) {
        for (var d = 0; d < e.length; d++) {
          e.digits[d] = digits[d];
          product *= digits[d].length;
        }
      }
      // If no values then compute them from digits
      if (entry.values == null) {
        if (product < 10000) {
          var values = <int>{};
          void addValues(int index, int value) {
            if (index == e.length) {
              values.add(value);
            } else {
              int nextValue = value * 10;
              for (var digit in e.digits[index]) {
                if (digit > 9) nextValue = value * 100;
                addValues(index + 1, nextValue + digit);
              }
            }
          }

          addValues(0, 0);
          entry.values = values;
        }
      }
    }
    // print((entries.values
    //         .map((e) =>
    //             '${e.name}:${e.values?.toShortString()}:${e.digits.toShortString()}')
    //         .toList()
    //       ..sort())
    //     .toString()
    //     .replaceAll(', ', '\n'));
    //print(toSolution());
  }

  Iterable<bool> mapNextClueToEntry(List<EntryKind> entries, int index) sync* {
    if (index == entries.length) {
      yield true;
      return;
    }

    var entry = entries[index];
    ClueKind? mappedClue = (entry as EntryMixin).clue as ClueKind?;

    for (var clue in mappedClue != null
        ? [mappedClue]
        : _clues.values.where((c) =>
            c.isAcross == entry.isAcross &&
            c.length == entry.length &&
            c.entry == null)) {
      // Set mapping
      mapClueToEntry(clue, entry);

      // Save values and entry digits
      var oldValues = clue.values;
      var savedDigits = clue.saveDigits();

      // Update entry from clue
      if (updateEntry(clue)) {
        // Try to map remaining clues
        yield* mapNextClueToEntry(entries, index + 1);
      } else if (mappedClue != null) {
        if (Crossnumber.traceSolve) {
          print(
              'Clue ${mappedClue.name} mapping to Entry ${entry.name} is invalid');
        }
      }

      // Undo mapping
      clue.values = oldValues;
      clue.restoreDigits(savedDigits);
      clue.entry = null;
      (entry as EntryMixin).clue = null;
    }

    if (Crossnumber.traceSolve) {
      // var mapping =
      //     "${entries.where((e) => (e as EntryMixin).clue != null).map((e) {
      //   var c = (e as EntryMixin).clue!;
      //   return '${e.name}=${c.name}${c.values})';
      // }).join(',')}";
      // print('Mapping failed for entry ${entry.name}');
      // print(mapping);
      // print(toSolution());
    }
    return;
  }

  bool updateEntry(ClueKind clue) {
    // Update entry digits from other entries
    clue.initialise();

    // Check values against permissible digits
    if (clue.values == null) return true;

    if (clue.values!.isNotEmpty) {
      var okValues = <int>{};
      for (var value in clue.values!) {
        if (clue.digitsMatch(value)) {
          okValues.add(value);
        }
      }
      if (okValues.isNotEmpty) {
        // Update values and digits
        clue.values = okValues;
        clue.finalise();
        return true;
      }
    }

    return false;
  }

  void mapClueToEntryByName(String clueName, String entryName) {
    var clue = _clues[clueName]!;
    var entry = _entries[entryName]!;
    mapClueToEntry(clue, entry);
  }

  void mapClueToEntry(ClueKind clue, EntryKind entry) {
    clue.entry = entry;
    (entry as EntryMixin).clue = clue;
  }
}

/// PuzzleException for puzzle definition
class PuzzleException implements Exception {
  final String msg;
  PuzzleException(this.msg);
}

/// SolveException for puzzle solution
class SolveException implements Exception {
  String? msg;
  SolveException([this.msg]);
}

class VariablePuzzle<ClueKind extends Clue, EntryKind extends ClueKind,
    VariableKind extends Variable> extends Puzzle<ClueKind, EntryKind> {
  late final VariableList variableList;
  bool get hasVariables => variableList.hasVariables;

  VariablePuzzle(List<int> possibleValues) {
    variableList = VariableList<VariableKind>(possibleValues);
  }
  VariablePuzzle.grid(List<int> possibleValues, List<String> gridString)
      : super.grid(gridString) {
    variableList = VariableList<VariableKind>(possibleValues);
  }

  Map<String, Variable> get variables => variableList.variables;
  List<int> get remainingValues => variableList.remainingValues;
  Set<String> updateVariables(String variable, Set<int> possibleValues) =>
      variableList.updateVariables(variable, possibleValues);

  String checkClueReferences() {
    var clueError = '';
    for (var entry in clues.entries) {
      var clue1 = entry.value;
      for (var clueName in clue1.clueReferences) {
        var clue2 = clues[clueName];
        if (clue2 == null) {
          clueError +=
              "Clue ${clue1.name} expression '${clue1.valueDesc}' refers to clue '$clueName' which does not exist\n";
        } else {
          addClueReference(clue1, clue2);
          // Simple circular reference check
          if (clue2.clueReferences.contains(clue1.name)) {
            clue1.circularClueReference = true;
            clue2.circularClueReference = true;
          }
        }
      }
    }
    return clueError;
  }

  String checkClueVariableReferences(Map<String, ClueKind> clues) {
    var variableError = '';
    for (var entry in clues.entries) {
      var clue = entry.value;
      for (var variableName in (clue as VariableClue).variableReferences) {
        var variable = variables[variableName];
        if (variable == null) {
          variableError +=
              "$runtimeType ${clue.name} expression '${clue.valueDesc}' refers to variable '$variableName' which does not exist\n";
        }
      }
    }
    return variableError;
  }

  String checkVariableReferences() {
    var variableError = '';
    variableError += checkClueVariableReferences(_clues);
    variableError += checkClueVariableReferences(_entries);
    return variableError;
  }

  int getClueCount(VariableClue clue, List<List<int>> variableValues) {
    for (var variable in clue.variableReferences) {
      variableValues.add(this.variables[variable]!.values!.toList());
    }
    return cartesianCount(variableValues);
  }

  int getEntryCount(VariableEntry clue, List<List<int>> variableValues) {
    for (var variable in clue.variableReferences) {
      variableValues.add(this.variables[variable]!.values!.toList());
    }
    return cartesianCount(variableValues);
  }

  void updateClueCount(VariableClue clue) {
    var variableValues = <List<int>>[];
    clue.count = getClueCount(clue, variableValues);
  }

  // Expression evaluator, supports variables with expression callback
  void solveVariableExpression(
      Clue clue,
      Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables,
      int expression(List<int> variables)) {
    final stopwatch = Stopwatch()..start();
    var variableValues = <List<int>>[];
    var count = clue is VariableClue
        ? getClueCount(clue, variableValues)
        : clue is VariableEntry
            ? getEntryCount(clue, variableValues)
            : null;
    if (count! > 1000000) {
      if (Crossnumber.traceSolve) {
        print('Func ${clue.name} cartesianCount=$count Exception');
      }
      throw new SolveException();
    }
    for (var product in cartesian(variableValues)) {
      var value = expression(product);
      if (value >= clue.min && value < clue.max + 1) {
        if (clue.digitsMatch(value)) {
          possibleValue.add(value);
          var index = 0;
          for (var variable in clue.variableReferences) {
            possibleVariables[variable]!.add(product[index++]);
          }
        }
      }
    }
    if (Crossnumber.traceSolve) {
      if (count != 1) {
        print(
            'Func ${clue.name} cartesianCount=$count, elapsed ${stopwatch.elapsed}');
      }
    }
  }

  // Generic expression evaluator, supports variables
  bool solveVariableExpressionEvaluator(ExpressionClue clue,
      Set<int> possibleValue, Map<String, Set<int>> possibleVariables,
      [bool Function(ExpressionClue, int, List<String>, List<int>)?
          validValue]) {
    final stopwatch = Stopwatch()..start();
    var variableValues = <List<int>>[];
    for (var variable in clue.variableReferences) {
      variableValues.add(this.variables[variable]!.values!.toList());
    }
    var count = cartesianCount(variableValues);
    if (count > 500000000) {
      //if (count > 1000000) {
      if (Crossnumber.traceSolve) {
        print('Eval ${clue.name} cartesianCount=$count Exception');
      }
      throw new SolveException();
    }
    for (var product in cartesian(variableValues)) {
      try {
        var value = clue.exp.evaluate(clue.variableReferences, product);
        if (value >= clue.min && value < clue.max + 1) {
          var valid = validValue == null
              ? clue.digitsMatch(value)
              : validValue(clue, value, clue.variableReferences, product);
          if (valid) {
            possibleValue.add(value);
            var index = 0;
            for (var variable in clue.variableReferences) {
              possibleVariables[variable]!.add(product[index++]);
            }
            // if (Crossnumber.traceSolve) {
            //   print('${clue.name}=$value, ${clue.variableReferences}=$product');
            // }
          }
        }
      } on ExpressionInvalid {
        // Illegal values
      }
    }
    if (Crossnumber.traceSolve) {
      print(
          'Eval ${clue.name} cartesianCount=$count, elapsed ${stopwatch.elapsed}');
    }
    return false;
  }

  // Generic expression evaluator, supports variables, clues, generators and functions
  bool solveExpressionEvaluator(ExpressionClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleVariables,
      [bool Function(ExpressionClue, int, List<String>, List<int>)?
          validValue]) {
    final stopwatch = Stopwatch()..start();
    var variableValues = <List<int>>[];
    for (var variable in clue.variableReferences) {
      variableValues.add(this.variables[variable]!.values!.toList());
    }
    for (var variable in clue.clueReferences) {
      var otherClue = this.clues[variable]!;
      // Clue values may not yet be available
      var clueValues = otherClue.values;
      if (clueValues == null) {
        // Try guessing other clue values for circular reference
        if (clue.circularClueReference) {
          clueValues = getValuesFromClueDigits(otherClue);
        }
        if (clueValues == null) throw new SolveException();
      }
      variableValues.add(clueValues.toList());
    }
    var count = cartesianCount(variableValues);
    if (count > 500000000) {
      //if (count > 1000000) {
      if (Crossnumber.traceSolve) {
        print('Eval ${clue.name} cartesianCount=$count Exception');
      }
      throw new SolveException();
    }
    for (var product
        in variableValues.isEmpty ? [<int>[]] : cartesian(variableValues)) {
      try {
        for (var value in clue.exp.generate(
            clue.min, clue.max, clue.variableClueReferences, product)) {
          if (value >= clue.min && value < clue.max + 1) {
            var valid = validValue == null
                ? clue.digitsMatch(value)
                : validValue(clue, value, clue.variableClueReferences, product);
            if (valid) {
              possibleValue.add(value);
              var index = 0;
              for (var variable in clue.variableReferences) {
                possibleVariables[variable]!.add(product[index++]);
              }
              // if (Crossnumber.traceSolve) {
              //   print('${clue.name}=$value, ${clue.variableReferences}=$product');
              // }
            }
          }
        }
      } on ExpressionInvalid {
        // Illegal values
      }
    }
    if (Crossnumber.traceSolve) {
      print(
          'Eval ${clue.name} cartesianCount=$count, elapsed ${stopwatch.elapsed}');
      // print('${clue.exp.toString()}');
      // for (var v in clue.variableReferences) {
      //   print('$v=${this.variables[v]!.values!.toList()}');
      // }
    }
    return false;
  }

  int iterateVariables() {
    // Iterate over possible variable values
    var variableValues = <List<int>>[];
    var variableNames = <String>[];
    for (var variable in this.variables.keys) {
      variableNames.add(variable);
      variableValues.add(this.variables[variable]!.values!.toList());
    }
    var count = 0;
    //for (var product in [      [8, 3, 5, 1, 7, 4, 9, 2, 6]    ]) {
    for (var product in cartesian(variableValues)) {
      for (var i = 0; i < product.length; i++) {
        this.variables[variableNames[i]]!.tryValue = product[i];
      }
      // Check all clues
      var found = true;
      solution = {};
      for (var clue in this.clues.values) {
        if (clue is VariableClue) {
          var possibleValue = <int>{};
          Map<String, Set<int>> possibleLetters = {};
          for (var variable in clue.variableReferences) {
            possibleLetters[variable] = <int>{};
          }
          clue.solve!(clue, possibleValue, possibleLetters);
          if (possibleValue.length == 1) {
            // Check that this value is consistent with other clues
            var value = possibleValue.first;
            found = clueValuesMatch(clue, value);
            if (found) {
              solution[clue] = Answer.value(value);
            }
          } else {
            found = false;
          }
          if (!found) break;
        }
      }
      if (found) {
        print(solutionToString());
        count++;
      }
    }
    return count;
  }

  String toString() {
    var text = super.toString();
    text += this.variableList.toString();
    return text;
  }

  String toSummary() {
    var text = super.toSummary();
    text += this.variableList.toSummary();
    return text;
  }
}

class Answer {
  List<int> possible;
  int? value;
  Answer(this.possible) {
    if (this.possible.length == 1) {
      this.value = this.possible[0];
    }
  }
  Answer.value(int this.value) : this.possible = [value];
}
