/// An API for solving Cross Number puzzles.
library crossnumber;

import 'package:collection/collection.dart' show PriorityQueue;
import 'package:powers/powers.dart';

import 'cartesian.dart';
import 'clue.dart';
import 'expression.dart';
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

  set puzzle(PuzzleKind puzzle) {
    assert(puzzles.isEmpty);
    puzzles.add(puzzle);
  }

  final puzzleForVariable = <Variable, PuzzleKind>{};

  static bool traceInit = true;
  static bool traceSolve = true;
  static bool traceQueue = false;

  Crossnumber();

  void initCrossnumber() {
    // Get puzzle to clue/variable mapping
    for (var puzzle in puzzles) {
      // Puzzles must have been finalized
      if (!puzzle.finalized) {
        throw PuzzleException('Puzzle not finalized, call fnalize()');
      }
      for (var variableEntry in puzzle.allVariables.entries) {
        var v = variableEntry.value;
        puzzleForVariable[v] = puzzle;
      }
    }

    if (traceInit) {
      for (var puzzle in puzzles) {
        print(puzzle.toString());
      }
    }
  }

  var updateQueue = <Variable>[];
  var priorityQueue = PriorityQueue<Variable>((a, b) => b.priorityCompareTo(a));

  void addToUpdateQueue(Variable clue) {
    var puzzle = puzzleForVariable[clue];
    if ((puzzle is VariablePuzzle) &&
        // (clue is VariableClue || clue is ExpressionVariable) &&
        puzzle.hasVariables) {
      puzzle.updatePriority(clue);
      if (priorityQueue.contains(clue)) {
        priorityQueue.remove(clue);
      }
      priorityQueue.add(clue);
      if (traceQueue) {
        print('addToUpdateQueue(${clue.name}), count=${clue.count}');
      }
    } else {
      if (!updateQueue.contains(clue)) {
        updateQueue.add(clue);
        if (traceQueue) print('addToUpdateQueue(${clue.name})');
      }
    }
  }

  Variable takeFromUpdateQueue() {
    if (priorityQueue.isNotEmpty) {
      var clue = priorityQueue.removeFirst();
      if (traceQueue) {
        print('takeFromUpdateQueue()=${clue.name}), count=${clue.count}');
      }
      return clue;
    } else {
      var clue = updateQueue.removeAt(0);
      if (traceQueue) print('takeFromUpdateQueue()=${clue.name})');
      return clue;
    }
  }

  bool updateQueueIsNotEmpty() {
    return priorityQueue.isNotEmpty || updateQueue.isNotEmpty;
  }

  void solve([bool iteration = true]) {
    var updatedVariables = <Variable>{};
    var iterations = 0;
    var updates = 0;
    var remainingVariables = <Variable>[];
    for (var puzzle in puzzles) {
      for (var variableEntry in puzzle.allVariables.entries) {
        var v = variableEntry.value;
        if (variableEntry.key.$1 != VariableType.V ||
            (v is ExpressionVariable) && v.valueDesc != '') {
          remainingVariables.add(v);
        }
      }
    }

    if (traceSolve) {
      print("UPDATES-----------------------------");
    }

    final stopwatch = Stopwatch()..start();
    Variable? firstExceptionVariable;
    bool skipExceptionVariables = false;
    Variable? previousVariable;
    var exceptionVariables = <Variable>[];
    while (remainingVariables.isNotEmpty) {
      for (var variable in remainingVariables) {
        if (variable != previousVariable) addToUpdateQueue(variable);
      }
      remainingVariables.clear();
      for (var variable in exceptionVariables) {
        if (variable != previousVariable) addToUpdateQueue(variable);
      }
      exceptionVariables.clear();

      while (updateQueueIsNotEmpty()) {
        Variable clueOrVariable = takeFromUpdateQueue();
        if (clueOrVariable == previousVariable) {
          remainingVariables.add(clueOrVariable);
          continue;
        }
        previousVariable = clueOrVariable;

        iterations++;
        try {
          updatedVariables = solveClue(clueOrVariable);
          for (var updatedVariable in updatedVariables) {
            for (var referrer in updatedVariable.referrers) {
              addToUpdateQueue(referrer);
            }
            if (updatedVariable.isSet) {
              // Find other clues/variables that can no longer have the value
              var puzzle = puzzleForVariable[updatedVariable]!;
              for (var referrer
                  in puzzle.clueOrVariableValueReferences(updatedVariable)) {
                addToUpdateQueue(referrer);
              }
            }
            updates++;
            firstExceptionVariable = null;
            skipExceptionVariables = false;
          }
        } on SolveException {
          // Put clue back at end of queue until no update since this clue
          if (firstExceptionVariable == clueOrVariable) {
            skipExceptionVariables = true;
          } else {
            if (!skipExceptionVariables) {
              addToUpdateQueue(clueOrVariable);
              firstExceptionVariable ??= clueOrVariable;
            } else {
              exceptionVariables.add(clueOrVariable);
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

  var iterating = false;

  late List<Puzzle> unfinishedPuzzles;
  void endSolve(bool iteration) {
    iterating = true;
    // In case solve/endSolve are called more than once
    unfinishedPuzzles = <Puzzle>[];
    // Unique solution?
    for (var puzzle in puzzles) {
      if (!puzzle.uniqueSolution()) {
        unfinishedPuzzles.add(puzzle);
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
    if (unfinishedPuzzles.isNotEmpty) {
      unfinishedPuzzles = puzzles;
      unfinishedPuzzles.first.postProcessing(iteration, callback);
    }
  }

  int callback(Puzzle puzzle) {
    // Puzzle has found a valid solution, check futher puzzles
    var index = unfinishedPuzzles.indexOf(puzzle);
    if (index + 1 == unfinishedPuzzles.length) {
      // Finished!
      print("SOLUTION-----------------------------");
      for (var puzzle in puzzles) {
        if (puzzle.uniqueSolution()) {
          print(puzzle.toSummary());
        }
      }
      return 1;
    }

    return unfinishedPuzzles[index + 1].iterate(callback);
  }

  Set<Variable> solveClue(Variable variable) {
    var puzzle = puzzleForVariable[variable]!;

    // If clue solved already then skip it
    // Can no longer do this because clue can be set by other clues
    // if (clue.values != null && clue.values!.length == 1) return false;

    var updated = false;
    if (variable is Clue && variable.initialise()) updated = true;

    var updatedVariables = <Variable>{};
    var updatedClues = <Variable>{};
    var updatedEntries = <Variable>{};
    var updatedAllVariables = <Variable>[];
    if (variable.solve != null) {
      var possibleValue = <int>{};
      var possibleVariables = <Variable, Set<int>>{};
      // if (clue is VariableClue) {
      for (var variableRef in variable.variableClueReferences) {
        possibleVariables[variableRef] = <int>{};
        if (variableRef is Clue && variableRef.initialise()) updated = true;
      }
      if (variable.solve!(
        puzzle,
        variable,
        possibleValue,
        possibleVariables: possibleVariables,
      )) updated = true;
      // } else {
      //   if (clue.solve!(puzzle, clue, possibleValue)) updated = true;
      // }
      // If no Values returned then Solve function could not solve
      if (possibleValue.isEmpty) {
        if (variable is Clue) {
          print(
              'Solve Error: clue ${variable.name} (${variable.valueDesc}) no solution!');

          throw SolveException();
        } else {
          if (variable is Expression) {
            throw SolveException(
                'Solve Error: variable ${variable.name} (${(variable as Expression).expString}) no solution!');
          }
        }
      }
      if (variable is Clue) {
        if (updateClueEntries(puzzle, variable, possibleValue)) updated = true;
      } else {
        if (updateVariables(
            puzzle, variable.name, possibleValue, updatedVariables)) {
          updateAllVariables(updatedVariables, updatedAllVariables);
          updated = true;
        }
        // Update variable references even if this variable not updated, because may
        // have been set elsewhere
        for (var variableRef in variable.variableReferences) {
          if (updateVariables(puzzle, variableRef.name,
              possibleVariables[variableRef]!, updatedVariables)) {
            updateAllVariables(updatedVariables, updatedAllVariables);
            updated = true;
          }
        }
      }
      if (variable is VariableClue) {
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
                    possibleVariables[variableRef]!,
                    isFocus: false, focusClue: variable)) {
              updatedAllVariables.add(variableRef);
              updatedClues.add(variableRef);
              updated = true;
            }
            if (variableRef.variableType == VariableType.E &&
                updateEntries(puzzle, variableRef as Clue,
                    possibleVariables[variableRef]!,
                    isFocus: false, focusClue: variable)) {
              updatedAllVariables.add(variableRef);
              updatedEntries.add(variableRef);
              updated = true;
            }
          }
        }
      }
      if (variable is Clue && variable.finalise()) updated = true;
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

    if (traceSolve && updated) {
      print("solve${puzzle.name}: ${variable.toString()}");
      for (var updateVariable in updatedAllVariables) {
        print(
            '${updateVariable.variableType} ${updateVariable.name}=${updateVariable.values!.toShortString()}');
      }
    }

    // Return all updated variables
    if (!updated) return {};
    var allUpdatedVariables = {variable};
    allUpdatedVariables.addAll(updatedAllVariables);

    return allUpdatedVariables;
  }

  bool updateVariables(PuzzleKind puzzle, String variableName,
      Set<int> possibleValues, Set<Variable> updatedVariables) {
    if (puzzle is VariablePuzzle) {
      updatedVariables
          .addAll(puzzle.updateVariables(variableName, possibleValues));
      if (updatedVariables.isEmpty) return false;

      // Schedule updated variables for update
      // for (var variableName in updatedVariables) {
      //   var variable = variablePuzzle.variables[variableName]!;
      //   addToUpdateQueue(variable);
      // }
      // Schedule referencing clues for update
      for (var e in puzzle.allVariables.entries) {
        // var type = e.key.$1;
        // var name = e.key.$2;
        var variable = e.value;
        if (variable.variableReferences
            .any((element) => updatedVariables.contains(element))) {
          addToUpdateQueue(variable);
        }
      }
      return updatedVariables.isNotEmpty;
    }
    return false;
  }

  bool updateClueEntries(
      PuzzleKind puzzle, Clue clue, Set<int> possibleValues) {
    var key = (clue.variableType, clue.name);
    if (!puzzle.allVariables.containsKey(key)) {
      throw SolveError('Clue/Entry ${clue.name} not found!');
    }

    return updateClues(puzzle, clue, possibleValues,
        isEntry:
            clue.variableType == VariableType.E && puzzle.entries.isNotEmpty);
  }

  bool updateClues(PuzzleKind thisPuzzle, Clue clue, Set<int> possibleValues,
      {bool isFocus = true, bool isEntry = false, Clue? focusClue}) {
    Puzzle puzzle = thisPuzzle;
    if (!isFocus &&
        focusClue != null &&
        thisPuzzle.otherPuzzleClues.containsKey(focusClue.name)) {
      puzzle = thisPuzzle.otherPuzzleClues[focusClue.name]!;
    }
    var updatedVariables = puzzle.updateVariableValues(clue, possibleValues);
    if (updatedVariables.isNotEmpty) {
      // Schedule clue for update (to check digits)
      // if (!isEntry || clue.entry == null)
      for (var clue in updatedVariables) {
        addToUpdateQueue(clue);
      }
      // Schedule referencing clues for update
      for (var referrer in clue.referrers) {
        addToUpdateQueue(referrer);
      }
      // Schedule referenced variables for update
      if (puzzle is VariablePuzzle) {
        for (var variable in clue.variableReferences) {
          if (variable is ExpressionVariable) {
            addToUpdateQueue(variable);
          }
        }
        return true;
      }
    }
    return false;
  }

  bool updateEntries(PuzzleKind puzzle, Clue entry, Set<int> possibleValues,
      {bool isFocus = true, Clue? focusClue}) {
    return updateClues(puzzle, entry, possibleValues,
        isEntry: true, isFocus: isFocus, focusClue: focusClue);
  }

  bool validVariable(Variable variable, int value,
      List<String> variableReferences, List<int> variableValues) {
    // if no values so far, then all valid
    if (variable.values == null) return true;
    return variable.values!.contains(value);
  }

  Set<Variable> solveVariable(ExpressionVariable variable) {
    // If variable solved already then skip it
    // Can no longer do this because variable can be set by other clues/variable
    // if (variable.values != null && variable.values!.length == 1) return false;

    bool updated = false;
    var puzzle = puzzleForVariable[variable]!;
    var possibleValue = <int>{};
    var possibleVariables = <Variable, Set<int>>{};

    for (var variableRef in variable.variableReferences) {
      possibleVariables[variableRef] = <int>{};
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
    var updatedVariables = <Variable>{};
    if (updateVariables(
        puzzle, variable.name, possibleValue, updatedVariables)) {
      updated = true;
    }
    // Update variable references even if this variable not updated, because may
    // have been set elsewhere
    for (var variableRef in variable.variableReferences) {
      if (updateVariables(puzzle, variableRef.name,
          possibleVariables[variableRef]!, updatedVariables)) {
        updated = true;
      }
    }

    if (traceSolve && updated) {
      print("solve: ${variable.runtimeType}(${variable.toString()})");
      for (var variableRef in updatedVariables) {
        print('${variableRef.name}=${variableRef.values.toString()}');
      }
    }

    // Return all updated variables
    if (!updated) return {};
    var allUpdatedVariables = <Variable>{variable};
    allUpdatedVariables.addAll(updatedVariables);

    return allUpdatedVariables;
  }

  // Validate possible clue value
  bool validClue(VariableClue clue, int value, List<String> variableReferences,
      List<int> variableValues) {
    if (value < 0) return false;
    if (clue.min != null && value < clue.min!) return false;
    if (clue.max != null && value > clue.max!) return false;
    if (clue.values != null && !clue.values!.contains(value)) return false;
    if (!clue.digitsMatch(value)) return false;

    // Pairs
    if (hasPairConstraint && !validPair(clue, value)) return false;

    return true;
  }

  // Pair constraints logic
  // When there are two puzzles, and the corresponding cells in each
  // puzzle are constrained
  bool hasPairConstraint = false;
  var pairs = <int, int>{};

  void addPairConstraint() {
    hasPairConstraint = true;
    initPairs();
  }

  void initPairs() {
    // pairs[0] = 0; // Invalid
    for (var i = 0; i < 10; i += 1) {
      for (var j = 0; j < 10; j += 1) {
        var pair = j * 10 + i;
        pairs[pair] = -1;
      }
    }
  }

  int getPairValue(int i, int j) {
    return 0;
  }

  bool validPair(Clue clue, int value) {
    var otherPuzzle =
        puzzles[0].clues.containsValue(clue) ? puzzles[1] : puzzles[0];
    var otherClue = otherPuzzle.clues[clue.name]!;
    var v = value;
    var newPairs = <int>[];
    for (var d = clue.length! - 1; d >= 0; d--) {
      var digit = v % 10;
      v = v ~/ 10;
      var otherDigits = clueDigits(otherClue, d);

      // Possible pair with any other digit means ok
      var ok = false;
      var newPair = -1; // No new pair
      for (var otherDigit in otherDigits) {
        var pair = getPairValue(digit, otherDigit);
        if (newPairs.contains(pair)) {
          continue; // This pair consumed by earlier digit in this value
        }
        if (pairs[pair] == -1) {
          if (newPair == -1) {
            newPair = pair; // New pair consumed by this digit
          } else {
            newPair = 0; // Multiple new pairs for this digit
          }
          ok = true;
        } else if (pairs[pair] == clue.entryMixin!.cellDigitIndex(d)) {
          ok = true;
        }
      }
      if (!ok) {
        return false;
      }
      if (newPair > 0) newPairs.add(newPair);
    }
    return true;
  }

  void updatePairs(Puzzle puzzle, Clue clue) {
    var otherPuzzle = puzzle == puzzles[0] ? puzzles[1] : puzzles[0];
    var otherClue = otherPuzzle.clues[clue.name]!;
    for (var d = 0; d < clue.length!; d++) {
      // Get clue digits from values as may not have finalised digits
      var digits = clue.clueDigits(d);
      if (digits.length == 1) {
        if (otherClue.digits[d].length == 1) {
          var pair = getPairValue(digits.first, otherClue.digits[d].first);
          if (!(pairs[pair] == -1 ||
              pairs[pair] == clue.entryMixin!.cellDigitIndex(d))) {
            throw SolveException('Pair violation');
          }
          // Cannot have side effect if iterating
          if (!iterating && pairs[pair] == -1) {
            pairs[pair] = clue.entryMixin!.cellDigitIndex(d);
          }
        }
      }
    }
  }

  List<int> clueDigits(Clue clue, int d) {
    return iterating ? clue.clueDigits(d) : List.from(clue.digits[d]);
  }

  Set<int>? getValuesFromDigits(Clue clue) {
    var allDigits =
        List<List<int>>.generate(clue.length!, (d) => clueDigits(clue, d));
    var count = cartesianCount(allDigits);
    if (count > 1000) return null;
    var values = <int>{};
    for (var product in cartesian(allDigits, true)) {
      int value = product.reduce((value, element) => value * 10 + element);
      values.add(value);
    }
    return values;
  }

  void updateAllVariables(
      Set<Variable> updatedVariables, List<Variable> updatedAllVariables) {
    for (var updatedVariable in updatedVariables) {
      var key = updatedVariable;
      if (!updatedAllVariables.contains(key)) updatedAllVariables.add(key);
    }
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
    if (r == 'I' || r == 'i') return 1;
    if (r == 'V' || r == 'v') return 5;
    if (r == 'X' || r == 'x') return 10;
    if (r == 'L' || r == 'l') return 50;
    if (r == 'C' || r == 'c') return 100;
    if (r == 'D' || r == 'd') return 500;
    if (r == 'M' || r == 'm') return 1000;
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
