/// An API for solving Letters puzzles.
library evenodder;

import '../crossnumber.dart';
import '../evenodder/clue.dart';
import '../evenodder/puzzle.dart';

/// Provide access to the Prime Cuts API.
class EvenOdder extends Crossnumber<EvenOdderPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+--+--+',
    '|1 :  :2 :3 |4 :5 |6 :7 :8 :9 |',
    '+::+--+::+::+::+::+--+::+::+::+',
    '|10:  :  :  |  |11:  :  :  :  |',
    '+::+--+--+::+::+::+--+::+::+--+',
    '|12:13|14:  :  |  |15|  |16:17|',
    '+--+::+::+--+::+::+::+::+--+::+',
    '|18:  :  |19:  :  |20:  :  :  |',
    '+::+--+::+::+--+::+::+--+--+::+',
    '|  |21:  :  :22|23:  :24:  |  |',
    '+::+--+--+::+::+--+::+::+--+::+',
    '|25:  :26:  |27:28:  |29:30:  |',
    '+::+--+::+::+::+::+--+::+::+--+',
    '|31:32|  |  |  |33:34:  |35:36|',
    '+--+::+::+--+::+::+::+--+--+::+',
    '|37:  :  :  :  |  |38:39:  :  |',
    '+::+::+::+--+::+::+::+::+--+::+',
    '|40:  :  :  |41:  |42:  :  :  |',
    '+--+--+--+--+--+--+--+--+--+--+',
  ];

  EvenOdder() {
    puzzle = EvenOdderPuzzle.grid(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var a1 = EvenOdderEntry(
        name: 'A1',
        length: 4,
        valueDesc: '-M+AS+S!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a1);
    var a4 = EvenOdderEntry(
        name: 'A4',
        length: 2,
        valueDesc: 'S+T+R-A-N-G+E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a4);
    var a6 = EvenOdderEntry(
        name: 'A6',
        length: 4,
        valueDesc: 'SPIN-O+R',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a6);
    var a10 = EvenOdderEntry(
        name: 'A10',
        length: 4,
        valueDesc: '-P+AR+T+ICL+E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a10);
    var a11 = EvenOdderEntry(
        name: 'A11',
        length: 5,
        valueDesc: '((P+H)(O-N)/O^N)!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a11);
    var a12 = EvenOdderEntry(
        name: 'A12',
        length: 2,
        valueDesc: 'A+T+O!+M-I+C',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a12);
    var a14 = EvenOdderEntry(
        name: 'A14',
        length: 3,
        valueDesc: 'G(A+U+G+E)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a14);
    var a16 = EvenOdderEntry(
        name: 'A16',
        length: 2,
        valueDesc: 'IO-NS',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a16);
    var a18 = EvenOdderEntry(
        name: 'A18',
        length: 3,
        valueDesc: 'H-I+GG+S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a18);
    var a19 = EvenOdderEntry(
        name: 'A19',
        length: 3,
        valueDesc: 'B(A-R+N)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a19);
    var a20 = EvenOdderEntry(
        name: 'A20',
        length: 4,
        valueDesc: '(P+L)(AS+M-O!-N)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a20);
    var a21 = EvenOdderEntry(
        name: 'A21',
        length: 4,
        valueDesc: '-P-OT-E^N+T+IAL',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a21);
    var a23 = EvenOdderEntry(
        name: 'A23',
        length: 4,
        valueDesc: 'N+E+U-TR+(O-N)S!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a23);
    var a25 = EvenOdderEntry(
        name: 'A25',
        length: 4,
        valueDesc: 'T(O!+P)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a25);
    var a27 = EvenOdderEntry(
        name: 'A27',
        length: 3,
        valueDesc: 'B(O+S+O+N)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a27);
    var a29 = EvenOdderEntry(
        name: 'A29',
        length: 3,
        valueDesc: 'TU+N-N+E+L',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a29);
    var a31 = EvenOdderEntry(
        name: 'A31',
        length: 2,
        valueDesc: 'B-O-S+E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a31);
    var a33 = EvenOdderEntry(
        name: 'A33',
        length: 3,
        valueDesc: '(P-I-ON)!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a33);
    var a35 = EvenOdderEntry(
        name: 'A35',
        length: 2,
        valueDesc: 'C+H-A-R+M',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a35);
    var a37 = EvenOdderEntry(
        name: 'A37',
        length: 5,
        valueDesc: 'B+OTTO+M',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a37);
    var a38 = EvenOdderEntry(
        name: 'A38',
        length: 4,
        valueDesc: 'NI+ELS',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a38);
    var a40 = EvenOdderEntry(
        name: 'A40',
        length: 4,
        valueDesc: 'S!/O-(L-I+TO)N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a40);
    var a41 = EvenOdderEntry(
        name: 'A41',
        length: 2,
        valueDesc: 'B-O+R^N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a41);
    var a42 = EvenOdderEntry(
        name: 'A42',
        length: 4,
        valueDesc: 'N+UCL-E+AR',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(a42);

    var d1 = EvenOdderEntry(
        name: 'D1',
        length: 3,
        valueDesc: 'M+(E+A+S-U)(R+E)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d1);
    var d2 = EvenOdderEntry(
        name: 'D2',
        length: 2,
        valueDesc: 'T+A-U',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d2);
    var d3 = EvenOdderEntry(
        name: 'D3',
        length: 3,
        valueDesc: '(-S+I)(N-G+L+E+T)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d3);
    var d4 = EvenOdderEntry(
        name: 'D4',
        length: 4,
        valueDesc: '(N-E+U+T+R)(I-N)O',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d4);
    var d5 = EvenOdderEntry(
        name: 'D5',
        length: 5,
        valueDesc: 'M+UM-E+S!(O!-N)+S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d5);
    var d7 = EvenOdderEntry(
        name: 'D7',
        length: 4,
        valueDesc: 'C+O-L+LAP+S-E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d7);
    var d8 = EvenOdderEntry(
        name: 'D8',
        length: 3,
        valueDesc: '(S!/P-I)^N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d8);
    var d9 = EvenOdderEntry(
        name: 'D9',
        length: 2,
        valueDesc: '-P+SI-O-N-S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d9);
    var d13 = EvenOdderEntry(
        name: 'D13',
        length: 2,
        valueDesc: '-S+L-I+T',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d13);
    var d14 = EvenOdderEntry(
        name: 'D14',
        length: 3,
        valueDesc: 'UP',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d14);
    var d15 = EvenOdderEntry(
        name: 'D15',
        length: 4,
        valueDesc: '(-E+(I+N!)S+T-E)IN',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d15);
    var d17 = EvenOdderEntry(
        name: 'D17',
        length: 4,
        valueDesc: 'M+O-L+ECU-L+E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d17);
    var d18 = EvenOdderEntry(
        name: 'D18',
        length: 4,
        valueDesc: '(T+E+NSO)R',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d18);
    var d19 = EvenOdderEntry(
        name: 'D19',
        length: 4,
        valueDesc: '(C+H+RO)NO-N!-S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d19);
    var d22 = EvenOdderEntry(
        name: 'D22',
        length: 5,
        valueDesc: 'I+S+O^S-P+I^N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d22);
    var d24 = EvenOdderEntry(
        name: 'D24',
        length: 3,
        valueDesc: '(C)LU/R', // (C/O)LOU/R fails integer division
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d24);
    var d26 = EvenOdderEntry(
        name: 'D26',
        length: 4,
        valueDesc: 'P+OS!+I+T+I-O-N!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d26);
    var d28 = EvenOdderEntry(
        name: 'D28',
        length: 4,
        valueDesc: 'PO(S+I-T+R+O+N)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d28);
    var d30 = EvenOdderEntry(
        name: 'D30',
        length: 2,
        valueDesc: '-G-L+UO+N!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d30);
    var d32 = EvenOdderEntry(
        name: 'D32',
        length: 3,
        valueDesc: 'P+HA+S+E-S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d32);
    var d34 = EvenOdderEntry(
        name: 'D34',
        length: 3,
        valueDesc: '-B-O+HR',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d34);
    var d36 = EvenOdderEntry(
        name: 'D36',
        length: 3,
        valueDesc: 'EL+E-C+T+R-O+N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d36);
    var d37 = EvenOdderEntry(
        name: 'D37',
        length: 2,
        valueDesc: '-M+UO/N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d37);
    var d39 = EvenOdderEntry(
        name: 'D39',
        length: 2,
        valueDesc: '-S+T+R+I+N-G',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addEntry(d39);

    puzzle.addDigitIdentityFromGrid();
    // Add letter references from descriptions
    var letters = [
      'A',
      'B',
      'C',
      'E',
      'G',
      'H',
      'I',
      'L',
      'M',
      'N',
      'O',
      'P',
      'R',
      'S',
      'T',
      'U',
    ];
    for (var letter in letters) {
      // Add Across and Down versions of variable
      for (var prefix in ['A', 'D']) {
        var variableName = prefix + letter;
        puzzle.letters[variableName] = EvenOdderVariable(variableName);
        for (var clue in puzzle.clues.values) {
          if (clue.name[0] == prefix) {
            if (clue.exp.variableRefs.contains(variableName)) {
              clue.addLetterReference(variableName);
            }
          }
        }
      }
      EvenOdderVariable.link(
        puzzle.letters['A' + letter]! as EvenOdderVariable,
        puzzle.letters['D' + letter]! as EvenOdderVariable,
      );
    }

    if (Crossnumber.traceInit) {
      print(puzzle.toString());
    }
  }

  // Semi-Manual solve procedure example
  // solveA2(EvenOdderEntry clue, Set<int> possibleValue,
  //     Map<String, Set<int>> possibleLetters) {
  //   var updated = false;
  //   puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
  //       (letters) {
  //     var index = 0;
  //     var E = letters[index++];
  //     var P = letters[index++];
  //     var W = letters[index++];
  //     var o = letters[index++];
  //     var r = letters[index++];
  //     return P * o + W * E + r;
  //   });
  //   return updated;
  // }
  // Manual solve procedure example
  // bool solveD25(EvenOdderEntry clue, Set<int> possibleValue,
  //     Map<String, Set<int>> possibleLetters) {
  //   final stopwatch = Stopwatch()..start();
  //   var count = 0;
  //   var updated = false;
  //   for (var Y
  //       in puzzle.letters['Y']!.values.where((element) => element < 10)) {
  //     for (var S
  //         in puzzle.letters['S']!.values.where((element) => element != Y)) {
  //       for (var I in puzzle.letters['I']!.values
  //           .where((element) => element != S && element != Y)) {
  //         count++;
  //         var value = Y * Y + Y;
  //         if (value >= 10 && value < 100 && value == (I - S)) {
  //           if (clue.digitsMatch(value)) {
  //             possibleValue.add(value);
  //             possibleLetters['S']!.add(S);
  //             possibleLetters['Y']!.add(Y);
  //             possibleLetters['I']!.add(I);
  //           }
  //         }
  //       }
  //     }
  //   }
  //   if (Crossnumber.traceSolve) {
  //     print(
  //         'Solve ${clue.name} iterations=$count, elapsed ${stopwatch.elapsed}');
  //   }
  //   return updated;
  // }

  void solve([bool iteration = true]) {
    print("SOLVE------------");
    // Manual sequencing of solution may save iterations
    // solveClue(this.puzzle.clues['D26']!);
    super.solve(iteration);
  }
}
