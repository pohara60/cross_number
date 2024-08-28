library different;

import 'package:collection/collection.dart';
import 'package:powers/powers.dart';

import '../clue.dart';
import '../crossnumber.dart';
import '../expression.dart';
import '../puzzle.dart';
import '../variable.dart';
import 'clue.dart';
import 'puzzle.dart';

/// Provide access to the Different API.
class Different extends Crossnumber<DifferentPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|Aa:b :c |B :d :e :f |',
    '+::+::+::+--+::+::+::+',
    '|C :  |D :g |  |E :  |',
    '+--+::+::+::+::+::+::+',
    '|Fh:  :  |G :  |  |  |',
    '+::+--+--+::+::+::+::+',
    '|H :i :j |  |I :  :  |',
    '+::+::+::+::+--+--+::+',
    '|  |  |J :  |Kk:l :  |',
    '+::+::+::+::+::+::+--+',
    '|L :  |  |M :  |N :m |',
    '+::+::+::+--+::+::+::+',
    '|O :  :  :  |P :  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  Different() {
    initCrossnumber();
  }

  @override
  void initCrossnumber() {
    var puzzle = DifferentPuzzle.fromGridString(gridString);
    puzzles.add(puzzle);

    // Entries and Clues have separate definitions
    // Get entries from grid
    var entryErrors = '';
    for (var entrySpec in puzzle.getEntriesFromGrid()) {
      try {
        var entry = DifferentEntry(
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
    void clueWrapper(
        {String? name,
        int? length,
        required int difference,
        String? valueDesc,
        List<String>? addDesc}) {
      try {
        var clue = DifferentClue(
            name: name!,
            length: length,
            difference: difference,
            valueDesc: valueDesc,
            addDesc: addDesc,
            entryNames: entryNames);
        puzzle.addClue(clue);
        return;
      } on ExpressionError catch (e) {
        clueErrors += '${e.msg}\n';
        return;
      }
    }

    clueWrapper(name: '1', difference: 1);
    clueWrapper(name: '2', difference: 2);
    clueWrapper(name: '3', difference: 3);
    clueWrapper(name: '4', difference: 16);
    clueWrapper(name: '5', difference: 1);
    clueWrapper(name: '6', difference: 1);
    clueWrapper(name: '7', difference: 10);
    clueWrapper(name: '8', difference: 19);
    clueWrapper(name: '9', difference: 1);
    clueWrapper(name: '10', difference: 272);
    clueWrapper(name: '11', difference: 8);
    clueWrapper(name: '12', difference: 12);
    clueWrapper(name: '13', difference: 21);
    clueWrapper(name: '14', difference: 39);
    clueWrapper(name: '15', difference: 47);
    clueWrapper(name: '16', difference: 83);
    clueWrapper(name: '17', difference: 117);
    clueWrapper(name: '18', difference: 3);
    clueWrapper(name: '19', difference: 5);
    clueWrapper(name: '20', difference: 5855);
    clueWrapper(name: '21', difference: 148);
    clueWrapper(name: '22', difference: 92);
    clueWrapper(name: '23', difference: 361);
    clueWrapper(name: '24', difference: 20);
    clueWrapper(name: '25', difference: 19);
    clueWrapper(name: '26', difference: 35940);
    clueWrapper(name: '27', difference: 8);
    clueWrapper(name: '28', difference: 32);

    if (clueErrors != '') {
      throw PuzzleException(clueErrors);
    }

    puzzle.linkEntriesToGrid();

    var letters = [
      'A',
    ];
    for (var letter in letters) {
      puzzle.addAnyVariable(DifferentVariable(letter));
    }

    puzzle.finalize();

    super.initCrossnumber();
  }

  void mapCallback() {
    var mapping = puzzle.entries.values.where((e) => e.clue != null).map((e) {
      var c = e.clue!;
      return '${e.name}=${c.name}${c.values})';
    }).join(',');
    print('Mapping $mapping');
    print(puzzle.toSolution());
  }

  @override
  // ignore: unnecessary_overrides
  void solve([bool iteration = true]) {
    initClues();

    var clueEntries = findClueEntries();

    // Map Clues to Entries
    puzzle.mapOrderedCluesToEntries(clueEntries, mapCallback);
  }

  void initClues() {
    var entryLengths = <int, int>{};
    for (var entry in puzzle.entries.values) {
      var len = entry.length!;
      if (!entryLengths.containsKey(len)) {
        entryLengths[len] = 1;
      } else {
        entryLengths[len] = entryLengths[len]! + 1;
      }
    }
    var clueLengths = <int>[];
    for (var len
        in entryLengths.keys.toList().sorted((a, b) => a.compareTo(b))) {
      clueLengths.addAll(List.filled(entryLengths[len]!, len));
    }
    var clueKeys = puzzle.clues.keys.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    var prevMin = 9;
    for (var clueName in clueKeys) {
      var clue = puzzle.clues[clueName]!;
      var number = int.parse(clueName);
      var prev = number > 1 ? puzzle.clues[(number - 1).toString()] : null;
      var length = clueLengths[number - 1];
      clue.length = length;
      clue.min = 10.pow(length - 1) as int;
      clue.max = (10.pow(length) as int) - 1;

      var thisMin = prevMin + (prev == null ? 1 : prev.difference);
      if (thisMin > clue.min!) clue.min = thisMin;
      // print(
      //     'Clue ${clue.name} difference ${clue.difference} length=${clue.length!} min=${clue.min!}');

      prevMin = clue.min!;
    }
    var prevMax = 100000;
    var minDiff = 100000;
    for (var clueName in clueKeys.reversed) {
      var clue = puzzle.clues[clueName]!;
      var number = int.parse(clueName);
      var prev = number < puzzle.clues.length
          ? puzzle.clues[(number + 1).toString()]
          : null;

      var thisMax = prevMax - (prev == null ? 1 : clue.difference);
      if (thisMax < clue.max!) clue.max = thisMax;
      var diff = clue.max! - clue.min!;
      if (diff < minDiff) minDiff = diff;
      // print(
      //     'Clue ${clue.name} difference ${clue.difference} length=${clue.length!} min=${clue.min!} max=${clue.max!}');

      prevMax = clue.max!;
    }
    for (var clueName in clueKeys) {
      var clue = puzzle.clues[clueName]!;
      clue.max = clue.min! + minDiff;
      clue.values =
          Set.from(List.generate(minDiff + 1, (index) => clue.min! + index));
      // print(
      //     'Clue ${clue.name} difference ${clue.difference} length=${clue.length!} min=${clue.min!} max=${clue.max!}');
    }
    return;
  }

  Map<DifferentClue, List<DifferentEntry>> findClueEntries() {
    var clueEntries = <DifferentClue, List<DifferentEntry>>{};
    for (var clue in puzzle.clues.values) {
      var entries = findPossibleEntriesForClue(clue);
      clueEntries[clue] = entries;
    }
    for (var clue in puzzle.clues.values) {
      var entries = clueEntries[clue]!;
      print(
          'Clue ${clue.name}, entries, ${puzzle.entries.values.where((e) => e.isDown).map((e) => entries.contains(e) ? e.name : '').join(',')}');
    }
    return clueEntries;
  }

  List<DifferentEntry> findPossibleEntriesForClue(DifferentClue clue) {
    var result = <DifferentEntry>[];
    for (var entry in puzzle.entries.values) {
      var value = clue.value;
      var ok = true;
      if (entry.length == clue.length) {
        if (clue.value != null) {
          for (var d = entry.length! - 1; d >= 0; d--) {
            var digit = value! % 10;
            if (!entry.digits[d].contains(digit)) {
              ok = false;
              break;
            }
            value ~/= 10;
          }
        }
        if (ok) result.add(entry);
      }
    }
    return result;
  }
}
