import 'dart:math';

import 'package:basics/basics.dart';
import 'package:collection/collection.dart';
import 'package:crossnumber/monadic.dart';

import 'cartesian.dart';
import 'clue.dart';
import 'crossnumber.dart';
import 'expression.dart';
import 'generators.dart';
import 'grid.dart';
import 'gridspec.dart';
import 'variable.dart';

class Puzzle<ClueKind extends Clue, EntryKind extends ClueKind> {
  late final Map<VariableType, VariableList> _variableLists;
  late final VariableList<ClueKind> _clues;
  late final VariableList<EntryKind> _entries;
  // ignore: unused_field
  late final VariableList<Cell> _cells;
  final _allVariables = <(VariableType, String), Variable>{};
  Map<String, ClueKind> get clues =>
      _clues.variables.isNotEmpty ? _clues.variables : _entries.variables;
  Map<String, EntryKind> get entries =>
      _clues.variables.isNotEmpty ? _entries.variables : {};
  bool get cluesAreEntries => _clues.variables.isEmpty;
  Map<String, EntryKind> get allEntries => _entries.variables;
  Map<String, Cell> get cells => _cells.variables;
  Map<(VariableType, String), Variable> get allVariables => _allVariables;

  final otherPuzzleClues = <String, Puzzle>{};
  Puzzle cluePuzzle(String clueName) => otherPuzzleClues[clueName] ?? this;

  GridSpec? gridSpec;
  Grid? grid;

  bool finalized = false;

  final String name;
  bool _distinctClues = true;
  set distinctClues(bool distinctClues) {
    _distinctClues = distinctClues;
    _clues.distinct = _distinctClues;
  }

  void _initPuzzle() {
    _variableLists = <VariableType, VariableList>{};
    _variableLists[VariableType.C] =
        (_clues = VariableList<ClueKind>(VariableType.C, []));
    _variableLists[VariableType.E] =
        (_entries = VariableList<EntryKind>(VariableType.E, []));
    // Cell values not distinct
    _variableLists[VariableType.G] =
        (_cells = VariableList<Cell>(VariableType.G, null));
  }

  Puzzle({this.name = ''}) {
    _initPuzzle();
  }
  Puzzle.fromGridString(List<String> gridString, {this.name = ''}) {
    _initPuzzle();
    this.gridSpec = GridSpec(gridString);
  }

  void addAnyVariable(Variable variable) {
    var variableList = _variableLists[variable.variableType]!;
    variableList[variable.name] = variable;
    _allVariables[(variable.variableType, variable.name)] = variable;
  }

  void addClue(ClueKind clue) {
    assert(clue.variableType == VariableType.C);
    addAnyVariable(clue);
  }

  void addEntry(EntryKind entry) {
    assert(entry.variableType == VariableType.E);
    addAnyVariable(entry);
  }

  void addCell(Cell cell) {
    assert(cell.variableType == VariableType.G);
    addAnyVariable(cell);
  }

  void addCellVariables() {
    assert(grid != null);
    for (var row in grid!.rows) {
      for (var cell in row) {
        addCell(cell);
      }
    }
  }

  // clue1[digit1-1] = clue2[digit2-1]
  void addDigitIdentity(
      EntryMixin entry1, int digit1, EntryMixin entry2, int digit2) {
    entry1.addDigitIdentity(digit1, entry2, digit2);
  }

  List<EntrySpec> getEntriesFromGrid() {
    assert(this.gridSpec != null);
    return this.gridSpec!.entries;
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

  void linkEntriesToGrid([CellConstructor? constructor]) {
    assert(this.gridSpec != null);
    for (var identity in this.gridSpec!.getIdentities()) {
      var entry1 = this._entries[identity['entry1']]!;
      var entry2 = this._entries[identity['entry2']]!;
      addDigitIdentity(entry1 as EntryMixin, identity['digit1'],
          entry2 as EntryMixin, identity['digit2']);
    }
    // Link entries to grid cells
    grid = Grid.fromGridSpec(this, '', constructor);
  }

  /// clue1 refers to clue2
  void addReference(Variable variable1, Variable variable2,
      [bool symmetric = false]) {
    variable2.addReferrer(variable1);
    if (symmetric) {
      variable1.addReferrer(variable2);
    }
  }

  /// clue1 refers to clue2
  void addClueReference(Clue clue1, Clue clue2, [bool symmetric = false]) =>
      addReference(clue1, clue2, symmetric);

  /// entry1 refers to entry2
  void addEntryReference(Clue entry1, Clue entry2, [bool symmetric = false]) =>
      addReference(entry1, entry2, symmetric);

  void finalize() {
    finalized = true;
  }

  @override
  String toString() {
    var addLabel = clues.isNotEmpty && entries.isNotEmpty;
    var text = '$name${name == '' ? '' : ' '}Puzzle\n';
    for (var clue in clues.values) {
      if (addLabel) text += 'Clue ';
      text += '$clue\n';
    }
    for (var entry in entries.values) {
      if (addLabel) text += 'Entry ';
      text += '$entry\n';
    }
    return text;
  }

  String toSummary() {
    var addLabel = clues.isNotEmpty && entries.isNotEmpty;
    var text = '$name${name == '' ? '' : ' '}Puzzle Summary\n';
    for (var clue in clues.values) {
      if (addLabel) text += 'Clue ';
      text += '${clue.toSummary()}\n';
    }
    for (var entry in entries.values) {
      if (addLabel) text += 'Entry ';
      text += '${entry.toSummary()}\n';
    }
    if (gridSpec != null) text += toSolution();
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
                : dl.isEmpty
                    ? ''
                    : '?')
            .toList();
        anyClue = true;
      }
    }
    if (anyClue) text += gridSpec!.solutionToString(entryValues);
    return text;
  }

  List<int> knownClueValues = [];
  List<int> knownEntryValues = [];

  Set<Variable> updateVariableValues(
      Variable variable, Set<int> possibleValue) {
    var variableList = _variableLists[variable.variableType]!;
    var updatedVariables =
        variableList.updateVariables(variable.name, possibleValue);
    return updatedVariables;
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
        if (clue is EntryMixin || _distinctClues) {
          clue.removeValue(value);
          yield clue;
        }
      }
    } else if (clueOrVariable.variableType == VariableType.V) {
      var puzzle = this as VariablePuzzle;
      for (var variable in puzzle.variables.values.where((variable) =>
          variable != clueOrVariable &&
          variable.values != null &&
          variable.values!.contains(value))) {
        variable.removeValue(value);
        yield variable;
      }
    }
  }

  void updateClueReference(
      String clueName, String otherClueName, Puzzle otherPuzzle) {
    // All clue references for this clue are to other puzzle (not just the specified clue)
    otherPuzzleClues[clueName] = otherPuzzle;
    print(
        'updateClueReference($clueName, $otherClueName, ${otherPuzzle.name})');
  }

  void fixClue(String clueName, int value) {
    var clue = this.clues[clueName];
    if (clue != null) {
      updateVariableValues(clue, {value});
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
    if (clues.values
        .any((clue) => clue.values == null || clue.values!.length != 1)) {
      return false;
    }
    if (clues != entries &&
        entries.values.any(
            (entry) => entry.values == null || entry.values!.length != 1)) {
      return false;
    }
    return true;
  }

  /*-------------------- Post-processing --------------------*/

  postProcessing(
      {bool iteration = true,
      int Function(Puzzle)? callback,
      Function? partialCallback}) {
    if (iteration) {
      print("ITERATE SOLUTIONS-----------------------------");
      var count = iterate(callback: callback, partialCallback: partialCallback);
      print('Solution count=$count');
    }
  }

  Map<Variable, Answer> solution = {};
  List<Variable> order = [];

  int iterate({int Function(Puzzle)? callback, Function? partialCallback}) {
    if (this is VariablePuzzle && (this as VariablePuzzle).hasVariables) {
      var puzzle = this as VariablePuzzle;
      try {
        var count = puzzle.iterateVariables();
        if (count > 0) return count;
      } on SolveException {
        // No variables to iterate, so try values
      }
    }
    return iterateValues(callback: callback, partialCallback: partialCallback);
  }

  int iterateValues(
      {int Function(Puzzle)? callback, Function? partialCallback}) {
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
    count = findSolutions(order, 0, count,
        callback: callback, partialCallback: partialCallback);
    return count;
  }

  var traceFindSolutions = true;
  var traceFindAnswer = true;

  int findSolutions(List<Variable> order, int next, int count,
      {Function? callback, bool isAnswer = true, Function? partialCallback}) {
    // Skip variables/clues with value
    while (next < order.length &&
        solution[order[next]] != null &&
        solution[order[next]]!.value != null) {
      var clue = order[next];
      var value = solution[order[next]]!.value;
      if (traceFindSolutions) {
        print(
            'findSolutions: next=$next, skip ${clue.name}=$value next=${next + 1}');
      }
      if (traceFindAnswer) {
        if (isAnswer && clue.answer != null && value == clue.answer) {
          print(
              'findSolutions: next=$next, clue=${clue.name}, answer value $value');
        } else {
          isAnswer = false;
        }
      }
      next++;
    }

    // End of search?
    if (next == order.length) {
      if (checkSolution()) {
        if (callback != null) {
          count += callback(this) as int;
        } else {
          print(solutionToString());
          count++;
        }

        if (traceFindSolutions) {
          print('findSolutions: end of clues, solution $count!');
        }
      } else {
        if (traceFindSolutions) {
          print('findSolutions: end of clues, no solution');
        }
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
      var possibleVariables = <Variable, Set<int>>{};
      try {
        if (clue is ExpressionVariable) {
          for (var variableRef in clue.variableReferences) {
            possibleVariables[variableRef] = <int>{};
          }
          clue.solve!(this, clue, possibleValue,
              possibleVariables: possibleVariables);
        } else if (clue is VariableClue) {
          for (var variableRef in clue.variableClueReferences) {
            possibleVariables[variableRef] = <int>{};
          }
          clue.solve!(this, clue, possibleValue,
              possibleVariables: possibleVariables);
        } else {
          clue.solve!(this, clue, possibleValue);
        }
        if (possibleValue.isEmpty) {
          if (traceFindSolutions) {
            print('findSolutions: next=$next, clue=${clue.name}, no values');
          }
          return count;
        }
        // Save previous values for updated variables as undo
        if (clue is VariableClue) {
          for (var variable in clue.variableClueReferences) {
            var possible = possibleVariables[variable];
            if (possible == null || possible.isEmpty) continue;
            if (variable is Clue && variable.updateValues(possible) ||
                variable is! Clue && variable.updatePossible(possible)) {
              undoVariables[variable] = solution[variable];
              variable.values = possibleVariables[variable]!;
              solution[variable] = Answer(List.from(variable.values!));
            }
          }
        }

        // Can iterate over values
        values = possibleValue;
        // solution[clue] = Answer(List.from(possibleValue));
        // }
      } catch (e) {
        // Cannot solve clue
        if (traceFindSolutions) {
          print('findSolutions: next=$next, clue=${clue.name}, exception');
        }
        if (partialCallback != null) {
          count += partialCallback(this) as int;
        }
        return count;
      }
    }

    // Try each of the possible values for this clue
    // for (var value in solution[clue]!.possible) {
    valueLoop:
    for (var value in values ?? {}) {
      var stillAnswer = isAnswer;
      // Check that this value is consistent with other clues
      if (clue is Clue) {
        if (!clueValuesMatch(clue, value)) {
          if (traceFindSolutions) {
            print(
                'findSolutions: next=$next, clue=${clue.name}, value $value does not match');
          }
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
      if (traceFindSolutions) {
        print('findSolutions: next=$next, clue=${clue.name}, try value $value');
      }
      if (traceFindAnswer) {
        if (stillAnswer && clue.answer != null && value == clue.answer) {
          print(
              'findSolutions: next=$next, clue=${clue.name}, answer value $value');
        } else {
          stillAnswer = false;
        }
      }
      count = findSolutions(order, next + 1, count,
          callback: callback,
          isAnswer: stillAnswer,
          partialCallback: partialCallback);
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
          var possibleVariables = <Variable, Set<int>>{};
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
          } on SolveException {
            // Do Nothing
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

  List<int>? getAllDigits() {
    var digits = <int>[];
    // Do not double count digits that appear in Across and Down clues
    for (var clue in this.clues.values) {
      if (clue.values == null || clue.values!.length != 1) return null;
      var value = clue.values!.first.toString();
      // Get all digits of Across clues
      for (var d = 0; d < clue.length!; d++) {
        var digit = int.parse(value[d]);
        // Exclude digits of Down clues that intersect with Across clues
        if (clue.name[0] == 'D') {
          if (clue.digitIdentities[d] != null) continue;
        }
        digits.add(digit);
      }
    }
    return digits;
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
      if (clue is Clue) {
        text += clueText;
      } else {
        varText += clueText;
      }
      if (solution[clue]!.value == null) {
        unique = false;
      } else {
        if (clue is Clue) {
          clueValues[clue.name] = solution[clue]!.value!.toString().split('');
        }
      }
    }
    if (unique && this.gridSpec != null) {
      var haveEntries = keys.all((clue) => clue is! Clue || clue.entry != null);
      if (haveEntries) {
        text += '\n${gridSpec!.solutionToString(clueValues)}';
      }
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
            if (updatePossible(entryDigits[e.name]![d], possibleDigits)) {
              updated = true;
            }
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
          e.setDigits(d, digits[d]);
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
    var noClueForEntry = true;

    while (noClueForEntry && index < entries.length) {
      var entry = entries[index];
      ClueKind? mappedClue = (entry as EntryMixin).clue as ClueKind?;

      for (var clue in mappedClue != null
          ? [mappedClue]
          : _clues.values.where((c) =>
              (c.isUnknown || c.isAcross == entry.isAcross) &&
              c.length == entry.length &&
              c.entry == null)) {
        // Set mapping
        noClueForEntry = false;
        mapClueToEntry(clue, entry);

        // Save values and entry digits
        var oldClueValues = clue.values;
        var oldEntryValues = entry.values;
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
        clue.values = oldClueValues;
        clue.restoreDigits(savedDigits);
        clue.entry = null;
        entry.values = oldEntryValues;
        (entry as EntryMixin).clue = null;
      }
      index++;
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
        clue.entry!.values = okValues;
        clue.finalise();

        // Check entry is compatible with other entries
        if (!(clue.entry as EntryMixin).okDigitsForOtherEntries()) {
          return false;
        }
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
  PuzzleException(this.msg);
}

/// SolveException for puzzle solution
class SolveException implements Exception {
  String? msg;
  SolveException([this.msg]);
}

/// SolveError for puzzle solution - impossible situation
class SolveError implements Exception {
  String? msg;
  SolveError([this.msg]);
}

/*-------------------- Variable Puzzle --------------------*/
class VariablePuzzle<ClueKind extends Clue, EntryKind extends ClueKind,
    VariableKind extends Variable> extends Puzzle<ClueKind, EntryKind> {
  late final VariableList variableList;

  bool get hasVariables => variableList.hasVariables;

  void initVariablePuzzle(List<int>? possibleValues,
      {bool variableListInitialized = false}) {
    final puzzleGenerators = [
      Generator('sumdigits', generateSumDigits),
      Generator('otherentry', generateOtherEntry),
      Generator('factorotherentry', factorOtherEntry),
      Generator('sumtwootherentry', sumTwoOtherEntry),
      Generator('difftwootherentry', diffTwoOtherEntry,
          order: NodeOrder.UNKNOWN)
    ];
    if (!variableListInitialized) {
      variableList = VariableList<VariableKind>(VariableType.V, possibleValues);
    }
    _variableLists[VariableType.V] = variableList;
    Scanner.addGenerators(puzzleGenerators);
  }

  VariablePuzzle(List<int>? possibleValues, {super.name}) {
    initVariablePuzzle(possibleValues);
  }

  VariablePuzzle.fromGridString(
      List<int>? possibleValues, List<String> gridString,
      {String name = ''})
      : super.fromGridString(gridString, name: name) {
    initVariablePuzzle(possibleValues);
  }

  Map<String, Variable> get variables => variableList.variables;
  Iterable<String> get variableNames => variableList.variableNames;
  VariableList get variablesList => variableList;
  List<int>? get remainingValues => variableList.restrictedValues;
  Set<Variable> updateVariables(String variable, Set<int> possibleValues) =>
      variableList.updateVariables(variable, possibleValues);

  void addVariable(VariableKind variable) {
    assert(variable.variableType == VariableType.V);
    addAnyVariable(variable);
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
      throw ExpressionInvalid('SumDigits cartesianCount=$count Exception');
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

  Iterable<int> generateOtherEntry(num? min, num? max) sync* {
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
          throw ExpressionInvalid('OtherEntry unknown ${entry.name}');
        }
      }
    }
    var list = allEntryValues.toList()..sort();
    for (var sum in list) {
      if (min != null && sum < min) continue;
      if (max != null && sum > max) break;
      yield sum;
    }
  }

  Iterable<int> factorOtherEntry(num min, num max) sync* {
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
          throw ExpressionInvalid('OtherEntry unknown ${entry.name}');
        }
      }
    }
    var list = allEntryValues.toList()..sort();
    var allFactors = <int>{};
    for (var value in list) {
      allFactors.addAll(divisors(value, min, max));
    }
    var factorList = allFactors.toList()..sort();
    for (var factor in factorList) {
      if (factor < min) continue;
      if (factor > max) break;
      yield factor;
    }
  }

  Iterable<int> sumTwoOtherEntry(num min, num max) sync* {
    // Generate other entries
    var otherEntries = generateOtherEntry(min, max).toList();
    for (var i = 0; i < otherEntries.length - 1; i++) {
      var anyOK = false;
      for (var j = i; j < otherEntries.length; j++) {
        var sum = otherEntries[i] + otherEntries[j];
        if (sum > max) break;
        anyOK = true;
        if (sum < min) continue;
        yield sum;
      }
      if (!anyOK) break;
    }
  }

  Iterable<int> diffTwoOtherEntry(num min, num max) sync* {
    // Generate other entries
    var otherEntries = generateOtherEntry(null, null).toList();
    for (var i = 0; i < otherEntries.length - 1; i++) {
      for (var j = i; j < otherEntries.length; j++) {
        var diff = otherEntries[i] - otherEntries[j];
        if (diff < 0) diff = -diff;
        if (diff > max) continue;
        if (diff < min) continue;
        yield diff;
      }
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
          checkEntries ? clue1.entryNameReferences : clue1.clueNameReferences);
      for (var refName in references) {
        var clueName = refName;
        // Clue references that start with E are entry references
        if (clueName.length > 1 && clueName[0] == 'E') {
          clueName = clueName.substring(1);
        }
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
          if (entries == null &&
              clue2.clueNameReferences.contains(clue1.name)) {
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

  String checkPuzzleVariableReferences() {
    var variableError = '';
    for (var variable in allVariables.values) {
      if (variable is Expression) {
        for (var variableName in variable.variableNameReferences) {
          var otherVariable = variables[variableName];
          if (otherVariable == null) {
            var expString = (variable as Expression).expString;
            variableError +=
                "${variable.runtimeType} ${variable.name} expression '$expString' refers to variable '$variableName' which does not exist\n";
          } else {
            if (variable is! Clue) otherVariable.addReferrer(variable);
          }
        }
      }
    }
    return variableError;
  }

  void resolveReferences(Variable variable) {
    // Check for cross-puzzle references
    var puzzle = otherPuzzleClues[variable.name] ?? this;

    // All references should already have been checked, i.e. valid
    for (var reference in variable.references) {
      // Clue references may actually be to entries
      var type = reference.type == VariableType.C && cluesAreEntries
          ? VariableType.E
          : reference.type;
      // Entry references may have prefix E
      var name = reference.name.length > 1 && reference.name[0] == 'E'
          ? reference.name.substring(1)
          : reference.name;
      var key = (type, name);
      reference.variable = puzzle.allVariables[key]!;
    }

    // Expressions
    if (variable is Expression) {
      for (var exp in (variable as Expression).expressions) {
        exp.resolveReferences(puzzle.allVariables);
      }
    }
  }

  void resolveAllReferences() {
    for (var variable in allVariables.values) {
      resolveReferences(variable);
    }
  }

  @override
  void finalize() {
    var clueError = '';
    clueError = checkClueEntryReferences();
    clueError = checkClueClueReferences();
    clueError += checkEntryClueReferences();
    clueError += checkEntryEntryReferences();
    // Check variabes last, as preceeding may update them
    clueError += checkPuzzleVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    resolveAllReferences();

    super.finalize();
  }

  int getPriority(
      Iterable<Variable> variableReferences, List<List<int>> variableValues) {
    for (var variable in variableReferences) {
      if (variable.values == null) return 0;
      variableValues.add(variable.values!.toList());
    }
    return cartesianCount(variableValues);
  }

  void updatePriority(Variable variable) {
    var variableValues = <List<int>>[];
    variable.priority =
        getPriority(variable.variableReferences, variableValues);
  }

  // Expression evaluator, supports variables with expression callback
  void solveVariableExpression(
      Clue clue,
      Set<int> possibleValue,
      Map<Variable, Set<int>>? possibleVariables,
      int Function(List<int> variables) expression) {
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
      throw SolveException();
    }
    for (var product in cartesian(variableValues)) {
      var value = expression(product);
      if (clue.length == null || value >= clue.min! && value < clue.max! + 1) {
        if (clue.digitsMatch(value)) {
          possibleValue.add(value);
          var index = 0;
          for (var variable in clue.variableClueReferences) {
            possibleVariables![variable]!.add(product[index++]);
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
    Map<Variable, Set<int>>? possibleVariables, [
    bool Function(ExpressionClue, int, List<String>, List<int>)? validValue,
    int maxCount = 1000000,
  ]) {
    final stopwatch = Stopwatch()..start();
    var variableValues = <List<int>>[];
    for (var variableRef in clue.variableReferences) {
      variableValues.add(variableRef.values!.toList());
    }
    var count = cartesianCount(variableValues);
    if (count > maxCount) {
      if (Crossnumber.traceSolve) {
        print(
            'Eval ${clue.runtimeType} ${clue.name} cartesianCount=$count Exception');
      }
      throw SolveException();
    }
    for (var product in cartesian(variableValues)) {
      try {
        var value = exp.evaluate(clue.variableReferences.toList(), product);
        if (clue.length == null ||
            value >= clue.min! && value < clue.max! + 1) {
          var valid = validValue == null
              ? clue.digitsMatch(value)
              : validValue(clue, value, clue.variableNameReferences, product);
          if (valid) {
            possibleValue.add(value);
            var index = 0;
            for (var variable in clue.variableClueReferences) {
              possibleVariables![variable]!.add(product[index++]);
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

  int checkVariablesCount(
    List<Variable> listClues,
    Set<int> possibleValue,
    Map<Variable, Set<int>>? possibleVariables,
    List<String> unknownVariable,
    List<String> impossibleVariable,
    List<List<int>> variableValues,
    int maxCount,
  ) {
    var clue = listClues.first;
    // Unknown variable
    if (unknownVariable.isNotEmpty) {
      // Try guessing clue values
      if (clue is Clue) {
        var clueValues = clue.values ?? clue.getValuesFromDigits();
        if (clueValues != null) {
          possibleValue.addAll(clueValues);
          // Cannot update variables
          possibleVariables!.clear();
          return 0;
        }
      }
      throw SolveException(
          "Solve ${clue.runtimeType} ${clue.name} no values for variable(s) $unknownVariable");
    }
    // Impossible variable
    if (impossibleVariable.isNotEmpty) {
      throw SolveException(
          "Solve ${clue.runtimeType} ${clue.name} no values for variable(s) $impossibleVariable");
    }
    var count = cartesianCount(variableValues);
    // if (count > 500000000) {
    if (count > maxCount) {
      if (Crossnumber.traceSolve) {
        print(
            'Eval ${clue.runtimeType} ${clue.name} cartesianCount=$count Exception');
      }
      throw SolveException();
    }
    return count;
  }

  int getVariables(
    List<Variable> listClues,
    List<ExpressionEvaluator> expressions,
    Set<int> possibleValue,
    Map<Variable, Set<int>>? possibleVariables,
    List<Variable> variables,
    List<List<int>> variableValues,
    int maxCount, [
    List<Variable>? excludeVariables,
    List<Variable>? solvedVariables,
    List<int>? solvedVariableValues,
  ]) {
    var unknownVariable = <String>[];
    var impossibleVariable = <String>[];
    getVariableValues(
        listClues,
        expressions,
        unknownVariable,
        impossibleVariable,
        variableValues,
        variables,
        excludeVariables,
        solvedVariables,
        solvedVariableValues);
    var count = checkVariablesCount(listClues, possibleValue, possibleVariables,
        unknownVariable, impossibleVariable, variableValues, maxCount);
    return count;
  }

  // Generic expression evaluator, supports variables, clues, generators and functions
  bool solveExpressionEvaluator(ExpressionClue clue, ExpressionEvaluator exp,
      Set<int> possibleValue, Map<Variable, Set<int>>? possibleVariables,
      [bool Function(ExpressionClue, int, List<String>, List<int>)? validValue,
      ExpressionCallback? callback,
      int maxCount = 1000000,
      Map<int, int>? duplicateLimit]) {
    final stopwatch = Stopwatch()..start();
    var variables = <Variable>[];
    var variableValues = <List<int>>[];
    var count = getVariables([clue], [exp], possibleValue, possibleVariables,
        variables, variableValues, maxCount);
    if (count == 0) return false;

    var variableNames = variables.map((e) => e.name).toList();
    for (var product in variableValues.isEmpty
        ? [<int>[]]
        : duplicateLimit == null
            ? cartesian(variableValues)
            : cartesianDuplicateLimit(variableValues, duplicateLimit)) {
      try {
        for (var value in exp.generate(
            clue.min, clue.max, variables, product, clue.values, callback)) {
          if (clue.length == null ||
              value >= clue.min! && value < clue.max! + 1) {
            var valid = validValue == null
                ? clue.digitsMatch(value)
                : validValue(clue, value, variableNames, product);
            if (valid) {
              possibleValue.add(value);
              var index = 0;
              for (var variable in variables) {
                possibleVariables![variable]!.add(product[index++]);
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

  // Clue solver invokes generic expression evaluator with validator
  bool solveRelatedClues(
    ExpressionClue clue,
    ExpressionEvaluator exp,
    Set<int> possibleValue,
    Map<Variable, Set<int>>? possibleVariables, [
    bool Function(ExpressionClue, int, List<String>, List<int>)? validValue,
    ExpressionCallback? callback,
    int maxCount = 1000000,
  ]) {
    var updated = false;

    // Get related variables
    var relatedVariables = relatedVariablesForVariable(clue);
    if (relatedVariables == null) {
      throw PuzzleException(
          'Variable ${clue.name} does not have related variables');
    }
    // print(
    //     '${clue.variableType} ${clue.name}, relatedVariables=${relatedVariables.map((e) => e.name)}');

    // solveClue does not know to initialise the relatedVariables
    for (var variableRef in relatedVariables) {
      if (variableRef is Clue && variableRef.initialise()) updated = true;
    }

    var maxCount = 10000000;
    var maxIndex = relatedVariables.length - 1;

    bool solveNextClue(
      List<Variable> relatedVariables,
      int index,
      List<Variable> variables,
      List<int> product,
      List<Variable> solvedVariables,
      List<int> solvedVariableValues,
      int maxCount,
    ) {
      // Function to solve one variable and recurse for others
      var updated = false;
      var variable = relatedVariables[index] as ExpressionClue;
      var variableIndex = variables.indexOf(variable);
      var nextVariables = variables;
      var nextProduct = product;
      var variableNames = <String>[];
      var nextVariableNames = variableNames;
      var newVariables = <Variable>[];
      var count = 1;
      var firstVariableIndex = relatedVariables.indexOf(clue);
      // if (index > 0) {
      //   print('solveAllClues: index=$index, variable=${variable.name}');
      // }

      bool solveNextClueValue(int value) {
        // Check if variable value is constrained by earlier variable evaluation
        if (variableIndex != -1 && product[variableIndex] != value) {
          return false;
        }
        // Check duplicates for variables of the same type
        var types = newVariables.map((e) => e.variableType).toSet();
        for (var type in types) {
          var values = <int>{};
          for (var i = 0; i < nextVariables.length; i++) {
            if (nextVariables[i].variableType == type) {
              var value = nextProduct[i];
              if (values.contains(value)) {
                return false;
              }
              values.add(value);
            }
          }
        }

        var valid = validValue == null
            ? variable.digitsMatch(value)
            : validValue(variable, value, nextVariableNames, nextProduct);
        if (!valid) return false;
        solvedVariableValues.add(value);

        // Recurse to next variable?
        if (index < maxIndex) {
          // Add this variable and value to product
          try {
            updated = solveNextClue(
                relatedVariables,
                index + 1,
                nextVariables,
                nextProduct,
                solvedVariables,
                solvedVariableValues,
                maxCount ~/ count);
          } on SolveException {
            // Return values so far
            var i = 0;
            for (var variable in nextVariables) {
              possibleVariables![variable]!.add(nextProduct[i++]);
            }
            possibleValue.add(solvedVariableValues[firstVariableIndex]);
            // Do not try this index again
            maxIndex = index;
          }
        } else {
          var i = 0;
          for (var variable in nextVariables) {
            possibleVariables![variable]!.add(nextProduct[i++]);
          }
          possibleValue.add(solvedVariableValues[firstVariableIndex]);
        }
        solvedVariableValues.removeLast();
        return true;
      }

      // Mo expression?
      if (variable.expressions.isEmpty) {
        // Values may have been set by other Clue
        var variableValues = variable.values ?? variable.getValuesFromDigits();
        if (variableValues != null) {
          // Recurse for each of the values
          solvedVariables.add(variable);
          // With different types of variables, we have to allow duplicates in the product
          try {
            // nextProduct = product + newProduct;
            for (var value in variableValues) {
              solveNextClueValue(value);
            }
          } on ExpressionInvalid {
            // Illegal values
          }
          solvedVariables.removeLast();
          return updated;
        } else {
          // No further action
          // Should return progress so far?
          throw SolveException();
        }
      } else {
        // Just support one expression per clue for now
        var exp = variable.exp;

        var count = 0;

        var newVariableValues = <List<int>>[];

        try {
          count = getVariables(
            [variable],
            [exp],
            possibleValue,
            possibleVariables!,
            newVariables,
            newVariableValues,
            maxCount,
            variables,
            solvedVariables,
            solvedVariableValues,
          );
        } on SolveException {
          // Exceeded maxCount
          count = 0;
          if (index > 0) rethrow;
        }
        // print(
        //     '${clue.variableType} ${clue.name}, index=$index, variable=${variable.name}, count=$count');

        // No variables, or have variable product count
        if (newVariableValues.isEmpty || count > 0) {
          nextVariableNames =
              variableNames + newVariables.map((e) => e.name).toList();
          for (var variable in newVariables) {
            if (!possibleVariables!.containsKey(variable)) {
              possibleVariables[variable] = <int>{};
            }
          }
          nextVariables = variables + newVariables;

          solvedVariables.add(variable);
          // With different types of variables, we have to allow duplicates in the product
          for (var newProduct in newVariableValues.isEmpty
              ? [<int>[]]
              : cartesian(newVariableValues, true)) {
            try {
              var knownValue =
                  variableIndex != -1 ? product[variableIndex] : null;
              nextProduct = product + newProduct;
              for (var value in exp.generate(
                  knownValue ?? 1,
                  knownValue ?? variable.max,
                  nextVariables,
                  nextProduct,
                  variable.values)) {
                solveNextClueValue(value);
              }
            } on ExpressionInvalid {
              // Illegal values
            }
          }
          solvedVariables.removeLast();
          return updated;
        } else {
          if (index == 0 && clue == variable) {
            // If count is zero then have possible values, and can check them
            var removePossibleValue = <int>{};
            var variable = relatedVariables[0] as ExpressionClue;
            for (var value in possibleValue) {
              var valid = validValue == null
                  ? clue.digitsMatch(value)
                  : validValue(variable, value, [], []);
              if (!valid) removePossibleValue.add(value);
            }
            if (removePossibleValue.isNotEmpty) {
              possibleValue.removeAll(removePossibleValue);
            }
            // Get values for other variables
            // variables.clear;
            // possibleVariables!.clear();
            // for (var variable
            //     in relatedVariables.where((element) => element != clue)) {
            //   if (variable is VariableClue) {
            //     var variableValues =
            //         variable.values ?? variable.getValuesFromDigits();
            //     if (variableValues != null) {
            //       variables.add(variable);
            //       possibleVariables[variable] = variableValues
            //           .where((element) => validClue(variable, element, [], []))
            //           .toSet();
            //     }
            //   }
            // }
          } else {
            possibleValue.clear();
            throw SolveException('Cannot compute ${variable.name}');
          }
          return updated;
        }
      }
    }

    var solveVariables =
        clue == relatedVariables.first ? relatedVariables : [clue];
    maxIndex = solveVariables.length - 1;
    updated = solveNextClue(solveVariables, 0, [], [], [], [], maxCount);

    return updated;
  }

  var allRelatedVariables = <List<Variable>>[];
  bool initAllRelatedVariables = true;

  List<Variable>? relatedVariablesForVariable(Variable variable) {
    if (initAllRelatedVariables) {
      getRelatedVariables();
      initAllRelatedVariables = false;
    }
    for (var relatedVariables in allRelatedVariables) {
      if (relatedVariables.contains(variable)) {
        return relatedVariables;
      }
    }
    return null;
  }

  void getRelatedVariables() {
    // Find ordered sets of solvable variables that refer to each other
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

          // Add variables this variable references
          for (var variableRef in variable.variableClueReferences) {
            if (variableRef is Expression) {
              if (!relatedVariables.contains(variableRef)) {
                relatedVariables.add(variableRef);
              }
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
    }
    for (var relatedVariables in allRelatedVariables) {
      print(
          'relatedVariables=${relatedVariables.map((e) => '${e is EntryMixin ? 'E' : ''}${e.name}').join(',')}');
    }
  }

  void getVariableValues(
    List<Variable> listClues,
    List<ExpressionEvaluator> exps,
    List<String> unknownVariable,
    List<String> impossibleVariable,
    List<List<int>> variableValues,
    List<Variable> variables, [
    List<Variable>? excludeVariables,
    List<Variable>? solvedVariables,
    List<int>? solvedVariableValues,
  ]) {
    var variableReferences =
        listClues.expand((clue) => clue.variableReferences);
    var expVariableReferences = Set<Variable>.from(exps.expand((exp) => exp
        .variableRefs
        .where((variable) => variableReferences.contains(variable))));
    for (var variable in expVariableReferences) {
      // Not including the input variables prevents self-referring clues
      // if (listClues.contains(variable)) continue;
      // Do not include the exclude variables
      if (excludeVariables != null && excludeVariables.contains(variable)) {
        continue;
      }
      if (solvedVariables != null && solvedVariables.contains(variable)) {
        // Know variable value
        variableValues
            .add([solvedVariableValues![solvedVariables.indexOf(variable)]]);
        variables.add(variable);
      } else {
        var values = variable.values;
        if (values == null && variable is ExpressionVariable) {
          values = variable.getValuesFromMinMax();
        }
        if (values == null) {
          unknownVariable.add(variable.name);
        } else if (values.isEmpty) {
          impossibleVariable.add(variable.name);
        } else {
          variableValues.add(values.toList()..sort());
          variables.add(variable);
        }
      }
    }
    var clueReferences = listClues.expand((clue) => clue.clueReferences);
    var expClueReferences = Set<Variable>.from(exps.expand((exp) => exp
        .variableRefs
        .where((variable) => clueReferences.contains(variable))));
    getClueValues(
        listClues,
        clues,
        List.from(expClueReferences),
        unknownVariable,
        impossibleVariable,
        variableValues,
        variables,
        false,
        excludeVariables,
        solvedVariables,
        solvedVariableValues);
    var entryReferences = listClues.expand((clue) => clue.entryReferences);
    var expEntryReferences = Set<Variable>.from(exps.expand((exp) => exp
        .variableRefs
        .where((variable) => entryReferences.contains(variable))));
    getClueValues(
        listClues,
        entries,
        List.from(expEntryReferences),
        unknownVariable,
        impossibleVariable,
        variableValues,
        variables,
        true,
        excludeVariables,
        solvedVariables,
        solvedVariableValues);
  }

  void getClueValues(
    List<Variable> listClues,
    Map<String, ClueKind> clues,
    List<Variable> clueReferences,
    List<String> unknownVariable,
    List<String> impossibleVariable,
    List<List<int>> variableValues,
    List<Variable> variables, [
    bool isEntry = false,
    List<Variable>? excludeVariables,
    List<Variable>? solvedVariables,
    List<int>? solvedVariableValues,
  ]) {
    for (var otherClue in clueReferences) {
      // Not including the input variables prevents self-referring clues
      // if (listClues.contains(otherClue)) continue;
      // Do not include the exclude variables
      if (excludeVariables != null && excludeVariables.contains(otherClue)) {
        continue;
      }
      if (solvedVariables != null && solvedVariables.contains(otherClue)) {
        // Know variable value
        variableValues
            .add([solvedVariableValues![solvedVariables.indexOf(otherClue)]]);
        variables.add(otherClue);
      } else {
        // Clue values may not yet be available
        var otherClueValues = otherClue.values;
        //if (otherClueValues == null && clue.circularClueReference) {
        otherClueValues ??= getValuesFromClueDigits(otherClue as Clue);
        if (otherClueValues == null) {
          unknownVariable.add(otherClue.name);
        } else if (otherClueValues.isEmpty) {
          impossibleVariable.add(otherClue.name);
        } else {
          variableValues.add(otherClueValues.toList()..sort());
          variables.add(otherClue);
        }
      }
    }
  }

  // Generic expression evaluator, supports variables
  bool solveVariable(
    Variable variable,
    ExpressionEvaluator exp,
    Set<int> possibleValue,
    Map<Variable, Set<int>>? possibleVariables, [
    bool Function(Variable, int, List<String>, List<int>)? validValue,
    int maxCount = 1000000,
    bool enforceDistinctValues = false,
  ]) {
    final stopwatch = Stopwatch()..start();
    var updated = false;
    var variables = <Variable>[];
    var variableValues = <List<int>>[];
    var count = getVariables([variable], [exp], possibleValue,
        possibleVariables, variables, variableValues, maxCount);
    if (count == 0) return false;
    if (count > maxCount) {
      if (Crossnumber.traceSolve) {
        print(
            'Eval ${variable.runtimeType} ${variable.name} cartesianCount=$count Exception');
      }
      throw SolveException();
    }
    var variableNames = variables.map((e) => e.name).toList();
    for (var product
        in variableValues.isEmpty ? [<int>[]] : cartesian(variableValues)) {
      try {
        for (var value
            in exp.generate(variable.min, variable.max, variables, product)) {
          if (enforceDistinctValues) {
            // Variable values are distinct
            if (product.contains(value)) continue;
          }
          if ((variable.min == null || value >= variable.min!) &&
              (variable.max == null || value < variable.max! + 1)) {
            var valid = validValue == null
                ? true
                : validValue(variable, value, variableNames, product);
            if (valid) {
              possibleValue.add(value);
              var index = 0;
              for (var variable in variables) {
                possibleVariables![variable]!.add(product[index++]);
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

  void maintainClueValueOrder(
    Clue clue,
    Set<Variable> updatedVariables, [
    Comparator<String>? compare,
  ]) {
    // Maintain clue value order
    var newMin = clue.values!.reduce(min);
    if (clue.min == null || clue.min! < newMin) clue.min = newMin;
    var newMax = clue.values!.reduce(max);
    if (clue.max == null || clue.max! > newMax) clue.max = newMax;
    // Clues are defined in ascending order of value
    compare ??= (String a, String b) => a.compareTo(b);
    var lowerClues = clues.values
        .where((otherClue) => compare!(clue.name, otherClue.name) > 0)
        .sorted((clue, otherClue) => -compare!(clue.name, otherClue.name));
    var higherClues = clues.values
        .where((otherClue) => compare!(clue.name, otherClue.name) < 0)
        .sorted((clue, otherClue) => compare!(clue.name, otherClue.name));

    var prevMin = clue.min!;
    var prevMax = clue.max!;
    for (var otherClue in lowerClues) {
      if ((otherClue.max == null || otherClue.max! >= prevMax)) {
        otherClue.max = prevMax - 1;
        if (otherClue.values != null) {
          // Remove some values
          var removeValues = otherClue.values!
              .where((value) => value > otherClue.max!)
              .toList();
          if (removeValues.isNotEmpty) {
            otherClue.removeValues(removeValues);
            updatedVariables.add(otherClue);
            otherClue.max = otherClue.values!.reduce(max);
          }
        }
      }
      prevMax = otherClue.max!;
    }
    for (var otherClue in higherClues) {
      if ((otherClue.min == null || otherClue.min! <= prevMin)) {
        otherClue.min = prevMin + 1;
        if (otherClue.values != null) {
          // Remove some values
          var removeValues = otherClue.values!
              .where((value) => value < otherClue.min!)
              .toList();
          if (removeValues.isNotEmpty) {
            otherClue.removeValues(removeValues);
            updatedVariables.add(otherClue);
            otherClue.min = otherClue.values!.reduce(min);
          }
        }
      }
      prevMin = otherClue.min!;
    }
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
    if (variableNames.isEmpty) {
      throw SolveException('No variable values to iterate over!');
    }
    if (variableValues.any((element) => element.isEmpty)) {
      throw SolveException('A variable has no values!');
    }

    // Determine if variables are distinct, and if so how
    // Get count of known values
    var distinctType = !variablesList.distinct
        ? 'Duplicate'
        : variablesList.distinctValueLimit == 1
            ? 'Distinct'
            : 'Limit';
    // Get count of known values
    var duplicateLimit =
        distinctType == 'Limit' ? variablesList.getDuplicateLimit() : null;
    var count = 0;
    for (var product in distinctType == 'Distinct'
        ? cartesian(variableValues)
        : distinctType == 'Limit'
            ? cartesianDuplicateLimit(variableValues, duplicateLimit!)
            : cartesian(variableValues, true)) {
      for (var i = 0; i < product.length; i++) {
        this.variables[variableNames[i]]!.tryValue = product[i];
      }
      // Check all clues
      var found = true;
      solution = {};
      for (var clue in clues.values) {
        if (clue is VariableClue) {
          var possibleValue = <int>{};
          Map<Variable, Set<int>> possibleVariables = {};
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
        if (checkSolution()) {
          print(solutionToString());
          count++;
        }
      }
    }
    // Clean up
    for (var i = 0; i < variableNames.length; i++) {
      this.variables[variableNames[i]]!.tryValue = null;
    }

    return count;
  }

  @override
  String toString() {
    var text = super.toString();
    text += this.variableList.toString();
    return text;
  }

  @override
  String toSummary() {
    var text = super.toSummary();
    text += this.variableList.toSummary();
    return text;
  }
}

class Answer {
  List<int>? possible;
  int? value;
  Answer(this.possible) {
    if (possible?.length == 1) {
      value = possible![0];
    }
  }
  Answer.value(int this.value) : possible = [value];
}
