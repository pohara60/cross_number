library excuses;

// import 'dart:io';
import 'dart:math';

import 'package:crossnumber/set.dart';

import '../cartesian.dart';
import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Excuses API.
class Excuses extends Crossnumber<ExcusesPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+--+',
    '|1 :2 :3 :4 :5 :  :6 |7 :8 |',
    '+::+::+::+::+::+--+::+::+::+',
    '|  |  |9 :  :  |10:  :  :  |',
    '+::+::+::+::+--+::+--+::+::+',
    '|11:  :  :  |12:  :13:  |  |',
    '+::+--+::+::+::+::+::+--+--+',
    '|14:15|16:  :  :  :  |17|18|',
    '+::+::+::+--+::+::+::+::+::+',
    '|  |19:  :20:  :  :  :  |  |',
    '+::+::+::+::+::+--+::+::+::+',
    '|  |  |21:  :  :22:  |23:  |',
    '+--+--+::+::+::+::+::+--+::+',
    '|24|25:  :  :  |26:  :27:  |',
    '+::+::+--+::+--+::+::+::+::+',
    '|28:  :29:  |30:  :  |  |  |',
    '+::+::+::+--+::+::+::+::+::+',
    '|31:  |32:  :  :  :  :  :  |',
    '+--+--+--+--+--+--+--+--+--+',
  ];

  Excuses() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = ExcusesPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions

    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = ExcusesEntry(
          name: entrySpec.name,
          length: entrySpec.length,
        );
        puzzle.addEntry(entry);
      } on ExpressionInvalid catch (e) {
        entryErrors += '${e.msg}\n';
      }
    }

    if (entryErrors != '') {
      throw PuzzleException(entryErrors);
    }

    // For alpha entry names we pass the names to clue expression parsing
    // Until we create a clue, then entries are returned as clues (legacy)
    var entryNames = puzzle.clues.keys.toList();

    var clueErrors = '';
    void clueWrapper({
      String? name,
      int? length,
      String? value,
      List<String>? addDesc,
      String? a,
      String? b,
      String? c,
      String? n,
      String isLetter = "",
      String entryName = "",
    }) {
      try {
        var clue = ExcusesClue(
            name: name!,
            length: length,
            // valueDesc: value,
            addDesc: addDesc,
            a: a,
            b: b,
            c: c,
            n: n,
            isLetter: isLetter,
            // solve: solveExcusesClue,
            entryNames: entryNames);
        puzzle.addClue(clue);
        clue.entry = puzzle.entries[entryName];
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    //=CONCATENATE("clueWrapper(name:'",A27,"', length:",h27,", value:'",c27,"', a:'",d27,"', b:'",e27,"', c:'",f27,"', n:'",g27,"', isLetter:'",i27,"', entryName:'",b27,"');")
    clueWrapper(
        name: '1',
        length: 3,
        value: 'f^h + m^h = (l + z)^h',
        a: 'f',
        b: 'm',
        c: '(l + z)',
        n: 'h',
        isLetter: '',
        entryName: 'D15');
    clueWrapper(
        name: '2',
        length: 3,
        value: '(g - n - q)^h + (a + c)^h = f^h',
        a: '(g - n - q)',
        b: '(a + c)',
        c: 'f',
        n: 'h',
        isLetter: '',
        entryName: 'D2');
    clueWrapper(
        name: '3',
        length: 4,
        value: '(u + y)^h + (v + x)^h = (c + qz)^h',
        a: '(u + y)',
        b: '(v + x)',
        c: '(c + qz)',
        n: 'h',
        isLetter: '',
        entryName: 'A12');
    clueWrapper(
        name: '4',
        length: 4,
        value: '(d + g)^h + (l + y)^h = (qz)^h',
        a: '(d + g)',
        b: '(l + y)',
        c: '(qz)',
        n: 'h',
        isLetter: '',
        entryName: 'A26');
    clueWrapper(
        name: '5',
        length: 2,
        value: 'c^h + p^h = q^h',
        a: 'c',
        b: 'p',
        c: 'q',
        n: 'h',
        isLetter: '',
        entryName: 'D30');
    clueWrapper(
        name: '6',
        length: 2,
        value: 'k^i + n^i = (k + n)^i',
        a: 'k',
        b: 'n',
        c: '(k + n)',
        n: 'i',
        isLetter: '',
        entryName: 'A31');
    clueWrapper(
        name: '7',
        length: 3,
        value: '(m - t)^c + (y - l)^c = (qt - kz)^c',
        a: '(m - t)',
        b: '(y - l)',
        c: '(qt - kz)',
        n: 'c',
        isLetter: 'Y',
        entryName: 'D8');
    clueWrapper(
        name: '8',
        length: 4,
        value: '(qt - kz)^c + (m - z)^c = (g - r)^c',
        a: '(qt - kz)',
        b: '(m - z)',
        c: '(g - r)',
        n: 'c',
        isLetter: 'Y',
        entryName: 'D20');
    clueWrapper(
        name: '9',
        length: 3,
        value: 'q^c + (m - t)^c = (x - l)^c',
        a: 'q',
        b: '(m - t)',
        c: '(x - l)',
        n: 'c',
        isLetter: 'Y',
        entryName: 'D24');
    clueWrapper(
        name: '10',
        length: 4,
        value: 'd^h + (t + y)^h = (cu)^h',
        a: 'd',
        b: '(t + y)',
        c: '(cu)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'A10');
    clueWrapper(
        name: '11',
        length: 2,
        value: '(v - a)^h + d^h = e^h',
        a: '(v - a)',
        b: 'd',
        c: 'e',
        n: 'h',
        isLetter: 'Y',
        entryName: 'D6');
    clueWrapper(
        name: '12',
        length: 3,
        value: '(k + n)^h + (i + x)^h = (d + f)^h',
        a: '(k + n)',
        b: '(i + x)',
        c: '(d + f)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'A9');
    clueWrapper(
        name: '13',
        length: 7,
        value: '(t+v) ^c+(jp+r)^c = (cnq)^c',
        a: '(t+v)',
        b: '(jp+r)',
        c: '(cnq)',
        n: 'c',
        isLetter: 'Y',
        entryName: 'A32');
    clueWrapper(
        name: '14',
        length: 4,
        value: '(f + j)^h + (eq)^h = (b + f + g)^h',
        a: '(f + j)',
        b: '(eq)',
        c: '(b + f + g)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'A28');
    clueWrapper(
        name: '15',
        length: 2,
        value: 'i^h + p^h = q^h',
        a: 'i',
        b: 'p',
        c: 'q',
        n: 'h',
        isLetter: 'Y',
        entryName: 'A7');
    clueWrapper(
        name: '16',
        length: 3,
        value: 'r^h + v^h = m^h',
        a: 'r',
        b: 'v',
        c: 'm',
        n: 'h',
        isLetter: 'Y',
        entryName: 'D25');
    clueWrapper(
        name: '17',
        length: 2,
        value: '(e - k)^h + (l - a)^h = (u - n)^h',
        a: '(e - k)',
        b: '(l - a)',
        c: '(u - n)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'D29');
    clueWrapper(
        name: '18',
        length: 4,
        value: '(e + u)^h + (cj)^h = (b + x + y)^h',
        a: '(e + u)',
        b: '(cj)',
        c: '(b + x + y)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'D22');
    clueWrapper(
        name: '19',
        length: 2,
        value: '(x - g)^h + (e - q)^h = (d + q - o)^h',
        a: '(x - g)',
        b: '(e - q)',
        c: '(d + q - o)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'A23');
    clueWrapper(
        name: '20',
        length: 7,
        value: '(k + n)^q + (g - o)^q = (o + u - q)^q',
        a: '(k + n)',
        b: '(g - o)',
        c: '(o + u - q)',
        n: 'q',
        isLetter: 'Y',
        entryName: 'A1');
    clueWrapper(
        name: '21',
        length: 4,
        value: '(s - d)^c + (ev - of)^c = z^c',
        a: '(s - d)',
        b: '(ev - of)',
        c: 'z',
        n: 'c',
        isLetter: 'Y',
        entryName: 'D10');
    clueWrapper(
        name: '22',
        length: 3,
        value: 'p^h + (c + m - e)^h = t^h',
        a: 'p',
        b: '(c + m - e)',
        c: 't',
        n: 'h',
        isLetter: 'Y',
        entryName: 'D17');
    clueWrapper(
        name: '23',
        length: 2,
        value: 'h^h + (c + q)^h = d^h',
        a: 'h',
        b: '(c + q)',
        c: 'd',
        n: 'h',
        isLetter: 'Y',
        entryName: 'A14');
    clueWrapper(
        name: '24',
        length: 5,
        value: '(q^c)^h + (q^c + b)^h = (bd - q)^h',
        a: '(q^c)',
        b: '(q^c + b)',
        c: '(bd - q)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'D12');
    clueWrapper(
        name: '25',
        length: 5,
        value: '(p + w) + (hw + k)^c = (hw + o)^c',
        a: '(p + w)',
        b: '(hw + k)',
        c: '(hw + o)',
        n: 'c',
        isLetter: 'Y',
        entryName: 'A21');
    clueWrapper(
        name: '26',
        length: 2,
        value: 'h^h + d^h = e^h',
        a: 'h',
        b: 'd',
        c: 'e',
        n: 'h',
        isLetter: 'Y',
        entryName: 'D5');
    clueWrapper(
        name: '27',
        length: 6,
        value: '(mq-e)^h + (cez + e)^h = (cez + j)^h',
        a: '(mq-e)',
        b: '(cez + e)',
        c: '(cez + j)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'D1');
    clueWrapper(
        name: '28',
        length: 6,
        value: '(r + u)^c + (gh + hu)^c = (nz)^c',
        a: '(r + u)',
        b: '(gh + hu)',
        c: '(nz)',
        n: 'c',
        isLetter: 'Y',
        entryName: 'D18');
    clueWrapper(
        name: '29',
        length: 3,
        value: 'o^h + e^h = (y - u)^h',
        a: 'o',
        b: 'e',
        c: '(y - u)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'D7');
    clueWrapper(
        name: '30',
        length: 4,
        value: '(t-p)^c + (t - i)^c = (i + t)^c',
        a: '(t-p)',
        b: '(t - i)',
        c: '(i + t)',
        n: 'c',
        isLetter: 'Y',
        entryName: 'A11');
    clueWrapper(
        name: '31',
        length: 3,
        value: '(y - f)^h + u^h = (p + r)^h',
        a: '(y - f)',
        b: 'u',
        c: '(p + r)',
        n: 'h',
        isLetter: 'Y',
        entryName: 'A30');
    clueWrapper(
        name: '32',
        length: 4,
        value: '(c + h + q)^h + (g + j + m)^h = (l + x + y)^h',
        a: '(c + h + q)',
        b: '(g + j + m)',
        c: '(l + x + y)',
        n: 'h',
        isLetter: '',
        entryName: 'A25');
    clueWrapper(
        name: '33',
        length: 4,
        value: '(j + y)^h + (mp)^h = (fq - c)^h',
        a: '(j + y)',
        b: '(mp)',
        c: '(fq - c)',
        n: 'h',
        isLetter: '',
        entryName: 'D4');
    clueWrapper(
        name: '34',
        length: 3,
        value: 'o^h + a^h = v^h',
        a: 'o',
        b: 'a',
        c: 'v',
        n: 'h',
        isLetter: '',
        entryName: 'D27');
    clueWrapper(
        name: '35',
        length: 7,
        value: '(hy - k - x)^p + (i + nq)^p = (f + v)^p',
        a: '(hy - k - x)',
        b: '(i + nq)',
        c: '(f + v)',
        n: 'p',
        isLetter: '',
        entryName: 'D3');
    clueWrapper(
        name: '36',
        length: 7,
        value: '(mqz)^h + (l(q^c)+i)^h= (hjqz)^h',
        a: '(mqz)',
        b: '(l(q^c)+i)',
        c: '(hjqz)',
        n: 'h',
        isLetter: '',
        entryName: 'D13');
    clueWrapper(
        name: '37',
        length: 5,
        value: '(bp)^h + (ef)^h = (fz - i)^h',
        a: '(bp)',
        b: '(ef)',
        c: '(fz - i)',
        n: 'h',
        isLetter: '',
        entryName: 'A16');
    clueWrapper(
        name: '38',
        length: 7,
        value: '(k^p - hk - hn)^h + (k^p + p^p - c)^h = (h(e^c) + c)^h',
        a: '(k^p - hk - hn)',
        b: '(k^p + p^p - c)',
        c: '(h(e^c) + c)',
        n: 'h',
        isLetter: '',
        entryName: 'A19');

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.linkEntriesToGrid();

    var letters = [
      // variables
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
    ];
    for (var letter in letters) {
      puzzle.addVariable(ExcusesVariable(letter));
    }

    puzzle.finalize();

    initClues();

    super.initCrossnumber();
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    super.solve(false);
    postProcessing();
  }

  @override
  Set<Variable> solveClue(Variable variable) {
    var puzzle = puzzleForVariable[variable]!;

    // If clue solved already then skip it
    // Can no longer do this because clue can be set by other clues
    // if (clue.values != null && clue.values!.length == 1) return false;

    var updated = false;
    if (variable is Clue && variable.initialise()) updated = true;

    var updatedVariables = <Variable>{};
    var updatedAllVariables = <Variable>[];
    if (variable is ExcusesClue && variable.expressions.isNotEmpty) {
      var possibleValue = <int>{};
      var possibleDiff = <int>{};
      var possibleVariables = <Variable, Set<int>>{};
      // if (clue is VariableClue) {
      for (var variableRef in variable.variableClueReferences) {
        possibleVariables[variableRef] = <int>{};
        if (variableRef is Clue && variableRef.initialise()) updated = true;
      }

      // Solve with additional possibleDiffs result
      if (solveExcusesClue(
        puzzle,
        variable,
        possibleValue,
        possibleDiff,
        possibleVariables: possibleVariables,
      )) updated = true;
      // } else {
      //   if (clue.solve!(puzzle, clue, possibleValue)) updated = true;
      // }

      // If no Values returned then Solve function could not solve
      if (possibleValue.isEmpty) {
        print(
            'Solve Error: ${variable.variableType.name} ${variable.name} (${variable.valueDesc}) no solution!');

        throw SolveException();
      }

      // Update clue possibleDiffs
      if (possibleDiff.length != variable.diffs.length) {
        variable.diffs = possibleDiff;
        updated = true;
      }

      if (updateClueEntries(
          puzzle, variable, possibleValue, updatedVariables)) {
        updateAllVariables(updatedVariables, updatedAllVariables);
        updated = true;
      }
      for (var variableRef in possibleVariables.keys) {
        var values = possibleVariables[variableRef];
        if (values != null && values.isNotEmpty) {
          if (variableRef.variableType == VariableType.V &&
              updateVariables(puzzle, variableRef.name,
                  possibleVariables[variableRef]!, updatedVariables)) {
            updateAllVariables(updatedVariables, updatedAllVariables);
            updated = true;
          }
          if (variableRef.variableType == VariableType.C &&
              updateClues(puzzle, variableRef as Clue,
                  possibleVariables[variableRef]!, updatedVariables,
                  isFocus: false, focusClue: variable)) {
            updateAllVariables(updatedVariables, updatedAllVariables);
            updated = true;
          }
          if (variableRef.variableType == VariableType.E &&
              updateEntries(puzzle, variableRef as Clue,
                  possibleVariables[variableRef]!, updatedVariables,
                  isFocus: false, focusClue: variable)) {
            updateAllVariables(updatedVariables, updatedAllVariables);
            updated = true;
          }
        }
      }
      if (variable.finalise()) updated = true;
      for (var variableRef in possibleVariables.keys) {
        if (variableRef is Clue && variableRef.finalise()) updated = true;
      }
    } else if (variable is Clue) {
      // No solve function, but may have been updated elsewhere
      // Check digits match
      var values = variable.values;
      if (values != null) {
        var possibleValue = <int>{};
        for (var value in values) {
          if (variable.digitsMatch(value)) possibleValue.add(value);
        }
        // Do not update puzzle known values - need to clean this up
        if (variable.updateValues(possibleValue)) updated = true;
        if (variable.finalise()) updated = true;
      }
    }

    if (Crossnumber.traceSolve && updated) {
      print("solve${puzzle.name}: ${variable.toString()}");
      for (var updateVariable in updatedAllVariables) {
        if (updateVariable != variable) {
          if (updateVariable is ExcusesClue) {
            // print(
            //     '${updateVariable.variableType} ${updateVariable.name}=${updateVariable.minDiff},${updateVariable.maxDiff}');
          } else {
            print(
                '${updateVariable.variableType} ${updateVariable.name}=${updateVariable.values!.toShortString()}');
          }
        }
      }
    }

    // Return all updated variables
    if (updated) {
      if (!updatedAllVariables.contains(variable)) {
        updatedAllVariables.add(variable);
      }
    }

    return updatedVariables;
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
  bool solveExcusesClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue,
    Set<int> possibleDiff, {
    Set<int>? possibleValue2,
    Map<Variable, Set<int>>? possibleVariables,
    Map<Variable, Set<int>>? possibleVariables2,
    Set<Variable>? updatedVariables,
  }) {
    var clue = v as ExcusesClue;
    var updated = false;

    /// Each clue is an equation of the form A ^ N + B ^ N = C ^ N where
    /// A < B < C N < 6 are all positive integers, for each clue the entry in
    /// the grid is the value of A ^ N + B ^ N
    /// Fermat's Last Theorem states that there are no such equations for N > 2
    /// so most of the clues are wrong, with an error value defined as (the
    /// absolute value of) the difference between A ^ N + B ^ N and C ^ N
    ///
    /// Evaluate A, B and C, checking A < B < C, and |C-A+B| in Diff range.
    /// The value is A+B.

    updated = solveNextExpressionEvaluator(
        clue, 0, possibleValue, possibleDiff, possibleVariables!, validClue);
    return updated;
  }

  // Clue solver invokes generic expression evaluator with validator
  bool solveNextExpressionEvaluator(
    ExcusesClue clue,
    int expIndex,
    Set<int> possibleValue,
    Set<int> possibleDiff,
    Map<Variable, Set<int>>? possibleVariables, [
    bool Function(ExpressionClue, int, List<String>, List<int>)? validValue,
    ExpressionCallback? callback,
    int maxCount = 1000000,
  ]) {
    var updated = false;

    var maxCount = 10000000;
    var maxIndex = clue.expressions.length - 1;

    bool solveNextExpression(
      int index,
      List<int> expValues,
      List<Variable> variables,
      List<int> product,
      int maxCount,
    ) {
      // Function to solve one variable and recurse for others
      var updated = false;
      var nextProduct = product;
      var variableNames = <String>[];
      var nextVariableNames = variableNames;
      var newVariables = <Variable>[];
      var nextVariables = <Variable>[];
      var count = 1;
      // if (index > 0) {
      //   print('solveAllClues: index=$index, variable=${variable.name}');
      // }

      bool solveNextExpressionValue(int value) {
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

        if (index == 0) {
          // A > 0
          if (value <= 0) return false;
        }

        if (index == 1 || index == 2) {
          // A < B < C
          if (value <= expValues[index - 1]) return false;
        }

        // Recurse to next expression?
        if (index < maxIndex) {
          // Add this variable and value to product
          expValues.add(value);
          try {
            updated = solveNextExpression(index + 1, expValues, nextVariables,
                nextProduct, maxCount ~/ count);
          } on SolveException {
            // Nothing to do?
          }
          expValues.removeLast();
        } else {
          var a = expValues[0];
          var b = expValues[1];
          var c = expValues[2];
          var n = value;

          // Clue value is A^N+B^N
          var clueValue = (pow(a, n) + pow(b, n)) as int;
          var valid = validValue == null
              ? clue.digitsMatch(clueValue)
              : validValue(clue, clueValue, nextVariableNames, nextProduct);
          if (!valid) return false;

          // |C^N-A^N-B^N| in Diff range
          var diff = (pow(c, n) - pow(a, n) - pow(b, n)) as int;
          if (diff < 0) diff = -diff;
          if (diff < clue.minDiff ||
              clue.maxDiff != null && diff > clue.maxDiff!) return false;
          var i = 0;
          for (var variable in nextVariables) {
            possibleVariables![variable]!.add(nextProduct[i++]);
          }
          possibleValue.add(clueValue);
          possibleDiff.add(diff);
          // stdout.write(
          //     'clueSolution: ${clue.name}, a=$a, b=$b, c=$c, n=$n, value=$clueValue, diff=$diff');
          // i = 0;
          // for (var variable in nextVariables) {
          //   stdout.write(', ${variable.name}=${nextProduct[i++]}');
          // }
          // stdout.write('\n');
        }
        return true;
      }

      var exp = clue.expressions[index];
      var newVariableValues = <List<int>>[];

      try {
        count = puzzle.getVariables(
          [clue],
          [exp],
          possibleValue,
          possibleVariables!,
          newVariables,
          newVariableValues,
          maxCount,
          variables,
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

        for (var newProduct in newVariableValues.isEmpty
            ? [<int>[]]
            : cartesian(newVariableValues)) {
          try {
            nextProduct = product + newProduct;
            for (var value in exp.generate(
              1,
              clue.max,
              nextVariables,
              nextProduct,
            )) {
              solveNextExpressionValue(value);
            }
          } on ExpressionInvalid {
            // Illegal values
          }
        }
        return updated;
      } else {
        possibleValue.clear();
        throw SolveException('Cannot compute ${clue.name}');
      }
    }

    var expValues = <int>[];
    updated = solveNextExpression(0, expValues, [], [], maxCount);

    return updated;
  }

  @override
  bool updateClues(ExcusesPuzzle thisPuzzle, Clue clue, Set<int> possibleValues,
      Set<Variable> updatedVariables,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    // If updating Clue values based on Entry, then skip the update as
    // the Clue values are for multiple entry expressions
    if (!isFocus && !isEntry) {
      return false;
    }
    var updated = super.updateClues(
        thisPuzzle, clue, possibleValues, updatedVariables,
        isFocus: isFocus, isEntry: isEntry);
    if (!isEntry && updated) {
      // Maintain clue difference order
      updateClueDiffs(updatedVariables);
    }
    return updated;
  }

  void updateClueDiffs(Set<Variable> updatedVariables) {
    var clueNames =
        List.generate(puzzle.clues.length, (index) => (index + 1).toString());
    var minDiff = 0;
    var wasLetter = '';
    for (var clueName in clueNames) {
      var clue = puzzle.clues[clueName]!;
      if (clue.isLetter != wasLetter) {
        minDiff++;
      }
      if (clue.diffs.isNotEmpty) {
        if (clue.diffs.reduce(min) > minDiff) {
          minDiff = clue.diffs.reduce(min);
        }
      }
      if (clue.minDiff < minDiff) {
        clue.minDiff = minDiff;
        updatedVariables.add(clue);
      } else {
        minDiff = clue.minDiff;
      }
      wasLetter = clue.isLetter!;
    }
    int? maxDiff;
    wasLetter = '';
    for (var clueName in clueNames.reversed) {
      var clue = puzzle.clues[clueName]!;
      if (clue.isLetter != wasLetter) {
        if (maxDiff == null) {
          maxDiff = 26;
        } else {
          maxDiff = maxDiff - 1;
        }
      }
      if (clue.diffs.isNotEmpty) {
        if (maxDiff == null || clue.diffs.reduce(max) < maxDiff) {
          maxDiff = clue.diffs.reduce(max);
        }
      }
      if (clue.maxDiff != null && maxDiff != null && clue.maxDiff! > maxDiff ||
          clue.maxDiff == null && maxDiff != null) {
        clue.maxDiff = maxDiff;
        updatedVariables.add(clue);
      } else if (clue.maxDiff != null &&
              maxDiff != null &&
              clue.maxDiff! < maxDiff ||
          clue.maxDiff != null && maxDiff == null) {
        maxDiff = clue.maxDiff;
      }
      wasLetter = clue.isLetter!;
    }
  }

  void initClues() {
    // Clues that correspond to letters set min and max Difference
    var clueNames =
        List.generate(puzzle.clues.length, (index) => (index + 1).toString());
    var exponents = <String>{};
    for (var clueName in clueNames) {
      var clue = puzzle.clues[clueName]!;
      exponents.add(clue.n!);
    }
    // Exponents are limited to 1..6, others to7..25
    for (var letter in puzzle.variables.keys) {
      if (exponents.contains(letter)) {
        // ignore: prefer_collection_literals
        puzzle.variables[letter]!.values = Set.from([1, 2, 3, 4, 5]);
      } else {
        puzzle.variables[letter]!.values!.removeAll([1, 2, 3, 4, 5]);
      }
    }
    var updatedVariables = <Variable>{};
    updateClueDiffs(updatedVariables);
  }

  void postProcessing() {
    var outer = [
      ['21', 'A10', '8', 'D1', '11', '14', 'D10', 'A30', '20', '28', '8'],
      ['0', 'D1'],
      ['0', '5'],
      ['D7', 'A7'],
      ['29', '22'],
      ['22', '32'],
      ['A1', '17'],
      ['9', 'A1'],
      ['23', 'D10'],
      ['24', 'D25'],
      ['5', '32', '20', '14', '21', '28', 'A7', '6', '29', 'D12', '18'],
    ];
    var text = <List<String>>[];
    for (var row in outer) {
      text.add([]);
      for (var col in row) {
        if (col != '0') {
          var entryName = col;
          if (!['A', 'D'].contains(col[0])) {
            // find entry name
            if (puzzle.entries.keys.contains('A$entryName')) {
              entryName = 'A$entryName';
            } else if (puzzle.entries.keys.contains('D$entryName')) {
              entryName = 'D$entryName';
            } else {
              print('Unknown entry $entryName');
              continue;
            }
          }
          // get clue name from entry name
          var clueName = puzzle.clues.values
              .firstWhere((element) => element.entry!.name == entryName)
              .name;
          var clue = puzzle.clues[clueName]!;
          if (clue.isLetter == 'Y') {
            var diff = clue.diffs.first;
            var letter = puzzle.variables.values
                .firstWhere((element) => element.value == diff);
            text.last.add(letter.name);
          }
        }
      }
    }
    print(text);
  }
}
