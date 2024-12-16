import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class ExcusesVariable extends Variable {
  ExcusesVariable(super.letter) {
    values = Set.from(List.generate(26, (index) => index + 1));
  }
  String get letter => name;
}

class ExcusesPuzzle
    extends VariablePuzzle<ExcusesClue, ExcusesEntry, ExcusesVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  ExcusesPuzzle({String name = ''}) : super(null, name: name);
  ExcusesPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}
