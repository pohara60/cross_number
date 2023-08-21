/// An API for solving Letters puzzles.
library sequences;

import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/sequences/clue.dart';
import 'package:crossnumber/sequences/puzzle.dart';

/// Provide access to the Prime Cuts API.
class Sequences extends Crossnumber<SequencesPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+--+',
    '|1 |2 :  :3 :4 |5 :6 :7 |',
    '+::+::+--+:::::+::::::::+',
    '|8 :  |9 |10:  |11:  :  |',
    '+--+::+::+--+--+:::::+--+',
    '|12:  :  |13:14:  |  |15|',
    '+::+--+::+:::::+--+--+::+',
    '|16:  |17:  |18:19|20:  |',
    '+::+--+--+::+:::::+--+::+',
    '|  |21|22:  :  |23:24:  |',
    '+--+::+::+--+--+::+::+--+',
    '|25:  :  |26:27|  |28:29|',
    '+::::::::+:::::+--+::+::+',
    '|30:  :  |31:  :  :  |  |',
    '+--+--+--+--+--+--+--+--+',
  ];

  Sequences() {
    puzzle = SequencesPuzzle.grid(gridString);
    initCrossnumber();
  }

  void initCrossnumber() {
    var a2 = SequencesEntry(
      name: 'A2', length: 4, valueDesc: 'P*o + W*E + r',
      //solve: solveA2,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a2);
    var a5 = SequencesEntry(
      name: 'A5', length: 3, valueDesc: 'S + E + r*I*e/S',
      //solve: solveA5,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a5);
    var a8 = SequencesEntry(
      name: 'A8', length: 2, valueDesc: 'S + U*m/S',
      //solve: solveA8,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a8);
    var a10 = SequencesEntry(
      name: 'A10', length: 2, valueDesc: 'T + a - U',
      //solve: solveA10,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a10);
    var a11 = SequencesEntry(
      name: 'A11',
      length: 3,
      valueDesc: 'P + r + I + m + e',
      //solve: solveA11,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a11);
    var a12 = SequencesEntry(
      name: 'A12', length: 3, valueDesc: 'F + o - r - T*Y',
      //solve: solveA12,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a12);
    var a13 = SequencesEntry(
      name: 'A13',
      length: 3,
      valueDesc: 'S + P + H + e + r + e',
      //solve: solveA13,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a13);
    var a16 = SequencesEntry(
      name: 'A16',
      length: 2,
      valueDesc: 'P + O + W - E + r',
      //solve: solveA16,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a16);
    var a17 = SequencesEntry(
      name: 'A17', length: 2, valueDesc: 'S + U + m',
      //solve: solveA17,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a17);
    var a18 = SequencesEntry(
      name: 'A18', length: 2, valueDesc: 'S + I*G/M + A',
      solve: solveA18,
      //solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a18);
    var a20 = SequencesEntry(
      name: 'A20',
      length: 2,
      valueDesc: 'S + I + G + m + A',
      //solve: solveA20,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a20);
    var a22 = SequencesEntry(
      name: 'A22',
      length: 3,
      valueDesc: 'S*E*r - I + e + S',
      //solve: solveA22,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a22);
    var a23 = SequencesEntry(
      name: 'A23', length: 3, valueDesc: 'M + E + N*U*S',
      //solve: solveA23,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a23);
    var a25 = SequencesEntry(
      name: 'A25', length: 3, valueDesc: 'S*U*m',
      //solve: solveA25,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a25);
    var a26 = SequencesEntry(
      name: 'A26', length: 2, valueDesc: 'S + U*M = O',
      //solve: solveA26,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a26);
    var a28 = SequencesEntry(
      name: 'A28',
      length: 2,
      valueDesc: 'P + R - I + M - e',
      //solve: solveA28,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a28);
    var a30 = SequencesEntry(
      name: 'A30',
      length: 3,
      valueDesc: 'T + H + e = T*I*M + E + S',
      //solve: solveA30,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a30);
    var a31 = SequencesEntry(
      name: 'A31', length: 4, valueDesc: 'M*I*N*T*Y',
      //solve: solveA31,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(a31);

    var d1 = SequencesEntry(
      name: 'D1', length: 2, valueDesc: 'S + U + m*S',
      //solve: solveD1,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d1);
    var d2 = SequencesEntry(
      name: 'D2', length: 3, valueDesc: 'm*O*r + e',
      //solve: solveD2,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d2);
    var d3 = SequencesEntry(
      name: 'D3', length: 2, valueDesc: 'S + U + M',
      //solve: solveD3,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d3);
    var d4 = SequencesEntry(
      name: 'D4', length: 2, valueDesc: 'S - I*G/M + a',
      //solve: solveD4,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d4);
    var d5 = SequencesEntry(
      name: 'D5', length: 3, valueDesc: 'S*E/r + I + E*S',
      //solve: solveD5,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d5);
    var d6 = SequencesEntry(
      name: 'D6', length: 3, valueDesc: 'P*R/I + M*e',
      //solve: solveD6,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d6);
    var d7 = SequencesEntry(
      name: 'D7', length: 2, valueDesc: 'F - E + W - e + R',
      //solve: solveD7,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d7);
    var d9 = SequencesEntry(
      name: 'D9',
      length: 3,
      valueDesc: 'R*A*T/I + o',
      //solve: solveD9,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d9);
    var d12 = SequencesEntry(
      name: 'D12',
      length: 3,
      valueDesc: 'R + A - T - I + o',
      //solve: solveD12,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d12);
    var d13 = SequencesEntry(
      name: 'D13', length: 3, valueDesc: 'S + I + N + E*S',
      //solve: solveD13,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d13);
    var d14 = SequencesEntry(
      name: 'D14', length: 3, valueDesc: '-T*E + R*M',
      //solve: solveD14,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d14);
    var d15 = SequencesEntry(
      name: 'D15', length: 3, valueDesc: 'm*a + T + H',
      //solve: solveD15,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d15);
    var d19 = SequencesEntry(
      name: 'D19',
      length: 3,
      valueDesc: 'C + O + S + I*N + E',
      //solve: solveD19,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d19);
    var d21 = SequencesEntry(
      name: 'D21', length: 3, valueDesc: '-T + r*I*G',
      //solve: solveD21,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d21);
    var d22 = SequencesEntry(
      name: 'D22',
      length: 3,
      valueDesc: 'S - E + R*I - e*S',
      //solve: solveD22,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d22);
    var d24 = SequencesEntry(
      name: 'D24', length: 3, valueDesc: 'N*(A + r) - C',
      //solve: solveD24,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d24);
    var d25 = SequencesEntry(
      name: 'D25', length: 2, valueDesc: 'Y*Y + Y = I - S',
      //solve: solveD25,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d25);
    var d26 = SequencesEntry(
      name: 'D26',
      length: 2,
      valueDesc: 'S*Y*S = S*(I - S)',
      solve: solveD26,
      //solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d26);
    var d27 = SequencesEntry(
      name: 'D27',
      length: 2,
      valueDesc: 'M + E = T - I + C',
      //solve: solveD27,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d27);
    var d29 = SequencesEntry(
      name: 'D29',
      length: 2,
      valueDesc: 'N + U + m + S',
      //solve: solveD29,
      solve: puzzle.solveVariableExpressionEvaluator,
    );
    puzzle.addEntry(d29);

    puzzle.addDigitIdentityFromGrid();
    // puzzle.addDigitIdentity(a2, 1, d2, 1);
    // puzzle.addDigitIdentity(a2, 3, d3, 1);
    // puzzle.addDigitIdentity(a2, 4, d4, 1);
    // puzzle.addDigitIdentity(a5, 1, d5, 1);
    // puzzle.addDigitIdentity(a5, 2, d6, 1);
    // puzzle.addDigitIdentity(a5, 2, d7, 1);
    // puzzle.addDigitIdentity(a8, 1, d2, 2);
    // puzzle.addDigitIdentity(a8, 2, d2, 2);
    // puzzle.addDigitIdentity(a10, 1, d3, 2);
    // puzzle.addDigitIdentity(a10, 2, d4, 2);
    // puzzle.addDigitIdentity(a11, 1, d5, 2);
    // puzzle.addDigitIdentity(a11, 2, d6, 2);
    // puzzle.addDigitIdentity(a11, 3, d7, 2);
    // puzzle.addDigitIdentity(a12, 1, d12, 1);
    // puzzle.addDigitIdentity(a12, 2, d2, 3);
    // puzzle.addDigitIdentity(a12, 3, d9, 2);
    // puzzle.addDigitIdentity(a13, 1, d13, 1);
    // puzzle.addDigitIdentity(a13, 2, d14, 1);
    // puzzle.addDigitIdentity(a13, 3, d5, 3);
    // puzzle.addDigitIdentity(a16, 1, d12, 2);
    // puzzle.addDigitIdentity(a17, 1, d9, 3);
    // puzzle.addDigitIdentity(a17, 2, d13, 2);
    // puzzle.addDigitIdentity(a18, 1, d14, 2);
    // puzzle.addDigitIdentity(a18, 2, d19, 1);
    // puzzle.addDigitIdentity(a20, 2, d15, 2);
    // puzzle.addDigitIdentity(a22, 1, d22, 1);
    // puzzle.addDigitIdentity(a22, 2, d13, 3);
    // puzzle.addDigitIdentity(a22, 3, d14, 3);
    // puzzle.addDigitIdentity(a23, 1, d19, 2);
    // puzzle.addDigitIdentity(a23, 2, d24, 1);
    // puzzle.addDigitIdentity(a23, 3, d15, 3);
    // puzzle.addDigitIdentity(a25, 1, d25, 1);
    // puzzle.addDigitIdentity(a25, 2, d21, 2);
    // puzzle.addDigitIdentity(a25, 3, d22, 2);
    // puzzle.addDigitIdentity(a26, 1, d26, 1);
    // puzzle.addDigitIdentity(a26, 2, d27, 1);
    // puzzle.addDigitIdentity(a28, 1, d24, 2);
    // puzzle.addDigitIdentity(a28, 2, d29, 1);
    // puzzle.addDigitIdentity(a30, 1, d25, 2);
    // puzzle.addDigitIdentity(a30, 2, d21, 3);
    // puzzle.addDigitIdentity(a30, 3, d22, 3);
    // puzzle.addDigitIdentity(a31, 1, d26, 2);
    // puzzle.addDigitIdentity(a31, 2, d27, 2);
    // puzzle.addDigitIdentity(a31, 4, d24, 3);

    // Add letter references from descriptions
    var letters = [
      'A',
      'C',
      'E',
      'F',
      'G',
      'H',
      'I',
      'M',
      'N',
      'O',
      'P',
      'R',
      'S',
      'T',
      'U',
      'W',
      'Y',
      'a',
      'e',
      'm',
      'o',
      'r',
    ];
    for (var letter in letters) {
      puzzle.letters[letter] = SequenceVariable(letter);
      for (var clue in puzzle.clues.values) {
        if (clue.valueDesc!.contains(letter)) {
          clue.addLetterReference(letter);
        }
      }
    }

    if (Crossnumber.traceInit) {
      print(puzzle.toString());
    }
  }

  solveA2(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var P = letters[index++];
      var W = letters[index++];
      var o = letters[index++];
      var r = letters[index++];
      return P * o + W * E + r;
    });
    return updated;
  }

  solveA5(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var I = letters[index++];
      var S = letters[index++];
      var e = letters[index++];
      var r = letters[index++];
      if (r * I * e % S != 0) return 0;
      return S + E + r * I * e ~/ S;
    });
    return updated;
  }

  solveA8(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var S = letters[index++];
      var U = letters[index++];
      var m = letters[index++];
      if (U * m % S != 0) return 0;
      return S + U * m ~/ S;
    });
    return updated;
  }

  bool solveA10(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var T = letters[index++];
      var U = letters[index++];
      var a = letters[index++];
      return T + a - U;
    });
    return updated;
  }

  bool solveA11(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var I = letters[index++];
      var P = letters[index++];
      var e = letters[index++];
      var m = letters[index++];
      var r = letters[index++];
      return P + r + I + m + e;
    });
    return updated;
  }

  bool solveA12(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var F = letters[index++];
      var T = letters[index++];
      var Y = letters[index++];
      var o = letters[index++];
      var r = letters[index++];
      return F + o - r - T * Y;
    });
    return updated;
  }

  bool solveA13(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var H = letters[index++];
      var P = letters[index++];
      var S = letters[index++];
      var e = letters[index++];
      var r = letters[index++];
      return S + P + H + e + r + e;
    });
    return updated;
  }

  bool solveA16(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var O = letters[index++];
      var P = letters[index++];
      var W = letters[index++];
      var r = letters[index++];
      return P + O + W - E + r;
    });
    return updated;
  }

  bool solveA17(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var S = letters[index++];
      var U = letters[index++];
      var m = letters[index++];
      return S + U + m;
    });
    return updated;
  }

  bool solveA18(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var A = letters[index++];
      var G = letters[index++];
      var I = letters[index++];
      var M = letters[index++];
      var S = letters[index++];
      if (I * G % M != 0) return 0;
      return S + I * G ~/ M + A;
    });
    return updated;
  }

  bool solveA20(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var A = letters[index++];
      var G = letters[index++];
      var I = letters[index++];
      var S = letters[index++];
      var m = letters[index++];
      return S + I + G + m + A;
    });
    return updated;
  }

  bool solveA22(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var I = letters[index++];
      var S = letters[index++];
      var e = letters[index++];
      var r = letters[index++];
      return S * E * r - I + e + S;
    });
    return updated;
  }

  bool solveA23(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var M = letters[index++];
      var N = letters[index++];
      var S = letters[index++];
      var U = letters[index++];
      return M + E + N * U * S;
    });
    return updated;
  }

  bool solveA25(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var S = letters[index++];
      var U = letters[index++];
      var m = letters[index++];
      return S * U * m;
    });
    return updated;
  }

  bool solveA26(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var M = letters[index++];
      var O = letters[index++];
      var S = letters[index++];
      var U = letters[index++];
      if (S + U * M != O) return 0;
      return S + U * M;
    });
    return updated;
  }

  bool solveA28(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var I = letters[index++];
      var M = letters[index++];
      var P = letters[index++];
      var R = letters[index++];
      var e = letters[index++];
      return P + R - I + M - e;
    });
    return updated;
  }

  bool solveA30(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var H = letters[index++];
      var I = letters[index++];
      var M = letters[index++];
      var S = letters[index++];
      var T = letters[index++];
      var e = letters[index++];
      if (T + H + e != T * I * M + E + S) return 0;
      return T + H + e;
    });
    return updated;
  }

  bool solveA31(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var I = letters[index++];
      var M = letters[index++];
      var N = letters[index++];
      var T = letters[index++];
      var Y = letters[index++];
      return M * I * N * T * Y;
    });
    return updated;
  }

  bool solveD1(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var S = letters[index++];
      var U = letters[index++];
      var m = letters[index++];
      return S + U + m * S;
    });
    return updated;
  }

  bool solveD2(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var O = letters[index++];
      var e = letters[index++];
      var m = letters[index++];
      var r = letters[index++];
      return m * O * r + e;
    });
    return updated;
  }

  bool solveD3(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var S = letters[index++];
      var M = letters[index++];
      var U = letters[index++];
      return S + U + M;
    });
    return updated;
  }

  bool solveD4(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var G = letters[index++];
      var I = letters[index++];
      var M = letters[index++];
      var S = letters[index++];
      var a = letters[index++];
      if (I * G % M != 0) return 0;
      return S - I * G ~/ M + a;
    });
    return updated;
  }

  bool solveD5(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var I = letters[index++];
      var S = letters[index++];
      var r = letters[index++];
      if (S * E % r != 0) return 0;
      return S * E ~/ r + I + E * S;
    });
    return updated;
  }

  bool solveD6(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var I = letters[index++];
      var M = letters[index++];
      var P = letters[index++];
      var R = letters[index++];
      var e = letters[index++];
      if (P * R % I != 0) return 0;
      return P * R ~/ I + M * e;
    });
    return updated;
  }

  bool solveD7(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var F = letters[index++];
      var R = letters[index++];
      var W = letters[index++];
      var e = letters[index++];
      return F - E + W - e + R;
    });
    return updated;
  }

  bool solveD9(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var A = letters[index++];
      var I = letters[index++];
      var R = letters[index++];
      var T = letters[index++];
      var o = letters[index++];
      if (R * A * T % I != 0) return 0;
      return R * A * T ~/ I + o;
    });
    return updated;
  }

  bool solveD12(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var A = letters[index++];
      var I = letters[index++];
      var R = letters[index++];
      var T = letters[index++];
      var o = letters[index++];
      return R + A - T - I + o;
    });
    return updated;
  }

  bool solveD13(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var I = letters[index++];
      var N = letters[index++];
      var S = letters[index++];
      return S + I + N + E * S;
    });
    return updated;
  }

  bool solveD14(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var M = letters[index++];
      var R = letters[index++];
      var T = letters[index++];
      return -T * E + R * M;
    });
    return updated;
  }

  bool solveD15(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var H = letters[index++];
      var T = letters[index++];
      var a = letters[index++];
      var m = letters[index++];
      return m * a + T + H;
    });
    return updated;
  }

  bool solveD19(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var C = letters[index++];
      var E = letters[index++];
      var I = letters[index++];
      var N = letters[index++];
      var O = letters[index++];
      var S = letters[index++];
      return C + O + S + I * N + E;
    });
    return updated;
  }

  bool solveD21(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var G = letters[index++];
      var I = letters[index++];
      var T = letters[index++];
      var r = letters[index++];
      return -T + r * I * G;
    });
    return updated;
  }

  bool solveD22(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var E = letters[index++];
      var I = letters[index++];
      var R = letters[index++];
      var S = letters[index++];
      var e = letters[index++];
      return S - E + R * I - e * S;
    });
    return updated;
  }

  bool solveD24(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var A = letters[index++];
      var C = letters[index++];
      var N = letters[index++];
      var r = letters[index++];
      return N * (A + r) - C;
    });
    return updated;
  }

  // bool solveD25(SequencesEntry clue, Set<int> possibleValue,
  //     Map<String, Set<int>> possibleLetters) {
  //   var updated = false;
  //   puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
  //       (letters) {
  //     var index = 0;
  //     var I = letters[index++];
  //     var S = letters[index++];
  //     var Y = letters[index++];
  //     if (Y * Y + Y != I - S) return 0;
  //     return Y * Y + Y;
  //   });
  //   return updated;
  // }

  // bool solveD26(SequencesEntry clue, Set<int> possibleValue,
  //     Map<String, Set<int>> possibleLetters) {
  //   var updated = false;
  //   puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
  //       (letters) {
  //     var index = 0;
  //     var I = letters[index++];
  //     var S = letters[index++];
  //     var Y = letters[index++];
  //     if (S * Y * S != S * (I - S)) return 0;
  //     return S * Y * S;
  //   });
  //   return updated;
  // }

  bool solveD27(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var C = letters[index++];
      var E = letters[index++];
      var I = letters[index++];
      var M = letters[index++];
      var T = letters[index++];
      if (M + E != T - I + C) return 0;
      return M + E;
    });
    return updated;
  }

  bool solveD29(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var N = letters[index++];
      var S = letters[index++];
      var U = letters[index++];
      var m = letters[index++];
      return N + U + m + S;
    });
    return updated;
  }

  bool solveD25(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    final stopwatch = Stopwatch()..start();
    var count = 0;
    var updated = false;
    for (var Y
        in puzzle.letters['Y']!.values!.where((element) => element < 10)) {
      for (var S
          in puzzle.letters['S']!.values!.where((element) => element != Y)) {
        for (var I in puzzle.letters['I']!.values!
            .where((element) => element != S && element != Y)) {
          count++;
          var value = Y * Y + Y;
          if (value >= 10 && value < 100 && value == (I - S)) {
            if (clue.digitsMatch(value)) {
              possibleValue.add(value);
              possibleLetters['S']!.add(S);
              possibleLetters['Y']!.add(Y);
              possibleLetters['I']!.add(I);
            }
          }
        }
      }
    }
    if (Crossnumber.traceSolve) {
      print(
          'Solve ${clue.name} iterations=$count, elapsed ${stopwatch.elapsed}');
    }
    return updated;
  }

  bool solveD26(SequencesEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    final stopwatch = Stopwatch()..start();
    var count = 0;
    var updated = false;
    for (var S
        in puzzle.letters['S']!.values!.where((element) => element < 10)) {
      for (var Y in puzzle.letters['Y']!.values!
          .where((element) => element < 100 && element != S)) {
        for (var I in puzzle.letters['I']!.values!.where(
            (element) => element < 100 && element != S && element != Y)) {
          count++;
          var value = S * Y * S;
          if (value >= 10 && value < 100 && value == S * (I - S)) {
            if (clue.digitsMatch(value)) {
              possibleValue.add(value);
              possibleLetters['S']!.add(S);
              possibleLetters['Y']!.add(Y);
              possibleLetters['I']!.add(I);
            }
          }
        }
      }
    }
    if (Crossnumber.traceSolve) {
      print(
          'Solve ${clue.name} iterations=$count, elapsed ${stopwatch.elapsed}');
    }
    return updated;
  }

  void solve([bool iteration = true]) {
    print("SOLVE------------");
    // Manual sequencing of solution saves 20 iterations
    // solveClue(this.puzzle.clues['D26']!);
    // solveClue(this.puzzle.clues['D25']!);
    // solveClue(this.puzzle.clues['D26']!);
    // solveClue(this.puzzle.clues['A18']!);
    // solveClue(this.puzzle.clues['A20']!);
    // solveClue(this.puzzle.clues['A18']!);
    // solveClue(this.puzzle.clues['D4']!);
    // solveClue(this.puzzle.clues['A17']!);
    // solveClue(this.puzzle.clues['A8']!);
    // solveClue(this.puzzle.clues['A25']!);
    // solveClue(this.puzzle.clues['A26']!);
    super.solve(iteration);
  }
}
