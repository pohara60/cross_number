/// An API for solving Letters puzzles.
library sequences;

import '../crossnumber.dart';
import '../puzzle.dart';
import '../sequences/clue.dart';
import '../sequences/puzzle.dart';
import '../variable.dart';

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
    puzzle = SequencesPuzzle.fromGridString(gridString);
    initCrossnumber();
  }

  SolveFunction solveWrapper(
      bool Function(SequencesEntry clue, Set<int> possibleValue,
              Map<String, Set<int>> possibleLetters)
          solve) {
    bool solveSequencesClue(
      Puzzle p,
      Variable v,
      Set<int> possibleValue, {
      Set<int>? possibleValue2,
      Map<String, Set<int>>? possibleVariables,
      Map<String, Set<int>>? possibleVariables2,
      Set<String>? updatedVariables,
    }) {
      var clue = v as SequencesEntry;
      return solve(clue, possibleValue, possibleVariables!);
    }

    return solveSequencesClue;
  }

  void initCrossnumber() {
    var a2 = SequencesEntry(
      name: 'A2', length: 4, valueDesc: 'P*o + W*E + r',
      //solve: solveA2,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a2);
    var a5 = SequencesEntry(
      name: 'A5', length: 3, valueDesc: 'S + E + r*I*e/S',
      //solve: solveA5,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a5);
    var a8 = SequencesEntry(
      name: 'A8', length: 2, valueDesc: 'S + U*m/S',
      //solve: solveA8,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a8);
    var a10 = SequencesEntry(
      name: 'A10', length: 2, valueDesc: 'T + a - U',
      //solve: solveA10,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a10);
    var a11 = SequencesEntry(
      name: 'A11',
      length: 3,
      valueDesc: 'P + r + I + m + e',
      //solve: solveA11,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a11);
    var a12 = SequencesEntry(
      name: 'A12', length: 3, valueDesc: 'F + o - r - T*Y',
      //solve: solveA12,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a12);
    var a13 = SequencesEntry(
      name: 'A13',
      length: 3,
      valueDesc: 'S + P + H + e + r + e',
      //solve: solveA13,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a13);
    var a16 = SequencesEntry(
      name: 'A16',
      length: 2,
      valueDesc: 'P + O + W - E + r',
      //solve: solveA16,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a16);
    var a17 = SequencesEntry(
      name: 'A17', length: 2, valueDesc: 'S + U + m',
      //solve: solveA17,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a17);
    var a18 = SequencesEntry(
      name: 'A18', length: 2, valueDesc: 'S + I*G/M + A',
      solve: solveWrapper(solveA18),
      //solve: solveSequencesClue,
    );
    puzzle.addEntry(a18);
    var a20 = SequencesEntry(
      name: 'A20',
      length: 2,
      valueDesc: 'S + I + G + m + A',
      //solve: solveA20,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a20);
    var a22 = SequencesEntry(
      name: 'A22',
      length: 3,
      valueDesc: 'S*E*r - I + e + S',
      //solve: solveA22,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a22);
    var a23 = SequencesEntry(
      name: 'A23', length: 3, valueDesc: 'M + E + N*U*S',
      //solve: solveA23,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a23);
    var a25 = SequencesEntry(
      name: 'A25', length: 3, valueDesc: 'S*U*m',
      //solve: solveA25,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a25);
    var a26 = SequencesEntry(
      name: 'A26', length: 2, valueDesc: 'S + U*M = O',
      //solve: solveA26,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a26);
    var a28 = SequencesEntry(
      name: 'A28',
      length: 2,
      valueDesc: 'P + R - I + M - e',
      //solve: solveA28,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a28);
    var a30 = SequencesEntry(
      name: 'A30',
      length: 3,
      valueDesc: 'T + H + e = T*I*M + E + S',
      //solve: solveA30,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a30);
    var a31 = SequencesEntry(
      name: 'A31', length: 4, valueDesc: 'M*I*N*T*Y',
      //solve: solveA31,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(a31);

    var d1 = SequencesEntry(
      name: 'D1', length: 2, valueDesc: 'S + U + m*S',
      //solve: solveD1,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d1);
    var d2 = SequencesEntry(
      name: 'D2', length: 3, valueDesc: 'm*O*r + e',
      //solve: solveD2,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d2);
    var d3 = SequencesEntry(
      name: 'D3', length: 2, valueDesc: 'S + U + M',
      //solve: solveD3,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d3);
    var d4 = SequencesEntry(
      name: 'D4', length: 2, valueDesc: 'S - I*G/M + a',
      //solve: solveD4,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d4);
    var d5 = SequencesEntry(
      name: 'D5', length: 3, valueDesc: 'S*E/r + I + E*S',
      //solve: solveD5,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d5);
    var d6 = SequencesEntry(
      name: 'D6', length: 3, valueDesc: 'P*R/I + M*e',
      //solve: solveD6,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d6);
    var d7 = SequencesEntry(
      name: 'D7', length: 2, valueDesc: 'F - E + W - e + R',
      //solve: solveD7,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d7);
    var d9 = SequencesEntry(
      name: 'D9',
      length: 3,
      valueDesc: 'R*A*T/I + o',
      //solve: solveD9,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d9);
    var d12 = SequencesEntry(
      name: 'D12',
      length: 3,
      valueDesc: 'R + A - T - I + o',
      //solve: solveD12,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d12);
    var d13 = SequencesEntry(
      name: 'D13', length: 3, valueDesc: 'S + I + N + E*S',
      //solve: solveD13,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d13);
    var d14 = SequencesEntry(
      name: 'D14', length: 3, valueDesc: '-T*E + R*M',
      //solve: solveD14,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d14);
    var d15 = SequencesEntry(
      name: 'D15', length: 3, valueDesc: 'm*a + T + H',
      //solve: solveD15,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d15);
    var d19 = SequencesEntry(
      name: 'D19',
      length: 3,
      valueDesc: 'C + O + S + I*N + E',
      //solve: solveD19,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d19);
    var d21 = SequencesEntry(
      name: 'D21', length: 3, valueDesc: '-T + r*I*G',
      //solve: solveD21,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d21);
    var d22 = SequencesEntry(
      name: 'D22',
      length: 3,
      valueDesc: 'S - E + R*I - e*S',
      //solve: solveD22,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d22);
    var d24 = SequencesEntry(
      name: 'D24', length: 3, valueDesc: 'N*(A + r) - C',
      //solve: solveD24,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d24);
    var d25 = SequencesEntry(
      name: 'D25', length: 2, valueDesc: 'Y*Y + Y = I - S',
      //solve: solveD25,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d25);
    var d26 = SequencesEntry(
      name: 'D26',
      length: 2,
      valueDesc: 'S*Y*S = S*(I - S)',
      solve: solveWrapper(solveD26),
      //solve: solveSequencesClue,
    );
    puzzle.addEntry(d26);
    var d27 = SequencesEntry(
      name: 'D27',
      length: 2,
      valueDesc: 'M + E = T - I + C',
      //solve: solveD27,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d27);
    var d29 = SequencesEntry(
      name: 'D29',
      length: 2,
      valueDesc: 'N + U + m + S',
      //solve: solveD29,
      solve: solveSequencesClue,
    );
    puzzle.addEntry(d29);

    puzzle.linkEntriesToGrid();

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
      puzzle.addVariable(SequenceVariable(letter));
      for (var clue in puzzle.clues.values) {
        if (clue.valueDesc!.contains(letter)) {
          clue.addLetterReference(letter);
        }
      }
    }

    var clueError = '';
    // clueError = puzzle.checkClueEntryReferences();
    clueError = puzzle.checkClueClueReferences();
    // clueError += puzzle.checkEntryClueReferences();
    // clueError += puzzle.checkEntryEntryReferences();
    // Check variabes last, as prceeding may update them
    clueError += puzzle.checkVariableReferences();
    if (clueError != '') throw PuzzleException(clueError);

    super.initCrossnumber();
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
        in puzzle.variables['Y']!.values!.where((element) => element < 10)) {
      for (var S
          in puzzle.variables['S']!.values!.where((element) => element != Y)) {
        for (var I in puzzle.variables['I']!.values!
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
        in puzzle.variables['S']!.values!.where((element) => element < 10)) {
      for (var Y in puzzle.variables['Y']!.values!
          .where((element) => element < 100 && element != S)) {
        for (var I in puzzle.variables['I']!.values!.where(
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

  // Clue solver invokes generic expression evaluator with validator
  bool solveSequencesClue(
    Puzzle p,
    Variable v,
    Set<int> possibleValue, {
    Set<int>? possibleValue2,
    Map<String, Set<int>>? possibleVariables,
    Map<String, Set<int>>? possibleVariables2,
    Set<String>? updatedVariables,
  }) {
    var puzzle = p as SequencesPuzzle;
    var clue = v as SequencesClue;

    var updated = false;
    if (clue.valueDesc != null && clue.valueDesc != '') {
      updated = puzzle.solveVariableExpressionEvaluator(
          clue, clue.exp, possibleValue, possibleVariables!);
    }
    return updated;
  }
}
