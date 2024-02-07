/// An API for solving Cross Number puzzles.
library crossnumber;

import 'package:collection/collection.dart' show PriorityQueue;
import 'package:powers/powers.dart';

import 'clue.dart';
import 'generators.dart';
import 'puzzle.dart';
import 'set.dart';
import 'variable.dart';

/// Provide access to the Cross Number API.
class Crossnumber<PuzzleKind extends Puzzle<Clue, Clue>> {
  final puzzles = <PuzzleKind>[];
  PuzzleKind get puzzle {
    assert(puzzles.length == 1);
    return puzzles[0];
  }

  void set puzzle(PuzzleKind puzzle) {
    assert(puzzles.length == 0);
    puzzles.add(puzzle);
  }

  final puzzleForVariable = <Variable, PuzzleKind>{};

  static bool traceInit = true;
  static bool traceSolve = true;

  Crossnumber();

  void initCrossnumber() {
    if (traceInit) {
      for (var puzzle in puzzles) {
        print(puzzle.toString());
      }
    }

    // Get puzzle to clue/variable mapping
    for (var puzzle in puzzles) {
      if (puzzle is VariablePuzzle) {
        for (var variable in puzzle.variables.values) {
          puzzleForVariable[variable] = puzzle;
        }
      }
      for (var clue in puzzle.clues.values) {
        puzzleForVariable[clue] = puzzle;
      }
      for (var entry in puzzle.entries.values) {
        puzzleForVariable[entry] = puzzle;
      }
    }
  }

  var updateQueue = <Variable>[];
  var priorityQueue = PriorityQueue<Variable>((a, b) => -(b as PriorityVariable)
      .priority
      .compareTo((a as PriorityVariable).priority));

  void addToUpdateQueue(Variable clue) {
    var puzzle = puzzleForVariable[clue]!;
    if ((puzzle is VariablePuzzle) &&
        puzzle.hasVariables &&
        (clue is VariableClue || clue is ExpressionVariable)) {
      if (clue is VariableClue) puzzle.updateCluePriority(clue);
      if (clue is ExpressionVariable) puzzle.updateVariablePriority(clue);

      if (priorityQueue.contains(clue)) {
        priorityQueue.remove(clue);
      }
      //print('addToUpdateQueue(${clue.name}), count=${clue.count}');
      priorityQueue.add(clue);
    } else {
      if (!updateQueue.contains(clue)) {
        updateQueue.add(clue);
      }
    }
  }

  Variable takeFromUpdateQueue() {
    if (priorityQueue.isNotEmpty) {
      var clue = priorityQueue.removeFirst();
      //print('takeFromUpdateQueue()=${clue.name}), count=${clue.count}');
      return clue;
    } else {
      return updateQueue.removeAt(0);
    }
  }

  bool updateQueueIsNotEmpty() {
    return priorityQueue.isNotEmpty || updateQueue.isNotEmpty;
  }

  void solve([bool iteration = true]) {
    bool updated;
    var iterations = 0;
    var updates = 0;
    var remainingClues = <Variable>[];
    for (var puzzle in puzzles) {
      remainingClues.addAll(puzzle.clues.values);
      remainingClues.addAll(puzzle.entries.values);
      if (puzzle is VariablePuzzle) {
        remainingClues.addAll(puzzle.variables.values
            .where((v) => (v is ExpressionVariable) && v.valueDesc != ''));
      }
    }

    if (traceSolve) {
      print("UPDATES-----------------------------");
    }

    final stopwatch = Stopwatch()..start();
    Variable? firstExceptionClue;
    bool skipExceptionClues = false;
    Variable? previousClue;
    var exceptionClues = <Variable>[];
    while (remainingClues.isNotEmpty) {
      remainingClues.forEach((clue) {
        if (clue != previousClue) addToUpdateQueue(clue);
      });
      remainingClues.clear();
      exceptionClues.forEach((clue) {
        if (clue != previousClue) addToUpdateQueue(clue);
      });
      exceptionClues.clear();

      while (updateQueueIsNotEmpty()) {
        Variable clueOrVariable = takeFromUpdateQueue();
        if (clueOrVariable == previousClue) {
          remainingClues.add(clueOrVariable);
          continue;
        }
        previousClue = clueOrVariable;

        iterations++;
        try {
          var referrers = <Variable>[];
          if (clueOrVariable is Clue) {
            updated = solveClue(clueOrVariable);
            referrers.addAll(clueOrVariable.referrers);
            // Add variables that clue uses
            // if (puzzle is VariablePuzzle) {
            //   for (var variableName in clueOrVariable.variableReferences) {
            //     var variable =
            //         (puzzle as VariablePuzzle).variables[variableName]!;
            //     if (variable is ExpressionVariable) referrers.add(variable);
            //   }
            // }
          } else {
            updated = solveVariable(clueOrVariable as ExpressionVariable);
            referrers = clueOrVariable.referrers;
          }
          if (updated) {
            for (var referrer in referrers) {
              addToUpdateQueue(referrer);
            }
            if (clueOrVariable.isSet) {
              // Find other clues/variables that can no longer have the value
              var puzzle = puzzleForVariable[clueOrVariable]!;
              for (var referrer
                  in puzzle.clueOrVariableValueReferences(clueOrVariable)) {
                addToUpdateQueue(referrer);
              }
            }
            updates++;
            firstExceptionClue = null;
            skipExceptionClues = false;
          }
        } on SolveException {
          // Put clue back at end of queue until no update since this clue
          if (firstExceptionClue == clueOrVariable) {
            skipExceptionClues = true;
          } else {
            if (!skipExceptionClues) {
              addToUpdateQueue(clueOrVariable);
              if (firstExceptionClue == null) {
                firstExceptionClue = clueOrVariable;
              }
            } else {
              exceptionClues.add(clueOrVariable);
            }
          }
        }
      }
    }
    if (traceSolve) {
      print(
          'Clue/Variable iterations=$iterations, updates=$updates, elapsed ${stopwatch.elapsed}');
    }

    // Unique solution?
    endSolve(iteration);
  }

  void endSolve(bool iteration) {
    // Unique solution?
    for (var puzzle in puzzles) {
      if (!puzzle.uniqueSolution()) {
        if (Crossnumber.traceSolve) {
          print("PARTIAL SOLUTION-----------------------------");
          print(puzzle.toSummary());
          // print(puzzle.toString());
        }
      } else {
        print("SOLUTION-----------------------------");
        print(puzzle.toSummary());
      }
    }
    for (var puzzle in puzzles) {
      if (!puzzle.uniqueSolution()) {
        puzzle.postProcessing(iteration);
      }
    }
  }

  bool solveClue(Clue clue) {
    var puzzle = puzzleForVariable[clue]!;

    // If clue solved already then skip it
    // Can no longer do this because clue can be set by other clues
    // if (clue.values != null && clue.values!.length == 1) return false;

    var updated = false;
    if (clue.initialise()) updated = true;

    var updatedVariables = <String>{};
    var updatedClues = <String>{};
    var updatedEntries = <String>{};
    if (clue.solve != null) {
      var possibleValue = <int>{};
      var possibleVariables = <String, Set<int>>{};
      if (clue is VariableClue) {
        for (var variableName in clue.variableClueReferences) {
          possibleVariables[variableName] = <int>{};
        }
        if (clue.solve!(
          puzzle,
          clue,
          possibleValue,
          possibleVariables: possibleVariables,
        )) updated = true;
      } else {
        if (clue.solve!(puzzle, clue, possibleValue)) updated = true;
      }
      // If no Values returned then Solve function could not solve
      if (possibleValue.isEmpty) {
        print(
            'Solve Error: clue ${clue.name} (${clue.valueDesc}) no solution!');
        throw SolveException();
      }
      if (updateClueEntries(puzzle, clue.name, possibleValue)) updated = true;
      if (clue.finalise()) updated = true;
      if (clue is VariableClue) {
        for (var variableName in clue.variableReferences) {
          if (possibleVariables[variableName] != null &&
              possibleVariables[variableName]!.isNotEmpty) {
            if (updateVariables(
                puzzle,
                variableName,
                possibleVariables[variableName]!,
                updatedVariables)) updated = true;
          }
        }
        for (var clueName in clue.clueReferences) {
          if (possibleVariables[clueName] != null &&
              possibleVariables[clueName]!.isNotEmpty) {
            if (updateClues(puzzle, clueName, possibleVariables[clueName]!,
                isFocus: false, focusClueName: clue.name)) {
              updatedClues.add(clueName);
              updated = true;
            }
          }
        }
        for (var entryName in clue.entryReferences) {
          if (possibleVariables[entryName] != null &&
              possibleVariables[entryName]!.isNotEmpty) {
            if (updateEntries(puzzle, entryName, possibleVariables[entryName]!,
                isFocus: false, focusClueName: clue.name)) {
              updatedEntries.add(entryName);
              updated = true;
            }
          }
        }
      }
    } else {
      // No solve function, but may have been updated elsewhere
      // Check digits match
      var values = clue.values;
      if (values != null) {
        var possibleValue = <int>{};
        for (var value in values) {
          if (clue.digitsMatch(value)) possibleValue.add(value);
        }
        // Do not update puzzle known values - need to clean this up
        if (clue.updateValues(possibleValue)) updated = true;
        if (clue.finalise()) updated = true;
      }
    }

    if (traceSolve && updated) {
      print("solve${puzzle.name}: ${clue.toString()}");
      if (clue is VariableClue) {
        var variableList = (puzzle as VariablePuzzle).variableList;
        for (var variableName in updatedVariables) {
          print(
              '$variableName=${variableList.variables[variableName]!.values!.toShortString()}');
        }
        for (var clueName in updatedClues) {
          var puzzle2 =
              clueName == clue.name ? puzzle : puzzle.cluePuzzle(clue.name);
          print(
              '$clueName=${puzzle2.clues[clueName]!.values!.toShortString()}');
        }
        for (var entryName in updatedEntries) {
          var puzzle2 =
              entryName == clue.name ? puzzle : puzzle.cluePuzzle(clue.name);
          print(
              '$entryName=${puzzle2.entries[entryName]!.values!.toShortString()}');
        }
      }
    }
    return updated;
  }

  bool updateVariables(PuzzleKind puzzle, String variableName,
      Set<int> possibleValues, Set<String> updatedVariables) {
    if (puzzle is VariablePuzzle) {
      updatedVariables
          .addAll(puzzle.updateVariables(variableName, possibleValues));
      // Schedule updated variables for update
      // for (var variableName in updatedVariables) {
      //   var variable = variablePuzzle.variables[variableName]!;
      //   addToUpdateQueue(variable);
      // }
      // Schedule referencing clues for update
      for (var clue in puzzle.clues.values) {
        if (clue is VariableClue) {
          if (clue.variableReferences
              .any((element) => updatedVariables.contains(element))) {
            addToUpdateQueue(clue);
          }
        }
      }
      // Schedule referencing variables for update
      for (var variable in puzzle.variables.values) {
        if (variable is ExpressionVariable) {
          if (variable.variableReferences
              .any((element) => updatedVariables.contains(element))) {
            addToUpdateQueue(variable);
          }
        }
      }
      return updatedVariables.length > 0;
    }
    return false;
  }

  bool updateClueEntries(
      PuzzleKind puzzle, String clueName, Set<int> possibleValues) {
    if (puzzle.clues.containsKey(clueName))
      return updateClues(puzzle, clueName, possibleValues);
    if (puzzle.entries.containsKey(clueName))
      return updateClues(puzzle, clueName, possibleValues, isEntry: true);
    throw SolveError('Clue/Entry $clueName not found!');
  }

  bool updateClues(
      PuzzleKind thisPuzzle, String clueName, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, String? focusClueName}) {
    Puzzle puzzle = thisPuzzle;
    if (!isFocus && thisPuzzle.otherPuzzleClues.containsKey(focusClueName)) {
      puzzle = thisPuzzle.otherPuzzleClues[focusClueName]!;
    }
    var clue = isEntry ? puzzle.entries[clueName]! : puzzle.clues[clueName]!;
    var updated = puzzle.updateValues(clue, possibleValues);
    if (updated) {
      // Schedule clue for update (to check digits)
      if (!isEntry) addToUpdateQueue(clue);
      // Schedule referencing clues for update
      for (var referrer in clue.referrers) {
        addToUpdateQueue(referrer);
      }
      // Schedule referenced variables for update
      if (puzzle is VariablePuzzle) {
        for (var variableName in clue.variableReferences) {
          var variable = puzzle.variables[variableName]!;
          if (variable is ExpressionVariable) {
            addToUpdateQueue(variable);
          }
        }
        return true;
      }
    }
    return false;
  }

  bool updateEntries(
      PuzzleKind puzzle, String entryName, Set<int> possibleValues,
      {bool isFocus = true, String? focusClueName}) {
    return updateClues(puzzle, entryName, possibleValues,
        isEntry: true, isFocus: isFocus, focusClueName: focusClueName);
  }

  bool validVariable(ExpressionVariable variable, int value,
      List<String> variableReferences, List<int> variableValues) {
    // if no values so far, then all valid
    if (variable.values == null) return true;
    return variable.values!.contains(value);
  }

  bool solveVariable(ExpressionVariable variable) {
    // If variable solved already then skip it
    // Can no longer do this because variable can be set by other clues/variable
    // if (variable.values != null && variable.values!.length == 1) return false;

    var updated = false;
    var puzzle = puzzleForVariable[variable]!;
    var varPuzzle = puzzle as VariablePuzzle;
    var possibleValue = <int>{};
    var possibleVariables = <String, Set<int>>{};

    for (var variable in variable.variableReferences) {
      possibleVariables[variable] = <int>{};
    }

    if (variable.solve!(
      puzzle,
      variable,
      possibleValue,
      possibleVariables: possibleVariables,
    )) updated = true;
    // If no Values returned then Solve function could not solve
    if (possibleValue.isEmpty) {
      throw SolveException(
          'Solve Error: variable ${variable.name} (${variable.valueDesc}) no solution!');
    }
    var updatedVariables = <String>{};
    if (updateVariables(
        puzzle, variable.name, possibleValue, updatedVariables)) {
      updated = true;
    }
    // Update variable references even if this variable not updated, because may
    // have been set elsewhere
    for (var variableName in variable.variableReferences) {
      if (updateVariables(puzzle, variableName,
          possibleVariables[variableName]!, updatedVariables)) {
        updated = true;
      }
    }

    if (traceSolve && updated) {
      print("solve: ${variable.runtimeType}(${variable.toString()})");
      var variableList = varPuzzle.variableList;
      for (var variableName in updatedVariables) {
        print(
            '$variableName=${variableList.variables[variableName]!.values.toString()}');
      }
    }

    return updated;
  }
}

List<int>? getDigitProductEqualsOtherClue(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>{};
    for (var value in other.values!) {
      for (var factor = 2; factor <= value.sqrt().floor(); factor++) {
        if (value % factor == 0) {
          var factor2 = value ~/ factor;
          if (factor2 < 10) {
            values.add(factor * 10 + factor2);
            values.add(factor2 * 10 + factor);
          }
        }
      }
    }
    return List.from(values);
  }
  return null;
}

List<int>? getFactorsOfOtherClue(Clue clue, Clue other) {
  if (other.values != null && clue.length != null) {
    var values = <int>{};
    int loLimit = clue.min!;
    if (loLimit < 2) loLimit = 2;
    int hiLimit = clue.max!;
    for (var value in other.values!) {
      int lo = loLimit;
      int hi = value ~/ 2;
      if (hi > hiLimit) hi = hiLimit;
      for (var factor = lo; factor <= hi; factor++) {
        if (value % factor == 0) {
          values.add(factor);
        }
      }
    }
    return List.from(values);
  }
  return null;
}

List<int>? getReverseOfOtherClue(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>[];
    for (var value in other.values!) {
      var reverse = 0;
      while (value > 0) {
        reverse = reverse * 10 + value % 10;
        // First digit cannot be 0
        if (reverse == 0) break;
        value = value ~/ 10;
      }
      if (reverse != 0) {
        values.add(reverse);
      }
    }
    return values;
  }
  return null;
}

List<int>? getDigitProductOtherClue(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>{};
    for (var value in other.values!) {
      var product = 1;
      while (value > 0) {
        product *= value % 10;
        value = value ~/ 10;
      }
      values.add(product);
    }
    return List.from(values);
  }
  return null;
}

List<int>? getMultipleOfOtherClue(Clue clue, Clue other) {
  if (other.values != null && clue.length != null) {
    var values = <int>[];
    for (var value in other.values!) {
      var hi = (clue.max!) ~/ value;
      for (var i = 2; i <= hi; i++) {
        var multiple = i * value;
        values.add(multiple);
      }
    }
    return values;
  }
  return null;
}

List<int>? getDigitProductEqualsOtherClueProduct(Clue clue, Clue other) {
  if (other.values != null) {
    var values = <int>{};
    for (var value in other.values!) {
      var product = 1;
      while (value > 0) {
        product *= value % 10;
        value = value ~/ 10;
      }
      for (var factor = 1; factor <= product.sqrt().floor(); factor++) {
        if (factor < 10 && product % factor == 0) {
          for (var factor2 = 1; factor2 <= product.sqrt().floor(); factor2++) {
            var prod2 = factor * factor2;
            if (factor2 < 10 && product % prod2 == 0) {
              var factor3 = product ~/ prod2;
              if (factor3 < 10) {
                values.add(factor * 100 + factor2 * 10 + factor3);
                values.add(factor * 100 + factor3 * 10 + factor2);
                values.add(factor2 * 100 + factor * 10 + factor3);
                values.add(factor2 * 100 + factor3 * 10 + factor);
                values.add(factor3 * 100 + factor2 * 10 + factor);
                values.add(factor3 * 100 + factor * 10 + factor2);
              }
            }
          }
        }
      }
    }
    return List.from(values);
  }
  return null;
}

int sumClueDigits(Clue clue, List<Clue> otherClues, List<int> otherValues) {
  var sum = 0;
  // Sum all otherClues that do not intersect with Clue
  // Do not double count digits that appear in Across and Down clues
  var index = 0;
  for (var otherClue in otherClues) {
    var value = otherValues[index].toString();
    // Sum all digits of Across clues
    for (var d = 0; d < otherClue.entry!.length!; d++) {
      var digit = int.parse(value[d]);
      // Exclude digits that intersect with the Clue
      if (otherClue.digitIdentities[d] != null) {
        if (otherClue.digitIdentities[d]!.clue == clue) digit = 0;
      }
      // Exclude digits of Down clues that intersect with Across clues
      if (otherClue.name[0] == 'D') {
        if (otherClue.digitIdentities[d] != null) digit = 0;
      }
      sum += digit;
    }
    index++;
  }
  return sum;
}

Set<int>? getValuesFromClueDigits(Clue clue) {
  return clue.getValuesFromDigits();
}

List<int>? getMultiplesOfValues(Clue clue, List<int> values) {
  var multiples = <int>[];
  if (clue.length != null) {
    var loResult = clue.min!;
    var hiResult = clue.max!;
    for (var value in values) {
      var loMultiplier = loResult ~/ value;
      if (loMultiplier < 2) loMultiplier = 2;
      var hiMultiplier = hiResult ~/ value;
      for (var multiplier = loMultiplier;
          multiplier <= hiMultiplier;
          multiplier++) {
        var multiple = multiplier * value;
        if (multiple < loResult) continue;
        if (multiple > hiResult) continue;
        multiples.add(multiple);
      }
    }
  }
  return multiples;
}

List<int>? getTriangularsLessValues(Clue clue, Set<int> values) {
  var result = <int>{};
  if (clue.length == null) return [];
  var minInput =
      values.reduce((value, element) => element < value ? element : value);
  var maxInput =
      values.reduce((value, element) => element > value ? element : value);
  var lo = clue.min!;
  var hi = clue.max!;
  var minTriangle = lo + minInput;
  var maxTriangle = hi + maxInput;
  var triangles = generateTriangles(minTriangle, maxTriangle).toList();
  for (var value in values) {
    for (var triangle in triangles) {
      var difference = triangle - value;
      if (difference < lo) continue;
      if (difference > hi) continue;
      result.add(difference);
    }
  }
  return List.from(result);
}

int romanToDecimal(String str) {
  int value(String r) {
    if (r == 'I') return 1;
    if (r == 'V') return 5;
    if (r == 'X') return 10;
    if (r == 'L') return 50;
    if (r == 'C') return 100;
    if (r == 'D') return 500;
    if (r == 'M') return 1000;
    return -1;
  }

  int res = 0;
  for (int i = 0; i < str.length; i++) {
    int s1 = value(str[i]);
    if (i + 1 < str.length) {
      int s2 = value(str[i + 1]);
      if (s1 >= s2) {
        res = res + s1;
      } else {
        res = res + s2 - s1;
        i++;
      }
    } else {
      res = res + s1;
    }
  }
  return res;
}
