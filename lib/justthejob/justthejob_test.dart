import 'dart:io';

import 'package:basics/basics.dart';

import '../clue.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../undo.dart';
import '../variable.dart';
import 'justthejob.dart';

void main(List<String> args) {
  try {
    final pc = JustTheJobTest();
    pc.solve();
  } on PuzzleException catch (e) {
    print(e.msg);
  } on SolveException catch (e) {
    print(e.msg);
  } on SolveError catch (e) {
    print(e.msg);
  } catch (e) {
    print('Exception ${e.toString()}');
  }
}

late Map<String, Variable> variables;
var allClues = <String, VariableClue>{};
late List<Variable> variableOrder;
late List<String> clueOrder;

class JustTheJobTest extends JustTheJob {
  JustTheJobTest() : super();

  @override
  void solve([bool iteration = true]) {
    print('JustTheJobTest.solve');
    variables = puzzle.variables;
    allClues = puzzle.clues;
    getEvaluationOrder(puzzle);
    // Permitted variable values are two sets of puzzle variable values
    var duplicateLimit = puzzle.variablesList.getDuplicateLimit();
    var count = 0;
    var variableValues = <int>[];
    initProgress();
    backtrackPuzzle(
        count, puzzle, variableOrder, variableValues, 0, duplicateLimit);
  }

  void getEvaluationOrder(VariablePuzzle puzzle) {
    variableOrder = <Variable>[];
    clueOrder = <String>[];
    // Build variableOrder, iterating over clues in order of increasing variable count
    while (true) {
      // Count remaining variables for each clue
      var clueVariableCount = <String, int>{};
      for (var clue in puzzle.clues.values) {
        if (clue is ExpressionClue) {
          clueVariableCount[clue.name] = clue.exp.variableRefs
              .where((element) => !variableOrder.contains(element))
              .length;
          if (clueVariableCount[clue.name] == 0) {
            clueVariableCount.remove(clue.name);
          }
        }
      }
      if (clueVariableCount.isEmpty) break;

      // Get clues in order of increasing variable count
      var order = clueVariableCount.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      // Choose clue with lowest remaining variables, and maximum existing variables
      var numVariables = order.first.value;
      order.removeWhere((element) => element.value != numVariables);
      ExpressionClue? nextClue;
      for (var entry in order) {
        var clue = puzzle.clues[entry.key] as ExpressionClue;
        if (nextClue == null ||
            clue.variableReferences.length >
                nextClue.variableReferences.length) {
          nextClue = clue;
        }
      }
      // Add variables for next clue to variableOrder
      var nextVariables = nextClue!.exp.variableRefs
          .where((element) => !variableOrder.contains(element));
      variableOrder.addAll(nextVariables);

      // Add clues where all variables are in variableOrder to clueOrder
      var allVariablesClues = clueVariableCount.entries
          .where((element) => element.value == numVariables)
          .where((element) => puzzle.clues[element.key]!.variableReferences
              .all((p0) => variableOrder.contains(p0)))
          .map((e) => e.key);
      // Add clues with no variables to clueOrder
      clueOrder.addAll(allVariablesClues);
    }
    return;
    // Order the list according to desired execuion order
    // variableOrder = [
    //   variables['O']!,
    //   variables['C']!,
    //   variables['T']!,
    //   variables['N']!,
    //   variables['U']!,
    //   variables['H']!,
    //   variables['R']!,
    //   variables['D']!,
    //   variables['A']!,
    //   variables['P']!,
    //   variables['I']!,
    //   variables['M']!,
    //   variables['B']!,
    //   variables['E']!,
    //   variables['G']!,
    //   variables['S']!,
    //   variables['F']!,
    //   variables['V']!,
    //   variables['W']!,
    //   variables['L']!,
    // ];
    // clueOrder = [
    //   'A9',
    //   'D6',
    //   'D25',
    //   'D22',
    //   'A23',
    //   'A8',
    //   'A24',
    //   'A15',
    //   'D1',
    //   'D23',
    //   'A14',
    //   'D15',
    //   'A28',
    //   'D2',
    //   'A6',
    //   'A11',
    //   'D5',
    //   'D7',
    //   'D17',
    //   'A27',
    //   'D13',
    //   'D3',
    //   'D20',
    //   'A26',
    //   'A4',
    //   'D4',
    //   'A16',
    //   'A17',
    //   'A19',
    //   'A1',
    //   'D9',
    //   'D10',
    //   'A21',
    //   'A12',
    //   'D18',
    //   'A22',
    // ];
  }

  int backtrack(Map<String, VariablePuzzle> puzzles, List<String> names,
      int count, Map<int, int> duplicateLimit) {
    if (names.isEmpty) {
      var ok = false;
      ok = checkPuzzle(null, true);
      if (!ok) return count;
      // Solution
      count = puzzlesOK(count, puzzles);
      return count;
    }
    var name = names[0];
    var puzzle = puzzles[name]!;
    var variableValues = <int>[];
    count = backtrackPuzzle(count, puzzle, puzzle.variables.values.toList(),
        variableValues, 0, duplicateLimit);
    return count;
  }

  // Check puzzle variables
  int maxVariables = 0;
  int backtrackPuzzle(
      int count,
      VariablePuzzle puzzle,
      List<Variable> variables,
      List<int> variableValues,
      int index,
      Map<int, int> duplicateLimit) {
    if (index >= variables.length) {
      // Set variables, so backtrack over cells
      // Clues first
      if (!checkPuzzle(puzzle, true)) return count;

      // Check puzzle cells
      // addProgress(
      //     'puzzle variables${puzzle.variableNames.fold('', (v, e) => "$v $e=${variables[e]!.value}")}');
      // return backtrackPuzzleVariable(count, puzzle, 0, 0, duplicateLimit);

      // Solution
      count = puzzleOK(count, puzzle);
      return count;
    }

    // Try variable
    var variable = variables[index];
    var values = variable.values;
    if (values == null) return count;

    var variableValueTooHigh = false;
    for (var value in values) {
      if (duplicateLimit[value] == 0) continue; // Should not happen
      UndoStack.begin();
      pushProgress(value);
      variable.value = value;
      variableValues.add(value);
      duplicateLimit[value] = duplicateLimit[value]! - 1;

      // Disallow value for other variables
      if (duplicateLimit[value] == 0) {
        for (var i = index + 1; i < variables.length; i++) {
          var otherVariable = variables[i];
          if (otherVariable.values!.contains(value)) {
            otherVariable.values = Set.from(otherVariable.values!)
              ..remove(value);
          }
        }
      }

      // var variableText =
      //     variables.fold('', (v, e) => '$v${e.isSet ? '$e=${e.value} ' : ''}');
      // print(variableText);

      // Check variable value is valid - evaluate all expressions that depend on
      // the variables that have been set so far
      var ok = true;
      var clueIndex = 0;
      while (clueIndex < clueOrder.length) {
        var clueName = clueOrder[clueIndex];
        var clue = allClues[clueName]! as ExpressionClue;

        // Do we have all the required variables for this clue?
        if (!clue.exp.variableNameRefs.all((p0) =>
            variables.indexWhere((element) => element.name == p0) <= index)) {
          break;
        }

        // Clue not yet evaluated?
        if (!clue.isSet) {
          // print('Evaluate ${clue.name}');
          clue.initialise();
          // Evaluate the clue
          var clueValue = 0;
          try {
            ok = false;
            for (var value in clue.exp.generate(clue.min, clue.max,
                variableOrder, variableValues, clue.values)) {
              var valid = validClue(clue, value, [], []);
              if (valid) {
                if (!variableValues.contains(value)) {
                  clueValue = value;
                  ok = true;
                }
              } else {
                // If value is greater than max, and exp does not include '-' then can break out of variable value loop
                if (clue.max != null &&
                    value > clue.max! &&
                    !clue.expString.contains('-')) {
                  variableValueTooHigh = true;
                  break;
                }
              }
            }
          } on ExpressionInvalid {
            // Illegal values
          }
          if (!ok) break;
          clue.value = clueValue;
          clue.finalise();
        }

        clueIndex++;
      }

      if (ok) {
        // Log Maximum
        if (variableValues.length > maxVariables) {
          maxVariables = variableValues.length;
          addProgress('Max Variables $maxVariables');
        }
        // Continue with other variables
        count = backtrackPuzzle(count, puzzle, variables, variableValues,
            index + 1, duplicateLimit);
      }

      duplicateLimit[value] = duplicateLimit[value]! + 1;
      variableValues.removeLast();
      popProgress();
      UndoStack.undo(); // Undo variable value

      if (variableValueTooHigh) {
        break;
      }
    }

    return count;
  }

// Check puzzle digits
  int backtrackPuzzleVariable(int count, VariablePuzzle puzzle, int row,
      int col, Map<int, int> duplicateLimit) {
    var grid = puzzle.grid!;
    var numRows = grid.numRows;
    var numCols = grid.numCols;
    if (row == numRows) {
      // Check variable values puzzle occurrences
      // for (var variableName in puzzle.variableNames) {
      //   var value = variables[variableName]!.value;
      //   assert(value != 0);
      //   var occurrences = puzzleDigitCount[puzzle.name]![value - 1];
      //   if (occurrences != value) return count;
      // }
      // Clues
      if (!checkPuzzle(puzzle, false)) return count;
      // return backtrack(puzzles, names, count);
      return count;
    }

    // Try cell
    // var cell = puzzle.grid.rows[row][col];
    // Reverse order
    var cell = grid.rows[numRows - row - 1][numCols - col - 1];
    var digits = cell.digits;
    // var digitCount = puzzleDigitCount[puzzle.name]!;
    digitLoop:
    for (var digit in digits) {
      // Check variables
      // var digitOK = digitCount[digit - 1] >= digit;
      var digitOK = true;
      if (duplicateLimit[digit - 1] == 0 && digitOK) {
        continue digitLoop;
      }

      // checkProgress('${puzzle.name} $row $col $digit');

      UndoStack.begin();
      // digitCount[digit - 1]++;
      //cell.updateNewDigits({digit});
      cell.setDigit(digit);
      pushProgress(digit);

      // Continue with next cell
      var newRow = row;
      var newCol = col + 1;
      if (newCol == numCols) {
        newRow++;
        newCol = 0;
      }
      count = backtrackPuzzleVariable(
          count, puzzle, newRow, newCol, duplicateLimit);

      // digitCount[digit - 1]--;
      popProgress();
      UndoStack.undo();
    }

    return count;
  }

//------------ Check

  bool checkPuzzle(Puzzle? puzzle, bool isPreCheck) {
    var ok = true;
    if (puzzle == null) {
      // Post-check
      // if (ok) ok = checkClue(puzzle, 'TA6', "multiple A");
    } else {
      // if (ok) ok = checkClue(puzzle, 'TA7', "square");
    }
    return ok;
  }

  bool checkClue(Puzzle? puzzle, String clueName, String expression) {
    var ok = true;
    // var clue = allClues[clueName]!;
    // var value = clue.getValueFromDigits();
    // assert(value != 0);
    // var a = variables['A']!.value;
    // switch (clueName) {
    //   case 'RD2':
    //"multiple (X + Z)"
    // var xz = x + z;
    // var root = value / xz;
    // ok = root == root.toInt();
    //     break;
    // }
    return ok;
  }

//------------ Print

  int puzzlesOK(
      int count, Map<String, VariablePuzzle<Clue, Clue, Variable>> puzzles) {
    count++;
    printPuzzles(puzzles, 'Solution $count');
    return count;
  }

  int puzzleOK(int count, VariablePuzzle<Clue, Clue, Variable> puzzle) {
    count++;
    printPuzzle(puzzle, 'Solution $count');
    return count;
  }

  void printPuzzles(Map<String, VariablePuzzle> puzzles, String heading) {
    print(heading);
    for (var variable in variables.values) {
      print('${variable.name}=${variable.values}');
    }
    for (var name in ['Top', 'Front', 'Right']) {
      var puzzle = puzzles[name]!;
      print(puzzle.toSummary());
    }
  }

  void printPuzzle(VariablePuzzle puzzle, String heading) {
    print(heading);
    print(puzzle.toSummary());
  }
}

//------------ Progress

bool trace = true;
bool timed = true;
Stopwatch? stopwatch;
var progress = '';
var characters = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

void initProgress() {
  if (!trace) return;
  stopwatch = Stopwatch()..start();
}

pushProgress(int value) {
  if (!trace) return;
  var char = characters[value];
  progress += char;
  if (timed) {
    checkProgress(progress);
  } else {
    stdout.write(char);
  }
}

popProgress() {
  if (!trace) return;
  progress = progress.substring(0, progress.length - 1);
  const ansiCursorLeft = '\x1b[D';
  const ansiEraseCursorToEnd = '\x1b[K';
  if (timed) {
    checkProgress(progress);
  } else {
    stdout.write(ansiCursorLeft);
    stdout.write(ansiEraseCursorToEnd);
  }
}

addProgress(String msg) {
  if (!trace) return;
  if (timed) {
    checkProgress(msg, true);
  } else {
    stdout.write(' ');
    stdout.writeln(msg);
  }
  stdout.writeln(progress);
}

int totalSeconds = 0;
void checkProgress(String msg, [bool force = false]) {
  var seconds = stopwatch!.elapsed.inSeconds;
  if (seconds >= 10) {
    totalSeconds += seconds;
    var progressMsg = '${totalSeconds.toString().padLeft(5, '0')}: $msg';
    stdout.writeln(progressMsg);
    stopwatch!.reset();
  } else if (force) {
    var progressMsg = '${totalSeconds.toString().padLeft(5, '0')}: $msg';
    stdout.writeln(progressMsg);
  }
}
