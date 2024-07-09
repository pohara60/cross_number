/// An API for solving Letters puzzles.
library pandigitals;

import '../cartesian.dart';
import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../generators.dart';
import '../puzzle.dart';
import '../set.dart';
import '../variable.dart';
import './variable_group.dart';
import './clue.dart';
import './puzzle.dart';

typedef RSTP = ({int r, int s, int t, int p});

/// Provide access to the Prime Cuts API.
class Pandigitals extends Crossnumber<PandigitalsPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 :3 |4 :  :5 |',
    '+--+::+::+::+--+::+',
    '|6 :  |7 :  :  |  |',
    '+--+::+::+--+--+::+',
    '|8 :  :  |9 :10:  |',
    '+::+--+--+::+::+--+',
    '|  |11:12:  |13:  |',
    '+::+--+::+::+::+--+',
    '|14:  :  |15:  :  |',
    '+--+--+--+--+--+--+',
  ];

  final variableGroups = <VariableGroup>[];
  Pandigitals() {
    puzzle = PandigitalsPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    // S, T and P are three 3-digit numbers that between them contain all of the
    // digits from 1 to 9 inclusive such that S is a square number, T a triangular
    // number and P a prime number. The result R of the calculation S + T - P is
    // a 3-digit prime number.
    var letters = [
      'S',
      'P',
      'T',
      'R',
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(PandigitalsVariable(letter));
    }

    // Create Variable Group for each set of rules
    var variables = puzzle.variables.values.toList();
    variableGroups.add(VariableGroup('I', variables));
    variableGroups.add(VariableGroup('II', variables));
    variableGroups.add(VariableGroup('III', variables));
    variableGroups.add(VariableGroup('IV', variables));
    variableGroups.add(VariableGroup('V', variables));

    var clueErrors = '';
    void clueWrapper(
        {String? name,
        int? length,
        List<String>? valueDesc,
        SolveFunction? solve}) {
      try {
        // Expression is not attached to clue
        var entry = PandigitalsClue(
            name: name!, length: length, valueDesc: '', solve: solve);
        puzzle.addClue(entry);
        for (var index = 0; index < valueDesc!.length; index++) {
          if (valueDesc[index] != '') {
            variableGroups[index]
                .clues
                .add(ClueExpression(entry, valueDesc[index]));
          }
        }
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(
        name: 'A1',
        length: 3,
        valueDesc: [r"", r"", r"P", r"$jumble R", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'A4',
        length: 3,
        valueDesc: [r"", r"", r"", r"", r"T'"],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'A6',
        length: 2,
        valueDesc: [r"", r"", r"", r"D3-D4-P", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'A7',
        length: 3,
        valueDesc: [r"", r"", r"", r"", r"R"],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'A8',
        length: 3,
        valueDesc: [r"", r"", r"", r"T/3", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'A9',
        length: 3,
        valueDesc: [r"", r"R", r"", r"", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'A11',
        length: 3,
        valueDesc: [r"R", r"", r"", r"", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'A13',
        length: 2,
        valueDesc: [r"√S", r"S/(A6+D4-D12)", r"", r"", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'A14',
        length: 3,
        valueDesc: [r"", r"T", r"", r"", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'A15',
        length: 3,
        valueDesc: [r"", r"", r"T", r"", r""],
        solve: solvePandigitalsClue);

    clueWrapper(
        name: 'D2',
        length: 3,
        valueDesc: [r"", r"", r"", r"", r"P+D4*D4"],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'D3',
        length: 3,
        valueDesc: [r"", r"", r"", r"P+A6+D4", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'D4',
        length: 2,
        valueDesc: [r"", r"S/A13-A6+D12", r"√S", r"D3-A6-P", r"√(D2-P)"],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'D5',
        length: 3,
        valueDesc: [r"P'", r"P'", r"", r"", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'D8',
        length: 3,
        valueDesc: [r"T", r"", r"", r"", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'D9',
        length: 3,
        valueDesc: [r"", r"", r"R", r"", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'D10',
        length: 3,
        valueDesc: [r"", r"", r"", r"S'", r""],
        solve: solvePandigitalsClue);
    clueWrapper(
        name: 'D12',
        length: 2,
        valueDesc: [r"", r"A6+D4-S/A13", r"", r"", r"√S"],
        solve: solvePandigitalsClue);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry =
            PandigitalsEntry(name: entrySpec.name, length: entrySpec.length);
        puzzle.addEntry(entry);
        // Link clues to entries
        puzzle.mapClueToEntry(puzzle.clues[entrySpec.name]!, entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += '${e.msg}\n';
      }
    }

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    puzzle.linkEntriesToGrid();

    var variableError = '';
    for (var variableGroup in variableGroups) {
      variableError += variableGroup.checkClueReferences(puzzle);
      variableError += variableGroup.checkVariableReferences(puzzle);
      variableGroup.resolveReferences(puzzle);
    }
    if (variableError != '') throw PuzzleException(variableError);

    puzzle.finalize();

    super.initCrossnumber();
  }

  bool differentDigits(int a, int b) {
    var aStr = a.toString();
    var bStr = b.toString();
    for (var d = 0; d < aStr.length; d++) {
      if (bStr.contains(aStr[d])) return false;
      if (d + 1 < aStr.length && aStr.substring(d + 1).contains(aStr[d])) {
        return false;
      }
      if (d + 1 < bStr.length && bStr.substring(d + 1).contains(bStr[d])) {
        return false;
      }
    }
    return true;
  }

  final rstpList = <RSTP>[];
  void getRSTP() {
    print(' R = S + T - P ');
    var primes = generatePrimes(100, 999).toList();
    for (var s in generateSquares(100, 999)) {
      for (var p in primes.where((p) => differentDigits(s, p))) {
        for (var t in generateTriangles(100, 999)
            .where((t) => differentDigits(s, t) && differentDigits(p, t))) {
          var r = s + t - p;
          if (r >= 100 && r <= 999 && primes.contains(r)) {
            print('$r=$s+$t-$p');
            var record = (r: r, s: s, t: t, p: p);
            rstpList.add(record);
          }
        }
      }
    }
  }

  // Validate possible clue value
  @override
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (!super.validClue(clue, value, variableReferences, variableValues)) {
      return false;
    }
    return true;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solvePandigitalsClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var clue = v as PandigitalsClue;
    var updated = false;
    if (clue.valueDesc != '') {
      // updated = puzzle.solveExpressionEvaluator(
      //     clue, possibleValue, possibleVariables, validClue);
    } else {
      // Values may have been set by other Clue
      if (clue.values != null) {
        var values =
            clue.values!.where((value) => validClue(clue, value, [], []));
        possibleValue.addAll(values);
      }
    }
    return updated;
  }

  @override
  void solve([bool iteration = true]) {
//    super.solve(false);
    getRSTP();

    // Iterate over variable groups
    var rstpQueues =
        List.generate(variableGroups.length, (i) => List<RSTP>.from(rstpList));
    var anyGroupUpdated = true;
    while (anyGroupUpdated) {
      anyGroupUpdated = false;
      for (var index = 0; index < variableGroups.length; index++) {
        var variableGroup = variableGroups[index];
        var rstpQueue = rstpQueues[index];
        var groupUpdated = false;
        // Update entry digits
        for (var clueExp in variableGroup.clues) {
          clueExp.clue.initialise();
        }
        var rstpInvalid = <RSTP>[];
        var allClueValues = <String, Set<int>>{};
        // Iterate over rstp
        for (var rstp in rstpQueue) {
          var clueValues = <String, Set<int>>{};
          var updated = true;
          var ok = true;
          while (updated) {
            updated = false;
            try {
              // Iterate over clue expressions, getting possible values
              for (var clueExp in variableGroup.clues) {
                try {
                  if (solveClueExp(rstp, clueExp, clueValues)) updated = true;
                } on SolveException {
                  continue;
                }
              }
            } on SolveError {
              // No solution possible, this rstp is invalid
              rstpInvalid.add(rstp);
              ok = false;
              break;
            }
          }
          if (ok) {
            clueValues.forEach((key, value) {
              if (allClueValues[key] == null) {
                allClueValues[key] = value;
              } else {
                allClueValues[key]!.addAll(value);
              }
            });
          }
        }
        // Set clue values

        var s = StringBuffer();
        s.writeln("solve: $variableGroup");
        for (var clueEntry in allClueValues.entries) {
          var clueName = clueEntry.key;
          var clue = puzzle.clues[clueName]!;
          if (puzzle.updateVariableValues(clue, clueEntry.value).isNotEmpty) {
            if (clue.values!.isEmpty) {
              print("solve: ${clue.toString()}");
              throw SolveError('Solve Error no values for clue ${clue.name}');
            }
            groupUpdated = true;
            anyGroupUpdated = true;
            clue.finalise();
            s.writeln("solve: ${clue.toString()}");
          }
        }
        if (rstpInvalid.isNotEmpty) {
          rstpQueue.removeWhere((element) => rstpInvalid.contains(element));
          groupUpdated = true;
          anyGroupUpdated = true;
          s.writeln('solve: rstpQueue.length=${rstpQueue.length}');
        }
        if (groupUpdated) {
          print(s.toString());
          printLetter(String letter, int Function(RSTP) select) {
            var list = rstpQueue.map<int>(select).toList();
            var nodups = List<int>.from(Set<int>.from(list))..sort();
            print('$letter=${list.toShortString()}=${nodups.toShortString()}');
          }

          printLetter('R', (rstp) => rstp.r);
          printLetter('S', (rstp) => rstp.s);
          printLetter('T', (rstp) => rstp.t);
          printLetter('P', (rstp) => rstp.p);
        }
      }
    }

    // Copy clue values to entries
    for (var clue in puzzle.clues.values) {
      clue.entry!.values = clue.values;
    }

    endSolve(false);

    // Print variable group variable values
    print(
        "     ${'S'.padLeft(3)} ${'T'.padLeft(3)} ${'P'.padLeft(3)} ${'R'.padLeft(3)}");
    for (var index = 0; index < variableGroups.length; index++) {
      var variableGroup = variableGroups[index];
      var rstpQueue = rstpQueues[index];
      for (var rstp in rstpQueue) {
        print(
            "${variableGroup.name.padLeft(4)} ${rstp.s} ${rstp.t} ${rstp.p} ${rstp.r}");
      }
    }
  }

  bool solveClueExp(
      RSTP rstp, ClueExpression clueExp, Map<String, Set<int>> clueValues) {
    // final stopwatch = Stopwatch()..start();
    var clue = clueExp.clue;
    var updated = false;
    var possibleValue = <int>{};
    var possibleVariables = <Variable, Set<int>>{};
    var updatedClues = <String>{};
    var variableValues = <List<int>>[];
    var unknownVariable = <String>[];
    var impossibleVariable = <String>[];
    for (var variable in clueExp.variableReferences) {
      possibleVariables[variable] = <int>{};
      switch (variable.name) {
        case 'R':
          variableValues.add([rstp.r]);
          break;
        case 'S':
          variableValues.add([rstp.s]);
          break;
        case 'T':
          variableValues.add([rstp.t]);
          break;
        case 'P':
          variableValues.add([rstp.p]);
          break;
      }
    }
    for (var otherClue in clueExp.clueReferences) {
      possibleVariables[otherClue] = <int>{};
      // Clue values may not yet be available
      var otherClueValues = otherClue.values;
      //if (otherClueValues == null && clue.circularClueReference) {
      otherClueValues ??= getValuesFromClueDigits(otherClue as Clue);
      if (otherClueValues == null) {
        unknownVariable.add(otherClue.name);
      } else if (otherClueValues.isEmpty) {
        impossibleVariable.add(otherClue.name);
      } else {
        variableValues.add(otherClueValues.toList());
      }
    }

    // Unknown variable
    if (unknownVariable.isNotEmpty) {
      // Try guessing clue values
      var clueValues = getValuesFromClueDigits(clue);
      if (clueValues != null) {
        possibleValue.addAll(clueValues);
        // Cannot update variables
        possibleVariables.clear();
        return false;
      }
      throw SolveException(
          "Solve ${clue.name} no values for variable(s) $unknownVariable");
    }
    // Impossible variable
    if (impossibleVariable.isNotEmpty) {
      throw SolveException(
          "Solve ${clue.name} no values for variable(s) $impossibleVariable");
    }

    var count = cartesianCount(variableValues);
    // if (count > 500000000) {
    if (count > 100000) {
      if (Crossnumber.traceSolve) {
        // print('Eval ${clue.name} cartesianCount=$count Exception');
      }
      throw SolveException();
    }
    for (var product
        in variableValues.isEmpty ? [<int>[]] : cartesian(variableValues)) {
      try {
        for (var value in clueExp.exp.generate(clue.min, clue.max,
            clueExp.variableClueReferences.toList(), product)) {
          if (value >= clue.min! && value < clue.max! + 1) {
            var valid = clue.digitsMatch(value);
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
        }
      } on ExpressionInvalid {
        // Illegal values
      }
    }
    if (Crossnumber.traceSolve) {
      if (count != 1) {
        // print(
        //     'Eval ${clue.name} cartesianCount=$count, elapsed ${stopwatch.elapsed}');

        // print('${clue.exp.toString()}');
        // for (var v in clue.variableReferences) {
        //   print('$v=${this.variables[v]!.values!.toList()}');
        // }
      }
    }
    // If no Values returned then Solve function could not solve
    if (possibleValue.isEmpty) {
      // print(
      //     'Solve Error: clue ${clue.name} (${clueExp.expression}) no solution!');
      throw SolveError(
          'Solve Error: clue ${clue.name} (${clueExp.expression}) no solution!');
    }
    // if (puzzle.updateValues(clue, possibleValue)) updated = true;
    if (clueValues[clue.name] == null) clueValues[clue.name] = {};

    if (addPossible(clueValues[clue.name]!, possibleValue)) {
      updated = true;
      // if (updateClues(clueName, possibleVariables[clueName]!))
      updatedClues.add(clue.name);
    }
    // if (clue.finalise()) updated = true;
    for (var clue in clue.clueReferences) {
      if (possibleVariables[clue] != null) {
        var clueName = clue.name;
        if (clueValues[clueName] == null) clueValues[clueName] = {};

        if (addPossible(clueValues[clueName]!, possibleVariables[clue]!)) {
          updated = true;
          // if (updateClues(clueName, possibleVariables[clueName]!))
          updatedClues.add(clueName);
        }
      }
    }

    if (Crossnumber.traceSolve && updatedClues.isNotEmpty) {
      // print("solveClueExp: ${clueExp.toString()}");
      // for (var clueName in updatedClues) {
      //   print('$clueName=${clueValues[clueName]!.toShortString()}');
      // }
    }
    return updated;
  }
}

bool addPossible(Set<int> possible, Set<int> possibleValues) {
  var updated = false;
  for (var value in possibleValues) {
    if (possible.add(value)) updated = true;
  }
  return updated;
}
