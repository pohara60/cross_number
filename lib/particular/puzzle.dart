import './clue.dart';
import '../puzzle.dart';
import '../variable.dart';

class ParticularVariable extends Variable {
  ParticularVariable(letter) : super(letter) {
    this.values = Set.from(List.generate(99, (index) => index + 1));
  }
  String get letter => this.name;
}

class ParticularPuzzle extends VariablePuzzle<ParticularClue, ParticularEntry,
    ParticularVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  late final VariableList variableList;
  ParticularPuzzle() : super(List.generate(99, (index) => index + 1));
  ParticularPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(
            List.generate(99, (index) => index + 1), gridString);

  Map<String, Variable> get letters => variableList.variables;
  List<int> get remainingDigits => variableList.remainingValues!;
  Set<String> updateLetters(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);
}
