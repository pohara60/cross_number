import '../puzzle.dart';
import '../variable.dart';
import '../generators.dart';

import './clue.dart';

class PrimeCutsVariable extends ExpressionVariable {
  PrimeCutsVariable(String prime, String expression, {SolveFunction? solve})
      : super(prime, expression, solve: solve) {
    this.values = Set.from(twoDigitPrimes);
  }
  String get prime => this.name;
}

class PrimeCuts2Puzzle
    extends VariablePuzzle<PrimeCutsClue, PrimeCutsEntry, PrimeCutsVariable> {
  // Puzzle has Prime variables that are restricted to two digit primes
  PrimeCuts2Puzzle() : super(List.from(twoDigitPrimes));
  PrimeCuts2Puzzle.fromGridString(List<String> gridString)
      : super.fromGridString(List.from(twoDigitPrimes), gridString);

  Map<String, Variable> get primes => variableList.variables;
  List<int> get remainingPrimes => variableList.restrictedValues!;
  Set<Variable> updatePrimes(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  @override
  postProcessing([bool iteration = true, int Function(Puzzle)? callback]) {
    if (iteration) {
      print("NO ITERATION-----------------------------");
    }
  }
}
