import '../primecuts/clue.dart';
import '../puzzle.dart';
import '../clue.dart';
import '../variable.dart';

import '../generators.dart';

class PrimeVariable extends Variable {
  PrimeVariable(super.prime) {
    values = Set.from(twoDigitPrimes);
  }
  String get prime => name;
}

class PrimeCutsPuzzle
    extends VariablePuzzle<PrimeCutsClue, PrimeCutsEntry, PrimeVariable> {
  // Puzzle has Prime variables that are restricted to two digit primes
  PrimeCutsPuzzle() : super(List.from(twoDigitPrimes));

  Map<String, Variable> get primes => variableList.variables;
  List<int> get remainingPrimes => variableList.restrictedValues!;
  Set<Variable> updatePrimes(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  @override
  void addEntry(Clue entry) {
    var clue = entry as PrimeCutsEntry;
    super.addEntry(entry);
    var prime = PrimeVariable(clue.prime);
    primes[clue.prime] = prime;
    addAnyVariable(prime);
  }
}
