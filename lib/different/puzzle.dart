import '../clue.dart';
import '../crossnumber.dart';
import '../undo.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class DifferentVariable extends Variable {
  DifferentVariable(super.letter) {
    values = Set.from(List.generate(99, (index) => 10 + index));
  }
  String get letter => name;
}

class DifferentPuzzle
    extends VariablePuzzle<DifferentClue, DifferentEntry, DifferentVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  DifferentPuzzle({String name = ''}) : super(null, name: name);
  DifferentPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  int mapOrderedCluesToEntries(
      Map<DifferentClue, List<DifferentEntry>> clueEntries, Function callback) {
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
      Map<DifferentClue, List<DifferentEntry>> clueEntries,
      List<DifferentClue> orderedClues,
      int offset,
      int index) sync* {
    var clue = orderedClues[index];
    for (var entry in clueEntries[clue]!) {
      DifferentClue? mappedClue = (entry as EntryMixin).clue as DifferentClue?;
      if (mappedClue != null) continue;

      // Set mapping
      mapClueToEntry(clue, entry);

      // Save values and entry digits
      UndoStack.begin();
      // var oldClueValues = clue.values;
      // var oldEntryValues = entry.values;
      // var savedDigits = clue.saveDigits();

      // Update entry from clue
      clue.value = clue.min! + offset;
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
  bool updateEntry(DifferentClue clue) {
    var updated = super.updateEntry(clue);
    if (updated) {
      // Update across entries
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
    return true;
  }
}
