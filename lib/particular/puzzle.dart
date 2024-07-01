import './clue.dart';
import '../puzzle.dart';
import '../variable.dart';

class ParticularVariable extends Variable {
  ParticularVariable(super.letter) {
    values = Set.from(List.generate(99, (index) => index + 1));
  }
  String get letter => name;
}

class ParticularPuzzle extends VariablePuzzle<ParticularClue, ParticularEntry,
    ParticularVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  ParticularPuzzle() : super(List.generate(99, (index) => index + 1));
  ParticularPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(
            List.generate(99, (index) => index + 1), gridString);
}
