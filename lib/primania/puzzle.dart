import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../generators.dart';
import '../monadic.dart';
import '../undo.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class PrimaniaVariable extends Variable {
  PrimaniaVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class PrimaniaPuzzle
    extends VariablePuzzle<PrimaniaClue, PrimaniaEntry, PrimaniaVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  PrimaniaPuzzle({String name = ''}) : super(null, name: name);
  PrimaniaPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  void initVariablePuzzle(List<int>? possibleValues) {
    final puzzleMonadics = [
      Monadic('firstfactor', firstFactor, int),
      Monadic('secondfactor', secondFactor, int)
    ];
    Scanner.addMonadics(puzzleMonadics);
    super.initVariablePuzzle(possibleValues);
  }

  int mapOrderedCluesToEntries(
      Map<PrimaniaClue, List<PrimaniaEntry>> clueEntries, Function callback) {
    var orderedClues = clueEntries.keys.toList();
    orderedClues.sort((clue1, clue2) =>
        clueEntries[clue1]!.length.compareTo(clueEntries[clue2]!.length));
    var count = 0;
    for (var mapped
        in mapOrderedDigitClueToEntry(clueEntries, orderedClues, 0)) {
      if (mapped) {
        callback();
        count++;
      }
    }
    return count;
  }

  Iterable<bool> mapOrderedDigitClueToEntry(
      Map<PrimaniaClue, List<PrimaniaEntry>> clueEntries,
      List<PrimaniaClue> orderedClues,
      int index) sync* {
    var clue = orderedClues[index];
    for (var entry in clueEntries[clue]!) {
      PrimaniaClue? mappedClue = (entry as EntryMixin).clue as PrimaniaClue?;
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
              clueEntries, orderedClues, index + 1);
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
  bool updateEntry(PrimaniaClue clue) {
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
    var permittedDownValues = clues.values.map((c) => c.value!).toSet();
    var acrossValues = <int>[];
    for (var entry in entries.values) {
      var value = entry.value!;
      if (entry.isDown) {
        if (!permittedDownValues.contains(value)) {
          return false;
        }
        permittedDownValues.remove(value);
      } else {
        if (acrossValues.contains(value) ||
            !isPrime(value) ||
            !isPrime(reverse(value))) {
          return false;
        }
        acrossValues.add(value);
      }
    }
    return true;
  }
}

int firstFactor(int value) {
  return nthFactor(value, 1);
}

int secondFactor(int value) {
  return nthFactor(value, 2);
}

int nthFactor(int value, int n) {
  var index = 1;
  for (var factor in getFactors(value)) {
    if (index == n) return factor;
    index++;
  }
  return 0;
}
