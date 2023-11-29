import 'dart:math';

// ignore: unused_import
import 'package:crossnumber/set.dart';

import 'cartesian.dart';
import 'clue.dart';
import 'crossnumber.dart';
import 'expression.dart';
import 'generators.dart';
import 'grid.dart';
import 'variable.dart';

class Puzzle<ClueKind extends Clue, EntryKind extends ClueKind> {
  final _clues = <String, ClueKind>{};
  final _entries = <String, EntryKind>{};
  Map<String, ClueKind> get clues => _clues.isNotEmpty ? _clues : _entries;
  Map<String, EntryKind> get entries => _clues.isNotEmpty ? _entries : {};

  Grid? grid;

  final String name;

  Puzzle({this.name = ''}) {}
  Puzzle.grid(List<String> gridString, {this.name = ''}) {
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
    if (entry1.clue != null && entry2.clue != null) {
      // Entrys are mapped to clues, so add reference betwen them
      entry2.clue!.addReferrer(entry1.clue!);
      entry1.clue!.addReferrer(entry2.clue!);
    }
  }

  List<EntrySpec> getEntriesFromGrid() {
    assert(this.grid != null);
    return this.grid!.entries;
  }

  void validateEntriesFromGrid() {
    var errors = '';
    for (var entrySpec in getEntriesFromGrid()) {
      var entry = _entries[entrySpec.name];
      if (entry == null) {
        errors += 'Entry ${entrySpec.name} not defined!\n';
      } else if (entry.length != entrySpec.length) {
        errors +=
            'Entry ${entrySpec.name} length is ${entry.length} but should be ${entrySpec.length}!\n';
      } else {
        (entry as EntryMixin).row = entrySpec.row;
        (entry as EntryMixin).col = entrySpec.col;
      }
    }
    if (errors != '') throw PuzzleException(errors);
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
    var text = '$name${name == '' ? '' : ' '}Puzzle\n';
    for (var clue in clues.values) {
      text += clue.toString() + '\n';
    }
    for (var entry in entries.values) {
      text += entry.toString() + '\n';
    }
    return text;
  }

  String toSummary() {
    var text = '$name${name == '' ? '' : ' '}Puzzle Summary\n';
    for (var clue in clues.values) {
      text += clue.toSummary() + '\n';
    }
    for (var entry in entries.values) {
      text += entry.toSummary() + '\n';
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
    for (var clue in entries.isNotEmpty ? entries.values : clues.values) {
      var values = clue.values ?? clue.entry?.values;
      if (values == null || values.length > 1) unique = false;
      if (clue.entry != null) {
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

  List<int> knownClueValues = [];
  List<int> knownEntryValues = [];

  bool updateValues(Clue clue, Set<int> possibleValue) {
    if (clue.isSet) {
      // Nothing to do
      assert(possibleValue.contains(clue.values!.first));
      return false;
    }
    // Values are restricted in set of clues/entries
    List<int> knownValues;
    if (clue is EntryMixin)
      knownValues = knownClueValues;
    else
      knownValues = knownEntryValues;
    possibleValue.removeAll(knownValues);
    var updated = clue.updateValues(possibleValue);
    if (updated) {
      clue.min = clue.values!.reduce(min);
      clue.max = clue.values!.reduce(max);
      if (possibleValue.length == 1) {
        knownValues.addAll(possibleValue);
      }
    }
    return updated;
  }

  Iterable<Variable> clueOrVariableValueReferences(
      Variable clueOrVariable) sync* {
    if (!clueOrVariable.isSet) return;
    var value = clueOrVariable.values!.first;
    if (clueOrVariable is Clue) {
      for (var clue in clues.values.where((clue) =>
          clue != clueOrVariable &&
          clue.values != null &&
          clue.values!.contains(value))) {
        clue.values!.remove(value);
        yield clue;
      }
    } else {
      var puzzle = this as VariablePuzzle;
      for (var variable in puzzle.variables.values.where((variable) =>
          variable != clueOrVariable &&
          variable.values != null &&
          variable.values!.contains(value))) {
        variable.values!.remove(value);
        yield variable;
      }
    }
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
    knownClueValues = [];
    knownEntryValues = [];
    for (var clue in this.clues.values) {
      clue.reset();
    }
  }

  bool uniqueSolution() {
    if (this
        .clues
        .values
        .any((clue) => clue.values == null || clue.values!.length != 1))
      return false;
    if (this
        .entries
        .values
        .any((entry) => entry.values == null || entry.values!.length != 1))
      return false;
    return true;
  }

  /*-------------------- Post-processing --------------------*/

  postProcessing([bool iteration = true]) {
    if (iteration) {
      print("ITERATE SOLUTIONS-----------------------------");
      var count = iterate();
      print('Solution count=$count');
    }
  }

  Map<Variable, Answer> solution = {};
  List<Variable> order = [];

  int iterate([Function? callback]) {
    if (this is VariablePuzzle && (this as VariablePuzzle).hasVariables) {
      var puzzle = this as VariablePuzzle;
      try {
        var count = puzzle.iterateVariables();
        if (count > 0) return count;
      } on SolveException {
        // No variables to iterate, so try values
      }
    }
    return iterateValues(callback);
  }

  int iterateValues([Function? callback]) {
    var unknownClues = <Variable>[];
    // ignore: unnecessary_cast
    List<Variable> clues = this.clues.values.map((c) => c as Variable).toList();
    if (this is VariablePuzzle) {
      var variablePuzzle = this as VariablePuzzle;
      var variables = variablePuzzle.variables.values
          // .where((v) => v is ExpressionVariable)
          .toList();
      clues.addAll(variables);
    }
    List<Variable> entries = this.entries.values.map((e) => e).toList();
    clues.addAll(entries);

    // Sort clues with least values first
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
          order.add(clue);
        }
      }
    }
    order.addAll(unknownClues);
    // Find solutions in clue order
    var count = 0;
    count = findSolutions(order, 0, count, callback);
    return count;
  }

  int findSolutions(List<Variable> order, int next, int count,
      [Function? callback]) {
    // Skip variables/clues with value
    while (next < order.length &&
        solution[order[next]] != null &&
        solution[order[next]]!.value != null) {
      // print(
      //     'findSolutions: next=$next, skip ${order[next].name}=${solution[order[next]]!.value} next=${next + 1}');
      next++;
    }

    // End of search?
    if (next == order.length) {
      if (checkSolution()) {
        if (callback != null)
          count += callback(this) as int;
        else {
          print(solutionToString());
          count++;
        }

        // print('findSolutions: end of clues, solution $count!');
      } else {
        // print('findSolutions: end of clues, no solution');
      }
      return count;
    }

    // Get clue values
    var clue = order[next];
    var values = clue.values;
    var undoVariables = <Variable, Answer?>{};
    if (clue.solve != null) {
      // Unknown clue - solve to get values
      // if (clue.values == null) {

      // Re-evaluate clue to see if have fewer values given context
      var possibleValue = <int>{};
      var possibleVariables = <String, Set<int>>{};
      try {
        if (clue is ExpressionVariable) {
          for (var variable in clue.variableReferences) {
            possibleVariables[variable] = <int>{};
          }
          clue.solve!(this, clue, possibleValue,
              possibleVariables: possibleVariables);
        } else if (clue is VariableClue) {
          for (var variable in clue.variableClueReferences) {
            possibleVariables[variable] = <int>{};
          }
          clue.solve!(this, clue, possibleValue,
              possibleVariables: possibleVariables);
        } else {
          clue.solve!(this, clue, possibleValue);
        }
        if (possibleValue.isEmpty) {
          return count;
        }
        // Save previous values for updated variables as undo
        if (clue is VariableClue) {
          for (var variableName in clue.variableClueReferences) {
            var possible = possibleVariables[variableName];
            if (possible == null || possible.isEmpty) continue;
            var variable = clues[variableName] ??
                entries[variableName] ??
                ((this is VariablePuzzle)
                    ? (this as VariablePuzzle).variables[variableName]
                    : null);
            if (variable != null) {
              if (variable is Clue && variable.updateValues(possible) ||
                  !(variable is Clue) && variable.updatePossible(possible)) {
                undoVariables[variable] = solution[variable];
                variable.values = possibleVariables[variableName]!;
                solution[variable] = Answer(List.from(variable.values!));
              }
            }
          }
        }

        // Can iterate over values
        values = possibleValue;
        // solution[clue] = Answer(List.from(possibleValue));
        // }
      } catch (e) {
        // Cannot solve clue
        return count;
      }
    }

    // Try each of the possible values for this clue
    // for (var value in solution[clue]!.possible) {
    valueLoop:
    for (var value in values ?? {}) {
      // Check that this value is consistent with other clues
      if (clue is Clue) {
        if (!clueValuesMatch(clue, value)) {
          // print(
          //     'findSolutions: next=$next, clue=${clue.name}, value $value does not match');
          continue;
        }
      } else {
        // Check does not duplicate other variables
        for (var variable in (this as VariablePuzzle).variables.values) {
          if (variable != clue &&
              variable.isSet &&
              variable.values!.first == value) {
            continue valueLoop;
          }
        }
      }
      // Consistent, try this value
      if (solution[clue] == null) {
        solution[clue] = Answer(null);
      }
      solution[clue]!.value = value;
      clue.tryValue = value;
      // print('findSolutions: next=$next, clue=${clue.name}, try value $value');
      count = findSolutions(order, next + 1, count, callback);
      solution[clue]!.value = null;
      clue.tryValue = null;
      // Undo other variables
      for (var variable in undoVariables.keys) {
        var possible = undoVariables[variable]!.possible!;
        solution[variable]!.possible = possible;
        variable.values = Set.from(possible);
      }
    }

    //return count;
    return count;
  }

  bool checkSolution() {
    var ok = true;
    var failedClues = <Variable>[];
    for (var clue in solution.keys) {
      if (solution[clue] != null) {
        if (clue.solve != null) {
          var value = solution[clue]!.value;
          var possibleValue = <int>{};
          var possibleVariables = <String, Set<int>>{};
          if (clue is ExpressionVariable) {
            for (var variable in clue.variableReferences) {
              possibleVariables[variable] = <int>{};
            }
            clue.solve!(this, clue, possibleValue,
                possibleVariables: possibleVariables);
          } else if (clue is VariableClue) {
            for (var variable in clue.variableClueReferences) {
              possibleVariables[variable] = <int>{};
            }
            clue.solve!(this, clue, possibleValue,
                possibleVariables: possibleVariables);
          } else {
            clue.solve!(this, clue, possibleValue);
          }
          if (possibleValue.isEmpty || !possibleValue.contains(value)) {
            // Failed
            failedClues.add(clue);
            ok = false;
          }
        }
      }
    }

    //print('Check $ok ${failedClues.map((e) => e.name)} ${solutionToString()}');
    return ok;
  }

  bool clueValuesMatch(Clue clue, int value) {
    var match = true;
    if (clue.entry != null) {
      var entry = clue.entry!;
      for (var d = 0; d < entry.length! && match; d++) {
        if (entry.digitIdentities[d] != null) {
          var clue2 = entry.digitIdentities[d]!.clue;
          assert(clue2.entry != null);
          var d2 = entry.digitIdentities[d]!.digit;
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
    }
    return match;
  }

  String solutionToString() {
    var text = "Solution\n";
    var keys = solution.keys.toList();
    keys.sort((c1, c2) => c1.compareTo(c2));
    var clueValues = <String, List<String>>{};
    var unique = true;
    var varText = '';
    for (var clue in keys) {
      var clueText =
          '${clue.name}=${solution[clue]!.value ?? solution[clue]!.possible}\n';
      if (clue is Clue)
        text += clueText;
      else
        varText += clueText;
      if (solution[clue]!.value == null) {
        unique = false;
      } else {
        if (clue is Clue)
          clueValues[clue.name] = solution[clue]!.value!.toString().split('');
      }
    }
    if (unique && this.grid != null) {
      text += '\n${grid!.solutionToString(clueValues)}';
      if (varText != '') {
        text += 'Variables:\n$varText';
      }
    }
    return text;
  }

  /*-------------------- Clue/Entry matching --------------------*/

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
          // cannot do this way because of side-effects
          // clue.initialise();
        }
        // Get entry digits
        var digits = entryDigits[e.name];
        if (digits == null) {
          entryDigits[e.name] =
              digits = List.generate(e.length!, (index) => {});
        }
        for (var d = 0; d < e.length!; d++) {
          digits[d].addAll(e.digits[d]);
        }
      }
    }
    // Update digit identities
    var updated = true;
    while (updated) {
      updated = false;
      for (var entry in entries.values) {
        var e = entry as EntryMixin;
        for (var d = 0; d < e.length!; d++) {
          if (e.digitIdentities[d] != null) {
            var entry2 = e.digitIdentities[d]!.entry;
            var d2 = e.digitIdentities[d]!.digit;
            var possibleDigits = entryDigits[entry2.name]![d2];
            if (updatePossible(entryDigits[e.name]![d], possibleDigits))
              updated = true;
          }
        }
      }
    }

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
        for (var d = 0; d < e.length!; d++) {
          e.digits[d] = digits[d];
          product *= digits[d].length;
        }
      }
      // If no values then compute them from digits
      if (entry.values == null) {
        if (product < 10000) {
          var values = <int>{};
          void addValues(int index, int value) {
            if (index == e.length!) {
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
        if (index == entries.length - 1) {
          yield true;
        } else {
          yield* mapNextClueToEntry(entries, index + 1);
        }
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

/*-------------------- Exceptions --------------------*/

/// PuzzleException for puzzle definition
class PuzzleException implements Exception {
  final String msg;
  PuzzleException(String this.msg);
}

/// SolveException for puzzle solution
class SolveException implements Exception {
  String? msg;
  SolveException([String? this.msg]);
}

/// SolveError for puzzle solution - impossible situation
class SolveError implements Exception {
  String? msg;
  SolveError([String? this.msg]);
}

/*-------------------- Variable Puzzle --------------------*/
class VariablePuzzle<ClueKind extends Clue, EntryKind extends ClueKind,
    VariableKind extends Variable> extends Puzzle<ClueKind, EntryKind> {
  late final VariableList variableList;
  bool get hasVariables => variableList.hasVariables;

  void initVariablePuzzle(List<int>? possibleValues) {
    final puzzleGenerators = [
      Generator('sumdigits', generateSumDigits),
      Generator('otherentry', generateOtherEntry)
    ];
    variableList = VariableList<VariableKind>(possibleValues);
    Scanner.addGenerators(puzzleGenerators);
  }

  VariablePuzzle(List<int>? possibleValues, {String name = ''})
      : super(name: name) {
    initVariablePuzzle(possibleValues);
  }

  VariablePuzzle.grid(List<int>? possibleValues, List<String> gridString,
      {String name = ''})
      : super.grid(gridString, name: name) {
    initVariablePuzzle(possibleValues);
  }

  Map<String, Variable> get variables => variableList.variables;
  List<int>? get remainingValues => variableList.remainingValues;
  Set<String> updateVariables(String variable, Set<int> possibleValues) =>
      variableList.updateVariables(variable, possibleValues);

  void addVariable(VariableKind variable) {
    variableList.variables[variable.name] = variable;
  }

  Iterable<int> generateSumDigits(num min, num max) sync* {
    // Generate sums of all combinations of entry digits
    var allDigits = <List<int>>[];
    for (var entry in _entries.values) {
      for (var d = 0; d < entry.length!; d++) {
        // Avoid double-counting overlapping digits
        if (entry.isAcross ||
            entry.isDown && entry.digitIdentities[d] == null) {
          allDigits.add(entry.digits[d].toList());
        }
      }
    }
    var count = cartesianCount(allDigits);
    if (count > 1000000) {
      // if (Crossnumber.traceSolve) {
      //   print('SumDigits cartesianCount=$count Exception');
      // }
      throw new ExpressionInvalid('SumDigits cartesianCount=$count Exception');
    }
    var allSums = <int>{};
    for (var product in cartesian(allDigits, true)) {
      var sum = product.reduce((value, element) => value + element);
      allSums.add(sum);
    }
    var list = allSums.toList()..sort();
    for (var sum in list) {
      if (sum < min) continue;
      if (sum > max) break;
      yield sum;
    }
  }

  Iterable<int> generateOtherEntry(num min, num max) sync* {
    // Generate other entries
    var allEntryValues = <int>{};
    for (var entry in _entries.values) {
      if (entry.values != null) {
        allEntryValues.addAll(entry.values!);
      } else {
        // generate values from digits
        var values = getValuesFromClueDigits(entry);
        if (values != null) {
          allEntryValues.addAll(values);
        } else {
          // cannot get entry values so give up
          throw new ExpressionInvalid('OtherEntry unknown ${entry.name}');
        }
      }
    }
    var list = allEntryValues.toList()..sort();
    for (var sum in list) {
      if (sum < min) continue;
      if (sum > max) break;
      yield sum;
    }
  }

  String checkClueReferences(Map<String, ClueKind>? clues,
      [Map<String, EntryKind>? entries, bool checkEntry = false]) {
    var clueError = '';
    var checkEntries =
        checkEntry && clues == null || !checkEntry && entries != null;
    for (var clue1 in checkEntry ? entries!.values : clues!.values) {
      // Make copy of references because can be updated
      var references = List.from(
          checkEntries ? clue1.entryReferences : clue1.clueReferences);
      for (var clueName in references) {
        var clue2 = checkEntries ? entries![clueName] : clues![clueName];
        if (clue2 == null) {
          // Fix clue reference Roman Numeral to be variable
          if (clueName == "I" || clueName == "V" || clueName == "X") {
            if (clue1 is ExpressionVariable) {
              var clue1ExpVar = (clue1 as ExpressionVariable);
              if (clue1ExpVar.fixReference(clueName)) {
                clue1ExpVar.sortVariables();
                continue;
              }
            }
            if (clue1 is ExpressionClue) {
              if (clue1.fixReference(clueName)) {
                // Maintain sorted variable order
                clue1.sortVariables();
                continue;
              }
            }
          }
          clueError +=
              "${checkEntry ? 'Entry' : 'Clue'} ${clue1.name} expression '${clue1.valueDesc}' refers to ${checkEntries ? 'entry' : 'clue'} '$clueName' which does not exist\n";
        } else {
          addClueReference(clue1, clue2);
          // Simple circular reference check for clue/clue
          if (entries == null && clue2.clueReferences.contains(clue1.name)) {
            clue1.circularClueReference = true;
            clue2.circularClueReference = true;
          }
        }
      }
    }
    return clueError;
  }

  String checkClueClueReferences() {
    return checkClueReferences(clues);
  }

  String checkClueEntryReferences() {
    return checkClueReferences(clues, entries);
  }

  String checkEntryClueReferences() {
    return checkClueReferences(clues, entries, true);
  }

  String checkEntryEntryReferences() {
    return checkClueReferences(null, entries, true);
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

  String checkVariableVariableReferences() {
    var variableError = '';
    for (var variable in variables.values) {
      if (variable is ExpressionVariable) {
        for (var variableName in variable.variableReferences) {
          var otherVariable = variables[variableName];
          if (otherVariable == null) {
            variableError +=
                "${variable.runtimeType} ${variable.name} expression '${variable.valueDesc}' refers to variable '$variableName' which does not exist\n";
          } else {
            (otherVariable as ExpressionVariable).addReferrer(variable);
          }
        }
      }
    }
    return variableError;
  }

  int getPriority(
      List<String> variableReferences, List<List<int>> variableValues) {
    for (var variableName in variableReferences) {
      var variable = this.variables[variableName]!;
      if (variable.values == null) return 0;
      variableValues.add(variable.values!.toList());
    }
    return cartesianCount(variableValues);
  }

  void updateCluePriority(VariableClue clue) {
    var variableValues = <List<int>>[];
    clue.priority = getPriority(clue.variableReferences, variableValues);
  }

  void updateVariablePriority(ExpressionVariable variable) {
    var variableValues = <List<int>>[];
    variable.priority =
        getPriority(variable.variableReferences, variableValues);
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
        ? getPriority(clue.variableReferences, variableValues)
        : clue is VariableEntry
            ? getPriority(clue.variableReferences, variableValues)
            : null;
    if (count! > 1000000) {
      if (Crossnumber.traceSolve) {
        print('Func ${clue.name} cartesianCount=$count Exception');
      }
      throw new SolveException();
    }
    for (var product in cartesian(variableValues)) {
      var value = expression(product);
      if (clue.length == null || value >= clue.min! && value < clue.max! + 1) {
        if (clue.digitsMatch(value)) {
          possibleValue.add(value);
          var index = 0;
          for (var variable in clue.variableClueReferences) {
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
  bool solveVariableExpressionEvaluator(
    ExpressionClue clue,
    ExpressionEvaluator exp,
    Set<int> possibleValue,
    Map<String, Set<int>> possibleVariables, [
    bool Function(ExpressionClue, int, List<String>, List<int>)? validValue,
    int maxCount = 1000000,
  ]) {
    final stopwatch = Stopwatch()..start();
    var variableValues = <List<int>>[];
    for (var variable in clue.variableReferences) {
      variableValues.add(this.variables[variable]!.values!.toList());
    }
    var count = cartesianCount(variableValues);
    if (count > maxCount) {
      if (Crossnumber.traceSolve) {
        print(
            'Eval ${clue.runtimeType} ${clue.name} cartesianCount=$count Exception');
      }
      throw new SolveException();
    }
    for (var product in cartesian(variableValues)) {
      try {
        var value = exp.evaluate(clue.variableReferences, product);
        if (clue.length == null ||
            value >= clue.min! && value < clue.max! + 1) {
          var valid = validValue == null
              ? clue.digitsMatch(value)
              : validValue(clue, value, clue.variableReferences, product);
          if (valid) {
            possibleValue.add(value);
            var index = 0;
            for (var variable in clue.variableClueReferences) {
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
      if (count != 1) {
        print(
            'Eval ${clue.runtimeType} ${clue.name} cartesianCount=$count, elapsed ${stopwatch.elapsed}');
      }
    }
    return false;
  }

  // Generic expression evaluator, supports variables, clues, generators and functions
  bool solveExpressionEvaluator(
    ExpressionClue clue,
    ExpressionEvaluator exp,
    Set<int> possibleValue,
    Map<String, Set<int>> possibleVariables, [
    bool Function(ExpressionClue, int, List<String>, List<int>)? validValue,
    int maxCount = 1000000,
  ]) {
    final stopwatch = Stopwatch()..start();
    var variableNames = <String>[];
    var variableValues = <List<int>>[];
    var unknownVariable = <String>[];
    var impossibleVariable = <String>[];
    getVariableValues(clue, exp, unknownVariable, impossibleVariable,
        variableValues, variableNames);

    // Unknown variable
    if (unknownVariable.isNotEmpty) {
      // Try guessing clue values
      var clueValues = clue.getValuesFromDigits();
      if (clueValues != null) {
        possibleValue.addAll(clueValues);
        // Cannot update variables
        possibleVariables.clear();
        return false;
      }
      throw new SolveException(
          "Solve ${clue.runtimeType} ${clue.name} no values for variable(s) ${unknownVariable}");
    }
    // Impossible variable
    if (impossibleVariable.isNotEmpty) {
      throw new SolveException(
          "Solve ${clue.runtimeType} ${clue.name} no values for variable(s) ${impossibleVariable}");
    }
    var count = cartesianCount(variableValues);
    // if (count > 500000000) {
    if (count > maxCount) {
      if (Crossnumber.traceSolve) {
        print(
            'Eval ${clue.runtimeType} ${clue.name} cartesianCount=$count Exception');
      }
      throw new SolveException();
    }
    for (var product
        in variableValues.isEmpty ? [<int>[]] : cartesian(variableValues)) {
      try {
        for (var value in exp.generate(
            clue.min, clue.max, variableNames, product, clue.values)) {
          if (clue.length == null ||
              value >= clue.min! && value < clue.max! + 1) {
            var valid = validValue == null
                ? clue.digitsMatch(value)
                : validValue(clue, value, clue.variableClueReferences, product);
            if (valid) {
              possibleValue.add(value);
              var index = 0;
              for (var variable in variableNames) {
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
      if (count != 1) {
        print(
            'Eval ${clue.runtimeType} ${clue.name} cartesianCount=$count, elapsed ${stopwatch.elapsed}');
        // print('${clue.exp.toString()}');
        // for (var v in clue.variableReferences) {
        //   print('$v=${this.variables[v]!.values!.toList()}');
        // }
      }
    }
    return false;
  }

  void getVariableValues(
    ExpressionClue clue,
    ExpressionEvaluator exp,
    List<String> unknownVariable,
    List<String> impossibleVariable,
    List<List<int>> variableValues,
    List<String> variableNames,
  ) {
    var variableReferences = exp.variableRefs
        .where((name) => clue.variableReferences.contains(name));
    for (var variableName in variableReferences) {
      var variable = this.variables[variableName]!;
      var values = variable.values;
      if (values == null && variable is ExpressionVariable)
        values = variable.getValuesFromMinMax();
      if (values == null) {
        unknownVariable.add(variableName);
      } else if (values.isEmpty) {
        impossibleVariable.add(variableName);
      } else {
        variableValues.add(values.toList()..sort());
        variableNames.add(variableName);
      }
    }
    var clueReferences =
        exp.clueRefs.where((name) => clue.clueReferences.contains(name));
    getClueValues(clues, clueReferences.toList(), unknownVariable,
        impossibleVariable, variableValues, variableNames);
    var entryReferences =
        exp.clueRefs.where((name) => clue.entryReferences.contains(name));
    getClueValues(entries, entryReferences.toList(), unknownVariable,
        impossibleVariable, variableValues, variableNames);
  }

  void getClueValues(
    Map<String, ClueKind> clues,
    List<String> clueReferences,
    List<String> unknownVariable,
    List<String> impossibleVariable,
    List<List<int>> variableValues,
    List<String> variableNames,
  ) {
    for (var otherClueName in clueReferences) {
      var name = otherClueName;
      // Entry names are single alpha or prefixed with E
      if (name.length > 1 && name[0] == 'E') name = name.substring(1);
      var otherClue = clues[name]!;
      // Clue values may not yet be available
      var otherClueValues = otherClue.values;
      //if (otherClueValues == null && clue.circularClueReference) {
      if (otherClueValues == null) {
        // Try guessing other clue values for circular reference
        otherClueValues = getValuesFromClueDigits(otherClue);
      }
      if (otherClueValues == null)
        unknownVariable.add(otherClueName);
      else if (otherClueValues.isEmpty)
        impossibleVariable.add(otherClueName);
      else {
        variableValues.add(otherClueValues.toList()..sort());
        variableNames.add(otherClueName);
      }
    }
  }

  // Generic expression evaluator, supports variables
  bool solveExpressionVariable(
    ExpressionVariable variable,
    ExpressionEvaluator exp,
    Set<int> possibleValue,
    Map<String, Set<int>> possibleVariables, [
    bool Function(ExpressionVariable, int, List<String>, List<int>)? validValue,
  ]) {
    final stopwatch = Stopwatch()..start();
    var updated = false;
    var variableValues = <List<int>>[];
    for (var variableName in variable.variableReferences) {
      var variable = this.variables[variableName]!;
      if (variable.values == null)
        throw new SolveException("Unknown values for variable $variableName");
      if (variable.values!.isEmpty)
        throw new SolveException("No values for variable $variableName!");
      variableValues.add(variable.values!.toList());
      possibleVariables[variableName] = <int>{};
    }
    var count = cartesianCount(variableValues);
    if (count > 1000000) {
      //if (count > 1000000) {
      if (Crossnumber.traceSolve) {
        print(
            'Eval ${variable.runtimeType} ${variable.name} cartesianCount=$count Exception');
      }
      throw new SolveException();
    }
    for (var product
        in variableValues.isEmpty ? [<int>[]] : cartesian(variableValues)) {
      try {
        for (var value in exp.generate(
            variable.min, variable.max, variable.variableReferences, product)) {
          // Variable values are distinct
          if (product.contains(value)) continue;
          if ((variable.min == null || value >= variable.min!) &&
              (variable.max == null || value < variable.max! + 1)) {
            var valid = validValue == null
                ? true
                : validValue(
                    variable, value, variable.variableReferences, product);
            if (valid) {
              possibleValue.add(value);
              var index = 0;
              for (var variableName in variable.variableReferences) {
                possibleVariables[variableName]!.add(product[index++]);
              }
              // if (Crossnumber.traceSolve) {
              //   print('${variable.name}=$value, ${variable.variableReferences}=$product');
              // }
            }
          }
        }
      } on ExpressionInvalid {
        // Illegal values
      }
    }
    if (Crossnumber.traceSolve) {
      if (count != 1) {
        print(
            'Eval ${variable.runtimeType} ${variable.name} cartesianCount=$count, elapsed ${stopwatch.elapsed}');
        // print('${clue.exp.toString()}');
        // for (var v in clue.variableReferences) {
        //   print('$v=${this.variables[v]!.values!.toList()}');
        // }
      }
    }
    return updated;
  }

  /*-------------------- Variable Puzzle Post-processing --------------------*/

  int iterateVariables() {
    // Iterate over possible variable values
    var variableValues = <List<int>>[];
    var variableNames = <String>[];
    for (var variableName in this.variables.keys) {
      var variable = this.variables[variableName]!;
      if (variable.values != null) {
        variableNames.add(variableName);
        variableValues.add(variable.values!.toList());
      }
    }
    if (variableNames.isEmpty)
      throw SolveException('No variable values to iterate over!');

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
          Map<String, Set<int>> possibleVariables = {};
          for (var variable in clue.variableClueReferences) {
            possibleVariables[variable] = <int>{};
          }
          try {
            clue.solve!(this, clue, possibleValue,
                possibleVariables: possibleVariables);
          } catch (e) {
            possibleValue.clear();
          }
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
    // Clean up
    for (var i = 0; i < variableNames.length; i++) {
      this.variables[variableNames[i]]!.tryValue = null;
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
  List<int>? possible;
  int? value;
  Answer(List<int>? this.possible) {
    if (this.possible?.length == 1) {
      this.value = this.possible![0];
    }
  }
  Answer.value(int this.value) : this.possible = [value];
}
