import '../expression.dart';
import '../polyadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class TwoByTwoVariable extends Variable {
  TwoByTwoVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class TwoByTwoPuzzle
    extends VariablePuzzle<TwoByTwoClue, TwoByTwoEntry, TwoByTwoVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  TwoByTwoPuzzle({String name = ''}) : super(null, name: name);
  TwoByTwoPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  void initVariablePuzzle(List<int>? possibleValues) {
    final puzzlePolyadics = [
      Polyadic('last3digits', last3DigitsFunc, Iterable<int>,
          order: NodeOrder.UNKNOWN),
    ];
    Scanner.addPolyadics(puzzlePolyadics);
    super.initVariablePuzzle(possibleValues);
  }
}

int last3DigitsFunc(List<dynamic> args) {
  assert(args.length == 2);
  int value1 = args[0];
  int value2 = args[1];
  int value = (value1 * value2) % 1000;
  return value;
}
