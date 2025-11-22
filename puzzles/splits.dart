// Splits by Nod

// Each clue consists of a 4-digit number which must be split into two parts
// that generate the entry by cubing one part and adding the other. For example,
// 2341 gives one of these entries 349, 12208, 68944, 235 which are 2³+341,
// 23³+41, 23+41³, 234 + 1³ respectively, ignoring 2+341³ and 234³ + 1 because
// they are too big for the grid.

// Clues are presented, reading down columns from left to right, in ascending
// numerical order of their answers, which must be entered where they will fit.
// Grid entries are numbered for reference only and bear no relation to clue
// order. The two unclued entries are multiples of the same entry.

import 'package:crossnumber/src/expressions/evaluator.dart';
import 'package:crossnumber/src/expressions/monadic.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/expression_constraint.dart';
import 'package:crossnumber/src/models/ordering_constraint.dart';
import 'package:crossnumber/src/models/puzzle_constraint.dart';
import 'package:crossnumber/src/models/puzzle_definition.dart';
import 'package:crossnumber/src/utils/set.dart';

PuzzleDefinition splits() {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :2 :3 :4 |5 :6 :  |',
    '+--+::+::+::+::+::+--+',
    '|7 :  :  |8 :  :  :9 |',
    '+::+::+::+::+::+::+::+',
    '|10:  :  :  |11:  :  |',
    '+::+::+--+--+::+--+::+',
    '|  |12:13:  :  :14|  |',
    '+::+--+::+--+--+::+::+',
    '|15:16:  |17:18:  :  |',
    '+::+::+::+::+::+::+::+',
    '|19:  :  :  |20:  :  |',
    '+--+::+::+::+::+::+--+',
    '|21:  :  |22:  :  :  |',
    '+--+--+--+--+--+--+--+',
  ];

  var puzzle = PuzzleDefinition.fromString(
    name: 'Splits',
    mappingIsKnown: false, // Mapping of Clues to Entries needed
    gridString: gridString.join('\n'),
    puzzleConstraints: [SplitsConstraint()],
    orderingConstraints: [OrderingConstraint(allClues: true)],
    entries: {},
    clues: {
      'A': Clue('A', [ExpressionConstraint(r"$split 1112")], length: 3),
      'B': Clue('B', [ExpressionConstraint(r"$split 1131")], length: 3),
      'C': Clue('C', [ExpressionConstraint(r"$split 3118")], length: 3),
      'D': Clue('D', [ExpressionConstraint(r"$split 1443")], length: 3),
      'E': Clue('E', [ExpressionConstraint(r"$split 2253")], length: 3),
      'F': Clue('F', [ExpressionConstraint(r"$split 4432")], length: 3),
      'G': Clue('G', [ExpressionConstraint(r"$split 2517")], length: 3),
      'H': Clue('H', [ExpressionConstraint(r"$split 4575")], length: 3),
      'I': Clue('I', [ExpressionConstraint(r"$split 6532")], length: 3),
      'K': Clue('K', [ExpressionConstraint(r"$split 7413")], length: 3),
      'L': Clue('L', [ExpressionConstraint(r"$split 6676")], length: 3),
      'M': Clue('M', [ExpressionConstraint(r"$split 5817")], length: 3),
      'N': Clue('N', [ExpressionConstraint(r"$split 7798")], length: 4),
      'O': Clue('O', [ExpressionConstraint(r"$split 9376")], length: 4),
      'P': Clue('P', [ExpressionConstraint(r"$split 9427")], length: 4),
      'Q': Clue('Q', [ExpressionConstraint(r"$split 9457")], length: 4),
      'R': Clue('R', [ExpressionConstraint(r"$split 8697")], length: 4),
      'S': Clue('S', [ExpressionConstraint(r"$split 8747")], length: 4),
      'T': Clue('T', [ExpressionConstraint(r"$split 1325")], length: 4),
      'U': Clue('U', [ExpressionConstraint(r"$split 5613")], length: 4),
      'V': Clue('V', [ExpressionConstraint(r"$split 1516")], length: 4),
      'W': Clue('W', [ExpressionConstraint(r"$split 8616")], length: 4),
      'X': Clue('X', [], length: 4),
      'Y': Clue('Y', [], length: 5),
      'Z': Clue('Z', [ExpressionConstraint(r"$split 4517")], length: 5),
    },
    variables: {},
  );

  registerPuzzleFunctions();

  setAnswers(puzzle);

  return puzzle;
}

void registerPuzzleFunctions() {
  // Register puzzle specific functions
  final MonadicFunctionRegistry monadicFunctionRegistry =
      MonadicFunctionRegistry();
  monadicFunctionRegistry.registerFunction('split', (values,
      {int? min, int? max}) {
    final results = <int>{};
    for (var v in values) {
      if (v < 1000 || v > 9999) {
        throw EvaluatorException(
            'split function requires a 4-digit number, got $v');
      }
      final s = v.toString();
      for (var i = 1; i < s.length; i++) {
        final part1 = int.parse(s.substring(0, i));
        final part2 = int.parse(s.substring(i));
        final result = part1 + part2 * part2 * part2;
        if ((min == null || result >= min) && (max == null || result <= max)) {
          results.add(result);
        }
        final result2 = part1 * part1 * part1 + part2;
        if ((min == null || result2 >= min) &&
            (max == null || result2 <= max)) {
          results.add(result2);
        }
      }
    }
    var res = results.toList()..sort();
    return res;
  });

  // Register puzzle specific functions
  // final GeneratorRegistry generatorRegistry = GeneratorRegistry();
  // generatorRegistry.register('sumdigits', SumDigitsGenerator(this));
}

void setAnswers(PuzzleDefinition puzzle) {
  // puzzle.entries['A1']!.answer = 191;
}

class SplitsConstraint extends PuzzleConstraint {
  @override
  void initialise(PuzzleDefinition puzzle, {bool trace = false}) {
    for (var clue in puzzle.clues.values) {
      if (clue.constraints.isNotEmpty) {
        // Clue has constraints, so possibleValues will be set by them
        continue;
      }
      // The unknown clues are 4 or 5-digit numbers
      var max = clue.length == 4 ? 9999 : 99999;
      var min = clue.length == 4 ? 1000 : 10000;
      var possibleValues = List.generate(max - min + 1, (i) => i + min).toSet();
      clue.possibleValues = Set.from(possibleValues);
    }
  }

  @override
  (bool, bool) propagate(PuzzleDefinition puzzle, {bool trace = false}) =>
      (true, false);

  @override
  (bool, bool) enforceDistinct(PuzzleDefinition puzzle, {bool trace = false}) =>
      (true, false);

  @override
  bool checkSolution(PuzzleDefinition puzzle, {bool trace = false}) {
    // The two unclued entries are multiples of the same entry.
    var foundEntry = false;
    final uncluedEntries =
        puzzle.clues.values.where((c) => c.constraints.isEmpty).toList();
    for (var entry in puzzle.entries.values) {
      if (entry.solution != null &&
          uncluedEntries.every((c) =>
              c.possibleValues?.any((v) => v % entry.solution! == 0) ??
              false)) {
        if (trace) {
          print(
              'SplitsConstraint: unclued entries ${uncluedEntries.map((c) => c.id).join(', ')} are multiples of entry ${entry.id} answer ${entry.solution}');
        }
        foundEntry = true;
      }
    }
    return foundEntry;
  }

  @override
  void onBacktrackingStart(PuzzleDefinition puzzle, {bool trace = false}) {
    // There are limited clue values, so set entry possibleValues for entries of
    // the correct length and force propagation of all entries
    // final valuesByLength = <int, Set<int>>{};
    // for (var clue in puzzle.clues.values) {
    //   if (clue.possibleValues != null) {
    //     valuesByLength.putIfAbsent(clue.length!, () => <int>{});
    //     valuesByLength[clue.length]!.addAll(clue.possibleValues!);
    //   }
    // }
    // for (var entry in puzzle.entries.values) {
    //   if (valuesByLength.containsKey(entry.length)) {
    //     entry.possibleValues = Set.from(valuesByLength[entry.length]!);
    //     entry.forcePropagation = true;
    //     if (trace) {
    //       print(
    //           'SplitsConstraint: onBacktrackingStart setting possibleValues for entry ${entry.id} to ${entry.possibleValues.length} ${entry.possibleValues.toShortString()}');
    //     }
    //   }
    // }
  }
}
