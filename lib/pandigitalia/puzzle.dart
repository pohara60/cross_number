import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'pandigital_set.dart';

// Numbers < 200 that are a power of a prime number

class PandigitaliaVariable extends Variable {
  PandigitaliaVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class PandigitaliaPuzzle extends VariablePuzzle<PandigitaliaClue,
    PandigitaliaEntry, PandigitaliaVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  PandigitaliaPuzzle({String name = ''}) : super(null, name: name);
  PandigitaliaPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  var pandigitalSets = <PanDigitalSet>[];
  var pandigitalSetForClue = <Variable, PanDigitalSet>{};

  void createPandigitalSet(String clue2name, String clue4name) {
    var set = PanDigitalSet(
      clue2digits: clues[clue2name] as PandigitaliaEntry,
      clue4digits: clues[clue4name] as PandigitaliaEntry,
    );
    pandigitalSets.add(set);
    pandigitalSetForClue[set.clue2digits] = set;
    pandigitalSetForClue[set.clue4digits] = set;
  }

  void initPandigitalSets() {
    // The 2-digit member of a set intersects the 4-digit entry symmetrically
    // opposite the 4-digit member of its own pandigital set. For example, 3dn
    // intersects 2ac so 14ac and 3dn belong to the same pandigital set.
    createPandigitalSet('A1', 'D8');
    createPandigitalSet('A6', 'D5');
    createPandigitalSet('A11', 'D4');
    createPandigitalSet('A15', 'D1');
    createPandigitalSet('D3', 'A14');
    createPandigitalSet('D12', 'A2');
  }

  bool validClue(PandigitaliaClue clue, int value) {
    // This puzzle consists of six 2-digit, six 3-digit and six 4-digit entries.
    // These can be divided into six pandigital sets each with a 2-, 3- and 4-digit
    // entry between them containing the digits 1-9.
    // The set's nine digits include 1-9, so no clue can have repeated digits.
    var digits = value.toString().split('').map(int.parse).toSet();
    if (digits.length != value.toString().length) {
      return false;
    }

    var set = pandigitalSetForClue[clue];
    if (clue is PandigitaliaEntry && set != null) {
      return set.checkClueValue(value, clue);
    }

    // The 18 digits of the six 3-digit entries contain two each of the digits 1-9.
    if (clue.length == 3) {
      // D2 ia a 3 digit clues that intersect with two other 3 digit clues A4 and A7.
      // Similarly D10 intersects with A9 and A13.
      // So the intersecting digits will be used twice in the 3-digit clues, i.e.
      // they may not appear elsewhere in the 3-digit clues.
      // var isD2orD10 = clue.name == 'D2' || clue.name == 'D10';

      // Get known 3 digit clue values
      var knownClues = clues.values
          .whereType<PandigitaliaEntry>()
          .where((c) => c != clue && c.length == 3 && c.isSet)
          .toList();
      var knownValues = knownClues.map((c) => c.value).toSet();
      // if (knownValues.length < 2) {
      //   // Not enough known values to check digit occurrence
      //   return true;
      // }

      // Get the occurrence count of digits in the values
      var digitCount = <String, int>{};
      for (var knownValue in knownValues) {
        var digits = knownValue.toString().split('');
        for (var digit in digits) {
          digitCount[digit] = (digitCount[digit] ?? 0) + 1;
        }
      }
      // Check first in case previous logic has exceeded the count
      if (digitCount.values.any((element) => element > 2)) {
        return false;
      }

      // Check if this clue's digits already appear twice in other clues
      var valueStr = value.toString();
      for (var index = 0; index < valueStr.length; index++) {
        var digit = valueStr[index];
        if (clue.length == 3) {
          // if an intersecting 3 digit clue is not known, then we can
          // count the digit twice
          var intersection = clue.digitIdentities[index];
          if (intersection != null) {
            var intersectingClue = intersection.clue;
            if (intersectingClue.length == 3 &&
                !knownClues.contains(intersectingClue)) {
              // Count the digit twice
              digitCount[digit] = (digitCount[digit] ?? 0) + 1;
            }
          }
        }
        digitCount[digit] = (digitCount[digit] ?? 0) + 1;
        if (digitCount[digit]! > 2) {
          // A digit appears more than twice in the 3-digit clues
          return false;
        }
      }
    }
    return true;
  }

  @override
  postProcessing(
      {bool iteration = true,
      int Function(Puzzle)? callback,
      Function? partialCallback}) {
    if (iteration) {
      traceFindSolutions = true;
      // traceFindAnswer = true;
      var stopwatch = Stopwatch()..start();
      super.postProcessing(
          iteration: iteration,
          callback: callback,
          partialCallback: partialCallback);
      stopwatch.stop();
      print('Post processing time: ${stopwatch.elapsedMilliseconds} ms');
    }
  }

  @override
  bool checkSolution() {
    if (!super.checkSolution()) {
      return false;
    }

    // Check if can allocate 3-digit clues to sets
    var clues3Digits = clues.values.where((c) => c.length == 3).toList();
    var remainingSets = Set<PanDigitalSet>.from(pandigitalSets);
    if (checkClueSet(clues3Digits, 0, remainingSets)) {
      // All 3-digit clues can be allocated to sets
      return true;
    } else {
      // Not all 3-digit clues can be allocated to sets
      return false;
    }
  }

  bool checkClueSet(
      List<PandigitaliaClue> clues3Digits, int index, Set<PanDigitalSet> sets) {
    var clue = clues3Digits[index];
    if (clue is PandigitaliaEntry && clue.isSet) {
      for (var set in sets) {
        // Check if the clue's digits are already used in the set
        if (set.checkClueValue(clue.value!, clue)) {
          // Possible to allocate this clue to the set
          pandigitalSetForClue[clue] = set;

          // Recurse
          if (index == clues3Digits.length - 1) {
            // Last clue, all clues allocated
            return true;
          } else {
            var remainingSets = Set<PanDigitalSet>.from(sets);
            remainingSets.remove(set);
            if (checkClueSet(clues3Digits, index + 1, remainingSets)) {
              return true;
            }
            // Backtrack
            pandigitalSetForClue.remove(clue);
          }
        }
      }
    }
    return false;
  }
}
