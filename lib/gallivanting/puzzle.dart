import '../expression.dart';
import '../monadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class GallivantingVariable extends Variable {
  GallivantingVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class GallivantingPuzzle extends VariablePuzzle<GallivantingClue,
    GallivantingEntry, GallivantingVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  GallivantingPuzzle({String name = ''}) : super(null, name: name);
  GallivantingPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  void initVariablePuzzle(List<int>? possibleValues,
      {bool variableListInitialized = false}) {
    final puzzleMonadics = [
      Monadic(
        'alldigits1to6',
        allDigits1to6,
        bool,
      ),
      Monadic(
        'firsttwodigitssumtothird',
        firstTwoDigitsSumToThird,
        bool,
      ),
    ];
    Scanner.addMonadics(puzzleMonadics);
    super.initVariablePuzzle(possibleValues);
  }

  @override
  bool checkSolution() {
    if (!super.checkSolution()) return false;
    if (!checkFrequencyAllDigits()) return false;
    return true;
  }

  bool checkFrequencyAllDigits() {
    var digits = getAllDigits();
    if (digits == null) return false;
    var set = Set.from(digits);
    for (var digit in set) {
      var count = digits.where((element) => element == digit).length;
      if (count != 6) return false;
    }
    return true;
  }
}

bool allDigits1to6(dynamic value) {
  var digits = (value as int).toString().split('').map(int.parse).toSet();
  return digits.length == 6 &&
      digits.contains(1) &&
      digits.contains(2) &&
      digits.contains(3) &&
      digits.contains(4) &&
      digits.contains(5) &&
      digits.contains(6);
}

bool firstTwoDigitsSumToThird(dynamic value) {
  var strValue = (value as int).toString();
  if (strValue.length < 3) return false;
  var firstTwoDigits = int.parse(strValue[0]) + int.parse(strValue[1]);
  var thirdDigit = int.parse(strValue[2]);
  return firstTwoDigits == thirdDigit;
}
