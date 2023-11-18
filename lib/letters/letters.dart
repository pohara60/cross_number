/// An API for solving Letters puzzles.
library letters;

import '../crossnumber.dart';
import '../cartesian.dart';
import '../letters/clue.dart';
import '../letters/puzzle.dart';
import '../puzzle.dart';
import '../variable.dart';

/// Provide access to the Prime Cuts API.
class Letters extends Crossnumber<LettersPuzzle> {
  var gridString = [
    '+--+--+--+--+--+--+',
    '|1 :2 |3 |4 :5 |6 |',
    '+:::::::::::::::::+',
    '|  |7 :  :  |8 :  |',
    '+::::::--+::|:::::+',
    '|9 :  :10|  |11:  |',
    '+-----+::|::+-----+',
    '|12:13|  |14:15:16|',
    '+:::::|::+--::::::+',
    '|17:  |18:19:  |  |',
    '+:::::|::::::::|::+',
    '|  |20:  |  |21:  |',
    '+--+--+--+--+--+--+',
  ];

  Letters() {
    puzzle = LettersPuzzle.grid(gridString);
    initCrossnumber();
  }

  SolveFunction solveWrapper(
      bool Function(LettersEntry clue, Set<int> possibleValue,
              Map<String, Set<int>> possibleLetters)
          solve) {
    bool solveLettersClue(
      Puzzle p,
      Variable v,
      Set<int> possibleValue, {
      Set<int>? possibleValue2,
      Map<String, Set<int>>? possibleVariables,
      Map<String, Set<int>>? possibleVariables2,
      Set<String>? updatedVariables,
    }) {
      var clue = v as LettersEntry;
      return solve(clue, possibleValue, possibleVariables!);
    }

    return solveLettersClue;
  }

  void initCrossnumber() {
    var a1 = LettersEntry(
        name: 'A1',
        length: 2,
        valueDesc: 'R(A+P)',
        solve: solveWrapper(solveA1));
    puzzle.addEntry(a1);
    var a4 = LettersEntry(
        name: 'A4',
        length: 2,
        valueDesc: 'D(U+E)',
        solve: solveWrapper(solveA4));
    puzzle.addEntry(a4);
    var a7 = LettersEntry(
        name: 'A7',
        length: 3,
        valueDesc: 'PEEPE-R+S+((E-Y+E)/S)',
        solve: solveWrapper(solveA7));
    puzzle.addEntry(a7);
    var a8 = LettersEntry(
        name: 'A8',
        length: 2,
        valueDesc: 'PUPAS',
        solve: solveWrapper(solveA8));
    puzzle.addEntry(a8);
    var a9 = LettersEntry(
        name: 'A9',
        length: 3,
        valueDesc: '(ST-R+A-Y)ED',
        solve: solveWrapper(solveA9));
    puzzle.addEntry(a9);
    var a11 = LettersEntry(
        name: 'A11',
        length: 2,
        valueDesc: 'ASP',
        solve: solveWrapper(solveA11));
    puzzle.addEntry(a11);
    var a12 = LettersEntry(
        name: 'A12',
        length: 2,
        valueDesc: 'PUPPY',
        solve: solveWrapper(solveA12));
    puzzle.addEntry(a12);
    var a14 = LettersEntry(
        name: 'A14',
        length: 3,
        valueDesc: 'SY(RU+P+S)',
        solve: solveWrapper(solveA14));
    puzzle.addEntry(a14);
    var a17 = LettersEntry(
        name: 'A17',
        length: 2,
        valueDesc: 'YE+S',
        solve: solveWrapper(solveA17));
    puzzle.addEntry(a17);
    var a18 = LettersEntry(
        name: 'A18',
        length: 3,
        valueDesc: 'S(USSE+D)',
        solve: solveWrapper(solveA18));
    puzzle.addEntry(a18);
    var a20 = LettersEntry(
        name: 'A20',
        length: 2,
        valueDesc: 'TE+(D/D)Y',
        solve: solveWrapper(solveA20));
    puzzle.addEntry(a20);
    var a21 = LettersEntry(
        name: 'A21',
        length: 2,
        valueDesc: '(PEPP/E+R)E+D',
        solve: solveWrapper(solveA21));
    puzzle.addEntry(a21);

    var d1 = LettersEntry(
        name: 'D1',
        length: 3,
        valueDesc: 'Y(E+(A+S)T-S)',
        solve: solveWrapper(solveD1));
    puzzle.addEntry(d1);
    var d2 = LettersEntry(
        name: 'D2',
        length: 3,
        valueDesc: 'SEES-(P+E+A+R)S',
        solve: solveWrapper(solveD2));
    puzzle.addEntry(d2);
    var d3 = LettersEntry(
        name: 'D3', length: 2, valueDesc: 'PRY', solve: solveWrapper(solveD3));
    puzzle.addEntry(d3);
    var d4 = LettersEntry(
        name: 'D4',
        length: 4,
        valueDesc: 'YAYA+D+A+D-A+S',
        solve: solveWrapper(solveD4));
    puzzle.addEntry(d4);
    var d5 = LettersEntry(
        name: 'D5',
        length: 3,
        valueDesc: 'PR+Y+EYE',
        solve: solveWrapper(solveD5));
    puzzle.addEntry(d5);
    var d6 = LettersEntry(
        name: 'D6',
        length: 3,
        valueDesc: 'DAYS-(T+A)U',
        solve: solveWrapper(solveD6));
    puzzle.addEntry(d6);
    var d10 = LettersEntry(
        name: 'D10',
        length: 4,
        valueDesc: 'YESTE-R(D+A-Y)-S',
        solve: solveWrapper(solveD10));
    puzzle.addEntry(d10);
    var d12 = LettersEntry(
        name: 'D12',
        length: 3,
        valueDesc: 'EYE-SPY+PUD',
        solve: solveWrapper(solveD12));
    puzzle.addEntry(d12);
    var d13 = LettersEntry(
        name: 'D13',
        length: 3,
        valueDesc: 'ERR',
        solve: solveWrapper(solveD13));
    puzzle.addEntry(d13);
    var d15 = LettersEntry(
        name: 'D15',
        length: 3,
        valueDesc: 'RAT+ES',
        solve: solveWrapper(solveD15));
    puzzle.addEntry(d15);
    var d16 = LettersEntry(
        name: 'D16',
        length: 3,
        valueDesc: 'DREY-TU+P',
        solve: solveWrapper(solveD16));
    puzzle.addEntry(d16);
    var d19 = LettersEntry(
        name: 'D19',
        length: 2,
        valueDesc: 'RAP',
        solve: solveWrapper(solveD19));
    puzzle.addEntry(d19);

    puzzle.addDigitIdentity(a1, 1, d1, 1);
    puzzle.addDigitIdentity(a1, 2, d2, 1);
    puzzle.addDigitIdentity(a4, 1, d4, 1);
    puzzle.addDigitIdentity(a4, 2, d5, 1);
    puzzle.addDigitIdentity(a7, 1, d2, 2);
    puzzle.addDigitIdentity(a7, 2, d3, 2);
    puzzle.addDigitIdentity(a8, 1, d5, 2);
    puzzle.addDigitIdentity(a8, 2, d6, 2);
    puzzle.addDigitIdentity(a9, 1, d1, 3);
    puzzle.addDigitIdentity(a9, 2, d2, 3);
    puzzle.addDigitIdentity(a9, 3, d10, 1);
    puzzle.addDigitIdentity(a11, 1, d5, 3);
    puzzle.addDigitIdentity(a11, 2, d6, 3);
    puzzle.addDigitIdentity(a12, 1, d12, 1);
    puzzle.addDigitIdentity(a12, 2, d13, 1);
    puzzle.addDigitIdentity(a14, 1, d4, 4);
    puzzle.addDigitIdentity(a14, 2, d15, 1);
    puzzle.addDigitIdentity(a14, 3, d16, 1);
    puzzle.addDigitIdentity(a17, 1, d12, 2);
    puzzle.addDigitIdentity(a17, 2, d13, 2);
    puzzle.addDigitIdentity(a18, 1, d10, 3);
    puzzle.addDigitIdentity(a18, 2, d19, 1);
    puzzle.addDigitIdentity(a18, 3, d15, 2);
    puzzle.addDigitIdentity(a20, 1, d13, 3);
    puzzle.addDigitIdentity(a20, 2, d10, 4);
    puzzle.addDigitIdentity(a21, 1, d15, 3);
    puzzle.addDigitIdentity(a21, 2, d16, 3);

    // Add letter references from descriptions
    var letters = ['A', 'D', 'E', 'P', 'R', 'S', 'T', 'U', 'Y'];
    for (var letter in letters) {
      puzzle.letters[letter] = LetterVariable(letter);
      for (var clue in puzzle.clues.values) {
        if (clue.valueDesc!.contains(letter)) {
          clue.addLetterReference(letter);
        }
      }
    }

    super.initCrossnumber();
  }

  bool solveA1(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var r in puzzle.letters['R']!.values!) {
      for (var a
          in puzzle.letters['A']!.values!.where((element) => element != r)) {
        for (var p in puzzle.letters['P']!.values!
            .where((element) => element != r && element != a)) {
          var value = r * (a + p);
          if (value >= 10 && value < 100) {
            possibleValue.add(value);
            possibleLetters['R']!.add(r);
            possibleLetters['A']!.add(a);
            possibleLetters['P']!.add(p);
          }
        }
      }
    }
    return updated;
  }

  bool solveA4(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var d in puzzle.letters['D']!.values!) {
      for (var u
          in puzzle.letters['U']!.values!.where((element) => element != d)) {
        for (var e in puzzle.letters['E']!.values!
            .where((element) => element != d && element != u)) {
          var value = d * (u + e);
          if (value >= 10 && value < 100) {
            possibleValue.add(value);
            possibleLetters['D']!.add(d);
            possibleLetters['U']!.add(u);
            possibleLetters['E']!.add(e);
          }
        }
      }
    }
    return updated;
  }

  bool solveA7(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var p in puzzle.letters['P']!.values!) {
      for (var e
          in puzzle.letters['E']!.values!.where((element) => element != p)) {
        for (var r in puzzle.letters['R']!.values!
            .where((element) => element != p && element != e)) {
          for (var s in puzzle.letters['S']!.values!.where(
              (element) => element != p && element != e && element != r)) {
            for (var y in puzzle.letters['Y']!.values!.where((element) =>
                element != p && element != e && element != r && element != s)) {
              var mul = (e - y + e);
              var div = (mul ~/ s);
              if (mul == div * s) {
                var value = p * e * e * p * e - r + s + div;
                if (value >= 100 && value < 1000) {
                  possibleValue.add(value);
                  possibleLetters['P']!.add(p);
                  possibleLetters['E']!.add(e);
                  possibleLetters['R']!.add(r);
                  possibleLetters['S']!.add(s);
                  possibleLetters['Y']!.add(y);
                }
              }
            }
          }
        }
      }
    }
    return updated;
  }

  bool solveA8(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var p in puzzle.letters['P']!.values!) {
      for (var u
          in puzzle.letters['U']!.values!.where((element) => element != p)) {
        for (var a in puzzle.letters['A']!.values!
            .where((element) => element != p && element != u)) {
          for (var s in puzzle.letters['S']!.values!.where(
              (element) => element != p && element != u && element != a)) {
            var value = p * u * p * a * s;
            if (value >= 10 && value < 100) {
              possibleValue.add(value);
              possibleLetters['P']!.add(p);
              possibleLetters['U']!.add(u);
              possibleLetters['A']!.add(a);
              possibleLetters['S']!.add(s);
            }
          }
        }
      }
    }
    return updated;
  }

  bool solveA9(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var product in cartesian([
      puzzle.letters['S']!.values!.toList(),
      puzzle.letters['T']!.values!.toList(),
      puzzle.letters['R']!.values!.toList(),
      puzzle.letters['A']!.values!.toList(),
      puzzle.letters['Y']!.values!.toList(),
      puzzle.letters['E']!.values!.toList(),
      puzzle.letters['D']!.values!.toList(),
    ])) {
      var s = product[0];
      var t = product[1];
      var r = product[2];
      var a = product[3];
      var y = product[4];
      var e = product[5];
      var d = product[6];
      var value = (s * t - r + a - y) * e * d;
      if (value >= 100 && value < 1000) {
        possibleValue.add(value);
        possibleLetters['S']!.add(s);
        possibleLetters['T']!.add(t);
        possibleLetters['R']!.add(r);
        possibleLetters['A']!.add(a);
        possibleLetters['Y']!.add(y);
        possibleLetters['E']!.add(e);
        possibleLetters['D']!.add(d);
      }
    }
    return updated;
  }

  bool solveA11(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var a = letters[index++];
      var p = letters[index++];
      var s = letters[index++];
      return a * s * p;
    });
    return updated;
  }

  bool solveA12(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var p = letters[index++];
      var u = letters[index++];
      var y = letters[index++];
      return p * u * p * p * y;
    });
    return updated;
  }

  bool solveA14(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var p = letters[index++];
      var r = letters[index++];
      var s = letters[index++];
      var u = letters[index++];
      var y = letters[index++];
      return s * y * (r * u + p + s);
    });
    return updated;
  }

  bool solveA17(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var e = letters[index++];
      var s = letters[index++];
      var y = letters[index++];
      return y * e + s;
    });
    return updated;
  }

  bool solveA18(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var d = letters[index++];
      var e = letters[index++];
      var s = letters[index++];
      var u = letters[index++];
      return s * (u * s * s * e + d);
    });
    return updated;
  }

  bool solveA20(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var d = letters[index++];
      var e = letters[index++];
      var t = letters[index++];
      var y = letters[index++];
      return t * e + (d ~/ d) * y;
    });
    return updated;
  }

  bool solveA21(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var d = letters[index++];
      var e = letters[index++];
      var p = letters[index++];
      var r = letters[index++];
      var result = (p * e * p * p ~/ e + r) * e + d;
      return result;
    });
    return updated;
  }

  bool solveD1(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var a = letters[index++];
      var e = letters[index++];
      var s = letters[index++];
      var t = letters[index++];
      var y = letters[index++];
      return y * (e + (a + s) * t - s);
    });
    return updated;
  }

  bool solveD2(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var a = letters[index++];
      var e = letters[index++];
      var p = letters[index++];
      var r = letters[index++];
      var s = letters[index++];
      return s * e * e * s - (p + e + a + r) * s;
    });
    return updated;
  }

  bool solveD3(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var p = letters[index++];
      var r = letters[index++];
      var y = letters[index++];
      return p * r * y;
    });
    return updated;
  }

  bool solveD4(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var a = letters[index++];
      var d = letters[index++];
      var s = letters[index++];
      var y = letters[index++];
      return y * a * y * a + d + a + d - a + s;
    });
    return updated;
  }

  bool solveD5(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var e = letters[index++];
      var p = letters[index++];
      var r = letters[index++];
      var y = letters[index++];
      return p * r + y + e * y * e;
    });
    return updated;
  }

  bool solveD6(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var a = letters[index++];
      var d = letters[index++];
      var s = letters[index++];
      var t = letters[index++];
      var u = letters[index++];
      var y = letters[index++];
      return d * a * y * s - (t + a) * u;
    });
    return updated;
  }

  bool solveD10(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var a = letters[index++];
      var d = letters[index++];
      var e = letters[index++];
      var r = letters[index++];
      var s = letters[index++];
      var t = letters[index++];
      var y = letters[index++];
      return y * e * s * t * e - r * (d + a - y) - s;
    });
    return updated;
  }

  bool solveD12(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var d = letters[index++];
      var e = letters[index++];
      var p = letters[index++];
      var s = letters[index++];
      var u = letters[index++];
      var y = letters[index++];
      return e * y * e - s * p * y + p * u * d;
    });
    return updated;
  }

  bool solveD13(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var e = letters[index++];
      var r = letters[index++];
      return e * r * r;
    });
    return updated;
  }

  bool solveD15(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var a = letters[index++];
      var e = letters[index++];
      var r = letters[index++];
      var s = letters[index++];
      var t = letters[index++];
      return r * a * t + e * s;
    });
    return updated;
  }

  bool solveD16(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var d = letters[index++];
      var e = letters[index++];
      var p = letters[index++];
      var r = letters[index++];
      var t = letters[index++];
      var u = letters[index++];
      var y = letters[index++];
      return d * r * e * y - t * u + p;
    });
    return updated;
  }

  bool solveD19(LettersEntry clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    puzzle.solveVariableExpression(clue, possibleValue, possibleLetters,
        (letters) {
      var index = 0;
      var a = letters[index++];
      var p = letters[index++];
      var r = letters[index++];
      return r * a * p;
    });
    return updated;
  }
}
