import '../expression.dart';
import '../monadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class TwoPrimesVariable extends Variable {
  TwoPrimesVariable(super.letter) {
    values = {3, 11, 17, 29, 41, 47, 53, 57, 59, 71, 83, 89, 97};
  }
  String get letter => name;
}

class TwoPrimesPuzzle
    extends VariablePuzzle<TwoPrimesClue, TwoPrimesEntry, TwoPrimesVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  TwoPrimesPuzzle() : super(null);
  TwoPrimesPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString);

  Iterable<int> variablevalues(dynamic value) sync* {
    // Return value and 100-value
    yield value as int;
    yield 100 - value;
    return;
  }

  @override
  void initVariablePuzzle(List<int>? possibleValues,
      {bool variableListInitialized = false}) {
    super.initVariablePuzzle(possibleValues);
    final puzzleMonadics = [
      Monadic('variablevalue', variablevalues, Iterable<int>,
          order: NodeOrder.UNKNOWN),
    ];
    Scanner.addMonadics(puzzleMonadics);
  }
}
