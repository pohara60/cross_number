import '../expression.dart';
import '../monadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class TwoPrimesVariable extends Variable {
  TwoPrimesVariable(letter) : super(letter) {
    this.values = Set.from([3, 11, 17, 29, 41, 47, 53, 57, 59, 71, 83, 89, 97]);
  }
  String get letter => this.name;
}

class TwoPrimesPuzzle
    extends VariablePuzzle<TwoPrimesClue, TwoPrimesEntry, TwoPrimesVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  TwoPrimesPuzzle() : super(null);
  TwoPrimesPuzzle.grid(List<String> gridString) : super.grid(null, gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  Iterable<int> variablevalues(int value) sync* {
    // Return value and 100-value
    yield value;
    yield 100 - value;
    return;
  }

  @override
  void initVariablePuzzle(List<int>? possibleValues) {
    super.initVariablePuzzle(possibleValues);
    final puzzleMonadics = [
      Monadic('variablevalue', variablevalues, Iterable<int>),
    ];
    Scanner.addMonadics(puzzleMonadics);
  }
}
