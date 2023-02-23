/// An API for solving Letters puzzles.
library evenodder;

import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/evenodder/clue.dart';
import 'package:crossnumber/evenodder/puzzle.dart';

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
    puzzle.clues = {};
    var a1 = EvenOdderClue(
        name: 'A1',
        length: 4,
        valueDesc: '-M+AS+S!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a1);
    var a4 = EvenOdderClue(
        name: 'A4',
        length: 2,
        valueDesc: 'S+T+R-A-N-G+E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a4);
    var a6 = EvenOdderClue(
        name: 'A6',
        length: 4,
        valueDesc: 'SPIN-O+R',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a6);
    var a10 = EvenOdderClue(
        name: 'A10',
        length: 4,
        valueDesc: '-P+AR+T+ICL+E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a10);
    var a11 = EvenOdderClue(
        name: 'A11',
        length: 5,
        valueDesc: '((P+H)(O-N)/O^N)!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a11);
    var a12 = EvenOdderClue(
        name: 'A12',
        length: 2,
        valueDesc: 'A+T+O!+M-I+C',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a12);
    var a14 = EvenOdderClue(
        name: 'A14',
        length: 3,
        valueDesc: 'G(A+U+G+E)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a14);
    var a16 = EvenOdderClue(
        name: 'A16',
        length: 2,
        valueDesc: 'IO-NS',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a16);
    var a18 = EvenOdderClue(
        name: 'A18',
        length: 3,
        valueDesc: 'H-I+GG+S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a18);
    var a19 = EvenOdderClue(
        name: 'A19',
        length: 3,
        valueDesc: 'B(A-R+N)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a19);
    var a20 = EvenOdderClue(
        name: 'A20',
        length: 4,
        valueDesc: '(P+L)(AS+M-O!-N)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a20);
    var a21 = EvenOdderClue(
        name: 'A21',
        length: 4,
        valueDesc: '-P-OT-E^N+T+IAL',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a21);
    var a23 = EvenOdderClue(
        name: 'A23',
        length: 4,
        valueDesc: 'N+E+U-TR+(O-N)S!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a23);
    var a25 = EvenOdderClue(
        name: 'A25',
        length: 4,
        valueDesc: 'T(O!+P)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a25);
    var a27 = EvenOdderClue(
        name: 'A27',
        length: 3,
        valueDesc: 'B(O+S+O+N)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a27);
    var a29 = EvenOdderClue(
        name: 'A29',
        length: 3,
        valueDesc: 'TU+N-N+E+L',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a29);
    var a31 = EvenOdderClue(
        name: 'A31',
        length: 2,
        valueDesc: 'B-O-S+E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a31);
    var a33 = EvenOdderClue(
        name: 'A33',
        length: 3,
        valueDesc: '(P-I-ON)!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a33);
    var a35 = EvenOdderClue(
        name: 'A35',
        length: 2,
        valueDesc: 'C+H-A-R+M',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a35);
    var a37 = EvenOdderClue(
        name: 'A37',
        length: 5,
        valueDesc: 'B+OTTO+M',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a37);
    var a38 = EvenOdderClue(
        name: 'A38',
        length: 4,
        valueDesc: 'NI+ELS',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a38);
    var a40 = EvenOdderClue(
        name: 'A40',
        length: 4,
        valueDesc: 'S!/O-(L-I+TO)N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a40);
    var a41 = EvenOdderClue(
        name: 'A41',
        length: 2,
        valueDesc: 'B-O+R^N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a41);
    var a42 = EvenOdderClue(
        name: 'A42',
        length: 4,
        valueDesc: 'N+UCL-E+AR',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(a42);

    var d1 = EvenOdderClue(
        name: 'D1',
        length: 3,
        valueDesc: 'M+(E+A+S-U)(R+E)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d1);
    var d2 = EvenOdderClue(
        name: 'D2',
        length: 2,
        valueDesc: 'T+A-U',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d2);
    var d3 = EvenOdderClue(
        name: 'D3',
        length: 3,
        valueDesc: '(-S+I)(N-G+L+E+T)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d3);
    var d4 = EvenOdderClue(
        name: 'D4',
        length: 4,
        valueDesc: '(N-E+U+T+R)(I-N)O',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d4);
    var d5 = EvenOdderClue(
        name: 'D5',
        length: 5,
        valueDesc: 'M+UM-E+S!(O!-N)+S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d5);
    var d7 = EvenOdderClue(
        name: 'D7',
        length: 4,
        valueDesc: 'C+O-L+LAP+S-E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d7);
    var d8 = EvenOdderClue(
        name: 'D8',
        length: 3,
        valueDesc: '(S!/P-I)^N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d8);
    var d9 = EvenOdderClue(
        name: 'D9',
        length: 2,
        valueDesc: '-P+SI-O-N-S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d9);
    var d13 = EvenOdderClue(
        name: 'D13',
        length: 2,
        valueDesc: '-S+L-I+T',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d13);
    var d14 = EvenOdderClue(
        name: 'D14',
        length: 3,
        valueDesc: 'UP',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d14);
    var d15 = EvenOdderClue(
        name: 'D15',
        length: 4,
        valueDesc: '(-E+(I+N!)S+T-E)IN',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d15);
    var d17 = EvenOdderClue(
        name: 'D17',
        length: 4,
        valueDesc: 'M+O-L+ECU-L+E',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d17);
    var d18 = EvenOdderClue(
        name: 'D18',
        length: 4,
        valueDesc: '(T+E+NSO)R',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d18);
    var d19 = EvenOdderClue(
        name: 'D19',
        length: 4,
        valueDesc: '(C+H+RO)NO-N!-S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d19);
    var d22 = EvenOdderClue(
        name: 'D22',
        length: 5,
        valueDesc: 'I+S+O^S-P+I^N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d22);
    var d24 = EvenOdderClue(
        name: 'D24',
        length: 3,
        valueDesc: '(C)LU/R', // (C/O)LOU/R fails integer division
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d24);
    var d26 = EvenOdderClue(
        name: 'D26',
        length: 4,
        valueDesc: 'P+OS!+I+T+I-O-N!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d26);
    var d28 = EvenOdderClue(
        name: 'D28',
        length: 4,
        valueDesc: 'PO(S+I-T+R+O+N)',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d28);
    var d30 = EvenOdderClue(
        name: 'D30',
        length: 2,
        valueDesc: '-G-L+UO+N!',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d30);
    var d32 = EvenOdderClue(
        name: 'D32',
        length: 3,
        valueDesc: 'P+HA+S+E-S',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d32);
    var d34 = EvenOdderClue(
        name: 'D34',
        length: 3,
        valueDesc: '-B-O+HR',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d34);
    var d36 = EvenOdderClue(
        name: 'D36',
        length: 3,
        valueDesc: 'EL+E-C+T+R-O+N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d36);
    var d37 = EvenOdderClue(
        name: 'D37',
        length: 2,
        valueDesc: '-M+UO/N',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d37);
    var d39 = EvenOdderClue(
        name: 'D39',
        length: 2,
        valueDesc: '-S+T+R+I+N-G',
        solve: puzzle.solveVariableExpressionEvaluator);
    puzzle.addClue(d39);

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
  // solveA2(EvenOdderClue clue, Set<int> possibleValue,
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
  // bool solveD25(EvenOdderClue clue, Set<int> possibleValue,
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
