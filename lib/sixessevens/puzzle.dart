import '../expression.dart';
import '../monadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class SixesSevensVariable extends Variable {
  SixesSevensVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class SixesSevensPuzzle extends VariablePuzzle<SixesSevensClue,
    SixesSevensEntry, SixesSevensVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  SixesSevensPuzzle({String name = ''}) : super(null, name: name);
  SixesSevensPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  void initVariablePuzzle(List<int>? possibleValues,
      {bool variableListInitialized = false}) {
    final puzzleMonadics = [
      Monadic('jumbledigits6and7', jumbleDigits6And7, Iterable<int>,
          order: NodeOrder.UNKNOWN),
    ];
    Scanner.addMonadics(puzzleMonadics);
    super.initVariablePuzzle(possibleValues);
  }
}

Iterable<int> jumbleDigits6And7(dynamic value) sync* {
  var valueStr = (value as int).toString();
  if (valueStr.contains('6') || valueStr.contains('7')) {
    yield* jumble(value);
  }
  yield value;
}
