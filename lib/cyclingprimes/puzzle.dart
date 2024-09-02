import 'package:collection/collection.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../undo.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class CyclingPrimesVariable extends Variable {
  CyclingPrimesVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class CyclingPrimesPuzzle extends VariablePuzzle<CyclingPrimesClue,
    CyclingPrimesEntry, CyclingPrimesVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  CyclingPrimesPuzzle({String name = ''}) : super(null, name: name);
  CyclingPrimesPuzzle.fromGridString(List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name);

  int mapOrderedCluesToEntries(
      Map<CyclingPrimesClue, List<CyclingPrimesEntry>> clueEntries,
      Function callback) {
    var orderedClues = clueEntries.keys.toList();
    orderedClues.sort((clue1, clue2) =>
        clueEntries[clue1]!.length.compareTo(clueEntries[clue2]!.length));
    var count = 0;
    var clue = orderedClues.first;
    var range = clue.max! - clue.min! + 1;
    for (var offset = 0; offset < range; offset++) {
      for (var mapped
          in mapOrderedDigitClueToEntry(clueEntries, orderedClues, offset, 0)) {
        if (mapped) {
          callback();
          count++;
        }
      }
    }
    return count;
  }

  Iterable<bool> mapOrderedDigitClueToEntry(
      Map<CyclingPrimesClue, List<CyclingPrimesEntry>> clueEntries,
      List<CyclingPrimesClue> orderedClues,
      int offset,
      int index) sync* {
    var clue = orderedClues[index];
    for (var entry in clueEntries[clue]!) {
      CyclingPrimesClue? mappedClue =
          (entry as EntryMixin).clue as CyclingPrimesClue?;
      if (mappedClue != null) continue;

      // Set mapping
      mapClueToEntry(clue, entry);

      // Save values and entry digits
      UndoStack.begin();
      // var oldClueValues = clue.values;
      // var oldEntryValues = entry.values;
      // var savedDigits = clue.saveDigits();

      // Update entry from clue
      if (updateEntry(clue)) {
        // Try to map remaining clues
        if (index == orderedClues.length - 1) {
          if (checkSolution()) {
            yield true;
          }
        } else {
          yield* mapOrderedDigitClueToEntry(
              clueEntries, orderedClues, offset, index + 1);
        }
      } else if (mappedClue != null) {
        if (Crossnumber.traceSolve) {
          print(
              'Clue ${mappedClue.name} mapping to Entry ${entry.name} is invalid');
        }
      }

      // Undo mapping
      UndoStack.undo();
      // clue.values = oldClueValues;
      // clue.restoreDigits(savedDigits);
      // entry.values = oldEntryValues;
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

  @override
  bool updateEntry(CyclingPrimesClue clue) {
    var updated = super.updateEntry(clue);
    if (updated) {
      var entry = clue.entry as EntryMixin;
      for (var d = 0; d < entry.length!; d++) {
        if (entry.digitIdentities[d] != null) {
          var entry2Updated = false;
          var entry2 = entry.digitIdentities[d]!.entry;
          var d2 = entry.digitIdentities[d]!.digit;
          var otherDigits = entry2.digits[d2];
          var newDigits = entry.digits[d].intersection(otherDigits);
          if (newDigits.length != otherDigits.length) {
            if (newDigits.isEmpty) {
              return false;
            }
            if (!entry2Updated) {
              entry2Updated = true;
              UndoStack.push(entry2);
            }
            entry2.setDigits(d2, newDigits);
          }
          // Update entry values from digits
          if (!entry2Updated) {
            entry2Updated = true;
            UndoStack.push(entry2);
          }
          entry2.updateValuesFromDigits();
        }
      }
    }
    return updated;
  }

  @override
  bool checkSolution() {
    // Check clues are in ascending order
    var clueKeys = clues.keys.sorted((a, b) => a.compareTo(b));
    var clueValues = List.filled(clueKeys.length, 0);
    for (var entry in entries.values) {
      var clueName = entry.clue!.name;
      var clueIndex = clueKeys.indexOf(clueName);
      clueValues[clueIndex] = entry.value!;
    }
    for (var i = 0; i < clueValues.length - 2; i++) {
      if (clueValues[i] >= clueValues[i + 1]) {
        return false;
      }
    }
    return true;
  }
}
