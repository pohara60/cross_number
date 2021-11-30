/// An API for solving Letters puzzles.
library letters;

import 'package:powers/powers.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/set.dart';
import 'package:crossnumber/letters/cartesian.dart';
import 'package:crossnumber/letters/clue.dart';
import 'package:crossnumber/letters/puzzle.dart';

/// Provide access to the Prime Cuts API.
class Letters extends Crossnumber<LettersPuzzle> {
  Letters() {
    puzzle = LettersPuzzle();
    initCrossnumber();
  }

  void initCrossnumber() {
    puzzle.clues = {};

    var a1 =
        LettersClue(name: 'A1', length: 2, valueDesc: 'R(A+P)', solve: solveA1);
    puzzle.addClue(a1);
    var a4 =
        LettersClue(name: 'A4', length: 2, valueDesc: 'D(U+E)', solve: solveA4);
    puzzle.addClue(a4);
    var a7 = LettersClue(
        name: 'A7',
        length: 3,
        valueDesc: 'PEEPE-R+S+((E-Y+E)/S)',
        solve: solveA7);
    puzzle.addClue(a7);
    var a8 =
        LettersClue(name: 'A8', length: 2, valueDesc: 'PUPAS', solve: solveA8);
    puzzle.addClue(a8);
    var a9 = LettersClue(
        name: 'A9', length: 3, valueDesc: '(ST-R+A-Y)ED', solve: solveA9);
    puzzle.addClue(a9);
    var a11 =
        LettersClue(name: 'A11', length: 2, valueDesc: 'ASP', solve: solveA11);
    puzzle.addClue(a11);
    var a12 = LettersClue(
        name: 'A12', length: 2, valueDesc: 'PUPPY', solve: solveA12);
    puzzle.addClue(a12);
    var a14 = LettersClue(
        name: 'A14', length: 3, valueDesc: 'SY(RU+P+S)', solve: solveA14);
    puzzle.addClue(a14);
    var a17 =
        LettersClue(name: 'A17', length: 2, valueDesc: 'YE+S', solve: solveA17);
    puzzle.addClue(a17);
    var a18 = LettersClue(
        name: 'A18', length: 3, valueDesc: 'S(USSE+D)', solve: solveA18);
    puzzle.addClue(a18);
    var a20 = LettersClue(
        name: 'A20', length: 2, valueDesc: 'TE+(D/D)Y', solve: solveA20);
    puzzle.addClue(a20);
    var a21 = LettersClue(
        name: 'A21', length: 2, valueDesc: '(PEPP/E+R)E+D', solve: solveA21);
    puzzle.addClue(a21);

    var d1 = LettersClue(
        name: 'D1', length: 3, valueDesc: 'Y(E+(A+S)T-S)', solve: solveD1);
    puzzle.addClue(d1);
    var d2 = LettersClue(
        name: 'D2', length: 3, valueDesc: 'SEES-(P+E+A+R)S', solve: solveD2);
    puzzle.addClue(d2);
    var d3 =
        LettersClue(name: 'D3', length: 2, valueDesc: 'PRY', solve: solveD3);
    puzzle.addClue(d3);
    var d4 = LettersClue(
        name: 'D4', length: 4, valueDesc: 'YAYA+D+A+D-A+S', solve: solveD4);
    puzzle.addClue(d4);
    var d5 = LettersClue(
        name: 'D5', length: 3, valueDesc: 'PR+Y+EYE', solve: solveD5);
    puzzle.addClue(d5);
    var d6 = LettersClue(
        name: 'D6', length: 3, valueDesc: 'DAYS-(T+A)U', solve: solveD6);
    puzzle.addClue(d6);
    var d10 = LettersClue(
        name: 'D10', length: 4, valueDesc: 'YESTE-R(D+A-Y)-S', solve: solveD10);
    puzzle.addClue(d10);
    var d12 = LettersClue(
        name: 'D12', length: 3, valueDesc: 'EYE-SPY+PUD', solve: solveD12);
    puzzle.addClue(d12);
    var d13 =
        LettersClue(name: 'D13', length: 3, valueDesc: 'ERR', solve: solveD13);
    puzzle.addClue(d13);
    var d15 = LettersClue(
        name: 'D15', length: 3, valueDesc: 'RAT+ES', solve: solveD15);
    puzzle.addClue(d15);
    var d16 = LettersClue(
        name: 'D16', length: 3, valueDesc: 'DREY-TU+P', solve: solveD16);
    puzzle.addClue(d16);
    var d19 =
        LettersClue(name: 'D19', length: 2, valueDesc: 'RAP', solve: solveD19);
    puzzle.addClue(d19);

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
      puzzle.letters[letter] = Letter(letter);
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

  bool solveClue(Clue inputClue) {
    var clue = inputClue as LettersClue;
    // If clue solved already then skip it
    if (clue.values != null && clue.values!.length == 1) return false;

    var updated = false;
    if (clue.initialise()) updated = true;

    if (clue.solve != null) {
      var possibleValue = <int>{};
      var possibleLetters = <String, Set<int>>{};
      for (var letter in clue.letterReferences) {
        possibleLetters[letter] = <int>{};
      }
      if (clue.solve!(clue, possibleValue, possibleLetters)) updated = true;
      // If no Values returned then Solve function could not solve
      if (possibleValue.isNotEmpty) {
        if (clue.updateValues(possibleValue)) updated = true;
        if (clue.finalise()) updated = true;
        for (var letter in clue.letterReferences) {
          if (updateLetters(letter, possibleLetters[letter]!)) updated = true;
        }
      }
    }

    if (Crossnumber.traceSolve) {
      print("solve: $clue");
      var text = '';
      for (var letter in clue.letterReferences) {
        text = text +
            "$letter=${puzzle.letters[letter]!.values.toShortString()}, ";
      }
      print(text);
    }
    return updated;
  }

  bool updateLetters(String letter, Set<int> possibleDigits) {
    var updatedLetters = puzzle.updateLetters(letter, possibleDigits);
    // Schedule referencing clues for update
    for (var clue in puzzle.clues.values) {
      if (clue.letterReferences
          .any((element) => updatedLetters.contains(element))) {
        addToUpdateQueue(clue);
      }
    }
    return updatedLetters.length > 0;
  }

  bool solveA1(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var r in puzzle.letters['R']!.values) {
      for (var a
          in puzzle.letters['A']!.values.where((element) => element != r)) {
        for (var p in puzzle.letters['P']!.values
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

  bool solveA4(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var d in puzzle.letters['D']!.values) {
      for (var u
          in puzzle.letters['U']!.values.where((element) => element != d)) {
        for (var e in puzzle.letters['E']!.values
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

  bool solveA7(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var p in puzzle.letters['P']!.values) {
      for (var e
          in puzzle.letters['E']!.values.where((element) => element != p)) {
        for (var r in puzzle.letters['R']!.values
            .where((element) => element != p && element != e)) {
          for (var s in puzzle.letters['S']!.values.where(
              (element) => element != p && element != e && element != r)) {
            for (var y in puzzle.letters['Y']!.values.where((element) =>
                element != p && element != e && element != r && element != s)) {
              var mul = (e - y + e);
              var div = (mul ~/ s);
              if (mul != div * s) {
                var notInteger = true;
              } else {
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

  bool solveA8(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var p in puzzle.letters['P']!.values) {
      for (var u
          in puzzle.letters['U']!.values.where((element) => element != p)) {
        for (var a in puzzle.letters['A']!.values
            .where((element) => element != p && element != u)) {
          for (var s in puzzle.letters['S']!.values.where(
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

  bool solveA9(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    for (var product in cartesian([
      puzzle.letters['S']!.values.toList(),
      puzzle.letters['T']!.values.toList(),
      puzzle.letters['R']!.values.toList(),
      puzzle.letters['A']!.values.toList(),
      puzzle.letters['Y']!.values.toList(),
      puzzle.letters['E']!.values.toList(),
      puzzle.letters['D']!.values.toList(),
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

  void solveExpression(
      LettersClue clue,
      Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters,
      int expression(List<int> letters)) {
    var letterValues = <List<int>>[];
    for (var letter in clue.letterReferences) {
      letterValues.add(puzzle.letters[letter]!.values.toList());
    }
    for (var product in cartesian(letterValues)) {
      var value = expression(product);
      if (value >= 10.pow(clue.length - 1) && value < 10.pow(clue.length)) {
        possibleValue.add(value);
        var index = 0;
        for (var letter in clue.letterReferences) {
          possibleLetters[letter]!.add(product[index++]);
        }
      }
    }
  }

  bool solveA11(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var a = letters[index++];
      var p = letters[index++];
      var s = letters[index++];
      return a * s * p;
    });
    return updated;
  }

  bool solveA12(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var p = letters[index++];
      var u = letters[index++];
      var y = letters[index++];
      return p * u * p * p * y;
    });
    return updated;
  }

  bool solveA14(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
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

  bool solveA17(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var e = letters[index++];
      var s = letters[index++];
      var y = letters[index++];
      return y * e + s;
    });
    return updated;
  }

  bool solveA18(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var d = letters[index++];
      var e = letters[index++];
      var s = letters[index++];
      var u = letters[index++];
      return s * (u * s * s * e + d);
    });
    return updated;
  }

  bool solveA20(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var d = letters[index++];
      var e = letters[index++];
      var t = letters[index++];
      var y = letters[index++];
      return t * e + (d ~/ d) * y;
    });
    return updated;
  }

  bool solveA21(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
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

  bool solveD1(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
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

  bool solveD2(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
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

  bool solveD3(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var p = letters[index++];
      var r = letters[index++];
      var y = letters[index++];
      return p * r * y;
    });
    return updated;
  }

  bool solveD4(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var a = letters[index++];
      var d = letters[index++];
      var s = letters[index++];
      var y = letters[index++];
      return y * a * y * a + d + a + d - a + s;
    });
    return updated;
  }

  bool solveD5(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var e = letters[index++];
      var p = letters[index++];
      var r = letters[index++];
      var y = letters[index++];
      return p * r + y + e * y * e;
    });
    return updated;
  }

  bool solveD6(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
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

  bool solveD10(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
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

  bool solveD12(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
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

  bool solveD13(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var e = letters[index++];
      var r = letters[index++];
      return e * r * r;
    });
    return updated;
  }

  bool solveD15(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
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

  bool solveD16(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
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

  bool solveD19(LettersClue clue, Set<int> possibleValue,
      Map<String, Set<int>> possibleLetters) {
    var updated = false;
    solveExpression(clue, possibleValue, possibleLetters, (letters) {
      var index = 0;
      var a = letters[index++];
      var p = letters[index++];
      var r = letters[index++];
      return r * a * p;
    });
    return updated;
  }
}
